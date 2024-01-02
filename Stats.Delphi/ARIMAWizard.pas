unit ARIMAWizard;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Wizard, MtxVec, Math387, StatTimeSerAnalysis, MtxExpr, FmxMtxComCtrls,
  FMX.Dialogs, FMX.Layouts, FMX.Memo, FMX.Edit, FMX.TabControl, FMX.Controls,
  FMX.Types, FMXTee.Series.Candle, FMXTee.Canvas, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.ScrollBox;


type
  TfrmARIMAWizard = class(TfrmBasicWizard)
    tsInputData: TTabItem;
    tsDefineModel: TTabItem;
    OpenDialog: TOpenDialog;
    tsDefineReport: TTabItem;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    editAROrder: TEdit;
    editMAOrder: TEdit;
    lblModel: TLabel;
    gbPhiThetaEdit: TGroupBox;
    btnEditPhi: TButton;
    btnEditTheta: TButton;
    gbInnovationsLag: TGroupBox;
    EditInnoLag: TEdit;
    Label5: TLabel;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    editForecastNo: TEdit;
    Label7: TLabel;
    editACFLag: TEdit;
    tsTextReport: TTabItem;
    RichEdit: TMemo;
    tsChart: TTabItem;
    Chart: TChart;
    GroupBox5: TGroupBox;
    chkDoMLE: TCheckBox;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    btnLoad: TButton;
    chkBoxRemoveMean: TCheckBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label8: TLabel;
    EditFmtString: TEdit;
    editAlpha: TEdit;
    chartData: TChart;
    Label3: TLabel;
    GroupBox6: TGroupBox;
    lblLength: TLabel;
    lblMean: TLabel;
    lblStdDev: TLabel;
    lblVariance: TLabel;
    GroupBox7: TGroupBox;
    lblTrSize: TLabel;
    lblTrMean: TLabel;
    lblTrStdDev: TLabel;
    lblTrVar: TLabel;
    chkAddMean: TCheckBox;
    chkIntegrate: TCheckBox;
    EditD: TMtxFloatEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ArButton1: TRadioButton;
    ArButton2: TRadioButton;
    ArButton3: TRadioButton;
    rgArmaInitIndex3: TRadioButton;
    rgArmaInitIndex4: TRadioButton;
    rgArmaInitIndex0: TRadioButton;
    PlotGroupBox: TGroupBox;
    rgArmaInit: TGroupBox;
    rgArmaInitIndex1: TRadioButton;
    rgArmaInitIndex2: TRadioButton;
    rgArInit: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditFmtStringChange(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure editAROrderChange(Sender: TObject);
    procedure editMAOrderChange(Sender: TObject);
    procedure editDChange(Sender: TObject);
    procedure rgARInitClick(Sender: TObject);
    procedure rgARMAInitClick(Sender: TObject);
    procedure btnEditPhiClick(Sender: TObject);
    procedure btnEditThetaClick(Sender: TObject);
    procedure EditInnoLagChange(Sender: TObject);
    procedure editForecastNoChange(Sender: TObject);
    procedure editACFLagChange(Sender: TObject);
    procedure editAlphaChange(Sender: TObject);
    procedure chkBoxRemoveMeanClick(Sender: TObject);
    procedure rgPlotClick(Sender: TObject);
    procedure chartDataBeforeDrawSeries(Sender: TObject);
    procedure chartDataAfterDraw(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure ArButton1Change(Sender: TObject);
    procedure rgArmaInitIndex3Change(Sender: TObject);
    procedure chkDoMLEChange(Sender: TObject);
  private
    { Private declarations }
    Data,Residuals,Forecasts,
    FStdDev,phi,theta: Vector;
    phiinit,thetainit: Vector;
    p,q,d,MaxLag,ForecastPer,ACFLag: Integer;
    dMean: double;
    InitM: TcfInitMethod;
    Alpha: double;
    ChartIndex: Integer;
    chartLCL,chartUCL: double;
    function CoeffReport(coeff,cstderrs: TVec; coefCaption: string): String; overload;
    function CoeffReport(coeff: TVec; coefCaption: string): String; overload;
    procedure InfoReport;
    procedure RefreshChart;
    procedure UpdateModelInfo;
    function ModelText:String;
    procedure TextReport;
    procedure InitEstReport;
    procedure CausalReport;
    procedure MLEReport;
    procedure ForecastReport;
    procedure ChartReport(Ind: Integer);
    procedure TransformTimeSeries;
  protected
    // These three methods control wizard behavoir
    procedure RefreshWizardControls; override;
    procedure DoMoveForward; override;
    procedure DoMoveBack; override;
  public
    { Public declarations }
    rgARInitItemIndex: integer;
    rgPlotItemIndex: integer;
    rgARMAInitItemIndex: integer;
    TimeSeries: TVec; { stores original data }
    procedure UpdateData;
  end;

var
  frmARIMAWizard: TfrmARIMAWizard;

implementation

{$R *.FMX}

Uses Statistics, FmxMtxVecEdit, FmxMtxVecTee, Probabilities, MtxVecUtils, AbstractMtxVec;

const
  firstchartindex = 4;
  lastchartindex = 4;

procedure TfrmARiMAWizard.UpdateData;
begin
  { initialize page }
  PageControl.ActiveTab := tsInputData;
  EditFmtString.Text := FormatString;

  editAROrderChange(nil);
  editMAOrderChange(nil);

  UpdateModelInfo;
  InfoReport;
end;


procedure TfrmARIMAWizard.FormCreate(Sender: TObject);
begin
  inherited;
  rgARMAInitItemIndex := 1;
  rgARInitItemIndex := 1;

  TimeSeries := TVec.Create;
  chartData.AddSeries(TLineSeries.Create(chartData));
  { initial values for different parameters }
  MaxLag := -1;
  ForecastPer := 40;
  ACFLag := -1;
  p := 0;
  q := 0;
  d := 0;
  InitM := TCfInitMethod(rgArmaInitItemIndex);
  Alpha := 0.05;

  { update visual controls }
  EditInnoLag.Text := IntToStr(MaxLag);
  editForecastNo.Text := IntToStr(ForecastPer);

  EditAlpha.Text := FormatSample(FormatString,Alpha);
  chartindex := firstchartindex;

  EditFmtString.Text := FormatString;
end;

procedure TfrmARIMAWizard.FormDestroy(Sender: TObject);
begin
  TimeSeries.Free;
  inherited;
end;

procedure TfrmARIMAWizard.EditFmtStringChange(Sender: TObject);
begin
  FormatString := EditFmtString.Text;
  try
    FormatFloat(FormatString,1.22);  { dummy test }
  except
  end;
  InfoReport;
end;

procedure TfrmARIMAWizard.btnLoadClick(Sender: TObject);
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
    InfoReport;
  end;
end;

procedure TfrmARIMAWizard.InfoReport;
var sd: double;
begin
  sd := TimeSeries.StdDev;
  lblLength.Text := 'size : '+IntToStr(TimeSeries.Length);
  lblMean.Text := 'mean : '+FormatSample(TimeSeries.Mean,FormatString);
  lblStdDev.Text := 'std.dev. : '+FormatSample(sd,FormatString);
  lblVariance.Text := 'variance : '+FormatSample(Sqr(sd),FormatString);
  TransformTimeSeries;
  { transformed series ... }
  sd := Data.StdDev;
  lblTrSize.Text := 'size : '+IntToStr(Data.Length);
  lblTrMean.Text := 'mean : '+FormatSample(Data.Mean,FormatString);
  lblTrStdDev.Text := 'std.dev. : '+FormatSample(sd,FormatString);
  lblTrVar.Text := 'variance : '+FormatSample(Sqr(sd),FormatString);
  { draw transformed time series }
  RefreshChart;
end;
procedure TfrmARIMAWizard.editAROrderChange(Sender: TObject);
begin
  p := StrToInt(editAROrder.Text);
  phi.Size(p);
  phi.SetZero;
  phiinit.Size(phi);
  phiinit.SetZero;
  UpdateModelInfo;
  RefreshWizardControls;
end;

procedure TfrmARIMAWizard.editMAOrderChange(Sender: TObject);
begin
  q := StrToInt(editMAOrder.Text);
  theta.Size(q);
  theta.SetZero;
  thetainit.Size(theta);
  thetainit.SetZero;
  UpdateModelInfo;
  RefreshWizardControls;
end;

procedure TfrmARIMAWizard.editDChange(Sender: TObject);
begin
  d := editD.IntPosition;
  chkIntegrate.Enabled := (d>0);
  UpdateModelInfo;
  InfoReport;
end;

function TfrmARIMAWizard.ModelText: String;
begin
  Result := '';
  if d = 0 then
  begin
    if (q=0) and (p<>0) then Result := 'AR ('+IntToStr(p)+')'
    else if (p=0) and (q<>0) then Result := 'MA ('+IntToStr(q)+')'
    else if (p<>0) and (q<>0) then Result := 'ARMA ('+IntToStr(p)+','+IntToStr(q)+')'
  end
  else if (p<>0) or (q<>0) then Result := 'ARIMA ('+IntToStr(p)+','+IntToStr(q)+','+IntToStr(d)+')'
end;

procedure TfrmARIMAWizard.UpdateModelInfo;
begin
  lblModel.Text := 'Model : '+ModelText;
  rgARInit.Visible := (p<>0) and (q=0);
  rgARMAInit.Visible := Not(rgARInit.Visible);
  gbPhiThetaEdit.Visible := (InitM = cfInitFixed);
  gbInnovationsLag.Visible := (InitM = cfInitInno);
end;

procedure TfrmARIMAWizard.rgARInitClick(Sender: TObject);
begin
  InitM := TcfInitMethod(rgARInitItemIndex);
  UpdateModelInfo;
end;

procedure TfrmARIMAWizard.rgARMAInitClick(Sender: TObject);
begin
  InitM := TcfInitMethod(rgARMAInitItemIndex);
  UpdateModelInfo;
end;

procedure TfrmARIMAWizard.ArButton1Change(Sender: TObject);
begin
  if Sender = ArButton1 then rgArInitItemIndex := 0;
  if Sender = ArButton2 then rgArInitItemIndex := 1;
  if Sender = ArButton3 then rgArInitItemIndex := 2;
  rgARInitClick(nil);
end;

procedure TfrmARIMAWizard.rgArmaInitIndex3Change(Sender: TObject);
begin
  if Sender = rgArmaInitIndex0 then rgArmaInitItemIndex := 0;
  if Sender = rgArmaInitIndex1 then rgArmaInitItemIndex := 1;
  if Sender = rgArmaInitIndex2 then rgArmaInitItemIndex := 2;
  if Sender = rgArmaInitIndex3 then rgArmaInitItemIndex := 3;
  if Sender = rgArmaInitIndex4 then rgArmaInitItemIndex := 4;
  rgARMAInitClick(nil);
end;

procedure TfrmARIMAWizard.btnEditPhiClick(Sender: TObject);
begin
  ViewValues(phiinit,'Editing phi coeffs.',True,True,True);
end;

procedure TfrmARIMAWizard.btnEditThetaClick(Sender: TObject);
begin
  ViewValues(thetainit,'Editing theta coeffs.',True,True,True);
end;

procedure TfrmARIMAWizard.EditInnoLagChange(Sender: TObject);
begin
  MaxLag := StrToInt(EditInnoLag.Text);
end;

procedure TfrmARIMAWizard.editForecastNoChange(Sender: TObject);
begin
  ForecastPer := StrToInt(EditForecastNo.Text);
end;

procedure TfrmARIMAWizard.editACFLagChange(Sender: TObject);
begin
  ACFLag := StrToInt(EditACFLag.Text);
end;

procedure TfrmARIMAWizard.TextReport;
begin
  { this is the actual ts used in calculations }
  TransformTimeSeries;
  if InitM = cfInitFixed then
  begin
    phi.Copy(phiinit);
    theta.Copy(thetainit);
  end;

  RichEdit.Enabled := false;
  RichEdit.Lines.Clear;

  SetHourGlassCursor;
  try
//    RichEdit.DefAttributes.Color := clBlack;
//    RichEdit.DefAttributes.Pitch := fpFixed;
//    RichEdit.DefAttributes.Style := [];
//    RichEdit.SelAttributes.Style := [fsBold];
//    RichEdit.SelAttributes.Size := 10;
    RichEdit.Lines.Add('Analyzing ' +timeSeries.Caption);
    RichEdit.Lines.Add(Chr(13));
    RichEdit.Lines.Add(Chr(13));
    InitEstReport;
    if chkDoMLE.IsChecked then MLEReport;
    ForecastReport;
  finally
    RichEdit.Enabled := true;
    ResetCursor;
  end;
end;

procedure TfrmARIMAWizard.InitEstReport;
var estVar: double;
  d1,d2: Vector;
  innolag : Integer;
begin
  RichEdit.Lines.Add('Preliminary estimates for '+ModelText+ ' process coefficients');
  if MaxLag<0 then innolag := Ceil(10*Log10(Data.Length)) else innolag := MaxLag;
  estVar := 1.0;
  if (p>0) then
  begin
    d1.Size(p);
    d1.SetZero;
  end;
  if (q>0) then
  begin
    d2.Size(q);
    d2.SetZero;
  end;

  // Retrieve coefficients
  case (InitM) of
    cfInitYW:
      begin
        ARYuleWalkerFit(Data,phi,estVar,d1);
        RichEdit.Lines.Add('Method used: Yule-Walker');
      end;
    cfInitBurg:
      begin
        ARBurgFit(Data,phi,estVar,d1);
        RichEdit.Lines.Add('Method used: Burg');
      end;
    cfInitInno:
      begin
        if (p=0) then ARMAInnovationsFit(Data,theta,estVar,d2,innolag)
        else ARMAInnovationsFit(Data,phi,theta,estVar,d1,d2,innolag);
        RichEdit.Lines.Add('Method used: Innovations');
      end;
    cfInitHannah:
      begin
        ARMAHannahFit(Data, Phi,Theta, estVar);
        RichEdit.Lines.Add('Method used: Hannah');
      end;
  end;

  if (InitM<>cfInitFixed) then RichEdit.Lines.Add('Estimated WN variance: ' + FormatSample(FormatString,estVar));

  CausalReport;
  RichEdit.Lines.Add('');
  RichEdit.Lines.Add('Model coefficients:');
//  RichEdit.Paragraph.TabCount := 5;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Coefficient'+#9+'Coefficient'+#9+'Standard'+#9+'T-value'+#9+'P-value');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('name'+#9+'estimate'+#9+'error'+#9+'Ho:Coef.=0'+#9);
  if (p>0) then RichEdit.Lines.Add(CoeffReport(phi,d1,'AR'));
  if (q>0) then RichEdit.Lines.Add(CoeffReport(theta,d2,'MA'));
end;

procedure TfrmARIMAWizard.CausalReport;
begin
  if p > 0 then  //if all ar roots are outside of uing circyle
  begin
      if CheckARMACoeffs(Phi, True) then RichEdit.Lines.Add('Model causal') else RichEdit.Lines.Add('Model not causal');
      if CheckARMACoeffs(Phi, False) then RichEdit.Lines.Add('Model stationary') else RichEdit.Lines.Add('Model not stationary');
  end;
  if q > 0 then
  begin
      if CheckARMACoeffs(Theta,False) then
      begin
          RichEdit.Lines.Add('Model invertible')
      end else
      begin
          RichEdit.Lines.Add('Model not invertible');
      end;
  end;
end;

procedure TfrmARIMAWizard.editAlphaChange(Sender: TObject);
begin
  try
    Alpha := StrToFloat(EditAlpha.Text);
    if (Alpha >1) or (Alpha <0) then
    begin
      Alpha := 0.05;
      EditAlpha.Text := FormatSample(FormatString,Alpha);
    end;
  except
    Alpha := 0.05;
    EditAlpha.Text := FormatSample(FormatString,Alpha);
  end;
  RefreshChart;
end;

procedure TfrmARIMAWizard.MLEReport;
var MLE: double;
  iters: Integer;
begin
  try
    iters := ARMAMLE(Data,phi,theta,Residuals,mle, dMean);
//    RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
    RichEdit.Lines.Add('Finding optimal coefficients (MLE)');
    RichEdit.Lines.Add('Number of iterations needed : '+IntToStr(iters));
    RichEdit.Lines.Add('-2log(likelihood) :'+FormatSample(FormatString,mle));
    CausalReport;
    RichEdit.Lines.Add('');
    RichEdit.Lines.Add('Model coefficients:');
//    RichEdit.Paragraph.TabCount := 5;
//    SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//    RichEdit.SelAttributes.Color := clBlue;
    RichEdit.Lines.Add('Coefficient'+#9+'Coefficient');
//    RichEdit.SelAttributes.Color := clBlue;
    RichEdit.Lines.Add('name'+#9+'estimate');
    if (p>0) then RichEdit.Lines.Add(CoeffReport(phi,'AR'));
    if (q>0) then RichEdit.Lines.Add(CoeffReport(theta,'MA'));
  finally
  end;
end;

procedure TfrmARIMAWizard.ForecastReport;
var i: Integer;
    v0: Vector;
    endperiod: Integer;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Forecasting '+IntToStr(ForecastPer)+' points');
  SetHourGlassCursor;
  try
     ARMAForecast(Data, phi, theta, residuals, ForecastPer, dMean, Forecasts, FStdDev);

    { integrate, if required }
    if (d>0) and (chkIntegrate.IsChecked) then
    begin
      { setup initial values for integration }
      TimeSeriesIntInit(TimeSeries,v0,d);
      { integrate d times }
      Forecasts.Integrate(v0);
      endperiod := Data.Length + d-1;
    end else endperiod := Data.Length-1;

//    RichEdit.Paragraph.TabCount := 3;
//    SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//    RichEdit.SelAttributes.Color := clBlue;
    RichEdit.Lines.Add('Period'+chr(9)+'Forecast'+chr(9)+'Forecast std.dev.');
    for i := 1 to ForecastPer do
      RichEdit.Lines.Add(IntToStr(i+endperiod)+chr(9)+FormatSample(FormatString,Forecasts[i-1])+chr(9)
                        +FormatSample(FormatString,FStdDev[i-1]));

    RichEdit.Lines.Add('');
  finally
//    Screen.Cursor := crDefault;
    ResetCursor;
  end;
end;

procedure TfrmARIMAWizard.ChartReport(Ind: Integer);
var v1,v2: Vector;
    i: Integer;
    offset: Integer;
begin
  Chart.FreeAllSeries(nil);
  Chart.Title.Text.Clear;
  Chart.Legend.Visible := False;
  Chart.Axes.Bottom.Visible := False;
  Chart.Axes.Left.Automatic := True;
  case Ind of
  firstchartindex: { forecasts }
    begin
      Chart.Axes.Bottom.Visible := True;
      Chart.Legend.Visible := True;
      Chart.AddSeries(TLineSeries.Create(Chart));
      { forecasts }
      Chart.AddSeries(TLineSeries.Create(Chart));
      { upper and lower ci }
      Chart.AddSeries(TLineSeries.Create(Chart));
      Chart.AddSeries(TLineSeries.Create(Chart));
      Chart[0].Title := 'Time series';
      Chart[1].Color := TAlphaColors.Gray;
      Chart[1].Title := 'Forecasts';
      Chart[2].Color := TAlphaColors.Yellow;
      Chart[2].Title := 'CI';
      Chart[3].Color := TAlphaColors.Yellow;
      Chart[3].ShowInLegend := False;
      v1.Copy(data);
      { add mean, if required }
//      if (chkBoxRemoveMean.IsChecked) and (chkAddMean.IsChecked) then v1.Add(dMean);
      { integrate }
      if (d>0) and (chkIntegrate.IsChecked) then
      begin
        TimeSeriesIntInit(TimeSeries,v2,d,False);
        v1.Integrate(v2);
        DrawValues(v1,Chart[0],d);
        offset := v1.Length+d;
      end else
      begin
        DrawValues(v1,Chart[0]);
        offset := v1.Length;
      end;
      { forecasts }
      DrawValues(Forecasts,Chart[1],offset);
      v1.Size(Forecasts);
      v2.Size(Forecasts);
      for i := 0 to v1.Length-1 do
      begin
        v1[i] := NormalCDFInv(0.5*Alpha,Forecasts[i],FStdDev[i]);
        v2[i] := NormalCDFInv(1.0 - 0.5*Alpha,Forecasts[i],FStdDev[i]);
      end;
      DrawValues(v1,Chart[2],offset);
      DrawValues(v2,Chart[3],offset);
      Chart.Title.Text.Add(ModelText+': Forecasting up to '+IntToStr(Forecasts.Length) + ' points');
    end;
  end;
end;

procedure TfrmARIMAWizard.chkBoxRemoveMeanClick(Sender: TObject);
begin
  InfoReport;
  chkAddMean.Enabled := chkBoxRemoveMean.IsChecked;
end;

procedure TfrmARIMAWizard.chkDoMLEChange(Sender: TObject);
begin
  inherited;

end;

{ transformations on original time series }
procedure TfrmARIMAWizard.TransformTimeSeries;
var i: Integer;
begin
  Data.Copy(timeSeries);
  { differenciate, if needed }
  if d>0 then for i := 1 to d do Data.Difference;
  dMean := Data.Mean;
  { remove mean, if needed }
//  if chkBoxRemoveMean.IsChecked then Data.Add(-dMean);
end;

procedure TfrmARIMAWizard.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then rgPlotItemIndex := 0;
  if Sender = RadioButton2 then rgPlotItemIndex := 1;
  if Sender = RadioButton3 then rgPlotItemIndex := 2;
  rgPlotClick(nil);
end;

procedure TfrmARIMAWizard.RefreshChart;
var v1,v2: Vector;
begin
  { recalculate lb and ub for acf and pacf chart }
  if rgPlotItemIndex <> 0 then
  begin
    chartUCL := NormalCDFInv(1.0-0.5*Alpha,0.0,1.0)/{$IFDEF POSIX}Math387.{$ENDIF}Sqrt(Data.Length);
    chartLCL := - chartUCL;
  end;
  ChartData.FreeAllSeries(nil);
  ChartData.Title.Text.Clear;
  ChartData.Legend.Visible := False;
  ChartData.Axes.Bottom.Visible := False;
  ChartData.Axes.Left.Automatic := True;
  ChartData.Axes.Bottom.Automatic := True;
  case rgPlotItemIndex of
    0: { dataset }
      begin
        ChartData.Axes.Bottom.Visible := True;
        ChartData.AddSeries(TLineSeries.Create(chartData));
        ChartData.Title.Text.Add('Transformed time series');
        DrawValues(Data,ChartData.Series[0]);
      end;
    1: { acf }
      begin
        ChartData.Axes.Left.SetMinMax(-1.0,1.0);
        chartData.Axes.Bottom.AutomaticMinimum := False;
        chartData.Axes.Bottom.Minimum := -1.0;
        ChartData.AddSeries(TVolumeSeries.Create(chartData));
        with (chartData.Series[0] as TVolumeSeries) do
        begin
          UseYOrigin := True;
          Pen.Width := 2;
          YOrigin := 0.0;
        end;
        ChartData.Title.Text.Add('Transformed time series ACF');
        ACF(Data,v1);
        DrawValues(v1,ChartData.Series[0]);
      end;
    2: { pacf }
      begin
        ChartData.Axes.Left.SetMinMax(-1.0,1.0);
        chartData.Axes.Bottom.AutomaticMinimum := False;
        chartData.Axes.Bottom.Minimum := -1.0;
        ChartData.AddSeries(TVolumeSeries.Create(chartData));
        with (chartData.Series[0] as TVolumeSeries) do
        begin
          UseYOrigin := True;
          Pen.Width := 2;
          YOrigin := 0.0;
        end;
        ChartData.Title.Text.Add('Transformed time series PACF');
        ACF(Data,v1);
        PACF(v1,v2);
        DrawValues(v2,ChartData.Series[0]);
      end;
  end;
end;

procedure TfrmARIMAWizard.rgPlotClick(Sender: TObject);
begin
  RefreshChart;
end;

procedure TfrmARIMAWizard.chartDataBeforeDrawSeries(Sender: TObject);
var ypos: Integer;
begin
  if (rgPlotItemIndex <> 0 )then
  begin
    ypos := ChartData.Axes.Left.CalcYPosValue(0.0);
    ChartData.Axes.Bottom.CustomDraw(ypos+10,ypos+15,ypos,False);
  end;
end;

procedure TfrmARIMAWizard.chartDataAfterDraw(Sender: TObject);
var ypos: Integer;
begin
  if (rgPlotItemIndex <> 0 )then { acf, pacf}
    with  chartData.Canvas,chartData do
    begin
      ypos := Axes.Left.CalcYPosValue(chartUCL);
      Pen.Style := TPenStyle.psSolid;
      Pen.Width := 1;
      Pen.Color := TAlphaColors.Blue;
      ClipRectangle(ChartRect);
      MoveTo(ChartRect.Left,ypos);
      LineTo(ChartRect.Right,ypos);
      Font.Style := [TFontStyle.fsBold];
      Font.Color := TAlphaColors.Blue;
      TextOut(ChartRect.Right-80,ypos-15,FormatSample('0.00%',100*(1-Alpha))+' CI');
      ypos := Axes.Left.CalcYPosValue(chartLCL);
      MoveTo(ChartRect.Left,ypos);
      LineTo(ChartRect.Right,ypos);
      UnclipRectangle;
    end;
end;

function TfrmARIMAWizard.CoeffReport(coeff, cstderrs: TVec; coefCaption: string): String;
var pVals,tVals: Vector;
  df,i: Integer;
begin
  Result := '';
  // Calculate t values
  // This is the t-test value for testing the hypothesis that j = 0 versus
  // the alternative that after removing the influence of all other X's.
  // The degrees of freedom is equal to the N minus the number of model parameters and differences.
  tVals.Divide(coeff, cstderrs);

  // calculate p values
  // The p-value is the probability that above T-statistic will take on a value
  // at least as extreme as the actually observed value, assuming that the null hypothesis
  // is true (i.e., the regression estimate is equal to zero). If the p-value is less than
  // alpha, say 0.05, the null hypothesis is rejected.
  // This p-value is for a two-tail test.
  df := Data.Length - p - q - d;
  StudentCDF(tVals,df,pVals);
  for i := 0 to pvals.Length-1 do
    pVals[i] := 2.0*Min(pVals[i],1.0-pVals[i]);

  for i := 0 to coeff.Length -1 do
  begin
    Result := Result + coefCaption+'['+IntToStr(i+1)+']'+#9+FormatSample(FormatString,coeff[i])+#9;
    Result := Result + FormatSample(FormatString,cstderrs[i])+#9;
    Result := Result + FormatSample(FormatString,tVals[i])+#9;
    Result := Result + FormatSample(FormatString,pVals[i])+#10;
  end;
end;

function TfrmARIMAWizard.CoeffReport(coeff: TVec; coefCaption: string): String;
var i: Integer;
begin
  Result := '';
  for i := 0 to coeff.Length -1 do
    Result := Result + coefCaption + '['+IntToStr(i+1)+']'+ #9 + FormatSample(FormatString,coeff[i]) + #10;
end;


procedure TfrmARIMAWizard.DoMoveBack;
begin
  if (PageControl.ActiveTab = tsChart) and (chartindex > firstchartindex) then
  begin
    Dec(chartindex);
    ChartReport(chartindex);
    moveback := false;
  end else moveback := true;

  inherited DoMoveBack;
end;

procedure TfrmARIMAWizard.DoMoveForward;
begin
  if (PageControl.ActiveTab = tsChart) and (chartindex<lastchartindex) then
  begin
    Inc(chartindex);
    moveforward := false;
  end else moveforward := true;

  inherited DoMoveForward;

  if (PageControl.ActiveTab = tsTextReport) then TextReport
  else if (PageControl.ActiveTab = tsChart) then ChartReport(chartindex);
end;

procedure TfrmARIMAWizard.RefreshWizardControls;
begin
  inherited;
  if PageControl.ActiveTab = tsInputData then btnNext.Enabled := (TimeSeries.Length > 0)
  else if PageControl.ActiveTab = tsDefineModel then btnNext.Enabled := (p<>0) or (q<>0)
  else if PageControl.ActiveTab = tsChart then btnNext.Enabled := chartindex < lastchartindex;
end;

end.
