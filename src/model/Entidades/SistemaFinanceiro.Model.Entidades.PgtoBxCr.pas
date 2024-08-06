unit SistemaFinanceiro.Model.Entidades.PgtoBxCr;

interface

uses
  uDBColumnAttribute,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows;

type
  [TDBTable('PGTO_BX_CR')]
  TModelPgtoBxCr = class

  private
    FDaoRTTI: TDaoRTTI;
    FId: Integer;
    FIdCr: Integer;
    FIdFrPgto: Integer;
    FNrPgto: Integer;
    FDataHora: TDateTime;
    FValorPago: Double;
  public
    [TDBColumn('ID', True, False)]
    property Id: Integer read FId write FId;
    [TDBColumn('ID_CR')]
    property IdCr: Integer read FIdCr write FIdCr;
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

    function Existe(const pId: Integer; const pCarrega: Boolean = false): Boolean;
    function ExistePorCr(const pIdCr: Integer; const pCarrega: Boolean = false): Boolean;
    procedure GeraCodigo;
  end;

implementation


{ TModelPgtoBxCr }

procedure TModelPgtoBxCr.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelPgtoBxCr.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelPgtoBxCr.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPK(Self);
end;

function TModelPgtoBxCr.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelPgtoBxCr.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelPgtoBxCr.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelPgtoBxCr.Existe(const pId: Integer; const pCarrega: Boolean): Boolean;
var
  lQuery : TSFQuery;
begin
  Result := False;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT ID FROM PGTO_BX_CR ');
      lQuery.SQL.Add(' WHERE ID_CR = :ID_CR      ');
      lQuery.ParamByName('ID_CR').AsInteger := pId;
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
      on E : Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao realizar a consulta: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelPgtoBxCr.ExistePorCr(const pIdCr: Integer; const pCarrega: Boolean): Boolean;
var
  lQuery : TSFQuery;
begin
  Result := False;
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT ID FROM PGTO_BX_CR ');
      lQuery.SQL.Add(' WHERE ID_CR = :ID_CR      ');
      lQuery.ParamByName('ID_CR').AsInteger := pIdCr;
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
      on E : Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao realizar a consulta: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

procedure TModelPgtoBxCr.GeraCodigo;
var
  lQuery : TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID) AS ID FROM PGTO_BX_CR');

      //  Ultimo codigo usado + 1
      FID := lQuery.FieldByName('ID').AsInteger + 1;

      //  Insere o registro no final da tabela
      lQuery.Append;
    except
      on E : Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter próximo ID da forma de pagamento da baixa do CR: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelPgtoBxCr.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelPgtoBxCr.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelPgtoBxCr.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelPgtoBxCr.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelPgtoBxCr.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelPgtoBxCr.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
