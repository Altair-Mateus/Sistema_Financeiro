unit uContasPagarDetalheExceptions;

interface

uses
  System.SysUtils;

type
  ECpDetalheExiste = class(Exception)
    public
      constructor Create(const pError: String);
  end;

  ECpDetalheId = class(Exception)
    public
      constructor Create(const pError: String);
  end;

implementation

{ ECpDetalheExiste }

constructor ECpDetalheExiste.Create(const pError: String);
begin
  inherited Create('Erro ao localizar detalhes do Contas a Pagar: ' + pError);
end;

{ ECpDetalheId }

constructor ECpDetalheId.Create(const pError: String);
begin
  inherited Create('Erro ao obter próximo ID de detalhes do Contas a Pagar: ' + pError);
end;

end.
