unit SistemaFinanceiro.Controller.BaixaContaPagar;

interface

uses
  uEnumsUtils,
  SistemaFinanceiro.Model.Entidades.CP,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  SistemaFinanceiro.Model.Entidades.PgtoBxCp,
  System.SysUtils,
  SistemaFinanceiro.View.BaixarCP.FrPgto,
  SistemaFinanceiro.View.BaixarCP,
  System.UITypes,
  System.Generics.Collections;

type
  TControllerBaixaCp = class
  private
    FCp: TModelCP;
    FDetalhesCp: TModelCpDetalhe;
    FIdCp: Integer;
    FListaPgtos: TObjectList<TModelPgtoBxCp>;

  const
    TOLERANCIAVALORCP: Double = 0.01;

    function ExisteConta: Boolean;

    procedure BaixarCP;
    procedure GerarParcial;
    procedure GravarDetalhesCp;
    procedure GravarPgtosCp;
    procedure GravarLctoCaixa;

  published

  public
    destructor Destroy; override;

    class procedure CancelarBaixa(const pIdCp: Integer);
    class function Baixar(const pIdCp: Integer; pDetalhesCp: TModelCpDetalhe;
      pListaPgtos: TObjectList<TModelPgtoBxCp>): Boolean;
  end;

implementation

{ TBaixarContaPagar }

uses
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.BaixaCp,
  SistemaFinanceiro.Exceptions.ContasPagar,
  SistemaFinanceiro.Exceptions.ContasPagarDetalhe,
  SistemaFinanceiro.Exceptions.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.PgtoBaixaCp,
  uTransactionScope;

class function TControllerBaixaCp.Baixar(const pIdCp: Integer; pDetalhesCp: TModelCpDetalhe;
  pListaPgtos: TObjectList<TModelPgtoBxCp>): Boolean;
var
  lBaixa: TControllerBaixaCp;
  lTransaction: TTransactionScope;
begin

  Result := False;

  lBaixa := TControllerBaixaCp.Create;
  lTransaction := TTransactionScope.Create;
  try
    try

      lBaixa.FIdCp := pIdCp;
      if not(lBaixa.ExisteConta) then
        Exit;

      if not(Assigned(pDetalhesCp)) then
        Exit;

      lBaixa.FDetalhesCp := pDetalhesCp;

      if not(Assigned(pListaPgtos)) then
        Exit;
      lBaixa.FListaPgtos := pListaPgtos;

      lBaixa.BaixarCP;
      lBaixa.GravarDetalhesCp;
      lBaixa.GravarPgtosCp;
      lBaixa.GravarLctoCaixa;

      lTransaction.Commit;
      Result := True;

    except
      on E: Exception do
      begin
        lTransaction.Rollback;
        raise;
      end;
    end;
  finally
    lBaixa.Free;
    lTransaction.Free;
  end;

end;

procedure TControllerBaixaCp.BaixarCP;
begin
  FCp.ValorAbatido := (FCp.ValorAbatido + FDetalhesCp.Valor);
  FCp.Status := 'P';
  FCp.DataPagamento := FDetalhesCp.Data;

  FCp.UpdateByPK;

  if ((Abs((FCp.ValorParcela - FDetalhesCp.Valor) - FDetalhesCp.ValorDesc)) > TOLERANCIAVALORCP) then
    GerarParcial;

end;

class
  procedure TControllerBaixaCp.CancelarBaixa(const pIdCp: Integer);
var
  lConta: TModelCP;
  lDetalhes: TModelCpDetalhe;
  lPagamentos: TModelPgtoBxCp;
  lLancamentoCaixa: TModelLancamentoCaixa;
  lTransaction: TTransactionScope;
begin

  lTransaction := TTransactionScope.Create;
  lConta := TModelCP.Create;
  lDetalhes := TModelCpDetalhe.Create;
  lPagamentos := TModelPgtoBxCp.Create;
  lLancamentoCaixa := TModelLancamentoCaixa.Create;
  try

    // Carrega os dados da conta
    lConta.ID := pIdCp;
    if not(lConta.LoadObjectByPK) then
      raise ECPagarNaoExiste.Create(Format('Não foi possível carregar os dados da conta nº %d', [lConta.ID]));

    // Carrega os dados do lançamento do caixa
    if not(lLancamentoCaixa.ExistePorOrigem(lConta.ID, tlCp, True)) then
      raise ELancCaixaNaoExiste.Create
        (Format('Não foi possível carregar os dados do lançamento do caixa da conta nº %d', [lConta.ID]));

    // Carrega os dados dos detalhes da baixa
    if not(lDetalhes.ExistePorCp(lConta.ID, True)) then
      raise ECpDetalheNaoExiste.Create
        (Format('Não foi possível carregar os dados do detalhe do pagamento da conta nº %d', [lConta.ID]));

    // Verifica se existe ao menos um pagamento
    if not(lPagamentos.ExistePorCp(lConta.ID, True)) then
      raise EPgtoCpNaoExiste.Create(Format('Não foi possível carregar os dados do pagamento da conta nº %d',
        [lConta.ID]));

    // Exclui o lançamento no caixa
    if not(lLancamentoCaixa.DeleteByPk) then
      raise ELancCaixaExcluir.Create(Format('Não foi possível excluir o lançamento do caixa da conta nº %d',
        [lConta.ID]));

    // Exclui os detalhes
    if not(lDetalhes.DeleteByPk) then
      raise ECpDetalheExcluir.Create(Format('Não foi possível excluir os detalhes do pagamento da conta nº %d',
        [lConta.ID]));

    // Exclui os pagamentos
    if not(lPagamentos.DeleteBySQLText(' ID_CP = ' + IntToStr(lConta.ID))) then
      raise EPgtoCpExcluir.Create(Format('Não foi possível excluir os pagamentos da conta nº %d', [lConta.ID]));

    // Atualiza a conta para não paga
    lConta.ValorAbatido := 0;
    lConta.DataPagamento := 0;
    lConta.Status := 'A';

    if not(lConta.UpdateByPK) then
      raise ECpagarAlterar.Create(Format('Não foi possível atualizar o status da conta  nº %d para Aberta',
        [lConta.ID]));

    lTransaction.Commit;

  finally
    lConta.Free;
    lDetalhes.Free;
    lPagamentos.Free;
    lLancamentoCaixa.Free;
    lTransaction.Free;
  end;

end;

destructor TControllerBaixaCp.Destroy;
begin
  if Assigned(FCp) then
    FCp.Free;
  inherited;
end;

function TControllerBaixaCp.ExisteConta: Boolean;
begin
  Result := False;

  FCp := TModelCP.Create;
  FCp.ID := FIdCp;

  if not(FCp.LoadObjectByPK) then
    raise ECPagarNaoExiste.Create(Format('Não foi possível carregar os dados da conta nº %d', [FCp.ID]));

  Result := True;
end;

procedure TControllerBaixaCp.GerarParcial;
var
  lParcial: TModelCP;
begin
  lParcial := TModelCP.Create;
  try
    try

      lParcial.GeraCodigo;
      lParcial.DataCadastro := Now;
      lParcial.Status := 'A';
      lParcial.ValorAbatido := 0;

      if ((FCp.Doc.Trim.IsEmpty) or (FCp.Parcial)) then
      begin
        lParcial.Doc := FCp.Doc;
      end
      else
      begin
        lParcial.Doc := Copy(Format('%s-P', [FCp.Doc]), 1, 20);
      end;

      lParcial.Desc := Format('Parcial - Restante da Conta ID Nº %d - Doc Nº %s', [FCp.ID, FCp.Doc]);
      lParcial.ValorCompra := FCp.ValorCompra;
      lParcial.DataCompra := FCp.DataCompra;
      lParcial.Parcela := FCp.Parcela;
      lParcial.ValorParcela := ((FCp.ValorParcela - FDetalhesCp.Valor) - FDetalhesCp.ValorDesc);
      lParcial.DataVencimento := FCp.DataVencimento;
      lParcial.Parcial := True;
      lParcial.CpOrigem := FCp.ID;
      lParcial.IdFornecedor := FCp.IdFornecedor;
      lParcial.FatCartao := FCp.FatCartao;
      lParcial.NumTotalParcelas := FCp.NumTotalParcelas;
      lParcial.IdGrupoParcelas := FCp.IdGrupoParcelas;

      if (lParcial.FatCartao) then
      begin
        lParcial.IdFatCartao := FCp.IdFatCartao;
      end;

      lParcial.Insert;

    except
      on E: Exception do
      begin
        raise ECPagarGerarParcial.Create;
      end;
    end;
  finally
    lParcial.Free;
  end;
end;

procedure TControllerBaixaCp.GravarDetalhesCp;
begin
  try
    FDetalhesCp.IdCP := FCp.ID;
    FDetalhesCp.Insert;
  except
    on E: Exception do
    begin
      raise ECpDetalheGravar.Create(E.Message);
    end;
  end;
end;

procedure TControllerBaixaCp.GravarLctoCaixa;
var
  lCaixa: TModelLancamentoCaixa;
begin
  lCaixa := TModelLancamentoCaixa.Create;
  try
    try

      lCaixa.GeraCodigo;
      lCaixa.NumDoc := FCp.Doc;
      lCaixa.Desc := Format('Baixa Conta ID Nº %d Pagar - Nº Documento: %s - Parcela: %d',
        [FCp.ID, FCp.Doc, FCp.Parcela]);
      lCaixa.Valor := FDetalhesCp.Valor;
      lCaixa.Tipo := 'D';
      lCaixa.DataCadastro := FDetalhesCp.Data;
      lCaixa.Origem := 'CP';
      lCaixa.IdOrigem := FCp.ID;

      lCaixa.Insert;

    except
      on E: Exception do
      begin
        raise ELancCaixaGravar.Create(E.Message);
      end;
    end;
  finally
    lCaixa.Free;
  end;
end;

procedure TControllerBaixaCp.GravarPgtosCp;
var
  lPgto: TModelPgtoBxCp;
begin

  try

    for lPgto in FListaPgtos do
    begin
      lPgto.IdCP := FIdCp;
      lPgto.Insert;
    end;

  except
    on E: Exception do
    begin
      raise EPgtoCpGravar.Create(E.Message);
    end;
  end;

end;

end.
