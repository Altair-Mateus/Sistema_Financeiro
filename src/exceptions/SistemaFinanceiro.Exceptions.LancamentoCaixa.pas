unit SistemaFinanceiro.Exceptions.LancamentoCaixa;

interface

uses
  System.SysUtils;

type

  ELancCaixaNaoExiste = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ELancCaixaExcluir = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ ELancCaixaNaoExiste }

constructor ELancCaixaNaoExiste.Create(const pError: String);
begin
  inherited Create('Erro ao localizar o lançamento do caixa: ' + pError);
end;

{ ELancCaixaExcluir }

constructor ELancCaixaExcluir.Create(const pError: String);
begin
  inherited Create('Erro ao excluir o lançamento do caixa: ' + pError);
end;

end.
