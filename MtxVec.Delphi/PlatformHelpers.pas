unit PlatformHelpers;

interface

uses  System.SysUtils,
      System.Types,
      System.UITypes,
      System.Classes,
      FMX.Types,
      FMX.Controls,
      FMX.Forms,
      FMX.Grid,
      FMX.Layouts,
      FMX.Edit,
      FMX.Platform,
      FMX.StdCtrls;

  function GetRadioItemIndex(aPanel: TPanel): integer; overload;
  procedure SetRadioItemIndex(aPanel: TPanel; RadioIndex: integer); overload;
  procedure SetGridColumnCount(aGrid: TStringGrid; Count: integer); overload;
  procedure SetHourGlassCursor;
  procedure ResetCursor;

implementation

var aScreen: IFMXCursorService;

procedure SetHourGlassCursor;
begin
    if Assigned(aScreen) then
        aScreen.SetCursor(crHourGlass);
end;

procedure ResetCursor;
begin
    if Assigned(aScreen) then
        aScreen.SetCursor(crDefault);
end;

procedure SetGridColumnCount(aGrid: TStringGrid; Count: integer);
var i: integer;
begin
    for i := aGrid.ColumnCount to Count-1 do
         aGrid.AddObject(TStringColumn.Create(aGrid));

    for i := aGrid.ColumnCount-1 downto Count do
    begin
         {$IFDEF AUTOREFCOUNT}
         aGrid.RemoveObject(aGrid.Columns[i]);
         {$ELSE}
         aGrid.Columns[i].Free;
         {$ENDIF}
    end;
end;

function GetRadioItemIndex(aPanel: TPanel): integer;
var i: Integer;
    a: TRadioButton;
begin
    Result := -1;
    for i := 0 to aPanel.ChildrenCount-1 do
    begin
        if aPanel.Children[i] is TRadioButton then
        begin
              a := TRadioButton(aPanel.Children[i]);
              if a.IsChecked then
              begin
                  Result := a.Index;
              end;
        end;
    end;
end;

procedure SetRadioItemIndex(aPanel: TPanel; RadioIndex: integer);
var a: TRadioButton;
begin
    if aPanel.Children[RadioIndex] is TRadioButton then
    begin
        a := TRadioButton(aPanel.Children[RadioIndex]);
        a.IsChecked := True;
    end;
end;

initialization
   TPlatformServices.Current.SupportsPlatformService(IFMXCursorService,IInterface(aScreen));

finalization
   aScreen := nil;

end.
