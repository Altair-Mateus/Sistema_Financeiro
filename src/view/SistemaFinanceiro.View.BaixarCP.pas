unit SistemaFinanceiro.View.BaixarCP;

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
  SistemaFinanceiro.Model.Entidades.CP,
  Vcl.ComCtrls,
  SistemaFinanceiro.View.BaixarCP.FrPgto,
  fMensagem,
  uEnumsUtils,
  System.StrUtils,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe;

type
  TfrmBaixarCP = class(TForm)
    pnlPrincipal: TPanel;
    pnlDocInfo: TPanel;
    pnlDetalhes: TPanel;
    pnlBotoes: TPanel;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    ImageList1: TImageList;
    gbDocInfo: TGroupBox;
    lblNDoc: TLabel;
    lblParc: TLabel;
    lblVenc: TLabel;
    lblVParcela: TLabel;
    lblDataCompra: TLabel;
    lblDoc: TLabel;
    lblParcela: TLabel;
    lblVencimento: TLabel;
    lblValorParcela: TLabel;
    lblDtCompra: TLabel;
    lblId: TLabel;
    lblIdConta: TLabel;
    lblValorRestante: TLabel;
    lblVRestante: TLabel;
    lblIdFornec: TLabel;
    lblCodFornec: TLabel;
    gbDetalhes: TGroupBox;
    lblObs: TLabel;
    lblValor: TLabel;
    lblData: TLabel;
    lblDesconto: TLabel;
    lblValorDesc: TLabel;
    edtObs: TEdit;
    edtValor: TEdit;
    datePgto: TDateTimePicker;
    edtValorDesc: TEdit;
    checkDesconto: TCheckBox;
    edtPorcDesc: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure checkDescontoClick(Sender: TObject);
    procedure edtPorcDescKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorDescKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtPorcDescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorDescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FTelaAtiva: Boolean;
    DataCompra: TDateTime;
    FCp: TModelCP;
    FCpDetalhe: TModelCpDetalhe;

    // Cálculos de Desconto
    function CalcValorDesc: Currency;
    function CalcPorcentDesc: Currency;

    // Funções de Inicialização
    procedure InicializaCampos;

    // Funções de Validação
    function ValidaCampos: Boolean;

    // Funções de formatação
    procedure KeyPressValor(Sender: TObject; var Key: Char);

    procedure Confirmar;

  public
    property CP: TModelCP read FCp write FCp;

    function ObterDetalhes: TModelCpDetalhe;

  end;

var
  frmBaixarCP: TfrmBaixarCP;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.dmUsuarios;

{ TfrmBaixarCP }
procedure TfrmBaixarCP.InicializaCampos;
begin
  lblIdConta.Caption := IntToStr(FCp.id);
  lblParcela.Caption := IntToStr(FCp.Parcela);
  lblVencimento.Caption := FormatDateTime('dd/mm/yyyy', FCp.DataVencimento);
  lblValorParcela.Caption := 'R$ ' + TUtilitario.FormatarValor(FCp.ValorParcela);
  lblDtCompra.Caption := DateToStr(FCp.DataCompra);
  lblValorRestante.Caption := 'R$ ' + TUtilitario.FormatarValor((FCp.ValorParcela - FCp.ValorAbatido));
  lblCodFornec.Caption := IntToStr(FCp.IdFornecedor);
  lblDoc.Caption := IfThen(FCp.Doc.Trim.IsEmpty, 'Não Informado', FCp.Doc);
  DataCompra := FCp.DataCompra;
  edtValor.Text := FloatToStr(FCp.ValorParcela);
  datePgto.DateTime := Now;
end;

function TfrmBaixarCP.CalcPorcentDesc: Currency;
var
  ValorFinal: Currency;
  PorcentDesc: Currency;
  ValorDesc: Currency;
  ValorCp: Currency;

begin

  ValorCp := FCp.ValorParcela;
  ValorDesc := 0;
  ValorFinal := 0;
  PorcentDesc := 0;
  Result := 0;

  TryStrToCurr(edtPorcDesc.Text, PorcentDesc);
  TryStrToCurr(edtValorDesc.Text, ValorDesc);

  if PorcentDesc > 0 then
  begin

    // Calcula o valor do desconto
    ValorDesc := (PorcentDesc / 100) * ValorCp;

    // Atribui o valor do desconto ao campo
    edtValorDesc.Text := CurrToStr(ValorDesc);

    // Calcula o valor final
    ValorFinal := ValorCp - ValorDesc;

    // retorna o valor final
    Result := ValorFinal;

  end;

end;

function TfrmBaixarCP.CalcValorDesc: Currency;
var
  ValorCp: Currency;
  ValorDesc: Currency;
  ValorFinal: Currency;
  PorcentDesc: Currency;

begin

  Result := 0;

  ValorCp := FCp.ValorParcela;
  ValorDesc := 0;
  ValorFinal := 0;
  PorcentDesc := 0;

  TryStrToCurr(edtPorcDesc.Text, PorcentDesc);
  TryStrToCurr(edtValorDesc.Text, ValorDesc);

  if ValorDesc > 0 then
  begin

    // Calcula a porcentagem de desconto
    PorcentDesc := (ValorDesc / ValorCp) * 100;

    // Atribui a porcentagem no campo
    edtPorcDesc.Text := CurrToStr(PorcentDesc);

    // Calcula o valor final
    ValorFinal := ValorCp - ValorDesc;

    // retorna o valor final
    Result := ValorFinal;

  end;

end;

procedure TfrmBaixarCP.checkDescontoClick(Sender: TObject);
begin

  // Libera e mostra os campos do desconto
  edtValorDesc.Enabled := checkDesconto.Checked;
  edtValorDesc.Visible := checkDesconto.Checked;
  edtPorcDesc.Visible := checkDesconto.Checked;
  edtPorcDesc.Enabled := checkDesconto.Checked;
  lblDesconto.Visible := checkDesconto.Checked;
  lblValorDesc.Visible := checkDesconto.Checked;
end;

procedure TfrmBaixarCP.Confirmar;
begin
  FCpDetalhe := TModelCpDetalhe.Create;

  FCpDetalhe.IdCP := FCp.id;
  FCpDetalhe.Detalhes := Trim(edtObs.Text);
  FCpDetalhe.Valor := StrToFloatDef(Trim(edtValor.Text), 0);
  FCpDetalhe.Data := datePgto.Date;
  FCpDetalhe.Usuario := dmUsuarios.GetUsuarioLogado.id;
  FCpDetalhe.ValorDesc := StrToFloatDef(Trim(edtValorDesc.Text), 0);

end;

procedure TfrmBaixarCP.EditKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmBaixarCP.edtPorcDescKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcPorcentDesc);
end;

procedure TfrmBaixarCP.edtPorcDescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcPorcentDesc);
end;

procedure TfrmBaixarCP.edtValorDescKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcValorDesc);
end;

procedure TfrmBaixarCP.edtValorDescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtValor.Text := CurrToStr(CalcValorDesc);
end;

procedure TfrmBaixarCP.edtValorExit(Sender: TObject);
begin
  edtValor.Text := TUtilitario.FormatarValor(Trim(edtValor.Text));
end;

procedure TfrmBaixarCP.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin

    if not(Assigned(FCp)) then
    begin
      TUtilitario.FecharFormulario(Self);
      Exit;
    end;

    InicializaCampos;
    FTelaAtiva := True;

  end;
end;

procedure TfrmBaixarCP.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

procedure TfrmBaixarCP.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;

  // Coloca no KeyPress o enter para ir para o proximo campo
  edtValor.OnKeyPress := KeyPressValor;
  edtValorDesc.OnKeyPress := KeyPressValor;
  edtPorcDesc.OnKeyPress := KeyPressValor;

end;

procedure TfrmBaixarCP.KeyPressValor(Sender: TObject; var Key: Char);
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

function TfrmBaixarCP.ObterDetalhes: TModelCpDetalhe;
begin
  Result := FCpDetalhe;
end;

function TfrmBaixarCP.ValidaCampos: Boolean;
var
  lValorDesconto, lValorAbater: Double;
begin
  Result := False;

  if (datePgto.Date > Date) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'A data de pagamento não pode ser maior que a data atual!', tmAviso);
    datePgto.SetFocus;
    Exit;
  end;

  if (datePgto.Date < DataCompra) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'A data de pagamento não pode ser menor que a data da compra!', tmAviso);
    datePgto.SetFocus;
    Exit;
  end;

  if (not TryStrToFloat(edtValor.Text, lValorAbater)) or (lValorAbater <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor inválido', tmAviso);
    edtValor.SetFocus;
    Exit;
  end;

  if (lValorAbater > FCp.ValorParcela) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Valor pago não pode ser maior que o valor da parcela', tmAviso);
    edtValor.SetFocus;
    Exit;
  end;

  if (checkDesconto.Checked) then
  begin
    if (not TryStrToFloat(edtValorDesc.Text, lValorDesconto)) or (lValorDesconto > FCp.ValorParcela) then
    begin
      TfrmMensagem.TelaMensagem('Atenção!', 'Valor de desconto inválido!', tmAviso);
      edtValorDesc.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

end.
