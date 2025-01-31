unit SistemaFinanceiro.Model.Entidades.PgtoBxCp;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  System.SysUtils,
  FireDAC.Stan.Param,
  SistemaFinanceiro.Model.uSFQuery;

type

  [TDBTable('PGTO_BX_CP')]
  TModelPgtoBxCp = class

  private
    FDaoRTTI: TDaoRTTI;
    FNrPgto: Integer;
    FDataHora: TDateTime;
    FId: Integer;
    FIdCp: Integer;
    FIdFrPgto: Integer;
    FValorPago: Double;

  public
    [TDBColumn('ID'), TDBIsPrimaryKey]
    property Id: Integer read FId write FId;
    [TDBColumn('ID_CP')]
    property IdCp: Integer read FIdCp write FIdCp;
    [TDBColumn('ID_FR_PGTO')]
    property IdFrPgto: Integer read FIdFrPgto write FIdFrPgto;
    [TDBColumn('NR_FR')]
    property NrPgto: Integer read FNrPgto write FNrPgto;
    [TDBColumn('DATA_HORA')]
    property DataHora: TDateTime read FDataHora write FDataHora;
    [TDBColumn('VALOR_PAGO')]
    property ValorPago: Double read FValorPago write FValorPago;

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

    function Existe(const pId: Integer;
      const pCarrega: Boolean = false): Boolean;
    function ExistePorCp(const pIdCp: Integer;
      const pCarrega: Boolean = false): Boolean;
    procedure GeraCodigo;
  end;

implementation

uses
  SistemaFinanceiro.Exceptions.BaixaCp;

procedure TModelPgtoBxCp.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelPgtoBxCp.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelPgtoBxCp.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelPgtoBxCp.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelPgtoBxCp.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelPgtoBxCp.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelPgtoBxCp.Existe(const pId: Integer;
  const pCarrega: Boolean): Boolean;
begin
  var
    lQuery: TSFQuery;
  begin
    Result := false;
    lQuery := TSFQuery.Create(nil);
    try
      try
        lQuery.Close;
        lQuery.SQL.Clear;
        lQuery.SQL.Add(' SELECT ID FROM PGTO_BX_CP ');
        lQuery.SQL.Add(' WHERE ID_CP = :ID_CP      ');
        lQuery.ParamByName('ID_CP').AsInteger := pId;
        lQuery.Open;

        if (lQuery.RecordCount > 0) then
        begin
          if pCarrega then
          begin
            FId := pId;
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
          raise EBaixaCPExiste.Create(E.Message);
        end;
      end;
    finally
      lQuery.Free;
    end;
  end;
end;

function TModelPgtoBxCp.ExistePorCp(const pIdCp: Integer;
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
      lQuery.SQL.Add(' SELECT ID FROM PGTO_BX_CP ');
      lQuery.SQL.Add(' WHERE ID_CP = :ID_CP      ');
      lQuery.ParamByName('ID_CP').AsInteger := pIdCp;
      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        if pCarrega then
        begin
          FId := lQuery.FieldByName('ID').AsInteger;
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
        raise EBaixaCPExiste.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

procedure TModelPgtoBxCp.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT COALESCE(MAX(ID), 0) AS ID FROM PGTO_BX_CP');

      // Ultimo codigo usado + 1
      FId := lQuery.FieldByName('ID').AsInteger + 1;

      // Insere o registro no final da tabela
      lQuery.Append;
    except
      on E: Exception do
      begin
        raise EBaixaCpId.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelPgtoBxCp.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelPgtoBxCp.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelPgtoBxCp.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelPgtoBxCp.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelPgtoBxCp.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelPgtoBxCp.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
