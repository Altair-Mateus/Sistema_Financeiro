unit SistemaFinanceiro.Model.Entidades.Usuario;

interface

uses
   uDBColumnAttribute, uBaseDAO;

type
  [TDBTable('USUARIOS')]
  TModelUsuario = class

  private
    FBaseDAO : TBaseDAO;
    FLogin: String;
    FNome: String;
    FId: Integer;
    FSenha_Temp: String;
    FSenha: String;
    FTeste: Integer;
    FStatus: String;
    FData_Cadastro: TDate;
    FUser_Admin: String;
    FTable_Name: String;

  public

    function Insert : Boolean;
    function UpdateByText(const pWhereClause: string = '') : Boolean;
    function UpdateByPK : Boolean;
    function UpdateByProp : Boolean;
    function DeleteByText(const pWhere : String = '') : Boolean;
    function DeleteByPk : Boolean;
    function DeleteByProp : Boolean;
    function Load : Boolean;

    procedure AddPropertyToWhere(const APropertyName : String);


    [TDBColumnAttribute('ID', True, True)]
    property Id            : Integer read FId write FId;
    [TDBColumnAttribute('NOME')]
    property Nome          : String read FNome write FNome;
    [TDBColumnAttribute('LOGIN')]
    property Login         : String read FLogin write FLogin;
    [TDBColumnAttribute('SENHA')]
    property Senha         : String read FSenha write FSenha;
    [TDBColumnAttribute('STATUS')]
    property Status        : String read FStatus write FStatus;
    [TDBColumnAttribute('DATA_CADASTRO')]
    property Data_Cadastro : TDate read FData_Cadastro write FData_Cadastro;
    [TDBColumnAttribute('SENHA_TEMP')]
    property Senha_Temp    : String read FSenha_Temp write FSenha_Temp;
    [TDBColumnAttribute('USER_ADMIN')]
    property User_Admin    : String read FUser_Admin write FUser_Admin;

    constructor Create;
    destructor Destroy; override;

  end;
implementation
{ TModelUsuario }

procedure TModelUsuario.AddPropertyToWhere(const APropertyName: String);
begin
  FBaseDAO.AddPropertyToWhere(APropertyName);
end;

constructor TModelUsuario.Create;
begin
  FBaseDAO := TBaseDAO.Create;
end;


function TModelUsuario.DeleteByPk: Boolean;
begin

  Result := False;

  if FBaseDAO.DeleteByPK(Self) then
    Result := true;

end;

function TModelUsuario.DeleteByProp: Boolean;
begin

  Result := False;

  if FBaseDAO.DeleteByProp(Self) then
    Result := True;

end;

function TModelUsuario.DeleteByText(const pWhere: String = ''): Boolean;
begin

  Result := false;

  if FBaseDAO.DeleteBySQLText(Self, pWhere) then
    Result := True;
end;

destructor TModelUsuario.Destroy;
begin
  FBaseDAO.Free;
  inherited;
end;

function TModelUsuario.Insert: Boolean;
begin

  Result := False;

  if FBaseDAO.Insert(Self) then
    Result := True;

end;

function TModelUsuario.Load: Boolean;
begin

  Result := False;

  if FBaseDAO.LoadObjectByPK(Self) then
    Result := True;

end;


function TModelUsuario.UpdateByPK: Boolean;
begin

  Result := False;

  if FBaseDAO.UpdateByPK(Self) then
    Result := True;

end;

function TModelUsuario.UpdateByProp: Boolean;
begin

   Result := False;

  if FBaseDAO.UpdateByProp(Self) then
    Result := True;

end;


function TModelUsuario.UpdateByText(const pWhereClause: string): Boolean;
begin

  Result := False;

  if FBaseDAO.UpdateBySQLText(Self, pWhereClause) then
    Result := true;

end;

end.
