unit SistemaFinanceiro.View.CReceber;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SistemaFinanceiro.View.CadastroPadrao,
  Data.DB, System.ImageList, Vcl.ImgList, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.WinXPanels, Vcl.WinXCtrls, Vcl.ComCtrls, Datasnap.DBClient,
  Vcl.Menus, SistemaFinanceiro.View.BaixarCR, SistemaFinanceiro.View.CrDetalhe,
  Vcl.Imaging.pngimage, SistemaFinanceiro.View.Clientes,
  SistemaFinanceiro.View.BxMultiplaCr;
type
  TfrmContasReceber = class(TfrmCadastroPadrao)
    DataSourceCReceber: TDataSource;
    CardPanelParcela: TCardPanel;
    cardParcelaUnica: TCard;
    lblParcela: TLabel;
    lblValorParcela: TLabel;
    lblVencimento: TLabel;
    edtParcela: TEdit;
    edtValorParcela: TEdit;
    dateVencimento: TDateTimePicker;
    cardParcelamento: TCard;
    btnGerar: TButton;
    btnLimpar: TButton;
    DBGridParcelas: TDBGrid;
    dateVenda: TDateTimePicker;
    edtValorVenda: TEdit;
    lblDataVend: TLabel;
    lblDesc: TLabel;
    lblParcelamento: TLabel;
    lblValorVenda: TLabel;
    memDesc: TMemo;
    toggleParcelamento: TToggleSwitch;
    cdsParcelas: TClientDataSet;
    dsParcelas: TDataSource;
    cdsParcelasParcela: TIntegerField;
    cdsParcelasDocumento: TWideStringField;
    cdsParcelasVencimento: TDateField;
    cdsParcelasValor: TCurrencyField;
    cbStatus: TComboBox;
    lblStatus: TLabel;
    edtNDoc: TEdit;
    lblNDoc: TLabel;
    gbFiltros: TGroupBox;
    rbDataVenc: TRadioButton;
    rbValorParcela: TRadioButton;
    lblDataInicial: TLabel;
    dateInicial: TDateTimePicker;
    lblDataFinal: TLabel;
    dateFinal: TDateTimePicker;
    cbData: TComboBox;
    lblData: TLabel;
    rbValorVenda: TRadioButton;
    rbDataVenda: TRadioButton;
    btnBaixarCR: TButton;
    rbId: TRadioButton;
    btnDetalhes: TButton;
    Image3: TImage;
    lblCR: TLabel;
    pnlParciais: TPanel;
    checkParciais: TCheckBox;
    checkVencidas: TCheckBox;
    edtDiaFixoVcto: TEdit;
    lblDiaFixo: TLabel;
    checkDiaFixoVcto: TCheckBox;
    edtIntervaloDias: TEdit;
    lblIntervaloDias: TLabel;
    edtQtdParcelas: TEdit;
    lblQtdParcelas: TLabel;
    lblCliente: TLabel;
    edtCliente: TEdit;
    lblNomeCliente: TLabel;
    btnPesquisaCliente: TButton;
    edtFiltroCliente: TEdit;
    btnPesqCliente: TButton;
    lblClienteFiltro: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    pnlTotais: TPanel;
    lblQtdCp: TLabel;
    lblTotalCpGrid: TLabel;
    lblTQtdCo: TLabel;
    lblTValorCp: TLabel;
    gbLegenda: TGroupBox;
    lblPagas: TLabel;
    lblVencida: TLabel;
    lblCancelada: TLabel;
    lblNormal: TLabel;
    pnlPagas: TPanel;
    pnlVencida: TPanel;
    pnlNormal: TPanel;
    pnlCancelada: TPanel;
    PopupMenu: TPopupMenu;
    CancelarBaixa1: TMenuItem;
    btnBxMultipla: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnPesquisaeClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure toggleParcelamentoClick(Sender: TObject);
    procedure edtValorVendaExit(Sender: TObject);
    procedure edtValorParcelaExit(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnBaixarCRClick(Sender: TObject);
    procedure Baixar1Click(Sender: TObject);
    procedure btnDetalhesClick(Sender: TObject);
    procedure DataSourceCReceberDataChange(Sender: TObject; Field: TField);
    procedure cbStatusClick(Sender: TObject);
    procedure cbDataClick(Sender: TObject);
    procedure rbDataVencClick(Sender: TObject);
    procedure rbDataVendaClick(Sender: TObject);
    procedure rbIdClick(Sender: TObject);
    procedure rbValorParcelaClick(Sender: TObject);
    procedure rbValorVendaClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure checkParciaisClick(Sender: TObject);
    procedure checkDiaFixoVctoClick(Sender: TObject);
    procedure edtClienteExit(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnPesqClienteClick(Sender: TObject);
    procedure edtFiltroClienteChange(Sender: TObject);
    procedure edtPesquisarChange(Sender: TObject);
    procedure dateInicialChange(Sender: TObject);
    procedure dateFinalChange(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure CancelarBaixa1Click(Sender: TObject);
    procedure btnBxMultiplaClick(Sender: TObject);

  private
    { Private declarations }
    procedure HabilitaBotoes;
    procedure EditarRegCReceber;
    procedure CadParcelaUnica;
    procedure CadParcelamento;
    procedure ExibeTelaBaixar;
    procedure ExibeTelaBxMultipla;
    procedure ExibeDetalhe;
    procedure BuscaNomeCliente;
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure GeraParcelas;
    procedure CalcCrGrid;
    procedure CalcQtdCrGrid;

  public
    { Public declarations }

  protected
    procedure Pesquisar; override;
  end;

var
  frmContasReceber: TfrmContasReceber;

implementation
{$R *.dfm}
uses
  SistemaFinanceiro.Model.dmCReceber,
  SistemaFinanceiro.Utilitarios, System.DateUtils,
  SistemaFinanceiro.View.Principal, SistemaFinanceiro.View.Relatorios.Cr,
  SistemaFinanceiro.Model.dmClientes, SistemaFinanceiro.Model.dmUsuarios;

{ TfrmContasReceber }

procedure TfrmContasReceber.Baixar1Click(Sender: TObject);
begin
  inherited;

  ExibeTelaBaixar;

end;

procedure TfrmContasReceber.btnAlterarClick(Sender: TObject);
begin

  inherited;
  EditarRegCReceber;

end;

procedure TfrmContasReceber.btnBaixarCRClick(Sender: TObject);
begin
  inherited;

  ExibeTelaBaixar;

end;

procedure TfrmContasReceber.btnBxMultiplaClick(Sender: TObject);
begin

  ExibeTelaBxMultipla;

end;

procedure TfrmContasReceber.btnCancelarClick(Sender: TObject);
begin

  inherited;

  //  Cancelando inclus�o
  dmCReceber.cdsCReceber.Cancel;

end;
procedure TfrmContasReceber.btnDetalhesClick(Sender: TObject);
begin
  inherited;

  if DataSourceCReceber.DataSet.FieldByName('STATUS').AsString <> 'P' then
  begin

    Application.MessageBox('Conta n�o paga, realize a baixa para ver os detalhes!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;


  ExibeDetalhe;

end;

procedure TfrmContasReceber.btnExcluirClick(Sender: TObject);
var
  Option : Word;
begin

  //  Se o documento j� foi baixado cancela a exclus�o
  if dmCReceber.cdsCReceberSTATUS.AsString = 'P' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� baixado n�o pode ser cancelado!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  //  Se o documento foi cancelado, a exclus�o � cancelada
  if dmCReceber.cdsCReceberSTATUS.AsString = 'C' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� cancelado n�o pode ser cancelado!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;


  option := Application.MessageBox('Deseja cancelar o registro? ', 'Confirma��o', MB_YESNO + MB_ICONQUESTION);

  if option = IDNO then
  begin
    exit;
  end;

  try
    dmCReceber.cdsCReceber.Edit;
    dmCReceber.cdsCReceberSTATUS.AsString := 'C';
    dmCReceber.cdsCReceber.Post;
    dmCReceber.cdsCReceber.ApplyUpdates(0);

    Application.MessageBox('Documento cancelado com sucesso!', 'Aten��o', MB_OK + MB_ICONINFORMATION);
    Pesquisar;

    //  Atualiza o relatorio na tela inicial
    frmPrincipal.TotalCR;

  except on e: Exception do
    Application.MessageBox(PWidechar(E.Message), 'Erro ao cancelar documento!', MB_OK + MB_ICONERROR);
  end;

  inherited;
end;

procedure TfrmContasReceber.btnGerarClick(Sender: TObject);
begin
  inherited;
  GeraParcelas;
end;

procedure TfrmContasReceber.btnImprimirClick(Sender: TObject);
begin

  //  Cria o form
  frmRelCr := TfrmRelCr.Create(Self);

  try

    frmRelCr.DataSourceCr.DataSet := DataSourceCReceber.DataSet;

    //  Mostra a pre vizualizacao
    frmRelCr.RLReport.Preview;

  finally

    FreeAndNil(frmRelCr);

  end;

  Pesquisar;

end;

procedure TfrmContasReceber.btnIncluirClick(Sender: TObject);
begin
  inherited;

  //  Atualiza titulo
  lblTitulo.Caption := 'Inserindo novo Lan�amento no Contas a Receber';

  if not (dmCReceber.cdsCReceber.State in [dsInsert, dsEdit]) then
  begin

    //  Coloca o dataset em modo de inser��o de dados
    dmCReceber.cdsCReceber.Insert;

  end;


  //  Gera a id
  dmCReceber.GeraCodigo;

  //  Posiciona o foco no 1 campo
  memDesc.SetFocus;

  //  Seta previamente as datas
  dateVenda.Date := now;
  dateVencimento.Date := now + 7;

  //  Seta previamente a parcela
  edtParcela.Text := '1';

  //  Esvazia o dataset das parcelas
  cdsParcelas.EmptyDataSet;

  //  Liberacoes
  edtQtdParcelas.Enabled     := True;
  edtIntervaloDias.Enabled   := True;
  edtDiaFixoVcto.Enabled     := False;
  checkDiaFixoVcto.Checked   := False;
  checkDiaFixoVcto.Enabled   := True;
  btnGerar.Enabled           := True;
  btnLimpar.Enabled          := False;
  toggleParcelamento.State   := tssOff;
  toggleParcelamento.Enabled := True;
  edtParcela.ReadOnly        := True;
  edtValorParcela.ReadOnly   := True;

  //  Oculta o nome do cliente
  lblNomeCliente.Visible := False;

end;

procedure TfrmContasReceber.btnLimparClick(Sender: TObject);
begin
  inherited;

  //  Esvazia o dataset das parcelas
  cdsParcelas.EmptyDataSet;

   //  Libera��es
  edtQtdParcelas.Enabled   := True;
  edtIntervaloDias.Enabled := True;
  edtDiaFixoVcto.Enabled   := True;
  checkDiaFixoVcto.Enabled := True;
  btnGerar.Enabled         := True;
  btnLimpar.Enabled        := False;

  edtQtdParcelas.Clear;
  edtIntervaloDias.Clear;
  edtDiaFixoVcto.Clear;

  checkDiaFixoVcto.Checked := False;

end;

procedure TfrmContasReceber.btnPesqClienteClick(Sender: TObject);
begin

  //  Cria o form
  frmCliente := TfrmCliente.Create(Self);

  try

    //  Exibe o form
    frmCliente.ShowModal;

  finally

    //  Pega a ID do cliente selecionado
    edtFiltroCliente.Text := frmCliente.DataSourceCliente.DataSet.FieldByName('ID_CLI').AsString;

    //  Libera da  memoria
    FreeAndNil(frmCliente);

  end;

  Pesquisar;

end;

procedure TfrmContasReceber.btnPesquisaClienteClick(Sender: TObject);
begin

  //  Cria o form
  frmCliente := TfrmCliente.Create(Self);

  try

    //  Exibe o form
    frmCliente.ShowModal;

  finally

    //  Pega a ID do cliente selecionado
    edtCliente.Text := frmCliente.DataSourceCliente.DataSet.FieldByName('ID_CLI').AsString;

    //  Libera da  memoria
    FreeAndNil(frmCliente);

  end;

  edtCliente.SetFocus;

end;

procedure TfrmContasReceber.btnPesquisaeClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.btnSalvarClick(Sender: TObject);
begin

  if toggleParcelamento.State = tssOff then
  begin
      CadParcelaUnica;
  end
    else
    begin
      CadParcelamento;
    end;

  //  Retorna ao card de pesquisa
  CardPanelPrincipal.ActiveCard := CardPesquisa;

  //  Atualiza a lista
  Pesquisar;

  //  Atualiza o relatorio na tela inicial
  frmPrincipal.TotalCR;

  inherited;
end;

procedure TfrmContasReceber.BuscaNomeCliente;
var
  NomeCliente : String;

begin

  if Trim(edtCliente.Text) <> '' then
  begin

    NomeCliente := dmClientes.GetNomeCliente(Trim(edtCliente.Text));

    if NomeCliente = '' then
    begin

      Application.MessageBox('Cliente n�o encontrado!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      edtCliente.SetFocus;
      edtCliente.Clear;

    end;

    lblNomeCliente.Visible := True;
    lblNomeCliente.Caption := NomeCliente;

  end;

end;

procedure TfrmContasReceber.CadParcelamento;
var
  ValorVenda : Currency;
  IdCliente : Integer;

begin

  //  Valida valor da venda
  if not TryStrToCurr(edtValorVenda.Text, ValorVenda) then
  begin
    edtValorVenda.SetFocus;
    Application.MessageBox('Valor da Venda inv�lido!', 'Aten��o', MB_OK + MB_ICONWARNING);
    abort;
  end;

  if not TryStrToInt(edtCliente.Text, IdCliente) then
  begin
    begin
    edtCliente.SetFocus;
    Application.MessageBox('Campo CLIENTE n�o pode estar vazio', 'Aten��o', MB_OK + MB_ICONWARNING);
    abort;
  end;
  end;

  //  Posiciona no reg 1 do cds
  cdsParcelas.First;

  if cdsParcelas.IsEmpty then
  begin

    edtQtdParcelas.SetFocus;
    Application.MessageBox('Parcelas n�o geradas!', 'Aten��o', MB_OK + MB_ICONWARNING);
    abort;

  end;

  //  Valida todos os reg do cds
  while not cdsParcelas.Eof do
  begin
    if cdsParcelasParcela.AsInteger < 0 then
    begin
      Application.MessageBox('N�mero de Parcela inv�lido!', 'Aten��o', MB_OK + MB_ICONWARNING);
      abort;
    end;

    if cdsParcelasValor.AsCurrency < 0.01 then
    begin
      Application.MessageBox('Valor da Parcela inv�lido!', 'Aten��o', MB_OK + MB_ICONWARNING);
      abort
    end;

    cdsParcelas.Next;

  end;

  //  Posiciona no reg 1 do cds
  cdsParcelas.First;

  //  Gravando Parcelas
  while not cdsParcelas.Eof do
  begin

    if dmCReceber.cdsCReceber.State in [dsBrowse, dsInactive] then
    begin
      dmCReceber.cdsCReceber.Insert;
    end;

    dmCReceber.GeraCodigo;
    dmCReceber.cdsCReceberID_CLIENTE.AsInteger       := IdCliente;
    dmCReceber.cdsCReceberDATA_CADASTRO.AsDateTime   := now;
    dmCReceber.cdsCReceberSTATUS.AsString            := 'A';
    dmCReceber.cdsCReceberVALOR_ABATIDO.AsCurrency   := 0;
    dmCReceber.cdsCReceberNUMERO_DOCUMENTO.AsString  := cdsParcelasDOCUMENTO.AsString;
    dmCReceber.cdsCReceberDESCRICAO.AsString         := Format('%s - Parcela %d', [memDesc.Text, cdsParcelasPARCELA.AsInteger]);
    dmCReceber.cdsCReceberVALOR_VENDA.AsCurrency     := ValorVenda;
    dmCReceber.cdsCReceberDATA_VENDA.AsDateTime      := dateVenda.Date;
    dmCReceber.cdsCReceberPARCELA.AsInteger          := cdsParcelasPARCELA.AsInteger;
    dmCReceber.cdsCReceberVALOR_PARCELA.AsCurrency   := cdsParcelasVALOR.AsCurrency;
    dmCReceber.cdsCReceberDATA_VENCIMENTO.AsDateTime := cdsParcelasVENCIMENTO.AsDateTime;
    dmCReceber.cdsCReceberPARCIAL.AsString           := 'N';

    //  Gravando no banco
    dmCReceber.cdsCReceber.Post;
    dmCReceber.cdsCReceber.ApplyUpdates(0);

    cdsParcelas.Next;

  end;

  Application.MessageBox('Parcelas Cadastradas com Sucesso!!', 'Aten��o', MB_OK + MB_ICONINFORMATION);

  Pesquisar;

  CardPanelPrincipal.ActiveCard := CardPesquisa;
end;

procedure TfrmContasReceber.CadParcelaUnica;
var
  Parcela : Integer;
  IdCliente : Integer;
  ValorVenda : Currency;
  ValorParcela : Currency;

begin

  //  Se for um novo registro ir� gerar o c�digo, status em aberto
  //  e setar 0 no valor abatido
  if DataSourceCReceber.State in [dsInsert] then
  begin

    //  gera a id
    dmCReceber.GeraCodigo;

    dmCReceber.cdsCReceberDATA_CADASTRO.AsDateTime := now;
    dmCReceber.cdsCReceberSTATUS.AsString := 'A';
    dmCReceber.cdsCReceberVALOR_ABATIDO.AsCurrency := 0;

    //  Se for parcela unica pega o mesmo valor da compra
    edtValorParcela.Text := edtValorVenda.Text;

  end;

  //  Valida Campos obrigat�rios
  if not TryStrToInt(edtCliente.Text, IdCliente) then
  begin
    edtCliente.SetFocus;
    Application.MessageBox('Campo CLIENTE n�o pode estar vazio!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if Trim(memDesc.text) = '' then
  begin
    memDesc.SetFocus;
    Application.MessageBox('Campo Descri��o n�o pode estar vazio!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToCurr(edtValorVenda.Text, ValorVenda) then
  begin
    edtValorVenda.SetFocus;
    Application.MessageBox('Valor da Venda inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if dateVencimento.Date < dateVenda.Date then
  begin
    dateVencimento.SetFocus;
    Application.MessageBox('Data de vencimento n�o pode ser inferior a data de venda!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToCurr(edtValorParcela.Text, ValorParcela) then
  begin
    edtValorParcela.SetFocus;
    Application.MessageBox('Valor da Parcela inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToInt(edtParcela.Text, Parcela) then
  begin
    edtParcela.SetFocus;
    Application.MessageBox('N�mero da Parcela inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if dateVenda.Date > Now then
  begin

    dateVenda.SetFocus;
    Application.MessageBox('Data de venda n�o pode ser maior que a data atual!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  //  Passando os dados para o dataset
  dmCReceber.cdsCReceberID_CLIENTE.AsInteger       := IdCliente;
  dmCReceber.cdsCReceberNUMERO_DOCUMENTO.AsString  := Trim(edtNDoc.text);
  dmCReceber.cdsCReceberDESCRICAO.AsString         := Trim(memDesc.Text);
  dmCReceber.cdsCReceberPARCELA.AsInteger          := Parcela;
  dmCReceber.cdsCReceberVALOR_PARCELA.AsCurrency   := ValorParcela;
  dmCReceber.cdsCReceberVALOR_VENDA.AsCurrency     := ValorVenda;
  dmCReceber.cdsCReceberDATA_VENCIMENTO.AsDateTime := dateVencimento.Date;
  dmCReceber.cdsCReceberDATA_VENDA.AsDateTime      := dateVenda.Date;
  dmCReceber.cdsCReceberPARCIAL.AsString           := 'N';

  //  Gravando no BD
  dmCReceber.cdsCReceber.Post;
  dmCReceber.cdsCReceber.ApplyUpdates(0);

end;

procedure TfrmContasReceber.CalcCrGrid;
var
  TotalCr: Currency;

begin

  TotalCr := 0;

  //  Percorre e soma
  with DBGrid1.DataSource.DataSet do
  begin

    //  Desativa o controle
    DisableControls;

    //  Posiciona no primeiro reg
    First;

    while not Eof do
    begin

      TotalCr := TotalCr + FieldByName('VALOR_PARCELA').AsCurrency;

      Next;

    end;

    //  Reativa o controle
    EnableControls;

    lblTotalCpGrid.Caption := TUtilitario.FormatoMoeda(TotalCr);

  end;

end;

procedure TfrmContasReceber.CalcQtdCrGrid;
var
  QtdCr: Integer;

begin

  QtdCr := 0;

  //  Realiza a conta
  QtdCr := DBGrid1.DataSource.DataSet.RecordCount;

  //  Exibe na label
  lblQtdCp.Caption := IntToStr(QtdCr);


end;

procedure TfrmContasReceber.CancelarBaixa1Click(Sender: TObject);
var
  Option : Word;
  IdCr   : Integer;

begin

  //  Valida se o user logado � adm
  if not dmUsuarios.GetUsuarioLogado.Admin then
  begin

  Application.MessageBox('Somente Administradores podem cancelar uma Baixa!', 'Erro', MB_OK + MB_ICONERROR);
    abort;

  end;


  if not DataSourceCReceber.DataSet.IsEmpty then
  begin

    //  Bloqueia o cancelamento se a conta n�o estiver como PAGA
    if DataSourceCReceber.DataSet.FieldByName('STATUS').AsString <> 'P' then
    begin

      Application.MessageBox('Conta n�o baixada!!', 'Erro', MB_OK + MB_ICONERROR);
      abort;

    end;

    Option := Application.MessageBox('Deseja cancelar o registro? ', 'Confirma��o', MB_YESNO + MB_ICONQUESTION);

    if Option = IDNO then
    begin
      exit;
    end;

    //  Pega a id da conta
    IdCr := DataSourceCReceber.DataSet.FieldByName('ID').AsInteger;

    //  Chama a procedure que fara o trabalho
    dmCReceber.CancBxCR(IdCr);

    Pesquisar;

    //  Atualiza relatorio tela principal
    frmPrincipal.TotalCr;
    frmPrincipal.ResumoMensalCaixa;

  end;


end;

procedure TfrmContasReceber.cbDataClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.cbStatusClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.checkDiaFixoVctoClick(Sender: TObject);
begin
  inherited;

  if checkDiaFixoVcto.Checked then
  begin

    edtDiaFixoVcto.Visible   := True;
    edtDiaFixoVcto.Enabled   := True;
    lblDiaFixo.Visible       := True;
    edtIntervaloDias.Enabled := False;
    edtIntervaloDias.Text    := '30';
    Label9.Visible           := True;

    edtDiaFixoVcto.SetFocus;

  end
  else
  begin

    edtDiaFixoVcto.Visible   := False;
    edtDiaFixoVcto.Enabled   := False;
    lblDiaFixo.Visible       := False;
    edtIntervaloDias.Enabled := True;
    label9.Visible           := False;
    edtIntervaloDias.Clear;

  end;


end;

procedure TfrmContasReceber.checkParciaisClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.DataSourceCReceberDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  btnDetalhes.Enabled := DataSourceCReceber.DataSet.FieldByName('STATUS').AsString = 'P';
  btnBaixarCR.Enabled := DataSourceCReceber.DataSet.FieldByName('STATUS').AsString = 'A';

end;

procedure TfrmContasReceber.dateFinalChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.dateInicialChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.DBGrid1DblClick(Sender: TObject);
begin

  inherited;
  EditarRegCReceber;

end;

procedure TfrmContasReceber.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  //  Altera a cor das duplicatas vencidas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
      (DBGrid1.DataSource.DataSet.FieldByName('DATA_VENCIMENTO').AsDateTime < Date)
      and (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'A')then
  begin
    DBGrid1.Canvas.Font.Color := clRed;  // Define a cor do texto da c�lula
  end;

  //  Altera a cor das duplicatas pagas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
     (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'P')then
  begin
    DBGrid1.Canvas.Font.Color := clHotLight;  // Define a cor do texto da c�lula
  end;

  //  Altera a cor das duplicatas canceladas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
     (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'C')then
  begin
    DBGrid1.Canvas.Font.Color := $00E68AE5;  // Define a cor do texto da c�lula
  end;

  // Desenha a c�lula com as propriedades de cor atualizadas
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  inherited;

end;

procedure TfrmContasReceber.EditarRegCReceber;
begin

  edtParcela.Enabled := True;
  edtValorParcela.Enabled := True;

  //  Esvazia o cds
  cdsParcelas.EmptyDataSet;

  //  Se o documento j� foi baixado cancela a edi��o
  if dmCReceber.cdsCReceberSTATUS.AsString = 'P' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� baixado n�o pode ser alterado!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  //  Se o documento foi cancelado, a edi��o � cancelada
  if dmCReceber.cdsCReceberSTATUS.AsString = 'C' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� cancelado n�o pode ser alterado!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Coloca o dataset em modo de edi��o
  dmCReceber.cdsCReceber.Edit;

  // Coloca o numero do registro no titulo
  lblTitulo.Caption := 'Alterando Registro N� ' + dmCReceber.cdsCReceberID.AsString;

  //  Bloqueia o toogle
  toggleParcelamento.Enabled  := False;
  toggleParcelamento.State    := tssOff;
  CardPanelParcela.ActiveCard := cardParcelaUnica;
  edtParcela.ReadOnly         := True;

  edtValorParcela.ReadOnly := False;

  //  Carrega os dados
  edtCliente.Text      := dmCReceber.cdsCReceberID_CLIENTE.AsString;
  memDesc.Text         := dmCReceber.cdsCReceberDESCRICAO.AsString;
  edtValorVenda.Text   := TUtilitario.FormatarValor(dmCReceber.cdsCReceberVALOR_VENDA.AsCurrency);
  dateVenda.Date       := dmCReceber.cdsCReceberDATA_VENDA.AsDateTime;
  edtNDoc.Text         := dmCReceber.cdsCReceberNUMERO_DOCUMENTO.AsString;
  edtParcela.Text      := dmCReceber.cdsCReceberPARCELA.AsString;
  edtValorParcela.Text := TUtilitario.FormatarValor(dmCReceber.cdsCReceberVALOR_PARCELA.AsCurrency);
  dateVencimento.Date  := dmCReceber.cdsCReceberDATA_VENCIMENTO.AsDateTime;
  BuscaNomeCliente;

end;

procedure TfrmContasReceber.edtClienteExit(Sender: TObject);
begin

  BuscaNomeCliente;

  if Trim(edtCliente.Text) <> '' then
  begin

    if dmClientes.GetStatus(Trim(edtCliente.Text)) = False then
    begin

      edtCliente.Clear;
      edtCliente.SetFocus;
      lblNomeCliente.Caption := '';
      Application.MessageBox('Cliente n�o est� Ativo, verifique o cadastro!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;


  end;

end;

procedure TfrmContasReceber.edtFiltroClienteChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.edtPesquisarChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.edtValorParcelaExit(Sender: TObject);
begin
  inherited;
  edtValorParcela.Text := TUtilitario.FormatarValor(edtValorParcela.Text);

end;

procedure TfrmContasReceber.edtValorVendaExit(Sender: TObject);
begin
  inherited;
  edtValorVenda.Text := TUtilitario.FormatarValor(edtValorVenda.Text);

  if dmCReceber.cdsCReceber.State in [dsInsert] then
  begin

    //  Se ao inserir Parcela unica pega o mesmo valor da venda
    edtValorParcela.Text := TUtilitario.FormatarValor(edtValorVenda.Text);

  end;

end;

procedure TfrmContasReceber.ExibeDetalhe;
begin

  // cria o form
  frmCrDetalhe := TfrmCrDetalhe.Create(self);

  try

    frmCrDetalhe.ExibirCRDetalhes(DataSourceCReceber.DataSet.FieldByName('ID').AsInteger);

    //  exibe o form
    frmCrDetalhe.ShowModal;

  finally

    FreeAndNil(frmCrDetalhe);

  end;



end;

procedure TfrmContasReceber.ExibeTelaBaixar;
begin

  //  Cria o form
  frmBaixarCR := TfrmBaixarCR.Create(Self);

  try

    frmBaixarCR.BaixarCR(DataSourceCReceber.DataSet.FieldByName('ID').AsInteger);

    //  Exibe o form
    frmBaixarCR.ShowModal;

  finally

    FreeAndNil(frmBaixarCR);

  end;


  Pesquisar;

  //  Atualiza relatorio tela principal
  frmPrincipal.TotalCr;
  frmPrincipal.ResumoMensalCaixa;

end;

procedure TfrmContasReceber.ExibeTelaBxMultipla;
begin

  //  Cria
  frmBxMultiplaCR := TfrmBxMultiplaCR.Create(Self);

  try

    //  Exibe a tela
    frmBxMultiplaCR.ShowModal;

  finally

    FreeAndNil(frmBxMultiplaCR);

  end;

  Pesquisar;

  //  Atualiza relatorio tela principal
  frmPrincipal.TotalCr;
  frmPrincipal.ResumoMensalCaixa;

end;

procedure TfrmContasReceber.FormCreate(Sender: TObject);
begin
  inherited;

  dmCReceber.cdsCReceber.Active := True;

  edtValorVenda.OnKeyPress   := KeyPressValor;
  edtValorParcela.OnKeyPress := KeyPressValor;

  //  Define as datas da consulta
  dateInicial.Date := StartOfTheMonth(Now);
  dateFinal.Date   := EndOfTheMonth(Now);

end;

procedure TfrmContasReceber.GeraParcelas;
var
  QtdParcelas   : Integer;
  IntervaloDias : Integer;
  ValorVenda    : Currency;
  ValorParcela  : Currency;
  ValorResiduo  : Currency;
  Contador      : Integer;
  DiaFixoVcto   : Integer;

begin

  //  Valida Campos
  if (not TryStrToCurr(edtValorVenda.Text, ValorVenda)) or (ValorVenda <= 0)then
  begin

    edtValorVenda.SetFocus;
    Application.MessageBox('Valor da Venda Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  if dateVenda.Date > Now then
  begin

    dateVenda.SetFocus;
    Application.MessageBox('Data de venda n�o pode ser maior que a data atual!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  if not TryStrToInt(edtQtdParcelas.Text, QtdParcelas) then
  begin
    edtQtdParcelas.SetFocus;
    Application.MessageBox('Quantidade de Parcelas Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if QtdParcelas <= 1 then
  begin
    edtQtdParcelas.SetFocus;
    Application.MessageBox('Para gerar parcelas a quantidade deve ser maior que 1!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToInt(edtIntervaloDias.Text, IntervaloDias) then
  begin
    edtIntervaloDias.SetFocus;
    Application.MessageBox('Intervalor de dias Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if checkDiaFixoVcto.Checked then
  begin
    if (not TryStrToInt(edtDiaFixoVcto.Text, DiaFixoVcto)) or (DiaFixoVcto > 28) or (DiaFixoVcto < 1) then
    begin
        edtDiaFixoVcto.SetFocus;
        Application.MessageBox('Dia fixo de vencimento Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      abort;
    end;
  end;

  //  Calculando valores das parcelas
  //  Trunca o valor final das parcelas
  ValorParcela := (Trunc(ValorVenda / QtdParcelas * 100) / 100);

  //  Calcula o valor do residuo do Trunc para colocar em uma das parcelas
  ValorResiduo := ValorVenda - (ValorParcela * QtdParcelas);

  //  Esvaziando data set
  cdsParcelas.IsEmpty;

  for Contador := 1 to QtdParcelas do
  begin

    cdsParcelas.Insert;
    cdsParcelasParcela.AsInteger := Contador;

    //  Adiciona o valor do residuo na primeira parcela
    cdsParcelasValor.AsCurrency := ValorParcela + ValorResiduo;
    ValorResiduo := 0;  //  Zera o valor de residuo

    //  Define a data de vencimento
     //  Define a data de vencimento
    if checkDiaFixoVcto.Checked then
    begin

      cdsParcelasVENCIMENTO.AsDateTime := EncodeDate(YearOf(IncDay(dateVenda.Date, IntervaloDias *  Contador)), MonthOf(IncDay(dateVenda.Date, IntervaloDias *  Contador)), DiaFixoVcto);

    end
    else
    begin
      cdsParcelasVENCIMENTO.AsDateTime := IncDay(dateVenda.Date, IntervaloDias *  Contador);
    end;


    //  Define o numero do documento
    if not (edtNDoc.Text = '') then
    begin
      cdsParcelasDocumento.AsString := Trim(edtNDoc.Text) + '-' + IntToStr(Contador);
    end;

    cdsParcelas.Post;

  end;

  //  Bloqueios
  edtQtdParcelas.Enabled   := False;
  edtIntervaloDias.Enabled := False;
  edtDiaFixoVcto.Enabled   := False;
  checkDiaFixoVcto.Enabled := False;
  btnGerar.Enabled         := False;
  btnLimpar.Enabled        := True;

end;

procedure TfrmContasReceber.HabilitaBotoes;
begin

  btnAlterar.Enabled  := not DataSourceCReceber.DataSet.IsEmpty;
  btnExcluir.Enabled  := not DataSourceCReceber.DataSet.IsEmpty;
  btnBaixarCR.Enabled := not DataSourceCReceber.DataSet.IsEmpty;
  btnDetalhes.Enabled := not DataSourceCReceber.DataSet.IsEmpty;
  btnImprimir.Enabled := not DataSourceCReceber.DataSet.IsEmpty;

end;

procedure TfrmContasReceber.KeyPressValor(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    //  Verifica se a tecla pressionada � o Enter
    //  Cancela o efeito do enter
    Key := #0;
    //  Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  //  Se for digitado um ponto, ser� convertido para virgula
  if Key = FormatSettings.ThousandSeparator then
   begin
      Key := #0;
    end;

  // Permite apenas digitar os caracteres dentro do charinset
  if not (CharInSet(Key, ['0'..'9', FormatSettings.DecimalSeparator, #8, #13])) then
  begin
    Key := #0;
  end;

  // Valida se j� existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

procedure TfrmContasReceber.Pesquisar;
var
  LFiltroEdit: String;
  LFiltro : String;
  LOrdem : String;

begin

  //  Valida��es
  if dateInicial.Date > dateFinal.Date then
  begin

    dateFinal.SetFocus;
    Application.MessageBox('Data Inicial n�o pode ser maior que a data Final!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    exit;

  end;

  if cbStatus.ItemIndex < 0 then
  begin

    cbStatus.SetFocus;
    Application.MessageBox('Selecione um tipo de STATUS!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    exit;

  end;

  if cbData.ItemIndex < 0 then
   begin

    cbData.SetFocus;
    Application.MessageBox('Selecione um tipo de DATA!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    exit;

  end;


  LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, DBGrid1);
  LFiltro := '';
  LOrdem := '';

  dmCReceber.cdsCReceber.Params.Clear;

  //  Pesquisa por tipo
  case cbStatus.ItemIndex of
    1 : LFiltro := LFiltro + ' AND CR.STATUS = ''P'' ';
    2 : LFiltro := LFiltro + ' AND CR.STATUS = ''A'' ';
    3 : LFiltro := LFiltro + ' AND CR.STATUS = ''C'' ';
  end;

  //  Pesquisa por data
  if (dateInicial.Checked) and (dateFinal.Checked) then
  begin

    case cbData.ItemIndex of

      0 : LFiltro := LFiltro + ' AND CR.DATA_VENDA BETWEEN :DTINI AND :DTFIM ';
      1 : LFiltro := LFiltro + ' AND CR.DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM ';
      2 : LFiltro := LFiltro + ' AND CR.DATA_RECEBIMENTO BETWEEN :DTINI AND :DTFIM ';

    end;

    //  Criando os parametros
    dmCReceber.cdsCReceber.Params.CreateParam(TFieldType.ftDate, 'DTINI', TParamType.ptInput);
    dmCReceber.cdsCReceber.ParamByName('DTINI').AsDate := dateInicial.Date;
    dmCReceber.cdsCReceber.Params.CreateParam(TFieldType.ftDate, 'DTFIM', TParamType.ptInput);
    dmCReceber.cdsCReceber.ParamByName('DTFIM').AsDate := dateFinal.Date;
  end;

   //  pesquisa parciais
   if checkParciais.Checked then
   begin

    LFiltro := LFiltro + ' AND CR.PARCIAL = ''S'' ';

   end;

  //  Pesquisa vencidas
  if checkVencidas.Checked then
  begin

    LFiltro := LFiltro + ' AND CR.STATUS = ''A'' AND CR.DATA_VENCIMENTO < :DATUAL ';

    //  Criando os parametros
    dmCReceber.cdsCReceber.Params.CreateParam(TFieldType.ftDate, 'DATUAL', TParamType.ptInput);
    dmCReceber.cdsCReceber.ParamByName('DATUAL').AsDate := NOW;

  end;

  //  Pesquisa por cliente
  if Trim(edtFiltroCliente.Text) <> '' then
  begin

    LFiltro := LFiltro + ' AND CR.ID_CLIENTE = :ID';

    //  Criando os parametros
    dmCReceber.cdsCReceber.Params.CreateParam(TFieldType.ftString, 'ID', TParamType.ptInput);
    dmCReceber.cdsCReceber.ParamByName('ID').AsString := Trim(edtFiltroCliente.Text);

  end;

  //  Ordem de pesquisa
  if rbId.Checked then
  begin
    lOrdem := ' ORDER BY CR.ID DESC';
  end
    else if rbDataVenc.Checked then
    begin
      lOrdem := ' ORDER BY CR.DATA_VENCIMENTO';
    end
      else if rbValorParcela.Checked then
      begin
        lOrdem := ' ORDER BY CR.VALOR_PARCELA DESC';
      end
        else if rbValorVenda.Checked then
        begin
          lOrdem := ' ORDER BY CR.VALOR_VENDA DESC';
        end
          else if rbDataVenda.Checked then
          begin
            lOrdem := ' ORDER BY CR.DATA_VENDA DESC';
          end
            else
            begin
              lOrdem := ' ORDER BY CR.ID DESC';
            end;




  dmCReceber.cdsCReceber.Close;

  dmCReceber.cdsCReceber.CommandText := 'SELECT CR.*, CL.NOME FROM CONTAS_RECEBER CR LEFT JOIN CLIENTES CL '
                                      + ' ON CR.ID_CLIENTE = CL.ID_CLI WHERE 1 = 1'
                                      + LFiltroEdit + LFiltro + LOrdem;
  dmCReceber.cdsCReceber.Open;

  HabilitaBotoes;

  //  Calcula a quantidade e valor
  CalcCrGrid;
  CalcQtdCrGrid;

  //  Posiciona no primeiro registro
  DataSourceCReceber.DataSet.First;


end;

procedure TfrmContasReceber.rbDataVencClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.rbDataVendaClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.rbIdClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.rbValorParcelaClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.rbValorVendaClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmContasReceber.toggleParcelamentoClick(Sender: TObject);
begin
  inherited;

  if toggleParcelamento.State = tssOff then
  begin
    CardPanelParcela.ActiveCard := cardParcelaUnica;
  end
    else if toggleParcelamento.State = tssOn then
         begin
          CardPanelParcela.ActiveCard := cardParcelamento;
         end;
end;
end.
