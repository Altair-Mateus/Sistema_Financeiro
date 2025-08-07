unit SistemaFinanceiro.Model.Entidades.Fornecedor;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils,
  fMensagem,
  uEnumsUtils;

type
  TModelFornecedor = class
  private
    FDaoRTTI: TDaoRTTI;
    FId_Fornec: Integer;
    FData_Alteracao: TDateTime;
    FCnpj: String;
    FEmail: String;
    FBairro: String;
    FRazao_Social: String;
    FData_Cadastro: TDateTime;
    FStatus_For: Boolean;
    FCpf: String;
    FCep: String;
    FIe: String;
    FNome_Fantasia: String;
    FComplemento: String;
    FN_Logradouro: String;
    FCidade: String;
    FTipo: String;
    FEndereco: String;
    FTelefone: String;
    FEstado: String;
    FCelular: String;

  public
    [TDBColumn('ID_FORNEC'), TDBIsPrimaryKey]
    property Id_Fornec: Integer read FId_Fornec write FId_Fornec;
    [TDBColumn('RAZAO_SOCIAL')]
    property Razao_Social: String read FRazao_Social write FRazao_Social;
    [TDBColumn('TIPO')]
    property Tipo: String read FTipo write FTipo;
    [TDBColumn('NOME_FANTASIA'), TDBAcceptNull]
    property Nome_Fantasia: String read FNome_Fantasia write FNome_Fantasia;
    [TDBColumn('CPF'), TDBAcceptNull]
    property Cpf: String read FCpf write FCpf;
    [TDBColumn('CNPJ'), TDBAcceptNull]
    property Cnpj: String read FCnpj write FCnpj;
    [TDBColumn('IE'), TDBAcceptNull]
    property Ie: String read FIe write FIe;
    [TDBColumn('ENDERECO'), TDBAcceptNull]
    property Endereco: String read FEndereco write FEndereco;
    [TDBColumn('N_LOGRADOURO'), TDBAcceptNull]
    property N_Logradouro: String read FN_Logradouro write FN_Logradouro;
    [TDBColumn('BAIRRO'), TDBAcceptNull]
    property Bairro: String read FBairro write FBairro;
    [TDBColumn('CIDADE'), TDBAcceptNull]
    property Cidade: String read FCidade write FCidade;
    [TDBColumn('ESTADO'), TDBAcceptNull]
    property Estado: String read FEstado write FEstado;
    [TDBColumn('CEP'), TDBAcceptNull]
    property Cep: String read FCep write FCep;
    [TDBColumn('CELULAR'), TDBAcceptNull]
    property Celular: String read FCelular write FCelular;
    [TDBColumn('TELEFONE'), TDBAcceptNull]
    property Telefone: String read FTelefone write FTelefone;
    [TDBColumn('COMPLEMENTO'), TDBAcceptNull]
    property Complemento: String read FComplemento write FComplemento;
    [TDBColumn('EMAIL'), TDBAcceptNull]
    property Email: String read FEmail write FEmail;
    [TDBColumn('DATA_CADASTRO')]
    property Data_Cadastro: TDateTime read FData_Cadastro write FData_Cadastro;
    [TDBColumn('DATA_ALTERACAO'), TDBAcceptNull]
    property Data_Alteracao: TDateTime read FData_Alteracao
      write FData_Alteracao;
    [TDBColumn('STATUS_FOR'), TDBSaveBoolean(btAI)]
    property Status_For: Boolean read FStatus_For write FStatus_For;

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
    procedure GeraCodigo;
  end;

implementation

{ TModelFornecedor }

procedure TModelFornecedor.AddPropertyToWhere(const APropertyName: String);
begin
  FDaoRTTI.AddPropertyToWhere(APropertyName);
end;

constructor TModelFornecedor.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelFornecedor.DeleteByPk: Boolean;
begin
  Result := FDaoRTTI.DeleteByPk(Self);
end;

function TModelFornecedor.DeleteByProp: Boolean;
begin
  Result := FDaoRTTI.DeleteByProp(Self);
end;

function TModelFornecedor.DeleteBySQLText(const pWhere: String): Boolean;
begin
  Result := FDaoRTTI.DeleteBySQLText(Self, pWhere);
end;

destructor TModelFornecedor.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelFornecedor.Existe(const pId: Integer;
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
      lQuery.SQL.Add(' SELECT ID_FORNEC FROM FORNECEDORES ');
      lQuery.SQL.Add(' WHERE ID_FORNEC = :ID            ');
      lQuery.ParamByName('ID').AsInteger := pId;
      lQuery.Open;

      if (lQuery.RecordCount > 0) then
      begin
        if (pCarrega) then
        begin
          FId_Fornec := pId;
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
        TfrmMensagem.TelaMensagem('Erro!', 'Erro ao realizar a consulta: ' +
          E.Message, tmErro);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

procedure TModelFornecedor.GeraCodigo;
var
  lQuery: TSFQuery;
begin
  lQuery := TSFQuery.Create(nil);
  try
    try
      lQuery.Close;
      lQuery.SQL.Clear;
      lQuery.Open('SELECT MAX(ID_FORNEC) AS ID FROM FORNECEDORES');

      // Ultimo codigo usado + 1
      FId_Fornec := lQuery.FieldByName('ID').AsInteger + 1;

      // Insere o registro no final da tabela
      lQuery.Append;
    except
      on E: Exception do
      begin
        TfrmMensagem.TelaMensagem('Erro!',
          'Erro ao obter próximo ID de Fornecedores: ' + E.Message, tmErro);
      end;
    end;
  finally
    lQuery.Free;
  end;

end;

function TModelFornecedor.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelFornecedor.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelFornecedor.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

function TModelFornecedor.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelFornecedor.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelFornecedor.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
