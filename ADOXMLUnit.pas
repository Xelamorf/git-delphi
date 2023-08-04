unit ADOXMLUnit;

 interface

 uses Classes, ADOInt;

 function RecordsetToXML(const Recordset: _Recordset): string;
 function RecordsetFromXML(const XML: string): _Recordset;

 implementation

 uses ComObj, System.SysUtils;

 {
  Example:
  ...
    Memo1.Lines.Text:=RecordsetToXML(ADOQuery1.Recordset);
  ...
}
 function RecordsetToXML(const Recordset: _Recordset): string;
 var
   RS: Variant;
   Stream: TStringStream;
   s : string;
 begin
   Result := '';
   if Recordset = nil then Exit;
   Stream := TStringStream.Create('',TEncoding.UTF8);  //Unicode
   try
     RS := CreateOleObject('ADODB.Recordset');
     RS := Recordset;
     //RS._xSave('C:\Projects\KillUsver - XE7\LostCerts_RS.xml',adPersistXML);  //s := RS.GetString;
     RS.Save(TStreamAdapter.Create(stream) as IUnknown, adPersistXML); //adPersistADTG adPersistADO adPersistProviderSpecific
     Stream.Position := 0;
     Result := Stream.DataString;
   finally
     Stream.Free;
   end;
 end;

 {  procedure _xSave(const FileName: WideString; PersistFormat: PersistFormatEnum);
  Example:
  ...
    ADOQuery1.Recordset:=RecordsetFromXML(Memo1.Lines.Text);
  ...
}

 function RecordsetFromXML(const XML: string): _Recordset;
 var
    RS: Variant;
   Stream: TStringStream;
 begin
   Result := nil;
   if XML = '' then Exit;
   try
     Stream := TStringStream.Create(XML);
     Stream.Position := 0;
     RS := CreateOleObject('ADODB.Recordset');
     RS.Open(TStreamAdapter.Create(Stream) as IUnknown);
     Result := IUnknown(RS) as _Recordset;
   finally
     Stream.Free;
   end;
 end;

{

procedure TForm1.Button3Click(Sender: TObject);
var
   OutStream                  : TFileStream;
   MyIStream                  : IStream;
   Parameter                  : _Parameter;
   RecordsAffected,Parameters : OleVariant;
begin
   OutStream := TFileStream.Create('C:\TestXml.xml',fmCreate);
   ADOCommand1.CommandText := 'select * from test1 for xml auto' ;
   MyIStream  := TStreamAdapter.Create(OutStream,soReference);
   ADOCommand1.Properties.Item['Output Stream'].Value := MyIStream;
   RecordsAffected := unassigned;
   Parameters      := EmptyParam;
   ADOCommand1.CommandObject.Execute(RecordsAffected,Parameters,adExecuteStream);
   MyIStream := nil;
   OutStream.Free;

end

procedure TForm1.Button3Click(Sender: TObject);
var
   OutStream                  : TFileStream;
   MyIStream                  : IStream;
   Parameter                  : _Parameter;
   RecordsAffected,Parameters : OleVariant;
begin
   OutStream := TFileStream.Create('C:\TestXml.xml',fmCreate);
   ADOCommand1.CommandText := 'select * from test1 for xml auto' ;
   MyIStream  := TStreamAdapter.Create(OutStream,soReference);
   ADOCommand1.Properties.Item['Output Stream'].Value := MyIStream;
   RecordsAffected := unassigned;
   Parameters      := EmptyParam;
   ADOCommand1.CommandObject.Execute(RecordsAffected,Parameters,adExecuteStream);

   ADOCommand1.CommandText := 'insert into TableXML(xml)values(:xml)';
   ADOCommand1.Parameters.ParamByName('xml').LoadFromStream(OutStream,ftString);
   ADOCommand1.Execute;

   MyIStream := nil;
   OutStream.Free;

end;

}

end.
