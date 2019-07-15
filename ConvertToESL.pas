unit ConvertToESL;

const
	MaxFormRecords = $800;
	MaxFormID = $fff;
	
function Initialize: integer;
var
	i: integer;
	f: IInterface;
begin
	for i := 0 to Pred(FileCount) do begin
	f := FileByIndex(i);
	
	if GetLoadOrder(f) = 0 then
	Continue;
	
	if(GetElementNativeValues(ElementByIndex(f, 0), 'Record Header\Record Flags\ESL') = 0) and not SameText(ExtractFileExt(GetFileName(f)), '.esl') then
	CheckESL(f);
   end;
end;

procedure CheckESL(f: IInterface);
var
	 i: Integer;
  e: IInterface;
  RecCount, RecMaxFormID, fid: Cardinal;
  HasCELL: Boolean;
begin
	for i:= 0 to Pred(RecordCount(f)) do begin
	e := RecordByIndex(f, i);
	
	if not IsMaster(e) then
		Continue;
		
	if Signature(e) = 'CELL' then
		HasCELL := True;
		
	Inc(RecCount);
	
	if RecCount > MaxFormRecords then
		Break;
		
	fid := FormID(e) and $FFFFFF;
	
	if fid > RecMaxFormID then
		RecMaxFormID := fid;
end;

	if RecCount > MaxFormRecords then
	Exit;
	
	AddMessage(Name(f));
	
	if RecMaxFormID <= MaxFormID then begin
		SetElementNativeValues(ElementByIndex(f, 0), 'Record Header\Record Flags\ESL', 1);
		AddMessage(#9'Converted to ESL by adding Record Flag');
end;
    
  // check if plugin has new cell(s)
  if HasCELL then
    AddMessage(#9'Warning: Plugin has new CELL(s) which won''t work when turned into ESL and overridden by other mods due to the game bug');
end;
end.