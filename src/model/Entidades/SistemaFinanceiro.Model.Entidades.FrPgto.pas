unit SistemaFinanceiro.Model.Entidades.FrPgto;

interface

uses
  uDBAttributes,
  uDaoRTTI;

type

  [TDBTable('FR_PGTO')]
  TModelFrPgto = class
  private
    FDaoRTTI: TDaoRTTI;
    FIdFr: Integer;
    FNomeFr: String;
    FDesc: String;
    FStatus: String;
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
    [TDBColumn('STATUS')]
    property Status: String read FStatus write FStatus;
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
begin
  Result := False;
end;

procedure TModelFrPgto.GeraCodigo;
begin

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
