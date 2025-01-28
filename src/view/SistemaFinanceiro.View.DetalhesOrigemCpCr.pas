unit SistemaFinanceiro.View.DetalhesOrigemCpCr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  SistemaFinanceiro.Model.uSFQuery;

type
  TfrmDetalhesOrigemCpCr = class(TForm)
    pnlPrincipal: TPanel;
    pnlTitulo: TPanel;
    pnlBotoes: TPanel;
    ImageList1: TImageList;
    btnSair: TButton;
    pnlInfo: TPanel;
    lblDesc: TLabel;
    memDesc: TMemo;
    lblValor: TLabel;
    edtValor: TEdit;
    lblData: TLabel;
    lblNDoc: TLabel;
    edtNDoc: TEdit;
    lblForCli: TLabel;
    edtForCli: TEdit;
    lblFatCartao: TLabel;
    edtFatCartao: TEdit;
    lblCod: TLabel;
    edtCod: TEdit;
    lblVencimento: TLabel;
    edtDataCompraVenda: TEdit;
    edtDtVenc: TEdit;
    dsPagamentos: TDataSource;
    DBGridPgto: TDBGrid;
    lblFrPgto: TLabel;
    memObsPag: TMemo;
    lblDetBx: TLabel;
    edtUser: TEdit;
    lblNomeUser: TLabel;
    edtDtPag: TEdit;
    lblDtPag: TLabel;
    edtValPago: TEdit;
    lblValorPago: TLabel;
    edtValorDesc: TEdit;
    lblValDesco: TLabel;
    lblParciais: TLabel;
    DBGridParciais: TDBGrid;
    dsParciais: TDataSource;
    procedure btnSairClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FQueryPgtosBx, FQueryParciais: TSFQuery;
  public
    { Public declarations }
    procedure CarregaDados(pId: Integer; Origem: String);

  end;

var
  frmDetalhesOrigemCpCr: TfrmDetalhesOrigemCpCr;

implementation

{$R *.dfm}

uses
  SistemaFinanceiro.Model.Entidades.CP, SistemaFinanceiro.Model.Entidades.CR,
  SistemaFinanceiro.Model.dmCPagar,
  SistemaFinanceiro.Model.dmClientes, SistemaFinanceiro.Model.dmFornecedores,
  SistemaFinanceiro.Utilitarios, SistemaFinanceiro.Model.Entidades.CP.Detalhe,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe,
  SistemaFinanceiro.Model.dmFaturaCartao,
  SistemaFinanceiro.Model.Entidades.Usuario;

procedure TfrmDetalhesOrigemCpCr.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDetalhesOrigemCpCr.CarregaDados(pId: Integer; Origem: String);
var
  Cp          : TModelCp;
  lCr          : TModelCr;
  CpDet       : TModelCpDetalhe;
  lCrDet       : TModelCrDetalhe;
  lUsuario : TModelUsuario;
  SQLPgto     : String;
  SQLParciais : String;

begin

  //  Validações
  if (Origem <> 'CR') and (Origem <> 'CP') then
  begin
    raise Exception.Create('Origem inválida!');
  end;

  if Origem = 'CR' then
  begin

    //  Atualiza titulo
    pnlTitulo.Caption := 'Detalhes do lançamento no Caixa do Contas a Receber';

    lCr := TModelCR.Create;
    lCrDet := TModelCrDetalhe.Create;
    lUsuario := TModelUsuario.Create;
    try

      if not lCr.Existe(pId, True) then
      begin
        Application.MessageBox('Não encontrado CR!', 'Erro', MB_OK + MB_ICONERROR);
        exit;
      end;

      if not lCrDet.ExistePorCr(pId, True) then
      begin
        Application.MessageBox('Não encontrado detalhes da CR!', 'Erro', MB_OK + MB_ICONERROR);
        exit;
      end;

      lUsuario.Existe(lCrDet.Usuario, True);

      //  Carrega os dados
      edtCod.Text       := IntToStr(lCr.ID);
      edtForCli.Text    := IntToStr(lCr.IdCliente) + ' - ' + dmClientes.GetNomeCliente(IntToStr(lCr.IdCliente));
      lblForCli.Caption := 'Cliente';

      if lCr.Doc <> '' then
        edtNDoc.Text := lCr.Doc
      else
        edtNDoc.Text := 'Não Informado';

      edtDataCompraVenda.Text := FormatDateTime('DD/MM/YYYY', lCr.DataVenda);
      lblData.Caption         := 'Data da Venda';

      memDesc.Text   := lCr.Desc;
      edtValor.Text  := TUtilitario.FormatoMoeda(lCr.ValorParcela);
      edtDtVenc.Text := FormatDateTime('DD/MM/YYYY', lCr.DataVencimento);

      lblFatCartao.Visible := False;
      edtFatCartao.Visible := False;


      //  Pegando dados dos detalhes da baixa
      edtDtPag.Text     := FormatDateTime('DD/MM/YYYY', lCrDet.Data);
      edtValPago.Text   := TUtilitario.FormatoMoeda(lCrDet.Valor);
      edtValorDesc.Text := TUtilitario.FormatoMoeda(lCrDet.ValorDesc);
      edtUser.Text      := lUsuario.Nome;
      memObsPag.Text    := lCrDet.Detalhes;


      //  Montando o SQL dos pagamentos
      SQLPgto := 'SELECT PG.*, FR.NOME_FR FROM PGTO_BX_CR PG ' +
                 'LEFT JOIN FR_PGTO FR ON PG.ID_FR_PGTO = FR.ID_FR ' +
                 ' WHERE ID_CR = :IDCR';

      if Assigned(FQueryPgtosBx) then
        FreeAndNil(FQueryPgtosBx);

      FQueryPgtosBx := TSFQuery.Create(nil);

      FQueryPgtosBx.Close;
      FQueryPgtosBx.SQL.Clear;
      FQueryPgtosBx.Params.Clear;
      FQueryPgtosBx.SQL.Add(SQLPgto);

      FQueryPgtosBx.ParamByName('IDCR').AsInteger := pId;
      FQueryPgtosBx.Open();

      //  Definindo o dataset do datasource
      dsPagamentos.DataSet := FQueryPgtosBx;



      //  Montando SQL das Parciais
      SQLParciais := 'SELECT * FROM CONTAS_RECEBER WHERE PARCIAL = ''S'' ' +
                      ' AND CR_ORIGEM = :IDCR';

      if Assigned(FQueryParciais) then
        FreeAndNil(FQueryParciais);

      FQueryParciais := TSFQuery.Create(nil);

      FQueryParciais.Close;
      FQueryParciais.SQL.Clear;
      FQueryParciais.SQL.Add(SQLParciais);

      FQueryParciais.ParamByName('IDCR').AsInteger := pId;
      FQueryParciais.Open;


      //  Se não exisitir nenhuma CR Parcial ira ocultar
      //  O grid das parciais
      if FQueryParciais.IsEmpty then
      begin
        lblParciais.Visible    := False;
        DBGridParciais.Visible := False;
      end;

       //  Definindo o dataset do datasource
       dsParciais.DataSet := FQueryParciais;

    finally
      lCr.Free;
      lCrDet.Free;
      lUsuario.Free;
    end;

  end
  else if Origem = 'CP' then
       begin

        //  Atualiza titulo
        pnlTitulo.Caption := 'Detalhes do lançamento no Caixa do Contas a Pagar';

        Cp    := dmCPagar.GetCP(pId);
        CpDet := dmCPagar.GetCpDet(pId);

        try

          if Cp.ID <= 0 then
          begin
            raise Exception.Create('Conta a receber não encontrada!');
          end;

          //  Carrega os dados
          edtCod.Text       := IntToStr(Cp.ID);
          edtForCli.Text    := IntToStr(Cp.IdFornecedor) + ' - ' + dmFornecedores.GetNomeFornecedor(IntToStr(Cp.IdFornecedor));
          lblForCli.Caption := 'Fornecedor';

          if Cp.Doc <> '' then
            edtNDoc.Text := Cp.Doc
          else
            edtNDoc.Text := 'Não Informado';

          edtDataCompraVenda.Text := FormatDateTime('DD/MM/YYYY', Cp.DataCompra);
          lblData.Caption         := 'Data da Compra';

          memDesc.Text   := Cp.Desc;
          edtValor.Text  := TUtilitario.FormatoMoeda(Cp.ValorParcela);
          edtDtVenc.Text := FormatDateTime('DD/MM/YYYY', Cp.DataVencimento);

          if Cp.IdFatCartao > 0 then
          begin

            lblFatCartao.Visible := True;
            edtFatCartao.Visible := True;
            edtFatCartao.Text    := IntToStr(Cp.IdFatCartao) + ' - ' + dmFaturaCartao.GetNomeFatCartao(IntToStr(Cp.IdFatCartao));

          end
          else
          begin
             lblFatCartao.Visible := False;
             edtFatCartao.Visible := False;
          end;


          //  Pegando dados dos detalhes da baixa
          edtDtPag.Text     := FormatDateTime('DD/MM/YYYY', CpDet.Data);
          edtValPago.Text   := TUtilitario.FormatoMoeda(CpDet.Valor);
          edtValorDesc.Text := TUtilitario.FormatoMoeda(CpDet.ValorDesc);
          edtUser.Text      := CpDet.Usuario;
          memObsPag.Text    := CpDet.Detalhes;


          //  Montando o SQL dos pagamentos
          SqlPgto := 'SELECT PG.*, FR.NOME_FR FROM PGTO_BX_CP PG ' +
                     'LEFT JOIN FR_PGTO FR ON PG.ID_FR_PGTO = FR.ID_FR ' +
                     'WHERE PG.ID_CP = :IDCP';

          dmCPagar.FDQueryPgtoCp.Close;
          dmCPagar.FDQueryPgtoCp.SQL.Clear;
          dmCPagar.FDQueryPgtoCp.Params.Clear;
          dmCPagar.FDQueryPgtoCp.SQL.Add(SqlPgto);

          dmCPagar.FDQueryPgtoCp.ParamByName('IDCP').AsInteger := pId;
          dmCPagar.FDQueryPgtoCp.Prepare;
          dmCPagar.FDQueryPgtoCp.Open();

          //  Definindo o dataset do datasource
          dsPagamentos.DataSet := dmCPagar.FDQueryPgtoCp;


          //  Montando o SQL das Parciais
          SQLParciais := 'SELECT * FROM CONTAS_PAGAR WHERE PARCIAL = ''S'' ' +
                         ' AND CP_ORIGEM = :IDCP';

          dmCPagar.FDQueryCpParciais.Close;
          dmCPagar.FDQueryCpParciais.SQl.Clear;
          dmCPagar.FDQueryCpParciais.Params.Clear;
          dmCPagar.FDQueryCpParciais.SQL.Add(SQLParciais);

          dmCPagar.FDQueryCpParciais.ParamByName('IDCP').AsInteger := pId;
          dmCPagar.FDQueryCpParciais.Prepare;
          dmCPagar.FDQueryCpParciais.Open;


          //  Se não exisitir nenhuma CP Parcial ira ocultar
          //  O grid das parciais
          if dmCPagar.FDQueryCpParciais.IsEmpty then
          begin

            lblParciais.Visible    := False;
            DBGridParciais.Visible := False;

          end;

          //  Definindo o dataset do datasource
          dsParciais.DataSet := dmCPagar.FDQueryCpParciais;

        finally

          Cp.Free;
          CpDet.Free;

        end;

       end;

end;

procedure TfrmDetalhesOrigemCpCr.FormDestroy(Sender: TObject);
begin
  if Assigned(FQueryPgtosBx) then
    FQueryPgtosBx.Free;

  if Assigned(FQueryParciais) then
    FQueryParciais.Free;
end;

end.
