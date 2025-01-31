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

implementation

{ EPgtoCpNaoExiste }

constructor EPgtoCpNaoExiste.Create(const pError: String);
begin
  inherited Create('Erro ao localizar pagamento da conta a pagar: ' + pError);
end;

{ EPgtoCpExcluir }

constructor EPgtoCpExcluir.Create(const pError: String);
begin
  inherited Create('Erro ao excluir pagamentos da baixa: ' + pError);
end;

end.
