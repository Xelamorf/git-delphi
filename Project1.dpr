program Project1;



{$R *.dres}

uses
  Forms,
  Messages,
  Windows,
  ShellApi,
  SysUtils,
  Dialogs,
  ADODB,
  Variants,
  Controls,
  Classes,
  System.UITypes,
  Unit1 in 'Unit1.pas' {Main},
  Unit2 in 'Unit2.pas' {Utilities},
  Unit3 in 'Unit3.pas' {ClientDataEnter},
  Unit4 in 'Unit4.pas' {UniConnection},
  Unit5 in 'Unit5.pas' {About},
  Unit6 in 'Unit6.pas' {CreditDataEnter},
  Unit7 in 'Unit7.pas' {SelectWayConnect};

{$R *.res}
{$R electro.res} // electro.RC}   // RC - не обязательно
{$R CONNECT_STRONG.RES}

var S           : string;
    hCur        : Variant;

begin
 ReportMemoryLeaksOnShutdown := DebugHook <> 0;
 try
   try
     S := ExtractFileName(ParamStr(0));

      CurDir:=ExtractFilePath(ParamStr(0));
      S := ChangeFileExt(CurDir+S, '.udl');
      if not FileExists(S) then;
        //Raise Exception.CreateFmt('Отсутствует файл соединения с БД : ''%s''', [S]);

      Application.Initialize;
      Application.MainFormOnTaskbar := True;

      hCur := LoadANICursorStream('ELECTRO'); // RT_ANICURSOR
      if hCur<>0 then begin
        Screen.Cursors[crSQLWait]   := hCur;
        Screen.Cursors[crHourGlass] := hCur;
      end;

      Application.Title := 'Test_RD';
      Application.CreateForm(TForm1, Form1);
      Application.CreateForm(TForm5, Form5);
  finally S := ''; end;    // утечка памяти если не очистить..

 except on E:Exception do begin
  MessageDlg('Ошибка при старте: '+E.Message,mtError,[mbOk],0);
  Application.ShowMainForm := False;
  PostMessage(Application.Handle, WM_CLOSE, 0, 0);
 end;end;

 Application.Run;

end.
