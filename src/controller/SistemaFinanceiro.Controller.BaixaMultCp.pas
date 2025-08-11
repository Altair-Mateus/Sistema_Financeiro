unit SistemaFinanceiro.Controller.BaixaMultCp;

interface

uses
  System.Classes,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  SistemaFinanceiro.Model.Entidades.PgtoBxCp,
  System.Generics.Collections,
  SistemaFinanceiro.Model.Entidades.CP,
  System.SysUtils;

type

  TLogsErroBaixaMultCp = procedure(const Logs: TStringList) of object;

  TControllerBaixaMultCp = class
  private
    FListaIdCp: TList<Integer>;
    FDetalhesGeraisCp: TModelCpDetalhe;
    FListaPgtos: TObjectList<TModelPgtoBxCp>;
    FValorTotalCps: Double;
    FLogsErros: TLogsErroBaixaMultCp;
    FListaLogs: TStringList;

    function DefineValorPago(const pValorCp, pValorDesconto: Double): Double;
    function DefineValorDesconto(const pValorCp: Double): Double;

    procedure BaixarCP(const pCp: TModelCP; const pDetalhes: TModelCpDetalhe);
    procedure GerarParcial(const pCp: TModelCP; const pDetalhes: TModelCpDetalhe);
    procedure GravarDetalhesCp(const pIdCp: Integer; const pValorParcelaCp: Double; const pDetalhes: TModelCpDetalhe);
    procedure GravarPgtosCp(const pIdCp: Integer; const pValorPago: Double);
    procedure GravarLctoCaixa(const pCp: TModelCP; const pDetalhes: TModelCpDetalhe);

    function BaixaMultipla: Boolean;

    procedure RetornarLogs;
    procedure RegistrarLogErro(const pLog: String);

  const
    TOLERANCIAVALORCP: Double = 0.01;

  public
    constructor Create;
    destructor Destroy; override;
    property LogsErros: TLogsErroBaixaMultCp read FLogsErros write FLogsErros;

    function Baixar(const pListaIdCp: TList<Integer>; const pValorTotalCps: Double; const pDetalhesCp: TModelCpDetalhe;
      const pListaPgtos: TObjectList<TModelPgtoBxCp>): Boolean;
  end;

implementation

uses
  uTransactionScope,
  SistemaFinanceiro.Exceptions.ContasPagar,
  SistemaFinanceiro.Exceptions.ContasPagarDetalhe,
  SistemaFinanceiro.Exceptions.PgtoBaixaCp,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.LancamentoCaixa;

{ TControllerBaixaMultCp }

function TControllerBaixaMultCp.BaixaMultipla: Boolean;
var
  lId: Integer;
  lCp: TModelCP;
  lTransaction: TTransactionScope;
  lDetalhesCp: TModelCpDetalhe;
begin
  Result := False;

  for lId in FListaIdCp do
  begin

    lTransaction := TTransactionScope.Create;
    lDetalhesCp := TModelCpDetalhe.Create;
    lCp := TModelCP.Create;
    try
      try

        lCp.ID := lId;
        if not(lCp.LoadObjectByPK) then
        begin
          RegistrarLogErro(Format('Falha ao buscar/carregar conta ID nº %d', [lId]));
          Continue;
        end;

        GravarDetalhesCp(lId, lCp.ValorParcela, lDetalhesCp);
        BaixarCP(lCp, lDetalhesCp);
        GravarPgtosCp(lId, lDetalhesCp.Valor);
        GravarLctoCaixa(lCp, lDetalhesCp);

        lTransaction.Commit;
      except
        on E: Exception do
        begin
          lTransaction.Rollback;
          RegistrarLogErro(Format('Falha ao baixar conta ID nº %d | Valor %f | Data Vencimento: %s | Erro: %s',
            [lCp.ID, lCp.ValorParcela, DateToStr(lCp.DataVencimento), E.Message]));
        end;
      end;
    finally
      lCp.Free;
      lDetalhesCp.Free;
      lTransaction.Free;
    end;

  end;

  // Retorna True somente se não teve nenhum log de erro
  Result := (FListaLogs.Count <= 0);

end;

function TControllerBaixaMultCp.Baixar(const pListaIdCp: TList<Integer>; const pValorTotalCps: Double;
  const pDetalhesCp: TModelCpDetalhe; const pListaPgtos: TObjectList<TModelPgtoBxCp>): Boolean;
begin

  Result := False;

  try

    if not(pListaIdCp.Count > 0) then
      Exit;

    FListaIdCp := pListaIdCp;

    if not(Assigned(pDetalhesCp)) then
      Exit;

    FDetalhesGeraisCp := pDetalhesCp;

    if not(Assigned(pListaPgtos)) then
      Exit;
    FListaPgtos := pListaPgtos;

    if (pValorTotalCps > 0) then
      FValorTotalCps := pValorTotalCps;

    Result := BaixaMultipla;

  finally
    RetornarLogs;
  end;

end;

procedure TControllerBaixaMultCp.BaixarCP(const pCp: TModelCP; const pDetalhes: TModelCpDetalhe);
begin
  pCp.ValorAbatido := (pCp.ValorAbatido + pDetalhes.Valor);
  pCp.Status := 'P';
  pCp.DataPagamento := pDetalhes.Data;

  pCp.UpdateByPK;

  if ((Abs((pCp.ValorParcela - pDetalhes.Valor) - pDetalhes.ValorDesc)) > TOLERANCIAVALORCP) then
    GerarParcial(pCp, pDetalhes);
end;

constructor TControllerBaixaMultCp.Create;
begin
  FListaLogs := TStringList.Create;
  FValorTotalCps := 0;
end;

function TControllerBaixaMultCp.DefineValorDesconto(
  const pValorCp: Double): Double;
var
  lPercentual: Double;
  lValorDesc: Double;
begin

  lPercentual := 0;
  lValorDesc := 0;
  Result := 0;

  // Descobre o percentual da conta
  lPercentual := (pValorCp / FValorTotalCps);

  // Descobre o valor do desconto para a conta
  lValorDesc := (lPercentual * FDetalhesGeraisCp.ValorDesc);

  Result := lValorDesc;

end;

function TControllerBaixaMultCp.DefineValorPago(const pValorCp, pValorDesconto: Double): Double;
begin
  if (FDetalhesGeraisCp.Valor - (pValorCp - pValorDesconto)) > 0 then
  begin

    // Se for maior que 0 vai baixar a conta total
    Result := (pValorCp - pValorDesconto);

  end
  else if FDetalhesGeraisCp.Valor > 0 then
  begin

    // Se ainda tiver ValorAbater mas não o suficiente
    // para baicar toda a cp, ira baixar apenas o valor
    // abater e o restante será gerado uma CP Parcial
    Result := FDetalhesGeraisCp.Valor;

  end
  else
  begin

    // Caso ainda tenha alguma CP selecionada porem
    // ValorAbater já está zerado irá baixar a conta
    // e irá gerar uma CP Parcial com o valor total
    Result := 0;

  end;

  // Calcula o restante do valor abater
  FDetalhesGeraisCp.Valor := (FDetalhesGeraisCp.Valor - (pValorCp - pValorDesconto));
end;

destructor TControllerBaixaMultCp.Destroy;
begin
  FListaLogs.Free;
  inherited;
end;

procedure TControllerBaixaMultCp.GerarParcial(const pCp: TModelCP; const pDetalhes: TModelCpDetalhe);
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

      if ((pCp.Doc.Trim.IsEmpty) or (pCp.Parcial)) then
      begin
        lParcial.Doc := pCp.Doc;
      end
      else
      begin
        lParcial.Doc := Copy(Format('%s-P', [pCp.Doc]), 1, 20);
      end;

      lParcial.Desc := Format('Parcial - Restante da Conta ID Nº %d - Doc Nº %s', [pCp.ID, pCp.Doc]);
      lParcial.ValorCompra := pCp.ValorCompra;
      lParcial.DataCompra := pCp.DataCompra;
      lParcial.Parcela := pCp.Parcela;
      lParcial.ValorParcela := ((pCp.ValorParcela - pDetalhes.Valor) - pDetalhes.ValorDesc);
      lParcial.DataVencimento := pCp.DataVencimento;
      lParcial.Parcial := True;
      lParcial.CpOrigem := pCp.ID;
      lParcial.IdFornecedor := pCp.IdFornecedor;
      lParcial.FatCartao := pCp.FatCartao;
      lParcial.NumTotalParcelas := pCp.NumTotalParcelas;
      lParcial.IdGrupoParcelas := pCp.IdGrupoParcelas;

      if (lParcial.FatCartao) then
      begin
        lParcial.IdFatCartao := pCp.IdFatCartao;
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

procedure TControllerBaixaMultCp.GravarDetalhesCp(const pIdCp: Integer; const pValorParcelaCp: Double;
  const pDetalhes: TModelCpDetalhe);
begin
  try
    pDetalhes.GeraCodigo;
    pDetalhes.IdCP := pIdCp;
    pDetalhes.Detalhes := 'CP baixada pela rotina de Baixa Múltipla';
    pDetalhes.Data := FDetalhesGeraisCp.Data;
    pDetalhes.Usuario := FDetalhesGeraisCp.Usuario;
    pDetalhes.ValorDesc := DefineValorDesconto(pValorParcelaCp);
    pDetalhes.Valor := DefineValorPago(pValorParcelaCp, pDetalhes.ValorDesc);
    pDetalhes.Insert;
  except
    on E: Exception do
    begin
      raise ECpDetalheGravar.Create(E.Message);
    end;
  end;

end;

procedure TControllerBaixaMultCp.GravarLctoCaixa(const pCp: TModelCP; const pDetalhes: TModelCpDetalhe);
var
  lCaixa: TModelLancamentoCaixa;
begin
  lCaixa := TModelLancamentoCaixa.Create;
  try
    try

      lCaixa.GeraCodigo;
      lCaixa.NumDoc := pCp.Doc;
      lCaixa.Desc := Format('Baixa Conta ID Nº %d Pagar - Nº Documento: %s - Parcela: %d',
        [pCp.ID, pCp.Doc, pCp.Parcela]);
      lCaixa.Valor := pDetalhes.Valor;
      lCaixa.Tipo := 'D';
      lCaixa.DataCadastro := pDetalhes.Data;
      lCaixa.Origem := 'CP';
      lCaixa.IdOrigem := pCp.ID;

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

procedure TControllerBaixaMultCp.GravarPgtosCp(const pIdCp: Integer; const pValorPago: Double);
var
  lPgto: TModelPgtoBxCp;
  lContador, lUltCod: Integer;
begin

  lContador := 0;
  try

    for lPgto in FListaPgtos do
    begin

      lContador := lContador + 1;
      if (lContador = 1) then
        lPgto.GeraCodigo
      else
        lPgto.GeraCodigo(lUltCod);

      lPgto.NrPgto := lContador;
      lPgto.IdCP := pIdCp;
      lPgto.ValorPago := pValorPago;
      lUltCod := lPgto.ID;

      lPgto.Insert;
    end;

  except
    on E: Exception do
    begin
      raise EPgtoCpGravar.Create(E.Message);
    end;
  end;

end;

procedure TControllerBaixaMultCp.RegistrarLogErro(const pLog: String);
begin
  FListaLogs.Add(pLog.Trim);
end;

procedure TControllerBaixaMultCp.RetornarLogs;
begin
  if Assigned(FLogsErros) then
    FLogsErros(FListaLogs);
end;

end.
