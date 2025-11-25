unit Interp1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Header,
  Basic1,  MtxVec, Math387,
  FmxMtxVecEdit, FmxMtxVecTee, MtxExpr,Polynoms,
  FMXTee.Series,
  FMXTee.Engine,
  FMXTee.Procs,
  FMXTee.Chart, FMX.ListBox, FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types,
  FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;



type
  TInterpolating1 = class(TBasicForm1)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    StaticText2: TLabel;
    TrackBar2: TTrackBar;
    StaticText3: TLabel;
    Button1: TButton;
    Label5: TLabel;
    Series2: TFastLineSeries;
    Series1: TPointSeries;
    Label4: TLabel;
    Item0: TListBoxItem;
    Item1: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    intMethod : Polynoms.TInterpolationType;
    NumPoints, Factor : Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Interpolating1: TInterpolating1;

implementation

uses AbstractMtxVec;

{$R *.FMX}
{$R *.Windows.fmx MSWINDOWS}

procedure TInterpolating1.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('Polynoms unit introduces a very powerful method for '
      + 'interpolation. You can perform linear or cubic interpolation '
      + '(using cubic splines). Everyhting gets done by calling just '
      + 'one  procedure:');
    Add('');
    Add('Interpolate(FunValues,intX,intY,interpolationMethod);');
    Add('');
    Add('Try changing the number of data points, number of '
      + 'interpolated points and interpolation method. The '
      + '"DownSample" checkbox will use the PixelDownSample '
      + 'method to reduce the number of points to be displayed '
      + '(BIG speed-up if you are charting interpolated values).');
    Add('');

    Add('Parameters in this demo :');
    Add('Interpolation:'+#9+'interpolation method used (linear, cubic)');
    Add('DataPoints:'+#9+'number of data points');
    Add('Factor:'+#9+#9+'number of interpolated points between two data points');
    Add('Time needed:'+#9+'time in miliseconds, needed to construct and evaluate (but not draw) piece-wise polynomial');
  end;
  ComboBox1.ItemIndex := 1;
  ComboBox1Change(ComboBox1);
  TrackBar1Change(TrackBar1);
  TrackBar2Change(TrackBar2);
  CheckDownSampleClick(CheckDownSample);
end;

procedure TInterpolating1.ComboBox1Change(Sender: TObject);
begin
     case TComboBox(Sender).ItemIndex of
     0: intMethod := intLinear;
     1: intMethod := intCubic;
     end;
end;

procedure TInterpolating1.TrackBar1Change(Sender: TObject);
begin
     NumPoints := Round(TTrackBar(Sender).Value);
     StaticText2.Text := IntToStr(NumPoints);
end;

procedure TInterpolating1.TrackBar2Change(Sender: TObject);
begin
     Factor := Round(TTrackBar(Sender).Value);
     StaticText3.Text := IntToStr(Factor);
end;

procedure TInterpolating1.Button1Click(Sender: TObject);
var    Y       : Vector;
       pX,pY     : Vector;
       i         : Integer;
       Offset: double;
begin
    Chart1.LeftAxis.Automatic := true;
    Chart1.BottomAxis.Automatic := true;
    Y.Size(NumPoints);

    Randomize;

    y[0] := 1000;
    for i := 1 to Y.Length-1 do
    begin
        Y.Values[i]:= Y.Values[i-1] + 250 - random(500);
    end;

    DrawValues(Y,Series1,0,1,DownSize);
    { calculate piecewise poly for the range of points }
    StartTimer;
    PX.Size((NumPoints-1)*Factor + 1);

//    offset := 1.2; //interpolation offset

    Offset := 0;
    PX.Ramp(Offset,1.0/Factor);
    Interpolate(Y,PX,PY,intMethod,true); { !! Check what happens if you have only Y }
    TimeElapsed := StopTimer*1000;
    Label5.Text:='Solved in '+ IntToStr(Round(TimeElapsed))+' ms';
    DrawValues(pY,Series2,Offset,1.0/Factor, DownSize);
end;

initialization
   RegisterClass(TInterpolating1);

end.


