unit SistemaFinanceiro.Exceptions.PgtoBaixaCp;

interface

uses
  System.SysUtils;

type
  EPgtoCpNaoExiste = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  EPgtoCpExcluir = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECpObterPgtos = class(Exception)
  public
    constructor Create;
  end;

  EPgtoCpGravar = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ EPgtoCpNaoExiste }

constructor EPgtoCpNaoExiste.Create(const pError: String);
begin
  inherited Create('Falha ao localizar pagamento da conta a pagar: ' + pError);
end;

{ EPgtoCpExcluir }

constructor EPgtoCpExcluir.Create(const pError: String);
begin
  inherited Create('Falha ao excluir pagamentos da baixa: ' + pError);
end;

{ ECpObterPgtos }

constructor ECpObterPgtos.Create;
begin
  inherited Create('Falha ao obter pagamentos para realizar a baixa da conta.');
end;

{ EPgtoCpGravar }

constructor EPgtoCpGravar.Create(const pError: String);
begin
  inherited Create('Falha ao salvar pagamentos da baixa da CP: ' + pError);
end;

end.
