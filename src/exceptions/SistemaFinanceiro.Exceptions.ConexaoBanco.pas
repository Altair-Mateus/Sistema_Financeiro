unit SistemaFinanceiro.Exceptions.ConexaoBanco;

interface

uses
  System.SysUtils;

type
  EConnectionCommit = class(Exception)
  public
    constructor Create(pError: String);
  end;

  EConnectionIni = class(Exception)
  public
    constructor Create;
  end;

  EConnectionOpen = class(Exception)
    constructor Create(pError: String);
  end;

  EConnectionClose = class(Exception)
    constructor Create(pError: String);
  end;

  EConnenctionNil = class(Exception)
    constructor Create;
  end;

implementation

{ EConnectionCommit }

constructor EConnectionCommit.Create(pError: String);
begin
  inherited Create('Erro ao Salvar registro no Banco de dados. Ser� feito o ROOLBACK nos dados. Erro: ' + pError);
end;

{ EConnectionIni }

constructor EConnectionIni.Create;
begin
  inherited Create('Arquivo INI do banco de dados n�o encontrado!');
end;

{ EConnectionOpen }

constructor EConnectionOpen.Create(pError: String);
begin
  inherited Create('Erro ao se conectar com o banco de dados: ' + pError);
end;

{ EConnecionClose }

constructor EConnectionClose.Create(pError: String);
begin
  inherited Create('Erro ao fechar conex�o com o banco de dados: ' + pError);
end;

{ EConnenctionNil }

constructor EConnenctionNil.Create;
begin
  inherited Create('Conex�o com o banco de dados passada inv�lida!');
end;

end.
