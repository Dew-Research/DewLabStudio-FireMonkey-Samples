unit CopyCompare;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IniFiles,
  FMX.Types,
  FMX.Forms,
  FMX.Grid,
  FMX.Memo,
  FMX.Platform,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,
  MtxVec, Math387, FMX.Controls, FMX.Layouts, PlatformHelpers, FMX.ScrollBox,
  FMX.Controls.Presentation;



type
  TCopyComp = class(TBasicForm2)
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Button1: TButton;
    Chart1: TChart;
    Series1: TBarSeries;
    Series2: TBarSeries;
    procedure FormDestroy(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    Dim : Integer;
    A,B : TMtx;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  CopyComp: TCopyComp;

implementation

{$R *.FMX}

procedure CopyMtxVec(A,B: TMtx);
begin
    B.Copy(A);
end;

procedure CopyDelphi(var A,B: T2DDoubleArray);
var i,j : Integer;
begin
    for i := 0 to Length(A) -1 do
      for j := 0 to Length(A[i]) -1 do b[i,j] := a[i,j];
end;

procedure TranspMtxVec(A,B: TMtx);
begin
    B.Transp(A);
end;

procedure TranspDelphi(var A,B: T2DDoubleArray);
var i,j: Integer;
begin
    for i := 0 to Length(A) -1 do {cols }
      for j := 0 to Length(A[i])-1 do b[j,i] := a[i,j];
end;

constructor TCopyComp.Create(AOwner: TComponent);
var st: String;
begin
    inherited;
    With RichEdit1.Lines, RichEdit1 do
    begin
        Clear;
        Add('This examle compares "regular" Delphi code with highly optimized MtxVec code.'
            +' The example compares TMtx.Copy and TMtx.Transp method with Delphi equivalent'
            +' code. Here is the code used : ');
        Add('');
        St := 'procedure CopyMtxVec(A,B: TMtx);'+#13
              + 'begin' + #13 + '  B.Copy(A);'+#13+
              'end;';
        Add(st);
        Add('');
        St := 'procedure CopyDelphi(var A,B: T2DSampleArray);'+#13
            + 'var i,j : Integer;'+#13 + 'begin'+#13+ '  for i := 0 to Length(A) -1 do'+#13
            + '    for j := 0 to Length(A[i]) -1 do b[i,j] := a[i,j];'+#13
            + 'end;';
        Add(St);
        Add('');
        St := 'procedure TranspDelphi(var A,B: T2DSampleArray);'+#13
            + 'var i,j: Integer;'+#13 +'begin'+#13
            + '  for i := 0 to Length(A) -1 do { cols } '+#13
            + '    for j := 0 to Length(A[i])-1 do b[j,i] := a[i,j];' +#13 + 'end;';
        Add(St);
        Add('');
        St := 'procedure TranspMtxVec(A,B: TMtx);'+#13 + 'begin'+#13
            + '  B.Transp(A);'+#13+'end;';
        Add(St);
        Add('');
        Add('Try changing dimension of test matrix.');
    end;

    A := TMtx.Create;
    B := TMtx.Create;
    A.ConditionCheck := false;
    B.ConditionCheck := false;
    TrackBar1Change(TrackBar1);
end;

procedure TCopyComp.FormDestroy(Sender: TObject);
begin
    A.Free;
    B.Free;
    inherited;
end;

procedure TCopyComp.TrackBar1Change(Sender: TObject);
begin
    Dim := Round(TTrackBar(Sender).Value);
    Label2.Text := IntToStr(Dim);
end;

procedure TCopyComp.Button1Click(Sender: TObject);
var i : Integer;
    MaxIter : Integer;
    aa,bb: T2DDoubleArray;
    TimeElapsed2: double;
begin
    { Setup chart}
    Series1.Clear;
    Series2.Clear;
    A.Size(Dim,Dim,false);
    B.Size(A);
    a.SizeToArray(aa);
    b.SizeToArray(bb);
    if dim < 15 then MaxIter := 500000
    else if Dim < 30 then MaxIter := 50000
    else if Dim < 50 then MaxIter := 20000
    else if Dim < 80 then MaxIter := 1000
    else if Dim < 200 then MaxIter := 500
    else if Dim < 500 then MaxIter := 100
    else MaxIter := 10;
    Chart1.LeftAxis.Title.Text := 'Time [ms]';
    SetHourGlassCursor;
    { Delphi Copy }
    StartTimer;
    for i := 1 to MaxIter do CopyDelphi(AA,BB);
    TimeElapsed := StopTimer;
    Series1.AddXY(0,TimeElapsed*1000,'Copy operation',clTeeColor);
    { MtxVec Copy }
    StartTimer;
    for i := 1 to MaxIter do CopyMtxVec(A,B);
    TimeElapsed2 := StopTimer;
    Series2.AddXY(0,TimeElapsed2*1000,'',clTeeColor);

    { Delphi Transp }
    StartTimer;
    for i :=1 to MaxIter do TranspDelphi(AA,BB);
    TimeElapsed2 := StopTimer;
    Series1.AddXY(1,TimeElapsed2*1000,'Transp operation',clTeeColor);
    { MtxVec Transp }
    StartTimer;
    for i := 1 to MaxIter do TranspMtxVec(A,B);
    TimeElapsed2 := StopTimer;
    Series2.AddXY(1,TimeElapsed2*1000,'',clTeeColor);

    ResetCursor;
end;

initialization
    RegisterClass(TCopyComp);

end.

