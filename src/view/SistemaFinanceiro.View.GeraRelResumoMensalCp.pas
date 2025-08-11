unit SistemaFinanceiro.View.GeraRelResumoMensalCp;

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
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  System.ImageList,
  Vcl.ImgList,
  SistemaFinanceiro.View.FaturaCartao,
  SistemaFinanceiro.View.Fornecedores,
  SistemaFinanceiro.View.Relatorios.ResumoMensalCp,
  fMensagem;

type
  TfrmGeraRelResumoMensalCp = class(TForm)
    pnlGeral: TPanel;
    pnlFiltros: TPanel;
    pnlBotoes: TPanel;
    dateIni: TDateTimePicker;
    lblDtIni: TLabel;
    lblDtFinal: TLabel;
    dateFinal: TDateTimePicker;
    edtCodFornec: TEdit;
    lblFornec: TLabel;
    lblFatura: TLabel;
    edtCodFatCartao: TEdit;
    btnPesqFornec: TButton;
    btnPesqFatCartao: TButton;
    ImageList1: TImageList;
    lblStatus: TLabel;
    cbStatus: TComboBox;
    gbData: TGroupBox;
    rbDtCompra: TRadioButton;
    rbDtVenc: TRadioButton;
    rbDtPag: TRadioButton;
    btnVisualizar: TButton;
    btnImprimir: TButton;
    btnCancelar: TButton;
    pnlTitulo: TPanel;
    pnlCheckBox: TPanel;
    checkNaoConsideraFat: TCheckBox;
    checkVencidas: TCheckBox;
    checkParciais: TCheckBox;
    checkAgrupaFatura: TCheckBox;
    checkTracoLinha: TCheckBox;
    checkDestacaLinha: TCheckBox;
    procedure btnPesqFornecClick(Sender: TObject);
    procedure btnPesqFatCartaoClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure checkNaoConsideraFatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FRelatorio: TfrmRelMensalCp;

    procedure CriaObjRelatorio;
    procedure GeraRelatorio;
    procedure GeraFiltros;
    procedure GeraImpressao;
    function ValidaFiltros: Boolean;

  public
    { Public declarations }
  end;

var
  frmGeraRelResumoMensalCp: TfrmGeraRelResumoMensalCp;

implementation

uses
  System.DateUtils,
  uEnumsUtils;

{$R *.dfm}


procedure TfrmGeraRelResumoMensalCp.btnImprimirClick(Sender: TObject);
begin
  if not(ValidaFiltros) then
    Exit;

  CriaObjRelatorio;
  GeraFiltros;
  GeraImpressao;
end;

procedure TfrmGeraRelResumoMensalCp.btnPesqFornecClick(Sender: TObject);
var
  lFormulario: TfrmFornecedores;
begin

  lFormulario := TfrmFornecedores.Create(Self);
  try

    lFormulario.ShowModal;

    // Pega a ID do cliente selecionado
    edtCodFornec.Text := lFormulario.RetornaCodigo;

  finally
    lFormulario.Free;
  end;

  edtCodFornec.SetFocus;

end;

procedure TfrmGeraRelResumoMensalCp.btnVisualizarClick(Sender: TObject);
begin
  if not(ValidaFiltros) then
    Exit;

  CriaObjRelatorio;
  GeraFiltros;
  GeraRelatorio;
end;

procedure TfrmGeraRelResumoMensalCp.checkNaoConsideraFatClick(Sender: TObject);
begin
  btnPesqFatCartao.Enabled := (not checkNaoConsideraFat.Checked);
  edtCodFatCartao.Enabled := (not checkNaoConsideraFat.Checked);
  checkAgrupaFatura.Checked := (not checkNaoConsideraFat.Checked);
  checkAgrupaFatura.Enabled := (not checkNaoConsideraFat.Checked);

  if checkNaoConsideraFat.Checked then
    edtCodFatCartao.Clear;

end;

procedure TfrmGeraRelResumoMensalCp.CriaObjRelatorio;
begin
  if Assigned(FRelatorio) then
    FreeAndNil(FRelatorio);

  FRelatorio := TfrmRelMensalCp.Create(nil);
end;

procedure TfrmGeraRelResumoMensalCp.btnPesqFatCartaoClick(Sender: TObject);
var
  lFormulario: TfrmFaturaCartao;
begin

  lFormulario := TfrmFaturaCartao.Create(Self);
  try

    lFormulario.ShowModal;
    // Pega a Id da fatura selecionada
    edtCodFatCartao.Text := lFormulario.RetornaCodigo;

  finally
    lFormulario.Free;
  end;

  edtCodFatCartao.SetFocus;

end;

procedure TfrmGeraRelResumoMensalCp.FormDestroy(Sender: TObject);
begin
  if Assigned(FRelatorio) then
    FRelatorio.Free;
end;

procedure TfrmGeraRelResumoMensalCp.FormShow(Sender: TObject);
begin
  // Define as datas previamente
  dateIni.Date := StartOfTheYear(Now);
  dateFinal.Date := EndOfTheYear(Now);
end;

function TfrmGeraRelResumoMensalCp.ValidaFiltros: Boolean;
begin

  Result := False;

  if (dateIni.Date > dateFinal.Date) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Data Inicial não pode ser maior que a data Final!', tmAviso);
    dateFinal.SetFocus;
    Exit;
  end;

  if (cbStatus.ItemIndex < 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Selecione um tipo de STATUS!', tmAviso);
    cbStatus.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmGeraRelResumoMensalCp.GeraFiltros;
begin

  FRelatorio.DtInicial := dateIni.Date;
  FRelatorio.DtFinal := dateFinal.Date;
  FRelatorio.AgruparFatura := checkAgrupaFatura.Checked;
  FRelatorio.ConsidDtCompra := rbDtCompra.Checked;
  FRelatorio.ConsidDtVcto := rbDtVenc.Checked;

  case cbStatus.ItemIndex of
    1:
      FRelatorio.StatusCp := sctPaga;
    2:
      FRelatorio.StatusCp := sctAberta;
    3:
      FRelatorio.StatusCp := sctCancelada;
  end;

  FRelatorio.CodFornecedor := Trim(edtCodFornec.Text);
  FRelatorio.CodFaturaCartao := Trim(edtCodFatCartao.Text);
  FRelatorio.SomenteParciais := checkParciais.Checked;
  FRelatorio.Vencidas := checkVencidas.Checked;
  FRelatorio.FiltrarFatCartao := not(checkNaoConsideraFat.Checked);
  FRelatorio.TracoLinha := checkTracoLinha.Checked;
  FRelatorio.DestacaLinha := checkDestacaLinha.Checked;

end;

procedure TfrmGeraRelResumoMensalCp.GeraImpressao;
begin
  FRelatorio.RLReport.Print;
end;

procedure TfrmGeraRelResumoMensalCp.GeraRelatorio;
begin
  FRelatorio.RLReport.Preview;
end;

end.
