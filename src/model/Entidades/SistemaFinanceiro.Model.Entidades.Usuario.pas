unit SistemaFinanceiro.Model.Entidades.Usuario;
interface
type
  TModelUsuario = class
  private
    FLogin: String;
    FNome: String;
    FId: String;
    FSenha_Temp: String;
    FSenha: String;
    FTeste: Integer;
    FStatus: String;
    FData_Cadastro: TDateTime;
    FUser_Admin: String;
    FTable_Name: String;

  public
    property Table_Name    : String read FTable_Name;
    property Id            : String read FId write FId;
    property Nome          : String read FNome write FNome;
    property Login         : String read FLogin write FLogin;
    property Senha         : String read FSenha write FSenha;
    property Status        : String read FStatus write FStatus;
    property Data_Cadastro : TDateTime read FData_Cadastro write FData_Cadastro;
    property Senha_Temp    : String read FSenha_Temp write FSenha_Temp;
    property User_Admin    : String read FUser_Admin write FUser_Admin;

    constructor Create;
    destructor Destroy; override;

  end;
implementation
{ TModelUsuario }

{ TModelUsuario }

constructor TModelUsuario.Create;
begin
  FTable_Name := 'USUARIOS';
end;

destructor TModelUsuario.Destroy;
begin

  inherited;
end;

end.
