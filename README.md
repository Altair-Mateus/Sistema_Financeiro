# Sistema Financeiro

<div style="background-color: black; display: inline-block; text-align: center;">
  <img src="./img/img_logo.png" alt="Sistema Financeiro" style="width: 300px;">
</div>


Este repositório contém um sistema financeiro desenvolvido em **Delphi**, com o objetivo de aprofundar na linguagem e em seus conceitos, aplicando melhorias contínuas e incorporando novas tecnologias e recursos. O sistema utiliza **Firebird** como banco de dados, **bcrypt** para criptografar senhas dos usuários e **Fortes Report** para geração de relatórios personalizados.

## Funcionalidades Principais

- **Clientes e Fornecedores**: Cadastros, pesquisa e relatórios personalizados.
- **Usuários**: Cadastros, pesquisa, relatórios personalizados e senhas criptografadas.
- **Contas a Receber e Contas a Pagar**: Controle de contas a receber e a pagar.
- **Gestão de Fluxo de Caixa**: 
  - Lançamentos manuais ou automáticos a partir de contas a receber e pagar.
  - Controle de saldo com relatórios personalizados.
- **Baixa Total ou Parcial de Contas**:
  - Realize pagamentos de uma ou mais contas, com filtros por cliente/fornecedor ou faturas de cartão.
  - Lançamento automático no fluxo de caixa ao realizar a baixa/pagamento.
  - Possibilidade de cancelar baixas/pagamentos, revertendo o status da conta e removendo o movimento do fluxo de caixa.
  - Veja detalhes da baixa como descriação, valor pago, data e usuário que realizou a mesma.
- **Descontos**: 
  - Aplique descontos em valor ou porcentagem ao realizar baixas/pagamentos.
- **Contas Parceladas**:
  - Cadastre contas em lote, informando valor total, número de parcelas e vencimento.
  - Vincule parcelas a faturas de cartão
  - Visualize todas as parcelas associadas a uma conta cadastrada.
- **Formas de Pagamento**: Cadastre formas de pagamento para uso na baixa de contas.
- **Faturas de Cartão**:
  - Cadastre cartões para controle de compras, associando-os a contas a pagar.
  - Relatórios para analisar gastos por cartão.
- **Relatórios Personalizados**: Disponíveis para todas as funcionalidades do sistema.
- **Pesquisa Inteligente**: Com várias opções de filtro para localizar registros rapidamente.
- **Lançamentos Padrão**: Cadastre lançamentos padrão para agilizar a inclusão de contas a pagar ou a receber.
- **Ativar/Desativar Cadastros**: Ative ou desative clientes, fornecedores, formas de pagamento ou faturas de cartão que não serão mais utilizados.

## Estrutura do Projeto

- **src**: Contém o código-fonte do sistema.
- **dados**: Inclui o banco de dados de exemplo, scripts para criação de tabelas e o diagrama ER.
- **img**: Armazena as imagens usadas no projeto.
- **bin**: Contém o executável do projeto e o arquivo `.ini` para configuração do banco de dados.

## Tecnologias Utilizadas

- **Delphi**: Linguagem principal do projeto.
- **Banco de Dados Firebird**: Para armazenamento e gerenciamento de dados.
- **bcrypt**: Para hashing seguro de senhas, protegendo dados sensíveis.
- **Fortes Report**: Para geração de relatórios personalizados.

## Como Executar o Projeto

### Requisitos

- **Firebird** 2.5+
- **Delphi** 10.3+
- **Fortes Report**
- **bcrypt**

### Passos para Execução

1. Instale o **Firebird**.
2. Instale os componentes do **Fortes Report** e do **bcrypt** no **Delphi**.
3. Clone este repositório:
   ```bash
   git clone https://github.com/Altair-Mateus/Sistema_Financeiro.git
4. Configure o arquivo .ini na mesma pasta do executável (bin) para conexão com o banco de dados.
5. Abra o projeto no Delphi e execute-o.