unit uDBConnectorFB;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Phys.FB,
  uDbConfig, Vcl.Forms;

type
  TDBConnectorFB = class
  private const
    ARQUIVOCONFIGURACAO = 'ConfigBanco.ini';
  public
    class procedure Connect;
  end;

implementation

{ TDBConnectorFB }

uses SistemaFinanceiro.Exceptions.ConexaoBanco;

class procedure TDBConnectorFB.Connect;
var
  lConexao: TFDConnection;
  lCaminhobanco: String;
begin

  lConexao := TFDConnection.Create(nil);
  try

    lCaminhobanco := ExtractFilePath(Application.ExeName) +
        'dados\SISTEMAFINANCEIRO.FDB';

    if FileExists(ARQUIVOCONFIGURACAO) then
    begin
      lConexao.Params.LoadFromFile(ARQUIVOCONFIGURACAO);
    end
    else
    begin
      lConexao.Params.Database := lCaminhobanco;
      lConexao.Params.SaveToFile(ARQUIVOCONFIGURACAO);
    end;

    lConexao.Connected := True;

    TDbConfig.InitConnection(lConexao);

  except
    on E: Exception do
    begin
      raise EConnectionOpen.Create(E.Message);
    end;
  end;

end;

end.
