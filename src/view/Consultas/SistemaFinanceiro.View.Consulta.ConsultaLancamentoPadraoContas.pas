unit SistemaFinanceiro.View.Consulta.ConsultaLancamentoPadraoContas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList,
  SistemaFinanceiro.View.Cadastro.LancamentoPadraoContas;

type
  TfrmLancamentoPadraoContas = class(TForm)
    pnlContainer: TPanel;
    pnlBotoes: TPanel;
    btnIncluir: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    btnImprimir: TButton;
    btnVoltar: TButton;
    pnlGrid: TPanel;
    DBGrid1: TDBGrid;
    pnlPesquisa: TPanel;
    lblPesquisar: TLabel;
    lblTipo: TLabel;
    edtPesquisar: TEdit;
    btnPesquisae: TButton;
    cbTipo: TComboBox;
    ImageList1: TImageList;
    dsLancPadraoContas: TDataSource;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnPesquisaeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    procedure Pesquisar;
    procedure HabilitaBotoes;
  public
    { Public declarations }
  end;

var
  frmLancamentoPadraoContas: TfrmLancamentoPadraoContas;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Utilitarios, SistemaFinanceiro.Model.uSFQuery;

procedure TfrmLancamentoPadraoContas.btnIncluirClick(Sender: TObject);
begin

  frmCadLancamentoPadrao := TfrmCadLancamentoPadrao.Create(Self);
  try
    frmCadLancamentoPadrao.ShowModal;
  finally
    FreeAndNil(frmCadLancamentoPadrao);
  end;

end;

procedure TfrmLancamentoPadraoContas.btnPesquisaeClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmLancamentoPadraoContas.btnVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLancamentoPadraoContas.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  if not Odd(DBGrid1.DataSource.DataSet.RecNo) then
  begin

    if not(gdSelected in State) then
    begin
      TDBGrid(Sender).Canvas.Brush.Color := $00F6F5F5;
      TDBGrid(Sender).Canvas.FillRect(Rect);
    end;

  end;

  if (gdSelected in State) then
  begin
    DBGrid1.Canvas.Brush.Color := $00578B2E;  // Define a cor de fundo da célula selecionada
    DBGrid1.Canvas.Font.Color := clWhite;  // Define a cor do texto da célula selecionada
  end;

  // Desenha a célula com as propriedades de cor atualizadas
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TfrmLancamentoPadraoContas.FormShow(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmLancamentoPadraoContas.HabilitaBotoes;
begin
  btnAlterar.Enabled  := not dsLancPadraoContas.DataSet.IsEmpty;
  btnExcluir.Enabled  := not dsLancPadraoContas.DataSet.IsEmpty;
  btnImprimir.Enabled := not dsLancPadraoContas.DataSet.IsEmpty;
end;

procedure TfrmLancamentoPadraoContas.Pesquisar;
var
  LFiltroEdit, LFiltro : String;
  lQuery : TSFQuery;
begin

  LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, DBGrid1);
  LFiltro := '';

  case cbTipo.ItemIndex of
    1 : LFiltro := lFiltro + ' AND TIPO = ''CP'' ';
    2 : LFiltro := LFiltro + ' AND TIPO = ''CR'' ';
  end;

//  lQuery := TSFQuery.Create;
//  try
//
//    lQuery.Close;
//    lQuery.SQL.Add('SELECT * FROM LANCAMENTO_PADRAO_CONTAS WHERE 1 = 1');
//    lQuery.SQL.Add('')
//    dsLancPadraoContas.DataSet := lQuery.ExecuteQuery('SELECT * FROM LANCAMENTO_PADRAO_CONTAS WHERE 1 = 1' +
//      LFiltroEdit + LFiltro + 'ORDER BY 1', []);
//
//  finally
//    lQuery.Free;
//  end;

  HabilitaBotoes;

end;

end.
