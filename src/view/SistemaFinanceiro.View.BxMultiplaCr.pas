unit SistemaFinanceiro.View.BxMultiplaCr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  SistemaFinanceiro.View.Clientes, SistemaFinanceiro.View.BxMulti.InfosBx,
  SistemaFinanceiro.Model.Entidades.CR, SistemaFinanceiro.Model.uSFQuery;

type
  TfrmBxMultiplaCR = class(TForm)
    ImageList1: TImageList;
    ImageList2: TImageList;
    pnlBotoes: TPanel;
    btnConfirmar: TButton;
    btnSair: TButton;
    pnlValorSelecionadas: TPanel;
    lblValorSelecionadas: TLabel;
    edtValorSel: TEdit;
    pnlQtdSelecionadas: TPanel;
    lblQtdSelecionada: TLabel;
    edtQtdSelecionada: TEdit;
    pnlQtdCr: TPanel;
    lblQtdCr: TLabel;
    edtQtdCr: TEdit;
    pnlQtdTotCr: TPanel;
    lblValorCRs: TLabel;
    edtValorTotCR: TEdit;
    pnlContas: TPanel;
    DBGrid1: TDBGrid;
    pnlFiltros: TPanel;
    lblDataInicial: TLabel;
    lblDataFinal: TLabel;
    lblCodCliente: TLabel;
    lblNomeCliente: TLabel;
    lblData: TLabel;
    lblCheckParciais: TLabel;
    lblCheckSelAll: TLabel;
    dateInicial: TDateTimePicker;
    dateFinal: TDateTimePicker;
    btnVisualizar: TButton;
    edtCliente: TEdit;
    cbData: TComboBox;
    checkParciais: TCheckBox;
    checkSelAll: TCheckBox;
    btnPesquisaFornecedor: TButton;
    DataSourceBxMultiplaCr: TDataSource;
    procedure btnPesquisaFornecedorClick(Sender: TObject);
    procedure edtClienteChange(Sender: TObject);
    procedure edtClienteExit(Sender: TObject);
    procedure dateInicialClick(Sender: TObject);
    procedure dateFinalClick(Sender: TObject);
    procedure cbDataClick(Sender: TObject);
    procedure checkParciaisClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure checkSelAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    FQueryPesquisa : TSFQuery;
    procedure Pesquisar;
    procedure BuscaNomeCliente;
    procedure SelAllReg(DBGrid: TDBGrid);
    procedure CalcCrGrid;
    procedure CalcQtdCrGrid;
    procedure CalcQtdCrSel;

    function CalcCrSel : Currency;
    function CalcDescBx(ValorCr, ValorTot, ValorDesc : Currency) : Currency;

  public
    { Public declarations }
  end;

var
  frmBxMultiplaCR: TfrmBxMultiplaCR;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Model.dmUsuarios,
  SistemaFinanceiro.Model.dmClientes,
  SistemaFinanceiro.Utilitarios,
  System.DateUtils,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe,
  Math, SistemaFinanceiro.Model.Entidades.PgtoBxCr;

procedure TfrmBxMultiplaCR.btnConfirmarClick(Sender: TObject);
var
  lCrDetalhe         : TModelCrDetalhe;
  lCr : TModelCR;
  lFrPgtoBaixa : TModelPgtoBxCr;
  lValorCrSel        : Currency;
  lValorAbater       : Currency;
  lValorDesc         : Currency;
  lValorTotCrSel     : Currency;
  lContador, lIdCr   : Integer;
  lDtMaisAntiga      : TDateTime;
  lDtCompraSel       : TDateTime;
  lFrPgto            : Integer;
  lDtPgto            : TDateTime;
begin

  //  Inicialização das variaveis
  lValorAbater   := 0;
  lValorDesc     := 0;
  lFrPgto        := 0;
  lValorCrSel    := 0;
  lIdCr          := 0;
  lValorTotCrSel := CalcCrSel;
  lDtPgto        := MaxDateTime;


  if DBGrid1.SelectedRows.Count > 0 then
  begin

    {Pega a data mais antiga}
    // Inicializa com o maior valor possível da data
    lDtMaisAntiga      := MaxDateTime;

    for lContador := 0 to DBGrid1.SelectedRows.Count - 1 do
    begin
      DBGrid1.DataSource.DataSet.Bookmark := DBGrid1.SelectedRows[lContador];

      //  Pega a data de venda
      lDtCompraSel := DBGrid1.DataSource.DataSet.FieldByName('DATA_VENDA').AsDateTime;

      if lDtCompraSel < lDtMaisAntiga then
        lDtMaisAntiga := lDtCompraSel;
    end;


    {Chama a tela de Infos Baixa}
    try

      //  Cria o form
      frmInfoBxMult := TfrmInfoBxMult.Create(Self);

      //  Passa o valor total das contas selecionadas e a data da mais antiga
      frmInfoBxMult.ValorPago   := CalcCrSel;
      frmInfoBxMult.DtMaisAnt   := lDtMaisAntiga;

      //  Exibe o form
      frmInfoBxMult.ShowModal;

    except
      on E : Exception do
        Application.MessageBox(PWideChar(E.Message), 'Erro na forma de pagamento do documento!', MB_OK + MB_ICONWARNING);
    end;

    //  Verifica se deu tudo certo com as info de pgto
    if frmInfoBxMult.ModalResult <> mrOk then
    begin
      abort;
    end
    else
    begin
      lFrPgto      := frmInfoBxMult.CodFrPgto;
      lValorAbater := frmInfoBxMult.ValorPago;
      lValorDesc   := frmInfoBxMult.ValorDesc;
      lDtPgto      := frmInfoBxMult.DataPgto;

      FreeAndNil(frmInfoBxMult);
    end;


    {Baixando as CRs}
    for lContador := 0 to DBGrid1.SelectedRows.Count - 1 do
    begin

      DBGrid1.DataSource.DataSet.Bookmark := DBGrid1.SelectedRows[lContador];
      lCrDetalhe  := TModelCrDetalhe.Create;
      lCr := TModelCR.Create;
      lFrPgtoBaixa := TModelPgtoBxCr.Create;
      lValorCrSel := 0;
      try
        lIdCr := DBGrid1.DataSource.DataSet.FieldByName('ID').AsInteger;
        if not lCr.Existe(lIdCr, True) then
        begin
          Application.MessageBox('Erro ao carregar dados da Conta', 'Erro', MB_OK + MB_ICONERROR);
          exit;
        end;

        //  Pegando o valor da conta
        lValorCrSel := DBGrid1.DataSource.DataSet.FieldByName('VALOR_PARCELA').AsCurrency;

        lCrDetalhe.IdCR      := lCr.ID;
        lCrDetalhe.Detalhes  := 'CR baixada pela rotina de Baixa Múltipla';
        lCrDetalhe.Data      := lDtPgto;
        lCrDetalhe.Usuario   := dmUsuarios.GetUsuarioLogado.Id;
        lCrDetalhe.ValorDesc := CalcDescBx(lValorCrSel, lValorTotCrSel, lValorDesc);


        if (lValorAbater - (lValorCrSel - lCrDetalhe.ValorDesc)) > 0 then
        begin
          //  Se for maior que 0 vai baixar a conta total
          lCrDetalhe.Valor := (lValorCrSel - lCrDetalhe.ValorDesc);
        end
        else if lValorAbater > 0 then
        begin
          //  Se ainda tiver ValorAbater mas não o suficiente
          //  para baixar toda a CR, ira baixar apenas o valor
          //  abater e o restante será gerado uma Cr Parcial
          lCrDetalhe.Valor := lValorAbater;
        end
        else
        begin
          //  Caso ainda tenha alguma CR selecionada porem
          //  ValorAbater já está zerado irá baixar a conta
          //  e irá gerar uma Cr Parcial com o valor total
          lCrDetalhe.Valor := 0;
        end;

        //  Calcula o restante do valor abater
        lValorAbater := (lValorAbater - (lValorCrSel - lCrDetalhe.ValorDesc));

        {Enviando a cp para ser baixada}
        try
          lCr.BaixarCr(lCrDetalhe, lCr);
        except on E : Exception do
          Application.MessageBox(PWideChar(E.Message), 'Erro ao baixar documento!', MB_OK + MB_ICONWARNING);
        end;


        {Gravando a forma de pgto}
        try

          lFrPgtoBaixa.GeraCodigo;
          lFrPgtoBaixa.IdCr       := lCr.Id;
          lFrPgtoBaixa.IdFrPgto   := lFrPgto;
          lFrPgtoBaixa.NrPgto     := 1;
          lFrPgtoBaixa.DataHora   := Now;
          lFrPgtoBaixa.ValorPago := lCrDetalhe.Valor;

          //  Gravando no banco
          lFrPgtoBaixa.Insert;

        except on E : Exception do
          Application.MessageBox(PWideChar(E.Message), 'Erro ao salvar Forma de pagamento!', MB_OK + MB_ICONWARNING)

        end;

      finally
        lFrPgtoBaixa.Free;
        lCrDetalhe.Free;
        lCr.Free;
      end;

    end;

    Application.MessageBox('Contas baixadas com sucesso!', 'Atenção', MB_OK + MB_ICONINFORMATION);

  end
  else
  begin
     Application.MessageBox('Selecione uma ou mais contas!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
  end;

  //  Desmarca os checks e atualiza o grid
  checkParciais.Checked := False;
  checkSelAll.Checked   := False;

  Pesquisar;

end;

procedure TfrmBxMultiplaCR.btnPesquisaFornecedorClick(Sender: TObject);
begin

  //  Cria o form
  frmCliente := TfrmCliente.Create(Self);

  try

    //  Exiobe na tela
    frmCliente.ShowModal;

  finally

    //  Pega a id do cliente selecionado
    edtCliente.Text := frmCliente.DataSourceCliente.DataSet.FieldByName('ID_CLI').AsString;

    FreeAndNil(frmCliente);

  end;

  edtCliente.SetFocus;

end;

procedure TfrmBxMultiplaCR.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBxMultiplaCR.btnVisualizarClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmBxMultiplaCR.BuscaNomeCliente;
var
  NomeCliente : String;

begin

  if Trim(edtCliente.Text) <> '' then
  begin

    NomeCliente := dmClientes.GetNomeCliente(Trim(edtCliente.Text));

    if NomeCliente = '' then
    begin

      Application.MessageBox('Cliente não encontrado!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
      edtCliente.SetFocus;
      edtCliente.Clear;

    end;

    lblNomeCliente.Visible := True;
    lblNomeCliente.Caption := NomeCliente;

  end;

end;

procedure TfrmBxMultiplaCR.CalcCrGrid;
var
  TotalCr: Currency;

begin

  TotalCr := 0;

  //  Percorre e soma
  with DBGrid1.DataSource.DataSet do
  begin

    //  Desativa o controle
    DisableControls;

    //  Posiciona no primeiro reg
    First;

    while not Eof do
    begin

      TotalCr := TotalCr + FieldByName('VALOR_PARCELA').AsCurrency;

      Next;

    end;

    //  Reativa o controle
    EnableControls;

    edtValorTotCR.Text := TUtilitario.FormatoMoeda(TotalCr);

  end;

end;

function TfrmBxMultiplaCR.CalcCrSel: Currency;
var
  I, OriginalRecNo: Integer;

begin

  Result := 0.0;

  if DBGrid1.SelectedRows.Count > 0 then
  begin

    // Salvar o RecNo original
    OriginalRecNo := DBGrid1.DataSource.DataSet.RecNo;

    try
      for I := 0 to DBGrid1.SelectedRows.Count - 1 do
      begin

        // Alterar para o Bookmark do item selecionado
        DBGrid1.DataSource.DataSet.Bookmark := DBGrid1.SelectedRows[I];

        // Adicionar ao resultado
        Result := Result + DBGrid1.DataSource.DataSet.FieldByName('VALOR_PARCELA').AsCurrency;

      end;
    finally

      // Restaurar o RecNo original
      DBGrid1.DataSource.DataSet.RecNo := OriginalRecNo;

    end;
  end;


end;

function TfrmBxMultiplaCR.CalcDescBx(ValorCr, ValorTot,
  ValorDesc: Currency): Currency;
var
  PercentCr   : Currency;
  ValorDescCr : Currency;

begin

  PercentCr   := 0;
  ValorDescCr := 0;
  Result      := 0;

  if (ValorCr < 0) then
  begin
    Application.MessageBox('Valor Conta a Receber < 0!', 'Atenção', MB_OK + MB_ICONWARNING);
  end
  else if (ValorTot < 0)  then
  begin
    Application.MessageBox('Valor Total das Contas < 0!', 'Atenção', MB_OK + MB_ICONWARNING);
  end
  else if (ValorDesc < 0) then
  begin
    Application.MessageBox('Valor Desconto < 0!', 'Atenção', MB_OK + MB_ICONWARNING);
  end
  else
  begin

    //  Descobre o percentual da conta
    PercentCr := (ValorCr / ValorTot);

    //  Descobre o valor do desconto para a conta
    ValorDescCr := (PercentCr * ValorDesc);

    Result := ValorDescCr;

  end;

end;

procedure TfrmBxMultiplaCR.CalcQtdCrGrid;
var
  QtdCr: Integer;

begin

  QtdCr := 0;

  //  Realiza a conta
  QtdCr := DBGrid1.DataSource.DataSet.RecordCount;

  //  Exibe na label
  edtQtdCr.Text := IntToStr(QtdCr);

end;

procedure TfrmBxMultiplaCR.CalcQtdCrSel;
begin

   if Assigned(DBGrid1.SelectedRows) then
    begin

      //  Exibe no edit
      edtQtdSelecionada.Text := IntToStr(DBGrid1.SelectedRows.Count);

    end;

end;

procedure TfrmBxMultiplaCR.cbDataClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmBxMultiplaCR.checkParciaisClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmBxMultiplaCR.checkSelAllClick(Sender: TObject);
begin

  //  Seleciona todas as contas no dbgrid
  SelAllReg(DBGrid1);

  //  Exibe o valor total das selecionadas
  edtValorSel.Text := TUtilitario.FormatoMoeda(CalcCrSel);
  CalcQtdCrSel;

end;

procedure TfrmBxMultiplaCR.dateFinalClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmBxMultiplaCR.dateInicialClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfrmBxMultiplaCR.DBGrid1CellClick(Column: TColumn);
begin

  //  Atualiza valores e quantidades de crs selecionadas
  edtValorSel.Text := TUtilitario.FormatoMoeda(CalcCrSel);
  CalcQtdCrSel;

end;

procedure TfrmBxMultiplaCR.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  //  Altera a cor das duplicatas vencidas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
      (DBGrid1.DataSource.DataSet.FieldByName('DATA_VENCIMENTO').AsDateTime < Date)
      and (DBGrid1.DataSource.DataSet.FieldByName('STATUS').AsString = 'A')then
  begin
    DBGrid1.Canvas.Font.Color := clRed;  // Define a cor do texto da célula
  end;

  //  Intercala a cor das contas não selecionadas
  if (gdSelected in State) then
  begin

    DBGrid1.Canvas.Brush.Color := $00578B2E;  // Define a cor de fundo da célula selecionada
    DBGrid1.Canvas.Font.Color := clWhite;  // Define a cor do texto da célula selecionada

  end;

  // Desenha a célula com as propriedades de cor atualizadas
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  TUtilitario.FormatoMoedaGrid(TDBGrid(Sender), Column, Rect, State);

end;

procedure TfrmBxMultiplaCR.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  //  Realiza o calculo caso o user use o shift + seta para baixo
  //  para selecionar as contas
  if key = VK_DOWN then
  begin

    edtValorSel.Text := TUtilitario.FormatoMoeda(CalcCrSel);
    CalcQtdCrSel;

  end;

end;

procedure TfrmBxMultiplaCR.edtClienteChange(Sender: TObject);
begin

  //  Se apagar o cod do fornec apaga o nome do mesmo
  if ((GetKeyState(VK_BACK) and $8000) <> 0) then
    lblNomeCliente.Caption := '';

  Pesquisar;

end;

procedure TfrmBxMultiplaCR.edtClienteExit(Sender: TObject);
begin

  BuscaNomeCliente;

  if Trim(edtCliente.Text) <> '' then
  begin

    if dmClientes.GetStatus(Trim(edtCliente.Text)) = False then
    begin

      edtCliente.Clear;
      edtCliente.SetFocus;
      lblNomeCliente.Caption := '';
      Application.MessageBox('Cliente não está Ativo, verifique o cadastro!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
      abort;

    end;


  end;

end;

procedure TfrmBxMultiplaCR.FormCreate(Sender: TObject);
begin
  //  Define as datas da consulta
  dateInicial.Date := StartOfTheMonth(Now);
  dateFinal.Date   := EndOfTheMonth(Now);
end;

procedure TfrmBxMultiplaCR.FormDestroy(Sender: TObject);
begin
  if Assigned(FQueryPesquisa) then
    FQueryPesquisa.Free;
end;

procedure TfrmBxMultiplaCR.FormKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmBxMultiplaCR.FormShow(Sender: TObject);
begin

  //  Fecha o dataset para limpar o dbgrid;
  if Assigned(DataSourceBxMultiplaCr) and Assigned(DataSourceBxMultiplaCr.DataSet) then
  begin
    DataSourceBxMultiplaCr.DataSet.Close; // Fecha o conjunto de dados
  end;

end;

procedure TfrmBxMultiplaCR.Pesquisar;
var
  LFiltro    : String;
  LOrdem     : String;
begin

  if Assigned(FQueryPesquisa) then
    FreeAndNil(FQueryPesquisa);

  FQueryPesquisa := TSFQuery.Create(nil);

  try
    //  Validações
    if dateInicial.Date > dateFinal.Date then
    begin
      dateFinal.SetFocus;
      Application.MessageBox('Data Inicial não pode ser maior que a data Final!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;

    if cbData.ItemIndex < 0 then
     begin
      cbData.SetFocus;
      Application.MessageBox('Selecione um tipo de DATA!', 'Atenção', MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;

    if Trim(edtCliente.Text) = '' then
    begin
      edtCliente.SetFocus;
      exit;
    end;

    LFiltro     := '';
    LOrdem      := '';

    //  Pesquisa por data
    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin
      case cbData.ItemIndex of
        0 : LFiltro := LFiltro + ' AND CR.DATA_VENDA BETWEEN :DTINI AND :DTFIM ';
        1 : LFiltro := LFiltro + ' AND CR.DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM ';
      end;
    end;

    //  Pesquisa parciais
    if checkParciais.Checked then
      LFiltro := LFiltro + ' AND CR.PARCIAL = ''S'' ';

    //  Pesquisa por Cliente
    if Trim(edtCliente.Text) <> '' then
      LFiltro := LFiltro + ' AND CR.ID_CLIENTE = :ID ';

    //  Ordem de pesquisa
    lOrdem := ' ORDER BY Cr.DATA_VENCIMENTO ';


    FQueryPesquisa.Close;
    FQueryPesquisa.SQL.Clear;
    FQueryPesquisa.SQL.Add(' SELECT CR.*, '''' SELECIONADO, CL.NOME FROM CONTAS_RECEBER CR           ');
    FQueryPesquisa.SQL.Add(' LEFT JOIN CLIENTES CL ON CR.ID_CLIENTE = CL.ID_CLI WHERE STATUS = ''A'' ');
    FQueryPesquisa.SQL.Add(LFiltro);
    FQueryPesquisa.SQL.Add(LOrdem);

    if (dateInicial.Checked) and (dateFinal.Checked) then
    begin
      FQueryPesquisa.ParamByName('DTINI').AsDateTime := dateInicial.Date;
      FQueryPesquisa.ParamByName('DTFIM').AsDateTime := dateFinal.Date;
    end;

    if Trim(edtCliente.Text) <> '' then
      FQueryPesquisa.ParamByName('ID').AsInteger := StrToInt(Trim(edtCliente.Text));

    FQueryPesquisa.Open;
    DBGrid1.DataSource.DataSet := FQueryPesquisa;

    //  Calcula a quantidade e valor
    CalcCrGrid;
    CalcQtdCrGrid;

    //  Coloca na primeira posição
    DBGrid1.DataSource.DataSet.First;
  except
    on e: Exception do
    begin
      Application.MessageBox(PWidechar('Erro ao realizar a consulta: ' +
        e.Message), 'Atenção', MB_OK + MB_ICONERROR);
    end;
  end;

end;

procedure TfrmBxMultiplaCR.SelAllReg(DBGrid: TDBGrid);
var
  i: Integer;

begin

  // Verifica se o DBGrid está conectado a um DataSource
  if Assigned(DBGrid.DataSource) and Assigned(DBGrid.DataSource.DataSet) then
  begin

    // Verifica se o data set esta aberto
    if DBGrid.DataSource.DataSet.Active then
    begin

      // Verifica se o conjunto de dados não está vazio
      if not DBGrid.DataSource.DataSet.IsEmpty then
      begin

        // Desativa controles de atualização para melhorar o desempenho
        DBGrid.DataSource.DataSet.DisableControls;

        //  Coloca na primeira posição
        DBGrid.DataSource.DataSet.first;

        try

          for i := 0 to DBGrid.DataSource.DataSet.RecordCount - 1 do
          begin

            if checkSelAll.Checked then
            begin

              // Marca a linha como selecionada
              DBGrid.SelectedRows.CurrentRowSelected := True;

            end
            else
            begin

              // Marca a linha como selecionada
              DBGrid.SelectedRows.CurrentRowSelected := False;

            end;

            DBGrid.DataSource.DataSet.Next;

          end;

        finally

          // Reativa controles
          DBGrid.DataSource.DataSet.EnableControls;

        end;

      end;

    end;

  end;

end;

end.
