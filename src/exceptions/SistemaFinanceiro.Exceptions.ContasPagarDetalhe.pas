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

  ECpDetalheObter = class(Exception)
    constructor Create;
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
  inherited Create('Erro ao obter pr�ximo ID de detalhes do Contas a Pagar: ' + pError);
end;

{ ECpDetalheExcluir }

constructor ECpDetalheExcluir.Create(const pError: String);
begin
  inherited Create('Erro ao excluir detalhes da conta a pagar: ' + pError);
end;

{ ECpDetalheObter }

constructor ECpDetalheObter.Create;
begin
  inherited Create('Erro ao obter detalhes para realizar a baixa da conta.');
end;

end.
