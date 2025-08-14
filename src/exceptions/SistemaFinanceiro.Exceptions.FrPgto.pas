unit SistemaFinanceiro.Exceptions.FrPgto;

interface

uses
  System.SysUtils;

type

  EFrPgtoNaoExiste = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  EFrPgtoExcluir = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  EFrPgtoGravar = class(Exception)
  public
    constructor Create(const pError: String);
  end;

  EFrPgtoId = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ EFrPgtoNaoExiste }

constructor EFrPgtoNaoExiste.Create(const pError: String);
begin
  inherited Create('Falha ao localizar a forma de pagamento: ' + pError);
end;

{ EFrPgtoExcluir }

constructor EFrPgtoExcluir.Create(const pError: String);
begin
  inherited Create('Falha ao excluir a forma de pagamento: ' + pError);
end;

{ EFrPgtoGravar }

constructor EFrPgtoGravar.Create(const pError: String);
begin
  inherited Create('Falha ao salvar a forma de pagamento: ' + pError);
end;

{ EFrPgtoId }

constructor EFrPgtoId.Create(const pError: String);
begin
  inherited Create('Falha ao obter próximo ID da forma de pagamento: ' + pError);
end;

end.
