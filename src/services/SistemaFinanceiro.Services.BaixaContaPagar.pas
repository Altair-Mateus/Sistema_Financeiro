unit SistemaFinanceiro.Services.BaixaContaPagar;

interface

uses
  uEnumsUtils,
  SistemaFinanceiro.Model.Entidades.CP,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  System.SysUtils,
  SistemaFinanceiro.View.BaixarCP.FrPgto,
  SistemaFinanceiro.View.BaixarCP,
  System.UITypes;

type
  TBaixarContaPagar = class
  private
    FCp: TModelCP;
    FDetalhesCp: TModelCpDetalhe;
    FIdCp: Integer;

    function ExisteConta: Boolean;
    function ObterDetalhesBaixa: Boolean;
    function ObterPgtosBaixa: Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    property IdCp: Integer read FIdCp write FIdCp;

    class procedure CancelarBaixa(const pIdCp: Integer);
    class function Baixar(const pIdCp: Integer): Boolean;
  end;

implementation

{ TBaixarContaPagar }

uses

  SistemaFinanceiro.Model.Entidades.PgtoBxCp,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.BaixaCp,
  SistemaFinanceiro.Exceptions.ContasPagar,
  SistemaFinanceiro.Exceptions.ContasPagarDetalhe,
  SistemaFinanceiro.Exceptions.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.PgtoBaixaCp,
  uTransactionScope;

class function TBaixarContaPagar.Baixar(const pIdCp: Integer): Boolean;
var
  lBaixa: TBaixarContaPagar;
  lTransaction: TTransactionScope;
begin

  Result := False;

  lBaixa := TBaixarContaPagar.Create;
  lTransaction := TTransactionScope.Create;
  try
    try

      lBaixa.IdCp := pIdCp;

      if not(lBaixa.ExisteConta) then
        Exit;

      if not(lBaixa.ObterDetalhesBaixa) then
        Exit;

      lTransaction.Commit;
      Result := True;

    except
      on E: Exception do
      begin
        raise;
      end;
    end;
  finally
    lBaixa.Free;
    lTransaction.Free;
  end;

end;

class
  procedure TBaixarContaPagar.CancelarBaixa(const pIdCp: Integer);
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
      raise ECPagarNaoExiste.Create(Format('N�o foi poss�vel carregar os dados da conta n� %d', [lConta.ID]));

    // Carrega os dados do lan�amento do caixa
    if not(lLancamentoCaixa.ExistePorOrigem(lConta.ID, tlCp, True)) then
      raise ELancCaixaNaoExiste.Create
        (Format('N�o foi poss�vel carregar os dados do lan�amento do caixa da conta n� %d', [lConta.ID]));

    // Carrega os dados dos detalhes da baixa
    if not(lDetalhes.ExistePorCp(lConta.ID, True)) then
      raise ECpDetalheNaoExiste.Create
        (Format('N�o foi poss�vel carregar os dados do detalhe do pagamento da conta n� %d', [lConta.ID]));

    // Verifica se existe ao menos um pagamento
    if not(lPagamentos.ExistePorCp(lConta.ID, True)) then
      raise EPgtoCpNaoExiste.Create(Format('N�o foi poss�vel carregar os dados do pagamento da conta n� %d',
        [lConta.ID]));

    // Exclui o lan�amento no caixa
    if not(lLancamentoCaixa.DeleteByPk) then
      raise ELancCaixaExcluir.Create(Format('N�o foi poss�vel excluir o lan�amento do caixa da conta n� %d',
        [lConta.ID]));

    // Exclui os detalhes
    if not(lDetalhes.DeleteByPk) then
      raise ECpDetalheExcluir.Create(Format('N�o foi poss�vel excluir os detalhes do pagamento da conta n� %d',
        [lConta.ID]));

    // Exclui os pagamentos
    if not(lPagamentos.DeleteBySQLText(' ID_CP = ' + IntToStr(lConta.ID))) then
      raise EPgtoCpExcluir.Create(Format('N�o foi poss�vel excluir os pagamentos da conta n� %d', [lConta.ID]));

    // Atualiza a conta para n�o paga
    lConta.ValorAbatido := 0;
    lConta.DataPagamento := 0;
    lConta.Status := 'A';

    if not(lConta.UpdateByPK) then
      raise ECpagarAlterar.Create(Format('N�o foi poss�vel atualizar o status da conta  n� %d para Aberta',
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

constructor TBaixarContaPagar.Create;
begin

end;

destructor TBaixarContaPagar.Destroy;
begin

  inherited;
end;

function TBaixarContaPagar.ExisteConta: Boolean;
begin
  Result := False;

  FCp := TModelCP.Create;
  FCp.ID := FIdCp;

  if not(FCp.LoadObjectByPK) then
    raise ECPagarNaoExiste.Create(Format('N�o foi poss�vel carregar os dados da conta n� %d', [FCp.ID]));

  Result := True;
end;

function TBaixarContaPagar.ObterDetalhesBaixa: Boolean;
var
  lFormDet: TfrmBaixarCP;
begin
  Result := False;

  lFormDet := TfrmBaixarCP.Create(nil);
  try
    try

      lFormDet.CP := FCp;
      lFormDet.ShowModal;

      if (lFormDet.ModalResult = mrOk) then
      begin
        FDetalhesCp := lFormDet.ObterDetalhes;

        if not Assigned(FDetalhesCp) then
          Exit;

        Result := True;
      end;

    except
      on E: Exception do
      begin
        raise ECpDetalheObter.Create;
      end;
    end;
  finally
    lFormDet.Free;
  end;

end;

function TBaixarContaPagar.ObterPgtosBaixa: Boolean;
begin
  Result := False;
end;

end.
