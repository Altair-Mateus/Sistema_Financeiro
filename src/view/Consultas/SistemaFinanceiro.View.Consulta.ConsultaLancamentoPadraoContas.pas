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
  SistemaFinanceiro.Model.uSFQuery, fMensagem,
  SistemaFinanceiro.View.Relatorios.LancamentoPadrao;

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
    procedure btnExcluirClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    FTelaAtiva : Boolean;
    FTipoLancamento : TTipoLancamento;
    FQueryPesquisa: TSFQuery;
    procedure Pesquisar;
    procedure HabilitaBotoes;
    procedure PreparaTela;
    procedure EditarRegistro;
    procedure QueryTipoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure QueryStatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public
    constructor Create(pOwner: TComponent; pTipoLancamento : TTipoLancamento); reintroduce;
  end;

var
  frmConsultaLancamentoPadraoContas: TfrmConsultaLancamentoPadraoContas;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.Entidades.LancamentoPadraoContas,
  uEnumsUtilsDescription;

procedure TfrmConsultaLancamentoPadraoContas.btnAlterarClick(Sender: TObject);
begin
  EditarRegistro;
end;

procedure TfrmConsultaLancamentoPadraoContas.btnExcluirClick(Sender: TObject);
var
  lLancamento: TModelLancamentoPadrao;
  lOpEscolhida : TModalResult;
begin

  lLancamento := TModelLancamentoPadrao.Create;
  try
    try

      lOpEscolhida := TfrmMensagem.TelaEscolha('Atenção', 'Deseja excluir o lançamento padrão selecionado? ', tmEscolha);
      if (lOpEscolhida = mrOk) then
      begin
        lLancamento.Id := grdLancPadrao.DataSource.DataSet.FieldByName('ID').AsInteger;
        lLancamento.DeleteByPk;
        Pesquisar;
      end;

    except
      on E: Exception do
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Erro ao excluir lançamento padrão ' + E.Message, tmErro);
      end;
    end;
  finally
    lLancamento.Free;
  end;

end;

procedure TfrmConsultaLancamentoPadraoContas.btnImprimirClick(Sender: TObject);
var
  lFormulario : TfrmRelLancamentoPadrao;
begin
  lFormulario := TfrmRelLancamentoPadrao.Create(Self, grdLancPadrao.DataSource.DataSet);
  try
    // Desativa a atualização visual do grid
    grdLancPadrao.DataSource.DataSet.DisableControls;
    lFormulario.RLReport.Preview;
  finally
    lFormulario.Free;
    grdLancPadrao.DataSource.DataSet.EnableControls;
  end;
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

constructor TfrmConsultaLancamentoPadraoContas.Create(pOwner: TComponent;
  pTipoLancamento: TTipoLancamento);
begin
  inherited Create(pOwner);
  FTipoLancamento := pTipoLancamento;
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
  case FTipoLancamento of
    tlCr:
    begin
      cbTipo.ItemIndex := 1;
      cbTipo.Enabled := False;
    end;
    tlCp:
    begin
      cbTipo.ItemIndex := 2;
      cbTipo.Enabled := False;
    end;
    tlTodos:
    begin
      cbTipo.ItemIndex := 0;
      cbTipo.Enabled := True;
    end
  end;

  FTelaAtiva := True;
  Pesquisar;
  edtPesquisar.SetFocus;
end;

procedure TfrmConsultaLancamentoPadraoContas.QueryStatusGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  lStatus : TStatusCadastro;
begin
  if not Sender.IsNull then
  begin
    lStatus := TStatusCadastro(Sender.AsInteger);
    Text := TEnumsUtilsDescription.GetEnumDescription<TStatusCadastro>(lStatus);
  end;
end;

procedure TfrmConsultaLancamentoPadraoContas.QueryTipoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  lTipoLancamento: TTipoLancamento;
begin
  if not Sender.IsNull then
  begin
    lTipoLancamento := TTipoLancamento(Sender.AsInteger);
    Text := TEnumsUtilsDescription.GetEnumDescription<TTipoLancamento>(lTipoLancamento);
  end
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
      1:
        LFiltro := LFiltro + ' AND TIPO = 0 ';
      2:
        LFiltro := LFiltro + ' AND TIPO = 1 ';
    end;

    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add(' SELECT * FROM LANCAMENTO_PADRAO_CONTAS ');
    FQueryPesquisa.SQL.Add(' WHERE 1 = 1');
    FQueryPesquisa.SQL.Add(LFiltroEdit + LFiltro);
    FQueryPesquisa.Open();

    if FQueryPesquisa.RecordCount > 0 then
    begin
      FQueryPesquisa.FieldByName('TIPO').OnGetText := QueryTipoGetText;
      FQueryPesquisa.FieldByName('STATUS').OnGetText := QueryStatusGetText;
    end;

    grdLancPadrao.Columns[2].Alignment := taLeftJustify;
    grdLancPadrao.Columns[3].Alignment := taLeftJustify;
  except
    on e: Exception do
    begin
      TfrmMensagem.TelaMensagem('Erro!', 'Erro ao realizar a consulta: ' + E.Message, tmErro);
    end;
  end;

  HabilitaBotoes;

end;

end.
