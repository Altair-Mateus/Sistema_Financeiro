unit SistemaFinanceiro.Exceptions.ContasPagarDetalhe;

interface

uses
  System.SysUtils;

type
  ECpDetalheNaoExiste = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECpDetalheId = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECpDetalheExcluir = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ ECpDetalheExiste }

constructor ECpDetalheNaoExiste.Create(const pError: String);
begin
  inherited Create('Erro ao localizar detalhes do Contas a Pagar: ' + pError);
end;

{ ECpDetalheId }

constructor ECpDetalheId.Create(const pError: String);
begin
  inherited Create('Erro ao obter próximo ID de detalhes do Contas a Pagar: ' + pError);
end;

{ ECpDetalheExcluir }

constructor ECpDetalheExcluir.Create(const pError: String);
begin
  inherited Create('Erro ao excluir detalhes da conta a pagar: ' + pError);
end;

end.
