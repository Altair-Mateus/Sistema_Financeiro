unit SistemaFinanceiro.Model.uSFQuery;

interface

uses
   FireDAC.Comp.Client, FireDAC.Stan.Def, SistemaFinanceiro.Model.udmDados,
  System.Classes;

type
  TSFQuery = class(TFDQuery)
  private
    FDataModule : TDataModule1;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TQuery }

constructor TSFQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDataModule := DataModule1;

  if Assigned(FDataModule) then
    Self.Connection := FDataModule.FDConnection;

end;

end.
