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
  SistemaFinanceiro.Model.uSFQuery,
  SistemaFinanceiro.Model.Entidades.CP,
  FireDAC.Stan.Param,
  System.DateUtils,
  SistemaFinanceiro.View.Relatorios.CP,
  SistemaFinanceiro.View.BaixarCP.FrPgto;

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
    dsGrupoParcelas: TDataSource;
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
    DataVctoFat: Integer;
    FQueryPesquisa, FQueryGrupoParcelas: TSFQuery;
    FCp: TModelCP;

    procedure HabilitaBotoes;
    function CadParcelaUnica: Boolean;
    function CadParcelamento: Boolean;
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
    procedure IncluirContaPagar;
    procedure PreparaInclusaoCp;
    function ValidaCadParcelaUnica: Boolean;
    function ValidaDadosGeraisIncCp: Boolean;
    function ValidaCadParcelamento: Boolean;
    function ValidaStatusCp: Boolean;
    procedure InicializaAlteracaoCp;
    procedure CarregaDadosAlteracao;
    function CarregaGrupoParcelas: Boolean;
    procedure InicializaTela;

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
  SistemaFinanceiro.Model.dmFornecedores,
  SistemaFinanceiro.Model.dmFaturaCartao,
  SistemaFinanceiro.Model.dmUsuarios,
  SistemaFinanceiro.View.Principal,
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

procedure TfrmContasPagar.btnDetalhesClick(Sender: TObject);
begin
  inherited;

  if DataSourceCPagar.DataSet.FieldByName('STATUS').AsString <> 'P' then
  begin

    Application.MessageBox
      ('Conta não paga, realize a baixa para ver os detalhes!', 'Atenção',
      MB_OK + MB_ICONEXCLAMATION);
    exit;

  end;

  ExibeDetalhe;

end;

procedure TfrmContasPagar.btnExcluirClick(Sender: TObject);
var
  lCp: TModelCP;
begin

  if not(ValidaStatusCp) then
    exit;

  lCp := TModelCP.Create;
  try
    try
      if (TfrmMensagem.TelaEscolha('Atenção', 'Deseja cancelar a conta selecionada? ', tmEscolha) = mrYes) then
      begin

        lCp.ID := DBGrid1.DataSource.DataSet.FieldByName('ID').AsInteger;
        if not(lCp.LoadObjectByPK) then
        begin
          TfrmMensagem.TelaMensagem('Erro!', 'Conta inválida!', tmErro);
          exit;
        end;

        lCp.Status := 'C';
        lCp.UpdateByPK;

        Pesquisar;

        // Atualiza o relatorio na tela inicial
        frmPrincipal.TotalCP;
      end;
    finally
      lCp.Free;
    end;
  except
    on E: Exception do
    begin
      TfrmMensagem.TelaMensagem('Erro', 'Erro ao excluir conta: ' + E.Message, tmErro);
    end;
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

    // Desativa a atualização visual do grid
    DataSourceCPagar.DataSet.DisableControls;
    frmRelCp.DataSourceCp.DataSet := DataSourceCPagar.DataSet;

    // Mostra a pre visualização
    frmRelCp.RLReport.Preview();

  finally

    FreeAndNil(frmRelCp);
    // Ativa a atualização visual do grid novamente
    DataSourceCPagar.DataSet.EnableControls;

  end;

  Pesquisar;

end;

procedure TfrmContasPagar.btnIncluirClick(Sender: TObject);
begin
  FOpCad := ocIncluir;

  // Dispara o evento do form pai para trocar a visualização do Card
  inherited;

  IncluirContaPagar;

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

  // Liberações
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

    // Libera da memória
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

    // Libera da memória
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
var
  lContaGravada: Boolean;
begin
  lContaGravada := False;
  try

    if not(ValidaDadosGeraisIncCp) then
      exit;

    if (toggleParcelamento.State = tssOff) then
      lContaGravada := CadParcelaUnica
    else
      lContaGravada := CadParcelamento;

    if not(lContaGravada) then
      exit;

    // Retorna ao card de pesquisa
    CardPanelPrincipal.ActiveCard := CardPesquisa;

    // Atualiza a lista
    Pesquisar;

    // Atualiza relatorio tela principal
    frmPrincipal.TotalCP;
  except
    on E: Exception do
    begin
      TfrmMensagem.TelaMensagem('Erro', 'Erro ao salvar Conta a Pagar: ' +
        E.Message, tmErro);
    end;
  end;

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

      Application.MessageBox('Fatura de Cartão não encontrada!', 'Atenção',
        MB_OK + MB_ICONEXCLAMATION);
      edtCodFatCartao.SetFocus;
      edtCodFatCartao.Clear;
      exit;

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

      Application.MessageBox('Fornecedor não encontrado!', 'Atenção',
        MB_OK + MB_ICONEXCLAMATION);
      edtFornecedor.SetFocus;
      edtFornecedor.Clear;

    end;

    lblNomeFornecedor.Visible := True;
    lblNomeFornecedor.Caption := NomeFornecedor;

  end;

end;

function TfrmContasPagar.CadParcelamento: Boolean;
var
  lParcelaCp: TModelCP;
  lQtdParcelas, lIdGrupoParcelas: Integer;
begin

  Result := False;

  if not(ValidaCadParcelamento) then
    exit;

  lQtdParcelas := cdsParcelas.RecordCount;
  lIdGrupoParcelas := TModelCP.GetIdGrupoParcelas;

  // Posiciona no primeiro registro do cds
  cdsParcelas.First;

  // Gravando Parcelas
  while not cdsParcelas.Eof do
  begin

    lParcelaCp := TModelCP.Create;
    try

      lParcelaCp.GeraCodigo;
      lParcelaCp.DataCadastro := Now;
      lParcelaCp.Status := 'A';
      lParcelaCp.ValorAbatido := 0;
      lParcelaCp.Doc := Trim(cdsParcelasDOCUMENTO.AsString);
      lParcelaCp.Desc := Format('%s - Parcela %d',
        [memDesc.Text, cdsParcelasPARCELA.AsInteger]);
      lParcelaCp.ValorCompra := StrToFloat(edtValorCompra.Text);
      lParcelaCp.DataCompra := dateCompra.Date;
      lParcelaCp.Parcela := cdsParcelasPARCELA.AsInteger;
      lParcelaCp.ValorParcela := cdsParcelasVALOR.AsCurrency;
      lParcelaCp.DataVencimento := cdsParcelasVENCIMENTO.AsDateTime;
      lParcelaCp.Parcial := 'N';
      lParcelaCp.FatCartao := 'N';
      lParcelaCp.IdFornecedor := StrToInt(edtFornecedor.Text);
      lParcelaCp.NumTotalParcelas := lQtdParcelas;
      lParcelaCp.IdGrupoParcelas := lIdGrupoParcelas;

      if (toggleFatura.State = tssOn) then
      begin
        lParcelaCp.FatCartao := 'S';
        lParcelaCp.IdFatCartao := StrToInt(edtCodFatCartao.Text);
      end;

      // Gravando no banco
      lParcelaCp.Insert;

    finally
      lParcelaCp.Free;
    end;

    cdsParcelas.Next;

  end;

  Result := True;

  TfrmMensagem.TelaMensagem('Informação', 'Parcelas Cadastradas com Sucesso!!',
    tmSucesso);

end;

function TfrmContasPagar.CadParcelaUnica: Boolean;
var
  lRegGravado: Boolean;
begin
  Result := False;
  lRegGravado := False;

  if not(ValidaCadParcelaUnica) then
    exit;

  if not(Assigned(FCp)) then
  begin
    TfrmMensagem.TelaMensagem('Erro', 'Erro ao inicializar processo para gravar a Conta', tmErro);
    exit;
  end;

  try

    FCp.IdFornecedor := StrToInt(edtFornecedor.Text);
    FCp.Doc := Trim(edtNDoc.Text);
    FCp.Desc := Trim(memDesc.Text);
    FCp.Parcela := StrToInt(edtParcela.Text);
    FCp.ValorParcela := StrToFloat(edtValorParcela.Text);
    FCp.ValorCompra := StrToFloat(edtValorCompra.Text);
    FCp.DataCompra := dateCompra.Date;
    FCp.Parcial := 'N';
    FCp.ValorAbatido := 0;
    FCp.Status := 'A';
    FCp.FatCartao := 'N';

    // Verifica se é fatura, se for a data de vcto
    // será pega a da fatura
    if (toggleFatura.State = tssOn) and (not(Trim(edtCodFatCartao.Text).IsEmpty))
    then
    begin
      dateVencimento.Date := EncodeDate(YearOf(dateVencimento.Date),
        MonthOf(dateVencimento.Date), DataVctoFat);

      FCp.FatCartao := 'S';
      FCp.IdFatCartao := StrToInt(edtCodFatCartao.Text);
    end;

    FCp.DataVencimento := dateVencimento.Date;

    // Gravando conta
    case FOpCad of

      ocIncluir:
        begin
          FCp.GeraCodigo;
          FCp.DataCadastro := Now;
          FCp.NumTotalParcelas := 1;
          lRegGravado := FCp.Insert;
        end;

      ocAlterar:
        begin
          lRegGravado := FCp.UpdateByPK;
        end;
    end;

    // Se foi marcado para baixar ao salvar e a conta foi salva irá exibir a tela da baixa
    if ((lRegGravado) and (chkBaixarAoSalvar.Checked)) then
      ExibeTelaBaixar(FCp.ID);

    Result := True;

  finally
    FreeAndNil(FCp);
  end;

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

  // Valida se o user logado é adm
  if not(dmUsuarios.GetUsuarioLogado.User_Admin = 'S') then
  begin

    Application.MessageBox('Somente Administradores podem cancelar uma Baixa!',
      'Erro', MB_OK + MB_ICONERROR);
    exit;

  end;

  if not DataSourceCPagar.DataSet.IsEmpty then
  begin

    // Bloqueia o cancelamento se a conta não estiver como PAGA
    if DataSourceCPagar.DataSet.FieldByName('STATUS').AsString <> 'P' then
    begin

      Application.MessageBox('Conta não baixada!!', 'Erro',
        MB_OK + MB_ICONERROR);
      exit;

    end;

    option := Application.MessageBox('Deseja cancelar o registro? ',
      'Confirmação', MB_YESNO + MB_ICONQUESTION);

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
          'Lançamento Padrão inativo, altere o cadastro do mesmo e tente novamente.',
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
        'Erro ao recuperar os dados do cadastro do Lançamento Padrão escolhido',
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

  // Pula o mês de vencimento caso seja CP p1
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

  // Bloqueia as faturas de cartão
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
    DBGrid1.Canvas.Font.Color := clRed; // Define a cor do texto da célula
  end;

  // Altera a cor das duplicatas pagas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
    (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'P') then
  begin
    DBGrid1.Canvas.Font.Color := clHotLight; // Define a cor do texto da célula
  end;

  // Altera a cor das duplicatas canceladas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
    (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'C') then
  begin
    DBGrid1.Canvas.Font.Color := $00E68AE5; // Define a cor do texto da célula
  end;

  // Desenha a célula com as propriedades de cor atualizadas
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  inherited;

  TUtilitario.FormatoMoedaGrid(TDBGrid(Sender), Column, Rect, State);

end;

procedure TfrmContasPagar.EditarRegCPagar;
begin

  if not(ValidaStatusCp) then
    exit;

  FOpCad := ocAlterar;

  if Assigned(FCp) then
    FreeAndNil(FCp);

  FCp := TModelCP.Create;

  try

    FCp.ID := DBGrid1.DataSource.DataSet.FieldByName('ID').AsInteger;

    if not(FCp.LoadObjectByPK) then
    begin
      TfrmMensagem.TelaMensagem('Erro!', 'Erro ao carregar dados da conta', tmErro);
      exit;
    end;

    // Abre a tela de cadastro
    CardPanelPrincipal.ActiveCard := CardCadastro;

    InicializaAlteracaoCp;
    CarregaDadosAlteracao;

  except

    on E: Exception do
    begin
      TfrmMensagem.TelaMensagem('Erro!', E.Message, tmErro);
      CardPanelPrincipal.ActiveCard := CardPesquisa;
    end;

  end;

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
        ('Fatura de Cartão não está Ativa, verifique o cadastro!', 'Atenção',
        MB_OK + MB_ICONEXCLAMATION);
      exit;

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
      Application.MessageBox('Fornecedor não está Ativo, verifique o cadastro!',
        'Atenção', MB_OK + MB_ICONEXCLAMATION);
      exit;

    end;

  end;

end;

procedure TfrmContasPagar.edtValorCompraExit(Sender: TObject);
begin
  inherited;

  edtValorCompra.Text := TUtilitario.FormatarValor(edtValorCompra.Text);

  if (FOpCad = ocIncluir) then
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

end;

procedure TfrmContasPagar.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FQueryPesquisa) then
    FQueryPesquisa.Free;

  if Assigned(FQueryGrupoParcelas) then
    FQueryGrupoParcelas.Free;

  if Assigned(FCp) then
    FCp.Free;
end;

procedure TfrmContasPagar.FormShow(Sender: TObject);
begin
  inherited;
  InicializaTela;
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
      Application.MessageBox('Valor da compra Inválido!', 'Atenção',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end
    else if dateCompra.Date > Now then
    begin
      dateCompra.SetFocus;
      Application.MessageBox
        ('Data de compra não pode ser maior que a data atual!', 'Atenção',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end
    else if not TryStrToInt(edtQtdParcelas.Text, lQtdParcelas) or
      (lQtdParcelas <= 1) then
    begin
      edtQtdParcelas.SetFocus;
      Application.MessageBox('Números de Parcelas Inválido!', 'Atenção',
        MB_OK + MB_ICONEXCLAMATION);
      Result := False;
    end
    else if not TryStrToInt(edtIntervaloDias.Text, lIntervaloDias) then
    begin
      edtIntervaloDias.SetFocus;
      Application.MessageBox('Intervalo de dias Inválido!', 'Atenção',
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
      Application.MessageBox('Dia fixo de vencimento Inválido!', 'Atenção',
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
    // Verifica se a tecla pressionada é o Enter
    // Cancela o efeito do enter
    Key := #0;
    // Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  // Se for digitado um ponto, será convertido para virgula
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

  // Valida se já existe o ponto decimal
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

    // Pré pesquisa para funcionar o likefind
    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add
      (' SELECT FIRST 1 CP.*, F.RAZAO_SOCIAL FROM CONTAS_PAGAR CP LEFT JOIN FORNECEDORES F ');
    FQueryPesquisa.SQL.Add(' ON CP.ID_FORNECEDOR = F.ID_FORNEC ');
    FQueryPesquisa.Open;

    // Configurações do DataSet para o DBGrid
    DBGrid1.DataSource.DataSet := FQueryPesquisa;

    LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, DBGrid1);

    // Pesquisa por tipo
    case cbStatus.ItemIndex of
      1:
        LFiltro := LFiltro + ' AND CP.STATUS = ''P'' ';
      2:
        LFiltro := LFiltro + ' AND CP.STATUS = ''A'' ';
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

    // Pesquisa Sem Fatura de cartão
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
    FQueryPesquisa.SQL.Add(' SELECT CP.*, F.RAZAO_SOCIAL, CAST(CP.PARCELA AS VARCHAR(10)) || ''/'' ');
    FQueryPesquisa.SQL.Add(' || CAST(CP.NUM_TOT_PARCELAS AS VARCHAR(10)) AS QTDPARC ');
    FQueryPesquisa.SQL.Add(' FROM CONTAS_PAGAR CP ');
    FQueryPesquisa.SQL.Add(' LEFT JOIN FORNECEDORES F ON CP.ID_FORNECEDOR = F.ID_FORNEC WHERE CP.STATUS <> ''C'' ');
    FQueryPesquisa.SQL.Add(LFiltroEdit + LFiltro + LOrdem);

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

procedure TfrmContasPagar.InicializaTela;
begin
  edtValorCompra.OnKeyPress := KeyPressValor;
  edtValorParcela.OnKeyPress := KeyPressValor;

  // Define as datas da consulta
  dateInicial.Date := StartOfTheMonth(Now);
  dateFinal.Date := EndOfTheMonth(Now);
  cbStatus.ItemIndex := 0;

  TUtilitario.CarregarOrdemColunasJSON(DBGrid1, 'ConfigGrids', 'grdCP');

  FTelaAtiva := True;
end;

procedure TfrmContasPagar.CarregaDadosAlteracao;
begin
  // Carrega os dados
  edtNDoc.Text := FCp.Doc;
  memDesc.Text := FCp.Desc;
  edtValorCompra.Text := TUtilitario.FormatarValor(FCp.ValorCompra);
  edtParcela.Text := IntToStr(FCp.Parcela);
  edtValorParcela.Text := TUtilitario.FormatarValor(FCp.ValorParcela);
  dateVencimento.Date := FCp.DataVencimento;
  dateCompra.Date := FCp.DataCompra;
  edtFornecedor.Text := IntToStr(FCp.IdFornecedor);
  BuscaNomeFornecedor;

  // Verifica se a CP foi vinculado a uma fatura de cartão
  if (FCp.FatCartao = 'S') then
  begin
    toggleFatura.State := tssOn;
    lblCodFatCartao.Visible := True;
    lblNomeFatCartao.Visible := True;
    edtCodFatCartao.Visible := True;
    btnPesqFat.Visible := True;
    edtCodFatCartao.Text := IntToStr(FCp.IdFatCartao);
    BuscaNomeFatCartao;
  end
  else
  begin
    toggleFatura.State := tssOff;
    edtCodFatCartao.Clear;
  end;

  // Verifica se a conta tem um grupo de parcelas
  if (FCp.IdGrupoParcelas > 0) then
  begin
    CarregaGrupoParcelas;
    pnlFundoGrupoParcelas.Visible := True;
  end
  else
  begin
    pnlFundoGrupoParcelas.Visible := False;
  end;
end;

function TfrmContasPagar.CarregaGrupoParcelas: Boolean;
begin
  Result := False;

  try
    if Assigned(FQueryGrupoParcelas) then
      FreeAndNil(FQueryGrupoParcelas);

    FQueryGrupoParcelas := TSFQuery.Create(nil);

    FQueryGrupoParcelas.Close;
    FQueryGrupoParcelas.SQL.Clear;
    FQueryGrupoParcelas.SQL.Add(' SELECT ID, VALOR_PARCELA, DATA_VENCIMENTO, STATUS,  ');
    FQueryGrupoParcelas.SQL.Add(' CAST(PARCELA AS VARCHAR(10)) || ''/''               ');
    FQueryGrupoParcelas.SQL.Add(' || CAST(NUM_TOT_PARCELAS AS VARCHAR(10)) AS QTDPARC ');
    FQueryGrupoParcelas.SQL.Add(' FROM CONTAS_PAGAR                                   ');
    FQueryGrupoParcelas.SQL.Add(' WHERE ID_GRUPO_PARCELAS = :ID_GRUPO_PARCELAS        ');
    FQueryGrupoParcelas.ParamByName('ID_GRUPO_PARCELAS').AsInteger := FCp.IdGrupoParcelas;
    FQueryGrupoParcelas.Open;

    grdGrupoParcelas.DataSource.DataSet := FQueryGrupoParcelas;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao carregar grupo de parcelas' + E.Message);
    end;
  end;
end;

procedure TfrmContasPagar.InicializaAlteracaoCp;
begin
  // Coloca o numero do registro no titulo
  lblTitulo.Caption := 'Alterando Registro Nº ' + dmCPagar.cdsCPagarID.AsString;

  toggleParcelamento.Enabled := False;
  toggleParcelamento.State := tssOff;
  CardPanelParcela.ActiveCard := cardParcelaUnica;
  edtParcela.ReadOnly := True;
  CheckFatVirada.Visible := False;
  CheckFatVirada.Checked := False;
  edtValorParcela.ReadOnly := False;
  chkBaixarAoSalvar.Checked := False;

  edtParcela.Enabled := True;
  edtValorParcela.Enabled := True;

  // Esvaziando data set de parcelas
  cdsParcelas.EmptyDataSet;
end;

procedure TfrmContasPagar.PreparaInclusaoCp;
begin
  lblTitulo.Caption := 'Inserindo um novo lançamento no Contas a Pagar';

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

procedure TfrmContasPagar.IncluirContaPagar;
begin
  PreparaInclusaoCp;

  if (Assigned(FCp)) then
    FreeAndNil(FCp);

  FCp := TModelCP.Create;
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

function TfrmContasPagar.ValidaCadParcelamento: Boolean;
begin

  Result := False;

  // Posiciona no primeiro registro do cds
  cdsParcelas.First;

  if (cdsParcelas.IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!',
      'Informando que a conta é parcelada porém as Parcelas não foram geradas!',
      tmAviso);
    edtQtdParcelas.SetFocus;
    exit;
  end;

  // Valida todos os registros do cds
  while not cdsParcelas.Eof do
  begin

    if (cdsParcelasPARCELA.AsInteger < 0) then
    begin
      TfrmMensagem.TelaMensagem('Atenção!',
        'Número de parcela gerado inválido!', tmAviso);
      exit;
    end;

    if (cdsParcelasVALOR.AsCurrency < 0.01) then
    begin
      TfrmMensagem.TelaMensagem('Atenção!',
        'Valor da Parcela Inválido!', tmAviso);
      exit;
    end;

    // Avança para o próximo registro
    cdsParcelas.Next;

  end;

  Result := True;

end;

function TfrmContasPagar.ValidaCadParcelaUnica: Boolean;
begin
  Result := False;

  // Valida campos obrigatorios

  if (Trim(edtParcela.Text).IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!',
      'Número da parcela Inválido!', tmAviso);
    edtParcela.SetFocus;
    exit;
  end;

  if (dateVencimento.Date < dateCompra.Date) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!',
      'Data de vencimento não pode ser inferior a data de compra!', tmAviso);
    dateVencimento.SetFocus;
    exit;
  end;

  if (Trim(edtValorParcela.Text).IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor da parcela Inválido!',
      tmAviso);
    edtValorParcela.SetFocus;
    exit;
  end;

  if not(Assigned(FCp)) then
  begin
    TfrmMensagem.TelaMensagem('Erro',
      'Erro ao inicializar processo para gravar a Conta', tmErro);
    exit;
  end;

  Result := True;
end;

function TfrmContasPagar.ValidaDadosGeraisIncCp: Boolean;
var
  lValorCompra: Double;
begin
  Result := False;
  lValorCompra := 0;

  if (Trim(memDesc.Text).IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!',
      'Campo DESCRICAO não pode estar vazio!', tmAviso);
    memDesc.SetFocus;
    exit;
  end;

  if (Trim(edtFornecedor.Text).IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!',
      'Campo FORNECEDOR não pode estar vazio!', tmAviso);
    edtFornecedor.SetFocus;
    exit;
  end;

  if (not(TryStrToFloat(edtValorCompra.Text, lValorCompra)) or
    (lValorCompra = 0)) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor da compra Inválido!', tmAviso);
    edtValorCompra.SetFocus;
    exit;
  end;

  if (dateCompra.Date > Now) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!',
      'Data de compra não pode ser maior que a data atual!', tmAviso);
    dateCompra.SetFocus;
    exit;
  end;

  Result := True;
end;

function TfrmContasPagar.ValidaStatusCp: Boolean;
var
  lStatus: String;
begin
  Result := False;

  lStatus := Trim(DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString);

  // Se o documento já foi baixado cancela a edição
  if (lStatus = 'P') then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Documento já pago não pode ser alterado!', tmAviso);
    exit;
  end;

  // Se o documento foi cancelado, a edição é cancelada
  if (lStatus = 'C') then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Documento já cancelado não pode ser alterado!', tmAviso);
    exit;
  end;

  Result := True;
end;

function TfrmContasPagar.ValidaPesquisa: Boolean;
begin
  Result := False;

  if (dateInicial.Date > dateFinal.Date) then
  begin
    TfrmMensagem.TelaMensagem('Atenção',
      'Data Inicial não pode ser maior que a data Final!', tmAviso);
    dateFinal.SetFocus;
    exit;
  end;

  if (cbStatus.ItemIndex < 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção',
      'Selecione um tipo de STATUS!', tmAviso);
    cbStatus.SetFocus;
    exit;
  end;

  if (cbData.ItemIndex < 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção', 'Selecione um tipo de Data!', tmAviso);
    cbData.SetFocus;
    exit;
  end;
  Result := True;
end;

end.
