unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm5 = class(TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure WMNCHitTest(var Msg : TWMNCHitTest); message WM_NCHITTEST;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure SaveRegion(FileName: string; fRgn : hRGN);
var
  s: TStream;
  size: cardinal;
  data: pointer;
begin
  s := TFileStream.Create(FileName, fmCreate);
  try
    size := GetRegionData(fRgn, SizeOf(RGNDATA), nil);
    data := GlobalAllocPtr(GPTR, size);
    try
      GetRegionData(fRgn, size, data);
      s.Write(data^, size);
    finally
      GlobalFreePtr(data);
    end;
  finally
    s.Free;
  end;
end;

function LoadRegion(FileName: string): hRGN;
var
  data: PRgnData;
  s: TStream;
begin
  s := TFileStream.Create (FileName, fmOpenRead);
  try
    data := GlobalAllocPtr(GPTR, s.size);
    try
      s.Read(data^, s.Size);
      Result := ExtCreateRegion(nil, s.Size, data^);
    finally
      GlobalFreePtr(data);
    end;
  finally
    s.Free;
  end;
end;

procedure StreamToRes(const FileName: string; Inputstream: TMemoryStream);
var
  hUpdate: THandle;
begin
  hUpdate := BeginUpdateResource(PChar(FileName), True);
  try
    UpdateResource(hUpdate, RT_RCDATA, 'ID', LANG_NEUTRAL, InputStream.Memory, InputStream.Size);
  finally
    EndUpdateResource(hUpdate, False);
  end;
end;

procedure CalcRegion(image : TImage);  //Borders=None
var
  regn, tmpRegn: integer; // регион окна и временный регион
  x, y: integer; // координаты пикселя
  nullClr: TColor; // «прозрачный цвет» пикель в левом нижнем углу
begin
  nullClr := image.picture.Bitmap.Canvas.Pixels[0, 0];
  // Image это картинка по которой создается форма окна
  regn := CreateRectRgn(0, 0, image.picture.Graphic.Width,
    image.picture.Graphic.Height);
  for x := 1 to image.picture.Graphic.Width do
    for y := 1 to image.picture.Graphic.Height do
      if image.picture.Bitmap.Canvas.Pixels[x - 1, y - 1] = nullClr then
      begin
        tmpRegn := CreateRectRgn(x - 1, y - 1, x, y);
        CombineRgn(regn, regn, tmpRegn, RGN_DIFF);
        DeleteObject(tmpRegn);
      end;
  //SaveRegion('AboutRegion.bin', regn);   // для создания ресурса
  SetWindowRgn(TWinControl(image.Owner).handle, regn, true);
end;

procedure TForm5.WMNCHitTest(var Msg : TWMNCHitTest); //где торчит форма - можно таскать за канву и края окна.
begin
  Msg.Result := HTCAPTION;  // таскаем окно мышой
end;

procedure TForm5.FormCreate(Sender: TObject);
var data  : PRgnData;
    //RS    : TResourceStream; fRgn  : hRGN;
begin
  //CalcRegion(image1); // можно выделить в свой поток, чтобы загрузку не тормозил
  //ещё лучше сохранить в ресурс через SaveRegion

  // регион сохранён в файл AboutRegion.bin и линкуется компилером.
  with TResourceStream.Create(hInstance, 'AboutRegion', RT_RCDATA) do try
    data := GlobalAllocPtr(GPTR, Size);
    try
      Read(data^, Size);
      SetWindowRgn(handle, ExtCreateRegion(nil, Size, data^), true);
    finally
      GlobalFreePtr(data);
    end;
  finally
    Free;
  end;
end;

end.
