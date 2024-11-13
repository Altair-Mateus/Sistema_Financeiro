unit SistemaFinanceiro.View.BaixarCR;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe,
  SistemaFinanceiro.Model.Entidades.CR, SistemaFinanceiro.View.BaixarCR.FrPgto;

type
  TfrmBaixarCR = class(TForm)
    ImageList1: TImageList;
    pnlPrincipal: TPanel;
    pnlDocInfo: TPanel;
    gbDocInfo: TGroupBox;
    lblNDoc: TLabel;
    lblParc: TLabel;
    lblVenc: TLabel;
    lblVParcela: TLabel;
    lblDataVenda: TLabel;
    lblDoc: TLabel;
    lblParcela: TLabel;
    lblVencimento: TLabel;
    lblValorParcela: TLabel;
    lblDtVenda: TLabel;
    lblId: TLabel;
    lblIdConta: TLabel;
    lblValorRestante: TLabel;
    lblVRestante: TLabel;
    pnlDetalhes: TPanel;
    gbDetalhes: TGroupBox;
    lblObs: TLabel;
    lblValor: TLabel;
    lblData: TLabel;
    edtObs: TEdit;
    edtValor: TEdit;
    datePgto: TDateTimePicker;
    pnlBotoes: TPanel;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    lblIdCliente: TLabel;
    lblCodCliente: TLabel;
    checkDesconto: TCheckBox;
    pnlDesconto: TPanel;
    lblDesconto: TLabel;
    edtPorcDesc: TEdit;
    lblValorDesc: TLabel;
    edtValorDesc: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure checkDescontoClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtPorcDescKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorDescKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    FCr : TModelCR;
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure AtualizaValoresValor;
    procedure AtualizaValoresPorcentagem;
  public
    { Public declarations }
    procedure BaixarCR(pId: Integer);
  end;

var
  frmBaixarCR: TfrmBaixarCR;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Model.dmUsuarios,
  SistemaFinanceiro.Utilitarios;

procedure TfrmBaixarCR.BaixarCR(pId: Integer);
begin

  if Assigned(FCr) then
    FreeAndNil(Fcr);

  FCr := TModelCR.Create;

  //  Valida ID do CR
  if not FCr.Existe(pId, True) then
  begin
    raise Exception.Create('ID do contas a receber Inválido!');
  end;

  //  Se o status já for B irá ignorar
  if FCr.Status = 'P' then
  begin
    raise Exception.Create('Não é possível baixar uma conta já Paga!');
  end;

  //  Se o status já for C irá ignorar
  if FCr.Status = 'C' then
  begin
    raise Exception.Create('Não é possível baixar uma conta cancelada!');
  end;



  //  Carregando dados para as labels
  lblIdConta.Caption       := IntToStr(FCr.ID);
  lblParcela.Caption       := IntToStr(FCr.Parcela);
  lblVencimento.Caption    := FormatDateTime('dd/mm/yyyy', FCr.DataVencimento);
  lblValorParcela.Caption  := 'R$ ' + TUtilitario.FormatarValor(FCr.ValorParcela);
  lblDtVenda.Caption       := DateToStr(FCr.DataVenda);
  lblValorRestante.Caption := 'R$ ' + TUtilitario.FormatarValor((FCr.ValorParcela - FCr.ValorAbatido));
  lblCodCliente.Caption    := IntToStr(FCr.IdCliente);


  if FCr.Doc = '' then
    lblDoc.Caption := 'Não Informado'
  else
    lblDoc.Caption := FCr.Doc;

  edtObs.Clear;
  edtValor.Text := CurrToStr(FCr.ValorParcela);

end;

procedure TfrmBaixarCR.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmBaixarCR.btnConfirmarClick(Sender: TObject);
var
  lCrDetalhe : TModelCrDetalhe;
  lValorAbater : Double;
  lValorDesc : Double;
begin

  lValorAbater := 0;
  lValorDesc   := 0;
  //  Validações dos campos
  if (datePgto.Date > Date) then
  begin
    datePgto.SetFocus;
    Application.MessageBox('A data de pagamento não pode ser maior que a data atual!', 'Atenção', MB_OK + MB_ICONWARNING);
    exit;
  end;

  if (datePgto.Date < FCr.DataVenda) then
  begin
    datePgto.SetFocus;
    Application.MessageBox('A data de pagamento não pode ser menor que a data da venda!', 'Atenção', MB_OK + MB_ICONWARNING);
    exit;
  end;

  if (not TryStrToFloat(edtValor.Text, lValorAbater)) or (lValorAbater <= 0)  then
  begin
    edtValor.SetFocus;
    Application.MessageBox('Valor inválido!', 'Atenção', MB_OK + MB_ICONWARNING);
    exit;
  end;

  if (lValorAbater > FCr.ValorParcela)  then
  begin
    edtValor.SetFocus;
    Application.MessageBox('Valor pago não pode ser maior que o valor da parcela!', 'Atenção', MB_OK + MB_ICONWARNING);
    exit;
  end;

  if checkDesconto.Checked then
  begin

    if (not TryStrToFloat(edtValorDesc.Text, lValorDesc)) or (lValorDesc > FCr.ValorParcela) then
    begin
      edtValorDesc.SetFocus;
      Application.MessageBox('Valor de desconto inválido!', 'Atenção', MB_OK + MB_ICONWARNING);
      exit;
    end;

  end;


  lCrDetalhe := TModelCrDetalhe.Create;
  try
    lCrDetalhe.IdCr       := FCr.ID;
    lCrDetalhe.Detalhes   := Trim(edtObs.Text);
    lCrDetalhe.Valor      := lValorAbater;
    lCrDetalhe.Data       := datePgto.Date;
    lCrDetalhe.Usuario    := dmUsuarios.GetUsuarioLogado.Id;
    lCrDetalhe.ValorDesc  := lValorDesc;

    //  Forma de pgto
    try

      //  Cria o form
      frmFrPgtoBaixaCr:= TfrmFrPgtoBaixaCr.Create(Self);

      //  Passa as informações para a tela de pgto
      frmFrPgtoBaixaCr.FrPgtoCr(FCr.ID, lValorAbater);

      //  Exibe o form
      frmFrPgtoBaixaCr.ShowModal;

    except on E : Exception do

      Application.MessageBox(PWideChar(E.Message), 'Erro na forma de pagamento do documento!', MB_OK + MB_ICONWARNING);

    end;

    //  Verifica se deu tudo certo com as formas de pgto
    if frmFrPgtoBaixaCr.ModalResult <> mrOk then
      abort
    else
      FreeAndNil(frmFrPgtoBaixaCr);

     try

      // Verifica se deu baixa na conta
      if FCr.BaixarCR(lCrDetalhe, FCr) then
      begin
        Application.MessageBox('Conta baixada com sucesso!', 'Atenção', MB_OK + MB_ICONINFORMATION);
        ModalResult := mrOk;
      end;

    except
      on E : Exception do
      Application.MessageBox(PWideChar(E.Message), 'Erro ao baixar documento!', MB_OK + MB_ICONWARNING);
    end;

  finally
    lCrDetalhe.Free;
  end;

end;

procedure TfrmBaixarCR.checkDescontoClick(Sender: TObject);
begin
  //  Libera e mostra os campos do desconto
  pnlDesconto.Visible := checkDesconto.Checked;
end;

procedure TfrmBaixarCR.edtPorcDescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  AtualizaValoresPorcentagem;
end;

procedure TfrmBaixarCR.edtValorDescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  AtualizaValoresValor;
end;

procedure TfrmBaixarCR.AtualizaValoresPorcentagem;
var
  ValorCr: Double;
  PorcentDesc: Double;
  ValorDesc: Double;
  ValorFinal: Double;
begin
  // Inicializa as variáveis
  ValorCr := FCr.ValorParcela;
  PorcentDesc := 0;
  ValorDesc := 0;
  ValorFinal := 0;

  // Tenta converter a porcentagem de desconto para double
  TryStrToFloat(edtPorcDesc.Text, PorcentDesc);

  // Calcula o valor do desconto se a porcentagem for válida
  if PorcentDesc >= 0 then
  begin
    ValorDesc := (PorcentDesc / 100) * ValorCr;
    edtValorDesc.Text := FloatToStr(ValorDesc);
  end;

  // Calcula o valor final
  ValorFinal := ValorCr - ValorDesc;

  // Atualiza os campos de texto com os valores calculados
  edtValor.Text := FloatToStr(ValorFinal);
end;

procedure TfrmBaixarCR.AtualizaValoresValor;
var
  ValorCr: Double;
  PorcentDesc: Double;
  ValorDesc: Double;
  ValorFinal: Double;
begin
  // Inicializa as variáveis
  ValorCr := FCr.ValorParcela;
  PorcentDesc := 0;
  ValorDesc := 0;
  ValorFinal := 0;

  // Tenta converter o valor de desconto para double
  TryStrToFloat(edtValorDesc.Text, ValorDesc);

  // Calcula a porcentagem de desconto se o valor for válido
  if ValorDesc >= 0 then
  begin
    PorcentDesc := (ValorDesc / ValorCr) * 100;
    edtPorcDesc.Text := FloatToStr(PorcentDesc);
  end;

  // Calcula o valor final
  ValorFinal := ValorCr - ValorDesc;

  // Atualiza os campos de texto com os valores calculados
  edtValor.Text := FloatToStr(ValorFinal);
end;

procedure TfrmBaixarCR.FormCreate(Sender: TObject);
begin

  //  Coloca no KeyPress o enter para ir para o proximo campo
  edtValor.OnKeyPress      := KeyPressValor;
  edtValorDesc.OnKeyPress  := KeyPressValor;
  edtPorcDesc.OnKeyPress   := KeyPressValor;
  pnlDesconto.Visible := False;
  datePgto.Date := now;

end;

procedure TfrmBaixarCR.FormDestroy(Sender: TObject);
begin
  if Assigned(FCr) then
    Fcr.Free;
end;

procedure TfrmBaixarCR.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    //  Verifica se a tecla pressionada é o Enter
    //  Cancela o efeito do enter
    Key := #0;
    //  Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmBaixarCR.KeyPressValor(Sender: TObject; var Key: Char);
begin

  //  Se for digitado um ponto, será convertido para virgula
  if Key = FormatSettings.ThousandSeparator then
   begin
      Key := #0;
    end;

  // Permite apenas digitar os caracteres dentro do charinset
  if not (CharInSet(Key, ['0'..'9', FormatSettings.DecimalSeparator, #8, #13])) then
  begin
    Key := #0;
  end;

  // Valida se já existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

end.
