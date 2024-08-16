unit SistemaFinanceiro.View.Relatorios.LancamentoPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SistemaFinanceiro.View.RelatoriosPadrao,
  RLFilters, RLPDFFilter, Vcl.StdCtrls, RLReport, Data.DB;

type
  TfrmRelLancamentoPadrao = class(TfrmRelatorioPadrao)
    lblId: TRLLabel;
    lblDescricao: TRLLabel;
    lblStatus: TRLLabel;
    lblTipo: TRLLabel;
    txtDescricao: TRLDBText;
    txtTipo: TRLDBText;
    txtStatus: TRLDBText;
    dsLancPadrao: TDataSource;
    txtId: TRLDBText;
    procedure txtTipoBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure txtStatusBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
  private
    { Private declarations }
  public
    constructor Create(pOwner: TComponent; pDataSet : TDataSet); reintroduce;
  end;

var
  frmRelLancamentoPadrao: TfrmRelLancamentoPadrao;

implementation

{$R *.dfm}

uses
  uEnumsUtils,
  uEnumsUtilsDescription;

constructor TfrmRelLancamentoPadrao.Create(pOwner: TComponent;
  pDataSet: TDataSet);
begin
  inherited Create(pOwner);
  dsLancPadrao.DataSet := pDataSet;
end;

procedure TfrmRelLancamentoPadrao.txtStatusBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
var
  lStatus : TStatusCadastro;
begin
  if not Trim(AText).IsEmpty then
  begin
    lStatus := TStatusCadastro(dsLancPadrao.DataSet.FieldByName('STATUS').AsInteger);
    AText := TEnumsUtilsDescription.GetEnumDescription<TStatusCadastro>(lStatus);
  end;
end;

procedure TfrmRelLancamentoPadrao.txtTipoBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
var
  lTipo : TTipoLancamento;
begin
  if not Trim(AText).IsEmpty then
  begin
    lTipo := TTipoLancamento(dsLancPadrao.DataSet.FieldByName('TIPO').AsInteger);
    AText := TEnumsUtilsDescription.GetEnumDescription<TTipoLancamento>(lTipo);
  end;
end;

end.
