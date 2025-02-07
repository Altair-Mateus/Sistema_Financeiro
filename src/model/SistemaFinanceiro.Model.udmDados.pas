unit SistemaFinanceiro.Model.udmDados;

interface

uses
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  Vcl.Forms,
  uDaoRTTI,
  System.SysUtils;

type
  TDataModule1 = class(TDataModule)
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);

  private
    const
    ARQUIVOCONFIGURACAO = 'ConfigBanco.ini';

  public
    function ConectarBd: Boolean;
    function DesconectarBd: Boolean;
    procedure BuscaArquivoIni;

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}
{
  Após migrar todos os CRUDs para classes e objetos, deve ser
  migrado o datamodule principal
}

uses
  SistemaFinanceiro.Exceptions.ConexaoBanco;

{ TDataModule1 }

function TDataModule1.ConectarBd: Boolean;
begin
  Result := False;

  try
    if not(FDConnection.Connected) then
      FDConnection.Open;

    Result := True;
  except
    on E: Exception do
    begin
      raise EConnectionOpen.Create(E.Message);
    end;
  end;

end;

procedure TDataModule1.BuscaArquivoIni;
begin

  if FileExists(ARQUIVOCONFIGURACAO) then
  begin
    FDConnection.Params.LoadFromFile(ARQUIVOCONFIGURACAO);
  end
  else
  begin
    FDConnection.Params.Database := ExtractFilePath(Application.ExeName) + 'dados\SISTEMAFINANCEIRO.FDB';
    FDConnection.Params.SaveToFile(ARQUIVOCONFIGURACAO);
  end;

end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  BuscaArquivoIni;
  ConectarBd;
  TDaoRTTI.Connection := FDConnection;
end;

function TDataModule1.DesconectarBd: Boolean;
begin
  Result := False;

  try

    if (FDConnection.Connected) then
      FDConnection.Close;

    Result := True;

  except
    on E: Exception do
    begin
      raise EConnectionClose.Create(E.Message);
    end;
  end;
end;

end.
