unit SistemaFinanceiro.View.Principal;

interface
uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, SistemaFinanceiro.View.Splash,
  SistemaFinanceiro.View.Usuarios, SistemaFinanceiro.View.Login, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, SistemaFinanceiro.View.RedefinirSenha,
  SistemaFinanceiro.View.Caixa, SistemaFinanceiro.View.SaldoCaixa,
  SistemaFinanceiro.View.CPagar,
  SistemaFinanceiro.View.CReceber, SistemaFinanceiro.View.Clientes,
  SistemaFinanceiro.View.Fornecedores, SistemaFinanceiro.View.FrPgto,
  SistemaFinanceiro.View.CadAdmin, System.IOUtils, SistemaFinanceiro.View.Ajuda,
  SistemaFinanceiro.View.FaturaCartao,
  SistemaFinanceiro.View.GeraRelResumoMensalCp,
  SistemaFinanceiro.View.GeraRelResumoMensalCr, Vcl.Buttons,
  SistemaFinanceiro.Model.Entidades.CR,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.View.Consulta.ConsultaLancamentoPadraoContas;

type
  TfrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    mnuCadastros: TMenuItem;
    mnuRelatorios: TMenuItem;
    mnuAjuda: TMenuItem;
    mnuUsuarios: TMenuItem;
    pnlDadosGerais: TPanel;
    pnlAtalhos: TPanel;
    pnlInfos: TPanel;
    lblUserLogado: TLabel;
    Image1: TImage;
    ImageList1: TImageList;
    mnuFinanceiro: TMenuItem;
    Caixa1: TMenuItem;
    SaldodoCaixa1: TMenuItem;
    ContasaPagar1: TMenuItem;
    N1: TMenuItem;
    ContasaReceber1: TMenuItem;
    pnlSaldoParcial: TPanel;
    lblSaldoCx: TLabel;
    lblValor: TLabel;
    imgLucro: TImage;
    imgPerda: TImage;
    lblData: TLabel;
    imgNormal: TImage;
    ImageListMenu: TImageList;
    pnlCP: TPanel;
    lblCP: TLabel;
    lblValorCP: TLabel;
    Image2: TImage;
    Label3: TLabel;
    pnlCR: TPanel;
    lblCR: TLabel;
    lblValorCR: TLabel;
    Image3: TImage;
    Label4: TLabel;
    mnuClientes: TMenuItem;
    mnuFornecedores: TMenuItem;
    N2: TMenuItem;
    mnuFormasPgto: TMenuItem;
    pnlBtn: TPanel;
    mnuConfiguracoes: TMenuItem;
    mnuAltImgPrincipal: TMenuItem;
    OpenDialog1: TOpenDialog;
    lblNomeSistema: TLabel;
    mnuFaturasCartao: TMenuItem;
    N3: TMenuItem;
    ContasaPagar2: TMenuItem;
    ResumoMensal1: TMenuItem;
    ContasaReceber2: TMenuItem;
    ResumoMensal2: TMenuItem;
    pnlNomeSistema: TPanel;
    Panel9: TPanel;
    imgLogo: TImage;
    btnFornec: TButton;
    btnClientes: TButton;
    btnCR: TButton;
    btnCP: TButton;
    btnCaixa: TButton;
    panel1: TPanel;
    pnlNomeBtnFornecedore: TPanel;
    pnlImgBtnFornecedore: TPanel;
    imgBtnFornecedore: TImage;
    pnlFundoBtnFornecedores: TPanel;
    pnlBtnFornecedores: TPanel;
    pnlNomeBtnFornecedores: TPanel;
    pnlImgBtnFornecedores: TPanel;
    imgBtnFornecedores: TImage;
    pnlFundoBtnClientes: TPanel;
    pnlBtnClientes: TPanel;
    pnlNomeBtnClientes: TPanel;
    pnlImgBtnClientes: TPanel;
    ImgBtnClientes: TImage;
    pnlFundoBtnCr: TPanel;
    pnnlBtnCr: TPanel;
    pnlNomeBtnCr: TPanel;
    pnlImgBtnCr: TPanel;
    imgBtnCr: TImage;
    pnlFundoBtnCp: TPanel;
    pnlBtnCp: TPanel;
    pnlNomeBtnCp: TPanel;
    pnlImgBtnCp: TPanel;
    imgBtnCp: TImage;
    pnlFundoBtnCaixa: TPanel;
    pnlBtnCaixa: TPanel;
    pnlNomeBtnCaixa: TPanel;
    pnlImgBtnCaixa: TPanel;
    imgBtnCaixa: TImage;
    mnuLancamentoPadrao: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure mnuUsuariosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCaixaClick(Sender: TObject);
    procedure Caixa1Click(Sender: TObject);
    procedure SaldodoCaixa1Click(Sender: TObject);
    procedure btnCPClick(Sender: TObject);
    procedure ContasaPagar1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCRClick(Sender: TObject);
    procedure ContasaReceber1Click(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure mnuClientesClick(Sender: TObject);
    procedure mnuFornecedoresClick(Sender: TObject);
    procedure mnuFormasPgtoClick(Sender: TObject);
    procedure mnuAltImgPrincipalClick(Sender: TObject);
    procedure mnuAjudaClick(Sender: TObject);
    procedure mnuFaturasCartaoClick(Sender: TObject);
    procedure ResumoMensal1Click(Sender: TObject);
    procedure ResumoMensal2Click(Sender: TObject);
    procedure imgBtnFornecedoreClick(Sender: TObject);
    procedure pnlNomeBtnFornecedoreClick(Sender: TObject);
    procedure btnFornecedoresClick(Sender: TObject);
    procedure btnClienteClick(Sender: TObject);
    procedure btnContasPagarClick(Sender: TObject);
    procedure btnContasReceberClick(Sender: TObject);
    procedure btnFluxoCaixaClick(Sender: TObject);
    procedure mnuLancamentoPadraoClick(Sender: TObject);

  private
    FDtIni : TDate;
    FDtFim : TDate;
    procedure ExibeTelaUsuario;
    procedure ExibeTelaCPagar;
    procedure ExibeTelaCReceber;
    procedure ExibeTelaCaixa;
    procedure ExibeTelaSaldoCaixa;
    procedure ExibeTelaClientes;
    procedure ExibeTelaFonecedores;
    procedure ExibeTelaFrPgto;
    procedure ExibeTelaAjuda;
    procedure ExibeTelaFaturaCartao;
    procedure ExibeTelaRelMensalCP;
    procedure ExibeTelaRelMensalCR;
    procedure ExibeTelaLancamentoPadrao;
    procedure CarregaImgPrincipal;

  public
    { Public declarations }
    procedure ResumoMensalCaixa;
    procedure TotalCP;
    procedure TotalCR;

  end;
var
  frmPrincipal: TfrmPrincipal;

implementation
{$R *.dfm}

uses
  SistemaFinanceiro.Model.dmUsuarios,
  System.DateUtils,
  SistemaFinanceiro.Model.Entidades.ResumoCaixa,
  SistemaFinanceiro.Utilitarios,
  Winapi.Windows,
  SistemaFinanceiro.Model.dmCPagar,
  MidasLib;

procedure TfrmPrincipal.mnuAltImgPrincipalClick(Sender: TObject);
var
  NomeImg, DestImg : String;

begin

  //  Setando tipos de arquivos do open dialog
  OpenDialog1.Filter := 'Imagens (*.png)|*.png';

  if OpenDialog1.Execute() then
  begin

    // pega o nome da imagem
    NomeImg := OpenDialog1.FileName;

    //  Define o destino e nome padrao
    DestImg := ExtractFilePath(Application.ExeName) + 'img_logo' + ExtractFileExt(NomeImg);

    //  Copia a logo para o local onde está o exe
    try

      CopyFile(PChar(NomeImg), Pchar(DestImg), False);

      ShowMessage('Nova logo principal Configurada!')

    except
      on E: Exception do
        ShowMessage('Erro ao copiar a imagem: ' + E.Message);

    end;

  end;

  //  Atualiza Logo Principal
  CarregaImgPrincipal;

end;

procedure TfrmPrincipal.btnCaixaClick(Sender: TObject);
begin
  ExibeTelaCaixa;
end;

procedure TfrmPrincipal.btnClienteClick(Sender: TObject);
begin
  ExibeTelaClientes;
end;

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin
  ExibeTelaClientes;
end;

procedure TfrmPrincipal.btnContasPagarClick(Sender: TObject);
begin
  ExibeTelaCPagar;
end;

procedure TfrmPrincipal.btnContasReceberClick(Sender: TObject);
begin
  ExibeTelaCReceber;
end;

procedure TfrmPrincipal.btnCPClick(Sender: TObject);
begin
  ExibeTelaCPagar;
end;

procedure TfrmPrincipal.btnCRClick(Sender: TObject);
begin
  ExibeTelaCReceber;
end;

procedure TfrmPrincipal.btnFluxoCaixaClick(Sender: TObject);
begin
  ExibeTelaCaixa;
end;

procedure TfrmPrincipal.btnFornecedoresClick(Sender: TObject);
begin
  ExibeTelaFonecedores;
end;

procedure TfrmPrincipal.Caixa1Click(Sender: TObject);
begin
  ExibeTelaCaixa;
end;

procedure TfrmPrincipal.CarregaImgPrincipal;
var
  Png: TPngImage;
  Bitmap: TBitmap;
begin

  //  Carrega a logo da tela principal
  if FileExists('img_logo.png') then
  begin
    imgLogo.Picture.LoadFromFile('img_logo.png');
  end;

end;

procedure TfrmPrincipal.ContasaPagar1Click(Sender: TObject);
begin
  ExibeTelaCPagar;
end;

procedure TfrmPrincipal.ContasaReceber1Click(Sender: TObject);
begin
  ExibeTelaCReceber;
end;

procedure TfrmPrincipal.ExibeTelaFrPgto;
begin

  //Cria o form
  frmFrPgto := TfrmFrPgto.Create(Self);

  try
    //  Exibe o form
    frmFrPgto.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmFrPgto);
  end;
end;

procedure TfrmPrincipal.ExibeTelaLancamentoPadrao;
var
  lFormulario : TfrmConsultaLancamentoPadraoContas;
begin

  lFormulario := TfrmConsultaLancamentoPadraoContas.Create(Self);
  try
    lFormulario.ShowModal;
  finally
    FreeAndNil(lFormulario);
  end;

end;

procedure TfrmPrincipal.ExibeTelaRelMensalCP;
begin

  //  Cria o Form
  frmGeraRelResumoMensalCp := TfrmGeraRelResumoMensalCp.Create(Self);

  try
    //  Exibe o form
    frmGeraRelResumoMensalCp.ShowModal;
  finally
    FreeAndNil(frmGeraRelResumoMensalCp);
  end;

end;

procedure TfrmPrincipal.ExibeTelaRelMensalCR;
begin

  //  Cria o Form
  frmGeraRelResumoMensalCr := TfrmGeraRelResumoMensalCr.Create(Self);

  try
    //  Exibe o form
    frmGeraRelResumoMensalCr.ShowModal;
  finally
    FreeAndNil(frmGeraRelResumoMensalCr);
  end;

end;

procedure TfrmPrincipal.ExibeTelaAjuda;
begin

   //Cria o form
  frmAjuda := TfrmAjuda.Create(Self);

  try
    //  Exibe o form
    frmAjuda.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmAjuda);
  end;

end;

procedure TfrmPrincipal.ExibeTelaCaixa;
begin

  //Cria o form
  frmCaixa := TfrmCaixa.Create(Self);

  try
    //  Exibe o form
    frmCaixa.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmCaixa);
  end;

end;

procedure TfrmPrincipal.ExibeTelaClientes;
begin

  //  Cria o Form
  frmCliente := TfrmCliente.Create(Self);

  try
    //  Exibe o Form
    frmCliente.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmCliente);
  end;

end;

procedure TfrmPrincipal.ExibeTelaCPagar;
begin

  //  Cria o Form
  frmContasPagar := TfrmContasPagar.Create(Self);

  try
    //  Exibe o Form
    frmContasPagar.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmContasPagar);
  end;
end;

procedure TfrmPrincipal.ExibeTelaCReceber;
var
  lFormulario : TfrmContasReceber;
begin

  //  Cria o Form
  lFormulario := TfrmContasReceber.Create(Self);
  try
    //  Exibe o Form
    lFormulario.ShowModal;
  finally
    //  Libera da memoria
    lFormulario.Free;
  end

end;

procedure TfrmPrincipal.ExibeTelaFaturaCartao;
begin

  //  Cria o form
  frmFaturaCartao := TfrmFaturaCartao.Create(Self);

  try
    //  Exibe o form
    frmFaturaCartao.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmFaturaCartao);
  end;

end;

procedure TfrmPrincipal.ExibeTelaFonecedores;
begin

  //  Cria o Form
  frmFornecedores := TfrmFornecedores.Create(Self);

  try
    //  Exibe o form
    frmFornecedores.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmFornecedores);
  end;

end;

procedure TfrmPrincipal.ExibeTelaSaldoCaixa;
begin

   //  Cria o Form
  frmSaldoCaixa := TfrmSaldoCaixa.Create(Self);

  try
    //  Exibe o form
    frmSaldoCaixa.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmSaldoCaixa);
  end;
end;

procedure TfrmPrincipal.ExibeTelaUsuario;
begin

  //  Cria o Form
  frmUsuarios := TfrmUsuarios.Create(Self);

  try
    //  Exibe o Form
    frmUsuarios.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmUsuarios);
  end
end;

procedure TfrmPrincipal.mnuFaturasCartaoClick(Sender: TObject);
begin
  ExibeTelaFaturaCartao;
end;

procedure TfrmPrincipal.mnuFormasPgtoClick(Sender: TObject);
begin
  ExibeTelaFrPgto;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

  //  Mostra o Usuario logado
  KeyPreview := True;

  //  Pega as datas do mês para os relatorios iniciais
  FDtIni := StartOfTheMonth(Now);
  FDtFim := EndOfTheMonth(Now);

end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 if Key = VK_F5 then
  begin
    //  Atualiza os valores da tela inicial
    ResumoMensalCaixa;
    TotalCP;
    TotalCR;
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin

  //  Cria o Form do splash
  frmSplash := TfrmSplash.Create(Self);
  try
    //  Exibe o form
    frmSplash.ShowModal;
  finally
    //  Libera da memoria
    FreeAndNil(frmSplash);
  end;


  if dmUsuarios.TblUsuariosVazia = True then
  begin
    //  Cria o form
    frmCadAdmin := TfrmCadAdmin.Create(Self);
    try

      //  Exibe o form
      frmCadAdmin.ShowModal;

      if frmCadAdmin.ModalResult <> mrOk then
        Application.Terminate;

    finally
      FreeAndNil(frmCadAdmin);
    end;

  end;

  //  Cria o Form do Login
  frmLogin := TfrmLogin.Create(Self);
  try

    //  Exibe o form
    frmLogin.ShowModal;

    if frmLogin.ModalResult <> mrOk then
      Application.Terminate;

  finally

    //  Libera da memoria
    FreeAndNil(frmLogin);

  end;

  if dmUsuarios.GetUsuarioLogado.Senha_Temp = 'S' then
  begin

    frmRedefinirSenha := TfrmRedefinirSenha.Create(nil);
    try

      frmRedefinirSenha.Usuario := dmUsuarios.GetUsuarioLogado;
      frmRedefinirSenha.ShowModal;

      if frmRedefinirSenha.ModalResult <> mrOk then
        Application.Terminate;

    finally
      FreeAndNil(frmRedefinirSenha);
    end;
  end;

  Self.Caption := 'Sistema Financeiro ' + TUtilitario.GetVesaoArq + ' - Desenvolvido por Altair Mateus T. Alencastro';
  CarregaImgPrincipal;
  ResumoMensalCaixa;
  TotalCP;
  TotalCR;
  lblUserLogado.Caption := dmUsuarios.GetUsuarioLogado.Nome;
end;

procedure TfrmPrincipal.mnuFornecedoresClick(Sender: TObject);
begin
  ExibeTelaFonecedores;
end;

procedure TfrmPrincipal.mnuLancamentoPadraoClick(Sender: TObject);
begin
  ExibeTelaLancamentoPadrao;
end;

procedure TfrmPrincipal.imgBtnFornecedoreClick(Sender: TObject);
begin
ExibeTelaFonecedores
end;

procedure TfrmPrincipal.mnuAjudaClick(Sender: TObject);
begin
  ExibeTelaAjuda;
end;

procedure TfrmPrincipal.mnuClientesClick(Sender: TObject);
begin
  ExibeTelaClientes;
end;

procedure TfrmPrincipal.mnuUsuariosClick(Sender: TObject);
begin
  ExibeTelaUsuario;
end;

procedure TfrmPrincipal.pnlNomeBtnFornecedoreClick(Sender: TObject);
begin
  ExibeTelaFonecedores
end;

procedure TfrmPrincipal.ResumoMensal1Click(Sender: TObject);
begin
  ExibeTelaRelMensalCP;
end;

procedure TfrmPrincipal.ResumoMensal2Click(Sender: TObject);
begin

  ExibeTelaRelMensalCR;

end;

procedure TfrmPrincipal.ResumoMensalCaixa;
var
  lResumoCaixa : TModelResumoCaixa;
  lDtIni : TDateTime;
  lDtFim   : TDateTime;

begin

  lDtIni := IncMonth(FDtIni, -2);
  lDtFim   := FDtFim;
  lResumoCaixa := TModelLancamentoCaixa.ResumoCaixa(lDtIni, lDtFim);
  lblValor.Caption := TUtilitario.FormatoMoeda(lResumoCaixa.SaldoFinal);

  if lResumoCaixa.SaldoFinal > 0 then
  begin

    imgLucro.Visible := True;
    imgPerda.Visible := False;
    imgNormal.Visible := False;
    pnlSaldoParcial.Color := $006FE76E;

  end
  else if lResumoCaixa.SaldoFinal < 0 then
  begin
    imgLucro.Visible := False;
    imgPerda.Visible := True;
    imgNormal.Visible := False;
    pnlSaldoParcial.Color := $003838F7;
  end
  else
  begin
    imgLucro.Visible := False;
    imgPerda.Visible := False;
    imgNormal.Visible := True;
    pnlSaldoParcial.Color := $0000CAE6;
  end;

end;

procedure TfrmPrincipal.SaldodoCaixa1Click(Sender: TObject);
begin
  ExibeTelaSaldoCaixa;
end;

procedure TfrmPrincipal.TotalCP;
begin
  lblValorCP.Caption := TUtilitario.FormatoMoeda(dmCPagar.TotalCP(FDtIni, FDtFim));
end;

procedure TfrmPrincipal.TotalCR;
begin
  lblValorCR.Caption := TUtilitario.FormatoMoeda(TModelCR.TotalCR(FDtIni, FDtFim));
end;

end.
