unit uDBConnectorFB;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Phys.FB,
  uDbConfig,
  Vcl.Forms;

type
  TDBConnectorFB = class
  private
    class var FConnection: TFDConnection;

  const
    ARQUIVOCONFIGURACAO = 'ConfigBanco.ini';
  public
    class procedure Connect;
  end;

implementation

{ TDBConnectorFB }

uses
  SistemaFinanceiro.Exceptions.ConexaoBanco;

class procedure TDBConnectorFB.Connect;
var
  lCaminhobanco: String;
begin

  if (Assigned(FConnection)) then
    FreeAndNil(FConnection);

  FConnection := TFDConnection.Create(nil);
  try

    lCaminhobanco := ExtractFilePath(Application.ExeName) +
      'dados\SISTEMAFINANCEIRO.FDB';

    if FileExists(ARQUIVOCONFIGURACAO) then
    begin
      FConnection.Params.LoadFromFile(ARQUIVOCONFIGURACAO);
    end
    else
    begin
      FConnection.Params.Database := lCaminhobanco;
      FConnection.Params.SaveToFile(ARQUIVOCONFIGURACAO);
    end;

    FConnection.Connected := True;

    TDbConfig.InitConnection(FConnection);

  except
    on E: Exception do
    begin
      raise EConnectionOpen.Create(E.Message);
    end;
  end;

end;

end.
