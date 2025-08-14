unit SistemaFinanceiro.Model.Entidades.LancamentoCaixa;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  Vcl.Dialogs,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows,
  SistemaFinanceiro.Model.Entidades.ResumoCaixa,
  uEnumsUtils;

type

  [TDBTable('CAIXA')]
  TModelLancamentoCaixa = class

  private
    FDaoRTTI: TDaoRTTI;
    FNumeroDoc: string;
    FValor: Double;
    FID: Integer;
    FDataCadastro: TDate;
    FDescricao: string;
    FTipo: string;
    FIdOrigem: Integer;
    FOrigem: String;

    class function GetSaldoAnteriorCaixa(pData: TDate): Double;
    class function GetTotalEntradasCaixa(DataInicial, DataFinal: TDate): Double;
    class function GetTotalSaidasCaixa(DataInicial, DataFinal: TDate): Double;
  public
    [TDBColumn('ID'), TDBIsPrimaryKey]
    property ID: Integer read FID write FID;
    [TDBColumn('NUMERO_DOC'), TDBAcceptNull]
    property NumDoc: string read FNumeroDoc write FNumeroDoc;
    [TDBColumn('DESCRICAO'), TDBAcceptNull]
    property Desc: string read FDescricao write FDescricao;
    [TDBColumn('VALOR')]
    property Valor: Double read FValor write FValor;
    [TDBColumn('TIPO')]
    property Tipo: string read FTipo write FTipo;
    [TDBColumn('DATA_CADASTRO')]
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;
    [TDBColumn('ORIGEM')]
    property Origem: String read FOrigem write FOrigem;
    [TDBColumn('ID_ORIGEM'), TDBAcceptNull]
    property IdOrigem: Integer read FIdOrigem write FIdOrigem;

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

    procedure GeraCodigo;
    function Existe(const pId: Integer; const pCarrega: Boolean = false): Boolean;
    function ExistePorOrigem(const pIdOrigem: Integer; const pTpLancamento: TTipoLancamento;
      const pCarrega: Boolean = false): Boolean;
    class function ResumoCaixa(pDtIni, pDtFim: TDate): TModelResumoCaixa;

  end;

implementation

{ TModelLancamentoCaixa }

procedure TModelLancamentoCaixa.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelLancamentoCaixa.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelLancamentoCaixa.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelLancamentoCaixa.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelLancamentoCaixa.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelLancamentoCaixa.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelLancamentoCaixa.Existe(const pId: Integer;
  const pCarrega: Boolean): Boolean;
var
  lQuery: TSFQuery;
begin
  Result := false;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT ID FROM CAIXA ');
      lQuery.SQL.Add(' WHERE ID = :ID       ');
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
        Application.MessageBox(PWideChar('Erro ao realizar a consulta: ' +
          E.Message), 'Aten��o', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelLancamentoCaixa.ExistePorOrigem(const pIdOrigem: Integer; const pTpLancamento: TTipoLancamento;
  const pCarrega: Boolean): Boolean;
var
  lQuery: TSFQuery;
begin
  Result := false;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT ID FROM CAIXA         ');
      lQuery.SQL.Add(' WHERE ID_ORIGEM = :ID_ORIGEM ');
      lQuery.SQL.Add(' AND ORIGEM = :ORIGEM         ');
      lQuery.ParamByName('ID_ORIGEM').AsInteger := pIdOrigem;

      case pTpLancamento of
        tlCr:
          lQuery.ParamByName('ORIGEM').AsString := 'CR';

        tlCp:
          lQuery.ParamByName('ORIGEM').AsString := 'CP';
      end;

      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        if pCarrega then
        begin
          FID := lQuery.FieldByName('ID').AsInteger;
          Result := LoadObjectByPK;
        end
        else
        begin
          Result := True;
        end;
      end;

    except
      on E:
        Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao realizar a consulta: ' +
          E.Message), 'Aten��o', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

procedure TModelLancamentoCaixa.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID) AS ID FROM CAIXA');

      // Ultimo codigo usado + 1
      FID := lQuery.FieldByName('ID').AsInteger + 1;

      // Insere o registro no final da tabela
      lQuery.Append;
    except
      on E: Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter pr�ximo ID deo Caixa: '
          + E.Message), 'Aten��o', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TModelLancamentoCaixa.GetSaldoAnteriorCaixa
  (pData: TDate): Double;
var
  lQuery: TSFQuery;
  lTotalEntradas: Currency;
  lTotalSaidas: Currency;

begin

  Result := 0;
  lQuery := TSFQuery.Create(nil);

  try

    // Pegando o valor total de entradas
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add
      ('SELECT COALESCE(SUM(VALOR), 0) AS VALOR FROM CAIXA WHERE TIPO = ''R'' ');
    lQuery.SQL.Add(' AND DATA_CADASTRO < :DATA ');
    lQuery.ParamByName('DATA').AsDate := pData;
    lQuery.Open();
    lTotalEntradas := lQuery.FieldByName('VALOR').AsCurrency;

    // Pegando o valor total de saidas
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add
      ('SELECT COALESCE(SUM(VALOR), 0) AS VALOR FROM CAIXA WHERE TIPO = ''D'' ');
    lQuery.SQL.Add(' AND DATA_CADASTRO < :DATA ');
    lQuery.ParamByName('DATA').AsDate := pData;
    lQuery.Open();
    lTotalSaidas := lQuery.FieldByName('VALOR').AsCurrency;

  finally
    lQuery.Free;
  end;

  Result := lTotalEntradas - lTotalSaidas;

end;

class function TModelLancamentoCaixa.GetTotalEntradasCaixa(DataInicial,
  DataFinal: TDate): Double;
var
  lQuery: TSFQuery;

begin

  Result := 0;
  lQuery := TSFQuery.Create(nil);

  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add
      ('SELECT COALESCE(SUM(VALOR), 0 ) AS VALOR FROM CAIXA WHERE TIPO = ''R'' ');
    lQuery.SQL.Add(' AND DATA_CADASTRO BETWEEN :DATA_INICIAL AND :DATA_FINAL');

    lQuery.ParamByName('DATA_INICIAL').AsDate := DataInicial;
    lQuery.ParamByName('DATA_FINAL').AsDate := DataFinal;
    lQuery.Open;

    Result := lQuery.FieldByName('VALOR').AsCurrency;

  finally
    lQuery.Free;
  end;

end;

class function TModelLancamentoCaixa.GetTotalSaidasCaixa(DataInicial,
  DataFinal: TDate): Double;
var
  lQuery: TSFQuery;

begin
  Result := 0;
  lQuery := TSFQuery.Create(nil);

  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add
      ('SELECT COALESCE(SUM(VALOR), 0) AS VALOR FROM CAIXA WHERE TIPO = ''D'' ');
    lQuery.SQL.Add(' AND DATA_CADASTRO BETWEEN :DATA_INICIAL AND :DATA_FINAL');

    lQuery.ParamByName('DATA_INICIAL').AsDate := DataInicial;
    lQuery.ParamByName('DATA_FINAL').AsDate := DataFinal;
    lQuery.Open;

    Result := lQuery.FieldByName('VALOR').AsCurrency;

  finally

    lQuery.Close;
    lQuery.Free;

  end;

end;

function TModelLancamentoCaixa.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelLancamentoCaixa.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelLancamentoCaixa.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

class function TModelLancamentoCaixa.ResumoCaixa(pDtIni, pDtFim: TDate)
  : TModelResumoCaixa;
begin

  if pDtIni > pDtFim then
  begin
    raise Exception.Create('Data inicial n�o pode ser maior que a data final!');
  end;

  Result := TModelResumoCaixa.Create;

  try
    Result.SaldoInicial := GetSaldoAnteriorCaixa(pDtIni);
    Result.TotalEntradas := GetTotalEntradasCaixa(pDtIni, pDtFim);
    Result.TotalSaidas := GetTotalSaidasCaixa(pDtIni, pDtFim);
  except
    Result.Free;
    raise;
  end;
end;

function TModelLancamentoCaixa.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelLancamentoCaixa.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelLancamentoCaixa.UpdateBySQLText(const pWhereClause
  : string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
