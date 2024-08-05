unit SistemaFinanceiro.Model.Entidades.LancamentoPadraoContas;

interface

uses
   uDBColumnAttribute, uDaoRTTI, SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils, Winapi.Windows, Vcl.Forms;

type
  [TDBTable('LANCAMENTO_PADRAO_CONTAS')]
  TModelLancamentoPadrao = class

  private
    FDaoRTTI : TDaoRTTI;
    FId: Integer;
    FTipo: String;
    FData_Cadastro: TDateTime;
    FData_Alteracao: TDateTime;
    FStatus: String;
    FDescricao: String;
    FId_Fornecedor: Integer;
    FId_Cliente: Integer;
    function Load: Boolean;

    public
      [TDBColumnAttribute('ID', True, True)]
      property Id: Integer read FId write FId;
      [TDBColumnAttribute('TIPO')]
      property Tipo: String read FTipo write FTipo;
      [TDBColumnAttribute('DATA_CADASTRO')]
      property Data_Cadastro: TDateTime read FData_Cadastro write FData_Cadastro;
      [TDBColumnAttribute('DATA_ALTERACAO')]
      property Data_Alteracao: TDateTime read FData_Alteracao write FData_Alteracao;
      [TDBColumnAttribute('STATUS')]
      property Status: String read FStatus write FStatus;
      [TDBColumnAttribute('DESCRICAO')]
      property Descricao: String read FDescricao write FDescricao;
      [TDBColumnAttribute('ID_FORNECEDOR')]
      property Id_Fornecedor: Integer read FId_Fornecedor write FId_Fornecedor;
      [TDBColumnAttribute('ID_CLIENTE')]
      property Id_Cliente: Integer read FId_Cliente write FId_Cliente;

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

  end;

implementation

{ TModelLancamentoPadrao }

procedure TModelLancamentoPadrao.AddPropertyToWhere(
  const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelLancamentoPadrao.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelLancamentoPadrao.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPK(Self);
end;

function TModelLancamentoPadrao.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelLancamentoPadrao.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelLancamentoPadrao.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelLancamentoPadrao.Existe(const pId: Integer;
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

function TModelLancamentoPadrao.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelLancamentoPadrao.Load: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

function TModelLancamentoPadrao.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelLancamentoPadrao.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelLancamentoPadrao.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelLancamentoPadrao.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelLancamentoPadrao.UpdateBySQLText(
  const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
