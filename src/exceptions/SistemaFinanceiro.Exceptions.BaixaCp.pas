unit SistemaFinanceiro.Exceptions.BaixaCp;

interface

uses
  System.SysUtils;

type
  EBaixaCPExiste = class(Exception)
    public
      constructor Create(const pError: String);
  end;

  EBaixaCpId = class(Exception)
    public
      constructor Create(const pError: String);
  end;

implementation

{ EBaixaCPExiste }

constructor EBaixaCPExiste.Create(const pError: String);
begin
  inherited Create('Erro ao localizar dados da baixa do Contas a Pagar: ' + pError);
end;

{ EBaixaCpId }

constructor EBaixaCpId.Create(const pError: String);
begin
  inherited Create('Erro ao obter próximo ID  da baixa do Contas a Pagar: ' + pError);
end;

end.
