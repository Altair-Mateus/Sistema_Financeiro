unit SistemaFinanceiro.View.CpDetalhe;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  System.ImageList,
  Vcl.ImgList,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  SistemaFinanceiro.Model.Entidades.CP,
  fMensagem,
  System.StrUtils,
  SistemaFinanceiro.Model.uSFQuery,
  System.Math;

type
  TfrmCpDetalhe = class(TForm)
    ImageList1: TImageList;
    pnlBotoes: TPanel;
    btnVoltar: TButton;
    pnlPesquisa: TPanel;
    lblTValorParcela: TLabel;
    lblTValorCompra: TLabel;
    lblValorCompra: TLabel;
    lblValorParcela: TLabel;
    lblTCodFornec: TLabel;
    lblCodFornec: TLabel;
    lblNumParcela: TLabel;
    lblVencimento: TLabel;
    lblDesc: TLabel;
    lblNumDoc: TLabel;
    lblTNDoc: TLabel;
    lblTDesc: TLabel;
    lblTVencimento: TLabel;
    lblTNumParcela: TLabel;
    DataSourcePgto: TDataSource;
    DataSourceParciais: TDataSource;
    edtDtPag: TEdit;
    lblDtPag: TLabel;
    lblValorPago: TLabel;
    edtValPago: TEdit;
    lblNomeUser: TLabel;
    edtUser: TEdit;
    lblVlDesc: TLabel;
    edtValDesc: TEdit;
    lblObsPag: TLabel;
    edtObsPag: TEdit;
    pnlInfopag: TPanel;
    pnlPrincipal: TPanel;
    pnlGrids: TPanel;
    pnlGridFormasPagamento: TPanel;
    DBGridPgto: TDBGrid;
    lblFrPgto: TLabel;
    pnlGridParciais: TPanel;
    DBGridParciais: TDBGrid;
    lblParciais: TLabel;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FTelaAtiva: Boolean;
    FIdCp: Integer;
    FCp: TModelCP;
    FDetalhesCp: TModelCpDetalhe;
    FQueryPgtos, FQueryParcias: TSFQuery;

    procedure CriarObjetos;
    procedure DestruirObjetos;
    function InicializaCampos: Boolean;

    function CarregaDadosCp: Boolean;
    procedure CarregaDadosCpNaTela;
    function CarregaDadosDetalhesCp: Boolean;
    procedure CarregaDadosDetalhesCpNaTela;
    function CarregaPagamentos: Boolean;
    procedure CarregaParciais;
    procedure GrdParciaisVisivel(const pTemParciais: Boolean);
    procedure DefineTamanhoTela(const pTemParciais: Boolean);

  public
    property IdCp: Integer read FIdCp write FIdCp;
  end;

var
  frmCpDetalhe: TfrmCpDetalhe;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Utilitarios,
  uEnumsUtils;

{ TfrmCpDetalhe }

procedure TfrmCpDetalhe.btnVoltarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

function TfrmCpDetalhe.CarregaDadosCp: Boolean;
begin
  Result := False;

  FCp.ID := FIdCp;
  if (FCp.LoadObjectByPK) then
  begin
    CarregaDadosCpNaTela;
    Result := True;
  end;
end;

procedure TfrmCpDetalhe.CarregaDadosCpNaTela;
begin

  lblNumDoc.Caption := IfThen(FCp.Doc.Trim.IsEmpty, 'Não Informado', FCp.Doc);
  lblDesc.Caption := FCp.Desc;
  lblVencimento.Caption := FormatDateTime('DD/MM/YYYY', FCp.DataVencimento);
  lblNumParcela.Caption := IntToStr(FCp.Parcela);
  lblValorCompra.Caption := TUtilitario.FormatoMoeda(FCp.ValorCompra);
  lblValorParcela.Caption := TUtilitario.FormatoMoeda(FCp.ValorParcela);
  lblCodFornec.Caption := IntToStr(FCp.IdFornecedor);

end;

function TfrmCpDetalhe.CarregaDadosDetalhesCp: Boolean;
begin
  Result := False;

  if (FDetalhesCp.ExistePorCp(FIdCp, True)) then
  begin
    CarregaDadosDetalhesCpNaTela;
    Result := True;
  end;
end;

procedure TfrmCpDetalhe.CarregaDadosDetalhesCpNaTela;
begin
  edtDtPag.Text := FormatDateTime('DD/MM/YYYY', FDetalhesCp.Data);
  edtValPago.Text := TUtilitario.FormatoMoeda(FDetalhesCp.Valor);
  edtValDesc.Text := TUtilitario.FormatoMoeda(FDetalhesCp.ValorDesc);
  edtUser.Text := IntToStr(FDetalhesCp.Usuario);
  edtObsPag.Text := FDetalhesCp.Detalhes;
end;

function TfrmCpDetalhe.CarregaPagamentos: Boolean;
begin

  Result := False;

  FQueryPgtos.Close;
  FQueryPgtos.SQL.Clear;
  FQueryPgtos.SQL.Text := 'SELECT PG.*, FR.NOME_FR FROM PGTO_BX_CP PG ' +
    'LEFT JOIN FR_PGTO FR ON PG.ID_FR_PGTO = FR.ID_FR ' +
    'WHERE PG.ID_CP = :IDCP';

  FQueryPgtos.ParamByName('IDCP').AsInteger := FIdCp;
  FQueryPgtos.Prepare;
  FQueryPgtos.Open;

  DBGridPgto.DataSource.DataSet := FQueryPgtos;

  Result := (not FQueryPgtos.IsEmpty);
end;

procedure TfrmCpDetalhe.CarregaParciais;
begin
  FQueryParcias.Close;
  FQueryParcias.SQL.Clear;
  FQueryParcias.SQL.Text := 'SELECT * FROM CONTAS_PAGAR WHERE PARCIAL = :SN ' +
    ' AND CP_ORIGEM = :IDCP';

  FQueryParcias.ParamByName('SN').AsString := 'S';
  FQueryParcias.ParamByName('IDCP').AsInteger := FIdCp;
  FQueryParcias.Open;

  ShowMessage(IntToStr(FQueryParcias.RecordCount));

  DBGridParciais.DataSource.DataSet := FQueryParcias;

end;

procedure TfrmCpDetalhe.CriarObjetos;
begin
  FCp := TModelCP.Create;
  FDetalhesCp := TModelCpDetalhe.Create;
  FQueryPgtos := TSFQuery.Create(nil);
  FQueryParcias := TSFQuery.Create(nil);
end;

procedure TfrmCpDetalhe.DefineTamanhoTela(const pTemParciais: Boolean);
begin
  Height := IfThen(pTemParciais, 710, 540);
end;

procedure TfrmCpDetalhe.DestruirObjetos;
begin
  FCp.Free;
  FDetalhesCp.Free;
  FQueryPgtos.Free;
  FQueryParcias.Free;
end;

procedure TfrmCpDetalhe.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin

    if not(InicializaCampos) then
    begin
      TfrmMensagem.TelaMensagem('Erro!', 'Não foi possível carregar os dados da Conta selecionada.', tmErro);
      TUtilitario.FecharFormulario(Self);
      Exit;
    end;

    FTelaAtiva := True;
  end;
end;

procedure TfrmCpDetalhe.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;
  CriarObjetos;
end;

procedure TfrmCpDetalhe.FormDestroy(Sender: TObject);
begin
  DestruirObjetos;
end;

procedure TfrmCpDetalhe.GrdParciaisVisivel(const pTemParciais: Boolean);
begin
  pnlGridParciais.Visible := pTemParciais;
end;

function TfrmCpDetalhe.InicializaCampos: Boolean;
var
  lTemParciais: Boolean;
begin

  Result := False;
  lTemParciais := False;

  if not((CarregaDadosCp) and (CarregaDadosDetalhesCp) and (CarregaPagamentos)) then
    Exit;

  CarregaParciais;
  lTemParciais := (not DBGridParciais.DataSource.DataSet.IsEmpty);
  GrdParciaisVisivel(lTemParciais);
  DefineTamanhoTela(lTemParciais);

  Result := True;
end;

end.
