unit SistemaFinanceiro.View.BxMulti.InfosBx;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  System.ImageList,
  Vcl.ImgList,
  SistemaFinanceiro.View.FrPgto,
  Vcl.Imaging.pngimage,
  Vcl.ComCtrls,
  fMensagem,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe;

type
  TfrmInfoBxMult = class(TForm)
    pnlGeral: TPanel;
    pnlBotoes: TPanel;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    ImageList1: TImageList;
    pnlFundoFrPgto: TPanel;
    pnlFrPgto: TPanel;
    lblNomeFrPgto: TLabel;
    btnPesqFrPgto: TButton;
    edtCodFrPgto: TEdit;
    pnlImgFrPgto: TPanel;
    imgPgto: TImage;
    pnlFundoInfo: TPanel;
    pnlInfos: TPanel;
    Label1: TLabel;
    lblValor: TLabel;
    lblDesconto: TLabel;
    lblValorDesc: TLabel;
    pnlImgInfos: TPanel;
    Image1: TImage;
    datePgto: TDateTimePicker;
    edtValor: TEdit;
    checkDesconto: TCheckBox;
    edtPorcDesc: TEdit;
    edtValorDesc: TEdit;
    procedure btnPesqFrPgtoClick(Sender: TObject);
    procedure edtCodFrPgtoExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure checkDescontoClick(Sender: TObject);
    procedure edtPorcDescKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPorcDescKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorDescKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorDescKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);

  private
    FTelaAtiva: Boolean;
    FCpDetalhe: TModelCpDetalhe;
    FCodFrPgto: Integer;
    FValorCpSel: Double;
    FDtMaisAnt: TDate;

    procedure InicializaTela;
    function ValidaInicializacao: Boolean;
    procedure BuscaNomeFrPgto;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    function CalcValorDesc: Double;
    function CalcPorcentDesc: Double;

    function ValidaCampos: Boolean;
    procedure Confirmar;

  public
    property CodFrPgto: Integer read FCodFrPgto;
    property ValorCpSel: Double read FValorCpSel write FValorCpSel;
    property DtMaisAnt: TDate read FDtMaisAnt write FDtMaisAnt;
    function ObterDetalhes: TModelCpDetalhe;

  end;

var
  frmInfoBxMult: TfrmInfoBxMult;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Model.dmFrPgto,
  SistemaFinanceiro.Utilitarios,
  uEnumsUtils,
  SistemaFinanceiro.Model.dmUsuarios;

{ TfrmFrPgtoBxMultCp }

procedure TfrmInfoBxMult.btnCancelarClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TfrmInfoBxMult.btnPesqFrPgtoClick(Sender: TObject);
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

  btnConfirmar.SetFocus;

end;

procedure TfrmInfoBxMult.BuscaNomeFrPgto;
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

function TfrmInfoBxMult.CalcPorcentDesc: Double;
var
  lValorFinal: Double;
  lPorcentDesc: Double;
  lValorDesc: Double;
  lValorCp: Double;

begin

  lValorCp := FValorCpSel;
  lValorDesc := 0;
  lValorFinal := 0;
  lPorcentDesc := 0;
  Result := 0;

  TryStrToFloat(edtPorcDesc.Text, lPorcentDesc);
  TryStrToFloat(edtValorDesc.Text, lValorDesc);

  if lPorcentDesc > 0 then
  begin

    // Calcula o valor do desconto
    lValorDesc := (lPorcentDesc / 100) * lValorCp;

    // Atribui o valor do desconto ao campo
    edtValorDesc.Text := CurrToStr(lValorDesc);

    // Calcula o valor final
    lValorFinal := lValorCp - lValorDesc;

    // retorna o valor final
    Result := lValorFinal;

  end;

end;

function TfrmInfoBxMult.CalcValorDesc: Double;
var
  lValorCp: Double;
  lValorDesc: Double;
  lValorFinal: Double;
  lPorcentDesc: Double;
begin

  Result := 0;

  lValorCp := FValorCpSel;
  lValorDesc := 0;
  lValorFinal := 0;
  lPorcentDesc := 0;

  TryStrToFloat(edtPorcDesc.Text, lPorcentDesc);
  TryStrToFloat(edtValorDesc.Text, lValorDesc);

  if lValorDesc > 0 then
  begin

    // Calcula a porcentagem de desconto
    lPorcentDesc := (lValorDesc / lValorCp) * 100;

    // Atribui a porcentagem no campo
    edtPorcDesc.Text := CurrToStr(lPorcentDesc);

    // Calcula o valor final
    lValorFinal := lValorCp - lValorDesc;

    // retorna o valor final
    Result := lValorFinal;

  end;

end;

procedure TfrmInfoBxMult.checkDescontoClick(Sender: TObject);
begin

  if checkDesconto.Checked then
  begin

    // Libera e mostra os campos do desconto
    edtValorDesc.Enabled := True;
    edtValorDesc.Visible := True;
    edtPorcDesc.Visible := True;
    edtPorcDesc.Enabled := True;
    lblDesconto.Visible := True;
    lblValorDesc.Visible := True;

  end
  else
  begin

    // Bloqueia e oculta os campos do desconto
    edtValorDesc.Enabled := False;
    edtValorDesc.Visible := False;
    edtPorcDesc.Visible := False;
    edtPorcDesc.Enabled := False;
    lblDesconto.Visible := False;
    lblValorDesc.Visible := False;

  end;
end;

procedure TfrmInfoBxMult.Confirmar;
begin
  FCpDetalhe := TModelCpDetalhe.Create;

  FCpDetalhe.GeraCodigo;
  FCpDetalhe.Valor := StrToFloatDef(Trim(edtValor.Text), 0);
  FCpDetalhe.Data := datePgto.Date;
  FCpDetalhe.Usuario := dmUsuarios.GetUsuarioLogado.id;
  FCpDetalhe.ValorDesc := StrToFloatDef(Trim(edtValorDesc.Text), 0);

  FCodFrPgto := StrToIntDef(Trim(edtCodFrPgto.Text), 0);

end;

procedure TfrmInfoBxMult.edtCodFrPgtoExit(Sender: TObject);
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

procedure TfrmInfoBxMult.edtPorcDescKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcPorcentDesc);
end;

procedure TfrmInfoBxMult.edtPorcDescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcPorcentDesc);
end;

procedure TfrmInfoBxMult.edtValorDescKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcValorDesc);
end;

procedure TfrmInfoBxMult.edtValorDescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcValorDesc);
end;

procedure TfrmInfoBxMult.edtValorExit(Sender: TObject);
begin
  edtValor.Text := TUtilitario.FormatarValor(Trim(edtValor.Text));
end;

procedure TfrmInfoBxMult.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin

    if not(ValidaInicializacao) then
    begin
      TUtilitario.FecharFormulario(Self);
      Exit;
    end;

    InicializaTela;
    FTelaAtiva := True;
  end;
end;

procedure TfrmInfoBxMult.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;

  if (ModalResult = mrOk) then
  begin

    if not(ValidaCampos) then
      Exit;

    Confirmar;

  end;

  CanClose := True;
end;

procedure TfrmInfoBxMult.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;

  // Coloca no KeyPress o enter para ir para o proximo campo
  datePgto.OnKeyPress := EditKeyPress;
  edtValor.OnKeyPress := KeyPressValor;
  edtValorDesc.OnKeyPress := KeyPressValor;
  edtPorcDesc.OnKeyPress := KeyPressValor;
  edtCodFrPgto.OnKeyPress := EditKeyPress;

end;

procedure TfrmInfoBxMult.InicializaTela;
begin
  datePgto.Date := Now;
end;

procedure TfrmInfoBxMult.KeyPressValor(Sender: TObject; var Key: Char);
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

function TfrmInfoBxMult.ObterDetalhes: TModelCpDetalhe;
begin

end;

function TfrmInfoBxMult.ValidaCampos: Boolean;
var
  lValorPago: Double;
  lDesconto: Double;
begin
  Result := False;

  if not(Trim(edtCodFrPgto.Text).IsEmpty) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Forma de Pagamento não informada!', tmAviso);
    edtCodFrPgto.SetFocus;
    Exit;
  end;

  if (not TryStrToFloat(edtValor.Text, lValorPago)) or (lValorPago <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor inválido!', tmAviso);
    edtValor.SetFocus;
    Exit;
  end;

  if (lValorPago > FValorCpSel) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor pago não pode ser maior que o valor das parcelas!', tmAviso);
    edtValor.SetFocus;
    Exit;
  end;

  if (checkDesconto.Checked) then
  begin

    if (not TryStrToFloat(edtValorDesc.Text, lDesconto)) or (lDesconto > FValorCpSel) then
    begin
      TfrmMensagem.TelaMensagem('Atenção!', 'Valor de desconto inválido!', tmAviso);
      edtValorDesc.SetFocus;
      Exit;
    end;

  end;

  if (datePgto.Date < FDtMaisAnt) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'A data de pagamento não pode ser menor que a data da compra!', tmAviso);
    datePgto.SetFocus;
    Exit;
  end;

  if (datePgto.Date > Now) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'A data de pagamento não pode ser maior que a data atual!', tmAviso);
    datePgto.SetFocus;
    Exit;
  end;

  Result := True;
end;

function TfrmInfoBxMult.ValidaInicializacao: Boolean;
begin
  Result := False;

  if not(FValorCpSel > 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor total das contas selecionadas deve ser maior que zero.', tmAviso);
    Exit;
  end;

  if (FDtMaisAnt > Now) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Data da CP mais antiga não pode ser maior que a data atual.', tmAviso);
    Exit;
  end;

  Result := True;
end;

procedure TfrmInfoBxMult.EditKeyPress(Sender: TObject; var Key: Char);
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

end.
