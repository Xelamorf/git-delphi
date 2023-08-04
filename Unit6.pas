unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, Mask, ADODB;

type
  TForm6 = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Label1: TLabel;
    UpDown1: TUpDown;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    UpDown2: TUpDown;
    MaskEdit1: TMaskEdit;
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
  Form6: TForm6;

implementation
uses Unit4, Unit2;
{$R *.dfm}

resourcestring
  SQL_InsertCredit =
    'DECLARE @Id int = NULL, @Res int = NULL '+
    #13#10'EXEC @Res = [dbo].[tsp_IU_Credit] @Id OUTPUT, %s, ''%s'', %s, %s ' +
    #13#10'SELECT @Id as ID, @Res as Res'; // возврат двух значений - новый Id и, возможно, код ошибки

procedure TForm6.BitBtn2Click(Sender: TObject);   // Insert
var s : string;
begin
 if TryEnterCriticalSection(FCS) then try
    // в промышленном варианте - единая resourcestring  под Format с параметрами
  if bIU then
    s:=Format(SQL_InsertCredit, [LabeledEdit2.Text,MaskEdit1.Text,LabeledEdit3.Text,LabeledEdit1.Text]);

  Screen.Cursor := crSQLWait; // вообще, запомнить нужно вид курсора :)
  With GetADOQueryKa(s, ADS.Queryes[qCredits]) do
    try
      while not Eof do begin // будет одна запись
        CurrentId := FieldByName('ID').AsInteger;
        Next;
      end;
    finally Free; Screen.Cursor := crDefault; end;
  finally
    LeaveCriticalSection(FCS);
  end;
  Close;
  ModalResult := mrOk;
end;

Constructor TForm6.Create;
begin
 InitializeCriticalSection(FCS);
 inherited Create(AOwner);

 CurrentId := 0;
 Query := AQuery; // должен быть открытым = наличие записи клиента
 bIU := AbIU;
 if bIU then begin
   Caption := 'Insert Client "' + Query.FieldValues['FirstName']+'"';
   LabeledEdit2.Text := Query.FieldValues['Id'];
   MaskEdit1.Text := '0';
   UpDown1.Position := 5;
   UpDown2.Position := 30;
 end
 else begin
   Caption := 'Update Client';
 end;
end;

procedure TForm6.FormDestroy(Sender: TObject);
begin
  inherited;
  DeleteCriticalSection(FCS);
end;
{$R *.dfm}

end.
