unit SistemaFinanceiro.Model.Entidades.Usuario;

interface

uses
   uDBAttributes, uDaoRTTI, SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils, Vcl.Forms, Winapi.Windows, BCrypt;

type
  [TDBTable('USUARIOS')]
  TModelUsuario = class

  private
    FDaoRTTI : TDaoRTTI;
    FLogin: String;
    FNome: String;
    FId: Integer;
    FSenha_Temp: String;
    FSenha: String;
    FStatus: String;
    FData_Cadastro: TDate;
    FUser_Admin: String;
    FTable_Name: String;
    CONST TEMP_PASSWORD = '12345';
  public

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

    function Existe(const pId : Integer; const pCarrega : Boolean = false) : Boolean;
    function ExistePorLogin(const pLogin: String; const pCarrega : Boolean = false) : Boolean;
    procedure GeraCodigo;
    procedure EfetuaLogin(const pLogin: String; const pSenha : String);
    function LimparSenhaTemp(pIdUsuario: Integer) : Boolean;
    function VerificaLogin(pLogin : String; pId: Integer) : Boolean;
    function TblUsuariosVazia : Boolean;
    function GetBaixa(Id: Integer) : Boolean;

  end;
implementation
{ TModelUsuario }

procedure TModelUsuario.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelUsuario.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;


function TModelUsuario.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPK(Self);
end;

function TModelUsuario.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelUsuario.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelUsuario.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

procedure TModelUsuario.EfetuaLogin(const pLogin: String; const pSenha : String);

begin

  if not ExistePorLogin(pLogin, True) then
  begin
    raise Exception.Create('Usuário e/ou senha inválidos');
  end;

  //  Valida se o usuario esta ativo
  if FStatus <> 'A' then
  begin
    raise Exception.Create('Usuário não está ativo! Contate o Administrador');
  end;

  //  Valida o hash da senha
  if not TBCrypt.CompareHash(Senha, FSenha) then
  begin
    raise Exception.Create('Senha Incorreta!');
  end;

end;

function TModelUsuario.Existe(const pId: Integer;
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
      lQuery.SQL.Add(' SELECT ID FROM USUARIOS ');
      lQuery.SQL.Add(' WHERE ID = :ID          ');
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

function TModelUsuario.ExistePorLogin(const pLogin: String;
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
      lQuery.SQL.Add(' SELECT ID FROM USUARIOS ');
      lQuery.SQL.Add(' WHERE LOGIN = :LOGIN    ');
      lQuery.ParamByName('LOGIN').AsString := pLogin;
      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        Result := True;
        if pCarrega then
        begin
          FID := lQuery.FieldByName('ID').AsInteger;
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

procedure TModelUsuario.GeraCodigo;
var
  lQuery : TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID) AS ID FROM USUARIOS');

      //  Ultimo codigo usado + 1
      FID := lQuery.FieldByName('ID').AsInteger + 1;

      //  Insere o registro no final da tabela
      lQuery.Append;
    except
      on E : Exception do
      begin
        Application.MessageBox(PWideChar('Erro ao obter próximo ID de USUARIOS: ' + E.Message), 'Atenção', MB_OK + MB_ICONERROR);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelUsuario.GetBaixa(Id: Integer): Boolean;
var
  lQuery : TSFQuery;
begin

  Result := False;
  lQuery := TSFQuery.Create(nil);
  try

    //  Verifica se o user fez alguma baixa no CR
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT FIRST 1 * FROM CONTAS_RECEBER_DETALHE ');
    lQuery.SQL.Add(' WHERE USUARIO = :ID                          ');
    lQuery.ParamByName('ID').AsInteger := ID;
    lQuery.Open();

    if not lQuery.IsEmpty then
    begin
      Result := True;
    end
    else
    begin

      //  Verifica se o user fez alguma baixa no CP
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.SQL.Add(' SELECT FIRST 1 * FROM CONTAS_PAGAR_DETALHE ');
      lQuery.SQL.Add(' WHERE USUARIO = :ID                        ');
      lQuery.ParamByName('ID').AsInteger := ID;
      lQuery.Open();

      if not lQuery.IsEmpty then
      begin
        Result := True;
      end;

    end;

  finally
    lQuery.Free;
  end;

end;

function TModelUsuario.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelUsuario.LimparSenhaTemp(pIdUsuario: Integer) : Boolean;
begin

  Result := False;

  if not Existe(pIdUsuario, True) then
  begin
    raise Exception.Create('Usuário não encontrado');
  end;

  FSenha_Temp := 'S';
  FSenha := TBCrypt.GenerateHash(TEMP_PASSWORD);

  Result := UpdateByPK;

end;

function TModelUsuario.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelUsuario.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelUsuario.TblUsuariosVazia: Boolean;
var
  lQuery : TSFQuery;
begin

  lQuery := TSFQuery.Create(nil);

  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.Open(' SELECT * FROM USUARIOS ');

    Result := lQuery.IsEmpty;

  finally
    lQuery.Free;
  end;

end;

function TModelUsuario.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelUsuario.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelUsuario.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

function TModelUsuario.VerificaLogin(pLogin : String; pId: Integer): Boolean;
var
  lQuery : TSFQuery;
begin

  Result := False;
  lQuery := TSFQuery.Create(nil);

  try

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT ID FROM USUARIOS WHERE LOGIN = :LOGIN');

    lQuery.ParamByName('LOGIN').AsString := pLogin;
    lQuery.Open();

    //  Se não estiver vazia
    if not lQuery.IsEmpty then
      Result := lQuery.FieldByName('ID').AsInteger <> pId;

  finally
    lQuery.Free;
  end;

end;

end.
