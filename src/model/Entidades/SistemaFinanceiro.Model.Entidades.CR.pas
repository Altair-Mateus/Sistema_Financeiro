unit SistemaFinanceiro.Model.Entidades.CR;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  Vcl.Dialogs,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.Model.Entidades.PgtoBxCr,
  uEnumsUtils;

type

  [TDBTable('CONTAS_RECEBER')]
  TModelCR = class

  private
    FDaoRTTI: TDaoRTTI;
    FDataVenda: TDate;
    FValorParcela: Double;
    FValorVenda: Double;
    FDataVencimento: TDate;
    FDataRecebimento: TDate;
    FID: Integer;
    FValorAbatido: Double;
    FStatus: String;
    FDataCadastro: TDate;
    FDoc: String;
    FDesc: String;
    FParcela: Integer;
    FParcial: String;
    FCrOrigem: Integer;
    FIdCliente: Integer;
    FNumTotalParcelas: Integer;
    FIdGrupoParcelas: Integer;

  public
    [TDBColumn('ID'), TDBIsPrimaryKey]
    property ID: Integer read FID write FID;
    [TDBColumn('NUMERO_DOCUMENTO'), TDBAcceptNull]
    property Doc: String read FDoc write FDoc;
    [TDBColumn('DESCRICAO'), TDBAcceptNull]
    property Desc: String read FDesc write FDesc;
    [TDBColumn('PARCELA')]
    property Parcela: Integer read FParcela write FParcela;
    [TDBColumn('VALOR_PARCELA')]
    property ValorParcela: Double read FValorParcela write FValorParcela;
    [TDBColumn('VALOR_VENDA')]
    property ValorVenda: Double read FValorVenda write FValorVenda;
    [TDBColumn('VALOR_ABATIDO')]
    property ValorAbatido: Double read FValorAbatido write FValorAbatido;
    [TDBColumn('DATA_VENDA')]
    property DataVenda: TDate read FDataVenda write FDataVenda;
    [TDBColumn('DATA_CADASTRO')]
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;
    [TDBColumn('DATA_VENCIMENTO')]
    property DataVencimento: TDate read FDataVencimento write FDataVencimento;
    [TDBColumn('DATA_RECEBIMENTO'), TDBAcceptNull]
    property DataRecebimento: TDate read FDataRecebimento write FDataRecebimento;
    [TDBColumn('STATUS')]
    property Status: String read FStatus write FStatus;
    [TDBColumn('PARCIAL')]
    property Parcial: String read FParcial write FParcial;
    [TDBColumn('CR_ORIGEM'), TDBAcceptNull]
    property CrOrigem: Integer read FCrOrigem write FCrOrigem;
    [TDBColumn('ID_CLIENTE')]
    property IdCliente: Integer read FIdCliente write FIdCliente;
    [TDBColumn('NUM_TOT_PARCELAS'), TDBAcceptNull]
    property NumTotalParcelas: Integer read FNumTotalParcelas write FNumTotalParcelas;
    [TDBColumn('ID_GRUPO_PARCELAS'), TDBAcceptNull]
    property IdGrupoParcelas: Integer read FIdGrupoParcelas write FIdGrupoParcelas;

    constructor Create;
    destructor Destroy; override;

    function Insert: Boolean;
    function UpdateBySQLText(const pWhereClause: string = ''): Boolean;
    function UpdateByPK: Boolean;
    function UpdateByProp: Boolean;
    function DeleteBySQLText(const pWhere: String = ''): Boolean;
    function DeleteByPk: Boolean;
    function DeleteByProp: Boolean;
    function LoadObjectByPK: Boolean;
    procedure ResetPropertiesToDefault;
    procedure AddPropertyToWhere(const APropertyName: String);

    function Existe(const pId: Integer; const pCarrega: Boolean = false): Boolean;
    procedure GeraCodigo;

    class function TotalCR(pDtIni, pDtFim: TDate): Double;
    class function GetIdGrupoParcelas: Integer;

    function BaixarCR(pCrDet: TModelCrDetalhe; pCr: TModelCR): Boolean;
    function CancBxCr: Boolean;

  end;

implementation

{ TModelCR }

procedure TModelCR.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

function TModelCR.BaixarCR(pCrDet: TModelCrDetalhe; pCr: TModelCR): Boolean;
var
  lCaixa: TModelLancamentoCaixa;
  lCrParcial: TModelCR;
const
  TOLERANCIAVALORCR: Currency = 0.01;
begin

  Result := false;
  pCr.ValorAbatido := pCr.ValorAbatido + pCrDet.Valor;

  // Caso o valor abatido já seja igual ao valor da parcela
  if (pCr.ValorAbatido >= pCr.ValorParcela) then
  begin
    pCr.Status := 'P';
    pCr.DataRecebimento := pCrDet.Data;
  end;

  // Inclui conta parcial
  if ((Abs(pCr.ValorParcela - pCrDet.Valor) - pCrDet.ValorDesc) > TOLERANCIAVALORCR) then
  begin
    lCrParcial := TModelCR.Create;
    try
      // gera a id
      lCrParcial.GeraCodigo;
      lCrParcial.DataCadastro := now;
      lCrParcial.Status := 'A';
      lCrParcial.ValorAbatido := 0;

      // Passando os dados para o dataset
      if (pCr.Doc = '') or (pCr.Parcial = 'S') then
        lCrParcial.Doc := pCr.Doc
      else
        lCrParcial.Doc := Format('%s-P', [pCr.Doc]);

      lCrParcial.Desc := Format('Parcial - Restante da Conta ID Nº %d - Doc Nº %s', [pCr.ID, pCr.Doc]);
      lCrParcial.ValorVenda := pCr.ValorVenda;
      lCrParcial.DataVenda := pCr.DataVenda;
      lCrParcial.Parcela := pCr.Parcela;
      lCrParcial.ValorParcela := ((pCr.ValorParcela - pCrDet.Valor) - pCrDet.ValorDesc);
      lCrParcial.DataVencimento := pCr.DataVencimento;
      lCrParcial.Parcial := 'S';
      lCrParcial.CrOrigem := pCr.ID;
      lCrParcial.IdCliente := pCr.IdCliente;

      // Gravando no BD
      if not lCrParcial.Insert then
      begin
        Application.MessageBox('Erro ao realizar a baixa: Erro ao gerar a conta parcial!', 'Erro',
          MB_OK + MB_ICONERROR);
        exit;
      end;

    finally
      lCrParcial.Free;
    end;

  end;

  // Atualizando a conta baixada
  pCr.Status := 'P';
  pCr.DataRecebimento := pCrDet.Data;
  if not pCr.UpdateByPK then
  begin
    Application.MessageBox('Erro ao realizar a baixa: Erro ao gravar a baixa!', 'Erro', MB_OK + MB_ICONERROR);
    exit;
  end;

  // Grava os detalhes da baixa
  pCrDet.GeraCodigo;
  if not pCrDet.Insert then
  begin
    Application.MessageBox('Erro ao realizar a baixa: Erro ao gravar os detalhes da baixa!', 'Erro',
      MB_OK + MB_ICONERROR);
    exit;
  end;

  // Lançando a baixa no caixa
  lCaixa := TModelLancamentoCaixa.Create;
  try
    lCaixa.GeraCodigo;
    lCaixa.NumDoc := pCr.Doc;
    lCaixa.Desc := Format('Baixa Conta ID Nº %d a Receber - Nº Documento: %s - Parcela: %d',
      [pCr.ID, pCr.Doc, pCr.Parcela]);
    lCaixa.Valor := pCrDet.Valor;
    lCaixa.Tipo := 'R';
    lCaixa.DataCadastro := pCrDet.Data;
    lCaixa.Origem := 'CR';
    lCaixa.IdOrigem := pCr.ID;

    // Gravando no BD
    if not lCaixa.Insert then
    begin
      Application.MessageBox('Erro ao realizar a baixa: Erro ao ggravar lançamento no caixa!', 'Erro',
        MB_OK + MB_ICONERROR);
      exit;
    end;
  finally
    lCaixa.Free;
  end;

  Result := True;

end;

function TModelCR.CancBxCr: Boolean;
var
  lCrDetalhe: TModelCrDetalhe;
  lCaixa: TModelLancamentoCaixa;
  lFrPgtoBx: TModelPgtoBxCr;
begin

  Result := false;
  lCrDetalhe := TModelCrDetalhe.Create;
  lCaixa := TModelLancamentoCaixa.Create;
  lFrPgtoBx := TModelPgtoBxCr.Create;
  try

    // Carrega os objetos
    if not lCrDetalhe.ExistePorCr(FID, True) then
    begin
      Application.MessageBox('Não encontrado detalhes da CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    if not lCaixa.ExistePorOrigem(FID, tlCr, True) then
    begin
      Application.MessageBox('Não encontrado lançamento no caixa da CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    if not lFrPgtoBx.ExistePorCr(FID, True) then
    begin
      Application.MessageBox('Não encontrado formas de pagamento da baixa da CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    // Exclui os detalhes da baixa
    if not lCrDetalhe.DeleteByPk then
    begin
      Application.MessageBox('Erro ao excluir detalhes da baixa da CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    // Exclui todas as formas de pagamento
    if not lFrPgtoBx.DeleteBySQLText('ID_CR = ' + IntToStr(FID)) then
    begin
      Application.MessageBox('Erro ao excluir detalhes da baixa da CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    // Exclui o lançamento do caixa
    if not lCaixa.DeleteByPk then
    begin
      Application.MessageBox('Erro ao excluir lançamento do caixa da CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    // Atualiza a CR para aberta
    FValorAbatido := 0;
    FDataRecebimento := 0;
    FStatus := 'A';

    if not UpdateByPK then
    begin
      Application.MessageBox('Erro ao alterar a CR!', 'Erro', MB_OK + MB_ICONERROR);
      exit;
    end;

    Result := True;

  finally
    lCrDetalhe.Free;
    lCaixa.Free;
    lFrPgtoBx.Free;
  end;

end;

constructor TModelCR.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelCR.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelCR.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelCR.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelCR.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelCR.Existe(const pId: Integer; const pCarrega: Boolean = false): Boolean;
var
  lQuery: TSFQuery;
begin
  Result := false;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT ID FROM CONTAS_RECEBER ');
      lQuery.SQL.Add(' WHERE ID = :ID                ');
      lQuery.ParamByName('ID').AsInteger := pId;
      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        if pCarrega then
        begin
          FID := pId;
          Result := LoadObjectByPK;
        end
        else
        begin
          Result := True;
        end;
      end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao realizar a consulta: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;
end;

procedure TModelCR.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID) AS ID FROM CONTAS_RECEBER');

      // Ultimo codigo usado + 1
      FID := lQuery.FieldByName('ID').AsInteger + 1;

      // Insere o registro no final da tabela
      lQuery.Append;
    except
      on E: Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de CR: ' + E.Message), 'Atenção',
          MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;
end;

class function TModelCR.GetIdGrupoParcelas: Integer;
var
  lQuery: TSFQuery;
begin
  Result := 0;

  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT NEXT VALUE FOR GEN_ID_GRUPO_PARCELAS FROM RDB$DATABASE');
      Result := lQuery.Fields[0].AsInteger;
    except
      on E: Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de grupo de parcelas: ' + E.Message), 'Atenção',
          MB_OK + MB_ICONERROR)
      end;
    end;
  finally
    lQuery.Free;
  end;
end;

function TModelCR.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelCR.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelCR.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

class function TModelCR.TotalCR(pDtIni, pDtFim: TDate): Double;
var
  lQuery: TSFQuery;
begin
  Result := 0;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT COALESCE(SUM(VALOR_PARCELA), 0) AS VALOR FROM CONTAS_RECEBER ');
      lQuery.SQL.Add(' WHERE STATUS = ''A'' AND DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM  ');
      lQuery.ParamByName('DTINI').AsDate := pDtIni;
      lQuery.ParamByName('DTFIM').AsDate := pDtFim;
      lQuery.Open;

      Result := lQuery.FieldByName('VALOR').AsFloat;
    except
      on E: Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter valores totais do Contas a Pagar: ' + E.Message), 'Atenção',
          MB_OK + MB_ICONERROR)
      end;
    end;
  finally
    lQuery.Free;
  end;
end;

function TModelCR.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelCR.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelCR.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
