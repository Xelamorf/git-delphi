unit Unit1;   // ������� ����� � �������������

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, DB, SqlExpr, FMTBcd, DBXMSSQL,
  ADODB, Buttons, TeCanvas, TeeEdiGrad, Menus, PlatformDefaultStyleActnCtrls,
  ActnList, ActnMan, System.Actions;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Memo1: TMemo;
    DBGrid2: TDBGrid;
    Splitter3: TSplitter;
    DBGrid3: TDBGrid;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOStoredProc1: TADOStoredProc;
    Button3: TButton;
    DataSource2: TDataSource;
    ADOQuery2: TADOQuery;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    AddClient1: TMenuItem;
    ChangeClient1: TMenuItem;
    ActionManager1: TActionManager;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ChangeClient1Click(Sender: TObject);
    procedure AddClient1Click(Sender: TObject);
  private
    procedure WMNCHitTest(var Msg : TWMNCHitTest); message WM_NCHITTEST;
  public
    procedure AppException(Sender: TObject; E: Exception);
  end;

var
  Form1         : TForm1;
  FF            : TFileStream = nil;
  CurDir        : string;

implementation
uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7;

{$R *.dfm}

// ������� ������

procedure TForm1.WMNCHitTest(var Msg : TWMNCHitTest); //��� ������ ����� - ����� ������� �� ����� � ���� ����.
begin   // ��������� �������������� �������� :(
  Msg.Result := HTCAPTION;
end;

procedure TForm1.AppException(Sender: TObject; E: Exception);
begin
  MWriteLn('@Error: "'+E.Message+'"',true);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 Form5.ShowModal;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i : integer;
begin
 ADOConnection1.Connected := not ADOConnection1.Connected;
 if ADOConnection1.Connected then
    for i := 0 to (ADOConnection1.DataSetCount - 1) do
      ADOConnection1.DataSets[i].Active := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Memo1.Lines.Add(GetFIO());
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  pt: TPoint;
begin
  with Sender as TButton do
  begin
    pt := Point(Left, Top + Height);
    pt := Parent.ClientToScreen(pt);
    if Assigned(PopupMenu) then PopupMenu.Popup(pt.X, pt.Y);
  end;
end;

procedure TForm1.AddClient1Click(Sender: TObject);
begin
   try
    Form3 := TForm3.Create(nil, True, ADOQuery1);
    if (Form3.ShowModal = mrOk) and (Form3.CurrentId > 0) then begin
      MWriteLn('@ ��������� ������ ������� ID='+IntToStr(Form3.CurrentId), true);
    end;
  finally
    FreeAndNil(Form3);
  end;
end;

procedure TForm1.ChangeClient1Click(Sender: TObject);
begin
  try
    Form3 := TForm3.Create(nil, False, ADOQuery1);
    if (Form3.ShowModal = mrOk) and (Form3.CurrentId > 0) then begin
      MWriteLn('@ �������������� ������ ������� ID='+IntToStr(Form3.CurrentId), true);
    end;
  finally
    FreeAndNil(Form3);
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  try
    Form6 := TForm6.Create(nil, True, ADOQuery1);
    if (Form6.ShowModal = mrOk) and (Form6.CurrentId > 0) then begin
      MWriteLn('@ ��������� ������ ������� ID='+IntToStr(Form6.CurrentId), true);
    end;
  finally
    FreeAndNil(Form6);
  end;
end;

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
begin
   if Assigned(Sender) and (Sender.ClassType = TDataSource) then begin
    with ADOQuery2 do begin // ����� �� � ADOQuery2 ��������� DataSource = DataSource1 � �� ������ ��� ���� ��� ������
      DisableControls;
      Close;
      Parameters.FindParam('ClientsId').Value := TDataSource(Sender).DataSet.FieldValues['Id'];
      Open; // ��� ����� ���������� �� ���������� � �������������� �������������� ������
      EnableControls;
    end;
   end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FF)then FlushFileBuffers(FF.Handle);
end;

procedure TForm1.FormCreate(Sender: TObject);
var s : string;
    tp : TParameter;
    i  : integer;
begin
  try
   //s := LoadResConnectStr; //MWriteLn('CS='+s,true);
   //MessageDlg(s,mtWarning,[mbOk],0);

   with TForm7.Create(nil) do begin
    ShowModal;
    s := ConStr;
    Free;
   end;

   Application.OnException:=AppException;

   ADS := TADS.Create(nil, s); // ��������� ����� ����������� � � ���������� �������� �����
   ADS.Name := 'ADS_Ex';
   FreeAndNil(ADOConnection1);
   ADOConnection1 := ADS;  //ADOQuery1.Connection := ADS; ADOQuery2.Connection := ADS;
   FreeAndNil(ADOQuery1); ADOQuery1 := ADS.Queryes[qClients];
   FreeAndNil(ADOQuery2); ADOQuery2 := ADS.Queryes[qCredits];
   // ��� ���������� ������ ��������� ������� ������� ������������ AssignADOQuery()
   DataSource1.DataSet := ADS.Queryes[qClients]; // �� ������ ������� ���� ��������� ������ ����� �� �������
   DataSource2.DataSet := ADS.Queryes[qCredits];

   // � ������������ ������ ������� ��������� �� ������ ������� ������������
   with ADS.Queryes[qClients] do begin
    SQL.Text := 'select * from Clients';
   end;

   with ADS.Queryes[qCredits] do begin
    CursorType := ctKeyset;
    SQL.Text := 'SELECT * FROM Credits as C WHERE (C.ClientsId = :ClientsId)';
    Prepared := true;  //  parameter ClientsId created automatic
    with Parameters.ParamByName('ClientsId') {AddParameter} do begin //Name := 'ClientsId';
     DataType := ftInteger; // ��� ������������� AssignADOQuery() �������� ���������� ������������� �� ������� (TPersistent!)
     Precision := 10;
     Size := 4;
     Value := 3;
    end;
    Open;
   end;
   ADS.Queryes[qClients].Open;
//   SaveCompToFile(TComponent(ADS.Queryes[qCredits]), 'qCredits.txt');   SaveComToFile(TComponent(ADOQuery2), 'ADOQuery2.txt');
 finally end;
end;

var S     : string;
    Mutex : THandle = 0;
initialization

  S := ExtractFileName(ParamStr(0));
  Mutex := CreateMutex(nil, True, PChar(S));
  if GetLastError = ERROR_ALREADY_EXISTS then begin
        MessageDlg('���������� "' + S + '" ��� ��������. ���������� ��������� ������ ���������.',mtError,[mbOk],0);
        Halt(3);
  end;

  S := ExtractFilePath(ParamStr(0))+ExtractFileName(ChangeFileExt(ParamStr(0), '.LOG'));
  if FileExists(S) then
        FF:=TFileStream.Create(S,fmOpenReadWrite, fmShareDenyRead) //fmShareCompat); fmShareDenyRead
   else FF:=TFileStream.Create(S,fmCreate, fmShareDenyRead);
  FF.Seek(0, soFromEnd);
  MWriteLn('Start...............' + DateTimeToStr(Now),true);

finalization
  if Assigned(ADS) then FreeAndNil(ADS);
  MWriteLn('Finish..............' + DateTimeToStr(Now),true);
  if Assigned(FF) then FreeAndNil(FF);
  if Mutex <> 0 then CloseHandle(Mutex);
end.

{

 with DM.AD do try
  DefaultDatabase:=HEALTH_DB;
  MWriteLn('Connection String="'+ConnectionString+'"'#13#10' Properties:',True);
   for i := 0 to Properties.Count-1 do begin
      MWriteLn('  ('+IntToStr(i)+')'+Properties.Item[i].Name+'='+String(Properties.Item[i].Value));
     if(Properties.Item[i].Name='Persist Security Info')and(String(Properties.Item[i].Value)='False')
       then begin MWriteLn('Finish...',true); MessageDlg('��������� ������� "Allow saving password" � Updater.udl! �����.',mtError,[mbOk],0); Halt; end;
       //then Properties.Item[i].Value.String :='True';
     if(Properties.Item[i].Name='Initial Catalog')and(String(Properties.Item[i].Value)<>'')
       then HEALTH_DB:=String(Properties.Item[i].Value);

   end; //DM.AD.DefaultDatabase:=String(DM.AD.Properties.Item[DBPROP_INIT_CATALOG=4].Value);
    if HEALTH_DB<>'' then DefaultDatabase:=HEALTH_DB;
    MWriteLn('  HEALTH_DB="'+HEALTH_DB+'"');
    MWriteLn('  ADO Version="'+DM.AD.Version+'"');
    MWriteLn('UserAccess: "'+fUp.GetUserAccess+'"',true);

  if fUp.GetUserAccess='MULTI_USER' then fUp.btSingleUserClick(Self);
 except raise end;
}



