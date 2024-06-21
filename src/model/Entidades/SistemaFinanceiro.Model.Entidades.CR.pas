unit SistemaFinanceiro.Model.Entidades.CR;

interface

uses
  uDBColumnAttribute,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  Vcl.Dialogs,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows;

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
    [TDBColumn('ID', True, False)]
    property ID: Integer read FID write FID;
    [TDBColumn('NUMERO_DOCUMENTO', False, False, True)]
    property Doc: String read FDoc write FDoc;
    [TDBColumn('DESCRICAO', False, False, True)]
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
    [TDBColumn('DATA_RECEBIMENTO', False, False, True)]
    property DataRecebimento: TDate read FDataRecebimento write FDataRecebimento;
    [TDBColumn('STATUS')]
    property Status: String read FStatus write FStatus;
    [TDBColumn('PARCIAL')]
    property Parcial: String read FParcial write FParcial;
    [TDBColumn('CR_ORIGEM', False, False, True)]
    property CrOrigem: Integer read FCrOrigem write FCrOrigem;
    [TDBColumn('ID_CLIENTE')]
    property IdCliente: Integer read FIdCliente write FIdCliente;
    [TDBColumn('NUM_TOT_PARCELAS', False, False, True)]
    property NumTotalParcelas: Integer read FNumTotalParcelas write FNumTotalParcelas;
    [TDBColumn('ID_GRUPO_PARCELAS', False, False, True)]
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
    function Load: Boolean;
    procedure ResetPropertiesToDefault;


    function Existe(const pId : Integer; const pCarrega : Boolean = false) : Boolean;

    procedure AddPropertyToWhere(const APropertyName: String);
    procedure GeraCodigo;

    class function TotalCR(pDtIni, pDtFim: TDate) : Double;
    class function GetIdGrupoParcelas : Integer;

//    procedure BaixarCR(BaixaCR: TModelCrDetalhe);
 //    function CancBxCr(pId: Integer) : Boolean;
//
//    function GeraCodigoCRDetalhe: Integer;
//    function GetCrDet(ID: Integer): TModelCrDetalhe;


  end;

implementation

{ TModelCR }

procedure TModelCR.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
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

function TModelCR.Existe(const pId: Integer; const pCarrega : Boolean = false): Boolean;
var
  lQuery : TSFQuery;
begin
  Result := False;
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
        Result := True;
        if pCarrega then
        begin
          FID := pId;
          Load;
        end;
      end;

    except
      on E : Exception do
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
  lQuery : TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID) AS ID FROM CONTAS_RECEBER');

      //  Ultimo codigo usado + 1
      FID := lQuery.FieldByName('ID').AsInteger + 1;

      //  Insere o registro no final da tabela
      lQuery.Append;
    except
      on E : Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de CR: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
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
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de grupo de parcelas: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR)
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

function TModelCR.Load: Boolean;
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
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de grupo de parcelas: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR)
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
