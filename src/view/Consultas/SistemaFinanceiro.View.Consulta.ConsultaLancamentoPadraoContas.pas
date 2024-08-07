unit SistemaFinanceiro.View.Consulta.ConsultaLancamentoPadraoContas;

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
  Data.DB,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  System.ImageList,
  Vcl.ImgList,
  SistemaFinanceiro.View.Cadastro.LancamentoPadraoContas,
  uEnumsUtils,
  SistemaFinanceiro.Model.uSFQuery;

type
  TfrmConsultaLancamentoPadraoContas = class(TForm)
    pnlContainer: TPanel;
    pnlBotoes: TPanel;
    btnIncluir: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    btnImprimir: TButton;
    btnVoltar: TButton;
    pnlGrid: TPanel;
    grdLancPadrao: TDBGrid;
    pnlPesquisa: TPanel;
    lblPesquisar: TLabel;
    lblTipo: TLabel;
    edtPesquisar: TEdit;
    btnPesquisae: TButton;
    cbTipo: TComboBox;
    ImageList1: TImageList;
    dsLancPadraoContas: TDataSource;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure grdLancPadraoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure PesquisaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure grdLancPadraoDblClick(Sender: TObject);
  private
    FTelaAtiva : Boolean;
    FTipoLancamento : TTipoLancamento;
    FQueryPesquisa: TSFQuery;
    procedure Pesquisar;
    procedure HabilitaBotoes;
    procedure PreparaTela;
    procedure EditarRegistro;
    procedure QueryTipoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public
    property TipoLancamento: TTipoLancamento read FTipoLancamento write FTipoLancamento;
  end;

var
  frmConsultaLancamentoPadraoContas: TfrmConsultaLancamentoPadraoContas;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Utilitarios;

procedure TfrmConsultaLancamentoPadraoContas.btnAlterarClick(Sender: TObject);
begin
  EditarRegistro;
end;

procedure TfrmConsultaLancamentoPadraoContas.btnIncluirClick(Sender: TObject);
var
  lFormulario : TfrmCadLancamentoPadrao;
begin

  lFormulario := TfrmCadLancamentoPadrao.Create(Self);
  try
    lFormulario.OperacaoCadastro := ocIncluir;
    lFormulario.ShowModal;
  finally
    FreeAndNil(lFormulario);
  end;

  Pesquisar;
end;

procedure TfrmConsultaLancamentoPadraoContas.btnVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultaLancamentoPadraoContas.grdLancPadraoDblClick(
  Sender: TObject);
begin
  EditarRegistro
end;

procedure TfrmConsultaLancamentoPadraoContas.grdLancPadraoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  if not Odd(grdLancPadrao.DataSource.DataSet.RecNo) then
  begin

    if not(gdSelected in State) then
    begin
      TDBGrid(Sender).Canvas.Brush.Color := $00F6F5F5;
      TDBGrid(Sender).Canvas.FillRect(Rect);
    end;

  end;

  if (gdSelected in State) then
  begin
    grdLancPadrao.Canvas.Brush.Color := $00578B2E;  // Define a cor de fundo da célula selecionada
    grdLancPadrao.Canvas.Font.Color := clWhite;  // Define a cor do texto da célula selecionada
  end;

  // Desenha a célula com as propriedades de cor atualizadas
  grdLancPadrao.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TfrmConsultaLancamentoPadraoContas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TUtilitario.SalvarOrdemColunasParaJSON(grdLancPadrao, 'ConfigGrids', 'grdLancamentoPadrao');
end;

procedure TfrmConsultaLancamentoPadraoContas.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;
  FTipoLancamento := tlTodos;
end;

procedure TfrmConsultaLancamentoPadraoContas.FormDestroy(Sender: TObject);
begin
   if Assigned(FQueryPesquisa) then
    FQueryPesquisa.Free;
end;

procedure TfrmConsultaLancamentoPadraoContas.FormShow(Sender: TObject);
begin
  PreparaTela;
end;

procedure TfrmConsultaLancamentoPadraoContas.HabilitaBotoes;
begin
  btnAlterar.Enabled  := not dsLancPadraoContas.DataSet.IsEmpty;
  btnExcluir.Enabled  := not dsLancPadraoContas.DataSet.IsEmpty;
  btnImprimir.Enabled := not dsLancPadraoContas.DataSet.IsEmpty;
end;

procedure TfrmConsultaLancamentoPadraoContas.PreparaTela;
begin

  TUtilitario.CarregarOrdemColunasJSON(grdLancPadrao, 'ConfigGrids', 'grdLancamentoPadrao');

  //  Se vier da tela de CR ou CP irá filtrar somente os lançamento de acordo com a origem
  if (FTipoLancamento <> tlTodos) then
  begin
    cbTipo.ItemIndex := Ord(FTipoLancamento);
    cbTipo.Enabled := False;
  end;

  FTelaAtiva := True;
  Pesquisar;
  edtPesquisar.SetFocus;
end;

procedure TfrmConsultaLancamentoPadraoContas.QueryTipoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  case Sender.AsInteger of
    0: Text := 'CR';
    1: Text := 'CP';
  end;
end;

procedure TfrmConsultaLancamentoPadraoContas.EditarRegistro;
var
  lFormulario: TfrmCadLancamentoPadrao;
begin
  lFormulario := TfrmCadLancamentoPadrao.Create(Self);
  try
    lFormulario.OperacaoCadastro := ocAlterar;
    lFormulario.CodLancamento := grdLancPadrao.DataSource.DataSet.FieldByName('ID').AsInteger;
    lFormulario.ShowModal;
  finally
    FreeAndNil(lFormulario);
  end;
  Pesquisar;
end;

procedure TfrmConsultaLancamentoPadraoContas.PesquisaClick(Sender: TObject);
begin
  if (FTelaAtiva) then
    Pesquisar;
end;

procedure TfrmConsultaLancamentoPadraoContas.Pesquisar;
var
  LFiltroEdit, LFiltro: String;
begin

  if Assigned(FQueryPesquisa) then
    FreeAndNil(FQueryPesquisa);

  FQueryPesquisa := TSFQuery.Create(nil);
  LFiltro := '';
  LFiltroEdit := '';
  try

    // Pré pesquisa para funcionar o likefind
    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add(' SELECT FIRST 1 * FROM LANCAMENTO_PADRAO_CONTAS ');
    FQueryPesquisa.Open();

    grdLancPadrao.DataSource.DataSet := FQueryPesquisa;
    LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, grdLancPadrao);


    case cbTipo.ItemIndex of
      0:
        LFiltro := LFiltro + ' AND TIPO = 0 ';
      1:
        LFiltro := LFiltro + ' AND TIPO = 1 ';
    end;

    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add(' SELECT * FROM LANCAMENTO_PADRAO_CONTAS ');
    FQueryPesquisa.SQL.Add(' WHERE 1 = 1');
    FQueryPesquisa.SQL.Add(LFiltroEdit + LFiltro);
    FQueryPesquisa.Open();

    if FQueryPesquisa.RecordCount > 0 then
      FQueryPesquisa.FieldByName('TIPO').OnGetText := QueryTipoGetText;

  except
    on e: Exception do
    begin
      Application.MessageBox(PWidechar('Erro ao realizar a consulta: ' +
        e.Message), 'Atenção', MB_OK + MB_ICONERROR);
    end;
  end;

  HabilitaBotoes;

end;

end.
