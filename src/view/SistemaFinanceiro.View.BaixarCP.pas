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
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  Vcl.ComCtrls,
  SistemaFinanceiro.View.BaixarCP.FrPgto,
  fMensagem,
  uEnumsUtils;

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
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure checkDescontoClick(Sender: TObject);
    procedure edtPorcDescKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorDescKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtPorcDescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorDescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
  private
    FTelaAtiva: Boolean;
    DataCompra: TDateTime;
    FIdCp: Integer;
    FCp: TModelCP;

    function CalcValorDesc: Currency;
    function CalcPorcentDesc: Currency;
    procedure InicializaBaixa;
    function ValidaContaPagar: Boolean;
    function ValidaCampos: Boolean;
    procedure KeyPressValor(Sender: TObject; var Key: Char);

  public
    property IdCp: Integer read FIdCp write FIdCp;

  end;

var
  frmBaixarCP: TfrmBaixarCP;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Model.dmCPagar,
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.dmUsuarios;

{ TfrmBaixarCP }
procedure TfrmBaixarCP.InicializaBaixa;
begin

  // Carregando dados para as labels
  lblIdConta.Caption := IntToStr(FCp.id);
  lblParcela.Caption := IntToStr(FCp.Parcela);
  lblVencimento.Caption := FormatDateTime('dd/mm/yyyy', FCp.DataVencimento);
  lblValorParcela.Caption := 'R$ ' + TUtilitario.FormatarValor(FCp.ValorParcela);
  lblDtCompra.Caption := DateToStr(FCp.DataCompra);
  lblValorRestante.Caption := 'R$ ' + TUtilitario.FormatarValor((FCp.ValorParcela - FCp.ValorAbatido));
  lblCodFornec.Caption := IntToStr(FCp.IdFornecedor);

  if (Trim(FCp.Doc).IsEmpty) then
    lblDoc.Caption := 'N�o Informado'
  else
    lblDoc.Caption := FCp.Doc;

  DataCompra := FCp.DataCompra;
  edtValor.Text := FloatToStr(FCp.ValorParcela);
  edtObs.Clear;
end;

procedure TfrmBaixarCP.btnConfirmarClick(Sender: TObject);
var
  CpDetalhe: TModelCpDetalhe;
  ValorAbater: Currency;
  ValorDesc: Currency;
begin

  if not(ValidaCampos) then
    Exit;

  CpDetalhe := TModelCpDetalhe.Create;

  try
    CpDetalhe.IdCp := FIdCp;
    CpDetalhe.Detalhes := Trim(edtObs.Text);
    CpDetalhe.Valor := ValorAbater;
    CpDetalhe.Data := datePgto.Date;
    CpDetalhe.Usuario := dmUsuarios.GetUsuarioLogado.id;
    CpDetalhe.ValorDesc := ValorDesc;

    // Forma de pgto
    try

      // Cria o form
      frmFrPgtoBaixaCp := TfrmFrPgtoBaixaCp.Create(Self);

      // Passa as informa��es para a tela de pgto
      frmFrPgtoBaixaCp.FrPgtoCp(FIdCp, ValorAbater);

      // Exibe o form
      frmFrPgtoBaixaCp.ShowModal;

    except
      on E: Exception do

        Application.MessageBox(PWideChar(E.Message), 'Erro na forma de pagamento do documento!',
          MB_OK + MB_ICONWARNING);

    end;

    // Verifica se deu tudo certo com as formas de pgto
    if frmFrPgtoBaixaCp.ModalResult <> mrOk then
    begin
      abort;
    end
    else
    begin
      FreeAndNil(frmFrPgtoBaixaCp);
    end;

    try

      dmCPagar.BaixarCP(CpDetalhe);
      Application.MessageBox('Conta baixada com sucesso!', 'Aten��o', MB_OK + MB_ICONINFORMATION);
      ModalResult := mrOk;

    except
      on E: Exception do
        Application.MessageBox(PWideChar(E.Message), 'Erro ao baixar documento!', MB_OK + MB_ICONWARNING);
    end;

  finally

    CpDetalhe.Free;

  end;

end;

function TfrmBaixarCP.CalcPorcentDesc: Currency;
var
  ValorFinal: Currency;
  PorcentDesc: Currency;
  ValorDesc: Currency;
  ValorCp: Currency;

begin

  ValorCp := dmCPagar.cdsCPagarVALOR_PARCELA.AsCurrency;
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

  ValorCp := dmCPagar.cdsCPagarVALOR_PARCELA.AsCurrency;
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

procedure TfrmBaixarCP.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    // Verifica se a tecla pressionada � o Enter
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

    FTelaAtiva := True;
    FCp.id := FIdCp;

    if not(ValidaContaPagar) then
    begin
      TUtilitario.FecharFormulario(Self);
      Exit;
    end;

    InicializaBaixa;

  end;
end;

procedure TfrmBaixarCP.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;
  FCp := TModelCP.Create;

  // Coloca no KeyPress o enter para ir para o proximo campo
  edtValor.OnKeyPress := KeyPressValor;
  edtValorDesc.OnKeyPress := KeyPressValor;
  edtPorcDesc.OnKeyPress := KeyPressValor;

end;

procedure TfrmBaixarCP.FormDestroy(Sender: TObject);
begin
  FCp.Free;
end;

procedure TfrmBaixarCP.KeyPressValor(Sender: TObject; var Key: Char);
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
  if not(CharInSet(Key, ['0' .. '9', FormatSettings.DecimalSeparator, #8, #13])) then
  begin
    Key := #0;
  end;

  // Valida se j� existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

function TfrmBaixarCP.ValidaCampos: Boolean;
var
  lValorDesconto, lValorAbater: Double;
begin
  Result := False;

  if (datePgto.Date > Date) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o!', 'A data de pagamento n�o pode ser maior que a data atual!', tmAviso);
    datePgto.SetFocus;
    Exit;
  end;

  if (datePgto.Date < DataCompra) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o!', 'A data de pagamento n�o pode ser menor que a data da compra!', tmAviso);
    datePgto.SetFocus;
    Exit;
  end;

  if (not TryStrToFloat(edtValor.Text, lValorAbater)) or (lValorAbater <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o!', 'Valor inv�lido', tmAviso);
    edtValor.SetFocus;
    Exit;
  end;

  if (lValorAbater > FCp.ValorParcela) then
  begin
    TfrmMensagem.TelaMensagem('Aten��o!', 'Valor pago n�o pode ser maior que o valor da parcela', tmAviso);
    edtValor.SetFocus;
    Exit;
  end;

  if (checkDesconto.Checked) then
  begin
    if (not TryStrToFloat(edtValorDesc.Text, lValorDesconto)) or (lValorDesconto > FCp.ValorParcela) then
    begin
      TfrmMensagem.TelaMensagem('Aten��o!', 'Valor de desconto inv�lido!', tmAviso);
      edtValorDesc.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

function TfrmBaixarCP.ValidaContaPagar: Boolean;
begin
  Result := False;

  if not(FCp.LoadObjectByPK) then
  begin
    TfrmMensagem.TelaMensagem('Erro!', Format('N�o foi poss�vel carregar os dados da conta n� %d', [FCp.id]), tmErro);
    Exit;
  end;

  // Se o documento j� foi baixado cancela a edi��o
  if (FCp.Status = 'P') then
  begin
    TfrmMensagem.TelaMensagem('Erro!', 'Conta j� paga!', tmErro);
    Exit;
  end;

  // Se o documento foi cancelado, a edi��o � cancelada
  if (FCp.Status = 'C') then
  begin
    TfrmMensagem.TelaMensagem('Erro!', 'Conta cancelada n�o pode ser baixada!', tmErro);
    Exit;
  end;

  Result := True;
end;

end.
