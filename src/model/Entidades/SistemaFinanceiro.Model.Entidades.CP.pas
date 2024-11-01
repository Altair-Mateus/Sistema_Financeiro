unit SistemaFinanceiro.Model.Entidades.CP;

interface

uses
  uDBAttributes,
  uDaoRTTI,
  SistemaFinanceiro.Model.uSFQuery,
  System.SysUtils;

type

  [TDBTable('CONTAS_RECEBER')]
  TModelCP = class

  private
    FDaoRTTI: TDaoRTTI;
    FID: String;
    FValorParcela: Double;
    FDataCompra: TDate;
    FDataVencimento: TDate;
    FDataPagamento: TDate;
    FValorAbatido: Double;
    FValorCompra: Double;
    FStatus: String;
    FDataCadastro: TDate;
    FDoc: String;
    FDesc: String;
    FParcela: Integer;
    FParcial: String;
    FCpOrigem: Integer;
    FIdFornecedor: Integer;
    FFatCartao: String;
    FIdFatCartao: Integer;
    FIdGrupoParcelas: Integer;
    FNumTotalParcelas: Integer;

  public
    [TDBColumn('ID'), TDBIsPrimaryKey]
    property ID: String read FID write FID;
    [TDBColumn('NUMERO_DOC'), TDBAcceptNull]
    property Doc: String read FDoc write FDoc;
    [TDBColumn('DESCRICAO'), TDBAcceptNull]
    property Desc: String read FDesc write FDesc;
    [TDBColumn('PARCELA')]
    property Parcela: Integer read FParcela write FParcela;
    [TDBColumn('VALOR_PARCELA')]
    property ValorParcela: Double read FValorParcela write FValorParcela;
    [TDBColumn('VALOR_COMPRA')]
    property ValorCompra: Double read FValorCompra write FValorCompra;
    [TDBColumn('VALOR_ABATIDO')]
    property ValorAbatido: Double read FValorAbatido write FValorAbatido;
    [TDBColumn('DATA_COMPRA')]
    property DataCompra: TDate read FDataCompra write FDataCompra;
    [TDBColumn('DATA_CADASTRO')]
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;
    [TDBColumn('DATA_VENCIMENTO')]
    property DataVencimento: TDate read FDataVencimento write FDataVencimento;
    [TDBColumn('DATA_PAGAMENTO')]
    property DataPagamento: TDate read FDataPagamento write FDataPagamento;
    [TDBColumn('STATUS')]
    property Status: String read FStatus write FStatus;
    [TDBColumn('PARCIAL')]
    property Parcial: String read FParcial write FParcial;
    [TDBColumn('CP_ORIGEM')]
    property CpOrigem: Integer read FCpOrigem write FCpOrigem;
    [TDBColumn('ID_FORNECEDOR')]
    property IdFornecedor: Integer read FIdFornecedor write FIdFornecedor;
    [TDBColumn('FATURA_cART')]
    property FatCartao: String read FFatCartao write FFatCartao;
    [TDBColumn('ID_FATURA')]
    property IdFatCartao: Integer read FIdFatCartao write FIdFatCartao;
    [TDBColumn('NUM_TOT_PARCELAS'), TDBAcceptNull]
    property NumTotalParcelas: Integer read FNumTotalParcelas write FNumTotalParcelas;
    [TDBColumn('ID_GRUPO_PARCELAS'), TDBAcceptNull]
    property IdGrupoParcelas: Integer read FIdGrupoParcelas write FIdGrupoParcelas;

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
    procedure GeraCodigo;

    class function TotalCP(pDtIni, pDtFim: TDate) : Double;
    class function GetIdGrupoParcelas : Integer;

    function CancBxCp : Boolean;

  end;

implementation

{ TModelCP }


procedure TModelCP.AddPropertyToWhere(const APropertyName: String);
begin

end;

function TModelCP.CancBxCp: Boolean;
begin

end;

constructor TModelCP.Create;
begin
  FDaoRTTI := TDaoRTTI.Create;
  ResetPropertiesToDefault;
end;

function TModelCP.DeleteByPk: Boolean;
begin

end;

function TModelCP.DeleteByProp: Boolean;
begin

end;

function TModelCP.DeleteBySQLText(const pWhere: String): Boolean;
begin

end;

destructor TModelCP.Destroy;
begin
  FDaoRTTI.Free;
  inherited;
end;

function TModelCP.Existe(const pId: Integer; const pCarrega: Boolean): Boolean;
begin

end;

procedure TModelCP.GeraCodigo;
begin

end;

class function TModelCP.GetIdGrupoParcelas: Integer;
begin

end;

function TModelCP.Insert: Boolean;
begin
  Result := FDaoRTTI.Insert(Self);
end;

function TModelCP.LoadObjectByPK: Boolean;
begin
  Result := FDaoRTTI.LoadObjectByPK(Self);
end;

procedure TModelCP.ResetPropertiesToDefault;
begin
  FDaoRTTI.ResetPropertiesToDefault(Self);
end;

class function TModelCP.TotalCP(pDtIni, pDtFim: TDate): Double;
begin

end;

function TModelCP.UpdateByPK: Boolean;
begin
  Result := FDaoRTTI.UpdateByPK(Self);
end;

function TModelCP.UpdateByProp: Boolean;
begin
  Result := FDaoRTTI.UpdateByProp(Self);
end;

function TModelCP.UpdateBySQLText(const pWhereClause: string): Boolean;
begin
  Result := FDaoRTTI.UpdateBySQLText(Self, pWhereClause);
end;

end.
