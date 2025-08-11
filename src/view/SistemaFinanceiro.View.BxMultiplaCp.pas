unit SistemaFinanceiro.View.BxMultiplaCp;

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
  Vcl.ComCtrls,
  System.ImageList,
  Vcl.ImgList,
  SistemaFinanceiro.View.Fornecedores,
  SistemaFinanceiro.View.FaturaCartao,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  System.DateUtils,
  SistemaFinanceiro.View.BxMulti.InfosBx,
  fMensagem,
  SistemaFinanceiro.Model.uSFQuery,
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  System.Generics.Collections,
  SistemaFinanceiro.Model.Entidades.PgtoBxCp;

type
  TfrmBxMultiplaCp = class(TForm)
    pnlFiltros: TPanel;
    pnlContas: TPanel;
    pnlBotoes: TPanel;
    dateInicial: TDateTimePicker;
    lblDataInicial: TLabel;
    lblDataFinal: TLabel;
    dateFinal: TDateTimePicker;
    ImageList1: TImageList;
    btnVisualizar: TButton;
    edtFornecedor: TEdit;
    lblFornecedor: TLabel;
    btnPesquisaFornecedor: TButton;
    lblNomeFornecedor: TLabel;
    lblCodFatCartao: TLabel;
    edtCodFatCartao: TEdit;
    btnPesqFat: TButton;
    lblNomeFatCartao: TLabel;
    DataSourceBxMultiplaCP: TDataSource;
    btnConfirmar: TButton;
    btnSair: TButton;
    lblData: TLabel;
    cbData: TComboBox;
    pnlValorSelecionadas: TPanel;
    edtValorSel: TEdit;
    lblValorSelecionadas: TLabel;
    pnlQtdSelecionadas: TPanel;
    lblQtdSelecionada: TLabel;
    edtQtdSelecionada: TEdit;
    grdCp: TDBGrid;
    pnlQtdCp: TPanel;
    lblQtdCp: TLabel;
    edtQtdCp: TEdit;
    pnlQtdTotCP: TPanel;
    lblValorCps: TLabel;
    edtValorTotCP: TEdit;
    ImageListGrd: TImageList;
    checkParciais: TCheckBox;
    lblCheckParciais: TLabel;
    checkSelAll: TCheckBox;
    lblCheckSelAll: TLabel;
    pnlPrincipal: TPanel;
    pgcBaixaMult: TPageControl;
    tbsBaixa: TTabSheet;
    tbsLogErros: TTabSheet;
    pnlBaixar: TPanel;
    pnlLogErros: TPanel;
    memLogErros: TMemo;
    procedure btnPesquisaFornecedorClick(Sender: TObject);
    procedure btnPesqFatClick(Sender: TObject);
    procedure edtFornecedorExit(Sender: TObject);
    procedure edtCodFatCartaoExit(Sender: TObject);
    procedure grdCpDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grdCpCellClick(Column: TColumn);
    procedure btnConfirmarClick(Sender: TObject);
    procedure grdCpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure checkSelAllClick(Sender: TObject);
    procedure PesquisaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    FTelaAtiva: Boolean;
    FQueryPesquisa: TSFQuery;

    procedure InicializaTela;
    procedure InicializaFiltros;
    procedure LimparLabels;
    procedure BuscaNomeFornecedor;
    procedure BuscaNomeFatCartao;
    procedure SelAllReg;
    procedure Pesquisar;
    procedure CalcCpGrid;
    procedure CalcQtdCpGrid;
    procedure CalcQtdCpSel;

    function CalcCpSel: Double;
    function CalcDescBx(ValorCP, ValorTot, ValorDesc: Currency): Currency;

    procedure AbreTelaFornecedor;
    procedure AbreTelaFaturas;

    procedure Confirmar;
    function ObterDetalhesBaixa(const pDtMaisAnt: TDate; const pValorSel: Double; out pOutCodPgto: Integer)
      : TModelCpDetalhe;
    function CarregaPgto(const pIdFrPgto: Integer): TObjectList<TModelPgtoBxCp>;

    procedure RegistrarLogsErros(const Logs: TStringList);

  public
    { Public declarations }
  end;

var
  frmBxMultiplaCp: TfrmBxMultiplaCp;

implementation

{$R *.dfm}


uses
  FireDAC.Stan.Param,
  SistemaFinanceiro.Utilitarios,
  uEnumsUtils,
  SistemaFinanceiro.Model.Entidades.Fornecedor,
  SistemaFinanceiro.Model.Entidades.FaturaCartao,
  SistemaFinanceiro.Exceptions.ContasPagarDetalhe,
  SistemaFinanceiro.Exceptions.PgtoBaixaCp,
  SistemaFinanceiro.Controller.BaixaMultCp;

procedure TfrmBxMultiplaCp.AbreTelaFaturas;
var
  lFormulario: TfrmFaturaCartao;
begin

  // Cria o form
  lFormulario := TfrmFaturaCartao.Create(Self);
  try

    // Exibe o form
    lFormulario.ShowModal;
    edtCodFatCartao.Text := lFormulario.RetornaCodigo;

  finally
    lFormulario.Free;
  end;

  edtCodFatCartao.SetFocus;

end;

procedure TfrmBxMultiplaCp.AbreTelaFornecedor;
var
  lFormulario: TfrmFornecedores;
begin
  // Cria o form
  lFormulario := TfrmFornecedores.Create(Self);
  try

    // Exibe o form
    lFormulario.ShowModal;
    edtFornecedor.Text := lFormulario.RetornaCodigo;

  finally
    lFormulario.Free;
  end;

  edtFornecedor.SetFocus;

end;

procedure TfrmBxMultiplaCp.btnConfirmarClick(Sender: TObject);
begin
  Confirmar;
end;

procedure TfrmBxMultiplaCp.btnPesqFatClick(Sender: TObject);
begin
  AbreTelaFaturas;
end;

procedure TfrmBxMultiplaCp.btnPesquisaFornecedorClick(Sender: TObject);
begin
  AbreTelaFornecedor;
end;

procedure TfrmBxMultiplaCp.BuscaNomeFatCartao;
var
  lFatura: TModelFaturaCartao;
  lCod: Integer;
begin

  lblNomeFatCartao.Caption := '';
  if not(Trim(edtCodFatCartao.Text).IsEmpty) then
  begin

    lFatura := TModelFaturaCartao.Create;
    try

      lCod := StrToIntDef(Trim(edtCodFatCartao.Text), 0);
      if not(lFatura.Existe(lCod, True)) then
      begin
        TfrmMensagem.TelaMensagem('Atenção!', 'Fatura de Cartão não encontrada!', tmAviso);
        pgcBaixaMult.ActivePage := tbsBaixa;
        edtCodFatCartao.SetFocus;
        edtCodFatCartao.Clear;
        Exit;
      end;

      if not(lFatura.StatusFt) then
      begin
        TfrmMensagem.TelaMensagem('Atenção!', 'Fatura de Cartão não está Ativa, verifique o cadastro!', tmAviso);
        pgcBaixaMult.ActivePage := tbsBaixa;
        edtCodFatCartao.Clear;
        edtCodFatCartao.SetFocus;
        Exit;
      end;

      lblNomeFatCartao.Caption := lFatura.Nome;

    finally
      lFatura.Free;
    end;

  end;

end;

procedure TfrmBxMultiplaCp.BuscaNomeFornecedor;
var
  lFornecedor: TModelFornecedor;
  lCod: Integer;
begin
  lblNomeFornecedor.Caption := '';
  if not(Trim(edtFornecedor.Text).IsEmpty) then
  begin

    lFornecedor := TModelFornecedor.Create;
    try

      lCod := StrToIntDef(Trim(edtFornecedor.Text), 0);
      if not(lFornecedor.Existe(lCod, True)) then
      begin
        TfrmMensagem.TelaMensagem('Atenção!', 'Fornecedor não encontrado!', tmAviso);
        pgcBaixaMult.ActivePage := tbsBaixa;
        edtFornecedor.SetFocus;
        edtFornecedor.Clear;
        Exit;
      end;

      if not(lFornecedor.Status_For) then
      begin
        TfrmMensagem.TelaMensagem('Atenção!', 'Fornecedor não está Ativo, verifique o cadastro!', tmAviso);
        pgcBaixaMult.ActivePage := tbsBaixa;
        edtFornecedor.Clear;
        edtFornecedor.SetFocus;
        Exit;
      end;

      lblNomeFornecedor.Caption := lFornecedor.Razao_Social;

    finally
      lFornecedor.Free;
    end;

  end;

end;

procedure TfrmBxMultiplaCp.CalcCpGrid;
var
  lTotalCp: Double;

begin

  lTotalCp := 0;

  // Desativa o controle
  grdCp.DataSource.DataSet.DisableControls;
  try

    // Percorre e soma
    with grdCp.DataSource.DataSet do
    begin

      // Posiciona no primeiro reg
      First;

      while not Eof do
      begin
        lTotalCp := lTotalCp + FieldByName('VALOR_PARCELA').AsCurrency;
        Next;
      end;

    end;

    edtValorTotCP.Text := TUtilitario.FormatoMoeda(lTotalCp);
  finally
    // Reativa o controle
    grdCp.DataSource.DataSet.EnableControls;
  end;

end;

function TfrmBxMultiplaCp.CalcCpSel: Double;
var
  I: Integer;
  lBmAtual: TBookmark;
begin
  Result := 0.0;

  if grdCp.SelectedRows.Count > 0 then
  begin
    with grdCp.DataSource.DataSet do
    begin
      DisableControls; // evita refresh visual
      lBmAtual := Bookmark; // salva posição exata atual

      try
        for I := 0 to grdCp.SelectedRows.Count - 1 do
        begin
          Bookmark := grdCp.SelectedRows[I];
          Result := Result + FieldByName('VALOR_PARCELA').AsCurrency;
        end;

      finally
        Bookmark := lBmAtual; // volta para o registro original
        EnableControls;
      end;
    end;
  end;
end;

function TfrmBxMultiplaCp.CalcDescBx(ValorCP, ValorTot,
  ValorDesc: Currency): Currency;
var
  PercentCp: Currency;
  ValorDescCp: Currency;
begin

  PercentCp := 0;
  ValorDescCp := 0;
  Result := 0;

  if (ValorCP < 0) then
  begin
    Application.MessageBox('Valor Conta a Pagar < 0!', 'Atenção', MB_OK + MB_ICONWARNING);
  end
  else if (ValorTot < 0) then
  begin
    Application.MessageBox('Valor Total das Contas < 0!', 'Atenção', MB_OK + MB_ICONWARNING);
  end
  else if (ValorDesc < 0) then
  begin
    Application.MessageBox('Valor Desconto < 0!', 'Atenção', MB_OK + MB_ICONWARNING);
  end
  else
  begin

    // Descobre o percentual da conta
    PercentCp := (ValorCP / ValorTot);

    // Descobre o valor do desconto para a conta
    ValorDescCp := (PercentCp * ValorDesc);

    Result := ValorDescCp;

  end;

end;

procedure TfrmBxMultiplaCp.CalcQtdCpGrid;
var
  lQtdCp: Integer;

begin

  lQtdCp := 0;

  // Realiza a conta
  lQtdCp := grdCp.DataSource.DataSet.RecordCount;

  // Exibe na label
  edtQtdCp.Text := IntToStr(lQtdCp);

end;

procedure TfrmBxMultiplaCp.CalcQtdCpSel;
begin

  if Assigned(grdCp.SelectedRows) then
  begin

    // Exibe no edit
    edtQtdSelecionada.Text := IntToStr(grdCp.SelectedRows.Count);

  end;

end;

function TfrmBxMultiplaCp.CarregaPgto(const pIdFrPgto: Integer): TObjectList<TModelPgtoBxCp>;
var
  lListaPgtos: TObjectList<TModelPgtoBxCp>;
  lPgto: TModelPgtoBxCp;
begin
  // Implementação de um unico pgto, no futuro adicionar multiplas formas
  Result := nil;

  try

    lListaPgtos := TObjectList<TModelPgtoBxCp>.Create;
    lPgto := TModelPgtoBxCp.Create;

    lPgto.IdFrPgto := pIdFrPgto;
    lPgto.NrPgto := 1;
    lPgto.DataHora := Now;

    lListaPgtos.Add(lPgto);

    Result := lListaPgtos;

  except
    on E: Exception do
    begin
      raise ECpObterPgtos.Create;
    end;
  end;

end;

procedure TfrmBxMultiplaCp.checkSelAllClick(Sender: TObject);
begin

  // Seleciona todas as contas no dbgrid
  SelAllReg;

  // Exibe o valor total das selecionadas
  edtValorSel.Text := TUtilitario.FormatoMoeda(CalcCpSel);
  CalcQtdCpSel;

end;

procedure TfrmBxMultiplaCp.Confirmar;
var
  lDetalhes: TModelCpDetalhe;
  lPgtos: TObjectList<TModelPgtoBxCp>;
  lControllerBaixa: TControllerBaixaMultCp;
  lListaCPs: TList<Integer>;
  lDtCpMaisAntiga, lDtCompraSel: TDateTime;
  I: Integer;
  lIdFrPgto: Integer;
  lBmAtual: TBookmark;
  lTotalCpSelec: Double;
  lVerErros: Boolean;
begin

  lIdFrPgto := 0;
  lTotalCpSelec := 0;
  lVerErros := False;

  if not(grdCp.SelectedRows.Count > 0) then
  begin
    TfrmMensagem.TelaMensagem('Atenção!', 'Selecione uma ou mais contas para baixar.', tmAviso);
    Exit;
  end;

  lDetalhes := nil;
  lPgtos := nil;
  lControllerBaixa := TControllerBaixaMultCp.Create;
  lListaCPs := TList<Integer>.Create;
  try

    lControllerBaixa.LogsErros := RegistrarLogsErros;
    lDtCpMaisAntiga := MaxDateTime;

    with grdCp.DataSource.DataSet do
    begin
      DisableControls; // evita refresh do grid
      lBmAtual := Bookmark; // guarda a posição atual

      try
        for I := 0 to grdCp.SelectedRows.Count - 1 do
        begin
          Bookmark := grdCp.SelectedRows[I]; // vai até o registro selecionado

          lListaCPs.Add(FieldByName('ID').AsInteger);
          lDtCompraSel := FieldByName('DATA_COMPRA').AsDateTime;
          if lDtCompraSel < lDtCpMaisAntiga then
            lDtCpMaisAntiga := lDtCompraSel;
        end;

      finally
        Bookmark := lBmAtual; // volta para o registro original
        EnableControls; // reativa refresh do grid
      end;
    end;

    lTotalCpSelec := CalcCpSel;
    lDetalhes := ObterDetalhesBaixa(lDtCpMaisAntiga, lTotalCpSelec, lIdFrPgto);
    if not(Assigned(lDetalhes)) then
      Exit;

    lPgtos := CarregaPgto(lIdFrPgto);
    if not(Assigned(lPgtos)) then
      Exit;

    if (lControllerBaixa.Baixar(lListaCPs, lTotalCpSelec, lDetalhes, lPgtos)) then
    begin
      TfrmMensagem.TelaMensagem('Sucesso!', 'Conta a Pagar baixada com sucesso.', tmSucesso);
    end
    else
    begin
      lVerErros := (TfrmMensagem.TelaEscolha('Atenção!',
        'Ocorreram falhas ao baixar algumas contas, deseja visualizar os logs?', tmEscolha) = mrYes);
      if (lVerErros) then
      begin
        pgcBaixaMult.ActivePage := tbsLogErros;
        memLogErros.SetFocus;
      end;
    end;

    Pesquisar;

  finally
    lDetalhes.Free;
    lPgtos.Free;
    lControllerBaixa.Free;
    lListaCPs.Free;
  end;

end;

procedure TfrmBxMultiplaCp.grdCpCellClick(Column: TColumn);
begin

  // Atualiza valores e quantidades de cps selecionadas
  edtValorSel.Text := TUtilitario.FormatoMoeda(CalcCpSel);
  CalcQtdCpSel;

end;

procedure TfrmBxMultiplaCp.grdCpDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  // Altera a cor das duplicatas vencidas
  if (not grdCp.DataSource.DataSet.IsEmpty) and
    (grdCp.DataSource.DataSet.FieldByName('DATA_VENCIMENTO').AsDateTime < Date)
    and (grdCp.DataSource.DataSet.FieldByName('STATUS').AsString = 'A') then
  begin
    grdCp.Canvas.Font.Color := clRed; // Define a cor do texto da célula
  end;

  // Intercala a cor das contas não selecionadas
  if (gdSelected in State) then
  begin

    grdCp.Canvas.Brush.Color := $00578B2E; // Define a cor de fundo da célula selecionada
    grdCp.Canvas.Font.Color := clWhite; // Define a cor do texto da célula selecionada

  end;

  // Desenha a célula com as propriedades de cor atualizadas
  grdCp.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  TUtilitario.FormatoMoedaGrid(TDBGrid(Sender), Column, Rect, State);

end;

procedure TfrmBxMultiplaCp.grdCpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  // Realiza o calculo caso o user use o shift + seta para baixo
  // para selecionar as contas
  if Key = VK_DOWN then
  begin

    edtValorSel.Text := TUtilitario.FormatoMoeda(CalcCpSel);
    CalcQtdCpSel;

  end;

end;

procedure TfrmBxMultiplaCp.edtCodFatCartaoExit(Sender: TObject);
begin
  BuscaNomeFatCartao;
end;

procedure TfrmBxMultiplaCp.edtFornecedorExit(Sender: TObject);
begin
  BuscaNomeFornecedor;
end;

procedure TfrmBxMultiplaCp.FormActivate(Sender: TObject);
begin
  if not(FTelaAtiva) then
  begin
    InicializaTela;
    InicializaFiltros;
    FTelaAtiva := True;
  end;
end;

procedure TfrmBxMultiplaCp.FormDestroy(Sender: TObject);
begin
  if Assigned(FQueryPesquisa) then
    FQueryPesquisa.Free;
end;

procedure TfrmBxMultiplaCp.FormKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmBxMultiplaCp.InicializaFiltros;
begin
  dateInicial.Date := StartOfTheMonth(Now);
  dateFinal.Date := EndOfTheMonth(Now);
end;

procedure TfrmBxMultiplaCp.InicializaTela;
begin
  LimparLabels;
  pgcBaixaMult.ActivePage := tbsBaixa;
end;

procedure TfrmBxMultiplaCp.LimparLabels;
begin
  lblNomeFornecedor.Caption := '';
  lblNomeFatCartao.Caption := '';
end;

function TfrmBxMultiplaCp.ObterDetalhesBaixa(const pDtMaisAnt: TDate; const pValorSel: Double;
  out pOutCodPgto: Integer)
  : TModelCpDetalhe;
var
  lFormulario: TfrmInfoBxMult;
begin
  Result := nil;

  lFormulario := TfrmInfoBxMult.Create(nil);
  try
    try
      lFormulario.DtMaisAnt := pDtMaisAnt;
      lFormulario.ValorCpSel := pValorSel;
      lFormulario.ShowModal;

      if (lFormulario.ModalResult = mrOk) then
      begin
        Result := lFormulario.ObterDetalhes;
        pOutCodPgto := lFormulario.CodFrPgto;
      end;
    except
      on E: Exception do
      begin
        raise ECpObterDetalhe.Create;
      end;
    end;

  finally
    lFormulario.Free;
  end;

end;

procedure TfrmBxMultiplaCp.PesquisaClick(Sender: TObject);
begin
  if (FTelaAtiva) then
    Pesquisar;
end;

procedure TfrmBxMultiplaCp.Pesquisar;
var
  LFiltro: String;
  LOrdem: String;
begin
  LFiltro := '';
  LOrdem := '';

  if Assigned(FQueryPesquisa) then
    FreeAndNil(FQueryPesquisa);

  FQueryPesquisa := TSFQuery.Create(nil);

  try
    // Validações
    if (dateInicial.Date > dateFinal.Date) then
    begin
      TfrmMensagem.TelaMensagem('Atenção!', 'Data Inicial não pode ser maior que a data Final!', tmAviso);
      dateFinal.SetFocus;
      Exit;
    end;

    if (cbData.ItemIndex < 0) then
    begin
      TfrmMensagem.TelaMensagem('Atenção', 'Selecione um tipo de DATA!', tmAviso);
      cbData.SetFocus;
      Exit;
    end;

    if (Trim(edtFornecedor.Text).IsEmpty) and (Trim(edtCodFatCartao.Text).IsEmpty) then
    begin
      edtFornecedor.SetFocus;
      Exit;
    end;

    // Pesquisa por data
    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin

      case cbData.ItemIndex of

        0:
          LFiltro := LFiltro + ' AND CP.DATA_COMPRA BETWEEN :DTINI AND :DTFIM ';
        1:
          LFiltro := LFiltro + ' AND CP.DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM ';

      end;

    end;

    // Pesquisa parciais
    if (checkParciais.Checked) then
    begin
      LFiltro := LFiltro + ' AND CP.PARCIAL = ''S'' ';
    end;

    // Pesquisa por FORNECEDORES
    if not(Trim(edtFornecedor.Text).IsEmpty) then
    begin
      LFiltro := LFiltro + ' AND CP.ID_FORNECEDOR = :ID ';
    end;

    // Pesquisa por Fatura de Cartao
    if not(Trim(edtCodFatCartao.Text).IsEmpty) then
    begin
      LFiltro := LFiltro + ' AND CP.ID_FATURA = :ID_FT ';
    end;

    // Ordem de pesquisa
    LOrdem := ' ORDER BY CP.DATA_VENCIMENTO';

    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add('SELECT CP.*, '''' SELECIONADO, F.RAZAO_SOCIAL FROM CONTAS_PAGAR CP ');
    FQueryPesquisa.SQL.Add('   LEFT JOIN Fornecedores F ON CP.ID_FORNECEDOR = F.ID_FORNEC WHERE STATUS = ''A'' ');
    FQueryPesquisa.SQL.Add(LFiltro);
    FQueryPesquisa.SQL.Add(LOrdem);

    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin
      FQueryPesquisa.ParamByName('DTINI').AsDateTime := dateInicial.Date;
      FQueryPesquisa.ParamByName('DTFIM').AsDateTime := dateFinal.Date;
    end;

    if not(Trim(edtFornecedor.Text).IsEmpty) then
      FQueryPesquisa.ParamByName('ID').AsInteger := StrToIntDef(Trim(edtFornecedor.Text), 0);

    if not(Trim(edtCodFatCartao.Text).IsEmpty) then
      FQueryPesquisa.ParamByName('ID_FT').AsInteger := StrToIntDef(Trim(edtCodFatCartao.Text), 0);

    FQueryPesquisa.Open;
    grdCp.DataSource.DataSet := FQueryPesquisa;

    // Calcula a quantidade e valor
    CalcCpGrid;
    CalcQtdCpGrid;

    // Coloca na primeira posição
    grdCp.DataSource.DataSet.First;

  except
    on E: Exception do
    begin
      TfrmMensagem.TelaMensagem('Erro!', 'Erro ao executar consulta: ' + E.Message, tmErro);
    end;
  end;

end;

procedure TfrmBxMultiplaCp.RegistrarLogsErros(const Logs: TStringList);
begin
  memLogErros.Clear;
  memLogErros.Lines.AddStrings(Logs);
end;

procedure TfrmBxMultiplaCp.SelAllReg;
var
  I: Integer;

begin

  // Verifica se o DBGrid está conectado a um DataSource
  if Assigned(grdCp.DataSource) and Assigned(grdCp.DataSource.DataSet) then
  begin

    // Verifica se o data set esta aberto
    if grdCp.DataSource.DataSet.Active then
    begin

      // Verifica se o conjunto de dados não está vazio
      if not grdCp.DataSource.DataSet.IsEmpty then
      begin

        // Desativa controles de atualização para melhorar o desempenho
        grdCp.DataSource.DataSet.DisableControls;
        try

          // Coloca na primeira posição
          grdCp.DataSource.DataSet.First;

          for I := 0 to grdCp.DataSource.DataSet.RecordCount - 1 do
          begin

            grdCp.SelectedRows.CurrentRowSelected := (checkSelAll.Checked);
            grdCp.DataSource.DataSet.Next;

          end;

        finally

          // Reativa controles
          grdCp.DataSource.DataSet.EnableControls;

        end;

      end;

    end;

  end;

end;

end.
