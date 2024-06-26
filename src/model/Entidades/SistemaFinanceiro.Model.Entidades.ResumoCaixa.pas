unit SistemaFinanceiro.Model.Entidades.ResumoCaixa;

interface
type
  TModelResumoCaixa = class

  private
    FTotalSaidas: Double;
    FTotalEntradas: Double;
    FSaldoInicial: Double;
    procedure SetSaldoInicial(const Value: Double);
    procedure SetTotalEntradas(const Value: Double);
    procedure SetTotalSaidas(const Value: Double);

  public

    property SaldoInicial : Double read FSaldoInicial write SetSaldoInicial;
    property TotalEntradas : Double read FTotalEntradas write SetTotalEntradas;
    property TotalSaidas : Double read FTotalSaidas write SetTotalSaidas;

    function SaldoParcial : Double;
    function SaldoFinal : Double;

  end;


implementation

{ TModelResumoCaixa }

function TModelResumoCaixa.SaldoFinal: Double;
begin

  Result := FSaldoInicial + SaldoParcial;

end;

function TModelResumoCaixa.SaldoParcial: Double;
begin

  Result := FTotalEntradas - FTotalSaidas;

end;

procedure TModelResumoCaixa.SetSaldoInicial(const Value: Double);
begin
  FSaldoInicial := Value;
end;

procedure TModelResumoCaixa.SetTotalEntradas(const Value: Double);
begin
  FTotalEntradas := Value;
end;

procedure TModelResumoCaixa.SetTotalSaidas(const Value: Double);
begin
  FTotalSaidas := Value;
end;

end.
