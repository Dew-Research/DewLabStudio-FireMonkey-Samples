unit PCRegWizard;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Wizard, MtxVec, MtxExpr, Regress, Statistics, Math387, FMXTee.Commander,
  FMX.Layouts, FMX.Memo, FMX.Edit, FMX.TabControl, FMX.Controls,
  FMX.Types, FmxMtxComCtrls, FMXTee.Functions.Stats,
  FMX.Controls.Presentation, FMX.ScrollBox;



type
  TfrmPCRegWizard = class(TfrmBasicWizard)
    tsInputData: TTabItem;
    tsReports: TTabItem;
    tsTextReports: TTabItem;
    tsCharts: TTabItem;
    RichEdit: TMemo;
    TeeCommander1: TTeeCommander;
    Chart: TChart;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Button2: TButton;
    Label4: TLabel;
    Button3: TButton;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    ChkBoxUseWeights: TCheckBox;
    Edit4: TEdit;
    Edit3: TEdit;
    cbDescStat: TCheckBox;
    cbCorrMtx: TCheckBox;
    cbLSMultiCol: TCheckBox;
    cbEigenvalues: TCheckBox;
    cbPCCoeffs: TCheckBox;
    cbResiduals: TCheckBox;
    Edit1: TMtxFloatEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure ChkBoxUseWeightsClick(Sender: TObject);
  private
    { Private declarations }
    ChartIndex: Integer;
    YCalc,Res: Vector;
    Bse,BStd: Vector;
    Alpha: TSample;
    procedure CalcRegParams;
    procedure DescStatReport;
    procedure CorrMtxReport;
    procedure PCRegCoeffReport;
    procedure ResidualsReport;
    procedure LSMultiColReport;
    procedure EigenvaluesReport;
    procedure TextReport;
    procedure ChartReport(AIndex: Integer);
  protected
      // These three methods control wizard behavoir
    procedure RefreshWizardControls; override;
    procedure DoMoveForward; override;
    procedure DoMoveBack; override;
  public
    { Public declarations }
    A: TMtx;
    y,b,w: TVec;
    NumOmmit: Integer;
    procedure UpdateData;
  end;

var
  frmPCRegWizard: TfrmPCRegWizard;

implementation

Uses FmxMtxVecEdit, Probabilities, FmxMtxVecTee, StatSeries, StatProbPlots;

{$R *.FMX}

{ page numbers }
const
  firstchartindex = 3;
  lastchartindex = 5;

function R2Calc(y: TVec; A: TMtx; out mse: TSample): TSample;
var b,yCalc: TVec;
begin
  CreateIt(b,yCalc);
  try
    MulLinRegress(y,A,b,true,yCalc);
    Result := R2(y,yCalc);
  finally
    FreeIt(b,YCalc);
  end;
end;

procedure TfrmPCRegWizard.Button1Click(Sender: TObject);
begin
  ViewValues(A,'A in A*b=y',True,FAlse,True);
  Edit1.MaxValue := IntToStr(A.Cols-1);
end;

procedure TfrmPCRegWizard.Button2Click(Sender: TObject);
begin
  ViewValues(y,'y in A*b=y',True,False,True);
end;

procedure TfrmPCRegWizard.Button3Click(Sender: TObject);
begin
  ViewValues(w,'Weights in A*b=y',True,False,True);
end;

procedure TfrmPCRegWizard.CalcRegParams;
var sy: TSample;
  sa: Vector;
begin
  if (chkBoxUseWeights.IsChecked) then PCRegress(y,A,b,w,yCalc,bse,NumOmmit)
                                  else PCRegress(y,A,b,yCalc,bse,NumOmmit);

  Res.Sub(YCalc,y);
  // Standardized coefficients
  sy := Y.StdDev;
  A.StdDevCols(sa);
  BStd.Size(B.Length-1);
  BStd.Copy(B,1,0,B.Length-1);
  BStd.Mul(sa);
  BStd.Mul(1.0/sy);
end;

procedure TfrmPCRegWizard.ChartReport(AIndex: Integer);
var tmpVec1,tmpVec2: Vector;
    minX,MaxX,minY,MaxY: TSample;
begin
  Chart.FreeAllSeries;
  if (AIndex = firstchartindex) then
  begin
    { setup chart title and axes }
    Chart.Title.Text.Clear;
    Chart.Title.Text.Add('Histogram of residuals');
    Chart.LeftAxis.Title.Caption := 'Count';
    Chart.BottomAxis.Title.Caption := 'Residuals';
    Chart.LeftAxis.AutomaticMinimum := false;
    Chart.LeftAxis.Minimum := 0.0;
    { add histogram series }
    Chart.AddSeries(THistogramSeries.Create(Self));
    Chart.Series[0].SeriesColor := TAlphaColors.Blue;
    THistogramSeries(Chart.Series[0]).LinesPen.Visible := true;
    { draw histogram }
    Histogram(Res,10,tmpVec1,tmpVec2,true);
    DrawValues(tmpVec2,tmpVec1,Chart.Series[0]);
  end
  else if (AIndex = firstchartindex+1) then
  begin
    { setup chart title and axes }
    Chart.Title.Text.Clear;
    Chart.AddSeries(TStatProbSeries.Create(Self));
    Chart.Series[0].SeriesColor := TAlphaColors.Blue;
    TStatProbSeries(Chart.Series[0]).Pointer.Style := psCircle;
    Chart.Title.Text.Add('Residuals normal probability plot');
    Chart.LeftAxis.Title.Caption := 'Expected normals';
    Chart.LeftAxis.Automatic := true;
    Chart.BottomAxis.Title.Caption := 'Residuals';
    StatNormalPlot(res,tmpVec1,tmpVec2,MinX,MaxX,MinY,MaxY,nil,False);
    TStatProbSeries(Chart.Series[0]).MinX:= MinX;
    TStatProbSeries(Chart.Series[0]).MaxX:= MaxX;
    TStatProbSeries(Chart.Series[0]).MinY:= MinY;
    TStatProbSeries(Chart.Series[0]).MaxY:= MaxY;
    DrawValues(tmpVec1,tmpVec2,Chart.Series[0]);
  end
  else if (AIndex = firstchartindex+2) then
  begin
    { setup chart title and axes }
    Chart.Title.Text.Clear;
    Chart.Title.Text.Add('Residuals versus predicted values');
    Chart.LeftAxis.Title.Caption := 'Residuals';
    Chart.BottomAxis.Title.Caption := 'Predicted';
    Chart.LeftAxis.Automatic := true;
    { add point series }
    Chart.AddSeries(TPointSeries.Create(Self));
    Chart.Series[0].SeriesColor := TAlphaColors.Blue;
    TPointSeries(Chart.Series[0]).Pointer.Style := psCircle;
    TPointSeries(Chart.Series[0]).Pointer.InflateMargins := true;
    DrawValues(YCalc,res,Chart.Series[0]);
  end;
end;


procedure TfrmPCRegWizard.ChkBoxUseWeightsClick(Sender: TObject);
begin
  Button3.Enabled := ChkBoxUseWeights.IsChecked;
end;

procedure TfrmPCRegWizard.DoMoveBack;
begin
  if (PageControl.ActiveTab = tsCharts) and (chartindex>firstchartindex) then
  begin
    Dec(chartindex);
    ChartReport(chartindex);
    moveback := false;
  end else moveback := true;

  inherited DoMoveBack;
end;

procedure TfrmPCRegWizard.DoMoveForward;
begin
  if (PageControl.ActiveTab = tsCharts) and (chartindex<lastchartindex) then
  begin
    Inc(chartindex);
    moveforward := false;
  end else moveforward := true;

  inherited DoMoveForward;

  if (PageControl.ActiveTab = tsTextReports) then
  begin
    CalcRegParams;
    TextReport;
  end
  else if (PageControl.ActiveTab = tsCharts) then ChartReport(chartindex);
end;

procedure TfrmPCRegWizard.Edit1Change(Sender: TObject);
begin
  NumOmmit := StrToInt(Edit1.Text);
end;

procedure TfrmPCRegWizard.Edit3Change(Sender: TObject);
begin
  Alpha := StrToSample(Edit3.Text);
end;

procedure TfrmPCRegWizard.Edit4Change(Sender: TObject);
begin
  FormatString := Edit4.Text;
end;

procedure TfrmPCRegWizard.EigenvaluesReport;
var i: Integer;
  LineText: String;
  PC,Z: Matrix;
  eigen,pct: Vector;
begin
//  RichEdit.Paragraph.TabCount := 4;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Eigenvalues of Correlations');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Number'+chr(9)+'Eigenvalue'+chr(9)+'Percent'+chr(9)+'Cond. number');
  PCA(A,PC,Z,eigen,pct,PCACorrMat);
  for I := 0 to eigen.Length - 1 do
  begin
    LineText := IntToStr(i)+chr(9)+FormatSample(eigen.Values[i],FormatString)
      + chr(9)+FormatSample(pct.Values[i],'0.00')+chr(9)+FormatSample(eigen.Max/eigen.Values[i],FormatString);
    RichEdit.Lines.Add(LineText);
  end;

  RichEdit.Lines.Add(Chr(13));
  RichEdit.Lines.Add('If some Condition Numbers are between 100 and 1000, Multicollinearity is a MILD problem.');
  RichEdit.Lines.Add('If some Condition Numbers are greater than 1000, Multicollinearity is a SEVERE problem.');
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCRegWizard.RefreshWizardControls;
begin
  inherited;
  if PageControl.ActiveTab = tsCharts then btnNext.Enabled := chartindex < lastchartindex;
end;


procedure TfrmPCRegWizard.ResidualsReport;
var i: Integer;
  LineText: String;
begin
//  RichEdit.Paragraph.TabCount := 3;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Estimated values and residuals');
  Richedit.Lines.Add('with '+IntToStr(NumOmmit)+' variable(s) removed.');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Actual Y'+chr(9)+'Predicted Y'+chr(9)+'Residual');

  for i := 0 to Y.Length -1 do
  begin
    LineText := FormatSample(Y.Values[i],FormatString)+chr(9)+
      FormatSample(YCalc.Values[i],FormatString)+chr(9)+
      FormatSample(Res.Values[i],FormatString);
    RichEdit.Lines.Add(LineText)
  end;

  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCRegWizard.UpdateData;
begin
  Edit1.MaxValue := IntToStr(A.Cols-1);
end;

procedure TfrmPCRegWizard.FormCreate(Sender: TObject);
begin
  inherited;
  A := TMtx.Create;
  y := TVec.Create;
  b := TVec.Create;
  w := TVec.Create;
  FormatString := '0.0000';
  Alpha := 0.05;
  Edit3.Text := SampleToStr(Alpha);
  Edit4.Text := FormatString;
  ChartIndex := firstchartindex;

  Edit1.MaxValue := IntToStr(A.Cols-1);
end;

procedure TfrmPCRegWizard.FormDestroy(Sender: TObject);
begin
  A.Free;
  y.Free;
  b.Free;
  w.Free;
  inherited;
end;

procedure TfrmPCRegWizard.LSMultiColReport;
var i: Integer;
  tmpm: Matrix;
  tmpv: Vector;
  calcr2,vif,mse : TSample;
  LineText: String;
begin
//  RichEdit.Paragraph.TabCount := 4;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Least Squares Multicollinearity Section');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Variable'+chr(9)+'VIF'+chr(9)+'R2 vs. other'+chr(9)+'Tolerance');

  for i := 0 to A.Cols -1 do
  begin
    RemoveColumn(A,tmpm,i);
    tmpv.GetCol(A,i);
    calcR2 := R2Calc(tmpv,tmpm,mse);
    vif := 1.0/(1.0-calcR2);
    LineText := IntToStr(i) + chr(9) + FormatSample(vif,FormatString) + chr(9)
      + FormatSample(calcR2,FormatString)+chr(9)+FormatSample(1.0-calcR2,FormatString);
    RichEdit.Lines.Add(LineText);
  end;
  RichEdit.Lines.Add(Chr(13));
  RichEdit.Lines.Add('If some VIF’s are greater than 10, multicollinearity is a problem.');
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCRegWizard.PCRegCoeffReport;
var i: Integer;
  LineText: String;
  r2val: TSample;
begin
//  RichEdit.Paragraph.TabCount := 4;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('PC Regression Coefficients');
  Richedit.Lines.Add('with '+IntToStr(NumOmmit)+' variable(s) removed.');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Variable'+chr(9)+'Coef.'+chr(9)+'Coef. SE'
                      +chr(9)+'Std(Coef.)');

  for i := 0 to B.Length -1 do
  begin
    if (i=0) then LineText := 'Intercept'+Chr(9)
    else LineText := IntToStr(i-1)+chr(9);
    LineText := LineText + FormatFloat(FormatString,B.Values[i])+chr(9);
    if (i>0) then
    begin
      LineText := LineText +FormatFloat(FormatString,bSe.Values[i-1])+chr(9);
      LineText := LineText + FormatSample(bstd.Values[i-1],FormatString);
    end;

    RichEdit.Lines.Add(LineText)
  end;
  r2val :=R2(Y,Ycalc);
  RichEdit.Lines.Add(Chr(13));
  RichEdit.Lines.Add('Model R2: '+chr(9)+FormatSample(FormatString,r2val));
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCRegWizard.TextReport;
begin
  RichEdit.Lines.Clear;
//  RichEdit.DefAttributes.Color := clBlack;
//  RichEdit.DefAttributes.Pitch := fpFixed;
//  RichEdit.DefAttributes.Style := [];
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
//  RichEdit.SelAttributes.Size := 16;
  RichEdit.Lines.Add('Principal Component Regression');
  RichEdit.Lines.Add(Chr(13));
  RichEdit.Lines.Add(Chr(13));

  if (cbDescStat.IsChecked) then DescStatReport;
  if (cbCorrMtx.IsChecked) then CorrMtxReport;
  if (cbLSMultiCol.IsChecked) then LSMultiColReport;
  if (cbEigenvalues.IsChecked) then EigenvaluesReport;
  if (cbPCCoeffs.IsChecked) then PCRegCoeffReport;
  if (cbResiduals.IsChecked) then ResidualsReport;
end;

procedure TfrmPCRegWizard.DescStatReport;
var i: Integer;
  tmpMin,tmpMean,
  tmpStdDev,tmpMax: TSample;
  LineText : String;
  tv: Vector;
begin
//  RichEdit.Paragraph.TabCount := 5;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Descriptive Statistics');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Variable'+chr(9)+'Mean'+chr(9)+'Std.Dev.'
                      +chr(9)+'Min'+chr(9)+'Max');
  { basic descriptive statistics }
  for i := 0 to A.Cols-1 do
  begin
    tv.GetCol(A,0,i,A.Rows);
    tmpMean := tv.Mean;
    tmpStdDev := tv.StdDev(tmpMean);
    tmpMax := tv.Max;
    tmpMin := tv.Min;
    LineText :='A column '+IntToStr(i)+Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpMean)+Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpStdDev) + Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpMin) + Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpMax);
    RichEdit.Lines.Add(LineText);
  end;
  tmpMean := Y.Mean;
  tmpStdDev := Y.StdDev(tmpMean);
  tmpMax := Y.Max;
  tmpMin := Y.Min;
  LineText := 'Y column'+chr(9);
  LineText := LineText + FormatFloat(FormatString,tmpMean) + Chr(9);
  LineText := LineText + FormatFloat(FormatString,tmpStdDev) + Chr(9);
  LineText := LineText + FormatFloat(FormatString,tmpMin) + Chr(9);
  LineText := LineText + FormatFloat(FormatString,tmpMax);
  RichEdit.Lines.Add(LineText);
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCRegWizard.CorrMtxReport;
var AdjCorrMtx,tmpMtx: Matrix;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Correlation matrix');
  AdjCorrMtx.Size(A.Rows,A.Cols + 1);
//  RichEdit.Paragraph.TabCount := AdjCorrMtx.Cols;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
  AdjCorrMtx.Copy(A,0,0,0,0,A.Rows,A.Cols,false);
  AdjCorrMtx.SetCol(Y,A.Cols);
  CorrCoef(AdjCorrMtx,tmpMtx);
  tmpMtx.ValuesToStrings(RichEdit.Lines,Chr(9), ftaNone, FormatString);
  RichEdit.Lines.Add(Chr(13));
end;



end.
