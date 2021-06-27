unit List_Func;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Dialogs,
  FMX.Header, System.Rtti, FMX.Controls, FMX.Types, FMX.Layouts,
  FMX.Grid, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox;


type
  TfrmListFunc = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Label1: TLabel;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    function ListToStringGrid(AFileName: String): Integer;
  public
    { Public declarations }
  end;

var
  frmListFunc: TfrmListFunc;

implementation

{$R *.FMX}

procedure TfrmListFunc.FormCreate(Sender: TObject);
var Total : Integer;
begin
  Total := ListToStringGrid('List_Functions.txt');
  Label1.Text := 'Function list: Count = '+IntToStr(Total) + '  (not counting overloaded functions)';
end;

function TfrmListFunc.ListToStringGrid(AFileName: String): Integer;
var f: TextFile;
  tmpStr: String;
  i,j, Len: Integer;
begin
  Result := 0;
  With StringGrid1 do
  begin
    Columns[0].Header := '(Unit) Name';
    Columns[1].Header := 'Description';
  end;
  i := -1;
  If FileExists(AFileName) then
  begin
    AssignFile(f,AFileName);
    try
      Reset(f);
      While Not Eof(f) do
      begin
        readln(f,tmpStr);
        Inc(i);
        StringGrid1.RowCount := i+1;
        Len := Length(tmpStr);
        j:= Pos(Chr(9),tmpStr);
        StringGrid1.Cells[0,i] := Copy(tmpStr,0,j-1);
        StringGrid1.Cells[1,i] := Copy(tmpStr,j+1,len-j);
        if StringGrid1.Cells[1,i]<>'' then Result := Result +1;
      end;
//      StringGrid1.FixedRows := 1;
    finally
      CloseFile(f);
    end;
  end else ShowMessage('Cant find ' + AFileName);
end;

procedure TfrmListFunc.FormResize(Sender: TObject);
begin
  StringGrid1.Columns[1].Width := StringGrid1.Width - StringGrid1.Columns[0].Width;
end;

initialization
  RegisterClass(TfrmListFunc);

end.
