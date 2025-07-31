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

  ECpObterDetalhe = class(Exception)
  public
    constructor Create;
  end;

  ECpDetalheGravar = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ ECpDetalheExiste }

constructor ECpDetalheNaoExiste.Create(const pError: String);
begin
  inherited Create('Falha ao localizar detalhes do Contas a Pagar: ' + pError);
end;

{ ECpDetalheId }

constructor ECpDetalheId.Create(const pError: String);
begin
  inherited Create('Falha ao obter próximo ID de detalhes do Contas a Pagar: ' + pError);
end;

{ ECpDetalheExcluir }

constructor ECpDetalheExcluir.Create(const pError: String);
begin
  inherited Create('Falha ao excluir detalhes da conta a pagar: ' + pError);
end;

{ ECpDetalheObter }

constructor ECpObterDetalhe.Create;
begin
  inherited Create('Falha ao obter detalhes para realizar a baixa da conta.');
end;

{ ECpDetalheGravar }

constructor ECpDetalheGravar.Create(const pError: String);
begin
  inherited Create('Falha ao salvar os detalhes da baixa da CP: ' + pError);
end;

end.
