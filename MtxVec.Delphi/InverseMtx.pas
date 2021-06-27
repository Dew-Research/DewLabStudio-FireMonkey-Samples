unit InverseMtx;

interface

{$I BdsppDefs.inc}

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Grid,
  FMX.Memo,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2, MtxVec, FMX.Controls, FMX.Layouts,
  PlatformHelpers;


type
  TInvMtx = class(TBasicForm2)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel4: TPanel;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Panel5: TPanel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Panel5Resize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    DimMtx : Integer;
    A,B, C: TMtx;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvMtx: TInvMtx;

implementation

{$R *.FMX}

Uses FmxMtxVecEdit, MtxDialogs;

procedure TInvMtx.TrackBar1Change(Sender: TObject);
begin
  DimMtx := Round(TTrackBar(Sender).Value);
  Label2.Text := IntToStr(DimMtx);
  Button2.Enabled := false;
  Button3.Enabled := false;
end;

procedure TInvMtx.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('Calculating the inverse matrix is a peace of '
      + 'cake. It can be done with just one function call :');
    Add('');
    Add('A.Inv;');
    Add('');
    Add('The Inv method optionally accepts the matrix type '
      + 'parameter. Depending of matrix type (symmetric, '
      + 'triangular, etc..)  optimized methods will be used '
      + 'to calculate the inverse matrix.');
  end;
  {$IFDEF D20}
  StringGrid1.Options := StringGrid1.Options - [TGridOption.Header];
  StringGrid2.Options := StringGrid2.Options - [TGridOption.Header];
  {$ELSE}
  StringGrid1.ShowHeader := False;
  StringGrid2.ShowHeader := False;
  {$ENDIF}
  CreateIt(A,B,C);
  TrackBar1Change(TrackBar1);
  Button1Click(Self);
end;

procedure TInvMtx.Button1Click(Sender: TObject);
begin
  A.Size(DimMtx,DimMtx);

  { Resize StringGrid1 to A size}
  StringGrid1.RowCount := DimMtx+1;
  SetGridColumnCount(StringGrid1, DimMtx+1);

  StringGrid2.RowCount := DimMtx+1;
  SetGridColumnCount(StringGrid2, DimMtx+1);

  StringGrid1.Cells[0,0] := 'A';
  StringGrid2.Cells[0,0] := 'A-1';
  A.RandUniform(-5,5);

  {Write A to StringGrid1 }
  ValuesToGrid(A,StringGrid1,0,0,'0.0000',True);

  Button2.Enabled := true;
  Button3.Enabled := false;
end;

procedure TInvMtx.Button2Click(Sender: TObject);
begin
  { resize B to match the size of A }
  B.Size(A);
  { copy values for StringGrid1 }
  GridToValues(B,StringGrid1,B.Complex,True);
  { calculate the inverse }
  B.AutoMtxType := true;
  B.Inv;
  {show the inverse matrix in StringGrid1 }
  ValuesToGrid(B,StringGrid2,0,0,'0.0000',True);
  Button3.Enabled := true;
end;

procedure TInvMtx.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  try
     StrToFloat(Value);
  except
  end;
end;

procedure TInvMtx.FormDestroy(Sender: TObject);
begin
  FreeIt(A,B,C);
  inherited;
end;

procedure TInvMtx.Button3Click(Sender: TObject);
begin
  C.Mul(A,B);
  ViewValues(C,'A*A-1 = ?',true);
end;

procedure TInvMtx.Panel5Resize(Sender: TObject);
begin
  inherited;
  StringGrid1.Width := Panel5.Width - 2;
  StringGrid1.Position.X := 1;
  StringGrid1.Position.Y := 1;
  StringGrid1.Height := Panel5.Height/2 - 2;

  StringGrid2.Position.X := 1;
  StringGrid2.Position.Y := StringGrid1.Height + 5;
  StringGrid2.Width := StringGrid1.Width;
  StringGrid2.Height := StringGrid1.Height;
end;

initialization
   RegisterClass(TInvMtx);

end.

