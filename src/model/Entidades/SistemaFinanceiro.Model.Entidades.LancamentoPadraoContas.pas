unit SistemaFinanceiro.Model.Entidades.LancamentoPadraoContas;

interface

uses
   uDBColumnAttribute, uDaoRTTI;

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

      function Insert : Boolean;
      function UpdateBySQLText(const pWhereClause: string = '') : Boolean;
      function UpdateByPK : Boolean;
      function UpdateByProp : Boolean;
      function DeleteBySQLText(const pWhere : String = '') : Boolean;
      function DeleteByPk : Boolean;
      function DeleteByProp : Boolean;
      function Load : Boolean;

      procedure AddPropertyToWhere(const APropertyName : String);

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
end;

function TModelLancamentoPadrao.DeleteByPk: Boolean;
begin

  Result := False;

  if FDaoRTTI.DeleteByPK(Self) then
    Result := True;

end;

function TModelLancamentoPadrao.DeleteByProp: Boolean;
begin

  Result := False;

  if FDaoRTTI.DeleteByProp(Self) then
    Result := True;

end;

function TModelLancamentoPadrao.DeleteBySQLText(const pWhere: String): Boolean;
begin

  Result := False;

  if FDaoRTTI.DeleteBySQLText(Self, pWhere) then
    Result := True;

end;

destructor TModelLancamentoPadrao.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelLancamentoPadrao.Insert: Boolean;
begin

  Result := False;

  if FDaoRTTI.Insert(Self) then
    Result := True;

end;

function TModelLancamentoPadrao.Load: Boolean;
begin

  Result := False;

  if FDaoRTTI.LoadObjectByPK(Self) then
    Result := True;

end;

function TModelLancamentoPadrao.UpdateByPK: Boolean;
begin

  Result := False;

  if FDaoRTTI.UpdateByPK(Self) then
    Result := True;

end;

function TModelLancamentoPadrao.UpdateByProp: Boolean;
begin

  Result := False;

  if FDaoRTTI.UpdateByProp(Self) then
    Result := True;

end;

function TModelLancamentoPadrao.UpdateBySQLText(
  const pWhereClause: string): Boolean;
begin

  Result := False;

  if FDaoRTTI.UpdateBySQLText(Self, pWhereClause) then
    Result := True;

end;

end.
