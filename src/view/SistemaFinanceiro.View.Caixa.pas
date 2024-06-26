unit SistemaFinanceiro.View.Caixa;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SistemaFinanceiro.View.CadastroPadrao,
  Data.DB, System.ImageList, Vcl.ImgList, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.WinXPanels, Vcl.ComCtrls, Vcl.Mask, Vcl.Imaging.pngimage, SistemaFinanceiro.Model.Entidades.ResumoCaixa,
  Vcl.Menus, SistemaFinanceiro.View.DetalhesOrigemCpCr,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa;
type
  TfrmCaixa = class(TfrmCadastroPadrao)
    DataSourceCaixa: TDataSource;
    lblNDoc: TLabel;
    edtNDoc: TEdit;
    lblDesc: TLabel;
    edtValor: TEdit;
    lblValor: TLabel;
    RadioGroup: TRadioGroup;
    DateTimePicker: TDateTimePicker;
    lblData: TLabel;
    lblReceita: TLabel;
    lblDespesa: TLabel;
    memDesc: TMemo;
    cbTipoLcto: TComboBox;
    lblTipo: TLabel;
    gbLegenda: TGroupBox;
    lblCorReceita: TLabel;
    lblCorDespesa: TLabel;
    pnlReceita: TPanel;
    pnlVencida: TPanel;
    lblDataFinal: TLabel;
    dateFinal: TDateTimePicker;
    dateInicial: TDateTimePicker;
    lblDataInicial: TLabel;
    gbFiltros: TGroupBox;
    rbData: TRadioButton;
    rbValor: TRadioButton;
    rbId: TRadioButton;
    imgCaixa: TImage;
    lblCaixa: TLabel;
    cbOrigem: TComboBox;
    lblOrigem: TLabel;
    lblTotalEntradas: TLabel;
    lblTotalSaidas: TLabel;
    lblVTotalEnt: TLabel;
    lblVTotalSai: TLabel;
    pnlValoresEntSai: TPanel;
    pnlTitTotEntSai: TPanel;
    lblOB: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PopupMenu1: TPopupMenu;
    DetalhesOrigemCpCr: TMenuItem;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnPesquisaeClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cbTipoLctoClick(Sender: TObject);
    procedure rbDataClick(Sender: TObject);
    procedure rbValorClick(Sender: TObject);
    procedure rbIdClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure cbOrigemClick(Sender: TObject);
    procedure dateInicialChange(Sender: TObject);
    procedure dateFinalChange(Sender: TObject);
    procedure edtPesquisarChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DetalhesOrigemCpCrClick(Sender: TObject);

  private
    { Private declarations }
    FResumoCaixa : TModelResumoCaixa;
    procedure ValidaCampos;
    procedure HabilitaBotoes;
    procedure EditarRegCaixa;
    procedure KeyPressValor(Sender: TObject; var Key: Char);
    procedure ExibeTelaDetalhesOrigem;


  public
    { Public declarations }

  protected
    procedure Pesquisar; override;

  end;
var
  frmCaixa: TfrmCaixa;

implementation
{$R *.dfm}
uses
  SistemaFinanceiro.Model.dmCaixa,
  SistemaFinanceiro.Utilitarios,
  SistemaFinanceiro.View.Principal,
  System.DateUtils, SistemaFinanceiro.View.Relatorios.Caixa;

procedure TfrmCaixa.btnAlterarClick(Sender: TObject);
begin

  inherited;
  EditarRegCaixa;

end;

procedure TfrmCaixa.btnCancelarClick(Sender: TObject);
begin

  inherited;
  //  Cancelando inclus�o
  dmCaixa.cdsCaixa.Cancel;

end;

procedure TfrmCaixa.btnExcluirClick(Sender: TObject);
var
  option : Word;

begin

  inherited;

  option := Application.MessageBox('Deseja excluir o lan�amento?', 'Confirma��o', MB_YESNO + MB_ICONQUESTION);

  if option = IDNO then
  begin
    exit;
  end;

  try
    //  Excluindo registro
    dmCaixa.cdsCaixa.Delete;
    dmCaixa.cdsCaixa.ApplyUpdates(0);

    //  Atualiza relatorio tela principal
    frmPrincipal.ResumoMensalCaixa;

  except on E : Exception do

    Application.MessageBox(PWidechar(E.Message), 'Erro ao excluir lan�amento do caixa', MB_OK + MB_ICONERROR);

  end;

end;

procedure TfrmCaixa.btnImprimirClick(Sender: TObject);
begin
  inherited;

  //  Cria o form
  frmRelCaixa := TfrmRelCaixa.Create(Self);

  try

    frmRelCaixa.DataSourceCaixa.DataSet := DataSourceCaixa.DataSet;

    frmRelCaixa.ResumoCaixa(FResumoCaixa);

    //  Exibe a pre visualizacao
    frmRelCaixa.RLReport.Preview();

  finally

    FreeAndNil(frmRelCaixa);

  end;

  Pesquisar;

end;

procedure TfrmCaixa.btnIncluirClick(Sender: TObject);
begin

  inherited;
  lblTitulo.Caption := 'Inserindo um novo Lan�amento no Caixa';

  if not (dmCaixa.cdsCaixa.State in [dsInsert, dsEdit]) then
  begin

    //  Colocando o data set em modo de inser��o de dados
    dmCaixa.cdsCaixa.Insert;

  end;

  //  Coloca a data atual no datetimepicker
  DateTimePicker.Date := now;

  edtNDoc.SetFocus;

end;

procedure TfrmCaixa.btnPesquisaeClick(Sender: TObject);
begin

  Pesquisar;
  inherited;

end;

procedure TfrmCaixa.btnSalvarClick(Sender: TObject);
begin

  //  Valida os campos obrigat�rios
  ValidaCampos;

  //  Passando os dados para o dataset
  dmCaixa.cdsCaixadata_cadastro.AsDateTime := DateTimePicker.Date;
  dmCaixa.cdsCaixavalor.AsFloat            := StrToFloat(Trim(edtValor.text));
  dmCaixa.cdsCaixanumero_doc.AsString      := Trim(edtNDoc.text);
  dmCaixa.cdsCaixadescricao.AsString       := Trim(memDesc.text);
  dmCaixa.cdsCaixaORIGEM.AsString          := 'CX';

  if RadioGroup.ItemIndex = 0 then
  begin
    dmCaixa.cdsCaixatipo.AsString := 'R';
  end
    else if RadioGroup.ItemIndex = 1 then
    begin
      dmCaixa.cdsCaixatipo.AsString := 'D';
    end;
  if dmCaixa.cdsCaixa.State in [dsInsert] then
  begin
    dmCaixa.GeraCodigo;
  end;

  //  Gravando no banco de dados
  dmCaixa.cdsCaixa.Post;
  dmCaixa.cdsCaixa.ApplyUpdates(0);

  //  Retorna ao cardPesquisa;
  CardPanelPrincipal.ActiveCard := CardPesquisa;

  //  Atualiza a lista
  Pesquisar;

  //  Atualiza relatorio tela principal
  frmPrincipal.ResumoMensalCaixa;
  inherited;
end;

procedure TfrmCaixa.cbOrigemClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.cbTipoLctoClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.dateFinalChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.dateInicialChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.DBGrid1DblClick(Sender: TObject);
begin

  inherited;
  EditarRegCaixa;

end;

procedure TfrmCaixa.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  //  Altera a cor das receitas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
     (DBGrid1.DataSource.DataSet.FieldByName('TIPO').AsString = 'R')then
  begin
    DBGrid1.Canvas.Font.Color := clHotLight;  // Define a cor do texto da c�lula
  end;

  //  Altera a cor das receitas
  if (not DBGrid1.DataSource.DataSet.IsEmpty) and
     (DBGrid1.DataSource.DataSet.FieldByName('TIPO').AsString = 'D')then
  begin
    DBGrid1.Canvas.Font.Color := $004F50FF;  // Define a cor do texto da c�lula
  end;

  // Desenha a c�lula com as propriedades de cor atualizadas
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  inherited;

end;

procedure TfrmCaixa.EditarRegCaixa;
begin

  //  Coloca o dataset em modo de edi��o
  dmCaixa.cdsCaixa.Edit;

  //  Coloca o numero do registro no titulo
  lblTitulo.Caption := 'Alterando lan�amento N� '+ dmCaixa.cdsCaixaid.AsString;

  //  Carrega os dados
  edtNDoc.Text        := dmCaixa.cdsCaixanumero_doc.AsString;
  memDesc.Text        := dmCaixa.cdsCaixadescricao.AsString;
  edtValor.Text       := TUtilitario.FormatarValor(dmCaixa.cdsCaixavalor.AsCurrency);
  DateTimePicker.Date := dmCaixa.cdsCaixadata_cadastro.AsDateTime;

  if dmCaixa.cdsCaixatipo.AsString = 'R' then
  begin
    RadioGroup.ItemIndex := 0;
  end
    else if dmCaixa.cdsCaixatipo.AsString = 'D' then
    begin
      RadioGroup.ItemIndex := 1;
    end;

end;

procedure TfrmCaixa.edtPesquisarChange(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.edtValorExit(Sender: TObject);
begin

  inherited;
  edtValor.Text := TUtilitario.FormatarValor(edtValor.Text);

end;

procedure TfrmCaixa.ExibeTelaDetalhesOrigem;
begin

  //  Cria o Form
  frmDetalhesOrigemCpCr := TfrmDetalhesOrigemCpCr.Create(Self);

  try

    frmDetalhesOrigemCpCr.CarregaDados(DataSourceCaixa.DataSet.FieldByName('ID_ORIGEM').AsInteger, DataSourceCaixa.DataSet.FieldByName('ORIGEM').AsString);

    //  Exibe o Form
    frmDetalhesOrigemCpCr.ShowModal;

  finally

    //  Libera da memoria
    FreeAndNil(frmDetalhesOrigemCpCr);

  end

end;

procedure TfrmCaixa.FormCreate(Sender: TObject);
begin

  inherited;
  edtValor.OnKeyPress := KeyPressValor;

  //  Define as datas
  dateInicial.Date := StartOfTheMonth(Now);
  dateFinal.Date   := EndOfTheMonth(Now);

end;

procedure TfrmCaixa.FormDestroy(Sender: TObject);
begin
  inherited;
  FResumoCaixa.Free;
end;

procedure TfrmCaixa.HabilitaBotoes;
begin

  btnAlterar.Enabled := not DataSourceCaixa.DataSet.IsEmpty;
  btnExcluir.Enabled := not DataSourceCaixa.DataSet.IsEmpty;
  btnImprimir.Enabled := not DataSourceCaixa.DataSet.IsEmpty;

end;

procedure TfrmCaixa.KeyPressValor(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    //  Verifica se a tecla pressionada � o Enter
    //  Cancela o efeito do enter
    Key := #0;
    //  Pula para o proximo
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  //  Se for digitado um ponto, ser� convertido para virgula
  if Key = FormatSettings.ThousandSeparator then
   begin
      Key := #0;
    end;

  // Permite apenas digitar os caracteres dentro do charinset
  if not (CharInSet(Key, ['0'..'9', FormatSettings.DecimalSeparator, #8, #13])) then
  begin
    Key := #0;
  end;

  // Valida se j� existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

procedure TfrmCaixa.Pesquisar;
var
  LFiltroEdit : String;
  LFiltro     : String;
  LOrdem      : String;

begin

  //  Valida��es
  if dateInicial.Date > dateFinal.Date then
  begin

    dateFinal.SetFocus;
    Application.MessageBox('Data Inicial n�o pode ser maior que a data Final!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    exit;

  end;

  if cbTipoLcto.ItemIndex < 0 then
  begin

    cbTipoLcto.SetFocus;
    Application.MessageBox('Selecione um tipo de Lan�amento!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    exit;

  end;

  LFiltroEdit := TUtilitario.LikeFind(edtPesquisar.Text, DBGrid1);
  LFiltro := '';
  LOrdem := '';

  dmCaixa.cdsCaixa.Params.Clear;

  //  Pesquisa por tipo de lcto
  case cbTipoLcto.ItemIndex of
    1 : LFiltro := LFiltro + ' AND TIPO = ''R'' ';
    2 : LFiltro := LFiltro + ' AND TIPO = ''D'' ';
  end;

  //  Pesquisa por origem
  case cbOrigem.ItemIndex of

    1 : LFiltro := LFiltro + ' AND ORIGEM = ''CR'' ';
    2 : LFiltro := LFiltro + ' AND ORIGEM = ''CP'' ';
    3 : LFiltro := LFiltro + ' AND ORIGEM = ''CX'' ';

  end;

  //  Pesquisa por data
  if (dateInicial.Checked) and (dateFinal.Checked) then
  begin

    LFiltro := LFiltro + ' AND DATA_CADASTRO BETWEEN :DTINI AND :DTFIM ';

    //  Criando os parametros
    dmCaixa.cdsCaixa.Params.CreateParam(TFieldType.ftDate, 'DTINI', TParamType.ptInput);
    dmCaixa.cdsCaixa.ParamByName('DTINI').AsDate := dateInicial.Date;

    dmCaixa.cdsCaixa.Params.CreateParam(TFieldType.ftDate, 'DTFIM', TParamType.ptInput);
    dmCaixa.cdsCaixa.ParamByName('DTFIM').AsDate := dateFinal.Date;

  end;

  //  Ordem de pesquisa
  if rbId.Checked then
  begin
    LOrdem := ' ORDER BY ID DESC';
  end
    else if rbData.Checked then
    begin
      LOrdem := ' ORDER BY DATA_CADASTRO DESC';
    end
      else if rbValor.Checked then
      begin
        LOrdem := ' ORDER BY VALOR DESC';
      end
        else
        begin
          LOrdem := ' ORDER BY ID DESC';
        end;


  dmCaixa.cdsCaixa.Close;
  dmCaixa.cdsCaixa.CommandText := 'SELECT * FROM CAIXA WHERE 1 = 1' + LFiltroEdit + LFiltro + LOrdem;
  dmCaixa.cdsCaixa.Open;

  if Assigned(FResumoCaixa) then
    FResumoCaixa.Free;

  //  Atualiza valores de entrada e saida
  FResumoCaixa := TModelLancamentoCaixa.ResumoCaixa(dateInicial.Date, dateFinal.Date);

  lblVTotalEnt.Caption := TUtilitario.FormatoMoeda(FResumoCaixa.TotalEntradas);
  lblVTotalSai.Caption := TUtilitario.FormatoMoeda(FResumoCaixa.TotalSaidas);


  HabilitaBotoes;
  inherited;


end;
procedure TfrmCaixa.rbDataClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.rbIdClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.rbValorClick(Sender: TObject);
begin
  inherited;

  Pesquisar;

end;

procedure TfrmCaixa.ValidaCampos;
begin

  if Trim(memDesc.Text) = '' then
  begin
    Application.MessageBox('Campo Descri��o n�o pode estar vazio!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    memDesc.SetFocus;
    abort;
  end;

  if Trim(edtValor.Text) = '' then
  begin
    Application.MessageBox('Campo Valor n�o pode estar vazio!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    edtValor.SetFocus;
    abort;
  end;
  if RadioGroup.ItemIndex = -1 then
  begin
    Application.MessageBox('Selecione o tipo do lan�amento!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;
  end;

end;
procedure TfrmCaixa.DetalhesOrigemCpCrClick(Sender: TObject);
begin

  if DataSourceCaixa.DataSet.FieldByName('ORIGEM').AsString = 'CX' then
  begin

    Application.MessageBox('Conta Inserida manualmente no Caixa!', 'Aten��o', MB_OK + MB_ICONEXCLAMATION);
    abort;

  end;


  ExibeTelaDetalhesOrigem;

end;

end.
