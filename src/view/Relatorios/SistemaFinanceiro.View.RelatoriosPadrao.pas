unit SistemaFinanceiro.View.RelatoriosPadrao;

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
  RLReport,
  RLFilters,
  RLPDFFilter,
  Vcl.StdCtrls, RLXLSXFilter;

type
  TfrmRelatorioPadrao = class(TForm)
    RLReport: TRLReport;
    rlbCab: TRLBand;
    rllblNomeEmp: TRLLabel;
    rlbTitulo: TRLBand;
    rllblTitulo: TRLLabel;
    rlbNomeColunas: TRLBand;
    rlbDados: TRLBand;
    rlbRodape: TRLBand;
    rlsiData: TRLSystemInfo;
    rlsiHora: TRLSystemInfo;
    rlsiNumPag: TRLSystemInfo;
    rlsiLastPage: TRLSystemInfo;
    rllblNomeUser: TRLLabel;
    RLPDFFilter: TRLPDFFilter;
    bndFiltros: TRLBand;
    lblFiltros: TLabel;
    RLXLSXFilter: TRLXLSXFilter;
    procedure RLReportBeforePrint(Sender: TObject;
      var PrintIt: Boolean);
    procedure rlbDadosBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    FTracoLinha: Boolean;
    FDestacaLinha: Boolean;
    FHeightDetalhe: Integer;
    FFiltros: String;
    FExibirFiltros: Boolean;
  public
    property TracoLinha: Boolean read FTracoLinha write FTracoLinha;
    property DestacaLinha: Boolean read FDestacaLinha write FDestacaLinha;
    property HeightDetalhe: Integer read FHeightDetalhe write FHeightDetalhe;
    property Filtros: String read FFiltros write FFiltros;
    property ExibirFiltros: Boolean read FExibirFiltros write FExibirFiltros;
  end;

var
  frmRelatorioPadrao: TfrmRelatorioPadrao;

implementation

{$R *.dfm}


uses
  SistemaFinanceiro.Model.dmUsuarios;

procedure TfrmRelatorioPadrao.rlbDadosBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin

  // Ajusta o tamanho
  if FHeightDetalhe > 0 then
    rlbDados.Height := FHeightDetalhe;

  // Desenha a linha
  if FTracoLinha then
  begin

    rlbDados.Borders.DrawBottom := True;
    rlbDados.Borders.Width := 1;

  end;

  if FDestacaLinha then
  begin

    if rlbDados.Tag = 0 then
    begin
      rlbDados.Tag := 1;
      rlbDados.Color := $00EAEAEA;
    end
    else
    begin
      rlbDados.Tag := 0;
      rlbDados.Color := clWhite;
    end;

  end;

end;

procedure TfrmRelatorioPadrao.RLReportBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin

  rllblNomeUser.Caption := Format('Impresso por %s', [dmUsuarios.GetUsuarioLogado.Nome]);

  bndFiltros.Visible := FExibirFiltros;
  lblFiltros.Caption := 'Filtros: ' + FFiltros;

end;

end.
