unit SistemaFinanceiro.View.CReceber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SistemaFinanceiro.View.CadastroPadrao,
  Data.DB, System.ImageList, Vcl.ImgList, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.WinXPanels, Vcl.WinXCtrls, Vcl.ComCtrls, Datasnap.DBClient,
  Vcl.Menus, SistemaFinanceiro.View.BaixarCR, SistemaFinanceiro.View.CrDetalhe,
  Vcl.Imaging.pngimage, SistemaFinanceiro.View.Clientes,
  SistemaFinanceiro.View.BxMultiplaCr, uEnumsUtils, SistemaFinanceiro.Model.Entidades.Cr;

type
  TfrmContasReceber = class(TfrmCadastroPadrao)
    dsCR: TDataSource;
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
    chkBaixarAoSalvar: TCheckBox;
    procedure FormCreate(Sender: TObject);
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
    procedure btnDetalhesClick(Sender: TObject);
    procedure dsCRDataChange(Sender: TObject; Field: TField);
    procedure btnImprimirClick(Sender: TObject);
    procedure checkDiaFixoVctoClick(Sender: TObject);
    procedure edtClienteExit(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnPesqClienteClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure CancelarBaixa1Click(Sender: TObject);
    procedure btnBxMultiplaClick(Sender: TObject);
    procedure chkBaixarAoSalvarClick(Sender: TObject);
    procedure PesquisaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTelaAtiva: Boolean;
    FCodCR: Integer;
    FOpCad: TOperacaoCadastro;
    FCr : TModelCR;
    procedure HabilitaBotoes;
    procedure EditarRegCReceber;
    procedure CadParcelaUnica;
    procedure CadParcelamento;
    procedure ExibeTelaBaixar(pCodCr: Integer);
    procedure ExibeTelaBxMultipla;
    procedure ExibeDetalhe;
    procedure BuscaNomeCliente;
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure GeraParcelas;
    procedure CalcCrGrid;
    procedure CalcQtdCrGrid;
    function GeraFiltrosRelatorio: String;
    function DtVencimentoCheckContaPaga: TDate;
    procedure QuerySTATUSGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public

  protected
    procedure Pesquisar; override;
  end;

var
  frmContasReceber: TfrmContasReceber;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Model.dmCReceber,
  SistemaFinanceiro.Utilitarios,
  System.DateUtils,
  SistemaFinanceiro.View.Principal,
  SistemaFinanceiro.View.Relatorios.Cr,
  SistemaFinanceiro.Model.dmClientes,
  SistemaFinanceiro.Model.dmUsuarios,
  SistemaFinanceiro.Model.uSFQuery;

{ TfrmContasReceber }

procedure TfrmContasReceber.btnAlterarClick(Sender: TObject);
begin
  EditarRegCReceber;
end;

procedure TfrmContasReceber.btnBaixarCRClick(Sender: TObject);
begin
  inherited;
  ExibeTelaBaixar(dsCR.DataSet.FieldByName('ID').AsInteger);
end;

procedure TfrmContasReceber.btnBxMultiplaClick(Sender: TObject);
begin

  ExibeTelaBxMultipla;

end;

procedure TfrmContasReceber.btnCancelarClick(Sender: TObject);
begin

  inherited;

  // Cancelando inclus�o
  dmCReceber.cdsCReceber.Cancel;

end;

procedure TfrmContasReceber.btnDetalhesClick(Sender: TObject);
begin
  inherited;

  if dsCR.DataSet.FieldByName('STATUS').AsString <> 'P' then
  begin

    Application.MessageBox
      ('Conta n�o paga, realize a baixa para ver os detalhes!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  ExibeDetalhe;

end;

procedure TfrmContasReceber.btnExcluirClick(Sender: TObject);
var
  Option: Word;
begin

  // Se o documento j� foi baixado cancela a exclus�o
  if dmCReceber.cdsCReceberSTATUS.AsString = 'P' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� baixado n�o pode ser cancelado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Se o documento foi cancelado, a exclus�o � cancelada
  if dmCReceber.cdsCReceberSTATUS.AsString = 'C' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� cancelado n�o pode ser cancelado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  Option := Application.MessageBox('Deseja cancelar o registro? ',
    'Confirma��o', MB_YESNO + MB_ICONQUESTION);

  if Option = IDNO then
  begin
    exit;
  end;

  try
    dmCReceber.cdsCReceber.Edit;
    dmCReceber.cdsCReceberSTATUS.AsString := 'C';
    dmCReceber.cdsCReceber.Post;
    dmCReceber.cdsCReceber.ApplyUpdates(0);

    Application.MessageBox('Documento cancelado com sucesso!', 'Aten��o',
      MB_OK + MB_ICONINFORMATION);
    Pesquisar;

    // Atualiza o relatorio na tela inicial
    frmPrincipal.TotalCR;

  except
    on e: Exception do
      Application.MessageBox(PWidechar(e.Message),
        'Erro ao cancelar documento!', MB_OK + MB_ICONERROR);
  end;

  inherited;
end;

procedure TfrmContasReceber.btnGerarClick(Sender: TObject);
begin
  GeraParcelas;
end;

procedure TfrmContasReceber.btnImprimirClick(Sender: TObject);
var
  lformularioRelatorio: TfrmRelCr;
  lFiltrosRelatorio: String;
begin

  lFiltrosRelatorio := GeraFiltrosRelatorio;
  lformularioRelatorio := TfrmRelCr.Create(Self);
  try
    // Desativa a atualiza��o visual do grid
    dsCR.DataSet.DisableControls;

    if not(Trim(lFiltrosRelatorio).IsEmpty) then
    begin
      lformularioRelatorio.Filtros := lFiltrosRelatorio;
      lformularioRelatorio.ExibirFiltros := True;
    end;
    lformularioRelatorio.DataSourceCr.DataSet := dsCR.DataSet;

    // Mostra a pre vizualizacao
    lformularioRelatorio.RLReport.Preview;

  finally

    lformularioRelatorio.Free;
    // Ativa a atualiza��o visual do grid novamente
    dsCR.DataSet.EnableControls;
  end;

  Pesquisar;

end;

procedure TfrmContasReceber.btnIncluirClick(Sender: TObject);
begin
  inherited;

  // Atualiza titulo
  lblTitulo.Caption := 'Inserindo novo Lan�amento no Contas a Receber';

  FOpCad := ocIncluir;

  // Posiciona o foco no 1 campo
  memDesc.SetFocus;

  // Seta previamente as datas
  dateVenda.Date := now;
  dateVencimento.Date := now + 7;

  // Seta previamente a parcela
  edtParcela.Text := '1';

  // Esvazia o dataset das parcelas
  cdsParcelas.EmptyDataSet;

  // Liberacoes
  edtQtdParcelas.Enabled := True;
  edtIntervaloDias.Enabled := True;
  edtDiaFixoVcto.Enabled := False;
  checkDiaFixoVcto.Checked := False;
  checkDiaFixoVcto.Enabled := True;
  btnGerar.Enabled := True;
  btnLimpar.Enabled := False;
  toggleParcelamento.State := tssOff;
  toggleParcelamento.Enabled := True;
  edtParcela.ReadOnly := True;
  edtValorParcela.ReadOnly := True;
  chkBaixarAoSalvar.Checked := False;

  // Oculta o nome do cliente
  lblNomeCliente.Visible := False;

  if Assigned(FCr) then
    FreeAndNil(Fcr);

  Fcr := TModelCR.Create;

end;

procedure TfrmContasReceber.btnLimparClick(Sender: TObject);
begin
  inherited;

  // Esvazia o dataset das parcelas
  cdsParcelas.EmptyDataSet;

  // Libera��es
  edtQtdParcelas.Enabled := True;
  edtIntervaloDias.Enabled := True;
  edtDiaFixoVcto.Enabled := True;
  checkDiaFixoVcto.Enabled := True;
  btnGerar.Enabled := True;
  btnLimpar.Enabled := False;

  edtQtdParcelas.Clear;
  edtIntervaloDias.Clear;
  edtDiaFixoVcto.Clear;

  checkDiaFixoVcto.Checked := False;

end;

procedure TfrmContasReceber.btnPesqClienteClick(Sender: TObject);
begin

  // Cria o form
  frmCliente := TfrmCliente.Create(Self);

  try

    // Exibe o form
    frmCliente.ShowModal;

  finally

    // Pega a ID do cliente selecionado
    edtFiltroCliente.Text := frmCliente.DataSourceCliente.DataSet.FieldByName
      ('ID_CLI').AsString;

    // Libera da  memoria
    FreeAndNil(frmCliente);

  end;

  Pesquisar;

end;

procedure TfrmContasReceber.btnPesquisaClienteClick(Sender: TObject);
begin

  // Cria o form
  frmCliente := TfrmCliente.Create(Self);

  try

    // Exibe o form
    frmCliente.ShowModal;

  finally

    // Pega a ID do cliente selecionado
    edtCliente.Text := frmCliente.DataSourceCliente.DataSet.FieldByName
      ('ID_CLI').AsString;

    // Libera da  memoria
    FreeAndNil(frmCliente);

  end;

  edtCliente.SetFocus;

end;

procedure TfrmContasReceber.btnSalvarClick(Sender: TObject);
begin

  if toggleParcelamento.State = tssOff then
    CadParcelaUnica
  else
    CadParcelamento;

  // Retorna ao card de pesquisa
  CardPanelPrincipal.ActiveCard := CardPesquisa;

  // Atualiza a lista
  Pesquisar;

  // Atualiza o relatorio na tela inicial
  frmPrincipal.TotalCR;

  inherited;
end;

procedure TfrmContasReceber.BuscaNomeCliente;
var
  NomeCliente: String;

begin

  if Trim(edtCliente.Text) <> '' then
  begin

    NomeCliente := dmClientes.GetNomeCliente(Trim(edtCliente.Text));

    if NomeCliente = '' then
    begin

      Application.MessageBox('Cliente n�o encontrado!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      edtCliente.SetFocus;
      edtCliente.Clear;

    end;

    lblNomeCliente.Visible := True;
    lblNomeCliente.Caption := NomeCliente;

  end;

end;

procedure TfrmContasReceber.CadParcelamento;
var
  lValorVenda: Currency;
  lIdCliente: Integer;
  lCr: TModelCR;
  lQtdParcelas, lIdGrupoParcelas: Integer;
begin

  lQtdParcelas := 0;
  lIdGrupoParcelas := 0;

  // Valida valor da venda
  if not TryStrToCurr(edtValorVenda.Text, lValorVenda) then
  begin
    edtValorVenda.SetFocus;
    Application.MessageBox('Valor da Venda inv�lido!', 'Aten��o',
      MB_OK + MB_ICONWARNING);
    abort;
  end;

  if not TryStrToInt(edtCliente.Text, lIdCliente) then
  begin
    begin
      edtCliente.SetFocus;
      Application.MessageBox('Campo CLIENTE n�o pode estar vazio', 'Aten��o',
        MB_OK + MB_ICONWARNING);
      abort;
    end;
  end;

  // Posiciona no reg 1 do cds
  cdsParcelas.First;
  // Valida todos os reg do cds
  while not cdsParcelas.Eof do
  begin
    if cdsParcelasParcela.AsInteger < 0 then
    begin
      Application.MessageBox('N�mero de Parcela inv�lido!', 'Aten��o',
        MB_OK + MB_ICONWARNING);
      abort;
    end;

    if cdsParcelasValor.AsCurrency < 0.01 then
    begin
      Application.MessageBox('Valor da Parcela inv�lido!', 'Aten��o',
        MB_OK + MB_ICONWARNING);
      abort
    end;

    cdsParcelas.Next;

  end;

  lQtdParcelas := cdsParcelas.RecordCount;
  lIdGrupoParcelas := TModelCR.GetIdGrupoParcelas;

  if (lIdGrupoParcelas <= 0) then
  begin
    Application.MessageBox('ID do grupo de Parcelas inv�lido!', 'Aten��o',  MB_OK + MB_ICONWARNING);
    abort
  end;

  if (lQtdParcelas <= 0) then
  begin
    edtQtdParcelas.SetFocus;
    Application.MessageBox('Parcelas n�o geradas!', 'Aten��o', MB_OK + MB_ICONWARNING);
    abort;
  end;

  // Posiciona no reg 1 do cds
  cdsParcelas.First;

  // Gravando Parcelas
  while not cdsParcelas.Eof do
  begin
    lCr := TModelCR.Create;
    try
      lCr.GeraCodigo;
      lCr.IdCliente := lIdCliente;
      lCr.DataCadastro := now;
      lCr.Status := 'A';
      lCr.ValorAbatido := 0;
      lCr.Doc := cdsParcelasDocumento.AsString;
      lCr.Desc := Format('%s - Parcela %d', [memDesc.Text, cdsParcelasParcela.AsInteger]);
      lCr.ValorVenda := lValorVenda;
      lCr.DataVenda := dateVenda.Date;
      lCr.Parcela := cdsParcelasParcela.AsInteger;
      lCr.ValorParcela := cdsParcelasValor.AsCurrency;
      lCr.DataVencimento := cdsParcelasVencimento.AsDateTime;
      lCr.Parcial := 'N';
      lCr.NumTotalParcelas := lQtdParcelas;
      lCr.IdGrupoParcelas := lIdGrupoParcelas;

      // Gravando no BD
      if (FOpCad = ocIncluir) then
        lCr.Insert;

      cdsParcelas.Next;
    finally
      lCr.Free;
    end;
  end;

  Application.MessageBox('Parcelas Cadastradas com Sucesso!!', 'Aten��o',
    MB_OK + MB_ICONINFORMATION);

  Pesquisar;

  CardPanelPrincipal.ActiveCard := CardPesquisa;
end;

procedure TfrmContasReceber.CadParcelaUnica;
var
  lParcela: Integer;
  lIdCliente: Integer;
  lValorVenda: Double;
  lValorParcela: Double;
  lRegGravado: Boolean;
begin

  lRegGravado := False;

  if Assigned(FCr) then
  begin
    try
      // Se for um novo registro ir� gerar o c�digo, status em aberto
      // e setar 0 no valor abatido
      if (FOpCad = ocIncluir) then
      begin
        FCr.GeraCodigo;
        FCr.DataCadastro := now;
        edtValorParcela.Text := edtValorVenda.Text;
      end;

      // Valida Campos obrigat�rios
      if not TryStrToInt(edtCliente.Text, lIdCliente) then
      begin
        edtCliente.SetFocus;
        Application.MessageBox('Campo CLIENTE n�o pode estar vazio!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if Trim(memDesc.Text) = '' then
      begin
        memDesc.SetFocus;
        Application.MessageBox('Campo Descri��o n�o pode estar vazio!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if not TryStrToFloat(edtValorVenda.Text, lValorVenda) then
      begin
        edtValorVenda.SetFocus;
        Application.MessageBox('Valor da Venda inv�lido!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if dateVencimento.Date < dateVenda.Date then
      begin
        dateVencimento.SetFocus;
        Application.MessageBox
          ('Data de vencimento n�o pode ser inferior a data de venda!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if not TryStrToFloat(edtValorParcela.Text, lValorParcela) then
      begin
        edtValorParcela.SetFocus;
        Application.MessageBox('Valor da Parcela inv�lido!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if not TryStrToInt(edtParcela.Text, lParcela) then
      begin
        edtParcela.SetFocus;
        Application.MessageBox('N�mero da Parcela inv�lido!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if dateVenda.Date > now then
      begin
        dateVenda.SetFocus;
        Application.MessageBox
          ('Data de venda n�o pode ser maior que a data atual!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      if (lValorParcela > lValorVenda) then
      begin
        edtValorParcela.SetFocus;
        Application.MessageBox
          ('Valor da parcela n�o pode ser maior que o valor da venda!', 'Aten��o',
          MB_OK + MB_ICONEXCLAMATION);
        abort;
      end;

      FCr.IdCliente := lIdCliente;
      FCr.Doc := Trim(edtNDoc.Text);
      FCr.Desc := Trim(memDesc.Text);
      FCr.Parcela := lParcela;
      FCr.ValorParcela := lValorParcela;
      FCr.ValorVenda := lValorVenda;
      FCr.DataVencimento := dateVencimento.Date;
      FCr.DataVenda := dateVenda.Date;
      FCr.Parcial := 'N';
      FCr.ValorAbatido := 0;
      FCr.Status := 'A';

      // Gravando no BD
      if (FOpCad = ocIncluir) then
        lRegGravado := FCr.Insert;

      if (FOpCad = ocAlterar) then
        lRegGravado := FCr.UpdateByPK;


      // Baixa apos salvar a conta
      if (lRegGravado and chkBaixarAoSalvar.Checked) then
        ExibeTelaBaixar(FCr.ID);

    finally
      FreeAndNil(FCr)
    end;
  end;

end;

procedure TfrmContasReceber.CalcCrGrid;
var
  TotalCR: Currency;

begin

  TotalCR := 0;

  // Percorre e soma
  with DBGrid1.DataSource.DataSet do
  begin

    // Desativa o controle
    DisableControls;

    // Posiciona no primeiro reg
    First;

    while not Eof do
    begin

      TotalCR := TotalCR + FieldByName('VALOR_PARCELA').AsCurrency;

      Next;

    end;

    // Reativa o controle
    EnableControls;

    lblTotalCpGrid.Caption := TUtilitario.FormatoMoeda(TotalCR);

  end;

end;

procedure TfrmContasReceber.CalcQtdCrGrid;
var
  QtdCr: Integer;

begin

  QtdCr := 0;

  // Realiza a conta
  QtdCr := DBGrid1.DataSource.DataSet.RecordCount;

  // Exibe na label
  lblQtdCp.Caption := IntToStr(QtdCr);

end;

procedure TfrmContasReceber.CancelarBaixa1Click(Sender: TObject);
var
  Option: Word;
  IdCr: Integer;

begin

  // Valida se o user logado � adm
  if not(dmUsuarios.GetUsuarioLogado.User_Admin = 'S') then
  begin

    Application.MessageBox('Somente Administradores podem cancelar uma Baixa!',
      'Erro', MB_OK + MB_ICONERROR);
    abort;

  end;

  if not dsCR.DataSet.IsEmpty then
  begin

    // Bloqueia o cancelamento se a conta n�o estiver como PAGA
    if dsCR.DataSet.FieldByName('STATUS').AsString <> 'P' then
    begin

      Application.MessageBox('Conta n�o baixada!!', 'Erro',
        MB_OK + MB_ICONERROR);
      abort;

    end;

    Option := Application.MessageBox('Deseja cancelar o registro? ',
      'Confirma��o', MB_YESNO + MB_ICONQUESTION);

    if Option = IDNO then
    begin
      exit;
    end;

    // Pega a id da conta
    IdCr := dsCR.DataSet.FieldByName('ID').AsInteger;

    // Chama a procedure que fara o trabalho
    dmCReceber.CancBxCR(IdCr);

    Pesquisar;

    // Atualiza relatorio tela principal
    frmPrincipal.TotalCR;
    frmPrincipal.ResumoMensalCaixa;

  end;

end;

procedure TfrmContasReceber.checkDiaFixoVctoClick(Sender: TObject);
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
    Label9.Visible := False;
    edtIntervaloDias.Clear;

  end;

end;

procedure TfrmContasReceber.chkBaixarAoSalvarClick(Sender: TObject);
begin
  dateVencimento.Date := DtVencimentoCheckContaPaga;
end;

procedure TfrmContasReceber.dsCRDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  btnDetalhes.Enabled := dsCR.DataSet.FieldByName('STATUS').AsString = 'P';
  btnBaixarCR.Enabled := dsCR.DataSet.FieldByName('STATUS').AsString = 'A';

end;

procedure TfrmContasReceber.DBGrid1DblClick(Sender: TObject);
begin

  inherited;
  EditarRegCReceber;

end;

procedure TfrmContasReceber.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  lDisplayText: String;
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

  TUtilitario.FormatoMoedaGrid(TDBGrid(Sender), Column, Rect, State);

end;

function TfrmContasReceber.DtVencimentoCheckContaPaga: TDate;
begin
  Result := dateVencimento.Date;

  if (chkBaixarAoSalvar.Checked) and (dsCR.State = dsInsert) then
    Result := dateVenda.Date;

end;

procedure TfrmContasReceber.EditarRegCReceber;
begin

  edtParcela.Enabled := True;
  edtValorParcela.Enabled := True;

  // Esvazia o cds
  cdsParcelas.EmptyDataSet;

  // Se o documento j� foi baixado cancela a edi��o
  if DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'P' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� baixado n�o pode ser alterado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Se o documento foi cancelado, a edi��o � cancelada
  if DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'C' then
  begin
    CardPanelPrincipal.ActiveCard := CardPesquisa;
    Application.MessageBox('Documento j� cancelado n�o pode ser alterado!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if Assigned(FCr) then
    FreeAndNil(Fcr);

  Fcr := TModelCR.Create;
  try
    Fcr.ID := DBGrid1.DataSource.DataSet.FieldByName('ID').AsInteger;
    if Fcr.LoadObjectByPK then
    begin

      // Ajusta o tipo de opercao de cadastro para alterar
      FOpCad := ocAlterar;
      FCodCR := Fcr.ID;

      // Coloca o numero do registro no titulo
      lblTitulo.Caption := 'Alterando Registro N� ' + IntToStr(Fcr.ID);

      // Bloqueia o toogle
      toggleParcelamento.Enabled := False;
      toggleParcelamento.State := tssOff;
      CardPanelParcela.ActiveCard := cardParcelaUnica;
      edtParcela.ReadOnly := True;
      edtValorVenda.ReadOnly := False;
      edtValorParcela.ReadOnly := False;
      chkBaixarAoSalvar.Checked := False;

      // Carrega os dados
      edtCliente.Text := IntToStr(Fcr.IdCliente);
      memDesc.Text := Fcr.Desc;
      edtValorVenda.Text := TUtilitario.FormatarValor(Fcr.ValorVenda);
      dateVenda.Date := Fcr.DataVenda;
      edtNDoc.Text := Fcr.Doc;
      edtParcela.Text := IntToStr(Fcr.Parcela);
      edtValorParcela.Text := TUtilitario.FormatarValor(Fcr.ValorParcela);
      dateVencimento.Date := Fcr.DataVencimento;
      BuscaNomeCliente;
    end
    else
    begin
      Application.MessageBox('Erro ao carregar dados da Conta!', 'Erro!',
        MB_OK + MB_ICONERROR);
    end;
  except
    on E : Exception do
      Application.MessageBox('Erro ao Criar Objeto ao alterar os dados da Conta!', 'Erro!',
        MB_OK + MB_ICONERROR);
  end;

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
      Application.MessageBox('Cliente n�o est� Ativo, verifique o cadastro!',
        'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;

  end;

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

  if (FOpCad = ocIncluir) then
    edtValorParcela.Text := TUtilitario.FormatarValor(edtValorVenda.Text);

end;

procedure TfrmContasReceber.ExibeDetalhe;
begin

  // cria o form
  frmCrDetalhe := TfrmCrDetalhe.Create(Self);

  try

    frmCrDetalhe.ExibirCRDetalhes(dsCR.DataSet.FieldByName('ID').AsInteger);

    // exibe o form
    frmCrDetalhe.ShowModal;

  finally

    FreeAndNil(frmCrDetalhe);

  end;

end;

procedure TfrmContasReceber.ExibeTelaBaixar(pCodCr: Integer);
var
  lFormulario : TfrmBaixarCR;
begin

  // Cria o form
  lFormulario := TfrmBaixarCR.Create(Self);
  try
    lFormulario.BaixarCR(pCodCr);
    lFormulario.ShowModal;
  finally
    lFormulario.Free;
  end;

  Pesquisar;

  // Atualiza relatorio tela principal
  frmPrincipal.TotalCR;
  frmPrincipal.ResumoMensalCaixa;

end;

procedure TfrmContasReceber.ExibeTelaBxMultipla;
begin

  // Cria
  frmBxMultiplaCR := TfrmBxMultiplaCR.Create(Self);

  try

    // Exibe a tela
    frmBxMultiplaCR.ShowModal;

  finally

    FreeAndNil(frmBxMultiplaCR);

  end;

  Pesquisar;

  // Atualiza relatorio tela principal
  frmPrincipal.TotalCR;
  frmPrincipal.ResumoMensalCaixa;

end;

procedure TfrmContasReceber.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  TUtilitario.SalvarOrdemColunasParaJSON(DBGrid1, 'ConfigGrids', 'grdCr');
end;

procedure TfrmContasReceber.FormCreate(Sender: TObject);
begin
  inherited;

  FTelaAtiva := False;
  dmCReceber.cdsCReceber.Active := True;

  // Define as datas da consulta
  dateInicial.Date := StartOfTheMonth(now);
  dateFinal.Date := EndOfTheMonth(now);
  edtValorVenda.OnKeyPress := KeyPressValor;
  edtValorParcela.OnKeyPress := KeyPressValor;
end;

procedure TfrmContasReceber.FormShow(Sender: TObject);
begin
  inherited;
  TUtilitario.CarregarOrdemColunasJSON(DBGrid1, 'ConfigGrids', 'grdCr');
  FTelaAtiva := True;
end;

function TfrmContasReceber.GeraFiltrosRelatorio: String;
var
  lFiltros: String;
begin

  lFiltros := '';

  if not(Trim(edtCliente.Text).IsEmpty) then
  begin
    lFiltros := lFiltros + ' | Cliente: ' + dmClientes.GetNomeCliente
      (Trim(edtCliente.Text));
  end;

  if (cbData.ItemIndex <> 0) then
  begin
    lFiltros := lFiltros + cbData.Items[cbData.ItemIndex];
  end;

  if (dateInicial.Checked) and (dateFinal.Checked) then
  begin
    lFiltros := lFiltros + ' Per�odo: ' + DateToStr(dateInicial.DateTime) +
      ' a ' + DateToStr(dateFinal.DateTime);
  end;

  if not(Trim(edtFiltroCliente.Text).IsEmpty) then
  begin
    lFiltros := lFiltros + ' | Cliente: ' + dmClientes.GetNomeCliente
      (Trim(edtFiltroCliente.Text));
  end;

  if (cbStatus.ItemIndex > 0) then
  begin
    lFiltros := lFiltros + ' | Status: ' + cbStatus.Items[cbStatus.ItemIndex];
  end;

  if (checkParciais.Checked) then
  begin
    lFiltros := lFiltros + ' | Somente Parciais ';
  end;

  if (checkVencidas.Checked) then
  begin
    lFiltros := lFiltros + ' | Somente Contas Vencidas ';
  end;

  // Ordem de pesquisa
  if rbId.Checked then
  begin
    lFiltros := lFiltros + ' | Ordem Registros do relat�rio: C�digo da Conta ';
  end
  else if rbDataVenc.Checked then
  begin
    lFiltros := lFiltros +
      ' | Ordem Registros do relat�rio: Data de Vencimento ';
  end
  else if rbValorParcela.Checked then
  begin
    lFiltros := lFiltros + ' | Ordem Registros do relat�rio: Valor da Parcela ';
  end
  else if rbValorVenda.Checked then
  begin
    lFiltros := lFiltros + ' | Ordem Registros do relat�rio: Valor da Venda ';
  end
  else if rbDataVenda.Checked then
  begin
    lFiltros := lFiltros + ' | Ordem Registros do relat�rio: Data da Venda ';
  end
  else
  begin
    lFiltros := lFiltros + ' | Ordem Registros do relat�rio: C�digo da Conta ';
  end;

  Result := lFiltros;

end;

procedure TfrmContasReceber.GeraParcelas;
var
  QtdParcelas: Integer;
  IntervaloDias: Integer;
  ValorVenda: Currency;
  ValorParcela: Currency;
  ValorResiduo: Currency;
  Contador: Integer;
  DiaFixoVcto: Integer;

begin

  // Valida Campos
  if (not TryStrToCurr(edtValorVenda.Text, ValorVenda)) or (ValorVenda <= 0)
  then
  begin

    edtValorVenda.SetFocus;
    Application.MessageBox('Valor da Venda Inv�lido!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  if dateVenda.Date > now then
  begin

    dateVenda.SetFocus;
    Application.MessageBox('Data de venda n�o pode ser maior que a data atual!',
      'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;

  if not TryStrToInt(edtQtdParcelas.Text, QtdParcelas) then
  begin
    edtQtdParcelas.SetFocus;
    Application.MessageBox('Quantidade de Parcelas Inv�lido!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if QtdParcelas <= 1 then
  begin
    edtQtdParcelas.SetFocus;
    Application.MessageBox
      ('Para gerar parcelas a quantidade deve ser maior que 1!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToInt(edtIntervaloDias.Text, IntervaloDias) then
  begin
    edtIntervaloDias.SetFocus;
    Application.MessageBox('Intervalor de dias Inv�lido!', 'Aten��o',
      MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if checkDiaFixoVcto.Checked then
  begin
    if (not TryStrToInt(edtDiaFixoVcto.Text, DiaFixoVcto)) or (DiaFixoVcto > 28)
      or (DiaFixoVcto < 1) then
    begin
      edtDiaFixoVcto.SetFocus;
      Application.MessageBox('Dia fixo de vencimento Inv�lido!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      abort;
    end;
  end;

  // Calculando valores das parcelas
  // Trunca o valor final das parcelas
  ValorParcela := (Trunc(ValorVenda / QtdParcelas * 100) / 100);

  // Calcula o valor do residuo do Trunc para colocar em uma das parcelas
  ValorResiduo := ValorVenda - (ValorParcela * QtdParcelas);

  // Esvaziando data set
  cdsParcelas.IsEmpty;

  for Contador := 1 to QtdParcelas do
  begin

    cdsParcelas.Insert;
    cdsParcelasParcela.AsInteger := Contador;

    // Adiciona o valor do residuo na primeira parcela
    cdsParcelasValor.AsCurrency := ValorParcela + ValorResiduo;
    ValorResiduo := 0; // Zera o valor de residuo

    // Define a data de vencimento
    if checkDiaFixoVcto.Checked then
    begin
      cdsParcelasVencimento.AsDateTime :=
        EncodeDate(YearOf(IncDay(dateVenda.Date, IntervaloDias * Contador)),
        MonthOf(IncDay(dateVenda.Date, IntervaloDias * Contador)), DiaFixoVcto);
    end
    else
    begin
      cdsParcelasVencimento.AsDateTime :=
        IncDay(dateVenda.Date, IntervaloDias * Contador);
    end;

    // Define o numero do documento
    if not(edtNDoc.Text = '') then
    begin
      cdsParcelasDocumento.AsString := Trim(edtNDoc.Text) + '-' +
        IntToStr(Contador);
    end;

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

procedure TfrmContasReceber.HabilitaBotoes;
begin

  btnAlterar.Enabled := not dsCR.DataSet.IsEmpty;
  btnExcluir.Enabled := not dsCR.DataSet.IsEmpty;
  btnBaixarCR.Enabled := not dsCR.DataSet.IsEmpty;
  btnDetalhes.Enabled := not dsCR.DataSet.IsEmpty;
  btnImprimir.Enabled := not dsCR.DataSet.IsEmpty;

end;

procedure TfrmContasReceber.KeyPressValor(Sender: TObject; var Key: Char);
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

procedure TfrmContasReceber.PesquisaClick(Sender: TObject);
begin
  if (FTelaAtiva) then
    Pesquisar;
end;

procedure TfrmContasReceber.Pesquisar;
var
  LFiltroEdit: String;
  LFiltro: String;
  LOrdem: String;
  lQuery: TSFQuery;
begin

  if Assigned(lQuery) then
    FreeAndNil(lQuery);

  lQuery := TSFQuery.Create(nil);

  try
    // Valida��es
    if dateInicial.Date > dateFinal.Date then
    begin
      dateFinal.SetFocus;
      Application.MessageBox
        ('Data Inicial n�o pode ser maior que a data Final!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;

    if cbStatus.ItemIndex < 0 then
    begin
      cbStatus.SetFocus;
      Application.MessageBox('Selecione um tipo de STATUS!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;

    if cbData.ItemIndex < 0 then
    begin
      cbData.SetFocus;
      Application.MessageBox('Selecione um tipo de DATA!', 'Aten��o',
        MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;

    LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, DBGrid1);
    LFiltro := '';
    LOrdem := '';

    // Pesquisa por tipo
    case cbStatus.ItemIndex of
      1:
        LFiltro := LFiltro + ' AND CR.STATUS = ''P'' ';
      2:
        LFiltro := LFiltro + ' AND CR.STATUS = ''A'' ';
      3:
        LFiltro := LFiltro + ' AND CR.STATUS = ''C'' ';
    end;

    // Pesquisa por data
    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin
      case cbData.ItemIndex of
        0:
          LFiltro := LFiltro +
            ' AND CR.DATA_VENDA BETWEEN :DTINI AND :DTFIM ';
        1:
          LFiltro := LFiltro +
            ' AND CR.DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM ';
        2:
          LFiltro := LFiltro +
            ' AND CR.DATA_RECEBIMENTO BETWEEN :DTINI AND :DTFIM ';
      end;
    end;

    // Pesquisa parciais
    if checkParciais.Checked then
      LFiltro := LFiltro + ' AND CR.PARCIAL = ''S'' ';

    // Pesquisa vencidas
    if checkVencidas.Checked then
      LFiltro := LFiltro +
        ' AND CR.STATUS = ''A'' AND CR.DATA_VENCIMENTO < :DATUAL ';

    // Pesquisa por cliente
    if Trim(edtFiltroCliente.Text) <> '' then
      LFiltro := LFiltro + ' AND CR.ID_CLIENTE = :ID';

    // Ordem de pesquisa
    if rbId.Checked then
      LOrdem := ' ORDER BY CR.ID DESC'
    else if rbDataVenc.Checked then
      LOrdem := ' ORDER BY CR.DATA_VENCIMENTO'
    else if rbValorParcela.Checked then
      LOrdem := ' ORDER BY CR.VALOR_PARCELA DESC'
    else if rbValorVenda.Checked then
      LOrdem := ' ORDER BY CR.VALOR_VENDA DESC'
    else if rbDataVenda.Checked then
      LOrdem := ' ORDER BY CR.DATA_VENDA DESC'
    else
      LOrdem := ' ORDER BY CR.ID DESC';

    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add
      ('SELECT CR.*, CL.NOME FROM CONTAS_RECEBER CR LEFT JOIN CLIENTES CL ');
    lQuery.SQL.Add(' ON CR.ID_CLIENTE = CL.ID_CLI WHERE 1 = 1');
    lQuery.SQL.Add(LFiltroEdit + LFiltro + LOrdem);

    if Trim(edtFiltroCliente.Text) <> '' then
      lQuery.ParamByName('ID').AsString := Trim(edtFiltroCliente.Text);

    if checkVencidas.Checked then
      lQuery.ParamByName('DATUAL').AsDate := now;

    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin
      lQuery.ParamByName('DTINI').AsDate := dateInicial.Date;
      lQuery.ParamByName('DTFIM').AsDate := dateFinal.Date;
    end;

    lQuery.Open;

    lQuery.FieldByName('STATUS').OnGetText := QuerySTATUSGetText;

    // Configura��es do DataSet para o DBGrid
    dsCR.DataSet := lQuery;

    HabilitaBotoes;

    // Calcula a quantidade e valor
    CalcCrGrid;
    CalcQtdCrGrid;

    // Posiciona no primeiro registro
    dsCR.DataSet.First;

  except
    on e: Exception do
    begin
      Application.MessageBox(PWidechar('Erro ao realizar a consulta: ' +
        e.Message), 'Aten��o', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmContasReceber.QuerySTATUSGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = 'A' then
    Text := 'ABERTA'
  else if Sender.AsString = 'P' then
    Text := 'PAGA'
  else if Sender.AsString = 'C' then
    Text := 'CANCELADA';
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
