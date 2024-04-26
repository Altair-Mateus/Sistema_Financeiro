unit SistemaFinanceiro.View.Cadastro.LancamentoPadraoContas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.WinXCtrls, System.ImageList, Vcl.ImgList;

type
  TfrmCadLancamentoPadrao = class(TForm)
    pnlContainer: TPanel;
    PanelCampos: TPanel;
    lblDescricao: TLabel;
    PanelTitulo: TPanel;
    lblTitulo: TLabel;
    pnlBotoesCad: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    ImageList1: TImageList;
    edtDescricao: TMemo;
    rdgTipo: TRadioGroup;
    ImageList16x16: TImageList;
    pnlIdCliFornec: TPanel;
    lblIdCliFornec: TLabel;
    edtIdCliFornec: TEdit;
    btnPesquisar: TButton;
    gbDadosCad: TGroupBox;
    lblDt: TLabel;
    lblDtAlt: TLabel;
    edtDtAlt: TEdit;
    edtDtCad: TEdit;
    LabelStatus: TLabel;
    ToggleStatus: TToggleSwitch;
    procedure FormShow(Sender: TObject);
    procedure rdgTipoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadLancamentoPadrao: TfrmCadLancamentoPadrao;

implementation

{$R *.dfm}

uses SistemaFinanceiro.Model.Entidades.LancamentoPadraoContas;

procedure TfrmCadLancamentoPadrao.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadLancamentoPadrao.btnSalvarClick(Sender: TObject);
var
  lLancamentoPadrao : TModelLancamentoPadrao;

begin

  try

    lLancamentoPadrao := TModelLancamentoPadrao.Create;
    try

      lLancamentoPadrao.Data_Cadastro := StrToDateTime(Trim(edtDtCad.Text));
      lLancamentoPadrao.Descricao := Trim(edtDescricao.Text);

      case rdgTipo.ItemIndex of

        0 :
        begin
          lLancamentoPadrao.Id_Fornecedor := StrToInt(edtIdCliFornec.Text);
          lLancamentoPadrao.Tipo := 'CP';
        end;

        1 :
        begin
          lLancamentoPadrao.Id_Cliente := StrToInt(edtIdCliFornec.Text);
          lLancamentoPadrao.Tipo := 'CR';
        end;

      end;

      if ToggleStatus.State = tssOn then
        lLancamentoPadrao.Status := 'A'
      else
        lLancamentoPadrao.Status := 'I';

      if lLancamentoPadrao.Insert then
        Application.MessageBox('Registro Salvo com Sucesso!', 'Informação', MB_OK + MB_ICONINFORMATION);

    finally
      lLancamentoPadrao.Free;
    end;

  except
    on E: Exception do
    begin
//      Application.MessageBox('Somente Administradores podem redefinir a senha!', 'Erro: ' + E.Message, MB_OK + MB_ICONERROR);
    end;
  end;

end;

procedure TfrmCadLancamentoPadrao.FormShow(Sender: TObject);
begin


  edtDtCad.Text := DateTimeToStr(Now);
  ToggleStatus.State := tssOn;

end;

procedure TfrmCadLancamentoPadrao.rdgTipoClick(Sender: TObject);
begin

  //  Libera para informar cliente ou fornecedor
  edtIdCliFornec.Enabled;
  btnPesquisar.Enabled;

end;

end.
