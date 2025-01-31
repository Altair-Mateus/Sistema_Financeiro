unit SistemaFinanceiro.Exceptions.ContasPagar;

interface

uses
  System.SysUtils;

type
  ECPagarId = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECPagarTotal = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECpagarIdGrupoParcelas = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECPagarNaoExiste = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  ECpagarAlterar = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ ECPagarId }

constructor ECPagarId.Create(const pError: String);
begin
  inherited Create('Erro ao obter próximo ID do Contas a Pagar: ' + pError);
end;

{ ECPagarTotal }

constructor ECPagarTotal.Create(const pError: String);
begin
  inherited Create('Erro ao obter valor total do Contas a Pagar: ' + pError);
end;

{ ECpagarIdGrupoParcelas }

constructor ECpagarIdGrupoParcelas.Create(const pError: String);
begin
  inherited Create('Erro ao obter próximo ID de grupo de parcelas do Contas a Pagar: ' + pError);
end;

{ ECPagarNaoExiste }

constructor ECPagarNaoExiste.Create(const pError: String);
begin
  inherited Create('Erro ao localizar a Conta a Pagar: ' + pError);
end;

{ ECpagarAlterar }

constructor ECpagarAlterar.Create(const pError: String);
begin
  inherited Create('Erro ao alterar a Conta a Pagar: ' + pError);
end;

end.
