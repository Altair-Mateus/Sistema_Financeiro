unit SistemaFinanceiro.Model.dmCReceber;
interface
uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Datasnap.Provider,
  Datasnap.DBClient, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  SistemaFinanceiro.Model.Entidades.CR.Detalhe,
  SistemaFinanceiro.Model.Entidades.CR, Vcl.Dialogs, Vcl.Forms, Winapi.Windows;

type
  TdmCReceber = class(TDataModule)
    FDQueryCReceber: TFDQuery;
    cdsCReceber: TClientDataSet;
    DataSetProviderCReceber: TDataSetProvider;
    cdsCReceberID: TIntegerField;
    cdsCReceberNUMERO_DOCUMENTO: TWideStringField;
    cdsCReceberDESCRICAO: TWideStringField;
    cdsCReceberPARCELA: TIntegerField;
    cdsCReceberDATA_CADASTRO: TDateField;
    cdsCReceberDATA_VENCIMENTO: TDateField;
    cdsCReceberDATA_RECEBIMENTO: TDateField;
    cdsCReceberSTATUS: TWideStringField;
    cdsCReceberDATA_VENDA: TDateField;
    FDQueryCrDetalhe: TFDQuery;
    FDQueryCrDetalheID: TIntegerField;
    FDQueryCrDetalheID_CONTA_RECEBER: TIntegerField;
    FDQueryCrDetalheDETALHES: TWideStringField;
    FDQueryCrDetalheDATA: TDateField;
    FDQueryCrDetalheNOME: TWideStringField;
    cdsCReceberPARCIAL: TWideStringField;
    cdsCReceberCR_ORIGEM: TIntegerField;
    cdsCReceberID_CLIENTE: TIntegerField;
    cdsCReceberNOME: TWideStringField;
    lQueryPgtoCr: TFDQuery;
    lQueryPgtoCrID_FR_PGTO: TIntegerField;
    lQueryPgtoCrNR_FR: TIntegerField;
    lQueryPgtoCrDATA_HORA: TSQLTimeStampField;
    lQueryPgtoCrID: TIntegerField;
    lQueryPgtoCrID_CR: TIntegerField;
    lQueryPgtoCrNOME: TWideStringField;
    cdsCReceberVALOR_PARCELA: TBCDField;
    cdsCReceberVALOR_VENDA: TBCDField;
    cdsCReceberVALOR_ABATIDO: TBCDField;
    FDQueryCrDetalheVALOR: TBCDField;
    lQueryPgtoCrVALOR_PAGO: TBCDField;
    FDQueryCrDetalheDESCONTO_BX: TBCDField;
    FDQueryCrDetalheUSUARIO: TIntegerField;
    FDQueryCrParciais: TFDQuery;
    FDQueryCrParciaisID: TIntegerField;
    FDQueryCrParciaisNUMERO_DOCUMENTO: TWideStringField;
    FDQueryCrParciaisDESCRICAO: TWideStringField;
    FDQueryCrParciaisPARCELA: TIntegerField;
    FDQueryCrParciaisVALOR_PARCELA: TBCDField;
    FDQueryCrParciaisVALOR_VENDA: TBCDField;
    FDQueryCrParciaisVALOR_ABATIDO: TBCDField;
    FDQueryCrParciaisDATA_VENDA: TDateField;
    FDQueryCrParciaisDATA_CADASTRO: TDateField;
    FDQueryCrParciaisDATA_VENCIMENTO: TDateField;
    FDQueryCrParciaisDATA_RECEBIMENTO: TDateField;
    FDQueryCrParciaisSTATUS: TWideStringField;
    FDQueryCrParciaisPARCIAL: TWideStringField;
    FDQueryCrParciaisCR_ORIGEM: TIntegerField;
    FDQueryCrParciaisID_CLIENTE: TIntegerField;
    cdsBxMultipla: TClientDataSet;
    cdsBxMultiplaID: TIntegerField;
    cdsBxMultiplaNUMERO_DOCUMENTO: TWideStringField;
    cdsBxMultiplaDESCRICAO: TWideStringField;
    cdsBxMultiplaPARCELA: TIntegerField;
    cdsBxMultiplaVALOR_PARCELA: TBCDField;
    cdsBxMultiplaVALOR_VENDA: TBCDField;
    cdsBxMultiplaVALOR_ABATIDO: TBCDField;
    cdsBxMultiplaDATA_VENDA: TDateField;
    cdsBxMultiplaDATA_CADASTRO: TDateField;
    cdsBxMultiplaDATA_VENCIMENTO: TDateField;
    cdsBxMultiplaDATA_RECEBIMENTO: TDateField;
    cdsBxMultiplaSTATUS: TWideStringField;
    cdsBxMultiplaPARCIAL: TWideStringField;
    cdsBxMultiplaCR_ORIGEM: TIntegerField;
    cdsBxMultiplaID_CLIENTE: TIntegerField;
    cdsBxMultiplaNOME: TWideStringField;
    FDQueryRelatorios: TFDQuery;
    procedure cdsCReceberSTATUSGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

  private
    { Private declarations }
    procedure QryCancBxCr(SQL : String; Id : Integer);

  public
    { Public declarations }
    procedure GeraCodigo;
    procedure BaixarCR(BaixaCR : TModelCrDetalhe);
    procedure CancBxCr(Id : Integer);

    function GeraCodigoCRDetalhe : Integer;
    function GetCR(Id : Integer) : TModelCR;
    function GetCrDet(Id : Integer) : TModelCrDetalhe;
    function TotalCR(DataInicial, DataFinal: TDate): Currency;

  end;

var
  dmCReceber: TdmCReceber;

implementation
{%CLASSGROUP 'Vcl.Controls.TControl'}

uses SistemaFinanceiro.Model.udmDados,
  SistemaFinanceiro.Model.Entidades.LancamentoCaixa,
  SistemaFinanceiro.Model.dmCaixa;
{$R *.dfm}
{ TdmCReceber }

procedure TdmCReceber.BaixarCR(BaixaCR: TModelCrDetalhe);
var
  ContaReceber : TModelCR;
  FDQueryCR    : TFDQuery;
  FDQueryCrDet : TFDQuery;
  SQLUpdate    : String;
  SQLInsert    : String;
  LancarCaixa  : TModelLancamentoCaixa;
  FDQueryCaixa : TFDQuery;

const
  ToleranciaValCr : Currency = 0.01;

begin
  ContaReceber := GetCR(BaixaCR.IdCR);
  FDQueryCR    := TFDQuery.Create(nil);
  FDQueryCrDet := TFDQuery.Create(nil);
  FDQueryCaixa := TFDQuery.Create(nil);

  try

    //  Estabelece conex�o com o banco
    FDQueryCR.Connection    := DataModule1.FDConnection;
    FDQueryCrDet.Connection := DataModule1.FDConnection;
    FDQueryCaixa.Connection := DataModule1.FDConnection;

    if ContaReceber.ID <= 0 then
    begin
      raise Exception.Create('Conta a receber n�o encontrada!');
    end;

    ContaReceber.ValorAbatido := ContaReceber.ValorAbatido + BaixaCR.Valor;

    //  Caso o valor abatido j� seja igual ao valor da parcela
    if ContaReceber.ValorAbatido >= ContaReceber.ValorParcela then
    begin

      ContaReceber.Status := 'P';
      ContaReceber.DataRecebimento := BaixaCR.Data;

    end;

    try

      // Inclui conta parcial
      if (Abs(ContaReceber.ValorParcela - BaixaCR.Valor) - BaixaCR.ValorDesc) > ToleranciaValCr then
      begin

          //  Inseriando nova duplcata parcial
          if not (cdsCReceber.State in [dsInsert, dsEdit]) then
          begin

            //  Colocando o data set em modo de inser��o de dados
            cdsCReceber.Insert;

          end;

          //  gera a id
          GeraCodigo;
          cdsCReceberDATA_CADASTRO.AsDateTime := now;
          cdsCReceberSTATUS.AsString          := 'A';
          cdsCReceberVALOR_ABATIDO.AsCurrency := 0;


          //  Passando os dados para o dataset
          if (ContaReceber.Doc = '') or (ContaReceber.Parcial = 'S' ) then
          begin
            cdsCReceberNUMERO_DOCUMENTO.AsString  := ContaReceber.Doc;
          end
          else
          begin
            cdsCReceberNUMERO_DOCUMENTO.AsString  := Format('%s-P', [ContaReceber.Doc]);
          end;

          cdsCReceberDESCRICAO.AsString         := Format('Parcial - Restante da Conta ID N� %s - Doc N� %s', [ContaReceber.ID, ContaReceber.Doc]);
          cdsCReceberVALOR_VENDA.AsCurrency     := ContaReceber.ValorVenda;
          cdsCReceberDATA_VENDA.AsDateTime      := ContaReceber.DataVenda;
          cdsCReceberPARCELA.AsInteger          := ContaReceber.Parcela;
          cdsCReceberVALOR_PARCELA.AsCurrency   := ((ContaReceber.ValorParcela - BaixaCR.Valor) - BaixaCR.ValorDesc);
          cdsCReceberDATA_VENCIMENTO.AsDateTime := ContaReceber.DataVencimento;
          cdsCReceberPARCIAL.AsString           := 'S';
          cdsCReceberCR_ORIGEM.AsString         := IntToStr(ContaReceber.Id);
          cdsCReceberID_CLIENTE.AsInteger       := ContaReceber.IdCliente;

          //  Gravando no BD
          cdsCReceber.Post;
          cdsCReceber.ApplyUpdates(0);

        end;

        //  Montando o SQL para atualizar a conta baixada
        SQLUpdate := 'UPDATE CONTAS_RECEBER SET VALOR_ABATIDO = :VALORABATIDO, ' +
                ' VALOR_PARCELA = :VALORPARCELA, STATUS = :STATUS, ' +
                ' DATA_RECEBIMENTO = :DATAREC' +
                ' WHERE ID = :IDCR; ';

        FDQueryCR.Close;
        FDQueryCR.SQL.Clear;
        FDQueryCR.SQL.Add(SQLUpdate);

        FDQueryCR.ParamByName('VALORABATIDO').AsCurrency := ContaReceber.ValorAbatido;
        FDQueryCR.ParamByName('VALORPARCELA').AsCurrency := ContaReceber.ValorParcela;
        FDQueryCR.ParamByName('STATUS').AsString         := 'P';
        FDQueryCR.ParamByName('DATAREC').AsDate          := BaixaCR.Data;
        FDQueryCR.ParamByName('IDCR').AsString           := IntToStr(ContaReceber.ID);

        FDQueryCR.Prepare;
        FDQueryCR.ExecSQL;

      //  Montando o SQL para persisitr os dados na tabela Contas_receber_detalhe
      SQLInsert := 'INSERT INTO CONTAS_RECEBER_DETALHE (ID, ID_CONTA_RECEBER, DETALHES, ' +
             ' VALOR, DATA, USUARIO, DESCONTO_BX) VALUES (:ID, :IDCR, :DETALHES, :VALOR, ' +
             ' :DATA, :USUARIO, :DESC )';

      FDQueryCrDet.SQL.Add(SQLInsert);

      FDQueryCrDet.ParamByName('ID').AsInteger      := GeraCodigoCRDetalhe;
      FDQueryCrDet.ParamByName('IDCR').AsInteger    := BaixaCR.IdCR;
      FDQueryCrDet.ParamByName('DETALHES').AsString := BaixaCR.Detalhes;
      FDQueryCrDet.ParamByName('VALOR').AsCurrency  := BaixaCR.Valor;
      FDQueryCrDet.ParamByName('DATA').AsDate       := BaixaCR.Data;
      FDQueryCrDet.ParamByName('USUARIO').AsInteger := BaixaCR.Usuario;
      FDQueryCrDet.ParamByName('DESC').AsCurrency   := BaixaCR.ValorDesc;

      FDQueryCrDet.Prepare;
      FDQueryCrDet.ExecSQL;

      //  Lan�ando a baixa no caixa
      LancarCaixa := TModelLancamentoCaixa.Create;
      try

        LancarCaixa.ID           := dmCaixa.GeraId;
        LancarCaixa.NumDoc       := ContaReceber.Doc;
        LancarCaixa.Desc         := Format('Baixa Conta ID N� %s a Receber - N� Documento: %s - Parcela: %d', [ContaReceber.ID, ContaReceber.Doc, ContaReceber.Parcela]);
        LancarCaixa.Valor        := BaixaCr.Valor;
        LancarCaixa.Tipo         := 'R';
        LancarCaixa.DataCadastro := BaixaCR.Data;
        LancarCaixa.Origem       := 'CR';
        LancarCaixa.IdOrigem     := ContaReceber.ID;

        try
          DataModule1.FDConnection.StartTransaction;
          try

            dmCaixa.GravarLancamento(LancarCaixa, FDQueryCaixa);
            DataModule1.FDConnection.Commit;

          except

            DataModule1.FDConnection.Rollback;
            raise;

          end;
        finally

          FDQueryCaixa.Close;
          FDQueryCaixa.Free;

        end;

      finally

        LancarCaixa.Free;

      end;

    finally

      FDQueryCR.Close;
      FDQueryCR.Free;
      FDQueryCrDet.Free;

    end;

  finally

    ContaReceber.Free;

  end;

end;

procedure TdmCReceber.CancBxCr(Id: Integer);
const
  SQLCp   = 'UPDATE CONTAS_RECEBER SET VALOR_ABATIDO = 0, DATA_RECEBIMENTO = NULL, STATUS = ''A'' ' +
           ' WHERE ID = :IDCR';
  SQlDet  = 'DELETE FROM CONTAS_RECEBER_DETALHE WHERE ID_CONTA_RECEBER = :IDCR';
  SQlPgto = 'DELETE FROM PGTO_BX_CR WHERE ID_CR = :IDCR';
  SQLCx   = 'DELETE FROM CAIXA WHERE ORIGEM = ''CR'' AND ID_ORIGEM = :IDCR';

begin

  //  Valida a ID
  if Id <= 0 then
  begin
   raise Exception.Create('Conta a receber n�o encontrada!');
  end;

  DataModule1.FDConnection.StartTransaction;

  try

    QryCancBxCR(SQLDet, Id);
    QryCancBxCR(SQLPgto, Id);
    QryCancBxCR(SQLCx, Id);
    QryCancBxCR(SQLCp, Id);

    DataModule1.FDConnection.Commit;
    Application.MessageBox('Conta cancelada com Sucesso!!', 'Aten��o', MB_OK + MB_ICONINFORMATION);

  except

    on E: Exception do
    begin
      DataModule1.FDConnection.Rollback;
      Application.MessageBox(PWideChar(E.Message), 'Erro ao cancelar a CR!', MB_OK + MB_ICONWARNING);
    end;

  end;



end;

procedure TdmCReceber.cdsCReceberSTATUSGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin

  if Sender.AsString = 'A' then
  begin
    Text := 'ABERTA';
  end
  else if Sender.AsString = 'P' then
       begin
         Text := 'PAGA';
       end
       else if Sender.AsString = 'C' then
            begin
              Text := 'CANCELADA';
            end;

end;

procedure TdmCReceber.GeraCodigo;
var
  FDQueryId : TFDQuery;
  cod : integer;

begin
  cod := 0;
  FDQueryId := TFDQuery.Create(nil);

  try

    //  Estabelece a conexao com o banco
    FDQueryId.Connection := DataModule1.FDConnection;
    FDQueryId.Close;
    FDQueryId.SQL.Clear;
    FDQueryId.Open('SELECT MAX(ID) AS ID FROM CONTAS_RECEBER');

    //  Ultimo codigo usado + 1
    cod := FDQueryId.FieldByName('ID').AsInteger + 1;
    cdsCReceberID.AsInteger := cod;

    //  Insere o registro no final da tabela
    FDQueryId.Append;

  finally

    FDQueryId.Close;
    FDQueryId.Free;

  end;

end;

function TdmCReceber.GeraCodigoCRDetalhe: Integer;
var
  FDQueryIdDet : TFDQuery;

begin

  Result := 0;
  FDQueryIdDet := TFDQuery.Create(nil);

  try
    //  Estabelece a conexao com o banco
    FDQueryIdDet.Connection := DataModule1.FDConnection;
    FDQueryIdDet.Close;
    FDQueryIdDet.SQL.Clear;
    FDQueryIdDet.Open('SELECT MAX(ID) AS ID FROM CONTAS_RECEBER_DETALHE');

    //  Ultimo codigo usado + 1
    Result := FDQueryIdDet.FieldByName('ID').AsInteger + 1;

    //  Insere o registro no final da tabela
    FDQueryIdDet.Append;

  finally

    FDQueryIdDet.Close;
    FDQueryIdDet.Free;

  end

end;

function TdmCReceber.GetCR(Id: Integer): TModelCR;
var
  FDQueryCR : TFDQuery;
begin

  FDQueryCR := TFDQuery.Create(nil);

  try

    //  Estabelece a conex�o
    FDQueryCR.Connection := DataModule1.FDConnection;

    FDQueryCR.Close;
    FDQueryCR.SQL.Clear;
    FDQueryCR.SQL.Add('SELECT * FROM CONTAS_RECEBER WHERE ID = :ID');

    FDQueryCR.ParamByName('ID').AsInteger := Id;
    FDQueryCR.Open;

    Result := TModelCR.Create;

    try

      Result.ID              := FDQueryCR.FieldByName('ID').AsInteger;
      Result.Doc             := FDQueryCR.FieldByName('NUMERO_DOCUMENTO').AsString;
      Result.Desc            := FDQueryCR.FieldByName('DESCRICAO').AsString;
      Result.Parcela         := FDQueryCR.FieldByName('PARCELA').AsInteger;
      Result.ValorVenda      := FDQueryCR.FieldByName('VALOR_VENDA').AsCurrency;
      Result.ValorAbatido    := FDQueryCR.FieldByName('VALOR_ABATIDO').AsCurrency;
      Result.ValorParcela    := FDQueryCR.FieldByName('VALOR_PARCELA').AsCurrency;
      Result.DataVenda       := FDQueryCR.FieldByName('DATA_VENDA').AsDateTime;
      Result.DataCadastro    := FDQueryCR.FieldByName('DATA_CADASTRO').AsDateTime;
      Result.DataVencimento  := FDQueryCR.FieldByName('DATA_VENCIMENTO').AsDateTime;
      Result.DataRecebimento := FDQueryCR.FieldByName('DATA_RECEBIMENTO').AsDateTime;
      Result.Status          := FDQueryCR.FieldByName('STATUS').AsString;
      Result.Parcial         := FDQueryCR.FieldByName('PARCIAL').AsString;
      Result.CrOrigem        := FDQueryCR.FieldByName('CR_ORIGEM').AsInteger;
      Result.IdCliente       := FDQueryCR.FieldByName('ID_CLIENTE').AsInteger;

    except

      Result.Free;
      raise;

    end;

  finally

    FDQueryCR.Close;
    FDQueryCR.Free;

  end;

end;

function TdmCReceber.GetCrDet(Id: Integer): TModelCrDetalhe;
var
  FDQueryCrDet : TFDQuery;
  SQL: String;

begin

  FDQueryCrDet := TFDQuery.Create(Nil);

  try

    //  Estabelece a conex�o
    FDQueryCrDet.Connection := DataModule1.FDConnection;

    SQL:= 'SELECT * FROM CONTAS_RECEBER_DETALHE CP' +
         ' LEFT JOIN USUARIOS US ON CP.USUARIO = US.ID ' +
         ' WHERE ID_CONTA_RECEBER = :ID';

    FDQueryCrDet.Close;
    FDQueryCrDet.SQL.Clear;
    FDQueryCrDet.SQL.Add(SQL);
    FDQueryCrDet.ParamByName('ID').AsInteger := Id;
    FDQueryCrDet.Open;

    Result := TModelCrDetalhe.Create;

    try

      Result.Id        := FDQueryCrDet.FieldByName('ID').AsInteger;
      Result.IdCr      := FDQueryCrDet.FieldByName('ID_CONTA_RECEBER').AsInteger;
      Result.Detalhes  := FDQueryCrDet.FieldByName('DETALHES').AsString;
      Result.Valor     := FDQueryCrDet.FieldByName('VALOR').AsCurrency;
      Result.Data      := FDQueryCrDet.FieldByName('DATA').AsDateTime;
//      Result.Usuario   := FDQueryCrDet.FieldByName('NOME').AsString;
      Result.ValorDesc := FDQueryCrDet.FieldByName('DESCONTO_BX').AsCurrency;

    except
      Result.Free;
      raise;
    end;

  finally
    FDQueryCrDet.Free;
  end;

end;

procedure TdmCReceber.QryCancBxCr(SQL : String; Id : Integer);
var
  FDQueryCancBx : TFDQuery;

begin

  FDQueryCancBx := TFDQuery.Create(nil);

  try

    //  Estabelece a conexao com o banco
    FDQueryCancBx.Connection := DataModule1.FDConnection;

    FDQueryCancBx.Close;
    FDQueryCancBx.SQL.Clear;
    FDQueryCancBx.SQL.Add(SQL);
    FDQueryCancBx.ParamByName('IDCR').AsInteger := Id;
    FDQueryCancBx.ExecSQL;

  finally

    FDQueryCancBx.Free;

  end;

end;

function TdmCReceber.TotalCR(DataInicial, DataFinal: TDate): Currency;
var
  FDQueryTotalCR : TFDQuery;

begin

  Result := 0;
  FDQueryTotalCR := TFDQuery.Create(nil);

  try

    //  Estabele a conex�o com o banco
    FDQueryTotalCR.Connection := DataModule1.FDConnection;

    FDQueryTotalCR.Close;
    FDQueryTotalCR.SQL.Clear;
    FDQueryTotalCR.SQL.Add('SELECT COALESCE(SUM(VALOR_PARCELA), 0) AS VALOR FROM CONTAS_RECEBER ');
    FDQueryTotalCR.SQL.Add(' WHERE STATUS = ''A'' AND DATA_VENCIMENTO BETWEEN :DATA_INICIAL AND :DATA_FINAL ');

    FDQueryTotalCR.ParamByName('DATA_INICIAL').AsDate := DataInicial;
    FDQueryTotalCR.ParamByName('DATA_FINAL').AsDate := DataFinal;

    FDQueryTotalCR.Open;

    Result := FDQueryTotalCR.FieldByName('VALOR').AsCurrency;


  finally

    FDQueryTotalCR.Close;
    FDQueryTotalCR.Free;

  end;

end;


end.
