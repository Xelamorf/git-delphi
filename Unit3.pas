unit Unit3; // форма ввода данных

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, ADODB;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    UpDown1: TUpDown;
    LabeledEdit1: TLabeledEdit;
    Label4: TLabel;
    LabeledEdit2: TLabeledEdit;
    procedure BitBtn2Click(Sender: TObject);
  private
    FCS: TRTLCriticalSection;
  public
    Query : TADOQuery;
    CurrentId : integer;
    bIU : bool;
    constructor Create(AOwner: TComponent; AbIU : bool; AQuery : TADOQuery); //override;
    procedure FormDestroy(Sender: TObject);
  end;

var
  Form3: TForm3;

implementation
uses Unit2, DB;
{$R *.dfm}

resourcestring   // здесь можно слить запросы в один общий
  SQL_InsertClient =
    'DECLARE @Id int = NULL, @Res int = NULL, @BirnDate date = ''%s'' '+
    #13#10'EXEC @Res = [dbo].[tsp_IU_Client] @Id OUTPUT, %s, ''%s'', ''%s'',''%s'', @BirnDate ' +
    #13#10'SELECT @Id as ID, @Res as Res'; // возврат двух значений - новый Id и, возможно, код ошибки
  SQL_UpdateClient =
    'DECLARE @Id int = %d, @Res int = NULL, @BirnDate date = ''%s'' '+
    #13#10'EXEC @Res = [dbo].[tsp_IU_Client] @Id OUTPUT, %s, ''%s'', ''%s'',''%s'', @BirnDate ' +
    #13#10'SELECT @Id as ID, @Res as Res'; // возврат двух значений - новый Id и, возможно, код ошибки

procedure TForm3.BitBtn2Click(Sender: TObject);   // Insert / Update
var s : string;
    BM: TBookmark;
begin
 if TryEnterCriticalSection(FCS) then try
    // в промышленном варианте - единая resourcestring  под Format с параметрами
  if bIU then begin
    s:=Format(SQL_InsertClient, [DateToStr(DateTimePicker1.DateTime),LabeledEdit1.Text,Edit1.Text,Edit2.Text,Edit3.Text]);

    Screen.Cursor := crSQLWait; // вообще, запомнить нужно вид курсора :)
    With GetADOQueryKa(s, Query) do  try
      while not Eof do begin // будет одна запись
        CurrentId := FieldByName('ID').AsInteger;
        Next;
      end;
    finally Free; Screen.Cursor := crDefault; end;
  end else begin
    s:=Format(SQL_UpdateClient, [CurrentId,DateToStr(DateTimePicker1.DateTime),LabeledEdit1.Text,Edit1.Text,Edit2.Text,Edit3.Text]);

    Screen.Cursor := crSQLWait; // вообще, запомнить нужно вид курсора :)
    BM := Query.GetBookmark;
    With GetADOQueryKa(s, Query) do try
      while not Eof do begin // будет одна запись
        CurrentId := FieldByName('ID').AsInteger;
        Next;
      end;
      if Query.BookmarkValid(BM) then Query.GotoBookmark(BM);
    finally Free; Screen.Cursor := crDefault; end;
  end;
  finally
    LeaveCriticalSection(FCS);
  end;
  Close;
  ModalResult := mrOk;
end;

Constructor TForm3.Create;
begin
 InitializeCriticalSection(FCS);
 inherited Create(AOwner);

 CurrentId := 0;
 Query := AQuery;
 bIU := AbIU;
 if bIU then begin
   Caption := 'Insert Client';
   Edit1.Text := GetWord();Edit2.Text := GetWord();Edit3.Text := GetWord();
   DateTimePicker1.DateTime := Now-Round(Random(365*16));
   UpDown1.Position := 2;
   LabeledEdit2.Text := '0';
 end
 else begin   // Query должен быть открытым = наличие записи клиента
   Caption := 'Update Client';
   Edit1.Text := Query.FieldValues['FirstName'];
   Edit2.Text := Query.FieldValues['LastName'];
   Edit3.Text := Query.FieldValues['SecondName'];
   DateTimePicker1.DateTime := Query.FieldValues['BirnDate'];
   UpDown1.Position := Query.FieldValues['Status'];
   LabeledEdit2.Text := Query.FieldValues['ID'];

   CurrentId := Query.FieldValues['ID'];
 end;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  inherited;
  DeleteCriticalSection(FCS);
end;


end.

(*
 s:='DECLARE @Id int = NULL, @Res int = NULL, @BirnDate date = '''+ DateToStr(Now-Round(Random(365)))+'''';
 s:=s+#13#10+Format('EXEC @Res = [dbo].[tsp_IU_Client] @Id OUTPUT, 1, ''%s'', ''%s'',''%s'', @BirnDate',[GetWord(),GetWord(),GetWord()]);
 s:=s+#13#10+'SELECT @Id as ID, @Res as Res';
*)
