unit SistemaFinanceiro.Model.Entidades.FrPgto;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  System.SysUtils;

type

  [TDBTable('FR_PGTO')]
  TModelFrPgto = class
  private
    FDaoRTTI: TDaoRTTI;
    FIdFr: Integer;
    FNomeFr: String;
    FDesc: String;
    FStatus: Boolean;
    FDataCadastro: TDateTime;
    FDataAlteracao: TDateTime;
    FMetodoPag: String;

  public
    [TDBColumn('ID_FR'), TDBIsPrimaryKey]
    property IdFr: Integer read FIdFr write FIdFr;
    [TDBColumn('NOME_FR')]
    property NomeFr: String read FNomeFr write FNomeFr;
    [TDBColumn('DESC'), TDBAcceptNull]
    property Desc: String read FDesc write FDesc;
    [TDBColumn('STATUS'), TDBSaveBoolean(btAI)]
    property Status: Boolean read FStatus write FStatus;
    [TDBColumn('DATA_CADASTRO')]
    property DataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    [TDBColumn('DATA_ALTERACAO'), TDBAcceptNull]
    property DataAlteracao: TDateTime read FDataAlteracao write FDataAlteracao;
    [TDBColumn('METODO_PAG')]
    property MetodoPag: String read FMetodoPag write FMetodoPag;

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
    procedure AddPropertyToWhere(const pPropertyName: String);

    function Existe(const pId: Integer; const pCarrega: Boolean = False): Boolean;
    procedure GeraCodigo;
  end;

implementation

{ TModelFrPgto }

uses
  SistemaFinanceiro.Model.uSFQuery,
  SistemaFinanceiro.Exceptions.FrPgto;

procedure TModelFrPgto.AddPropertyToWhere(const pPropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(pPropertyName);
end;

constructor TModelFrPgto.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelFrPgto.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelFrPgto.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelFrPgto.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelFrPgto.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelFrPgto.Existe(const pId: Integer;
  const pCarrega: Boolean): Boolean;
var
  lQuery: TSFQuery;
begin
  Result := False;
  lQuery := TSFQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT ID_FR FROM FR_PGTO   ');
    lQuery.SQL.Add(' WHERE ID_FR = :ID           ');
    lQuery.ParamByName('ID').AsInteger := pId;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      if (pCarrega) then
      begin
        IdFr := pId;
        Result := LoadObjectByPK;
      end
      else
      begin
        Result := True;
      end;
    end;
  finally
    lQuery.Free;
  end;
end;

procedure TModelFrPgto.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try

      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT COALESCE(MAX(ID_FR), 0) AS ID FROM FR_PGTO ');

      // Ultimo codigo usado + 1
      FIdFr := (lQuery.FieldByName('ID').AsInteger + 1);

      // Insere o registro no final da tabela
      lQuery.Append;
    except
      on E: Exception do
      begin
        raise EFrPgtoId.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelFrPgto.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelFrPgto.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelFrPgto.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelFrPgto.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelFrPgto.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelFrPgto.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
