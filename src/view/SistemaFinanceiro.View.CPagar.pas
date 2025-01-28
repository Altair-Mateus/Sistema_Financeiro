unit SistemaFinanceiro.View.CPagar;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  SistemaFinanceiro.View.CadastroPadrao,
  Data.DB,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.WinXPanels,
  Vcl.ComCtrls,
  Vcl.WinXCtrls,
  Datasnap.DBClient,
  System.SysUtils,
  SistemaFinanceiro.View.BaixarCP,
  Vcl.Menus,
  SistemaFinanceiro.View.CpDetalhe,
  Vcl.Imaging.pngimage,
  SistemaFinanceiro.View.Fornecedores,
  SistemaFinanceiro.View.FaturaCartao,
  SistemaFinanceiro.View.BxMultiplaCp,
  SistemaFinanceiro.View.Consulta.ConsultaLancamentoPadraoContas,
  fMensagem,
  uEnumsUtils,
  SistemaFinanceiro.Model.uSFQuery;

type
  TfrmContasPagar = class(TfrmCadastroPadrao)
    DataSourceCPagar: TDataSource;
    lblDesc: TLabel;
    memDesc: TMemo;
    dateCompra: TDateTimePicker;
    lblDataCompra: TLabel;
    edtValorCompra: TEdit;
    lblValorCompra: TLabel;
    toggleParcelamento: TToggleSwitch;
    lblParcelamento: TLabel;
    CardPanelParcela: TCardPanel;
    cardParcelaUnica: TCard;
    cardParcelamento: TCard;
    lblParcela: TLabel;
    edtParcela: TEdit;
    edtValorParcela: TEdit;
    lblValorParcela: TLabel;
    dateVencimento: TDateTimePicker;
    lblVencimento: TLabel;
    edtQtdParcelas: TEdit;
    lblQtdParcelas: TLabel;
    edtIntervaloDias: TEdit;
    lblIntervaloDias: TLabel;
    btnGerar: TButton;
    btnLimpar: TButton;
    DBGridParcelas: TDBGrid;
    cdsParcelas: TClientDataSet;
    dsParcelas: TDataSource;
    cdsParcelasPARCELA: TIntegerField;
    cdsParcelasVALOR: TCurrencyField;
    cdsParcelasVENCIMENTO: TDateField;
    cdsParcelasDOCUMENTO: TWideStringField;
    cbStatus: TComboBox;
    lblStatus: TLabel;
    gbLegenda: TGroupBox;
    pnlPagas: TPanel;
    lblPagas: TLabel;
    pnlVencida: TPanel;
    lblVencida: TLabel;
    lblCancelada: TLabel;
    lblNormal: TLabel;
    pnlNormal: TPanel;
    pnlCancelada: TPanel;
    edtNDoc: TEdit;
    lblNDoc: TLabel;
    gbFiltros: TGroupBox;
    rbDataVenc: TRadioButton;
    rbValorParcela: TRadioButton;
    rbValorCompra: TRadioButton;
    rbDataCompra: TRadioButton;
    rbId: TRadioButton;
    cbData: TComboBox;
    lblData: TLabel;
    dateFinal: TDateTimePicker;
    lblDataFinal: TLabel;
    lblDataInicial: TLabel;
    dateInicial: TDateTimePicker;
    btnBaixarCP: TButton;
    btnDetalhes: TButton;
    Image2: TImage;
    lblCP: TLabel;
    lblDiaFixo: TLabel;
    edtDiaFixoVcto: TEdit;
    checkDiaFixoVcto: TCheckBox;
    pnlParciais: TPanel;
    checkParciais: TCheckBox;
    checkVencidas: TCheckBox;
    lblFornecedor: TLabel;
    edtFornecedor: TEdit;
    btnPesquisaFornecedor: TButton;
    lblNomeFornecedor: TLabel;
    lblFornecedorFiltro: TLabel;
    edtFiltroFornecedor: TEdit;
    btnPesqFornecedor: TButton;
    lblFatura: TLabel;
    toggleFatura: TToggleSwitch;
    lblCodFatCartao: TLabel;
    edtCodFatCartao: TEdit;
    btnPesqFat: TButton;
    lblNomeFatCartao: TLabel;
    btnPesqFtCartao: TButton;
    edtFiltroFatCartao: TEdit;
    lblCodFtCartao: TLabel;
    pnlAviso: TPanel;
    pnlImgAviso: TPanel;
    imgAviso: TImage;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    btnBxMultipla: TButton;
    pnlTotais: TPanel;
    lblQtdCp: TLabel;
    lblTotalCpGrid: TLabel;
    lblTQtdCo: TLabel;
    lblTValorCp: TLabel;
    CheckFatVirada: TCheckBox;
    PopupMenu: TPopupMenu;
    CancelarBaixa1: TMenuItem;
    checkNaoConsideraFatura: TCheckBox;
    chkBaixarAoSalvar: TCheckBox;
    pnlFundoAvisoFatura: TPanel;
    pnlMensagemAviso: TPanel;
    lblAvisoFatura: TLabel;
    pnlFundoGrupoParcelas: TPanel;
    lblGrupoParcelas: TLabel;
    grdGrupoParcelas: TDBGrid;
    btnLancPadrao: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure toggleParcelamentoClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorCompraExit(Sender: TObject);
    procedure edtValorParcelaExit(Sender: TObject);
    procedure btnBaixarCPClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DataSourceCPagarDataChange(Sender: TObject; Field: TField);
    procedure btnDetalhesClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure checkDiaFixoVctoClick(Sender: TObject);
    procedure btnPesquisaFornecedorClick(Sender: TObject);
    procedure btnPesqFornecedorClick(Sender: TObject);
    procedure toggleFaturaClick(Sender: TObject);
    procedure btnPesqFatClick(Sender: TObject);
    procedure edtCodFatCartaoExit(Sender: TObject);
    procedure edtFornecedorExit(Sender: TObject);
    procedure btnPesqFtCartaoClick(Sender: TObject);
    procedure btnBxMultiplaClick(Sender: TObject);
    procedure CheckFatViradaClick(Sender: TObject);
    procedure CancelarBaixa1Click(Sender: TObject);
    procedure checkNaoConsideraFaturaClick(Sender: TObject);
    procedure chkBaixarAoSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLancPadraoClick(Sender: TObject);
    procedure CardCadastroEnter(Sender: TObject);
    procedure PesquisaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FTelaAtiva: Boolean;
    FOpCad: TOperacaoCadastro;
    FCodCP: Integer;
    DataVctoFat: Integer;
    FQueryPesquisa, FQueryGrupoParcelas: TSFQuery;

    procedure HabilitaBotoes;
    procedure CadParcelaUnica;
    procedure CadParcelamento;
    procedure EditarRegCPagar;
    procedure ExibeTelaBaixar(pCodCP: Integer);
    procedure ExibeTelaBxMultipla;
    procedure ExibeDetalhe;
    procedure BuscaNomeFornecedor;
    procedure BuscaNomeFatCartao;
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure GeraParcelas;
    procedure FatCartaoAtiva;
    procedure CalcCpGrid;
    procedure CalcQtdCpGrid;
    procedure ExibeTelaLancPadrao;
    procedure CarregaLancPadrao(pCod: Integer);
    function DtVencimentoCheckContaPaga: TDate;

    function ValidaPesquisa: Boolean;
    procedure QuerySTATUSGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

  public
    { Public declarations }

  protected
    procedure Pesquisar; override;

  end;

var
  frmContasPagar: TfrmContasPagar;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Model.dmCPagar,
  SistemaFinanceiro.Utilitarios,
  System.DateUtils, SistemaFinanceiro.View.Principal,
  SistemaFinanceiro.View.Relatorios.Cp, SistemaFinanceiro.Model.dmFornecedores,
  SistemaFinanceiro.Model.dmFaturaCartao, SistemaFinanceiro.Model.dmUsuarios,
  SistemaFinanceiro.View.BaixarCP.FrPgto,
  SistemaFinanceiro.Model.Entidades.LancamentoPadraoContas;

procedure TfrmContasPagar.btnAlterarClick(Sender: TObject);
begin
  EditarRegCPagar;
end;

procedure TfrmContasPagar.btnBaixarCPClick(Sender: TObject);
begin

  ExibeTelaBaixar(DataSourceCPagar.DataSet.FieldByName('ID').AsInteger);

end;

procedure TfrmContasPagar.btnBxMultiplaClick(Sender: TObject);
begin

  ExibeTelaBxMultipla;

end;

procedure TfrmContasPagar.btnCancelarClick(Sender: TObject);
begin

  inherited;
  // Cancelando inclus�o
  dmCPagar.cdsCPagar.Cancel;

end;

procedure TfrmContasPagar.btnDetalhesClick(Sender: TObject);
begin
  inherited;

  if DataSourceCPagar.DataSet.FieldByName('STATUS').AsString <> 'P' then
  begin

    Application.MessageBox
      ('Conta n�o paga, realize a baixa para ver os detalhes!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  ExibeDetalhe;

end;

procedure TfrmContasPagar.btnExcluirClick(Sender: TObject);
var
  option: Word;

begin
  inherited;

  // Se o documento j� foi baixado cancela a exclus�o
  if dmCPagar.cdsCPagarSTATUS.AsString = 'P' then
  begin
    Application.MessageBox('Documento j� pago n�o pode ser cancelado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Se o documento foi cancelado, a exclus�o � cancelada
  if dmCPagar.cdsCPagarSTATUS.AsString = 'C' then
  begin
    Application.MessageBox('Documento j� cancelado n�o pode ser cancelado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  option := Application.MessageBox('Deseja cancelar o registro? ',
    'Confirma��o', MB_YESNO + MB_ICONQUESTION);

  if option = IDNO then
  begin
    exit;
  end;

  try
    dmCPagar.cdsCPagar.Edit;
    dmCPagar.cdsCPagarSTATUS.AsString := 'C';
    dmCPagar.cdsCPagar.Post;
    dmCPagar.cdsCPagar.ApplyUpdates(0);

    Application.MessageBox('Documento cancelado com sucesso!', 'Aten��o',
      MB_OK + MB_ICONINFORMATION);

    Pesquisar;

    // Atualiza o relatorio na tela inicial
    frmPrincipal.TotalCP;

  except
    on E: Exception do
      Application.MessageBox(PWidechar(E.Message),
        'Erro ao cancelar documento!', MB_OK + MB_ICONERROR);
  end;

end;

procedure TfrmContasPagar.btnGerarClick(Sender: TObject);
begin
  GeraParcelas;
end;

procedure TfrmContasPagar.btnImprimirClick(Sender: TObject);
begin
  inherited;

  // Cria o form
  frmRelCp := TfrmRelCp.Create(Self);

  try

    // Desativa a atualiza��o visual do grid
    DataSourceCPagar.DataSet.DisableControls;
    frmRelCp.DataSourceCp.DataSet := DataSourceCPagar.DataSet;

    // Mostra a pre visualiza��o
    frmRelCp.RLReport.Preview();

  finally

    FreeAndNil(frmRelCp);
    // Ativa a atualiza��o visual do grid novamente
    DataSourceCPagar.DataSet.EnableControls;

  end;

  Pesquisar;

end;

procedure TfrmContasPagar.btnIncluirClick(Sender: TObject);
begin
  FOpCad := ocIncluir;
  inherited;

  lblTitulo.Caption := 'Inserindo um novo lan�amento no Contas a Pagar';

  if not(dmCPagar.cdsCPagar.State in [dsInsert, dsEdit]) then
  begin

    // Colocando o data set em modo de inser��o de dados
    dmCPagar.cdsCPagar.Insert;

  end;

  // Seta parcela previamente como 1
  edtParcela.Text := '1';

  // Esvaziando data set de parcelas
  cdsParcelas.EmptyDataSet;

  // Liberacoes e bloqueios
  edtQtdParcelas.Enabled := True;
  edtIntervaloDias.Enabled := True;
  edtDiaFixoVcto.Enabled := False;
  checkDiaFixoVcto.Checked := False;
  checkDiaFixoVcto.Enabled := True;
  chkBaixarAoSalvar.Checked := False;
  CheckFatVirada.Checked := False;
  btnGerar.Enabled := True;
  btnLimpar.Enabled := False;
  toggleFatura.State := tssOff;
  toggleParcelamento.State := tssOff;
  toggleParcelamento.Enabled := True;
  edtParcela.ReadOnly := True;
  edtValorParcela.ReadOnly := True;
  lblNomeFornecedor.Visible := False;
  lblNomeFatCartao.Visible := False;

  // Coloca a data atual no datetimepicker
  dateCompra.DateTime := Now;
  dateVencimento.DateTime := Now + 7;

  memDesc.SetFocus;

end;

procedure TfrmContasPagar.btnLancPadraoClick(Sender: TObject);
begin
  ExibeTelaLancPadrao;
end;

procedure TfrmContasPagar.btnLimparClick(Sender: TObject);
begin
  inherited;

  // Esvaziando data set de parcelas
  cdsParcelas.EmptyDataSet;

  // Libera��es
  edtQtdParcelas.Enabled := True;
  btnGerar.Enabled := True;
  btnLimpar.Enabled := False;

  edtQtdParcelas.Clear;

  if DataVctoFat = 0 then
  begin

    checkDiaFixoVcto.Checked := False;
    checkDiaFixoVcto.Enabled := True;
    edtDiaFixoVcto.Enabled := True;
    edtIntervaloDias.Enabled := True;
    edtIntervaloDias.Clear;
    edtDiaFixoVcto.Clear;

  end;

end;

procedure TfrmContasPagar.btnPesqFatClick(Sender: TObject);
begin

  // Cria o form
  frmFaturaCartao := TfrmFaturaCartao.Create(Self);

  try

    // Exibe o form
    frmFaturaCartao.ShowModal;

  finally

    // Pega a Id da fatura selecionada
    edtCodFatCartao.Text := frmFaturaCartao.DataSourceFaturaCartao.DataSet.
      FieldByName('ID_FT').AsString;
    edtCodFatCartao.SetFocus;

    // Libera da mem�ria
    FreeAndNil(frmFaturaCartao);

  end;

end;

procedure TfrmContasPagar.btnPesqFornecedorClick(Sender: TObject);
begin
  inherited;

  // Cria o form
  frmFornecedores := TfrmFornecedores.Create(Self);

  try

    // Exibe o form
    frmFornecedores.ShowModal;

  finally

    // Pega a ID do cliente selecionado
    edtFiltroFornecedor.Text := frmFornecedores.DataSourceFornecedor.DataSet.
      FieldByName('ID_FORNEC').AsString;

    // Libera da  memoria
    FreeAndNil(frmFornecedores);

  end;

  Pesquisar;

end;

procedure TfrmContasPagar.btnPesqFtCartaoClick(Sender: TObject);
begin
  inherited;

  // Cria o form
  frmFaturaCartao := TfrmFaturaCartao.Create(Self);

  try

    // Exibe o form
    frmFaturaCartao.ShowModal;

  finally

    // Pega a Id da fatura selecionada
    edtFiltroFatCartao.Text := frmFaturaCartao.DataSourceFaturaCartao.DataSet.
      FieldByName('ID_FT').AsString;

    // Libera da mem�ria
    FreeAndNil(frmFaturaCartao);

  end;

  Pesquisar;

end;

procedure TfrmContasPagar.btnPesquisaFornecedorClick(Sender: TObject);
begin

  // Cria o form
  frmFornecedores := TfrmFornecedores.Create(Self);

  try

    // Exibe o form
    frmFornecedores.ShowModal;

  finally

    // Pega a ID do cliente selecionado
    edtFornecedor.Text := frmFornecedores.DataSourceFornecedor.DataSet.
      FieldByName('ID_FORNEC').AsString;

    // Libera da  memoria
    FreeAndNil(frmFornecedores);

  end;

  edtFornecedor.SetFocus;

end;

procedure TfrmContasPagar.btnSalvarClick(Sender: TObject);
begin

  if toggleParcelamento.State = tssOff then
  begin
    CadParcelaUnica;
    if (chkBaixarAoSalvar.Checked) and (FCodCP > 0) then
      ExibeTelaBaixar(FCodCP);
  end
  else
  begin
    CadParcelamento;
  end;

  // Retorna ao card de pesquisa
  CardPanelPrincipal.ActiveCard := CardPesquisa;

  // Atualiza a lista
  Pesquisar;

  // Atualiza relatorio tela principal
  frmPrincipal.TotalCP;

end;

procedure TfrmContasPagar.BuscaNomeFatCartao;
var
  NomeFatCartao: String;

begin

  if Trim(edtCodFatCartao.Text) <> '' then
  begin

    NomeFatCartao := dmFaturaCartao.GetNomeFatCartao
      (Trim(edtCodFatCartao.Text));

    if NomeFatCartao = '' then
    begin

      Application.MessageBox('Fatura de Cart�o n�o encontrada!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      edtCodFatCartao.SetFocus;
      edtCodFatCartao.Clear;
      abort;

    end;

    lblNomeFatCartao.Caption := NomeFatCartao;
    lblNomeFatCartao.Visible := True;

    DataVctoFat := dmFaturaCartao.GetDataVcto(Trim(edtCodFatCartao.Text));
    dateVencimento.Date := EncodeDate(YearOf(dateVencimento.Date),
      MonthOf(dateVencimento.Date), DataVctoFat);

  end;

end;

procedure TfrmContasPagar.BuscaNomeFornecedor;
var
  NomeFornecedor: String;

begin

  if Trim(edtFornecedor.Text) <> '' then
  begin

    NomeFornecedor := dmFornecedores.GetNomeFornecedor
      (Trim(edtFornecedor.Text));

    if NomeFornecedor = '' then
    begin

      Application.MessageBox('Fornecedor n�o encontrado!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      edtFornecedor.SetFocus;
      edtFornecedor.Clear;

    end;

    lblNomeFornecedor.Visible := True;
    lblNomeFornecedor.Caption := NomeFornecedor;

  end;

end;

procedure TfrmContasPagar.CadParcelamento;
var
  ValorCompra: Currency;
  IdFornecedor: Integer;

begin

  // Valida valor da compra
  if not TryStrToCurr(edtValorCompra.Text, ValorCompra) then
  begin

    edtValorCompra.SetFocus;
    Application.MessageBox('Valor da Compra inv�lido!', 'Aten��o',
      MB_OK + MB_ICONWARNING);
    abort;

  end;

  if not TryStrToInt(edtFornecedor.Text, IdFornecedor) then
  begin

    edtFornecedor.SetFocus;
    Application.MessageBox('Campo FORNECEDOR n�o pode estar vazio!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  // Posiciona no primeiro registro do cds
  cdsParcelas.First;

  if cdsParcelas.IsEmpty then
  begin

    edtQtdParcelas.SetFocus;
    Application.MessageBox('Parcelas n�o geradas!', 'Aten��o',
      MB_OK + MB_ICONWARNING);
    abort;

  end;

  // Valida todos os registros do cds
  while not cdsParcelas.Eof do
  begin

    if cdsParcelasPARCELA.AsInteger < 0 then
    begin
      Application.MessageBox('N�mero de Parcela Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONWARNING);
      abort;
    end;

    if cdsParcelasVALOR.AsCurrency < 0.01 then
    begin
      Application.MessageBox('Valor da Parcela Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONWARNING);
      abort;
    end;

    // Avan�a para o pr�ximo registro
    cdsParcelas.Next;

  end;

  // Posiciona no primeiro registro do cds
  cdsParcelas.First;

  // Gravando Parcelas
  while not cdsParcelas.Eof do
  begin

    if dmCPagar.cdsCPagar.State in [dsBrowse, dsInactive] then
    begin
      dmCPagar.cdsCPagar.Insert;
    end;

    dmCPagar.GeraCodigo;
    dmCPagar.cdsCPagarDATA_CADASTRO.AsDateTime := Now;
    dmCPagar.cdsCPagarSTATUS.AsString := 'A';
    dmCPagar.cdsCPagarVALOR_ABATIDO.AsCurrency := 0;
    dmCPagar.cdsCPagarNUMERO_DOC.AsString := cdsParcelasDOCUMENTO.AsString;
    dmCPagar.cdsCPagarDESCRICAO.AsString := Format('%s - Parcela %d',
      [memDesc.Text, cdsParcelasPARCELA.AsInteger]);
    dmCPagar.cdsCPagarVALOR_COMPRA.AsCurrency := ValorCompra;
    dmCPagar.cdsCPagarDATA_COMPRA.AsDateTime := dateCompra.Date;
    dmCPagar.cdsCPagarPARCELA.AsInteger := cdsParcelasPARCELA.AsInteger;
    dmCPagar.cdsCPagarVALOR_PARCELA.AsCurrency := cdsParcelasVALOR.AsCurrency;
    dmCPagar.cdsCPagarDATA_VENCIMENTO.AsDateTime :=
      cdsParcelasVENCIMENTO.AsDateTime;
    dmCPagar.cdsCPagarPARCIAL.AsString := 'N';
    dmCPagar.cdsCPagarID_FORNECEDOR.AsInteger := IdFornecedor;

    if toggleFatura.State = tssOff then
    begin

      dmCPagar.cdsCPagarFATURA_CART.AsString := 'N';

    end
    else
    begin

      dmCPagar.cdsCPagarFATURA_CART.AsString := 'S';
      dmCPagar.cdsCPagarID_FATURA.AsString := Trim(edtCodFatCartao.Text);

    end;

    // Gravando no banco
    dmCPagar.cdsCPagar.Post;
    dmCPagar.cdsCPagar.ApplyUpdates(0);

    cdsParcelas.Next;

  end;

  Application.MessageBox('Parcelas Cadastradas com Sucesso!!', 'Aten��o',
    MB_OK + MB_ICONINFORMATION);

  Pesquisar;

  CardPanelPrincipal.ActiveCard := CardPesquisa;
end;

procedure TfrmContasPagar.CadParcelaUnica;
var
  Parcela: Integer;
  ValorCompra: Currency;
  ValorParcela: Currency;
  IdFornecedor: Integer;

begin

  // Valida campos obrigatorios
  if Trim(memDesc.Text) = '' then
  begin
    memDesc.SetFocus;
    Application.MessageBox('Campo DESCRICAO n�o pode estar vazio!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToInt(edtFornecedor.Text, IdFornecedor) or (IdFornecedor <= 0)
  then
  begin
    edtFornecedor.SetFocus;
    Application.MessageBox('Campo FORNECEDOR n�o pode estar vazio!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if (not TryStrToCurr(edtValorCompra.Text, ValorCompra)) or (ValorCompra <= 0)
  then
  begin
    edtValorCompra.SetFocus;
    Application.MessageBox('Valor da compra Inv�lido!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if (not TryStrToInt(edtParcela.Text, Parcela)) or (Parcela <= 0) then
  begin
    edtParcela.SetFocus;
    Application.MessageBox('N�mero da parcela Inv�lido!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if dateVencimento.Date < dateCompra.Date then
  begin
    dateVencimento.SetFocus;
    Application.MessageBox
      ('Data de vencimento n�o pode ser inferior a data de compra!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if dateCompra.Date > Now then
  begin
    dateCompra.SetFocus;
    Application.MessageBox
      ('Data de compra n�o pode ser maior que a data atual!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToCurr(edtValorParcela.Text, ValorParcela) then
  begin
    edtValorParcela.SetFocus;
    Application.MessageBox('Valor da parcela Inv�lido!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Se for um novo registro ir� gerar o c�digo, status em aberto
  // e setar 0 no valor abatido
  if DataSourceCPagar.State in [dsInsert] then
  begin

    // gera a id
    dmCPagar.GeraCodigo;

    dmCPagar.cdsCPagarDATA_CADASTRO.AsDateTime := Now;
    dmCPagar.cdsCPagarSTATUS.AsString := 'A';
    dmCPagar.cdsCPagarVALOR_ABATIDO.AsCurrency := 0;

  end;

  // Passando os dados para o dataset
  dmCPagar.cdsCPagarNUMERO_DOC.AsString := Trim(edtNDoc.Text);
  dmCPagar.cdsCPagarDESCRICAO.AsString := Trim(memDesc.Text);
  dmCPagar.cdsCPagarVALOR_COMPRA.AsCurrency := ValorCompra;
  dmCPagar.cdsCPagarDATA_COMPRA.AsDateTime := dateCompra.Date;
  dmCPagar.cdsCPagarPARCELA.AsInteger := Parcela;
  dmCPagar.cdsCPagarVALOR_PARCELA.AsCurrency := ValorParcela;
  dmCPagar.cdsCPagarPARCIAL.AsString := 'N';
  dmCPagar.cdsCPagarID_FORNECEDOR.AsInteger := IdFornecedor;

  if chkBaixarAoSalvar.Checked then
    FCodCP := dmCPagar.cdsCPagarID.AsInteger;

  // Verifica se � fatura, se for a data de vcto
  // ser� pega a da fatura
  if (toggleFatura.State = tssOn) and (edtCodFatCartao.Text <> '') then
  begin
    dateVencimento.Date := EncodeDate(YearOf(dateVencimento.Date),
      MonthOf(dateVencimento.Date), DataVctoFat);
  end;
  dmCPagar.cdsCPagarDATA_VENCIMENTO.AsDateTime := dateVencimento.Date;

  if toggleFatura.State = tssOff then
  begin
    dmCPagar.cdsCPagarFATURA_CART.AsString := 'N';
  end
  else
  begin
    dmCPagar.cdsCPagarFATURA_CART.AsString := 'S';
    dmCPagar.cdsCPagarID_FATURA.AsString := Trim(edtCodFatCartao.Text);
  end;

  // Gravando no BD
  dmCPagar.cdsCPagar.Post;
  dmCPagar.cdsCPagar.ApplyUpdates(0);

end;

procedure TfrmContasPagar.CalcCpGrid;
var
  TotalCP: Currency;

begin

  TotalCP := 0;

  // Percorre e soma
  with DBGrid1.DataSource.DataSet do
  begin

    // Desativa o controle
    DisableControls;

    // Posiciona no primeiro reg
    First;

    while not Eof do
    begin

      TotalCP := TotalCP + FieldByName('VALOR_PARCELA').AsCurrency;

      Next;

    end;

    // Reativa o controle
    EnableControls;

    lblTotalCpGrid.Caption := TUtilitario.FormatoMoeda(TotalCP);

  end;

end;

procedure TfrmContasPagar.CalcQtdCpGrid;
var
  QtdCp: Integer;

begin

  QtdCp := 0;

  // Realiza a conta
  QtdCp := DBGrid1.DataSource.DataSet.RecordCount;

  // Exibe na label
  lblQtdCp.Caption := IntToStr(QtdCp);

end;

procedure TfrmContasPagar.CancelarBaixa1Click(Sender: TObject);
var
  IdCp: Integer;
  option: Word;

begin

  // Valida se o user logado � adm
  if not(dmUsuarios.GetUsuarioLogado.User_Admin = 'S') then
  begin

    Application.MessageBox('Somente Administradores podem cancelar uma Baixa!',
      'Erro', MB_OK + MB_ICONERROR);
    abort;

  end;

  if not DataSourceCPagar.DataSet.IsEmpty then
  begin

    // Bloqueia o cancelamento se a conta n�o estiver como PAGA
    if DataSourceCPagar.DataSet.FieldByName('STATUS').AsString <> 'P' then
    begin

      Application.MessageBox('Conta n�o baixada!!', 'Erro',
        MB_OK + MB_ICONERROR);
      abort;

    end;

    option := Application.MessageBox('Deseja cancelar o registro? ',
      'Confirma��o', MB_YESNO + MB_ICONQUESTION);

    if option = IDNO then
    begin
      exit;
    end;

    // Pega a id da conta
    IdCp := DataSourceCPagar.DataSet.FieldByName('ID').AsInteger;

    // Chama a procedure que fara o trabalho
    dmCPagar.CancBxCP(IdCp);

    Pesquisar;

    // Atualiza relatorio tela principal
    frmPrincipal.TotalCP;
    frmPrincipal.ResumoMensalCaixa;

  end;

end;

procedure TfrmContasPagar.CardCadastroEnter(Sender: TObject);
begin
  inherited;
  btnLancPadrao.Visible := (FOpCad = ocIncluir);
end;

procedure TfrmContasPagar.CarregaLancPadrao(pCod: Integer);
var
  lLancamento: TModelLancamentoPadrao;
begin
  lLancamento := TModelLancamentoPadrao.Create;
  try
    if (lLancamento.Existe(pCod, True)) then
    begin

      if (lLancamento.Status = Smallint(scInativo)) then
      begin
        TfrmMensagem.TelaMensagem('Cadastro Inativo!',
          'Lan�amento Padr�o inativo, altere o cadastro do mesmo e tente novamente.',
          tmAviso);
        exit;
      end;

      memDesc.Text := lLancamento.Descricao;
      if (lLancamento.Id_Fornecedor > 0) then
        edtFornecedor.Text := IntToStr(lLancamento.Id_Fornecedor);
      BuscaNomeFornecedor;
      memDesc.SetFocus;
    end
    else
    begin
      TfrmMensagem.TelaMensagem('Erro!',
        'Erro ao recuperar os dados do cadastro do Lan�amento Padr�o escolhido',
        tmErro);
    end;
  finally
    lLancamento.Free;
  end;
end;

procedure TfrmContasPagar.checkDiaFixoVctoClick(Sender: TObject);
begin
  inherited;

  if checkDiaFixoVcto.Checked then
  begin

    edtDiaFixoVcto.Visible := True;
    edtDiaFixoVcto.Enabled := True;
    lblDiaFixo.Visible := True;
    edtIntervaloDias.Enabled := False;
    edtIntervaloDias.Text := '30';
    Label9.Visible := True;

    edtDiaFixoVcto.SetFocus;

  end
  else
  begin

    edtDiaFixoVcto.Visible := False;
    edtDiaFixoVcto.Enabled := False;
    lblDiaFixo.Visible := False;
    edtIntervaloDias.Enabled := True;
    edtIntervaloDias.Clear;
    Label9.Visible := False;

  end;

end;

procedure TfrmContasPagar.CheckFatViradaClick(Sender: TObject);
begin

  // Pula o m�s de vencimento caso seja CP p1
  if CheckFatVirada.Checked then
  begin

    if toggleParcelamento.State = tssOff then
    begin

      dateVencimento.Date := IncMonth(dateVencimento.Date, 1);

    end;
  end
  else
  begin
    dateVencimento.Date := IncMonth(dateVencimento.Date, -1);
  end;

end;

procedure TfrmContasPagar.checkNaoConsideraFaturaClick(Sender: TObject);
begin
  inherited;

  // Bloqueia as faturas de cart�o
  if checkNaoConsideraFatura.Checked then
  begin

    btnPesqFtCartao.Enabled := False;
    edtFiltroFatCartao.Enabled := False;
    edtFiltroFatCartao.Clear;

  end
  else
  begin

    btnPesqFtCartao.Enabled := True;
    edtFiltroFatCartao.Enabled := True;

  end;

  PesquisaClick(Sender);
end;

procedure TfrmContasPagar.chkBaixarAoSalvarClick(Sender: TObject);
begin
  dateVencimento.Date := DtVencimentoCheckContaPaga;
end;

procedure TfrmContasPagar.DataSourceCPagarDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  btnDetalhes.Enabled := DataSourceCPagar.DataSet.FieldByName('STATUS')
    .AsString = 'P';
  btnBaixarCP.Enabled := DataSourceCPagar.DataSet.FieldByName('STATUS')
    .AsString = 'A';

end;

procedure TfrmContasPagar.DBGrid1DblClick(Sender: TObject);
begin
  EditarRegCPagar;
end;

procedure TfrmContasPagar.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  // Altera a cor das duplicatas vencidas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
    (DBGrid1.DataSource.DataSet.FieldByName('DATA_VENCIMENTO').AsDateTime <
    Date) and (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'A')
  then
  begin
    DBGrid1.Canvas.Font.Color := clRed; // Define a cor do texto da c�lula
  end;

  // Altera a cor das duplicatas pagas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
    (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'P') then
  begin
    DBGrid1.Canvas.Font.Color := clHotLight; // Define a cor do texto da c�lula
  end;

  // Altera a cor das duplicatas canceladas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
    (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'C') then
  begin
    DBGrid1.Canvas.Font.Color := $00E68AE5; // Define a cor do texto da c�lula
  end;

  // Desenha a c�lula com as propriedades de cor atualizadas
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  inherited;

end;

procedure TfrmContasPagar.EditarRegCPagar;
begin

  FOpCad := ocAlterar;

  // Abre a tela de cadastro
  CardPanelPrincipal.ActiveCard := CardCadastro;

  // Se o documento j� foi baixado cancela a edi��o
  if dmCPagar.cdsCPagarSTATUS.AsString = 'P' then
  begin

    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� pago n�o pode ser alterado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  // Se o documento foi cancelado, a edi��o � cancelada
  if dmCPagar.cdsCPagarSTATUS.AsString = 'C' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� cancelado n�o pode ser alterado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  // Coloca o dataset em modo de edi��o
  dmCPagar.cdsCPagar.Edit;

  edtParcela.Enabled := True;
  edtValorParcela.Enabled := True;

  // Esvaziando data set de parcelas
  cdsParcelas.EmptyDataSet;

  // Coloca o numero do registro no titulo
  lblTitulo.Caption := 'Alterando Registro N� ' + dmCPagar.cdsCPagarID.AsString;

  // Bloqueia o toogle de parcelamento
  toggleParcelamento.Enabled := False;
  toggleParcelamento.State := tssOff;
  CardPanelParcela.ActiveCard := cardParcelaUnica;
  edtParcela.ReadOnly := True;
  CheckFatVirada.Visible := False;
  CheckFatVirada.Checked := False;

  edtValorParcela.ReadOnly := False;
  chkBaixarAoSalvar.Checked := False;

  // Carrega os dados
  edtNDoc.Text := dmCPagar.cdsCPagarNUMERO_DOC.AsString;
  memDesc.Text := dmCPagar.cdsCPagarDESCRICAO.AsString;
  edtValorCompra.Text := TUtilitario.FormatarValor
    (dmCPagar.cdsCPagarVALOR_COMPRA.AsCurrency);
  edtParcela.Text := dmCPagar.cdsCPagarPARCELA.AsString;
  edtValorParcela.Text := TUtilitario.FormatarValor
    (dmCPagar.cdsCPagarVALOR_PARCELA.AsString);
  dateVencimento.Date := dmCPagar.cdsCPagarDATA_VENCIMENTO.AsDateTime;
  dateCompra.Date := dmCPagar.cdsCPagarDATA_COMPRA.AsDateTime;
  edtFornecedor.Text := dmCPagar.cdsCPagarID_FORNECEDOR.AsString;

  // Verifica se a CP foi vinculado a uma fatura de cart�o
  if dmCPagar.cdsCPagarFATURA_CART.AsString = 'S' then
  begin

    toggleFatura.State := tssOn;
    lblCodFatCartao.Visible := True;
    lblNomeFatCartao.Visible := True;
    edtCodFatCartao.Visible := True;
    btnPesqFat.Visible := True;

    edtCodFatCartao.Text := dmCPagar.cdsCPagarID_FATURA.AsString;
    BuscaNomeFatCartao;

  end
  else
  begin

    toggleFatura.State := tssOff;
    edtCodFatCartao.Clear;

  end;

  BuscaNomeFornecedor;

end;

procedure TfrmContasPagar.edtCodFatCartaoExit(Sender: TObject);
begin

  BuscaNomeFatCartao;

  if Trim(edtCodFatCartao.Text) <> '' then
  begin

    if dmFaturaCartao.GetStatusFatCartao(Trim(edtCodFatCartao.Text)) = False
    then
    begin

      edtCodFatCartao.Clear;
      edtCodFatCartao.SetFocus;
      lblNomeFatCartao.Caption := '';
      Application.MessageBox
        ('Fatura de Cart�o n�o est� Ativa, verifique o cadastro!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;

    if toggleParcelamento.State = tssOn then
    begin

      FatCartaoAtiva;

    end;

    if edtQtdParcelas.Text <> '' then
    begin

      GeraParcelas;

    end;

  end;

end;

procedure TfrmContasPagar.edtFornecedorExit(Sender: TObject);
begin
  inherited;

  BuscaNomeFornecedor;

  if Trim(edtFornecedor.Text) <> '' then
  begin

    if dmFornecedores.GetStatus(Trim(edtFornecedor.Text)) = False then
    begin

      edtFornecedor.Clear;
      edtFornecedor.SetFocus;
      lblNomeFornecedor.Caption := '';
      Application.MessageBox('Fornecedor n�o est� Ativo, verifique o cadastro!',
        'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;

  end;

end;

procedure TfrmContasPagar.edtValorCompraExit(Sender: TObject);
begin
  inherited;

  edtValorCompra.Text := TUtilitario.FormatarValor(edtValorCompra.Text);

  if dmCPagar.cdsCPagar.State in [dsInsert] then
  begin

    // Se ao inserir Parcela unica pega o mesmo valor da venda
    edtValorParcela.Text := TUtilitario.FormatarValor(edtValorCompra.Text);

  end;

end;

procedure TfrmContasPagar.edtValorParcelaExit(Sender: TObject);
begin
  inherited;
  edtValorParcela.Text := TUtilitario.FormatarValor(edtValorParcela.Text);

end;

procedure TfrmContasPagar.ExibeDetalhe;
begin

  // cria o form
  frmCpDetalhe := TfrmCpDetalhe.Create(Self);
  try

    frmCpDetalhe.ExibirCPDetalhes(DataSourceCPagar.DataSet.FieldByName('ID')
      .AsInteger);

    // Exibe o form
    frmCpDetalhe.ShowModal;

  finally

    FreeAndNil(frmCpDetalhe);

  end;

end;

procedure TfrmContasPagar.ExibeTelaBaixar(pCodCP: Integer);
begin

  // Cria o form
  frmBaixarCP := TfrmBaixarCP.Create(Self);

  try

    frmBaixarCP.BaixarCP(pCodCP);

    // Exibe o form
    frmBaixarCP.ShowModal;

  finally

    FreeAndNil(frmBaixarCP);

  end;

  Pesquisar;

  // Atualiza relatorio tela principal
  frmPrincipal.TotalCP;
  frmPrincipal.ResumoMensalCaixa;

end;

procedure TfrmContasPagar.ExibeTelaBxMultipla;
begin

  // Cria o form
  frmBxMultiplaCP := TfrmBxMultiplaCP.Create(Self);

  try

    // Exibe o form
    frmBxMultiplaCP.ShowModal;

  finally

    FreeAndNil(frmBxMultiplaCP);

  end;

  Pesquisar;

  // Atualiza relatorio tela principal
  frmPrincipal.TotalCP;
  frmPrincipal.ResumoMensalCaixa;

end;

procedure TfrmContasPagar.ExibeTelaLancPadrao;
var
  lFormulario: TfrmConsultaLancamentoPadraoContas;
begin
  lFormulario := TfrmConsultaLancamentoPadraoContas.Create(Self, tlCp);
  try
    lFormulario.ShowModal;
    CarregaLancPadrao(lFormulario.grdLancPadrao.DataSource.DataSet.FieldByName
      ('ID').AsInteger);
  finally
    lFormulario.Free;
  end;
end;

procedure TfrmContasPagar.FatCartaoAtiva;
begin

  if toggleFatura.State = tssOn then
  begin

    checkDiaFixoVcto.Checked := True;
    checkDiaFixoVcto.Enabled := False;
    edtDiaFixoVcto.Text := IntToStr(DataVctoFat);
    edtDiaFixoVcto.Enabled := False;

  end;

end;

procedure TfrmContasPagar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  TUtilitario.SalvarOrdemColunasParaJSON(DBGrid1, 'ConfigGrids', 'grdCP');
end;

procedure TfrmContasPagar.FormCreate(Sender: TObject);
begin
  inherited;

  FTelaAtiva := False;

  edtValorCompra.OnKeyPress := KeyPressValor;
  edtValorParcela.OnKeyPress := KeyPressValor;

  // Define as datas da consulta
  dateInicial.Date := StartOfTheMonth(Now);
  dateFinal.Date := EndOfTheMonth(Now);

end;

procedure TfrmContasPagar.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FQueryPesquisa) then
    FQueryPesquisa.Free;

  if Assigned(FQueryGrupoParcelas) then
    FQueryGrupoParcelas.Free;
end;

procedure TfrmContasPagar.FormShow(Sender: TObject);
begin
  inherited;
  TUtilitario.CarregarOrdemColunasJSON(DBGrid1, 'ConfigGrids', 'grdCP');
  FTelaAtiva := True;
end;

procedure TfrmContasPagar.GeraParcelas;
var
  lQtdParcelas: Integer;
  lIntervaloDias: Integer;
  lValorCompra: Double;
  lValorParcela: Double;
  lValorResiduo: Double;
  lContador: Integer;
  lDiaFixoVcto: Integer;
  lDataPrimeiraParcela: TDateTime;

  function ValidarCampos: Boolean;
  begin
    Result := True;

    if (not TryStrToFloat(edtValorCompra.Text, lValorCompra)) or
      (lValorCompra <= 0) then
    begin
      edtValorCompra.SetFocus;
      Application.MessageBox('Valor da compra Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end
    else if dateCompra.Date > Now then
    begin
      dateCompra.SetFocus;
      Application.MessageBox
        ('Data de compra n�o pode ser maior que a data atual!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end
    else if not TryStrToInt(edtQtdParcelas.Text, lQtdParcelas) or
      (lQtdParcelas <= 1) then
    begin
      edtQtdParcelas.SetFocus;
      Application.MessageBox('N�meros de Parcelas Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end
    else if not TryStrToInt(edtIntervaloDias.Text, lIntervaloDias) then
    begin
      edtIntervaloDias.SetFocus;
      Application.MessageBox('Intervalo de dias Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end;
  end;

begin

  lDataPrimeiraParcela := 0;
  if not ValidarCampos then
    exit;

  // Calculando valores das parcelas
  lValorParcela := (Trunc(lValorCompra / lQtdParcelas * 100) / 100);
  lValorResiduo := lValorCompra - (lValorParcela * lQtdParcelas);

  // Inicializando dataset
  cdsParcelas.EmptyDataSet;

  // Definindo a data da primeira parcela
  if (toggleFatura.State = tssOn) and (edtCodFatCartao.Text <> '') then
  begin
    FatCartaoAtiva;
    lDiaFixoVcto := DataVctoFat;

    if CheckFatVirada.Checked then
      lDataPrimeiraParcela := IncMonth(dateCompra.Date, 2)
      // Vcto da parcela 1 para dois meses
    else
      lDataPrimeiraParcela := IncMonth(dateCompra.Date, 1);

    lDataPrimeiraParcela := EncodeDate(YearOf(lDataPrimeiraParcela),
      MonthOf(lDataPrimeiraParcela), lDiaFixoVcto);
  end
  else if checkDiaFixoVcto.Checked then
  begin
    if not TryStrToInt(edtDiaFixoVcto.Text, lDiaFixoVcto) or (lDiaFixoVcto > 28)
      or (lDiaFixoVcto < 1) then
    begin
      edtDiaFixoVcto.SetFocus;
      Application.MessageBox('Dia fixo de vencimento Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;

    lDataPrimeiraParcela := IncMonth(dateCompra.Date, 1);
    lDataPrimeiraParcela := EncodeDate(YearOf(lDataPrimeiraParcela),
      MonthOf(lDataPrimeiraParcela), lDiaFixoVcto);
  end;

  // Gerando parcelas
  for lContador := 1 to lQtdParcelas do
  begin
    cdsParcelas.Insert;
    cdsParcelasPARCELA.AsInteger := lContador;
    cdsParcelasVALOR.AsFloat := lValorParcela + lValorResiduo;
    lValorResiduo := 0;

    if checkDiaFixoVcto.Checked then
      cdsParcelasVENCIMENTO.AsDateTime :=
        EncodeDate(YearOf(IncMonth(lDataPrimeiraParcela, lContador - 1)),
        MonthOf(IncMonth(lDataPrimeiraParcela, lContador - 1)), lDiaFixoVcto)
    else
      cdsParcelasVENCIMENTO.AsDateTime :=
        IncDay(dateCompra.Date, lIntervaloDias * lContador);

    if not(Trim(edtNDoc.Text).IsEmpty) then
      cdsParcelasDOCUMENTO.AsString := Trim(edtNDoc.Text) + '-' +
        IntToStr(lContador);

    cdsParcelas.Post;
  end;

  // Bloqueios
  edtQtdParcelas.Enabled := False;
  edtIntervaloDias.Enabled := False;
  edtDiaFixoVcto.Enabled := False;
  checkDiaFixoVcto.Enabled := False;
  btnGerar.Enabled := False;
  btnLimpar.Enabled := True;
end;

procedure TfrmContasPagar.HabilitaBotoes;
begin

  btnAlterar.Enabled := not DataSourceCPagar.DataSet.IsEmpty;
  btnExcluir.Enabled := not DataSourceCPagar.DataSet.IsEmpty;
  btnBaixarCP.Enabled := not DataSourceCPagar.DataSet.IsEmpty;
  btnDetalhes.Enabled := not DataSourceCPagar.DataSet.IsEmpty;
  btnImprimir.Enabled := not DataSourceCPagar.DataSet.IsEmpty;

end;

procedure TfrmContasPagar.KeyPressValor(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    // Verifica se a tecla pressionada � o Enter
    // Cancela o efeito do enter
    Key := #0;
    // Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  // Se for digitado um ponto, ser� convertido para virgula
  if Key = FormatSettings.ThousandSeparator then
  begin
    Key := #0;
  end;

  // Permite apenas digitar os caracteres dentro do charinset
  if not(CharInSet(Key, ['0' .. '9', FormatSettings.DecimalSeparator, #8, #13]))
  then
  begin
    Key := #0;
  end;

  // Valida se j� existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and
    (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

procedure TfrmContasPagar.PesquisaClick(Sender: TObject);
begin
  if (FTelaAtiva) then
    Pesquisar;
end;

procedure TfrmContasPagar.Pesquisar;
var
  LFiltroEdit: String;
  LFiltro: String;
  LOrdem: String;

begin

  LFiltroEdit := '';
  LFiltro := '';
  LOrdem := '';

  if not(ValidaPesquisa) then
    exit;

  if (Assigned(FQueryPesquisa)) then
    FreeAndNil(FQueryPesquisa);

  FQueryPesquisa := TSFQuery.Create(nil);
  try

    // Pr� pesquisa para funcionar o likefind
    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add
      (' SELECT FIRST 1 CP.*, F.RAZAO_SOCIAL FROM CONTAS_PAGAR CP LEFT JOIN FORNECEDORES F ');
    FQueryPesquisa.SQL.Add(' ON CP.ID_FORNECEDOR = F.ID_FORNEC ');
    FQueryPesquisa.Open;

    // Configura��es do DataSet para o DBGrid
    DBGrid1.DataSource.DataSet := FQueryPesquisa;

    LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, DBGrid1);

    // Pesquisa por tipo
    case cbStatus.ItemIndex of
      1:
        LFiltro := LFiltro + ' AND CP.STATUS = ''P'' ';
      2:
        LFiltro := LFiltro + ' AND CP.STATUS = ''A'' ';
      3:
        LFiltro := LFiltro + ' AND CP.STATUS = ''C'' ';
    end;

    // Pesquisa por data
    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin

      case cbData.ItemIndex of

        0:
          LFiltro := LFiltro + ' AND CP.DATA_COMPRA BETWEEN :DTINI AND :DTFIM ';
        1:
          LFiltro := LFiltro +
            ' AND CP.DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM ';
        2:
          LFiltro := LFiltro +
            ' AND CP.DATA_PAGAMENTO BETWEEN :DTINI AND :DTFIM ';

      end;

    end;

    // Pesquisa parciais
    if checkParciais.Checked then
      LFiltro := LFiltro + ' AND CP.PARCIAL = ''S'' ';

    // Pesquisa vencidas
    if checkVencidas.Checked then
      LFiltro := LFiltro +
        ' AND CP.STATUS = ''A'' AND CP.DATA_VENCIMENTO < :DATUAL ';

    // Pesquisa por FORNECEDORES
    if Trim(edtFiltroFornecedor.Text) <> '' then
      LFiltro := LFiltro + ' AND CP.ID_FORNECEDOR = :ID ';

    // Pesquisa por Fatura de Cartao
    if Trim(edtFiltroFatCartao.Text) <> '' then
      LFiltro := LFiltro + ' AND CP.ID_FATURA = :ID_FT ';

    // Pesquisa Sem Fatura de cart�o
    if checkNaoConsideraFatura.Checked then
      LFiltro := LFiltro + 'AND FATURA_CART = ''N'' ';

    // Ordem de pesquisa
    if rbId.Checked then
      LOrdem := ' ORDER BY CP.ID DESC'
    else if rbDataVenc.Checked then
      LOrdem := ' ORDER BY CP.DATA_VENCIMENTO'
    else if rbValorParcela.Checked then
      LOrdem := ' ORDER BY CP.VALOR_PARCELA DESC'
    else if rbValorCompra.Checked then
      LOrdem := ' ORDER BY CP.VALOR_COMPRA DESC'
    else if rbDataCompra.Checked then
      LOrdem := ' ORDER BY CP.DATA_COMPRA DESC'
    else
      LOrdem := ' ORDER BY CP.ID DESC';

    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add('SELECT CP.*, F.RAZAO_SOCIAL FROM CONTAS_PAGAR CP ' +
      'LEFT JOIN FORNECEDORES F ON CP.ID_FORNECEDOR = F.ID_FORNEC WHERE 1 = 1 '
      + LFiltroEdit + LFiltro + LOrdem);

    // Criando os parametros
    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin
      FQueryPesquisa.ParamByName('DTINI').AsDate := dateInicial.Date;
      FQueryPesquisa.ParamByName('DTFIM').AsDate := dateFinal.Date;
    end;

    if (checkVencidas.Checked) then
      FQueryPesquisa.ParamByName('DATUAL').AsDate := Now;

    if not(Trim(edtFiltroFornecedor.Text).IsEmpty) then
      FQueryPesquisa.ParamByName('ID').AsString :=
        Trim(edtFiltroFornecedor.Text);

    if not(Trim(edtFiltroFatCartao.Text).IsEmpty) then
      FQueryPesquisa.ParamByName('ID_FT').AsString :=
        Trim(edtFiltroFatCartao.Text);


    FQueryPesquisa.Open;

    // Formata visualmente o campo de STATUS
    FQueryPesquisa.FieldByName('STATUS').OnGetText := QuerySTATUSGetText;

    HabilitaBotoes;

    // Calcula a quantidade e valor
    CalcCpGrid;
    CalcQtdCpGrid;

    // Posiciona no primeiro registro
    DataSourceCPagar.DataSet.First;

  except
    on E: Exception do
    begin
      TfrmMensagem.TelaMensagem('Erro!', 'Erro ao realizar consulta: ' +
        E.Message, tmErro);
    end;
  end;

end;

procedure TfrmContasPagar.QuerySTATUSGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = 'A' then
    Text := 'ABERTA'
  else if Sender.AsString = 'P' then
    Text := 'PAGA'
  else if Sender.AsString = 'C' then
    Text := 'CANCELADA';
end;

function TfrmContasPagar.DtVencimentoCheckContaPaga: TDate;
begin

  Result := dateVencimento.Date;

  if (chkBaixarAoSalvar.Checked) and (DataSourceCPagar.State = dsInsert) then
    Result := dateCompra.Date;

end;

procedure TfrmContasPagar.toggleFaturaClick(Sender: TObject);
begin

  if toggleFatura.State = tssOff then
  begin

    // Oculta as info de fatura
    lblCodFatCartao.Visible := False;
    lblNomeFatCartao.Visible := False;
    edtCodFatCartao.Clear;
    edtCodFatCartao.Visible := False;
    btnPesqFat.Visible := False;

    DataVctoFat := 0;

    if toggleParcelamento.State = tssOn then
    begin

      checkDiaFixoVcto.Checked := False;
      checkDiaFixoVcto.Enabled := True;
      edtDiaFixoVcto.Clear;
      edtDiaFixoVcto.Enabled := True;

    end;

    pnlFundoAvisoFatura.Visible := False;
    CheckFatVirada.Visible := False;

  end
  else
  begin

    // Oculta as info de fatura
    lblCodFatCartao.Visible := True;
    edtCodFatCartao.Visible := True;
    btnPesqFat.Visible := True;

    edtCodFatCartao.SetFocus;

    pnlFundoAvisoFatura.Visible := True;

    if not(dmCPagar.cdsCPagar.State in [dsEdit]) then
      CheckFatVirada.Visible := True;

  end;

end;

procedure TfrmContasPagar.toggleParcelamentoClick(Sender: TObject);
begin

  if toggleParcelamento.State = tssOff then
  begin

    CardPanelParcela.ActiveCard := cardParcelaUnica;

  end
  else if toggleParcelamento.State = tssOn then
  begin

    CardPanelParcela.ActiveCard := cardParcelamento;

    FatCartaoAtiva;

  end;
end;

function TfrmContasPagar.ValidaPesquisa: Boolean;
begin
  Result := False;

  if (dateInicial.Date > dateFinal.Date) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o',
      'Data Inicial n�o pode ser maior que a data Final!', tmAviso);
    dateFinal.SetFocus;
    exit;
  end;

  if (cbStatus.ItemIndex < 0) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o',
      'Selecione um tipo de STATUS!', tmAviso);
    cbStatus.SetFocus;
    exit;
  end;

  if (cbData.ItemIndex < 0) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o', 'Selecione um tipo de Data!', tmAviso);
    cbData.SetFocus;
    exit;
  end;
  Result := True;
end;

end.
