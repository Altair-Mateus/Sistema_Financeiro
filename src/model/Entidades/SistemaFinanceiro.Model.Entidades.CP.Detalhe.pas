unit SistemaFinanceiro.Model.Entidades.CP.Detalhe;

interface

uses
  uDaoRTTI,
  uDBAttributes,
  System.SysUtils,
  FireDAC.Stan.Param;

type

  [TDBTable('CONTAS_PAGAR_DETALHE')]
  TModelCpDetalhe = class
  private
    FDaoRTTI: TDaoRTTI;
    FValor: Currency;
    FDetalhes: String;
    FId: Integer;
    FIdCP: Integer;
    FUsuario: Integer;
    FData: TDate;
    FValorDesc: Currency;

  public
    [TDBColumn('ID'), TDBIsPrimaryKey]
    property Id: Integer read FId write FId;
    [TDBColumn('ID_CONTA_PAGAR')]
    property IdCP: Integer read FIdCP write FIdCP;
    [TDBColumn('DETALHES')]
    property Detalhes: String read FDetalhes write FDetalhes;
    [TDBColumn('VALOR')]
    property Valor: Currency read FValor write FValor;
    [TDBColumn('DATA')]
    property Data: TDate read FData write FData;
    [TDBColumn('USUARIO')]
    property Usuario: Integer read FUsuario write FUsuario;
    [TDBColumn('DESCONTO_BX')]
    property ValorDesc: Currency read FValorDesc write FValorDesc;

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
    function ExistePorCp(const pIdCr: Integer;
      const pCarrega: Boolean = false): Boolean;
    procedure GeraCodigo;
  end;

implementation

{ TModelCpDetalhe }

uses
  SistemaFinanceiro.Model.uSFQuery,
  SistemaFinanceiro.Exceptions.ContasPagarDetalhe;

procedure TModelCpDetalhe.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelCpDetalhe.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelCpDetalhe.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelCpDetalhe.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelCpDetalhe.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelCpDetalhe.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelCpDetalhe.Existe(const pId: Integer;
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
      lQuery.SQL.Add(' SELECT ID FROM CONTAS_PAGAR_DETALHE ');
      lQuery.SQL.Add(' WHERE ID = :ID                        ');
      lQuery.ParamByName('ID').AsInteger := pId;
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
        raise ECpDetalheNaoExiste.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelCpDetalhe.ExistePorCp(const pIdCr: Integer;
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
      lQuery.SQL.Add(' SELECT ID FROM CONTAS_PAGAR_DETALHE ');
      lQuery.SQL.Add(' WHERE ID_CONTA_PAGAR = :IDCP        ');
      lQuery.ParamByName('IDCP').AsInteger := pIdCr;
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
        raise ECpDetalheNaoExiste.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

procedure TModelCpDetalhe.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open
        ('SELECT COALESCE(MAX(ID), 0) AS ID FROM CONTAS_PAGAR_DETALHE');

      // Ultimo codigo usado + 1
      FId := lQuery.FieldByName('ID').AsInteger + 1;

      // Insere o registro no final da tabela
      lQuery.Append;
    except
      on E: Exception do
      begin
        raise ECpDetalheId.Create(E.Message);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelCpDetalhe.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelCpDetalhe.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelCpDetalhe.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelCpDetalhe.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelCpDetalhe.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelCpDetalhe.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
