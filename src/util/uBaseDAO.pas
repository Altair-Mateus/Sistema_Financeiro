unit uBaseDAO;

interface

uses
  SysUtils, RTTI, Data.DB, FireDAC.Comp.Client, System.Variants,
  uDBColumnAttribute;

type
  TBaseDAO = class
  private
    class var FConnection: TFDConnection;
    function CheckTableAttribute(pType: TRttiType) : Boolean;
    function CheckColumnsAttribute(pProperty : TRttiProperty) : Boolean;
    function GetParameterValue(const pObject: TObject; const pProperty: TRttiProperty): string;
  public
    function Insert(const pObject: TObject) : Boolean;
    function Update(const pObject: TObject; const pWhereClause: string = '') : Boolean;
    class function Delete(const pTabela: string; const pCampos: array of string; const pValores: array of Variant) : Boolean;
    class function LoadObjectByID(const pTabela: string; pID: Integer; pObjeto: TObject) : Boolean;

    class property Connection: TFDConnection read FConnection write FConnection;
  end;

implementation

uses
  SistemaFinanceiro.Model.udmDados, Vcl.Dialogs;


function TBaseDAO.CheckTableAttribute(pType: TRttiType): Boolean;
begin
  
  Result := False;
    
  //  Verifica se a classe possui o atributo com o nome da tabela
  if (pType.HasAttribute<TDBTable>) and ( pType.GetAttribute<TDBTable>.TableName <> '') then
  begin
      Result := True;
  end;
    
end;

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


function TBaseDAO.GetParameterValue(const pObject: TObject;
  const pProperty: TRttiProperty): string;
begin

  if pProperty.GetValue(pObject).TypeInfo = TypeInfo(TDate) then
  begin
    Result := VarToStr(FormatDateTime('yyyy/mm/dd', pProperty.GetValue(pObject).AsExtended));
  end
  else if pProperty.GetValue(pObject).TypeInfo = TypeInfo(TDateTime) then
  begin
    Result := VarToStr(FormatDateTime('yyyy/mm/dd hh:MM:ss', pProperty.GetValue(pObject).AsExtended));
  end
  else 
  begin
    Result := VarToStr(pProperty.GetValue(pObject).AsVariant);
  end;

end;

function TBaseDAO.CheckColumnsAttribute(pProperty: TRttiProperty): Boolean;
begin

  Result := False;

  //  Verifica se a property possui o atributo com o nome da coluna
  if pProperty.HasAttribute<TDBColumnAtrribute> then
    //  Verifica se o atributo não é PK
    if not (pProperty.GetAttribute<TDBColumnAtrribute>.IsPrimaryKey) then
      Result := True;

end;

function TBaseDAO.Insert(const pObject: TObject) : Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL, lColumns, lValues, lTable: string;
  lQuery: TFDQuery;

begin

  Result := False;
  lContext := TRttiContext.Create;
  lQuery   := TFDQuery.Create(nil);

  try

    lType := lContext.GetType(pObject.ClassType);

    //  Verifica se a classe possui o atributo com o nome da tabela
    if not CheckTableAttribute(lType) then
    begin
        raise Exception.Create('Classe ' + lType.Name + ' está com o atributo TDBTable em branco ou insxistente!');
        exit;
    end;
    
    lTable   := lType.GetAttribute<TDBTable>.TableName;
    lColumns := '';
    lValues  := '';

    //  Percorre as propertys para montar as colunas para o SQL
    for lProperty in lType.GetProperties do
    begin

      //  Verifica se a property possui o atributo com o nome da coluna e se a mesma não é PK
      if CheckColumnsAttribute(lProperty) then
      begin
          lColumns := lColumns + lProperty.GetAttribute<TDBColumnAtrribute>.FieldName + ', ';
          lValues  := lValues + ':' + lProperty.Name + ', ';
      end;

    end;
    
    // Remove a última vírgula
    lColumns := Copy(lColumns, 1, Length(lColumns) - 2);
    lValues  := Copy(lValues, 1, Length(lValues) - 2);

    // Monta a query
    lSQL := 'INSERT INTO ' + lTable + ' (' + lColumns + ') VALUES (' + lValues + ')';


    try

      lQuery.Connection := FConnection;
      lQuery.SQL.Text := lSQL;

      // Definindo parâmetros
      for lProperty in lType.GetProperties do
      begin
        if CheckColumnsAttribute(lProperty)  then
          lQuery.Params.ParamByName(lProperty.Name).Value := GetParameterValue(pObject, lProperty);

      end;

      lQuery.ExecSQL;
      Result := True;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao Inserir registro na tabela  ' + lTable + E.Message);
      end;
    end;
  finally
    lQuery.Free;
    lContext.Free;
  end;

end;

function TBaseDAO.Update(const pObject: TObject; const pWhereClause: string = '') : Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL, lSets, lTable: string;
  lQuery: TFDQuery;
  
begin

  Result := False;
  lContext := TRttiContext.Create;
  lQuery := TFDQuery.Create(nil);

  //  Verifica se o where não veio vazio para evitar um update sem condição
  if pWhereClause = '' then
  begin
    raise Exception.Create('É necessário informar uma condição para executar um Update!');
    exit;
  end;
  

  try
    lType := lContext.GetType(pObject.ClassType);

    // Verifica o atributo TDBTable
    if not CheckTableAttribute(lType) then
    begin
      raise Exception.Create('A classe ' + lType.Name + ' possui o atributo TDBTable vazio ou inexistente!');
      exit;
    end;

    lTable := lType.GetAttribute<TDBTable>.TableName;
    lSets := '';

    // Percorre as propriedades para montar a cláusula SET do update
    for lProperty in lType.GetProperties do
    begin
      if CheckColumnsAttribute(lProperty) then
      begin
        lSets := lSets + lProperty.GetAttribute<TDBColumnAtrribute>.FieldName +
                 ' = :' + lProperty.Name + ', ';
      end;
    end;

    // Remove a última vírgula
    lSets := Copy(lSets, 1, Length(lSets) - 2);

    // Monta a consulta UPDATE
    lSQL := 'UPDATE ' + lTable + ' SET ' + lSets + ' WHERE ' + pWhereClause ;

    try
      lQuery.Connection := FConnection;
      lQuery.SQL.Text := lSQL;

      // Define parâmetros
      for lProperty in lType.GetProperties do
      begin
        if CheckColumnsAttribute(lProperty) then
          lQuery.Params.ParamByName(lProperty.Name).Value := GetParameterValue(pObject, lProperty);
      end;

      showmessage(lQuery.SQL.Text);
      lQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao atualizar registro na tabela ' + lTable + E.Message);
      end;
    end;
  finally
    lQuery.Free;
    lContext.Free;
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
