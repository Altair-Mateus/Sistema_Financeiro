unit SistemaFinanceiro.Services.BaixaContaPagar;

interface

uses
  uEnumsUtils,
  System.SysUtils;

type
  TBaixarContaPagar = class

  private

  public
    class procedure CancelarBaixa(const pIdCp: integer);
  end;

implementation

{ TBaixarContaPagar }

uses
  SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  SistemaFinanceiro.Model.Entidades.CP,
  SistemaFinanceiro.Model.Entidades.PgtoBxCp,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.BaixaCp,
  SistemaFinanceiro.Exceptions.ContasPagar,
  SistemaFinanceiro.Exceptions.ContasPagarDetalhe,
  SistemaFinanceiro.Exceptions.LancamentoCaixa,
  SistemaFinanceiro.Exceptions.PgtoBaixaCp;

class procedure TBaixarContaPagar.CancelarBaixa(const pIdCp: integer);
var
  lConta: TModelCP;
  lDetalhes: TModelCpDetalhe;
  lPagamentos: TModelPgtoBxCp;
  lLancamentoCaixa: TModelLancamentoCaixa;
begin

  lConta := TModelCP.Create;
  lDetalhes := TModelCpDetalhe.Create;
  lPagamentos := TModelPgtoBxCp.Create;
  lLancamentoCaixa := TModelLancamentoCaixa.Create;
  try

    // Carrega os dados da conta
    lConta.ID := pIdCp;
    if not(lConta.LoadObjectByPK) then
      raise ECPagarNaoExiste.Create(Format('N�o foi poss�vel carregar os dados da conta n� %d', [lConta.ID]));

    // Carrega os dados do lan�amento do caixa
    if not(lLancamentoCaixa.ExistePorOrigem(lConta.ID, tlCp, True)) then
      raise ELancCaixaNaoExiste.Create
        (Format('N�o foi poss�vel carregar os dados do lan�amento do caixa da conta n� %d', [lConta.ID]));

    // Carrega os dados dos detalhes da baixa
    if not(lDetalhes.ExistePorCp(lConta.ID, True)) then
      raise ECpDetalheNaoExiste.Create
        (Format('N�o foi poss�vel carregar os dados do detalhe do pagamento da conta n� %d', [lConta.ID]));

    // Verifica se existe ao menos um pagamento
    if not(lPagamentos.ExistePorCp(lConta.ID, True)) then
      raise EPgtoCpNaoExiste.Create(Format('N�o foi poss�vel carregar os dados do pagamento da conta n� %d',
        [lConta.ID]));

    // Exclui o lan�amento no caixa
    if not(lLancamentoCaixa.DeleteByPk) then
      raise ELancCaixaExcluir.Create(Format('N�o foi poss�vel excluir o lan�amento do caixa da conta n� %d',
        [lConta.ID]));

    // Exclui os detalhes
    if not(lDetalhes.DeleteByPk) then
      raise ECpDetalheExcluir.Create(Format('N�o foi poss�vel excluir os detalhes do pagamento da conta n� %d',
        [lConta.ID]));

    // Exclui os pagamentos
    if not(lPagamentos.DeleteBySQLText(' ID_CP = ' + IntToStr(lConta.ID))) then
      raise EPgtoCpExcluir.Create(Format('N�o foi poss�vel excluir os pagamentos da conta n� %d', [lConta.ID]));

    // Atualiza a conta para n�o paga
    lConta.ValorAbatido := 0;
    lConta.DataPagamento := 0;
    lConta.Status := 'A';

    if not(lConta.UpdateByPK) then
      raise ECpagarAlterar.Create(Format('N�o foi poss�vel atualizar o status da conta  n� %d para Aberta',
        [lConta.ID]));

  finally
    lConta.Free;
    lDetalhes.Free;
    lPagamentos.Free;
    lLancamentoCaixa.Free;
  end;

end;

end.
