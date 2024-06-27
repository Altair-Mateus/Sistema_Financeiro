unit SistemaFinanceiro.View.CrDetalhe;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.ImageList,
  Vcl.ImgList,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ComCtrls,
  SistemaFinanceiro.Model.uSFQuery;

type
  TfrmCrDetalhe = class(TForm)
    pnlPesquisa: TPanel;
    ImageList1: TImageList;
    pnlBotoes: TPanel;
    btnVoltar: TButton;
    DataSourceCrDetalhe: TDataSource;
    lblTNDoc: TLabel;
    lblTVencimento: TLabel;
    lblTNumParcela: TLabel;
    lblNumParcela: TLabel;
    lblVencimento: TLabel;
    lblNumDoc: TLabel;
    lblValorVenda: TLabel;
    lblDesc: TLabel;
    lblValorParcela: TLabel;
    lblTValorParcela: TLabel;
    lblTValorVenda: TLabel;
    lblTDesc: TLabel;
    lblTCodCliente: TLabel;
    lblCodCliente: TLabel;
    dsPgtos: TDataSource;
    dsParciais: TDataSource;
    pnlInfopag: TPanel;
    lblDtPag: TLabel;
    lblNomeUser: TLabel;
    lblObsPag: TLabel;
    lblValorPago: TLabel;
    lblVlDesc: TLabel;
    edtDtPag: TEdit;
    edtObsPag: TEdit;
    edtUser: TEdit;
    edtValDesc: TEdit;
    edtValPago: TEdit;
    pnlPrincipal: TPanel;
    pnlGrids: TPanel;
    pnlGridFormasPagamento: TPanel;
    lblFrPgto: TLabel;
    grdPgtos: TDBGrid;
    pnlGridParciais: TPanel;
    lblParciais: TLabel;
    grdParciais: TDBGrid;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdPgtosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grdParciaisDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FQueryParciais, FQueryPgto : TSFQuery;
  public
    { Public declarations }
    procedure ExibirCRDetalhes(IDCR : integer);

  end;

var
  frmCrDetalhe: TfrmCrDetalhe;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Model.Entidades.CR,
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.Entidades.Usuario,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe;

{ TfrmConsultarCr }

procedure TfrmCrDetalhe.btnVoltarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmCrDetalhe.ExibirCRDetalhes(IDCR: integer);
var
  lCr          : TModelCr;
  lCrDetalhe   : TModelCrDetalhe;
  lUsuario : TModelUsuario;
begin

  lCr := TModelCR.Create;
  lCrDetalhe := TModelCrDetalhe.Create;
  lUsuario := TModelUsuario.Create;
  try

    //  Carrega os dados da CR
    if not lCr.Existe(IDCR, True) then
    begin
      raise Exception.Create('ID do contas a receber Inválido!');
    end;

    if lCr.Doc <> '' then
      lblNumDoc.Caption := lCr.Doc
    else
      lblNumDoc.Caption := 'Não Informado';

    lblDesc.Caption         := lCr.Desc;
    lblVencimento.Caption   := FormatDateTime('DD/MM/YYYY', lCr.DataVencimento);
    lblNumParcela.Caption   := IntToStr(lCr.Parcela);
    lblValorVenda.Caption   := TUtilitario.FormatoMoeda(lCr.ValorVenda);
    lblValorParcela.Caption := TUtilitario.FormatoMoeda(lCr.ValorParcela);
    lblCodCliente.Caption   := IntToStr(lCr.IdCliente);

    //  Carrega os detalhes da CR
    if not lCrDetalhe.ExistePorCr(lCr.ID, True) then
    begin
      raise Exception.Create('ID do contas a receber Inválido!');
    end;

    lUsuario.Existe(lCrDetalhe.Usuario, True);

    edtDtPag.Text   := FormatDateTime('DD/MM/YYYY', lCrDetalhe.Data);
    edtValPago.Text := TUtilitario.FormatoMoeda(lCrDetalhe.Valor);
    edtValDesc.Text := TUtilitario.FormatoMoeda(lCrDetalhe.ValorDesc);
    edtUser.Text    := lUsuario.Nome;
    edtObsPag.Text  := lCrDetalhe.Detalhes;

    //  Carrega os pagamentos
    FQueryPgto.Close;
    FQueryPgto.SQL.Clear;
    FQueryPgto.SQL.Add(' SELECT PG.*, FR.NOME_FR FROM PGTO_BX_CR PG       ');
    FQueryPgto.SQL.Add(' LEFT JOIN FR_PGTO FR ON PG.ID_FR_PGTO = FR.ID_FR ');
    FQueryPgto.SQL.Add(' WHERE ID_CR = :IDCR                              ');
    FQueryPgto.ParamByName('IDCR').AsInteger := lCr.ID;
    FQueryPgto.Open;
    grdPgtos.DataSource.DataSet := FQueryPgto;

    //  Carrega as parciais
    FQueryParciais.Close;
    FQueryParciais.SQL.Clear;
    FQueryParciais.SQL.Add(' SELECT * FROM CONTAS_RECEBER WHERE PARCIAL = ''S'' ');
    FQueryParciais.SQL.Add(' AND CR_ORIGEM = :IDCR                              ');
    FQueryParciais.ParamByName('IDCR').AsInteger := lCr.ID;
    FQueryParciais.Open;
    grdParciais.DataSource.DataSet := FQueryParciais;

    //  Se Existir Parcial Gerada irá informar na tela
    if not (FQueryParciais.IsEmpty) then
    begin
      pnlGridParciais.Visible := True;
      pnlGrids.Height := 331;
    end
    else
    begin
      pnlGridParciais.Visible := False;
      pnlGrids.Height := 170;
    end;

  finally
    lCr.Free;
    lCrDetalhe.Free;
    lUsuario.Free;
  end;

end;

procedure TfrmCrDetalhe.FormCreate(Sender: TObject);
begin
  FQueryParciais := TSFQuery.Create(nil);
  FQueryPgto := TSFQuery.Create(nil);
end;

procedure TfrmCrDetalhe.FormDestroy(Sender: TObject);
begin
  FQueryParciais.Free;
  FQueryPgto.Free;
end;

procedure TfrmCrDetalhe.grdParciaisDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  TUtilitario.FormatoMoedaGrid(TDBGrid(Sender), Column, Rect, State);
end;


procedure TfrmCrDetalhe.grdPgtosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  TUtilitario.FormatoMoedaGrid(TDBGrid(Sender), Column, Rect, State);
end;

end.
