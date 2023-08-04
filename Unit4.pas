unit Unit4;

interface
uses Windows, Classes, ADODB;

type
 TQueryesEn = (qStandalone, qClients, qCredits);
 //для ловли "неуловимых" ошибок и принтов
 TADS = class(TADOConnection)
    Query : TADOQuery; // для общего абстрактного пользования и короткого доступа.
    procedure ADConnectComplete(Connection: TADOConnection; const Error: Error; var EventStatus: TEventStatus);
    procedure ADInfoMessage(Connection: TADOConnection; const Error: Error; var EventStatus: TEventStatus);    procedure ADAfterConnect(Sender: TObject);    procedure ADAfterDisconnect(Sender: TObject);    procedure ADExecuteComplete(Connection: TADOConnection; RecordsAffected: Integer;      const Error: Error; var EventStatus: TEventStatus;      const Command: _Command; const Recordset: _Recordset);  private    FCS: TRTLCriticalSection;  public
    Queryes : array [TQueryesEn] of TADOQuery;
    constructor Create(AOwner: TComponent; ACS : string); virtual; //override;
    destructor  Destroy; override;
  end;

var ADS: TADS = nil;

implementation
uses SysUtils, Dialogs, Unit2;

resourcestring
  SBadParams      = '%s: Неверные параметры вызова.';

constructor TADS.Create(AOwner: TComponent; ACS : string);
var  QueryesEn  : TADOQuery;
     QueryesEnI : TQueryesEn;
begin
 InitializeCriticalSection(FCS); // полезно при асинхронном доступе, многопоточности, принтах из ХП и т.д.
 inherited Create(AOwner);
 ConnectionString:=ACS;
 LoginPrompt:=false;

  for QueryesEnI:= Low(TQueryesEn) to High(TQueryesEn) do
   begin
    Queryes[QueryesEnI]:= TADOQuery.Create(nil);
    Queryes[QueryesEnI].Tag := Ord(QueryesEnI);
   end;

  for QueryesEn in Queryes do   //if Assigned(QueryesEn)
   with QueryesEn do begin
    Name := 'ADQ_Ex_' + IntToStr(Tag);
    Connection := Self;
    CursorLocation:=clUseClient; //clUseServer; for PRINT too
    CursorType:=ctStatic; //ctDynamic; ctOpenForwardOnly;
    LockType:=ltReadOnly;
    MarshalOptions := moMarshalModifiedOnly;
    SQL.Text:='select 1';
   end;
 Query := Queryes[qStandalone];  // для общего абстрактного пользования и короткого доступа.

 OnConnectComplete := ADConnectComplete;
 OnExecuteComplete := ADExecuteComplete;
 OnInfoMessage     := ADInfoMessage;
 AfterConnect      := ADAfterConnect;
 AfterDisconnect   := ADAfterDisconnect;
end;

destructor  TADS.Destroy;
var  QueryesEn  : TADOQuery;
begin
 for QueryesEn in Queryes do QueryesEn.Free;
 inherited Destroy;
 DeleteCriticalSection(FCS);
end;

procedure TADS.ADAfterConnect(Sender: TObject);
begin
 MWriteLn('Connected to DB...',true);
end;

procedure TADS.ADAfterDisConnect(Sender: TObject);
begin
 MWriteLn('Disconnected from DB...',true);
end;

procedure TADS.ADExecuteComplete;
var     i : integer;
        s : string;
begin
 if Assigned(Connection.Errors)and(Connection.Errors.Count>0)then
  with Connection do begin
   for i :=0 to Errors.Count-1 do begin
    s:='#Error_EC_'+IntToStr(i)+':'+
     #09'(0x'+
     IntToHex(Errors[i].Number,8)+')  <'+
     IntToStr(Errors[i].NativeError)+'>'#13#10#09+
     Errors[i].Description+#13#10#09+
     Errors[i].Source+' '+
     Errors[i].SQLState+#13#10#09+
     'SQL:"'+Command.CommandText+'"';
    MWriteLn(s,true);
    end;
     Errors.Clear;
  end;
end;

procedure TADS.ADInfoMessage(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
var i : integer;
    s : string;
begin
 if Assigned(Connection.Errors)and(Connection.Errors.Count>0)then
  with Connection do begin
   for i :=0 to Errors.Count-1 do begin
    s:='#Message_'+IntToStr(i)+':'+
     #09'(0x'+
     IntToHex(Errors[i].Number,8)+')  <'+
     IntToStr(Errors[i].NativeError)+'>'#13#10#09+
     Errors[i].Description+#13#10#09+
     Errors[i].Source+' '+
     Errors[i].SQLState+#13#10#09;
    //MessageDlg(s,mtWarning,[mbOk],0);
    MWriteLn(s,true);
    end;
     Errors.Clear;
  end;
end;

procedure TADS.ADConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
var i : integer;
    s : string;
begin
 if Assigned(Connection.Errors)and(Connection.Errors.Count>0)then
  with Connection do begin
   for i :=0 to Errors.Count-1 do begin
    s:='#Error_CC_'+IntToStr(i)+':'+
     #09'(0x'+
     IntToHex(Errors[i].Number,8)+')  <'+
     IntToStr(Errors[i].NativeError)+'>'#13#10#09+
     Errors[i].Description+#13#10#09+
     Errors[i].Source+' '+
     Errors[i].SQLState+#13#10#09;
    //'SQL:"'+Commands.CommandText+'"'; тут их массив по всем командам
    MWriteLn(s,true);
    end;
     Errors.Clear;
  end;
end;

End.


{Provider=SQLNCLI10.1;Integrated Security=SSPI;Persist Security Info=False;User ID="";Initial Catalog=Test;Data Source=HELEN-ПК\CRM;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Application Name=Test;Workstation ID=HELEN-ПК;Initial File Name="";Use Encryption for Data=False;Tag with column collation when possible=False;MARS Connection=False;DataTypeCompatibility=0;Trust Server Certificate=False;

(Connection: TADOConnection; RecordsAffected: Integer; const Error: Error; var EventStatus: TEventStatus; const Command: _Command; const Recordset: _Recordset);

type
  ADOConnectionExecuteComplete = class of TExecuteCompleteEvent;
  TADExecuteComplete = procedure(Connection: TADOConnection; RecordsAffected: Integer;
    const Error: Error; var EventStatus: TEventStatus;
    const Command: _Command; const Recordset: _Recordset) of object;
}

