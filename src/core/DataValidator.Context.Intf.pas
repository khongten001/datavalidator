{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataValidator.Context.Intf;

interface

uses
  DataValidator.Types, DataValidator.ItemBase.Intf,
  System.Generics.Collections, System.Rtti;

type
  IDataValidatorSchemaContext = interface
    ['{B282DFB4-FDDC-424C-8C76-C8265822C79B}']
  end;

  IDataValidatorContextMessage<T> = interface
    ['{54CF9567-25E9-4B1A-A62B-7F270E5351E2}']
    function WithMessage(const AMessage: string): T; overload;
    function WithMessage(const AMessage: string; const AParams: array of const): T; overload;
    function Execute(const AExecute: TDataValidatorInformationExecute): T;
  end;

  IDataValidatorContextSanitizer<T> = interface(IDataValidatorContextMessage<T>)
    ['{80BCAFBF-2BBB-46FA-9C39-E7CC7D188350}']
    function CustomSanitizer(const ASanitizerItem: IDataSanitizerItem): T; overload;
    function CustomSanitizer(const AExecute: TDataValidatorCustomSanitizerExecute): T; overload;
    function NormalizeEmail(const AAllLowercase: Boolean = True; const AGmailRemoveDots: Boolean = True): T;
    function OnlyNumbers(): T;
    function RemoveAccents(): T;
    function Replace(const AOldValue: string; const ANewValue: string): T;
    function ToBase64Decode(): T;
    function ToBase64Encode(): T;
    function ToDate(const AJSONISO8601ReturnUTC: Boolean = True): T;
    function ToDateTime(const AJSONISO8601ReturnUTC: Boolean = True): T;
    function ToHTMLDecode(): T;
    function ToHTMLEncode(): T;
    function ToInteger(): T;
    function ToLowerCase(): T;
    function ToMD5(): T;
    function ToNumeric(): T;
    function ToTime(const AJSONISO8601ReturnUTC: Boolean = True): T;
    function ToUpperCase(): T;
    function ToURLDecode(): T;
    function ToURLEncode(): T;
    function Trim(): T;
    function TrimLeft(): T;
    function TrimRight(): T;
  end;

  IDataValidatorContextValidator<T> = interface(IDataValidatorContextSanitizer<T>)
    ['{F61EA315-86CA-4807-B1A1-F9030FADB844}']
    function CustomValue(const ADataItem: IDataValidatorItem): T; overload;
    function CustomValue(const AExecute: TDataValidatorCustomExecute): T; overload;
    function Contains(const AValueContains: string; const ACaseSensitive: Boolean = False): T;
    function IsAlpha(const ALocaleLanguage: TDataValidatorLocaleLanguage = tl_en_US): T;
    function IsAlphaNumeric(const ALocaleLanguage: TDataValidatorLocaleLanguage = tl_en_US): T;
    function IsBase64(): T;
    function IsBetween(const AValueA: Integer; const AValueB: Integer): T; overload;
    function IsBetween(const AValueA: Int64; const AValueB: Int64): T; overload;
    function IsBetween(const AValueA: Double; const AValueB: Double): T; overload;
    function IsBetween(const AValueA: Extended; const AValueB: Extended): T; overload;
    function IsBetween(const AValueA: Single; const AValueB: Single): T; overload;
    function IsBetween(const AValueA: UInt64; const AValueB: UInt64): T; overload;
    function IsBTCAddress(): T;
    function IsCEP(): T;
    function IsCNPJ(): T;
    function IsCPF(): T;
    function IsCPFCNPJ(): T;
    function IsDate(const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsDateBetween(const AValueA: TDate; const AValueB: TDate; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsDateEquals(const ACompareDate: TDate; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsDateGreaterThan(const ACompareDate: TDate; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsDateLessThan(const ACompareDate: TDate; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsDateTime(const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsEmail(): T;
    function IsEmpty(): T;
    function IsEquals(const AValueEquals: string; const ACaseSensitive: Boolean = False): T;
    function IsEthereumAddress(): T;
    function IsGreaterThan(const AValueGreaterThan: Integer): T;
    function IsHexadecimal(): T;
    function IsInteger(): T;
    function IsIP(): T;
    function IsJSON(): T;
    function IsLength(const AMin: Integer; const AMax: Integer): T;
    function IsLessThan(const AValueLessThan: Integer): T;
    function IsLowercase(): T;
    function IsMACAddress(): T;
    function IsMD5(): T;
    function IsNegative(): T;
    function IsNumeric(): T;
    function IsPhoneNumber(const ALocaleLanguage: TDataValidatorLocaleLanguage = tl_en_US): T;
    function IsPositive(): T;
    function IsSSN(): T;
    function IsTime(const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsTimeBetween(const AValueA: TTime; const AValueB: TTime; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsTimeEquals(const ACompareTime: TTime; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsTimeGreaterThan(const ACompareTime: TTime; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsTimeLessThan(const ACompareTime: TTime; const AJSONISO8601ReturnUTC: Boolean = True): T;
    function IsUppercase(): T;
    function IsURL(): T;
    function IsUUID(): T;
    function IsUUIDv1(): T;
    function IsUUIDv2(): T;
    function IsUUIDv3(): T;
    function IsUUIDv4(): T;
    function IsUUIDv5(): T;
    function IsZero(): T;

    function &Not(): T;
  end;

  IDataValidatorContextSchema<T> = interface(IDataValidatorContextValidator<T>)
    ['{01249950-D03B-4A14-BBE7-DB820FE1917E}']
    function AddSchema(const ASchema: IDataValidatorSchemaContext): T;
  end;

  IDataValidatorContext<T> = interface(IDataValidatorContextSchema<T>)
    ['{990209EE-C2A5-4C95-AE82-30277DF40B35}']
  end;

  IDataValidatorContextBase<T> = interface(IDataValidatorContext<T>)
    ['{990209EE-C2A5-4C95-AE82-30277DF40B35}']
    function GetItem(): TList<IDataValidatorItem>;
    function GetValue(): TValue;
  end;

implementation

end.
