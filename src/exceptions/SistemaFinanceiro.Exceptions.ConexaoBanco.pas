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
  inherited Create('Erro ao Salvar registro no Banco de dados. Será feito o ROOLBACK nos dados. Erro: ' + pError);
end;

{ EConnectionIni }

constructor EConnectionIni.Create;
begin
  inherited Create('Arquivo INI do banco de dados não encontrado!');
end;

{ EConnectionOpen }

constructor EConnectionOpen.Create(pError: String);
begin
  inherited Create('Erro ao se conectar com o banco de dados: ' + pError);
end;

{ EConnecionClose }

constructor EConnectionClose.Create(pError: String);
begin
  inherited Create('Erro ao fechar conexão com o banco de dados: ' + pError);
end;

{ EConnenctionNil }

constructor EConnenctionNil.Create;
begin
  inherited Create('Conexão com o banco de dados passada inválida!');
end;

end.
