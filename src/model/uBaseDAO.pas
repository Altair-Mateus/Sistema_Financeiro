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
    class function Update(const pTabela: string; const pCampos: array of string; const pValores: array of Variant): Boolean;
    class function Delete(const pTabela: string; const pCampos: array of string; const pValores: array of Variant): Boolean;

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
      lColumns := lColumns + lProperty.Name + ', ';
      lValues  := lValues + ':' + lProperty.Name + ', ';
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
        lValues := VarToStr(lProperty.GetValue(pObjeto).AsVariant);
        lQuery.Params.ParamByName(lProperty.Name).Value := lValues;
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


end.
