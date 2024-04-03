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
    function Update(const pWhere : String = '') : Boolean;

    [TDBColumnAtrribute('ID', True, True)]
    property Id            : Integer read FId write FId;
    [TDBColumnAtrribute('NOME')]
    property Nome          : String read FNome write FNome;
    [TDBColumnAtrribute('LOGIN')]
    property Login         : String read FLogin write FLogin;
    [TDBColumnAtrribute('SENHA')]
    property Senha         : String read FSenha write FSenha;
    [TDBColumnAtrribute('STATUS')]
    property Status        : String read FStatus write FStatus;
    [TDBColumnAtrribute('DATA_CADASTRO')]
    property Data_Cadastro : TDate read FData_Cadastro write FData_Cadastro;
    [TDBColumnAtrribute('SENHA_TEMP')]
    property Senha_Temp    : String read FSenha_Temp write FSenha_Temp;
    [TDBColumnAtrribute('USER_ADMIN')]
    property User_Admin    : String read FUser_Admin write FUser_Admin;

    constructor Create;
    destructor Destroy; override;

  end;
implementation
{ TModelUsuario }

constructor TModelUsuario.Create;
begin
  FBaseDAO := TBaseDAO.Create;
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

function TModelUsuario.Update(const pWhere : String = '') : Boolean;
begin

  Result := False;

  if FBaseDAO.Update(Self, pWhere) then
    Result := True;

end;

end.
