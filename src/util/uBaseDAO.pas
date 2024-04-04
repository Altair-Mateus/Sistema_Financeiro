unit uBaseDAO;

interface

uses
  SysUtils, RTTI, Data.DB, FireDAC.Comp.Client, System.Variants,
  uDBColumnAttribute,
  System.Classes;

type
  TBaseDAO = class
  private
    FPropertiesToWhere: TStringList;
    class var FConnection: TFDConnection;
    function CheckTableAttribute(pType: TRttiType) : Boolean;
    function CheckColumnsAttribute(pProperty : TRttiProperty) : Boolean;
    function GetParameterValue(const pObject: TObject; const pProperty: TRttiProperty): string;
    function FindPrimaryKeyProperty(const pType: TRttiType): TRttiProperty;

  public

    function Insert(const pObject: TObject) : Boolean;

    //  Atualiza com base no SQL passado por parametro
    function UpdateByText(const pObject: TObject; const pWhereClause: string = '') : Boolean;
    //  Atualiza usando a property mapeada como Primary Key na property
    function UpdateByPK(const pObject : TObject) : Boolean;
    //  Atualiza usando as propertys passada como parametro
    function UpdateByProp(const pObject: TObject): Boolean;

    function Delete(const pObject: TObject; const pWhereClause: string = '') : Boolean;
    function LoadObjectByPK(const pObject: TObject) : Boolean;

    procedure AddPropertyToWhere(const pPropertyName: string);
    function GetPropertiesToWhere: TStringList;

    constructor Create;
    destructor Destroy; override;

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

constructor TBaseDAO.Create;
begin
  FPropertiesToWhere := TStringList.Create;
end;

function TBaseDAO.UpdateByProp(const pObject: TObject): Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL, lSets, lTable: string;
  lQuery: TFDQuery;
  lWhereClause: string;

begin
  Result := False;
  lContext := TRttiContext.Create;
  lQuery := TFDQuery.Create(nil);

  try
    lType := lContext.GetType(pObject.ClassType);

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

    // Constrói a cláusula WHERE baseada na lista de propriedades fornecida
    lWhereClause := '';
    for lProperty in lType.GetProperties do
    begin
      if CheckColumnsAttribute(lProperty) and (FPropertiesToWhere.IndexOf(lProperty.Name) > -1) then
      begin
        if not lWhereClause.IsEmpty then
          lWhereClause := lWhereClause + ' AND ';
        lWhereClause := lWhereClause + lProperty.GetAttribute<TDBColumnAtrribute>.FieldName + ' = :' + lProperty.Name;
      end;
    end;

    if lWhereClause.IsEmpty then
    begin
      raise Exception.Create('Nenhuma propriedade válida fornecida para construir a cláusula WHERE!');
      exit;
    end;

    // Monta a consulta UPDATE
    lSQL := 'UPDATE ' + lTable + ' SET ' + lSets + ' WHERE ' + lWhereClause;

    try
      lQuery.Connection := FConnection;
      lQuery.SQL.Text := lSQL;

      // Define parâmetros
      for lProperty in lType.GetProperties do
      begin
        if CheckColumnsAttribute(lProperty) then
          lQuery.Params.ParamByName(lProperty.Name).Value := GetParameterValue(pObject, lProperty);
      end;

      lQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao atualizar registro na tabela ' + lTable + ': ' + E.Message);
      end;
    end;
  finally
    lQuery.Free;
    lContext.Free;
  end;
end;


function TBaseDAO.Delete(const pObject: TObject; const pWhereClause: string = '') : Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL, lTable: string;
  lQuery: TFDQuery;
  
begin

  Result   := False;
  lContext := TRttiContext.Create;
  lQuery   := TFDQuery.Create(nil);

  //  Verifica se o where não veio vazio para evitar um update sem condição
  if pWhereClause = '' then
  begin
    raise Exception.Create('É necessário informar uma condição para executar um Delete!');
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

    lSQL := 'DELETE FROM ' + lTable + ' WHERE ' + pWhereClause;

    try

      lQuery.Connection := FConnection;
      lQuery.SQL.Text := lSQL;  

      lQuery.ExecSQL;
      Result := True;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao deletar registro da tabela '+ lTable + ': ' + E.Message);
      end;
    end;

  finally
    lQuery.Free;
  end;
end;


destructor TBaseDAO.Destroy;
begin
  FPropertiesToWhere.Free;
  inherited;
end;

function TBaseDAO.FindPrimaryKeyProperty(const pType: TRttiType) : TRttiProperty;
var
  lProperty: TRttiProperty;
begin

  Result := nil;
  for lProperty in pType.GetProperties do
  begin
    if lProperty.GetAttribute<TDBColumnAtrribute> is TDBColumnAtrribute then
    begin
      if lProperty.GetAttribute<TDBColumnAtrribute>.IsPrimaryKey then
      begin
        Result := lProperty;
        Exit;
      end;
    end;
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

procedure TBaseDAO.AddPropertyToWhere(const pPropertyName: string);
begin
  FPropertiesToWhere.Add(pPropertyName);
end;

function TBaseDAO.GetPropertiesToWhere: TStringList;
begin
  Result := FPropertiesToWhere;
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

function TBaseDAO.UpdateByText(const pObject: TObject; const pWhereClause: string = '') : Boolean;
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

function TBaseDAO.UpdateByPK(const pObject: TObject): Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty, lPk: TRttiProperty;
  lSQL, lSets, lTable: string;
  lQuery: TFDQuery;
  
begin

  Result := False;
  lContext := TRttiContext.Create;
  lQuery := TFDQuery.Create(nil);

  try
    lType := lContext.GetType(pObject.ClassType);

    // Verifica se a classe possui o atributo com o nome da tabela
    if not CheckTableAttribute(lType) then
    begin
      raise Exception.Create('Classe ' + lType.Name + ' está com o atributo TDBTable em branco ou inexistente!');
      exit;
    end;

    // Encontra a propriedade com o atributo Chave Primária (PrimaryKey)
    lPk := FindPrimaryKeyProperty(lType);

    if lPk = nil then
    begin
      raise Exception.Create('A classe ' + lType.Name + ' não possui uma propriedade marcada como Chave Primária!');
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
    lSQL := 'UPDATE ' + lTable + ' SET ' + lSets + ' WHERE '  +
      lPk.GetAttribute<TDBColumnAtrribute>.FieldName + ' = :' + lPk.Name;

    try
      lQuery.Connection := FConnection;
      lQuery.SQL.Text := lSQL;

      // Define parâmetros
      for lProperty in lType.GetProperties do
      begin
        if CheckColumnsAttribute(lProperty) then
        begin
          lQuery.Params.ParamByName(lProperty.Name).Value := GetParameterValue(pObject, lProperty);
        end;
      end;

      //  Parametro da PK
      lQuery.Params.ParamByName(lPk.Name).Value := GetParameterValue(pObject, lPk);

      lQuery.ExecSQL;
      Result := True;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao atualizar registro na tabela ' + lTable + E.Message);
      end;
    end;
    
  finally
    lContext.Free;
    lQuery.Free;
  end;

end;

function TBaseDAO.LoadObjectByPK(const pObject: TObject): Boolean;
var
  lContext: TRttiContext;
  lType: TRttiType;
  lProperty: TRttiProperty;
  lSQL, lTable: string;
  lQuery: TFDQuery;
  
begin

  Result := False;
  lContext := TRttiContext.Create;
  lQuery := TFDQuery.Create(nil);

  try
    lType := lContext.GetType(pObject.ClassType);

    // Verifica se a classe possui o atributo com o nome da tabela
    if not CheckTableAttribute(lType) then
    begin
      raise Exception.Create('Classe ' + lType.Name + ' está com o atributo TDBTable em branco ou inexistente!');
      exit;
    end;

    lQuery.Connection := FConnection;

    // Encontra a propriedade com o atributo Chave Primária (PrimaryKey)
    lProperty := FindPrimaryKeyProperty(lType);

    if lProperty = nil then
    begin
      raise Exception.Create('A classe ' + lType.Name + ' não possui uma propriedade marcada como Chave Primária!');
      exit;
    end;

    // Monta a consulta SQL de seleção
    lTable := lType.GetAttribute<TDBTable>.TableName;
    lSQL := 'SELECT * FROM ' + lTable + ' WHERE ' + lProperty.GetAttribute<TDBColumnAtrribute>.FieldName + ' = :' + lProperty.Name;

    // Executa a consulta SQL
    try
      lQuery.SQL.Add(lSQL);
      lQuery.Params.ParamByName(lProperty.Name).Value := GetParameterValue(pObject, lProperty);;
      lQuery.Open;

      // Atribui os valores das colunas às propriedades do objeto
      for lProperty in lType.GetProperties do
      begin
        if not lQuery.FieldByName(lProperty.Name).IsNull then
          lProperty.SetValue(pObject, TValue.FromVariant(lQuery.FieldByName(lProperty.Name).Value));
      end;

      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao executar a consulta SQL: ' + E.Message);
      end;
    end;

  finally
    lContext.Free;
    lQuery.Free;
  end;

end;

end.
