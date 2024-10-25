unit SistemaFinanceiro.Model.Entidades.Cliente;

interface

uses
  uDBAttributes, uDaoRTTI, SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils, fMensagem, uEnumsUtils;

type

  [TDBTable('CLIENTES')]
  TModelCliente = class
  private
    FDaoRTTI: TDaoRTTI;
    FId_Cli: Integer;
    FNome: String;
    FTipo: String;
    FCpf: String;
    FCnpj: String;
    FIe: String;
    FEndereco: String;
    FN_Logradouro: String;
    FBairro: String;
    FCidade: String;
    FEstado: String;
    FCep: String;
    FCelular: String;
    FTelefone: String;
    FComplemento: String;
    FEmail: String;
    FData_Cadastro: TDateTime;
    FData_Alteracao: TDateTime;
    FStatus_Cli: String;
  public
    [TDBColumn('ID_CLI', True)]
    property Id_Cli: Integer read FId_Cli write FId_Cli;
    [TDBColumn('NOME')]
    property Nome: String read FNome write FNome;
    [TDBColumn('TIPO')]
    property Tipo: String read FTipo write FTipo;
    [TDBColumn('CPF', False, False, True)]
    property Cpf: String read FCpf write FCpf;
    [TDBColumn('CNPJ', False, False, True)]
    property Cnpj: String read FCnpj write FCnpj;
    [TDBColumn('IE', False, False, True)]
    property Ie: String read FIe write FIe;
    [TDBColumn('ENDERECO', False, False, True)]
    property Endereco: String read FEndereco write FEndereco;
    [TDBColumn('N_LOGRADOURO', False, False, True)]
    property N_Logradouro: String read FN_Logradouro write FN_Logradouro;
    [TDBColumn('BAIRRO', False, False, True)]
    property Bairro: String read FBairro write FBairro;
    [TDBColumn('CIDADE', False, False, True)]
    property Cidade: String read FCidade write FCidade;
    [TDBColumn('ESTADO', False, False, True)]
    property Estado: String read FEstado write FEstado;
    [TDBColumn('CEP', False, False, True)]
    property Cep: String read FCep write FCep;
    [TDBColumn('CELULAR', False, False, True)]
    property Celular: String read FCelular write FCelular;
    [TDBColumn('TELEFONE', False, False, True)]
    property Telefone: String read FTelefone write FTelefone;
    [TDBColumn('COMPLEMENTO', False, False, True)]
    property Complemento: String read FComplemento write FComplemento;
    [TDBColumn('EMAIL', False, False, True)]
    property Email: String read FEmail write FEmail;
    [TDBColumn('DATA_CADASTRO')]
    property Data_Cadastro: TDateTime read FData_Cadastro write FData_Cadastro;
    [TDBColumn('DATA_ALTERACAO', False, False, True)]
    property Data_Alteracao: TDateTime read FData_Alteracao write FData_Alteracao;
    [TDBColumn('STATUS_CLI')]
    property Status_Cli: String read FStatus_Cli write FStatus_Cli;

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
    procedure GeraCodigo;
  end;

implementation

{ TModelCliente }

procedure TModelCliente.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelCliente.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelCliente.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPK(Self);
end;

function TModelCliente.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelCliente.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelCliente.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelCliente.Existe(const pId: Integer;
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
      lQuery.SQL.Add(' SELECT ID_CLI FROM CLIENTES   ');
      lQuery.SQL.Add(' WHERE ID_CLI = :ID            ');
      lQuery.ParamByName('ID').AsInteger := pId;
      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        if (pCarrega) then
        begin
          FId_Cli := pId;
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
        TfrmMensagem.TelaMensagem('Erro!', 'Erro ao realizar a consulta: ' + E.Message, tmErro);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

procedure TModelCliente.GeraCodigo;
var
  lQuery : TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID_CLI) AS ID FROM CLIENTES');

      //  Ultimo codigo usado + 1
      FId_Cli := lQuery.FieldByName('ID').AsInteger + 1;

      //  Insere o registro no final da tabela
      lQuery.Append;
    except
      on E : Exception do
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Erro ao obter próximo ID de CR: ' + E.Message, tmErro);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelCliente.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelCliente.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelCliente.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelCliente.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelCliente.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelCliente.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
