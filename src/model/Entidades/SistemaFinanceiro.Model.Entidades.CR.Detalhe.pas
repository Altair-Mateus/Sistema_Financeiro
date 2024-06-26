unit SistemaFinanceiro.Model.Entidades.CR.Detalhe;

interface

uses
  uDBColumnAttribute,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows;

type
  [TDBTable('CONTAS_RECEBER_DETALHE')]
  TModelCrDetalhe = class

  private
    FDaoRTTI: TDaoRTTI;
    FValor: Currency;
    FDetalhes: String;
    FIdCR: Integer;
    FId: Integer;
    FUsuario: Integer;
    FData: TDate;
    FValorDesc: Double;
  public
    [TDBColumn('ID', True, False)]
    property Id: Integer read FId write FId;
    [TDBColumn('ID_CONTA_RECEBER')]
    property IdCR: Integer read FIdCR write FIdCR;
    [TDBColumn('DETALHES', False, False, True)]
    property Detalhes: String read FDetalhes write FDetalhes;
    [TDBColumn('VALOR')]
    property Valor: Currency read FValor write FValor;
    [TDBColumn('DATA')]
    property Data: TDate read FData write FData;
    [TDBColumn('USUARIO')]
    property Usuario: Integer read FUsuario write FUsuario;
    [TDBColumn('DESCONTO_BX', False, False, True)]
    property ValorDesc: Double read FValorDesc write FValorDesc;

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

    function Existe(const pId : Integer; const pCarrega : Boolean = false) : Boolean;
    procedure GeraCodigo;

  end;

implementation


{ TModelCrDetalhe }

procedure TModelCrDetalhe.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelCrDetalhe.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelCrDetalhe.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPK(Self);
end;

function TModelCrDetalhe.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelCrDetalhe.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelCrDetalhe.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelCrDetalhe.Existe(const pId: Integer;
  const pCarrega: Boolean): Boolean;
var
  lQuery : TSFQuery;
begin
  Result := False;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT ID FROM CONTAS_RECEBER_DETALHE ');
      lQuery.SQL.Add(' WHERE ID = :ID                        ');
      lQuery.ParamByName('ID').AsInteger := pId;
      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        Result := True;
        if pCarrega then
        begin
          FID := pId;
          LoadObjectByPK;
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

procedure TModelCrDetalhe.GeraCodigo;
var
  lQuery : TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID) AS ID FROM CONTAS_RECEBER_DETALHE');

      //  Ultimo codigo usado + 1
      FID := lQuery.FieldByName('ID').AsInteger + 1;

      //  Insere o registro no final da tabela
      lQuery.Append;
    except
      on E : Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de CR_Detalhe: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelCrDetalhe.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelCrDetalhe.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelCrDetalhe.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelCrDetalhe.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelCrDetalhe.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelCrDetalhe.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
