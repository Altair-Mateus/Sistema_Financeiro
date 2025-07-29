unit SistemaFinanceiro.Model.uSFQuery;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  System.Classes;

type
  TSFQuery = class(TFDQuery)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  uDbConfig;

constructor TSFQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Connection := TDbConfig.Connection;
end;

end.
