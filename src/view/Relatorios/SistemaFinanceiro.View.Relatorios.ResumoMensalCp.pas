unit SistemaFinanceiro.View.Relatorios.ResumoMensalCp;

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
  SistemaFinanceiro.View.RelatoriosPadrao,
  RLFilters,
  RLPDFFilter,
  RLReport,
  Data.DB,
  RLXLSFilter,
  SistemaFinanceiro.Model.uSFQuery,
  Vcl.StdCtrls,
  RLXLSXFilter,
  uEnumsUtils;

type
  TfrmRelMensalCp = class(TfrmRelatorioPadrao)
    dsRelResumoMensal: TDataSource;
    rllblValorTot: TRLLabel;
    rllblAnoMes: TRLLabel;
    rldbtMesAno: TRLDBText;
    rldbtValorTotal: TRLDBText;
    rllblQtd: TRLLabel;
    rldbtQtd: TRLDBText;
    RLBand1: TRLBand;
    rllblTotal: TRLLabel;
    rllblQuantidade: TRLLabel;
    rllblFatCartao: TRLLabel;
    rldbtFatCartao: TRLDBText;
    procedure RLReportBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbDadosBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FQuery: TSFQuery;
    FCodFornecedor: String;
    FCodFaturaCartao: String;
    FVencidas: Boolean;
    FAgruparFatura: Boolean;
    FConsidDtCompra: Boolean;
    FConsidDtVcto: Boolean;
    FStatusCp: TStatusConta;
    FSomenteParciais: Boolean;
    FFiltrarFatCartao: Boolean;
    FDtInicial: TDate;
    FDtFinal: TDate;

    procedure CalculaTotais;

  public
    property CodFornecedor: String read FCodFornecedor write FCodFornecedor;
    property CodFaturaCartao: String read FCodFaturaCartao write FCodFaturaCartao;
    property Vencidas: Boolean read FVencidas write FVencidas;
    property AgruparFatura: Boolean read FAgruparFatura write FAgruparFatura;
    property ConsidDtCompra: Boolean read FConsidDtCompra write FConsidDtCompra;
    property ConsidDtVcto: Boolean read FConsidDtVcto write FConsidDtVcto;
    property StatusCp: TStatusConta read FStatusCp write FStatusCp;
    property SomenteParciais: Boolean read FSomenteParciais write FSomenteParciais;
    property FiltrarFatCartao: Boolean read FFiltrarFatCartao write FFiltrarFatCartao;
    property DtInicial: TDate read FDtInicial write FDtInicial;
    property DtFinal: TDate read FDtFinal write FDtFinal;

    procedure Pesquisar;
  end;

var
  frmRelMensalCp: TfrmRelMensalCp;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Utilitarios;

procedure TfrmRelMensalCp.CalculaTotais;
var
  lSoma: Currency;
  lQtd: Integer;
begin
  lSoma := 0;
  lQtd := 0;

  // Posiciona no primeiro dado do dataset
  dsRelResumoMensal.DataSet.First;

  // Soma ate o ultimo registro
  while not dsRelResumoMensal.DataSet.Eof do
  begin

    lSoma := lSoma + dsRelResumoMensal.DataSet.FieldByName('TOTAL_MENSAL').AsCurrency;
    lQtd := lQtd + dsRelResumoMensal.DataSet.FieldByName('QTD').AsInteger;

    // avança para o proximi
    dsRelResumoMensal.DataSet.Next;

  end;

  // Exibe a soma
  rllblTotal.Caption := 'Total: ' + TUtilitario.FormatoMoeda(lSoma);

  // Conta a quantidade de contas
  rllblQuantidade.Caption := 'Total de Contas: ' + IntToStr(lQtd);
end;

procedure TfrmRelMensalCp.FormCreate(Sender: TObject);
begin
  inherited;
  FQuery := TSFQuery.Create(nil);
end;

procedure TfrmRelMensalCp.FormDestroy(Sender: TObject);
begin
  inherited;
  FQuery.Free;
end;

procedure TfrmRelMensalCp.Pesquisar;
var
  SQL: String;
  LFiltro: String;
  LExtract: String;
  LSelectExtract: String;
  LOrdem: String;
  LJoin: String;
begin

  LFiltro := '';
  SQL := '';
  LExtract := '';
  LSelectExtract := '';
  LOrdem := '';
  LJoin := '';

  FQuery.Close;
  FQuery.SQL.Clear;

  // Agrupa por Fatura
  if (FAgruparFatura) then
  begin
    LSelectExtract := LSelectExtract + ' FT.NOME AS FATURA, ';
    LJoin := LJoin + ' INNER JOIN FATURA_CARTAO FT ON CP.ID_FATURA = FT.ID_FT ';
    LExtract := LExtract + ' CP.ID_FATURA, FT.NOME, ';
    LOrdem := LOrdem + ' CP.ID_FATURA, ';
  end;

  // Pesquisa por data
  if (FConsidDtCompra) then
  begin

    LFiltro := LFiltro + ' AND CP.DATA_COMPRA BETWEEN :DTINI AND :DTFIM ';
    LExtract := LExtract + ' EXTRACT(MONTH FROM CP.DATA_COMPRA), EXTRACT(YEAR FROM CP.DATA_COMPRA) ';
    LSelectExtract := LSelectExtract +
      ' EXTRACT(MONTH FROM CP.DATA_COMPRA) || ''/'' || EXTRACT(YEAR FROM CP.DATA_COMPRA) AS ano_mes ';
    LOrdem := LOrdem + ' EXTRACT(YEAR FROM CP.DATA_COMPRA), EXTRACT(MONTH FROM CP.DATA_COMPRA) ';

  end
  else if (FConsidDtVcto) then
  begin

    LFiltro := LFiltro + ' AND CP.DATA_VENCIMENTO BETWEEN :DTINI AND :DTFIM ';
    LExtract := LExtract + ' EXTRACT(MONTH FROM CP.DATA_VENCIMENTO), EXTRACT(YEAR FROM CP.DATA_VENCIMENTO) ';
    LSelectExtract := LSelectExtract +
      ' EXTRACT(MONTH FROM CP.DATA_VENCIMENTO) || ''/'' || EXTRACT(YEAR FROM CP.DATA_VENCIMENTO) AS ano_mes ';
    LOrdem := LOrdem + ' EXTRACT(YEAR FROM CP.DATA_VENCIMENTO), EXTRACT(MONTH FROM CP.DATA_VENCIMENTO) ';

  end
  else
  begin

    LFiltro := LFiltro + ' AND CP.DATA_PAGAMENTO BETWEEN :DTINI AND :DTFIM ';
    LExtract := LExtract + ' EXTRACT(MONTH FROM CP.DATA_PAGAMENTO), EXTRACT(YEAR FROM CP.DATA_PAGAMENTO) ';
    LSelectExtract := LSelectExtract +
      ' EXTRACT(MONTH FROM CP.DATA_PAGAMENTO) || ''/'' || EXTRACT(YEAR FROM CP.DATA_PAGAMENTO) AS ano_mes ';
    LOrdem := LOrdem + ' EXTRACT(YEAR FROM CP.DATA_PAGAMENTO), EXTRACT(MONTH FROM CP.DATA_PAGAMENTO) ';

  end;

  case FStatusCp of
    sctPaga:
      LFiltro := LFiltro + ' AND CP.STATUS = ''P'' ';
    sctAberta:
      LFiltro := LFiltro + ' AND CP.STATUS = ''A'' ';
    sctCancelada:
      LFiltro := LFiltro + ' AND CP.STATUS = ''C'' ';
  end;

  // Pesquisa por FORNECEDORES
  if not(Trim(FCodFornecedor).IsEmpty) then
    LFiltro := LFiltro + ' AND CP.ID_FORNECEDOR = :ID_FORNEC ';

  // Pesquisa por Fatura de Cartao
  if not(Trim(FCodFaturaCartao).IsEmpty) then
    LFiltro := LFiltro + ' AND CP.ID_FATURA = :ID_FT ';

  // Pesquisa parciais
  if (FSomenteParciais) then
    LFiltro := LFiltro + ' AND CP.PARCIAL = ''S'' ';

  // Pesquisa vencidas
  if (FVencidas) then
    LFiltro := LFiltro + ' AND CP.STATUS = ''A'' AND CP.DATA_VENCIMENTO < :DTATUAL ';

  // Não considera faturas
  if not(FFiltrarFatCartao) then
    LFiltro := LFiltro + ' AND FATURA_CART = ''N'' ';

  SQL := 'SELECT ' + LSelectExtract + ', SUM(VALOR_PARCELA) AS TOTAL_MENSAL, ' +
    ' COUNT(*) AS QTD FROM CONTAS_PAGAR CP ' + LJoin + ' WHERE 1 = 1 ' + LFiltro +
    'GROUP BY ' + LExtract +
    'ORDER BY ' + LOrdem;

  FQuery.SQL.Text := SQL;

  // Criando os parametros
  FQuery.ParamByName('DTINI').AsDate := FDtInicial;
  FQuery.ParamByName('DTFIM').AsDate := FDtFinal;

  if not(Trim(FCodFornecedor).IsEmpty) then
    FQuery.ParamByName('ID_FORNEC').AsInteger := StrToIntDef(Trim(FCodFornecedor), 0);

  if not(Trim(FCodFaturaCartao).IsEmpty) then
    FQuery.ParamByName('ID_FT').AsInteger := StrToIntDef(Trim(FCodFaturaCartao), 0);

  if (FVencidas) then
    FQuery.ParamByName('DTATUAL').AsDate := Now;

  FQuery.Open;

  dsRelResumoMensal.DataSet := FQuery;
end;

procedure TfrmRelMensalCp.rlbDadosBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;

  rllblFatCartao.Visible := FAgruparFatura;
  rldbtFatCartao.Visible := FAgruparFatura;

end;

procedure TfrmRelMensalCp.RLReportBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;
  Pesquisar;
  CalculaTotais;

end;

end.
