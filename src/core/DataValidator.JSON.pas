{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataValidator.JSON;

interface

uses
  DataValidator.Intf, DataValidator.Result.Intf, DataValidator.Information.Intf, DataValidator.ItemBase.Intf, DataValidator.Context.Intf,
  DataValidator.JSON.Base, DataValidator.Information, DataValidator.ItemBase.Sanitizer, DataValidator.ItemBase,
  System.Generics.Collections, System.Rtti, System.JSON, System.SysUtils;

type
  TDataValidatorJSON = class(TInterfacedObject, IDataValidatorJSON, IDataValidatorJSONResult)
  private
    FJSON: TJSONObject;
    FList: TList<IDataValidatorJSONBaseContext>;

    function Check(const ACheckAll: Boolean): IDataValidatorResult;
  public
    function Validate(const AName: string): IDataValidatorJSONBaseContext;

    function Checked: IDataValidatorResult;
    function CheckedAll: IDataValidatorResult;

    constructor Create(const AJSON: TJSONObject);
    destructor Destroy; override;
  end;

implementation

{ TDataValidatorJSON }

constructor TDataValidatorJSON.Create(const AJSON: TJSONObject);
begin
  if not Assigned(AJSON) then
    raise Exception.Create('JSON is nil');

  FJSON := AJSON;
  FList := TList<IDataValidatorJSONBaseContext>.Create;
end;

destructor TDataValidatorJSON.Destroy;
begin
  FList.Clear;
  FList.DisposeOf;

  inherited;
end;

function TDataValidatorJSON.Validate(const AName: string): IDataValidatorJSONBaseContext;
var
  LJSONPair: TJSONPair;
begin
  LJSONPair := FJSON.Get(AName);

  FList.Add(TDataValidatorJSONBase.Create(Self, LJSONPair));
  Result := FList.Last;
end;

function TDataValidatorJSON.Checked: IDataValidatorResult;
begin
  Result := Check(False);
end;

function TDataValidatorJSON.CheckedAll: IDataValidatorResult;
begin
  Result := Check(True);
end;

function TDataValidatorJSON.Check(const ACheckAll: Boolean): IDataValidatorResult;
  function ValueString(const AValue: TValue): string;
  var
    LJSONPair: TJSONPair;
  begin
    Result := '';

    if AValue.IsType<TJSONPair> then
    begin
      LJSONPair := AValue.AsType<TJSONPair>;

      if Assigned(LJSONPair) then
        Result := LJSONPair.JsonValue.Value;
    end
    else
      Result := AValue.AsString;
  end;

var
  LOK: Boolean;
  LInfo: IDataValidatorInformations;
  I: Integer;

  LListValidatorItem: TList<IDataValidatorItem>;
  LValidatorItem: IDataValidatorItem;
  LValueSanitizer: TValue;

  J: Integer;
  LValidatorResult: IDataValidatorResult;
  LValues: TArray<string>;
begin
  LOK := True;
  LInfo := TDataValidatorInformations.Create;

  for I := 0 to Pred(FList.Count) do
  begin
    LListValidatorItem := (FList.Items[I] as IDataValidatorContextBase<IDataValidatorItem>).GetItem;
    LValueSanitizer := (FList.Items[I] as IDataValidatorContextBase<IDataValidatorItem>).GetValue;

    for J := 0 to Pred(LListValidatorItem.Count) do
    begin
      LValidatorItem := LListValidatorItem.Items[J];

      if (LValidatorItem is TDataValidatorItemBaseSanitizer) then
      begin
        LValidatorItem.SetValue(LValueSanitizer);
        LValueSanitizer := (LValidatorItem as TDataValidatorItemBaseSanitizer).Sanitize;
        Continue;
      end;

      LValidatorItem.SetValue(LValueSanitizer);

      LValidatorResult := LValidatorItem.Checked;

      if not LValidatorResult.OK then
      begin
        LOK := False;
        LInfo.Add(LValidatorResult.Informations as IDataValidatorInformations);

        if not ACheckAll then
          Break;
      end;
    end;

    LValues := Concat(LValues, [ValueString(LValueSanitizer)]);

    if not LOK then
      if not ACheckAll then
        Break;
  end;

  Result := TDataValidatorResult.Create(LOK, LInfo, LValues);
end;

end.
