unit SistemaFinanceiro.View.DetalhesOrigemCpCr;

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
  System.ImageList,
  Vcl.ImgList,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  SistemaFinanceiro.Model.uSFQuery,
  fMensagem;

type
  TfrmDetalhesOrigemCpCr = class(TForm)
    pnlPrincipal: TPanel;
    pnlTitulo: TPanel;
    pnlBotoes: TPanel;
    ImageList1: TImageList;
    btnSair: TButton;
    pnlInfo: TPanel;
    lblDesc: TLabel;
    memDesc: TMemo;
    lblValor: TLabel;
    edtValor: TEdit;
    lblData: TLabel;
    lblNDoc: TLabel;
    edtNDoc: TEdit;
    lblForCli: TLabel;
    edtForCli: TEdit;
    lblFatCartao: TLabel;
    edtFatCartao: TEdit;
    lblCod: TLabel;
    edtCod: TEdit;
    lblVencimento: TLabel;
    edtDataCompraVenda: TEdit;
    edtDtVenc: TEdit;
    dsPagamentos: TDataSource;
    DBGridPgto: TDBGrid;
    lblFrPgto: TLabel;
    memObsPag: TMemo;
    lblDetBx: TLabel;
    edtUser: TEdit;
    lblNomeUser: TLabel;
    edtDtPag: TEdit;
    lblDtPag: TLabel;
    edtValPago: TEdit;
    lblValorPago: TLabel;
    edtValorDesc: TEdit;
    lblValDesco: TLabel;
    lblParciais: TLabel;
    DBGridParciais: TDBGrid;
    dsParciais: TDataSource;
    procedure btnSairClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FQueryPgtosBx, FQueryParciais: TSFQuery;
    FIdOrigem: Integer;
    FOrigem: String;
    FTelaAtiva: Boolean;

    function ValidaOrigem: Boolean;
    function CarregaDados: Boolean;
    function CarregaCr: Boolean;
    procedure CarregaPgtoCr;
    procedure CarregaParciaisCr;
    function CarregaCp: Boolean;
    procedure CarregaPgtoCp;
    procedure CarregaParciaisCp;

  public
    property IdOrigem: Integer read FIdOrigem write FIdOrigem;
    property Origem: String read FOrigem write FOrigem;

  end;

var
  frmDetalhesOrigemCpCr: TfrmDetalhesOrigemCpCr;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Model.Entidades.CP,
  SistemaFinanceiro.Model.Entidades.CR,
  SistemaFinanceiro.Model.dmClientes,
  SistemaFinanceiro.Model.dmFornecedores,
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe,
  SistemaFinanceiro.Model.dmFaturaCartao,
  SistemaFinanceiro.Model.Entidades.Usuario,
  uEnumsUtils;

procedure TfrmDetalhesOrigemCpCr.btnSairClick(Sender: TObject);
begin
  Close;
end;

function TfrmDetalhesOrigemCpCr.CarregaCp: Boolean;
var
  lCp: TModelCP;
  lDetalheCp: TModelCpDetalhe;
  lUsuario: TModelUsuario;
begin
  Result := False;

  lCp := TModelCP.Create;
  lDetalheCp := TModelCpDetalhe.Create;
  lUsuario := TModelUsuario.Create;
  try
    try
      if not lCp.Existe(FIdOrigem, True) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Não encontrado CP!', tmErro);
        Exit;
      end;

      if not lDetalheCp.ExistePorCp(FIdOrigem, True) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Não encontrado detalhes da CP!', tmErro);
        Exit;
      end;

      // Atualiza titulo
      pnlTitulo.Caption := 'Detalhes do lançamento no Caixa do Contas a Pagar';

      lUsuario.Existe(lDetalheCp.Usuario, True);

      // Carrega os dados
      edtCod.Text := IntToStr(lCp.ID);
      edtForCli.Text := IntToStr(lCp.IdFornecedor) + ' - ' + dmFornecedores.GetNomeFornecedor
        (IntToStr(lCp.IdFornecedor));
      lblForCli.Caption := 'Fornecedor';

      if lCp.Doc <> '' then
        edtNDoc.Text := lCp.Doc
      else
        edtNDoc.Text := 'Não Informado';

      edtDataCompraVenda.Text := FormatDateTime('DD/MM/YYYY', lCp.DataCompra);
      lblData.Caption := 'Data da Compra';

      memDesc.Text := lCp.Desc;
      edtValor.Text := TUtilitario.FormatoMoeda(lCp.ValorParcela);
      edtDtVenc.Text := FormatDateTime('DD/MM/YYYY', lCp.DataVencimento);

      if lCp.IdFatCartao > 0 then
      begin

        lblFatCartao.Visible := True;
        edtFatCartao.Visible := True;
        edtFatCartao.Text := IntToStr(lCp.IdFatCartao) + ' - ' + dmFaturaCartao.GetNomeFatCartao
          (IntToStr(lCp.IdFatCartao));

      end
      else
      begin
        lblFatCartao.Visible := False;
        edtFatCartao.Visible := False;
      end;

      // Pegando dados dos detalhes da baixa
      edtDtPag.Text := FormatDateTime('DD/MM/YYYY', lDetalheCp.Data);
      edtValPago.Text := TUtilitario.FormatoMoeda(lDetalheCp.Valor);
      edtValorDesc.Text := TUtilitario.FormatoMoeda(lDetalheCp.ValorDesc);
      edtUser.Text := Format('%d - %s', [lUsuario.ID, lUsuario.Nome]);
      memObsPag.Text := lDetalheCp.Detalhes;

      CarregaPgtoCp;
      CarregaParciaisCp;

      Result := True;

    except
      on E: Exception do
      begin
        TfrmMensagem.TelaMensagem('Erro ao Carregar Origem', 'Falha ao carregar dados da Conta a Pagar: ' +
          E.Message, tmErro);
      end;
    end;
  finally
    lCp.Free;
    lDetalheCp.Free;
    lUsuario.Free;
  end;
end;

function TfrmDetalhesOrigemCpCr.CarregaCr: Boolean;
var
  lCr: TModelCr;
  lCrDet: TModelCrDetalhe;
  lUsuario: TModelUsuario;
begin

  Result := False;

  lCr := TModelCr.Create;
  lCrDet := TModelCrDetalhe.Create;
  lUsuario := TModelUsuario.Create;
  try
    try

      if not lCr.Existe(FIdOrigem, True) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Não encontrado CR!!', tmErro);
        Exit;
      end;

      if not lCrDet.ExistePorCr(FIdOrigem, True) then
      begin
        TfrmMensagem.TelaMensagem('Erro!', 'Não encontrado detalhes da CR!', tmErro);
        Exit;
      end;

      // Atualiza titulo
      pnlTitulo.Caption := 'Detalhes do lançamento no Caixa do Contas a Receber';

      lUsuario.Existe(lCrDet.Usuario, True);

      // Carrega os dados
      edtCod.Text := IntToStr(lCr.ID);
      edtForCli.Text := IntToStr(lCr.IdCliente) + ' - ' + dmClientes.GetNomeCliente(IntToStr(lCr.IdCliente));
      lblForCli.Caption := 'Cliente';

      if lCr.Doc <> '' then
        edtNDoc.Text := lCr.Doc
      else
        edtNDoc.Text := 'Não Informado';

      edtDataCompraVenda.Text := FormatDateTime('DD/MM/YYYY', lCr.DataVenda);
      lblData.Caption := 'Data da Venda';

      memDesc.Text := lCr.Desc;
      edtValor.Text := TUtilitario.FormatoMoeda(lCr.ValorParcela);
      edtDtVenc.Text := FormatDateTime('DD/MM/YYYY', lCr.DataVencimento);

      lblFatCartao.Visible := False;
      edtFatCartao.Visible := False;

      // Pegando dados dos detalhes da baixa
      edtDtPag.Text := FormatDateTime('DD/MM/YYYY', lCrDet.Data);
      edtValPago.Text := TUtilitario.FormatoMoeda(lCrDet.Valor);
      edtValorDesc.Text := TUtilitario.FormatoMoeda(lCrDet.ValorDesc);
      edtUser.Text := Format('%d - %s', [lUsuario.ID, lUsuario.Nome]);
      memObsPag.Text := lCrDet.Detalhes;

      CarregaPgtoCr;
      CarregaParciaisCr;

      Result := True;

    except
      on E: Exception do
      begin
        TfrmMensagem.TelaMensagem('Erro ao Carregar Origem', 'Falha ao carregar dados da Conta a Receber: ' +
          E.Message, tmErro);
      end;
    end;
  finally
    lCr.Free;
    lCrDet.Free;
    lUsuario.Free;
  end;

end;

function TfrmDetalhesOrigemCpCr.CarregaDados: Boolean;
begin

  Result := False;

  if (FOrigem = 'CR') then
    Result := CarregaCr
  else if (FOrigem = 'CP') then
    Result := CarregaCp;

end;

procedure TfrmDetalhesOrigemCpCr.CarregaParciaisCp;
var
  lSQLParciais: String;
begin
  // Montando o SQL das Parciais
  lSQLParciais := 'SELECT * FROM CONTAS_PAGAR WHERE PARCIAL = ''S'' ' +
    ' AND CP_ORIGEM = :IDCP';

  if Assigned(FQueryParciais) then
    FreeAndNil(FQueryParciais);

  FQueryParciais := TSFQuery.Create(nil);

  FQueryParciais.Close;
  FQueryParciais.SQL.Clear;
  FQueryParciais.Params.Clear;
  FQueryParciais.SQL.Add(lSQLParciais);

  FQueryParciais.ParamByName('IDCP').AsInteger := FIdOrigem;
  FQueryParciais.Prepare;
  FQueryParciais.Open;

  // Se não exisitir nenhuma CP Parcial ira ocultar
  // O grid das parciais
  if FQueryParciais.IsEmpty then
  begin

    lblParciais.Visible := False;
    DBGridParciais.Visible := False;

  end;

  // Definindo o dataset do datasource
  dsParciais.DataSet := FQueryParciais;
end;

procedure TfrmDetalhesOrigemCpCr.CarregaParciaisCr;
var
  lSQLParciais: String;
begin
  // Montando SQL das Parciais
  lSQLParciais := 'SELECT * FROM CONTAS_RECEBER WHERE PARCIAL = ''S'' ' +
    ' AND CR_ORIGEM = :IDCR';

  if Assigned(FQueryParciais) then
    FreeAndNil(FQueryParciais);

  FQueryParciais := TSFQuery.Create(nil);

  FQueryParciais.Close;
  FQueryParciais.SQL.Clear;
  FQueryParciais.SQL.Add(lSQLParciais);

  FQueryParciais.ParamByName('IDCR').AsInteger := FIdOrigem;
  FQueryParciais.Open;

  // Se não exisitir nenhuma CR Parcial ira ocultar
  // O grid das parciais
  if FQueryParciais.IsEmpty then
  begin
    lblParciais.Visible := False;
    DBGridParciais.Visible := False;
  end;

  // Definindo o dataset do datasource
  dsParciais.DataSet := FQueryParciais;
end;

procedure TfrmDetalhesOrigemCpCr.CarregaPgtoCp;
var
  lSQLPgto: String;
begin
  // Montando o SQL dos pagamentos
  lSQLPgto := 'SELECT PG.*, FR.NOME_FR FROM PGTO_BX_CP PG ' +
    'LEFT JOIN FR_PGTO FR ON PG.ID_FR_PGTO = FR.ID_FR ' +
    'WHERE PG.ID_CP = :IDCP';

  if Assigned(FQueryPgtosBx) then
    FreeAndNil(FQueryPgtosBx);

  FQueryPgtosBx := TSFQuery.Create(nil);

  FQueryPgtosBx.Close;
  FQueryPgtosBx.SQL.Clear;
  FQueryPgtosBx.Params.Clear;
  FQueryPgtosBx.SQL.Add(lSQLPgto);

  FQueryPgtosBx.ParamByName('IDCP').AsInteger := FIdOrigem;
  FQueryPgtosBx.Prepare;
  FQueryPgtosBx.Open();

  // Definindo o dataset do datasource
  dsPagamentos.DataSet := FQueryPgtosBx;
end;

procedure TfrmDetalhesOrigemCpCr.CarregaPgtoCr;
var
  lSQLPgto: String;
begin

  // Montando o SQL dos pagamentos
  lSQLPgto := 'SELECT PG.*, FR.NOME_FR FROM PGTO_BX_CR PG ' +
    'LEFT JOIN FR_PGTO FR ON PG.ID_FR_PGTO = FR.ID_FR ' +
    ' WHERE ID_CR = :IDCR';

  if Assigned(FQueryPgtosBx) then
    FreeAndNil(FQueryPgtosBx);

  FQueryPgtosBx := TSFQuery.Create(nil);

  FQueryPgtosBx.Close;
  FQueryPgtosBx.SQL.Clear;
  FQueryPgtosBx.Params.Clear;
  FQueryPgtosBx.SQL.Add(lSQLPgto);

  FQueryPgtosBx.ParamByName('IDCR').AsInteger := FIdOrigem;
  FQueryPgtosBx.Open();

  // Definindo o dataset do datasource
  dsPagamentos.DataSet := FQueryPgtosBx;

end;

procedure TfrmDetalhesOrigemCpCr.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin

    if not((ValidaOrigem) and (CarregaDados)) then
    begin
      TUtilitario.FecharFormulario(Self);
      Exit;
    end;

    FTelaAtiva := True;
  end;
end;

procedure TfrmDetalhesOrigemCpCr.FormCreate(Sender: TObject);
begin
  FTelaAtiva := False;
end;

procedure TfrmDetalhesOrigemCpCr.FormDestroy(Sender: TObject);
begin
  if Assigned(FQueryPgtosBx) then
    FQueryPgtosBx.Free;

  if Assigned(FQueryParciais) then
    FQueryParciais.Free;
end;

function TfrmDetalhesOrigemCpCr.ValidaOrigem: Boolean;
begin
  Result := False;

  if ((FOrigem <> 'CR') and (FOrigem <> 'CP')) then
  begin
    TfrmMensagem.TelaMensagem('Erro!', 'Origem Inválida!', tmErro);
    Exit;
  end;

  if (FIdOrigem <= 0) then
  begin
    TfrmMensagem.TelaMensagem('Erro', 'Id de origem inválida', tmErro);
    Exit;
  end;

  Result := True;
end;

end.
