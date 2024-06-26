unit SistemaFinanceiro.View.BaixarCR.FrPgto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList, Datasnap.DBClient,
  SistemaFinanceiro.View.FrPgto;

type
  TfrmFrPgtoBaixaCr = class(TForm)
    pnlBotoes: TPanel;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    ImageList1: TImageList;
    pnlForma: TPanel;
    pnlGrid: TPanel;
    DBGrid1: TDBGrid;
    dsFrPgto: TDataSource;
    cdsFrPgto: TClientDataSet;
    lblCodFrPgto: TLabel;
    edtCodFrPgto: TEdit;
    btnPesqFrPgto: TButton;
    edtValorForma: TEdit;
    lblValorForma: TLabel;
    lblValorTotalCr: TLabel;
    edtValorCr: TEdit;
    edtValorRest: TEdit;
    lblValorRest: TLabel;
    cdsFrPgtoNome: TWideStringField;
    cdsFrPgtovalorpago: TCurrencyField;
    btnAdiciona: TButton;
    btnLimpar: TButton;
    cdsFrPgtoid_fr: TIntegerField;
    lblNomeFrPgto: TLabel;
    procedure btnPesqFrPgtoClick(Sender: TObject);
    procedure edtValorFormaEnter(Sender: TObject);
    procedure btnAdicionaClick(Sender: TObject);
    procedure edtCodFrPgtoExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FId : Integer;
    procedure BuscaNomeFrPgto;
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure EditKeyPress(Sender: TObject; var Key: Char);

  public
    { Public declarations }
    procedure FrPgtoCr(pId : Integer; pValorCr : Double);

  end;

var
  frmFrPgtoBaixaCr: TfrmFrPgtoBaixaCr;

implementation

{$R *.dfm}

uses

  SistemaFinanceiro.Model.dmFrPgto, SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.Entidades.PgtoBxCr;

procedure TfrmFrPgtoBaixaCr.btnAdicionaClick(Sender: TObject);
var
  lValorForma : Double;
  lValorRest  : Double;
  ValorCr    : Double;
begin

  //  Valida Campos
  if (not TryStrToFloat(edtValorCr.Text, ValorCr)) or (ValorCr <= 0) then
  begin
    Application.MessageBox('Valor da Conta a Receber Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if not TryStrToFloat(edtValorRest.Text, lValorRest) then
  begin
    Application.MessageBox('Valor Restante Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if (not TryStrToFloat(edtValorForma.Text, lValorForma)) or (lValorForma <= 0) then
  begin
    edtValorForma.SetFocus;
    Application.MessageBox('Valor da Forma Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if Trim(edtCodFrPgto.Text) = '' then
  begin
    edtCodFrPgto.SetFocus;
    Application.MessageBox('Forma de Pagamento n�o informada!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if (lValorForma > ValorCr) or (lValorForma > lValorRest) then
  begin
    edtValorForma.Clear;
    edtValorForma.SetFocus;
    Application.MessageBox('Valor da Forma n�o pode ser maior que o valor da conta!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  //  Calculando o valor restante
  lValorRest         := lValorRest - lValorForma;
  edtValorRest.Text := FloatToStr(lValorRest);

  //  Coloca o dataset em modo de inser��o
  cdsFrPgto.Insert;

  //  Alimenta as colunas
  cdsFrPgtoid_fr.AsString       := Trim(edtCodFrPgto.Text);
  cdsFrPgtoNome.AsString        := lblNomeFrPgto.Caption;
  cdsFrPgtovalorpago.AsCurrency := lValorForma;

  // Salva no data set
  cdsFrPgto.Post;


  edtValorForma.Clear;
  edtCodFrPgto.Clear;
  edtCodFrPgto.SetFocus;
  lblNomeFrPgto.Caption:= '';

  if lValorRest = 0 then
  begin
    btnConfirmar.SetFocus;
  end;

end;

procedure TfrmFrPgtoBaixaCr.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFrPgtoBaixaCr.btnConfirmarClick(Sender: TObject);
var
  lContador   : Integer;
  lTotalPgtos : Double;
  lValorCr    : Double;
  lFrPgtoCr : TModelPgtoBxCr;
begin

  lTotalPgtos := 0;
  lContador   := 0;

  //  Valida valor CR
  if (not TryStrToFloat(edtValorCr.Text, lValorCr)) or (lValorCr <= 0) then
  begin
    Application.MessageBox('Valor da Conta a Receber Inv�lido!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  if cdsFrPgto.IsEmpty then
  begin
    Application.MessageBox('Nenhuma forma de pagamento informada!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Coloca na primeira posi��o do dataset
  cdsFrPgto.First;

  //  Soma o valor de todas as formas de pagamento
  while not cdsFrPgto.Eof do
  begin
    lTotalPgtos := lTotalPgtos + cdsFrPgto.FieldByName('VALORPAGO').AsFloat;
    //  Avan�a para o proximo
    cdsFrPgto.Next;
  end;

  //  Compara com o valor total do CR
  if lTotalPgtos < lValorCr then
  begin
    Application.MessageBox('Valor das formas de pagamento menor que o valor da conta!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

  // Coloca na primeira posi��o do dataset
  cdsFrPgto.First;

  //  Gravando as formas de pagamento
  while not cdsFrPgto.Eof do
  begin
    lFrPgtoCr := TModelPgtoBxCr.Create;
    try
      lContador := lContador + 1;

      lFrPgtoCr.GeraCodigo;
      lFrPgtoCr.IdCr      := FId;
      lFrPgtoCr.IdFrPgto  := cdsFrPgtoid_fr.AsInteger;
      lFrPgtoCr.NrPgto    := lContador;
      lFrPgtoCr.DataHora  := Now;
      lFrPgtoCr.ValorPago := cdsFrPgtovalorpago.AsCurrency;

      //  Gravando no banco
      lFrPgtoCr.Insert;

      cdsFrPgto.Next;
    finally
      lFrPgtoCr.Free;
    end;

  end;

  //  Fecha a tela
  ModalResult := mrOk;

end;

procedure TfrmFrPgtoBaixaCr.btnLimparClick(Sender: TObject);
begin

  cdsFrPgto.EmptyDataSet;

  //  Reinicia o valor restante
  edtValorRest.Text := Trim(edtValorCr.Text);

  //  Limpa os campos
  edtCodFrPgto.Clear;
  edtValorForma.Clear;
  lblNomeFrPgto.Caption := '';

  edtCodFrPgto.SetFocus;

end;

procedure TfrmFrPgtoBaixaCr.btnPesqFrPgtoClick(Sender: TObject);
begin

  //  Cria o form
  frmFrPgto := TfrmFrPgto.Create(Self);

  try

    //  Exibe o form
    frmFrPgto.ShowModal;

  finally

    //  Pega a ID da forma de pgto selecionado
    edtCodFrPgto.Text := frmFrPgto.DataSourceFrPgto.DataSet.FieldByName('ID_FR').AsString;

    //  Libera da  memoria
    FreeAndNil(frmFrPgto);

  end;

  edtCodFrPgto.SetFocus;

end;

procedure TfrmFrPgtoBaixaCr.BuscaNomeFrPgto;
var
  NomeFrPgto : String;

begin

  if Trim(edtCodFrPgto.Text) <> '' then
  begin

    NomeFrPgto := dmFrPgto.GetNomeFrPgto(Trim(edtCodFrPgto.Text));

    if (Trim(edtCodFrPgto.Text) = '') or (NomeFrPgto = '') then
    begin

      Application.MessageBox('Forma de Pagamento n�o encontrada!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      edtCodFrPgto.SetFocus;
      edtCodFrPgto.Clear;

    end;

    lblNomeFrPgto.Visible := True;
    lblNomeFrPgto.Caption := NomeFrPgto;

  end;


end;

procedure TfrmFrPgtoBaixaCr.EditKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    //  Verifica se a tecla pressionada � o Enter
    //  Cancela o efeito do enter
    Key := #0;
    //  Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

end;

procedure TfrmFrPgtoBaixaCr.edtCodFrPgtoExit(Sender: TObject);
begin

  BuscaNomeFrPgto;

  if Trim(edtCodFrPgto.Text) <> '' then
  begin
    if dmFrPgto.GetStatus(Trim(edtCodFrPgto.Text)) = False then
    begin

      edtCodFrPgto.Clear;
      edtCodFrPgto.SetFocus;
      lblNomeFrPgto.Caption := '';
      Application.MessageBox('Forma de Pagamento n�o est� Ativa!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;
  end;


end;

procedure TfrmFrPgtoBaixaCr.edtValorFormaEnter(Sender: TObject);
begin

  //  Assume previamente o valor total da CR
  edtValorForma.Text := edtValorRest.Text;

end;

procedure TfrmFrPgtoBaixaCr.FormCreate(Sender: TObject);
begin

  //  Coloca no KeyPress a formata��o para valores
  edtValorCr.OnKeyPress    := KeyPressValor;
  edtValorRest.OnKeyPress  := KeyPressValor;
  edtValorForma.OnKeyPress := KeyPressValor;

  edtCodFrPgto.OnKeyPress := EditKeyPress;

end;

procedure TfrmFrPgtoBaixaCr.FormShow(Sender: TObject);
begin
  edtCodFrPgto.SetFocus;
end;

procedure TfrmFrPgtoBaixaCr.FrPgtoCr(pId: Integer; pValorCr : Double);
begin

  FID := pId;

  //  Valida ID do CR
  if FID < 0 then
  begin
    raise Exception.Create('ID do contas a receber Inv�lido!');
  end;

  if pValorCr <= 0 then
  begin
    raise Exception.Create('Valor da Conta a Receber Inv�lido!');
  end;

  // Puxa o valor da CR
  edtValorCr.Text   := FloatToStr(pValorCr);
  edtValorRest.Text := FloatToStr(pValorCr);

  edtValorForma.Clear;

end;

procedure TfrmFrPgtoBaixaCr.KeyPressValor(Sender: TObject; var Key: Char);
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

end.
