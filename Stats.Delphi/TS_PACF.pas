unit TS_PACF;

interface

{$I BdsppDefs.inc}

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,

  FMX.Header,
  Basic_Chart, MtxVec, FMX.Edit, FMX.StdCtrls, FMXTee.Engine, FMXTee.Series,
  FMX.Layouts, FMX.Memo, FMXTee.Procs, FMXTee.Chart, FMXTee.Functions.Stats,
  FMXTee.Series.Candle, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;



type
  TfrmTSPACF = class(TfrmBasicChart)
    Button2: TButton;
    RadioGroupPT: TPanel;
    Series1: TLineSeries;
    Label1: TLabel;
    EditLags: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Chart1BeforeDrawSeries(Sender: TObject);
    procedure EditLagsChange(Sender: TObject);
    procedure Chart1AfterDraw(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    { Private declarations }
    myData: TVec;
    vACF, vPACF: TVec;
    Lags: Integer;
    RadioGroup1ItemIndex: integer;
    procedure RadioGroupUpdate;
  public
    { Public declarations }
  end;

var
  frmTSPACF: TfrmTSPACF;

implementation

Uses FmxMtxVecTee, FmxMtxVecEdit, StatTimeSerAnalysis, Statistics, Math387, Basic_Form,
     Probabilities; // FMXTee.tatChar, CandleCh;

{$R *.FMX}

{$IFDEF ARITH_USE_LIBM}
function Sin(x: double): double; cdecl;  external libmmodulename name _PU + 'sin';
function Cos(X: double): double; cdecl;  external libmmodulename name _PU + 'cos';
function Exp(x: double): double; cdecl; external libmmodulename name _PU + 'exp';
function Ln(x: double): double; cdecl;  external libmmodulename name _PU + 'log';
function Sqrt(x: double): double; cdecl;  external libmmodulename name _PU + 'sqrt';
function ArcTan(x: double): double; cdecl; external libmmodulename name _PU + 'atan';
{$ENDIF}

procedure TfrmTSPACF.FormCreate(Sender: TObject);
var aPath: string;
begin
  inherited;

  with Memo1.Lines do
  begin
    Clear;
    Add('Data set in this example was collected by H. S. Lew of NIST in 1969 to measure '
        + 'steel-concrete beam deflections. The response variable is the deflection of a '
        + 'beam from the center point.');
    Add('');
    Add('In this example several plot techniques are used to chec if sample data is '
        + 'randomly distributed.');
    Add('[1] Data plot indicates indicates that the data do not have any significant shifts '
        + 'in location or scale over time.');
    Add('[2] The lag plot shows that the data are not random. The lag plot further '
        + 'indicates the presence of a few outliers.');
    Add('[3] When the randomness assumption is thus seriously violated, the histogram '
        + 'can be ignored since determining the distribution of the data is only meaningful '
        + 'when the data are random.');
    Add('[4] The autocorrelation plot shows a distinct cyclic pattern. As with the lag plot, '
        + 'this suggests a sinusoidal model.');
  end;

  myData := TVec.Create;
  vACF := TVec.Create;
  vPACF := TVec.Create;

  { load prepared data }
  aPath := GetDataPath + 'beam_deflection.VEC';
  myData.LoadFromFile(aPath);
///    UpDown1.Max := Data.Length;
//  except
//    myData.Size(200,False);
//    myData.RandGauss;
//  end;

  EditLagsChange(Self); { recalc and display }
end;

procedure TfrmTSPACF.FormDestroy(Sender: TObject);
begin
  vACF.Free;
  vPACF.Free;
  myData.Free;
  inherited;
end;

procedure TfrmTSPACF.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then RadioGroup1ItemIndex := 0;
  if Sender = RadioButton2 then RadioGroup1ItemIndex := 1;
  if Sender = RadioButton3 then RadioGroup1ItemIndex := 2;
  if Sender = RadioButton4 then RadioGroup1ItemIndex := 3;
  if Sender = RadioButton5 then RadioGroup1ItemIndex := 4;

  RadioGroupUpdate;
end;

procedure TfrmTSPACF.RadioGroupUpdate;
var tmp: TChartSeries;


  procedure ToVolumeSeries;
  begin
    tmp := Series1;
    ChangeSeriesType(tmp,TChartSeriesClass(TVolumeSeries));
    with tmp as TVolumeSeries do
    begin
      YOrigin := 0.0;
      UseYOrigin := True;
      Pen.Width := 2;
    end;
  end;
  procedure ToLineSeries;
  begin
    tmp := Series1;
    ChangeSeriesType(tmp,TChartSeriesClass(TLineSeries));
    tmp.Pen.Width := 1;
    (tmp as TLineSeries).Pointer.Visible := False;
  end;
  procedure ToPointSeries;
  begin
    tmp := Series1;
    ChangeSeriesType(tmp,TChartSeriesClass(TPointSeries));
    tmp.Pen.Width := 1;
    with tmp as TPointSeries do
    begin
      Pointer.Style := psStar;
      Pointer.VertSize := 3;
      Pointer.HorizSize := 3;
      Pointer.Visible := True;
    end;
  end;
  procedure ToHistogramSeries;
  begin
    tmp := Series1;
    ChangeSeriesType(tmp,TChartSeriesClass(THistogramSeries));
    tmp.Pen.Width := 1;
  end;

var dX,dY: TVec;
begin
  dX := nil;
  dY := nil;
  case RadioGroup1ItemIndex of
    0:  begin { Data set }
          Chart1.Title.Text.Clear;
          Chart1.Title.Text.Add('Data set');
          Chart1.Axes.Left.Title.Caption := 'Y';
          Chart1.Axes.Bottom.Title.Caption := '';
          Chart1.Axes.Left.Automatic := True;
          ToLineSeries;
          dY := myData;
        end;
    1:  begin { Lag plot }
          Chart1.Title.Text.Clear;
          Chart1.Title.Text.Add('Lag plot');
          Chart1.Axes.Left.Title.Caption := 'Y[i]';
          Chart1.Axes.Bottom.Title.Caption := 'Y[i-1]';
          Chart1.Axes.Left.Automatic := True;
          ToPointSeries;
          { LAG = 1}
          vACF.Length := myData.Length -1;
          vPACF.Length := myData.Length -1;
          vACF.Copy(myData,0,0,vACF.Length);
          vPACF.Copy(myData,1,0,vPACF.Length);
          dx := vACF;
          dY := vPACF;
        end;
    2:  begin  { ACF plot }
          ACF(myData,vACF,Lags);
          Chart1.Title.Text.Clear;
          Chart1.Title.Text.Add('Autocorellation function');
          Chart1.Axes.Left.Title.Caption := 'Autocorellation';
          Chart1.Axes.Bottom.Title.Caption := 'lag';
          Chart1.Axes.Left.Automatic := False;
          Chart1.Axes.Left.SetMinMax(-1,1);
          ToVolumeSeries;
          dY := vACF;
        end;
    3:  begin  { PACF plot }
          ACF(myData,vACF,Lags);
          PACF(vACF,vPACF);
          Chart1.Title.Text.Clear;
          Chart1.Title.Text.Add('Partial autocorellation function');
          Chart1.Axes.Left.Automatic := False;
          Chart1.Axes.Left.SetMinMax(-1,1);
          Chart1.Axes.Left.Title.Caption := 'Partial autocorellation';
          Chart1.Axes.Bottom.Title.Caption := 'lag';
          ToVolumeSeries;
          dY := vPACF;
        end;
    4:  begin { Histogram }
          Chart1.Title.Text.Clear;
          Chart1.Title.Text.Add('Histogram');
          Chart1.Axes.Left.Title.Caption := 'Count';
          Chart1.Axes.Bottom.Title.Caption := 'Y';
          Chart1.Axes.Left.Automatic := True;
          ToHistogramSeries;
          Histogram(myData,20,vACF,vPACF,True);
          dX := vPACF;
          dY := vACF;
        end;
    end;
    if Assigned (dy) then
      if Assigned (dx) then DrawValues(dX,dY,Series1)
      else DrawValues(dY,Series1);
end;

procedure TfrmTSPACF.Button2Click(Sender: TObject);
begin
  ViewValues(myData,'Sample data',True,False,True);
//  UpDown1.Max := Data.Length;
end;

procedure TfrmTSPACF.Chart1BeforeDrawSeries(Sender: TObject);
var ypos: Integer;
begin
  inherited;
  ypos := Chart1.Axes.Left.CalcYPosValue(0.0);
  Chart1.Axes.Bottom.CustomDraw(ypos+5,ypos+15,ypos,True);
end;

procedure TfrmTSPACF.EditLagsChange(Sender: TObject);
begin
  Lags := StrToInt(EditLags.Text);
  RadioGroupUpdate;  { Refresh chart }
end;

procedure TfrmTSPACF.Chart1AfterDraw(Sender: TObject);
var ub,lb: Integer;
begin
  inherited;
  With Chart1.Canvas, Chart1 do
  begin
    if (RadioGroup1ItemIndex = 2) or (RadioGroup1ItemIndex = 3) then
    begin
      if RadioGroup1ItemIndex = 2 then { ACF }
      begin
        ub := Axes.Left.CalcYPosValue(NormalCDF(0.95,0,1.0));
        lb := Axes.Left.CalcYPosValue(-NormalCDF(0.95,0,1.0));
      end else { PACF }
      begin
        ub := Axes.Left.CalcYPosValue(2/Sqrt(myData.Length));
        lb := Axes.Left.CalcYPosValue(-2/Sqrt(myData.Length));
      end;
      ClipRectangle(ChartRect);
      Pen.Color := TAlphaColors.Blue;
      Font.Color := clWhite;
      Line(ChartRect.Left,ub,ChartRect.Right,ub);
      TextOut(ChartRect.Left+100,ub+2,'95% confidence interval');
      Line(ChartRect.Left,lb,ChartRect.Right,lb);
      TextOut(ChartRect.Left+100,lb-12,'95% confidence interval');
      UnclipRectangle;
    end;
  end;

end;

initialization
  RegisterClass(TfrmTSPACF);

end.
