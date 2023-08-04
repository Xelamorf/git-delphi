unit Unit7;

interface

uses  //SelectWayConnect
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DB, ADODB, Menus;

type
  TWayConnect = (wcUDL, wcINI, wcReg, wcEXE, wcHandMake);

  TForm7 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Splitter1: TSplitter;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    ADOConnection1: TADOConnection;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Timer1: TTimer;
    ADOCommand1: TADOCommand;
    BitBtn5: TBitBtn;
    PopupMenu1: TPopupMenu;
    ExecCreateNewDB1: TMenuItem;
    procedure RadioGroup1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure ExecCreateNewDB1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ConStr : string;
    WayOfConnect : TWayConnect;
  end;

var
  Form7: TForm7;
  WayConnectStr   : array [TWayConnect] of String = ('UDL', 'INI', 'REG', 'EXE', 'HANDMAKE');
  WayConnectType  : array [TWayConnect] of TWayConnect = (wcUDL, wcINI, wcReg, wcEXE, wcHandMake);

implementation
uses Unit2, AdoConEd, Registry, IniFiles;
{$R *.dfm}

function LoadIniConnectStr(out AWayOfConnect : TWayConnect) : string;
var WayConnectEn : TWayConnect;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0))+ExtractFileName(ChangeFileExt(ParamStr(0), '.INI'))) do
  begin
    Result := AnsiUpperCase(ReadString('Global','WayOfConnect','EmptyStr'));
    if Result = 'EMPTYSTR' then begin
      Result := WayConnectStr[Low(TWayConnect)];
      WriteString('Global','WayOfConnect',Result);
      UpdateFile;
    end;

    for WayConnectEn in WayConnectType do   //if Assigned(QueryesEn)
     if Result = WayConnectStr[WayConnectEn] then
      begin
       AWayOfConnect := WayConnectEn;
       break;
      end;
    Result := ReadString('Global','ConnectionString','EmptyStr');
    Free;
  end;
end;

function LoadResConnectStr : string;
var
  ResStream : TResourceStream;
  s         : ansistring;
begin
 Result:='';
 try try
    ResStream := TResourceStream.Create(hInstance, 'STRONG', 'CONNECT');
    SetString(s, PAnsiChar(ResStream.Memory), ResStream.Size);
    Result:=s;
  finally ResStream.Free; end; //MWriteLn('>ReadConnection: '+SysErrorMessage(GetLastError));end;
 except on E: Exception do begin MWriteLn('>ResError: '+E.Message); Result:=''; end; end
end;

function LoadRegConnectStr : string;
var Reg: TRegistry;
begin
  Result:='';
  Reg := TRegistry.Create(KEY_ALL_ACCESS);//KEY_ALL_ACCESS. KEY_QUERY_VALUE
 try
   Reg.RootKey := HKEY_CURRENT_USER; //HKEY_LOCAL_MACHINE;
   if Reg.OpenKey('\Software\KaSSoR\', True) then begin
     Result:=Reg.ReadString('ConnectionString');
     Reg.CloseKey; end;
  finally Reg.Free; end;
//HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper\ImagePath
end;

procedure TForm7.BitBtn3Click(Sender: TObject);
var cs : string;
begin
 ADOConnection1.ConnectionString := Memo1.Lines.Text;
 try try
  ADOConnection1.Connected := true;
  if ADOConnection1.Connected then begin
    MessageDlg('Успех!',mtInformation,[mbOk],0); // хорошо бы проверить и наличие таблиц с ХП
    cs := ADOConnection1.ConnectionString;
    cs := StringReplace(cs, ';', ';'#13#10, [rfReplaceAll, rfIgnoreCase]);
    Memo1.Lines.Text := cs;
  end;
 finally
  ADOConnection1.Connected := false;
 end;
 except on E:Exception do begin
  MessageDlg('Ошибка при коннекте: '+E.Message,mtError,[mbOk],0);
 end;end;
end;

procedure TForm7.RadioGroup1Click(Sender: TObject);
var cs, fn : string;
begin
 Memo1.Lines.Clear;
 with Sender as TRadioGroup do
  case ItemIndex of
    0: begin
        fn := ExtractFilePath(ParamStr(0))+ExtractFileName(ChangeFileExt(ParamStr(0), '.UDL'));
        if FileExists(fn) then begin
          Memo1.Lines.Text := 'FILE NAME='+fn;
        end;
       end;
    1: begin
          cs := LoadIniConnectStr(WayOfConnect);
          cs := StringReplace(cs, ';', ';'#13#10, [rfReplaceAll, rfIgnoreCase]);
          Memo1.Lines.Text := cs;
       end;
    2: begin
          cs := LoadRegConnectStr;
          cs := StringReplace(cs, ';', ';'#13#10, [rfReplaceAll, rfIgnoreCase]);
          Memo1.Lines.Text := cs;
       end;
    3: begin
          cs := LoadResConnectStr;
          cs := StringReplace(cs, ';', ';'#13#10, [rfReplaceAll, rfIgnoreCase]);
          Memo1.Lines.Text := cs;
     end;
    4: begin
          EditConnectionString(ADOConnection1);
          cs := ADOConnection1.ConnectionString;
          cs := StringReplace(cs, ';', ';'#13#10, [rfReplaceAll, rfIgnoreCase]);
          Memo1.Lines.Text := cs;
      end;
   end;
end;

procedure TForm7.BitBtn4Click(Sender: TObject);
var cs : string;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0))+ExtractFileName(ChangeFileExt(ParamStr(0), '.INI'))) do
  begin
      cs := Memo1.Lines.Text;
      cs := StringReplace(cs, ';'#13#10, ';', [rfReplaceAll, rfIgnoreCase]);
      WriteString('Global','ConnectionString',cs);
      WriteString('Global','WayOfConnect',WayConnectStr[TWayConnect(RadioGroup1.ItemIndex)]);
      UpdateFile;
      Free;
      ConStr := cs;
  end;
end;

procedure TForm7.Timer1Timer(Sender: TObject);
begin
 (Sender as Ttimer).Enabled := false;
 PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TForm7.FormMouseEnter(Sender: TObject);
begin
 Timer1.Enabled := false;
end;

procedure TForm7.BitBtn5Click(Sender: TObject);
begin // нельзя в одном Sql-пакете строить базу и добавлять ХП-шки
 if MessageDlg('Are you sure?',mtConfirmation,[mbOK,mbCancel],0)<>mrOk then Exit;
 //Memo1.Lines.LoadFromFile('Create_DB_Test.sql');
 Memo1.Lines.Text := ADOCommand1.CommandText;
end;

procedure TForm7.ExecCreateNewDB1Click(Sender: TObject);
begin // отложено
 if MessageDlg('Are you sure?',mtConfirmation,[mbOK,mbCancel],0)=mrOk then ADOCommand1.Execute;
end;

procedure TForm7.FormCreate(Sender: TObject);
var cs : string;
begin
  ConStr := '';
  cs := LoadIniConnectStr(WayOfConnect);
  if cs <> 'EmptyStr' then begin
    ConStr := cs;
    Timer1.Enabled := true;
  end;

  RadioGroup1.ItemIndex := Ord(WayOfConnect);
  RadioGroup1.OnClick := RadioGroup1Click;
  if WayOfConnect <> wcHandMake then RadioGroup1Click(RadioGroup1);
end;

End.
