unit SistemaFinanceiro.View.BaixarCP.FrPgto;

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
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.ImageList,
  Vcl.ImgList,
  SistemaFinanceiro.View.FrPgto,
  Datasnap.DBClient,
  SistemaFinanceiro.Model.Entidades.PgtoBxCp,
  System.Generics.Collections,
  fMensagem,
  uEnumsUtils;

type
  TfrmFrPgtoBaixaCp = class(TForm)
    ImageList1: TImageList;
    pnlBotoes: TPanel;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    pnlForma: TPanel;
    lblCodFrPgto: TLabel;
    lblValorForma: TLabel;
    lblValorTotalCr: TLabel;
    lblValorRest: TLabel;
    lblNomeFrPgto: TLabel;
    edtCodFrPgto: TEdit;
    btnPesqFrPgto: TButton;
    edtValorForma: TEdit;
    edtValorCp: TEdit;
    edtValorRest: TEdit;
    btnAdiciona: TButton;
    btnLimpar: TButton;
    pnlGrid: TPanel;
    DBGrid1: TDBGrid;
    dsFrPgto: TDataSource;
    cdsFrPgto: TClientDataSet;
    cdsFrPgtoID_FR: TIntegerField;
    cdsFrPgtoNOME: TWideStringField;
    cdsFrPgtoVALORPAGO: TCurrencyField;
    procedure FormCreate(Sender: TObject);
    procedure edtValorFormaEnter(Sender: TObject);
    procedure edtCodFrPgtoExit(Sender: TObject);
    procedure btnPesqFrPgtoClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnAdicionaClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FTelaAtiva: Boolean;
    FIdCp: Integer;
    FValorAbater: Double;
    FListaPagamentos: TObjectList<TModelPgtoBxCp>;
    procedure BuscaNomeFrPgto;

    function ValidaIniciarPagamentos: Boolean;
    procedure InicializaTela;
    procedure AdicionaPagamento;

    procedure SetIdCp(const Value: Integer);
    procedure SetValorAbater(const Value: Double);
    procedure AdicionaPgtoGrid(const pValorForma: Double);

    procedure ConfirmarPagamentos;
  public
    property IdCp: Integer read FIdCp write SetIdCp;
    property ValorAbater: Double read FValorAbater write SetValorAbater;

    function ObterPagamentos: TObjectList<TModelPgtoBxCp>;

  end;

var
  frmFrPgtoBaixaCp: TfrmFrPgtoBaixaCp;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Model.dmFrPgto,
  SistemaFinanceiro.Model.dmPgtoBxCp,
  SistemaFinanceiro.Utilitarios;

procedure TfrmFrPgtoBaixaCp.AdicionaPagamento;
var
  lValorForma: Double;
  lValorRest: Double;
begin

  // Valida Campos
  if (not TryStrToFloat(edtValorRest.Text, lValorRest)) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor Restante Inválido!', tmAviso);
    Exit;
  end;

  if (not TryStrToFloat(edtValorForma.Text, lValorForma)) or (lValorForma <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor da Forma Inválido!!', tmAviso);
    edtValorForma.SetFocus;
    Exit;
  end;

  if (Trim(edtCodFrPgto.Text).IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Forma de Pagamento não informada!', tmAviso);
    edtCodFrPgto.SetFocus;
    Exit;
  end;

  if ((lValorForma > FValorAbater) or (lValorForma > lValorRest)) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor da Forma não pode ser maior que o valor da conta!', tmAviso);
    edtValorForma.Clear;
    edtValorForma.SetFocus;
    Exit;
  end;

  // Calculando o valor restante
  lValorRest := lValorRest - lValorForma;
  edtValorRest.Text := FloatToStr(lValorRest);

  AdicionaPgtoGrid(lValorForma);

  if (lValorRest = 0) then
    btnConfirmar.SetFocus;

end;

procedure TfrmFrPgtoBaixaCp.btnAdicionaClick(Sender: TObject);
begin
  AdicionaPagamento;
end;

procedure TfrmFrPgtoBaixaCp.btnConfirmarClick(Sender: TObject);
begin
  ConfirmarPagamentos;
end;

procedure TfrmFrPgtoBaixaCp.btnLimparClick(Sender: TObject);
begin

  cdsFrPgto.EmptyDataSet;

  // Reinicia o valor restante
  edtValorRest.Text := Trim(edtValorCp.Text);

  // Limpa os campos
  edtCodFrPgto.Clear;
  edtValorForma.Clear;
  lblNomeFrPgto.Caption := '';

  edtCodFrPgto.SetFocus;

end;

procedure TfrmFrPgtoBaixaCp.btnPesqFrPgtoClick(Sender: TObject);
begin
  // Cria o form
  frmFrPgto := TfrmFrPgto.Create(Self);

  try

    // Exibe o form
    frmFrPgto.ShowModal;

  finally

    // Pega a ID da forma de pgto selecionado
    edtCodFrPgto.Text := frmFrPgto.DataSourceFrPgto.DataSet.FieldByName('ID_FR').AsString;

    // Libera da  memoria
    FreeAndNil(frmFrPgto);

  end;

  edtCodFrPgto.SetFocus;

end;

procedure TfrmFrPgtoBaixaCp.BuscaNomeFrPgto;
var
  NomeFrPgto: String;

begin

  if Trim(edtCodFrPgto.Text) <> '' then
  begin

    NomeFrPgto := dmFrPgto.GetNomeFrPgto(Trim(edtCodFrPgto.Text));

    if (Trim(edtCodFrPgto.Text) = '') or (NomeFrPgto = '') then
    begin

      Application.MessageBox('Forma de Pagamento não encontrada!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
      edtCodFrPgto.SetFocus;
      edtCodFrPgto.Clear;

    end;

    lblNomeFrPgto.Visible := True;
    lblNomeFrPgto.Caption := NomeFrPgto;

  end;

end;

procedure TfrmFrPgtoBaixaCp.ConfirmarPagamentos;
var
  lContador: Integer;
  lTotalPgtos: Double;
  lValorCp: Double;
  lFormaPgto: TModelPgtoBxCp;
begin

  lTotalPgtos := 0;
  lContador := 0;

  if (cdsFrPgto.IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção', 'Nenhuma forma de pagamento informada!', tmAviso);
    Exit;
  end;

  // Valida valor CR
  if ((not TryStrToFloat(edtValorCp.Text, lValorCp)) or (lValorCp <= 0)) then
  begin
    TfrmMensagem.TelaMensagem('Atenção', 'Valor da Conta a Pagar Inválido', tmAviso);
    Exit;
  end;

  // Coloca na primeira posição do dataset
  cdsFrPgto.First;

  // Soma o total das formas de pagamento
  while not cdsFrPgto.Eof do
  begin
    lTotalPgtos := lTotalPgtos + cdsFrPgto.FieldByName('VALORPAGO').AsFloat;
    cdsFrPgto.Next;
  end;

  // Compara o valor total e o valor da conta
  if (lTotalPgtos < lValorCp) then
  begin
    TfrmMensagem.TelaMensagem('Atenção', 'Valor das formas de pagamento menor que o valor da conta!', tmAviso);
    Exit;
  end;

  // Coloca na primeira posição do dataset
  cdsFrPgto.First;

  // Adicionando as formas em uma lista de objetos
  // para serem salvas pela tela que a invocar
  while not cdsFrPgto.Eof do
  begin

    lContador := lContador + 1;

    lFormaPgto := TModelPgtoBxCp.Create;
    lFormaPgto.GeraCodigo;
    lFormaPgto.IdCp := FIdCp;
    lFormaPgto.IdFrPgto := cdsFrPgtoID_FR.AsInteger;
    lFormaPgto.NrPgto := lContador;
    lFormaPgto.DataHora := Now;
    lFormaPgto.ValorPago := cdsFrPgtoVALORPAGO.AsFloat;

    FListaPagamentos.Add(lFormaPgto);

  end;

  // Fecha a tela
  Modalresult := mrOk;

end;

procedure TfrmFrPgtoBaixaCp.edtCodFrPgtoExit(Sender: TObject);
begin

  BuscaNomeFrPgto;

  if Trim(edtCodFrPgto.Text) <> '' then
  begin
    if dmFrPgto.GetStatus(Trim(edtCodFrPgto.Text)) = False then
    begin

      edtCodFrPgto.Clear;
      edtCodFrPgto.SetFocus;
      lblNomeFrPgto.Caption := '';
      Application.MessageBox('Forma de Pagamento não está Ativa!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;
  end;

end;

procedure TfrmFrPgtoBaixaCp.edtValorFormaEnter(Sender: TObject);
begin
  // Assume previamente o valor total da Cp
  edtValorForma.Text := edtValorRest.Text;
end;

procedure TfrmFrPgtoBaixaCp.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin

    FTelaAtiva := True;

    if not(ValidaIniciarPagamentos) then
    begin
      TUtilitario.FecharFormulario(Self);
      Exit;
    end;

  end;
end;

procedure TfrmFrPgtoBaixaCp.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;
  FListaPagamentos := TObjectList<TModelPgtoBxCp>.Create;
end;

procedure TfrmFrPgtoBaixaCp.FormDestroy(Sender: TObject);
begin
  FListaPagamentos.Free;
end;

procedure TfrmFrPgtoBaixaCp.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    // Verifica se a tecla pressionada é o Enter
    // Cancela o efeito do enter
    Key := #0;
    // Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmFrPgtoBaixaCp.FormShow(Sender: TObject);
begin
  InicializaTela;
end;

procedure TfrmFrPgtoBaixaCp.InicializaTela;
begin
  edtCodFrPgto.SetFocus;
end;

procedure TfrmFrPgtoBaixaCp.KeyPressValor(Sender: TObject; var Key: Char);
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
  if not(CharInSet(Key, ['0' .. '9', FormatSettings.DecimalSeparator, #8, #13])) then
  begin
    Key := #0;
  end;

  // Valida se já existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

function TfrmFrPgtoBaixaCp.ObterPagamentos: TObjectList<TModelPgtoBxCp>;
begin
  Result := FListaPagamentos;
end;

procedure TfrmFrPgtoBaixaCp.AdicionaPgtoGrid(const pValorForma: Double);
begin

  // Coloca o dataset em modo de inserção
  cdsFrPgto.Insert;

  // Alimenta as colunas
  cdsFrPgtoID_FR.AsString := Trim(edtCodFrPgto.Text);
  cdsFrPgtoNOME.AsString := lblNomeFrPgto.Caption;
  cdsFrPgtoVALORPAGO.AsCurrency := pValorForma;

  // Salva no data set
  cdsFrPgto.Post;

  edtValorForma.Clear;
  edtCodFrPgto.Clear;
  edtCodFrPgto.SetFocus;
  lblNomeFrPgto.Caption := '';

end;

procedure TfrmFrPgtoBaixaCp.SetIdCp(const Value: Integer);
begin
  FIdCp := Value;
end;

procedure TfrmFrPgtoBaixaCp.SetValorAbater(const Value: Double);
begin
  FValorAbater := Value;
  edtValorCp.Text := FloatToStr(FValorAbater);
  edtValorRest.Text := FloatToStr(FValorAbater);
end;

function TfrmFrPgtoBaixaCp.ValidaIniciarPagamentos: Boolean;
begin
  Result := False;

  if (FIdCp <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Erro!', 'ID do contas a Pagar Inválido!', tmErro);
    Exit;
  end;

  if (FValorAbater <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Erro!', 'Valor da Conta a Pagar não pode ser menor que zero!', tmErro);
    Exit;
  end;

  Result := True;
end;

end.
