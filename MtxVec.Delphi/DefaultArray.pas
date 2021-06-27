unit DefaultArray;

{$I BdsppDefs.inc}
interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,
  MtxVec, Math387, MtxExpr,
  PlatformHelpers, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;



type
  TDefArray = class(TBasicForm2)
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TPanel;
    Button1: TButton;
    vectorItem: TRadioButton;
    matrixItem: TRadioButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure vectorItemChange(Sender: TObject);
    procedure matrixItemChange(Sender: TObject);
  private
    TestGroupIndex: integer;
    TestVec : Vector;
    TestMtx : Matrix;
    Len     : Integer;
    function CumulativeSum(A: TVec): double; overload;
    function CumulativeSum(A: TMtx): double; overload;
    function CumulativeSumFast1(A: TVec): double; overload;
    function CumulativeSumFast(A: TVec): double;overload;
    procedure CumulativeSumFast(A: TMtx);overload;
    procedure CumulativeSumFast1(A: TMtx); overload;
    function CumulativeSum3(const A: Matrix): double; overload;
    function CumulativeSum3(const A: Vector): double; overload;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  DefArray: TDefArray;

implementation

uses AbstractMtxVec;

{$R *.FMX}

function TDefArray.CumulativeSumFast(A: TVec): double;
var i : Integer;
begin
     for i := 0 to A.Length - 1 do
        A.Values[i] := A.Values[i] + A.Values[i];
     Result := A[0];
end;

function TDefArray.CumulativeSumFast1(A: TVec): double;
var i : Integer;
    a1 : TSampleArray;
begin
     Enlist(A,a1);
     for i := 0 to A.Length - 1  do  a1[i] := a1[i] + a1[i];
     Result := a1[0];

     DismissIt(a,a1);
end;

function TDefArray.CumulativeSum(A: TVec): double;
var i : Integer;
begin
     for i := 0 to A.Length - 1 do
     begin
         A[i] := A[i] + A[i];
     end;
     Result := A[0];
end;

function TDefArray.CumulativeSum3(const A: Vector): double;
var i : Integer;
begin
     for i := 0 to A.Length - 1 do
     begin
         A[i] := A[i] + A[i];
     end;
     Result := A[0];
end;

constructor TDefArray.Create(AOwner: TComponent);
begin
  inherited;
  With RichEdit1 do
  begin
    Lines.Clear;
    Lines.Add('There are three different ways on how to'
                      + ' access the elements of an array. '
                      + ' (vector or matrix). All access methods '+
                      '  work on the same block of memory.');

    Lines.Add('');
    Lines.Add('(*) Default arrays give you clear syntax, '
                      + 'but are not as fast:');
    Lines.Add('a[i,j] := 1; {where "a" is TMtx object}');
    Lines.Add('');
    Lines.Add('(*) Dynamic array pointer is a bit faster than '
            + ' default array.');
    Lines.Add('a.Values[i,j] := 3.5; {where "a" is TMtx object}');
    Lines.Add('');
    Lines.Add('(*) One dimensional array (TMtx object only) allows '
            + 'you to work with the matrix as you would with one '
            + 'dimensional array:');
    Lines.Add('a.Values1D[i*Cols+j]:= 2.3; {where "a" is TMtx object}');
  end;
  RadioGroup1Click(RadioGroup1);
  TrackBar1Change(TrackBar1);
end;

function TDefArray.CumulativeSum(A: TMtx): double;
var i,j : Integer;
begin
     for i := 0 to A.Rows-1 do
        for j := 0 to A.Cols-1 do
        begin
            A[i,j] := A[i,j] + A[i,j];
        end;
     Result := A[0,0];
end;

function TDefArray.CumulativeSum3(const A: Matrix): double;
var i,j : Integer;
begin
     for i := 0 to A.Rows-1 do
        for j := 0 to A.Cols-1 do
        begin
            A[i,j] := A[i,j] + A[i,j];
        end;
     Result := A[0,0];
end;

procedure TDefArray.CumulativeSumFast1(A: TMtx);
var i,j : Integer;
    a1  : T2DDoubleArray;
begin
     Enlist(A,a1);

     for i := 0 to A.Rows-1 do
        for j := 0 to A.Cols-1 do
            a1[i,j] := a1[i,j] + a1[i,j];

     DismissIt(A,a1);
end;

procedure TDefArray.CumulativeSumFast(A: TMtx);
var i,j  : Integer;
    k, Cols  : Integer;
begin
     Cols := A.Cols;
     for i := 0 to A.Rows-1 do
        for j := 0 to A.Cols-1 do
        begin
            k := i*Cols+j;
            A.Values1D[k] := A.Values1D[k] + A.Values1D[k];
        end;
end;


procedure TDefArray.matrixItemChange(Sender: TObject);
begin
  if matrixItem.IsChecked then TestGroupIndex := 1;
end;

procedure TDefArray.TrackBar1Change(Sender: TObject);
begin
  Len := System.Round(TTrackBar(Sender).Value);
  Label1.Text := IntToStr(Len);
end;

procedure TDefArray.vectorItemChange(Sender: TObject);
begin
  if vectorItem.IsChecked then TestGroupIndex := 0;
end;

procedure TDefArray.Button1Click(Sender: TObject);
var i : Integer;
    j : Integer;
    MaxIter : Integer;
begin
  { setup TestVec }
  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;
  SetHourGlassCursor;
  Series1.Title := 'Values property';
  Series2.Title := 'Values array field';
  Series3.Title := 'array of double';
  Series4.Title := 'Record.Values property';
  if TestGroupIndex = 0 then { test vector }
  begin
    j := 1;
    MaxIter := 10;
    if Len < 5000 then MaxIter := 500;
    if Len < 2000 then MaxIter := 1000;
    if Len < 500 then MaxIter := 6000;
    if Len < 100 then MaxIter := 30000;
    while j < Len do
    begin
      TestVec.Size(j);

      { default arrays }
      TestVec.SetZero;
      StartTimer;
      for i := 1 to MaxIter do CumulativeSum(TestVec);
      Series1.AddXY(j,StopTimer*1000,'',clTeeColor);

      { TSampleArray }
      TestVec.SetZero;
      StartTimer;
      for i := 1 to MaxIter do CumulativeSumFast(TestVec);
      Series2.AddXY(j,StopTimer*1000,'',clTeeColor);

     { TSampleArray Enlist}
      TestVec.SetZero;
      StartTimer;
      for i := 1 to MaxIter do CumulativeSumFast1(TestVec);
      Series3.AddXY(j,StopTimer*1000,'',clTeeColor);

     { default array on record}
      TestVec.SetZero;
      StartTimer;
      for i := 1 to MaxIter do CumulativeSum3(TestVec);
      Series4.AddXY(j,StopTimer*1000,'',clTeeColor);


      if j < 10 then j := j +2
      else if J < 100 then j := j + 10
      else if j < 500 then j := j + 50
      else if j < 1000 then j := j + 100
      else if j < 3000 then j := j + 250
      else j := j + 1000;
    end
  end else
  begin
    j := 5;
    MaxIter := 1;
    if Len < 70 then MaxIter := 150;
    if Len < 30 then MaxIter := 550;

    while j < Len do
    begin
      TestMtx.Size(j,j);

      { default arrays }
      TestMtx.SetZero;
      StartTimer;
      for i := 1 to MaxIter do CumulativeSum(TestMtx);
      Series1.AddXY(j,StopTimer*1000,'',clTeeColor);

      { TSampleArray fast}
      StartTimer;
      for i := 1 to MaxIter do CumulativeSumFast(TestMtx);
      TimeElapsed := StopTimer;
      Series2.AddXY(j,StopTimer*1000,'',clTeeColor);

      { TSampleArray ultra fast}
      StartTimer;
      for i := 1 to MaxIter do CumulativeSumFast1(TestMtx);
      TimeElapsed := StopTimer;
      Series3.AddXY(j,StopTimer*1000,'',clTeeColor);

      { default arrays }
      TestMtx.SetZero;
      StartTimer;
      for i := 1 to MaxIter do CumulativeSum3(TestMtx);
      Series4.AddXY(j,StopTimer*1000,'',clTeeColor);

      if j < 10 then j := j +2
      else if j < 50 then j := j + 5
      else if j < 100 then j := j + 10
      else if j < 200 then j := j + 15
      else j := j + 20;
    end;
  end;
  Chart1.LeftAxis.Title.Text := 'time [ms] ('+IntToStr(MaxIter)+' iterations)';

  ResetCursor;
end;

procedure TDefArray.RadioGroup1Click(Sender: TObject);
begin
  Case GetRadioItemIndex(RadioGroup1) of
  0  : begin
            Label2.Text := 'Vector length';
            TrackBar1.Max := 10000;
            TrackBar1.Frequency := 500;
       end;
  1  : begin
            Label2.Text := 'Sqared matrix rows';
            TrackBar1.Max := 300;
            TrackBar1.Frequency := 10;
            TrackBar1.Value := 150;
       end;
  end;
  TrackBar1Change(TrackBar1);
end;

initialization
   RegisterClass(TDefArray);

end.
