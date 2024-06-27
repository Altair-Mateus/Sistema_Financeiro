unit SistemaFinanceiro.Utilitarios;

interface

uses
  Vcl.DBGrids,
  Vcl.Controls,
  Winapi.Windows,
  Vcl.Grids,
  System.SysUtils,
  System.Classes,
  System.JSON,
  Data.DB,
  System.Generics.Collections,
  System.IOUtils,
  System.JSON.Writers, System.JSON.Types;

type
  TUtilitario = class
    class function GetId: String;
    class function LikeFind(Pesquisa: String; Grid: TDBGrid): String;
    class function FormatoMoeda(Valor: Currency): String;
    class function FormatarValor(Valor: Currency; Decimais: Integer = 2) : string; overload;
    class function FormatarValor(Valor: String; Decimais: Integer = 2) : string; overload;
    class function TruncarValor(Valor: Currency; Decimais: Integer = 2) : Currency;
    class procedure KeyPressValor(Sender: TObject; var Key: Char);
    class procedure FormatoMoedaGrid(Grid: TDBGrid; Column: TColumn; Rect: TRect; State: TGridDrawState);
    class procedure SalvarOrdemColunasParaJSON(pGrid: TDBGrid; const pNomeArquivo: string; const pGridName: string);
    class procedure CarregarOrdemColunasJSON(pGrid: TDBGrid; const pNomeArquivo: string; const pGridName: string);
  end;

implementation

uses
  System.Math,
  Vcl.StdCtrls;

{ TUtilitario }
class function TUtilitario.FormatarValor(Valor: Currency;
  Decimais: Integer): string;
begin
  Valor := TruncarValor(Valor, Decimais);
  Result := FormatCurr('0.' + StringOfChar('0', Decimais), Valor);
end;


class procedure TUtilitario.SalvarOrdemColunasParaJSON(pGrid: TDBGrid; const pNomeArquivo: string; const pGridName: string);
var
  JSON: TJSONObject;
  GridJSONObject: TJSONObject;
  JSONArray: TJSONArray;
  ColumnData: TJSONObject;
  Column: TColumn;
  I: integer;
  JSONString: string;
begin
  JSON := TJSONObject.Create;
  try
    // Carregar JSON existente se houver
    if FileExists(pNomeArquivo + '.json') then
    begin
      JSONString := TFile.ReadAllText(pNomeArquivo + '.json', TEncoding.UTF8);
      JSON := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
      if not Assigned(JSON) then
        JSON := TJSONObject.Create;
    end;
    // Criar JSONArray para as colunas do grid atual
    JSONArray := TJSONArray.Create;
    for I := 0 to pGrid.Columns.Count - 1 do
    begin
      Column := pGrid.Columns[I];
      ColumnData := TJSONObject.Create;
      ColumnData.AddPair('FieldName', TJSONString.Create(Column.FieldName));
      ColumnData.AddPair('Width', TJSONNumber.Create(Column.Width));
      JSONArray.AddElement(ColumnData);
    end;
    // Adicionar ou substituir o grid específico no JSON principal
    GridJSONObject := TJSONObject.Create;
    GridJSONObject.AddPair('ColumnConfigs', JSONArray);
    if JSON.Values[pGridName] <> nil then
      JSON.RemovePair(pGridName).Free; // Remove o par existente antes de adicionar o novo
    JSON.AddPair(pGridName, GridJSONObject);
    // Formatar o JSON de maneira legível
    JSONString := JSON.Format(4); // Indentação de 4 espaços
    // Salvar o JSON formatado
    TFile.WriteAllText(pNomeArquivo + '.json', JSONString, TEncoding.UTF8);
  finally
    JSON.Free;
  end;
end;


class procedure TUtilitario.CarregarOrdemColunasJSON(pGrid: TDBGrid; const pNomeArquivo: string; const pGridName: string);
var
  JSON: TJSONObject;
  GridJSONObject: TJSONObject;
  JSONArray: TJSONArray;
  ColumnData: TJSONObject;
  ColumnIndex: integer;
  Column: TColumn;
  ColumnName: string;
  ColumnWidth: integer;
  ColumnsMap: TDictionary<string, TColumn>;
  JSONString: string;
begin
  if not FileExists(pNomeArquivo + '.json') then
    Exit;
  ColumnsMap := TDictionary<string, TColumn>.Create;
  try
    for ColumnIndex := 0 to pGrid.Columns.Count - 1 do
      ColumnsMap.Add(pGrid.Columns[ColumnIndex].FieldName, pGrid.Columns[ColumnIndex]);
    JSONString := TFile.ReadAllText(pNomeArquivo + '.json', TEncoding.UTF8);
    JSON := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
    if not Assigned(JSON) then
      Exit;
    try
      GridJSONObject := JSON.GetValue(pGridName) as TJSONObject;
      if not Assigned(GridJSONObject) then
        Exit;
      JSONArray := GridJSONObject.GetValue('ColumnConfigs') as TJSONArray;
      if not Assigned(JSONArray) then
        Exit;
      for ColumnIndex := 0 to JSONArray.Count - 1 do
      begin
        ColumnData := JSONArray.Items[ColumnIndex] as TJSONObject;
        if not Assigned(ColumnData) then
          Continue;
        ColumnName := ColumnData.GetValue('FieldName').Value;
        ColumnWidth := ColumnData.GetValue('Width').AsType<Integer>;
        if ColumnsMap.TryGetValue(ColumnName, Column) then
        begin
          Column.Index := ColumnIndex;
          Column.Width := ColumnWidth;
        end;
      end;
    finally
      JSON.Free;
    end;
  finally
    ColumnsMap.Free;
  end;
end;


class function TUtilitario.FormatarValor(Valor: String;
  Decimais: Integer): string;
var
  LValor: Currency;
begin
  LValor := 0;
  TryStrToCurr(Valor, LValor);
  Result := FormatarValor(LValor, Decimais);
end;

class function TUtilitario.FormatoMoeda(Valor: Currency): String;
begin
  Result := Format('%m', [Valor]);
end;

class procedure TUtilitario.FormatoMoedaGrid(Grid: TDBGrid; Column: TColumn;
  Rect: TRect; State: TGridDrawState);
var
  lDisplayText: string;
begin
  // Verifica se Column e Column.Field são válidos
  if Assigned(Column) and Assigned(Column.Field) then
  begin
    // Verifica se a coluna atual é uma das colunas de moeda
    if (Column.Field.DataType in [ftCurrency, ftFloat, ftBCD]) and
      (Column.Field.AsFloat <> 0) then
    begin
      // Formata o valor como moeda
      lDisplayText := FormatFloat('R$ #,##0.00', Column.Field.AsFloat);
      // Desenha a célula com a formatação personalizada
      Grid.Canvas.FillRect(Rect);
      Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, lDisplayText);
    end;
  end;

end;

class function TUtilitario.GetId: String;
begin
  Result := TGUID.NewGuid.ToString;
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

class procedure TUtilitario.KeyPressValor(Sender: TObject; var Key: Char);
begin
  // Se for digitado um ponto, será convertido para virgula
  if Key = FormatSettings.ThousandSeparator then
  begin
    Key := #0;
  end;

  // Permite apenas digitar os caracteres dentro do charinset
  if not(CharInSet(Key, ['0' .. '9', FormatSettings.DecimalSeparator, #8, #13]))
  then
  begin
    Key := #0;
  end;

  // Valida se já existe o ponto decimal
  if (Key = FormatSettings.DecimalSeparator) and
    (pos(Key, TEdit(Sender).Text) > 0) then
  begin
    Key := #0;
  end;

end;

class function TUtilitario.LikeFind(Pesquisa: String; Grid: TDBGrid): String;
var
  LContador: Integer;
begin
  Result := '';

  // Valida se a pesquisa veio vazia
  if Pesquisa.Trim.IsEmpty then
  begin
    exit;
  end;

  // Função upper converte a string em letras maiúsculas
  // Função QuotedStr trata o texto e o coloca dentro aspas simples
  // Função trim remove os espaços no início e fim do texto
  for LContador := 0 to Pred(Grid.Columns.Count) do
  begin
    if (Grid.Columns.Items[LContador].Field <> nil) and
       (Grid.Columns.Items[LContador].Field.DataType = ftWideString) then
    begin
      Result := Result + 'upper(trim(' + Grid.Columns.Items[LContador].FieldName
        + '))' + ' LIKE ' + QuotedStr('%' + AnsiUpperCase(Trim(Pesquisa)) +
        '%') + ' OR ';
    end;
  end;

  // Remove o último ' OR ' e encapsula a condição entre parênteses
  if not Result.IsEmpty then
    Result := ' AND (' + Copy(Result, 1, Length(Result) - 4) + ')';
end;

class function TUtilitario.TruncarValor(Valor: Currency; Decimais: Integer)
  : Currency;
var
  LFator: Double;
begin
  LFator := Power(10, Decimais);
  Result := Trunc(Valor * LFator) / LFator;
end;

end.
