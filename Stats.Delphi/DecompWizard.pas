unit DecompWizard;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  FMX.Header,
  Basic_Wizard,
  MtxVec, Math387, FMX.Dialogs, FMX.Layouts, FMX.Memo, FMX.Edit, FMX.StdCtrls,
  FMX.TabControl, FMX.Controls, FMX.Types, FmxMtxComCtrls,
  FMX.Controls.Presentation;



type
  TfrmDecompositionWizard = class(TfrmBasicWizard)
    tsInputData: TTabItem;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    btnLoad: TButton;
    chartData: TChart;
    chkCycle: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog: TOpenDialog;
    tsTextReport: TTabItem;
    RichEdit: TMemo;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    EditFmtString: TEdit;
    Label3: TLabel;
    editCycle: TEdit;
    tsChartReport: TTabItem;
    reportChart: TChart;
    EditSeasons: TMtxFloatEdit;
    editForecasts: TMtxFloatEdit;
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkLOGClick(Sender: TObject);
    procedure editSeasonsChange(Sender: TObject);
    procedure EditFmtStringChange(Sender: TObject);
    procedure editForecastsChange(Sender: TObject);
    procedure chkCycleClick(Sender: TObject);
  private
    { Private declarations }
    Data: TVec;
    Yv,Mv,Tv: TVec;
    L,l2 :Integer; { MA period }
    a,b,dmean: TSample; { trend parameters }
    Cv,Kv,Sv,Rv: TVeC;
    Forecasts, Residuals: TVec;
    ChartIndex: Integer;
    ForNum: Integer;
    ForCycle: TSample;
    procedure TransformTimeSeries;
    procedure MovAve;
    procedure Trend;
    procedure Seasonality;
    procedure Randomness;
    procedure DoForecasts;
    procedure DoCalc;
    procedure RefreshChart;
    procedure TextReport;
    procedure ChartReport(AIndex: Integer);
  protected
    // These three methods control wizard behavoir
    procedure RefreshWizardControls; override;
    procedure DoMoveForward; override;
    procedure DoMoveBack; override;
  public
    { Public declarations }
    TimeSeries: TVec;
    procedure UpdateData;
  end;

var
  frmDecompositionWizard: TfrmDecompositionWizard;

implementation

{$R *.FMX}

Uses FmxMtxVecTee, Regress, Statistics, StatTimeSerAnalysis,
  RegModels;

const
  firstchartindex = 2;
  lastchartindex = 7;

procedure TfrmDecompositionWizard.DoMoveBack;
begin
  if (PageControl.ActiveTab = tsChartReport) and (chartindex>firstchartindex) then
  begin
    Dec(chartindex);
    ChartReport(chartindex);
    moveback := false;
  end else moveback := true;

  inherited DoMoveBack;
end;

procedure TfrmDecompositionWizard.DoMoveForward;
begin
  if (PageControl.ActiveTab = tsChartReport) and (chartindex<lastchartindex) then
  begin
    Inc(chartindex);
    moveforward := false;
  end else moveforward := true;

  inherited DoMoveForward;

  if (PageControl.ActiveTab = tsTextReport) then TextReport
  else if (PageControl.ActiveTab = tsChartReport) then ChartReport(chartindex);

end;

procedure TfrmDecompositionWizard.RefreshWizardControls;
begin
  inherited;
  if PageControl.ActiveTab = tsInputData then btnNext.Enabled := (TimeSeries.Length > 0)
  else if PageControl.ActiveTab = tsChartReport then btnNext.Enabled := chartindex < lastchartindex;
end;


procedure TfrmDecompositionWizard.btnLoadClick(Sender: TObject);
var sl: TStringList;
begin
  if OpenDialog.Execute then
  try
    { 1 = native format, 2=column text file }
    if OpenDialog.FilterIndex = 1 then TimeSeries.LoadFromFile(OpenDialog.FileName)
    else if OpenDialog.FilterIndex = 2 then
    begin
      sl := TStringList.Create;
      try
        sl.LoadFromFile(OpenDialog.FileName);
        TimeSeries.StringsToValues(sl);
      finally
        sl.Free;
      end;
    end;
    TimeSeries.Caption := OpenDialog.FileName;
  finally
    TransformTimeSeries;
    RefreshChart;
  end;
end;

procedure TfrmDecompositionWizard.RefreshChart;
begin
  DrawValues(timeSeries,chartData[0]);
  DoCalc;
end;

procedure TfrmDecompositionWizard.TransformTimeSeries;
begin
  Data.Copy(TimeSeries);
  EditSeasons.MaxValue := IntToStr(TimeSeries.Length);
end;

procedure TfrmDecompositionWizard.FormCreate(Sender: TObject);
begin
  inherited;
  TimeSeries := TVec.Create;
  Data := TVec.Create;
  Yv := TVec.Create;
  Mv := TVec.Create;
  Tv := TVec.Create;
  Cv := TVec.Create;
  Kv := TVec.Create;
  Sv := TVec.Create;
  Rv := TVec.Create;
  Forecasts := TVec.Create;
  Residuals := TVec.Create;
  L := 1;
  ForNum := 10;
  ForCycle := 1.0;
  EditCycle.Text := FormatSample('0.00',ForCycle);
  chartindex := firstchartindex;
end;

procedure TfrmDecompositionWizard.UpdateData;
begin
  { initialize page }
  PageControl.ActiveTab := tsInputData;
  lblHeader.Text := 'Step 1 : Decomposition forecasting parameters';
  EditFmtString.Text := FormatString;
  RefreshWizardControls;

  TransformTimeSeries;
  RefreshChart;
end;

procedure TfrmDecompositionWizard.FormDestroy(Sender: TObject);
begin
  TimeSeries.Free;
  Data.Free;
  Yv.Free;
  Mv.Free;
  Tv.Free;
  Cv.Free;
  Kv.Free;
  Sv.Free;
  Rv.Free;
  Forecasts.Free;
  Residuals.Free;
  inherited;
end;

procedure TfrmDecompositionWizard.chkLOGClick(Sender: TObject);
begin
  TransformTimeSeries;
  RefreshChart;
end;


procedure TfrmDecompositionWizard.editSeasonsChange(Sender: TObject);
begin
  L := EditSeasons.IntPosition;
  TransformTimeSeries;
  RefreshChart;
end;

procedure TfrmDecompositionWizard.MovAve;
var v1: TVec;
  MInd,i : Integer;
  eind: Integer;
begin
  if L <=2 then MovingAverage(Yv,L,Mv,MInd)
  else
  begin
    v1 := TVec.Create;
    try
      eind := (Yv.Length-1)+l2+1;
      v1.Size(Yv.Length+l2*2);
      v1.Copy(Yv,0,l2+1,Yv.Length);
      for i := 0 to l2 do
      begin
        v1.Values[i] := v1.Values[i+L];
        v1.Values[eind+i-1] := v1.Values[eind-L+i];
      end;
      MovingAverage(v1,L,Mv,MInd);
    finally
      v1.Free;
    end;
  end
end;

procedure TfrmDecompositionWizard.Trend;
var x,bv: TVec;
begin
  x := TVec.Create;
  bv := TVec.Create;
  try
    x.Size(Mv);
    x.Ramp;
    { perform fit on truncated MA because first l2+1 and last l2+1  problem (see NIST pages) }
    x.SetSubRange(l2,x.Length-2*l2);
    Mv.SetSubRange(l2,Mv.Length-2*l2);
    LineFit(bv,x,Mv);
    { but evaluate on whole interval }
    x.SetSubRange;
    Mv.SetSubRange;
    a := bv.Values[0];
    b := bv.Values[1];
    LineEval([a,b],x,Tv);
  finally
    x.Free;
    bv.Free;
  end;
end;

procedure TfrmDecompositionWizard.Seasonality;
var i,j,n : Integer;
  sum : TSample;
begin
  Kv.Divide(Yv,Mv);
  Sv.Size(L);
  for i := 0 to L-1 do
  begin
    sum := 0.0;
    j := 0;
    n := 0;
    while (j+i<Kv.Length) do
    begin
      sum := sum + Kv.Values[j+i];
      j := j + L;
      n := n+1;
    end;
    if n>1 then Sv.Values[i] := sum/n else Sv.Values[i] := 0.0;
  end;
end;

procedure TfrmDecompositionWizard.Randomness;
var i: Integer;
    plen: Integer;
begin
  plen := Sv.Length;
  Rv.Size(Kv);
  for i := 0 to Rv.Length -1 do Rv.Values[i] := Kv.Values[i]/Sv.Values[i mod plen];
end;


procedure TfrmDecompositionWizard.DoCalc;
begin
  { read parameters }
  L := StrToInt(EditSeasons.Text);
  l2 := (L-1) div 2; {l/2 period end index }
  ForNum := StrToInt(editForecasts.Text);

  { #1 : Remove mean }
  dmean := Data.Mean;
  Yv.Copy(Data);
  Yv.Mul(1.0/dmean);
  DrawValues(Yv,chartData[0]);

  { #2 : Moving average on Y }
  MovAve;
  DrawValues(Mv,chartData[1]);

  { #3 : Trend on M }
  Trend;
  DrawValues(Tv,chartData[2]);

  { #4 : Cycle }
  Cv.Divide(Mv,Tv);

  { #5 :  Seasonality }
  Seasonality;

  { #6 : Randomness }
  Randomness;
end;

procedure TfrmDecompositionWizard.TextReport;
var st: String;
  i: Integer;
begin
  DoCalc;
  DoForecasts;
  RichEdit.Lines.Clear;

//  RichEdit.Paragraph.TabCount := 8;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];

  RichEdit.Lines.Add('Forecast summary');
  st := 'Mean x (Trend) x ';
  if chkCycle.IsChecked then st := st + '(Cycle) x ';
  st := st + '(Season)';
  RichEdit.Lines.Add('Model:'+chr(9)+st);
  RichEdit.Lines.Add('Rows:'+chr(9)+IntToStr(Data.Length));
  RichEdit.Lines.Add('Mean:'+chr(9)+FormatSample(FormatString,TimeSeries.Mean));
  RichEdit.Lines.Add('Residuals RMS:'+chr(9)+FormatSample(FormatString,Residuals.RMS));


  RichEdit.Lines.Add('Trend'+chr(9)+'('+FormatSample(FormatString,a) + ') +('+ FormatSample(FormatString,b)+') x Time');
  RichEdit.Lines.Add('Seasons:'+chr(9)+IntToStr(L));
  RichEdit.Lines.Add('Seasonal component ratio:');
  RichEdit.Lines.Add('No'+chr(9)+'Ratio');
  for i := 0 to L -1 do
    RichEdit.Lines.Add(IntToStr(i+1)+chr(9)+FormatSample(FormatString,Sv.Values[i]));
  RichEdit.Lines.Add('');

  { forecasts section }
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Forecast');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Time'+chr(9)+'Foreast'+chr(9)+'Actual'+chr(9)+'Residuals'+chr(9)+'Trend factor'+chr(9)+'Cycle'+chr(9)+'Season'+chr(9)+'Randomness');
  for i := 0 to Forecasts.Length-1 do
  begin
    st := IntToStr(i)+chr(9)+FormatSample(FormatString,Forecasts.Values[i])+chr(9);
    if i<Data.Length then st := st + FormatSample(FormatString,Data.Values[i])+chr(9)+FormatSample(FormatString,Residuals.Values[i])+chr(9)
    else st := st+chr(9)+chr(9);
    st := st + FormatSample(FormatString,Tv.Values[i]) + chr(9);
    if (chkCycle.IsChecked) then st := st+ FormatSample(FormatString,Cv.Values[i])+chr(9) else st := st + chr(9);
    st := st + FormatSample(FormatString,Sv.Values[i])+chr(9);
    st := st + FormatSample(FormatString,Rv.Values[i]);
    RichEdit.Lines.Add(st);
  end;
end;

procedure TfrmDecompositionWizard.EditFmtStringChange(Sender: TObject);
begin
  FormatString := EditFmtString.Text;
  try
    FormatFloat(FormatString,1.22);  { dummy test }
  except
  end;
end;


procedure TfrmDecompositionWizard.ChartReport(AIndex: Integer);
begin
  reportChart.FreeAllSeries(nil);
  reportChart.Title.Text.Clear;
  reportChart.Legend.Visible := False;
  case AIndex of
  firstchartindex: { forecasts }
    begin
      reportChart.Legend.Visible := True;
      reportChart.Title.Text.Add('Forecasts');
      reportChart.AddSeries(TPointSeries.Create(reportChart));
      reportChart.AddSeries(TLineSeries.Create(reportChart));
      with (reportChart.Series[0] as TPointSeries) do
      begin
        Title := 'Time series';
        Pointer.VertSize := 2;
        Pointer.HorizSize := 2;
      end;
      reportChart.Series[1].Title := 'Forecasts';
      DrawValues(TimeSeries,reportChart.Series[0]);
      DrawValues(Forecasts,reportChart.Series[1]);
    end;
  firstchartindex+1: { residuals }
    begin
      reportChart.Title.Text.Add('Residuals');
      reportChart.AddSeries(TLineSeries.Create(reportChart));
      DrawValues(Residuals,reportChart.Series[0]);
    end;
  firstchartindex+2: { Trend factor plot }
    begin
      reportChart.Title.Text.Add('Trend factor (T)');
      reportChart.AddSeries(TBarSeries.Create(reportChart));
      with (reportChart.Series[0] as TBarSeries) do
      begin
        Marks.Visible := False;
        YOrigin := 1.0;
        UseYOrigin := True;
      end;
      DrawValues(Tv,reportChart.Series[0]);
    end;
  firstchartindex+3: { Cycle }
    begin
      reportChart.Title.Text.Add('Cycle factor (C)');
      reportChart.AddSeries(TBarSeries.Create(reportChart));
      with (reportChart.Series[0] as TBarSeries) do
      begin
        Marks.Visible := False;
        YOrigin := 1.0;
        UseYOrigin := True;
      end;
      DrawValues(Cv,reportChart.Series[0]);
    end;
  firstchartindex+4: { Seasonality }
    begin
      reportChart.Title.Text.Add('Seasonality factor (S)');
      reportChart.AddSeries(TLineSeries.Create(reportChart));
      DrawValues(Sv,reportChart.Series[0]);
    end;
  firstchartindex+5: { Randomness }
    begin
      reportChart.Title.Text.Add('Randomness factor (R)');
      reportChart.AddSeries(TLineSeries.Create(reportChart));
      DrawValues(Rv,reportChart.Series[0]);
    end;
 end;
end;

procedure TfrmDecompositionWizard.DoForecasts;
var xv: TVec;
  i : Integer;
begin
  xv := TVec.Create;
  try
    Forecasts.Size(Data.Length + ForNum);
    { Mean }
    Forecasts.SetVal(dmean);

    { Trend component }
    xv.Size(Forecasts);
    xv.Ramp;
    LineEval([a,b],xv,Tv);
    Forecasts.Mul(Tv);

    { Seasonality }
    Sv.Resize(Forecasts.Length);
    for i := L to Sv.Length -1 do Sv.Values[i] := sv.values[i mod L];
    Forecasts.Mul(Sv);

    { add cycle factor, if specified }
    if chkCycle.IsChecked then
    begin
      Cv.Resize(Forecasts.Length);
      Cv.SetVal(StrToFloat(editCycle.Text),Data.Length,ForNum);
      Forecasts.Mul(Cv);
    end;

    { define R factor as 1.0 for forecasts }
    Rv.Resize(Forecasts.Length);
    Rv.SetVal(1.0,Data.Length,ForNum);

    { calculate residuals}
    Residuals.Size(Data);
    Residuals.Sub(Data,Forecasts,0,0,0,Data.Length);
  finally
    xv.Free;
  end;
end;

procedure TfrmDecompositionWizard.editForecastsChange(Sender: TObject);
begin
   ForNum := editForecasts.IntPosition;
end;

procedure TfrmDecompositionWizard.chkCycleClick(Sender: TObject);
begin
  Label3.Enabled := chkCycle.IsChecked;
  EditCycle.Enabled := chkCycle.IsChecked;
end;

end.
