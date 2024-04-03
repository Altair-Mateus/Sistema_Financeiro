unit uDBColumnAttribute;

interface

uses

  System.SysUtils;

type
  TDBColumnAtrribute = class(TCustomAttributeClass)
  private
    FIsPrimaryKey: Boolean;
    FIsAutoIncrement: Boolean;
    FFieldName: string;

    public
      constructor Create(const AFieldName: string; AIsPrimaryKey: Boolean = False; AIsAutoIncrement: Boolean = False);
      property FieldName: string read FFieldName;
      property IsPrimaryKey: Boolean read FIsPrimaryKey;
      property IsAutoIncrement: Boolean read FIsAutoIncrement;
  end;

implementation

{ TDBColumnAtrribute }

constructor TDBColumnAtrribute.Create(const AFieldName: string; AIsPrimaryKey,
  AIsAutoIncrement: Boolean);
begin
  FFieldName       := AFieldName;
  FIsPrimaryKey    := AIsPrimaryKey;
  FIsAutoIncrement := AIsAutoIncrement;
end;

end.
