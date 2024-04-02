unit uBaseDAO;

interface

uses
  SysUtils, RTTI, Data.DB, FireDAC.Comp.Client, System.Variants;

type
  TBaseDAO = class
  private
    class var FConnection: TFDConnection;
  public
    class function Insert(const pTabela: string; pObjeto: TObject) : Boolean;
    class function Update(const pTabela: string; const pCampos: array of string; const pValores: array of Variant) : Boolean;
    class function Delete(const pTabela: string; const pCampos: array of string; const pValores: array of Variant) : Boolean;
    class function LoadObjectByID(const pTabela: string; pID: Integer; pObjeto: TObject) : Boolean;

    class property Connection: TFDConnection read FConnection write FConnection;
  end;

implementation

uses
  SistemaFinanceiro.Model.udmDados;


class function TBaseDAO.Delete(const pTabela: string; const pCampos: array of string; const pValores: array of Variant): Boolean;
var
  lCondicao: string;
  lQuery: TFDQuery;
  i: Integer;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);

  try
    lQuery.Connection := FConnection;

    try
      lCondicao := ' WHERE ';
      for i := Low(pCampos) to High(pCampos) do
      begin
        lCondicao := lCondicao + pCampos[i] + ' = :' + pCampos[i];
        if i < High(pCampos) then
          lCondicao := lCondicao + ' AND ';
      end;

      lQuery.SQL.Text := 'DELETE FROM ' + pTabela + lCondicao;

      for i := Low(pCampos) to High(pCampos) do
        lQuery.Params.ParamByName(pCampos[i]).Value := pValores[i];

      lQuery.ExecSQL;
      Result := True;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao deletar registro da tabela '+ pTabela + ': ' + E.Message);
      end;
    end;

  finally
    lQuery.Free;
  end;
end;


class function TBaseDAO.Insert(const pTabela: string; pObjeto: TObject) : Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL, lColumns, lValues: string;
  lQuery: TFDQuery;

begin

  Result := False;
  lContext := TRttiContext.Create;
  lQuery   := TFDQuery.Create(nil);

  try

    lType    := lContext.GetType(pObjeto.ClassType);
    lColumns := '';
    lValues  := '';

    for lProperty in lType.GetProperties do
    begin
      if not (lProperty.Name = 'Id') and not (lProperty.Name = 'Table_Name') then
      begin
        lColumns := lColumns + lProperty.Name + ', ';
        lValues  := lValues + ':' + lProperty.Name + ', ';
      end;
    end;

    // Remove a última vírgula
    lColumns := Copy(lColumns, 1, Length(lColumns) - 2);
    lValues  := Copy(lValues, 1, Length(lValues) - 2);

    // Monta a query
    lSQL := 'INSERT INTO ' + pTabela + ' (' + lColumns + ') VALUES (' + lValues + ')';


    try

      lQuery.Connection := FConnection;
      lQuery.SQL.Text := lSQL;

      // Definindo parâmetros
      for lProperty in lType.GetProperties do
      begin
        if not (lProperty.Name = 'Id') and not (lProperty.Name = 'Table_Name') then
        begin

           if lProperty.GetValue(pObjeto).TypeInfo = TypeInfo(TDate) then
            lValues  := VarToStr(FormatDateTime('yyyy/mm/dd', (lProperty.GetValue(pObjeto).AsExtended)))
           else
            lValues := VarToStr(lProperty.GetValue(pObjeto).AsVariant);

          lQuery.Params.ParamByName(lProperty.Name).Value := lValues;

        end;
      end;

      lQuery.ExecSQL;
      Result := True;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao Inserir registro na tabela  ' + pTabela + E.Message);
      end;
    end;
  finally
    lQuery.Free;
    lContext.Free;
  end;

end;

class function TBaseDAO.Update(const pTabela: string; const pCampos: array of string; const pValores: array of Variant): Boolean;
var
  lCondicao: string;
  lQuery: TFDQuery;
  i: Integer;

begin

  Result := False;
  lQuery := TFDQuery.Create(nil);

  try
    lQuery.Connection := FConnection;

    try

      lCondicao := ' SET ';
      for i := Low(pCampos) to High(pCampos) do
      begin
        lCondicao := lCondicao + pCampos[i] + ' = :' + pCampos[i];
        if i < High(pCampos) then
          lCondicao := lCondicao + ', ';
      end;

      lQuery.SQL.Text := 'UPDATE ' + pTabela + lCondicao;

      for i := Low(pCampos) to High(pCampos) do
        lQuery.Params.ParamByName(pCampos[i]).Value := pValores[i];

      lQuery.ExecSQL;
      Result := True;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao atualizar registro da tabela '+ pTabela + ': ' + E.Message);
      end;
    end;

  finally
    lQuery.Free;
  end;
end;

class function TBaseDAO.LoadObjectByID(const pTabela: string; pID: Integer; pObjeto: TObject) : Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL: string;
  lQuery: TFDQuery;

begin

  Result := False;
  lContext := TRttiContext.Create;
  lQuery := TFDQuery.Create(nil);

  try
    lType := lContext.GetType(pObjeto.ClassType);
    lQuery.Connection := FConnection;

    // Monta a query SQL de seleção
    lSQL := 'SELECT * FROM ' + pTabela + ' WHERE ID = :ID';

    // Execute a query SQL
    try
      lQuery.SQL.Add(lSQL);
      lQuery.ParamByName('ID').Value := pID;
      lQuery.Open;

      // Atribui os valores das colunas às propriedades do objeto
      for lProperty in lType.GetProperties do
      begin
       if not lQuery.FieldByName(lProperty.Name).IsNull then
        lProperty.SetValue(pObjeto, TValue.FromVariant(lQuery.FieldByName(lProperty.Name).Value));
      end;

      Result := True;

    except

      on E: Exception do
      begin
        raise Exception.Create('Erro ao executar a query SQL: ' + E.Message);
      end;

    end;

  finally
    lContext.Free;
    lQuery.Free;
  end;

end;

end.
