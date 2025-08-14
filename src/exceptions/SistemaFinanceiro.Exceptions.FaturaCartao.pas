unit SistemaFinanceiro.Exceptions.FaturaCartao;

interface

uses
  System.SysUtils;

type
  EFatCartaoId = class(Exception)
  public
    constructor Create(const pError: String);
  end;

implementation

{ EFatCartaoId }

constructor EFatCartaoId.Create(const pError: String);
begin
  inherited Create('Falha ao obter pr�ximo ID da Faturas de Cart�o: ' + pError);
end;

end.
