unit SistemaFinanceiro.Model.Entidades.FaturaCartao;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils,
  FireDAC.Stan.Param,
  System.Math;

type

  [TDBTable('FATURA_CARTAO')]
  TModelFaturaCartao = class
  private
    FDaoRTTI: TDaoRTTI;
    FId: Integer;
    FNome: String;
    FObservacao: String;
    FDiaVcto: Integer;
    FDataCadastro: TDateTime;
    FDataAlteracao: TDateTime;
    FStatusFt: Boolean;
  public
    [TDBColumn('ID_FT'), TDBIsPrimaryKey]
    property Id: Integer read FId write FId;
    [TDBColumn('NOME')]
    property Nome: String read FNome write FNome;
    [TDBColumn('OBSERVACAO')]
    property Observacao: String read FObservacao write FObservacao;
    [TDBColumn('DIA_VCTO')]
    property DiaVcto: Integer read FDiaVcto write FDiaVcto;
    [TDBColumn('DATA_CADASTRO')]
    property DataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    [TDBColumn('DATA_ALTERACAO')]
    property DataAlteracao: TDateTime read FDataAlteracao write FDataAlteracao;
    [TDBColumn('STATUS_FT'), TDBSaveBoolean(btAI)]
    property StatusFt: Boolean read FStatusFt write FStatusFt;

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

    function Existe(const pId: Integer; const pCarrega: Boolean = false): Boolean;
    procedure GeraCodigo;
  end;

implementation

uses
  SistemaFinanceiro.Exceptions.FaturaCartao;

{ TModelFaturaCartao }

procedure TModelFaturaCartao.AddPropertyToWhere(const pPropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(pPropertyName);
end;

constructor TModelFaturaCartao.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelFaturaCartao.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelFaturaCartao.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelFaturaCartao.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelFaturaCartao.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelFaturaCartao.Existe(const pId: Integer;
  const pCarrega: Boolean): Boolean;
var
  lQuery: TSFQuery;
begin
  Result := false;
  lQuery := TSFQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT ID_FT FROM FATURA_CARTAO   ');
    lQuery.SQL.Add(' WHERE ID_FT = :ID               ');
    lQuery.ParamByName('ID').AsInteger := pId;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      if (pCarrega) then
      begin
        FId := pId;
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

procedure TModelFaturaCartao.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try

      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT COALESCE(MAX(ID_FT), 0) AS ID FROM FATURA_CARTAO');

      // Ultimo codigo usado + 1
      FId := (lQuery.FieldByName('ID').AsInteger + 1);

    except
      on E: Exception do
      begin
        raise EFatCartaoId.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelFaturaCartao.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelFaturaCartao.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelFaturaCartao.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelFaturaCartao.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelFaturaCartao.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelFaturaCartao.UpdateBySQLText(
  const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
