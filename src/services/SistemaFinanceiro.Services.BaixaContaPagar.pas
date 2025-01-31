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
      raise ECPagarNaoExiste.Create(Format('Não foi possível carregar os dados da conta nº %d', [lConta.ID]));

    // Carrega os dados do lançamento do caixa
    if not(lLancamentoCaixa.ExistePorOrigem(lConta.ID, tlCp, True)) then
      raise ELancCaixaNaoExiste.Create
        (Format('Não foi possível carregar os dados do lançamento do caixa da conta nº %d', [lConta.ID]));

    // Carrega os dados dos detalhes da baixa
    if not(lDetalhes.ExistePorCp(lConta.ID, True)) then
      raise ECpDetalheNaoExiste.Create
        (Format('Não foi possível carregar os dados do detalhe do pagamento da conta nº %d', [lConta.ID]));

    // Verifica se existe ao menos um pagamento
    if not(lPagamentos.ExistePorCp(lConta.ID, True)) then
      raise EPgtoCpNaoExiste.Create(Format('Não foi possível carregar os dados do pagamento da conta nº %d',
        [lConta.ID]));

    // Exclui o lançamento no caixa
    if not(lLancamentoCaixa.DeleteByPk) then
      raise ELancCaixaExcluir.Create(Format('Não foi possível excluir o lançamento do caixa da conta nº %d',
        [lConta.ID]));

    // Exclui os detalhes
    if not(lDetalhes.DeleteByPk) then
      raise ECpDetalheExcluir.Create(Format('Não foi possível excluir os detalhes do pagamento da conta nº %d',
        [lConta.ID]));

    // Exclui os pagamentos
    if not(lPagamentos.DeleteBySQLText(' ID_CP = ' + IntToStr(lConta.ID))) then
      raise EPgtoCpExcluir.Create(Format('Não foi possível excluir os pagamentos da conta nº %d', [lConta.ID]));

    // Atualiza a conta para não paga
    lConta.ValorAbatido := 0;
    lConta.DataPagamento := 0;
    lConta.Status := 'A';

    if not(lConta.UpdateByPK) then
      raise ECpagarAlterar.Create(Format('Não foi possível atualizar o status da conta  nº %d para Aberta',
        [lConta.ID]));

  finally
    lConta.Free;
    lDetalhes.Free;
    lPagamentos.Free;
    lLancamentoCaixa.Free;
  end;

end;

end.
