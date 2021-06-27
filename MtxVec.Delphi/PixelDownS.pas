unit PixelDownS;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.ExtCtrls,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,

  Basic2, MtxVec, Math387, FmxMtxVecEdit,MtxExpr;



type
  TDownS = class(TBasicForm2)
    Label1: TLabel;               
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar1: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    DrawNormalButton: TSpeedButton;
    DrawFastButton: TSpeedButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Chart2: TChart;
    Series2: TFastLineSeries;
    procedure DrawFastButtonClick(Sender: TObject);
    procedure DrawNormalButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
  private
    TestVec : Vector;
    NumPoints : Integer;
    procedure FillRandomPoints;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  DownS: TDownS;

implementation

{$R *.FMX}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiTb.fmx ANDROID}

Uses FmxMtxVecTee;


procedure TDownS.FillRandomPoints;
begin
    if NumPoints = TestVec.Length then
    begin
         TestVec := TestVec + 10000;
    end;
    TestVec.Size(NumPoints);
    TestVec.RandUniform(-500,500);
    TestVec.CumSum;
end;

procedure TDownS.Panel3Resize(Sender: TObject);
begin
  Chart1.Height := Panel3.Height/ 2;
  Chart2.Height := Panel3.Height/ 2;
end;

procedure TDownS.Button1Click(Sender: TObject);
begin
  TestVec.length := 0;
  FillRandomPoints;
  { "regular" plotting }

  StartTimer;
  with Chart1.BottomAxis do
  begin
       Automatic := false;
       SetMinMax(0,TestVec.Length);
  end;
  Series1.Clear;
  DrawValues(TestVec,Series1,0,1.0,False);
  TimeElapsed := StopTimer*1000;
  Label3.Text := FormatSample('0.000ms',TimeElapsed);

  { "optimized" plotting }
  StartTimer;
  with Chart2.BottomAxis do
  begin
       Automatic := false;
       SetMinMax(0,TestVec.Length-1);
  end;
  Series2.Clear;
  DrawValues(TestVec,Series2,0,1.0,True);
  TimeElapsed := StopTimer*1000;
  Label4.Text := FormatSample('0.000ms',TimeElapsed);
end;

procedure TDownS.TrackBar1Change(Sender: TObject);
begin
  NumPoints := Round(TTrackBar(Sender).Value);
  Label6.Text := IntToStr(NumPoints);
end;

procedure TDownS.DrawNormalButtonClick(Sender: TObject);
begin
  FillRandomPoints;

  StartTimer;
  with Chart1.BottomAxis do
  begin
       Automatic := false;
       SetMinMax(0,TestVec.Length);
  end;
  Series1.Clear;
  DrawValues(TestVec,Series1,0,1.0,False);
  TimeElapsed := StopTimer*1000;
  Label3.Text := FormatSample('0.000ms',TimeElapsed);
end;

constructor TDownS.Create(AOwner: TComponent);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Add('The PixelDownSample method can be used to speed '
      + 'up the drawing of huge amounts of data (>> 1 milion points) '
      + 'samples). The routine will reduce the number of '
      + 'points in vectors Y and X in such a way that there '
      + 'will be virtualy no visual difference between the original '
      + 'and downsampled data. That however will no longer be '
      + 'true, if you will zoom-in on the data.');
    Add('The performance gain can be as big as 500x depending '
      + 'on the charting tool that you use, CPU and number '
      + 'of points that will be drawn. You can easily '
      + 'draw data series from vectors with length of over 10 milion '
      + 'points in real time taking only a percent or so of your '
      + 'CPU. Try changing the "Number of points" '
      + 'and compare the visual appearance of both charts.');
  end;

  TrackBar1Change(TrackBar1);
end;

procedure TDownS.DrawFastButtonClick(Sender: TObject);
begin
  FillRandomPoints;

  StartTimer;
  with Chart2.BottomAxis do
  begin
       Automatic := false;
       SetMinMax(0,TestVec.Length-1);
  end;
  Series2.Clear;
  DrawValues(TestVec,Series2,0,1.0,True);
  TimeElapsed := StopTimer*1000;
  Label4.Text := FormatSample('0.000ms',TimeElapsed);
end;

initialization
   RegisterClass(TDownS);

end.
