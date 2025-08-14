unit SistemaFinanceiro.View.Cadastro.LancamentoPadraoContas;

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
  Vcl.WinXCtrls,
  System.ImageList,
  Vcl.ImgList,
  uEnumsUtils,
  SistemaFinanceiro.Model.Entidades.LancamentoPadraoContas,
  fMensagem,
  SistemaFinanceiro.View.Fornecedores,
  SistemaFinanceiro.View.Clientes;

type
  TfrmCadLancamentoPadrao = class(TForm)
    pnlContainer: TPanel;
    pnlCampos: TPanel;
    lblDescricao: TLabel;
    pnlTitulo: TPanel;
    pnlBotoesCad: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    ImageList1: TImageList;
    edtDescricao: TMemo;
    rdgTipo: TRadioGroup;
    ImageList16x16: TImageList;
    pnlIdCliFornec: TPanel;
    lblIdCliFornec: TLabel;
    edtIdCliFornec: TEdit;
    btnPesquisar: TButton;
    gbDadosCad: TGroupBox;
    lblDt: TLabel;
    lblDtAlt: TLabel;
    edtDtAlt: TEdit;
    edtDtCad: TEdit;
    LabelStatus: TLabel;
    ToggleStatus: TToggleSwitch;
    procedure FormShow(Sender: TObject);
    procedure rdgTipoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure edtIdCliFornecExit(Sender: TObject);
  private
    FTelaAtiva: Boolean;
    FOperacaoCadastro: TOperacaoCadastro;
    FCodLancamento: Integer;
    FLancamentoPadrao: TModelLancamentoPadrao;

    function CarregaDadosAlteracao: Boolean;
    procedure ExibeTelaFornecedor;
    procedure ExibeTelaCliente;
    procedure ValidaCliente;
    procedure ValidaFornecedor;

    function TipoIndiceParaEnum: TTipoLancamento;
    function TipoEnumParaIndice: Integer;

  public
    property OperacaoCadastro: TOperacaoCadastro read FOperacaoCadastro write FOperacaoCadastro;
    property CodLancamento: Integer read FCodLancamento write FCodLancamento;
  end;

var
  frmCadLancamentoPadrao: TfrmCadLancamentoPadrao;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.Entidades.Cliente,
  SistemaFinanceiro.Model.Entidades.Fornecedor;

procedure TfrmCadLancamentoPadrao.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadLancamentoPadrao.btnPesquisarClick(Sender: TObject);
begin
  case rdgTipo.ItemIndex of
    0:
      ExibeTelaCliente;
    1:
      ExibeTelaFornecedor;
  end;
end;

procedure TfrmCadLancamentoPadrao.btnSalvarClick(Sender: TObject);
var
  lTipo: Integer;
begin

  lTipo := rdgTipo.ItemIndex;

  // validar
  if lTipo < 0 then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Obrigatório informar o Tipo do lançamento!', tmAviso);
    exit;
  end;

  FLancamentoPadrao.Descricao := Trim(edtDescricao.Text);
  FLancamentoPadrao.Tipo := TipoIndiceParaEnum;

  if (ToggleStatus.State = tssOn) then
    FLancamentoPadrao.Status := scAtivo
  else
    FLancamentoPadrao.Status := scInativo;

  if not Trim(edtIdCliFornec.Text).IsEmpty then
  begin
    case lTipo of
      0:
        FLancamentoPadrao.Id_Cliente := Trim(edtIdCliFornec.Text).ToInteger;
      1:
        FLancamentoPadrao.Id_Fornecedor := Trim(edtIdCliFornec.Text).ToInteger;
    end;
  end;

  case FOperacaoCadastro of
    ocIncluir:
      begin
        FLancamentoPadrao.Data_Cadastro := Now;
        FLancamentoPadrao.Insert;
      end;
    ocAlterar:
      begin
        FLancamentoPadrao.Data_Alteracao := Now;
        FLancamentoPadrao.UpdateByPK;
      end;
  end;

  Close;

end;

function TfrmCadLancamentoPadrao.CarregaDadosAlteracao: Boolean;
begin
  Result := False;

  FLancamentoPadrao.Id := FCodLancamento;
  if (FLancamentoPadrao.LoadObjectByPK) then
  begin
    Result := True;

    edtDescricao.Text := FLancamentoPadrao.Descricao;
    edtDtCad.Text := DateTimeToStr(FLancamentoPadrao.Data_Cadastro);
    rdgTipo.ItemIndex := TipoEnumParaIndice;
    ToggleStatus.State := TToggleSwitchState(FLancamentoPadrao.Status);

    if (FLancamentoPadrao.Tipo = tlCr) then
      edtIdCliFornec.Text := FLancamentoPadrao.Id_Cliente.ToString
    else if (FLancamentoPadrao.Tipo = tlCp) then
      edtIdCliFornec.Text := FLancamentoPadrao.Id_Fornecedor.ToString;

    if FLancamentoPadrao.Data_Alteracao > 0 then
      edtDtAlt.Text := DateTimeToStr(FLancamentoPadrao.Data_Alteracao);

  end;
end;

procedure TfrmCadLancamentoPadrao.edtIdCliFornecExit(Sender: TObject);
begin
  case rdgTipo.ItemIndex of
    0:
      ValidaCliente;
    1:
      ValidaFornecedor;
  end;
end;

procedure TfrmCadLancamentoPadrao.ExibeTelaCliente;
var
  lFormulario: TfrmCliente;
begin
  lFormulario := TfrmCliente.Create(Self);

  try
    lFormulario.ShowModal;
    // Pega a ID do cliente selecionado
    edtIdCliFornec.Text := lFormulario.DBGrid1.DataSource.DataSet.FieldByName('ID_CLI').AsString;
  finally
    lFormulario.Free;
  end;
  edtIdCliFornec.SetFocus;
end;

procedure TfrmCadLancamentoPadrao.ExibeTelaFornecedor;
var
  lFormulario: TfrmFornecedores;
begin
  lFormulario := TfrmFornecedores.Create(Self);

  try
    lFormulario.ShowModal;
    // Pega a ID do cliente selecionado
    edtIdCliFornec.Text := lFormulario.DBGrid1.DataSource.DataSet.FieldByName('ID_FORNEC').AsString;
  finally
    lFormulario.Free;
  end;
  edtIdCliFornec.SetFocus;
end;

procedure TfrmCadLancamentoPadrao.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin

    FTelaAtiva := True;
    FLancamentoPadrao := TModelLancamentoPadrao.Create;

    if (FOperacaoCadastro = ocAlterar) and (FCodLancamento > 0) then
    begin
      if not(CarregaDadosAlteracao) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Erro ao recuperar dados do lançamento padrão nº ' +
          FCodLancamento.ToString, tmErro);
        TUtilitario.FecharFormulario(Self);
      end;

      pnlTitulo.Caption := 'Alterando Lançamento Nº ' + FLancamentoPadrao.Id.ToString;
    end;
  end;
end;

procedure TfrmCadLancamentoPadrao.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;
end;

procedure TfrmCadLancamentoPadrao.FormShow(Sender: TObject);
begin
  edtDtCad.Text := DateTimeToStr(Now);
  ToggleStatus.State := tssOn;
end;

procedure TfrmCadLancamentoPadrao.rdgTipoClick(Sender: TObject);
begin
  // Libera para informar cliente ou fornecedor
  edtIdCliFornec.Enabled := True;
  btnPesquisar.Enabled := True;

  if not(Trim(edtIdCliFornec.Text).IsEmpty) then
  begin
    edtIdCliFornec.Clear;
    edtIdCliFornec.SetFocus;
  end;
end;

function TfrmCadLancamentoPadrao.TipoEnumParaIndice: Integer;
begin
  case FLancamentoPadrao.Tipo of
    tlCr:
      Result := 0;
    tlCp:
      Result := 1;
  else
    Result := -1;
  end;
end;

function TfrmCadLancamentoPadrao.TipoIndiceParaEnum: TTipoLancamento;
begin
  case rdgTipo.ItemIndex of
    0:
      Result := tlCr;
    1:
      Result := tlCp;
  else
    Result := tlTodos;
  end;
end;

procedure TfrmCadLancamentoPadrao.ValidaCliente;
var
  lCliente: TModelCliente;
begin

  if not Trim(edtIdCliFornec.Text).IsEmpty then
  begin
    lCliente := TModelCliente.Create;
    try
      if not lCliente.Existe(StrToInt(Trim(edtIdCliFornec.Text))) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Cliente não encontrado!', tmErro);
        edtIdCliFornec.Clear;
        edtIdCliFornec.SetFocus;
      end;
    finally
      lCliente.Free;
    end;
  end;
end;

procedure TfrmCadLancamentoPadrao.ValidaFornecedor;
var
  lFornecedor: TModelFornecedor;
begin

  if not Trim(edtIdCliFornec.Text).IsEmpty then
  begin
    lFornecedor := TModelFornecedor.Create;
    try
      if not lFornecedor.Existe(StrToInt(Trim(edtIdCliFornec.Text))) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Fornecedor não encontrado!', tmErro);
        edtIdCliFornec.Clear;
        edtIdCliFornec.SetFocus;
      end;
    finally
      lFornecedor.Free;
    end;
  end;

end;

end.
