unit Unit2;  // Utlities

interface
uses Classes, Variants, Messages, Controls, Forms, ADODB, Dialogs, ShellApi, Windows, SysUtils;

procedure AssignADOQuery(Dest, Source: TADOQuery);
procedure SaveCompToFile(RootObject: TComponent; const FileName: TFileName);
function GetADOQueryKa(const ASQL : String = ''; AQuery : TADOQuery = nil) : TADOQuery;
function GetADOCommand(const ASQL : String = ''; AQuery : TADOQuery = nil) : TADOCommand;
function GetSysErrorMessage(const ACode: DWORD; const AFN: String = ''): String;
function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
function LoadANICursorStream(lpName : PWideChar): HICON;
function LoadCursorRes(lpName, lpType: PWideChar): HICON;
procedure MWriteLn(AStr:string; T:boolean=false);
function GetFIO : string;
function GetWord : string;

implementation
uses Unit1, TypInfo;

procedure MWriteLn(AStr:string; T:boolean=false);
var PStr      : PChar;
    AStrANSI  : ansistring;
begin
 if T then AStr:=#13#10'['+TimeToStr(Time)+']:>'+AStr else Astr:=#32+Astr;
 if(Assigned(Form1)and Assigned(Form1.Memo1))then Form1.Memo1.Lines.Add(AStr);
//{$IFDEF VER220}
  AStrANSI := WideStringToString(AStr, 1251);
  AStrANSI:=AStrANSI+#13#10; PStr:=PChar(AStrANSI);
//{$ELSE}//  AStr:=Astr+#13#10; PStr:=PChar(AStr); // PStr:=@AStr[1];//{$ENDIF}
 if Assigned(FF)then begin FF.WriteBuffer(PStr^,Length(AStr)); FlushFileBuffers(FF.Handle); end;
end;

procedure SaveCompToFile(RootObject: TComponent; const FileName: TFileName);
var
  FileStream: TFileStream;
  MemStream: TMemoryStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  MemStream := TMemoryStream.Create;
  try
    MemStream.WriteComponent(RootObject);
    MemStream.Position := 0;
    ObjectBinaryToText(MemStream, FileStream);
  finally
    MemStream.Free;
    FileStream.Free;
  end;
end;

procedure AssignADOQuery(Dest, Source: TADOQuery);
  var
    Src, Dst: PPropList;
    i, nSrc: Integer;
    s: string;
begin
      GetPropList(Dest, Dst);
      try
        nSrc := GetPropList(Source, Src);
        try
          for i := 0 to nSrc - 1 do
            try
              s := Src[i]^.Name;
              case Src[i]^.PropType^^.Kind of
              tkClass:
                if s <> 'CursorLocation' then
                  SetObjectProp(Dest, s, GetObjectProp(Source, s));
              tkMethod:
                SetMethodProp(Dest, s, GetMethodProp(Source, s));
              else
                if s <> 'Name' then
                  SetPropValue(Dest, s, GetPropValue(Source, s));
              end;
            except
            end
        finally
          FreeMem(Src);
        end;
      finally
        FreeMem(Dst);
      end;
end;

function GetADOQueryKa(const ASQL : String = ''; AQuery : TADOQuery = nil) : TADOQuery;
begin
   Result := nil; if not Assigned(AQuery) then Exit;
   Result := TADOQuery.Create(nil);
  with Result do try
    Connection:=AQuery.Connection;
    CursorLocation:=clUseServer; // for PRINT too
    CursorType:=ctOpenForwardOnly;
    LockType:=ltReadOnly;
   if ASQL<>''then
    begin SQL.Text:=ASQL; Open;
      with AQuery do begin
       DisableControls;
       Active := false; // contra Refresh   go to first record
       Active := true;
       Last;            // можно запомнить рекорд, но учитывать потенциальное удаление
       EnableControls;  // GetBookmark -> FreeBookmark
      end;
    end;
  except
    FreeAndNil(Result); raise;
  end;
end;

// изолированное подключение для выполнений Exec.
function GetADOCommand(const ASQL : String = ''; AQuery : TADOQuery = nil) : TADOCommand;
begin
  Result := nil; if not Assigned(AQuery) then Exit;
  Result := TADOCommand.Create(nil);
  with Result do try
   ConnectionString:=AQuery.Connection.ConnectionString; //Connection:=AQuery.Connection;
   ExecuteOptions:=[eoAsyncExecute]+[eoExecuteNoRecords];
   CommandTimeOut:=30;
   ParamCheck:=false;
   Prepared:=false;
   if ASQL<>''then begin CommandText:=ASQL; Execute; end;
  except
    FreeAndNil(Result); raise;
  end;
end;

function LoadCursorRes(lpName, lpType: PWideChar): HICON;
var
  hResInfo, hResData: HRSRC;
  dwResSize : DWORD;
  lpBuffer  : PByte;
begin
  Result     := 0;
  hResInfo   := FindResource(HInstance, lpName, lpType);
  if hResInfo <> 0 then
  begin
    dwResSize    := SizeOfResource(HInstance, hResInfo);
    if dwResSize <> 0 then
    begin
      hResData   := LoadResource(HInstance, hResInfo);
      if hResData <> 0 then
      try
        lpBuffer := LockResource(hResData);
        if Assigned(lpBuffer) then
        try
          //Result := CreateIconFromResource(lpBuffer, dwResSize, False, $00030000);
          Result := CreateIconFromResourceEx(lpBuffer, dwResSize, False, $00030000, 0,0, LR_DEFAULTCOLOR or LR_DEFAULTSIZE or LR_SHARED);  //LR_SHARED
          if Result = 0 then
            OutputDebugString(PChar(GetSysErrorMessage(GetLastError)));
        finally
          UnlockResource(hResData);
        end;
      finally
        FreeResource(hResData);
      end
      else
        OutputDebugString(PChar(GetSysErrorMessage(GetLastError)));
    end
    else
      OutputDebugString(PChar(GetSysErrorMessage(GetLastError)));
  end
  else
    OutputDebugString(PChar(GetSysErrorMessage(GetLastError)));
end;

function LoadANICursorStream(lpName : PWideChar): HICON;
var
  res: TCustomMemoryStream;
begin
  Result := 0;
  try
    res := TResourceStream.Create(MainInstance, 'ELECTRO', RT_ANICURSOR);
    //Result := CreateIconFromResource(res.Memory, res.Size, False, $30000);  // не работает в Win7 (((
    res.SaveToFile('Electro.tmp');
    Result := LoadCursorFromFile(PChar('Electro.tmp'));
    DeleteFile('Electro.tmp'); //Win32Check(Result <> 0);
  finally
    res.Free;
  end;

  if Result = 0 then
    OutputDebugString(PChar(GetSysErrorMessage(GetLastError)));
end;

function GetSysErrorMessage(const ACode: DWORD; const AFN: String = ''): String;
begin
  if AFN = '' then
    Result := Format('Произошла ошибка с кодом %d (%s). SysErrorMessage: "%s".', [ACode, IntToHex(ACode, 8), SysErrorMessage(ACode)])
  else
    Result := Format('Произошла ошибка с кодом %d (%s) при работе с файлом "%s". SysErrorMessage: "%s".', [ACode, IntToHex(ACode, 8), ExtractFileName(AFN), SysErrorMessage(ACode)]);
end;

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], -1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], -1, @Result[1], l - 1, nil, nil);
  end;
end;

function UpCaseRus(ch: Char): Char;
{Перевод символа в верхний регистр для русского алфавита}
asm
CMP AL,'а'
JB @@exit
CMP AL,'z'
JA @@Rus
SUB AL,'a' - 'A'
RET
@@Rus:
CMP AL,'я'
JA @@Exit
CMP AL,'а'
JB @@yo
SUB AL,'я' - 'Я'
RET
@@yo:
CMP AL,'ё' // эта хрень, типа ё/Ё
JNE @@exit
MOV AL,'Ё'
@@exit:
end;

function LoCaseRus( ch : Char ) : Char;
{Перевод символа в нижний регистр для русского алфавита}
asm
CMP AL,'A'
JB @@exit
CMP AL,'Z'
JA @@Rus
ADD AL,'a' - 'A'
RET
@@Rus:
CMP AL,'Я'
JA @@Exit
CMP AL,'А'
JB @@yo
ADD AL,'я' - 'Я'
RET
@@yo:
CMP AL,'Ё'
JNE @@exit
MOV AL,'ё'
@@exit:
end;

function Generator_Sloga : string; //возвращает только один случайный слог
 const Slogi : array[0..372] of string = (
  'НА',   'НУ',   'НО',   'НЫ',   'НИ',   'НЕ',   'НЯ',   'НЁ',   'НЮ',   'НЭ',   'НЬ',
  'МА',   'МУ',   'МО',   'МЫ',   'МИ',   'МЕ',   'МЯ',   'МЁ',   'МЮ',   'МЭ',   'МЬ',
  'ТА',   'ТУ',   'ТО',   'ТЫ',   'ТИ',   'ТЕ',   'ТЯ',   'ТЁ',   'ТЮ',   'ТЭ',   'ТЬ',
  'КА',   'КУ',   'КО',   'КИ',   'КЕ',   'КЁ',   'КЭ',   'КЬ',   'ХА',   'ХУ',   'ХО',
  'ХИ',   'ХЕ',   'ХЭ',   'ХЬ',   'БА',   'БУ',   'БО',   'БЫ',   'БИ',   'БЕ',   'БЯ',
  'БЁ',   'БЮ',   'БЭ',   'БЬ',   'ВА',   'ВУ',   'ВО',   'ВЫ',   'ВИ',   'ВЕ',   'ВЯ',
  'ВЁ',   'ВЮ',   'ВЭ',   'ВЬ',   'ГА',   'ГУ',   'ГО',   'ГИ',   'ГЕ',   'ГЁ',   'ГЭ',
  'ГЬ',   'ДА',   'ДУ',   'ДО',   'ДЫ',   'ДИ',   'ДЕ',   'ДЯ',   'ДЁ',   'ДЮ',   'ДЭ',
  'ДЬ',   'ЖА',   'ЖУ',   'ЖО',   'ЖИ',   'ЖЕ',   'ЖЁ',   'ЖЬ',   'ЗА',   'ЗУ',   'ЗО',
  'ЗЫ',   'ЗИ',   'ЗЕ',   'ЗЯ',   'ЗЁ',   'ЗЮ',   'ЗЭ',   'ЗЬ',   'ЛА',   'ЛУ',   'ЛО',
  'ЛЫ',   'ЛИ',   'ЛЕ',   'ЛЯ',   'ЛЁ',   'ЛЮ',   'ЛЭ',   'ЛЬ',   'ПА',   'ПУ',   'ПО',
  'ПЫ',   'ПИ',   'ПЕ',   'ПЯ',   'ПЁ',   'ПЮ',   'ПЭ',   'ПЬ',   'РА',   'РУ',   'РО',
  'РЫ',   'РИ',   'РЕ',   'РЯ',   'РЁ',   'РЮ',   'РЭ',   'РЬ',   'СА',   'СУ',   'СО',
  'СЫ',   'СИ',   'СЕ',   'СЯ',   'СЁ',   'СЮ',   'СЭ',   'СЬ',   'ФА',   'ФУ',   'ФО',
  'ФЫ',   'ФИ',   'ФЕ',   'ФЯ',   'ФЁ',   'ФЮ',   'ФЭ',   'ФЬ',   'ЦА',   'ЦУ',   'ЦО',
  'ЦЫ',   'ЦИ',   'ЦЕ',   'ЧА',   'ЧУ',   'ЧО',   'ЧИ',   'ЧЕ',   'ЧЁ',   'ЧЬ',   'ША',
  'ШУ',   'ШО',   'ШИ',   'ШЕ',   'ШЁ',   'ШЬ',   'ЩА',   'ЩУ',   'ЩО',   'ЩИ',   'ЩЕ',
  'ЩЁ',   'ЩЬ',   'ЙА',   'ЙО',   'ЙИ',   'ЙЕ',   'ЙЮ',   'АМ',
  'АН',   'УН',   'ОН',   'ЫН',   'ИН',   'ЕН',   'ЯН',   'НЁ',   'ЮН',   'ЭН',
  'АМ',   'УМ',   'ОМ',   'ЫМ',   'ИМ',   'ЕМ',   'ЯМ',   'ЁМ',   'ЮМ',   'ЭМ',
  'АТ',   'УТ',   'ОТ',   'ЫТ',   'ИТ',   'ЕТ',   'ЯТ',   'ЁТ',   'ЮТ',   'ЭТ',
  'АК',   'УК',   'ОК',   'ИК',   'ЕК',   'ЁК',   'ЭК',   'АХ',   'УХ',   'ОХ',
  'ИХ',   'ХЕ',   'ХЭ',   'ХЬ',   'БА',   'БУ',   'БО',   'БЫ',   'БИ',   'БЕ',   'ЯБ',
  'ЁБ',   'ЮБ',   'ЭБ',   'ВА',   'УВ',   'ОВ',   'ЫВ',   'ИВ',   'ЕВ',   'ЯВ',
  'ЁВ',   'ЮВ',   'ЭВ',   'ГА',   'УГ',   'ОГ',   'ИГ',   'ЕГ',   'ЁГ',   'ЭГ',
  'АД',   'УД',   'ОД',   'ЫД',   'ИД',   'ЕД',   'ЯД',   'ЁД',   'ЮД',   'ЭД',
  'АЖ',   'УЖ',   'ОЖ',   'ИЖ',   'ЕЖ',   'ЁЖ',   'АЗ',   'УЗ',   'ОЗ',
  'ЫЗ',   'ИЗ',   'ЕЗ',   'ЯЗ',   'ЁЗ',   'ЮЗ',   'ЭЗ',   'АЛ',   'УЛ',   'ОЛ',
  'ЫЛ',   'ИЛ',   'ЕЛ',   'ЯЛ',   'ЁЛ',   'ЮЛ',   'ЭЛ',   'АП',   'УП',   'ОП',
  'ЫП',   'ИП',   'ЕП',   'ЯП',   'ЁП',   'ЮП',   'ЭП',   'АР',   'УР',   'ОР',
  'ЫР',   'ИР',   'ЕР',   'ЯР',   'ЁР',   'ЮР',   'ЭР',   'АС',   'УС',   'ОС',
  'ЫС',   'ИС',   'ЕС',   'ЯС',   'ЁС',   'ЮС',   'ЭС',   'АФ',   'УФ',   'ОФ',
  'ЫФ',   'ИФ',   'ЕФ',   'ЯФ',   'ЁФ',   'ЮФ',   'ЭФ',   'АЦ',   'УЦ',   'ОЦ',
  'ЦЫ',   'ЦИ',   'ЦЕ',   'ЧА',   'ЧУ',   'ЧО',   'ЧИ',   'ЧЕ',   'ЧЁ',   'ЧЬ',   'ША',
  'УШ',   'ОШ',   'ИШ',   'ЕШ',   'ЁШ',   'АЩ',   'УЩ',   'ОЩ',   'ИЩ',   'ЕЩ',
  'ЁЩ',   'АЙ',   'ОЙ',   'ИЙ',   'ЕЙ',   'ЮЙ',   'МА'
  );
var Len : integer;
begin
  Len := SizeOf(Slogi) div Sizeof(Slogi[0]);
  Result := Slogi[Round(Random() * Len)];
end;

function Sluchainiy_Simbol : string ; //возвращает случайно выбранный из заданного алфавита символ
  const Bukwi : string = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЫЭЮЯ';
        N : integer = 100;
        K : integer = 0; //Чем ближе к 100 - тем чаще длинее и тем трудновыговариваемее фамилии могут появиться
  var   s : string;
        x : integer;
begin
    x := N - Round(Random()* N) + 1;
    if (x<=K) then s := Bukwi[Round(Random() * SizeOf(Bukwi)) - 1];
    Result := s;
end;

function GetFIO : string;
var i,j,k : integer;
    s     : string;
begin  //setlocale(LC_ALL,"");
    Result := ''; s := '';
    for j := 0 to 2 do begin
      for i := 0 to (Round(Random() * 5) + 1) do begin
        s := s + Generator_Sloga();
        for k := 0 to 1  do s := s + Sluchainiy_Simbol();
      end;
      s := AnsiLowerCase(s);
      s[1] := AnsiUpperCase(s)[1];
      Result := Result + s; s := '';
      if j < 2  then Result := Result + ' ';
    end;
end;

function GetWord : string;
var i,k : integer;
begin  //setlocale(LC_ALL,"");
    Result := '';
      for i := 0 to (Round(Random() * 5) + 1) do begin
        Result := Result + Generator_Sloga();
        for k := 0 to 1  do Result := Result + Sluchainiy_Simbol();
      end;
      Result := AnsiLowerCase(Result);
      Result[1] := AnsiUpperCase(Result)[1];   // не ругатьсо )
end;

Initialization
  Randomize;
End.

{
CreateIconFromResourceEx(
    PBYTE pbIconBits,
    DWORD cbIconBits,
    BOOL fIcon,
    DWORD dwVersion,
    int cxDesired,
    int cyDesired,
    UINT uFlags
)

}
