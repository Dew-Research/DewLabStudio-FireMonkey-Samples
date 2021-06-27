unit PCAWizard;

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
  Basic_Wizard,
  StatTools,
  Math387, MtxVec,
  FMXTee.Editor.Chart,
  Statistics, FMXTee.Commander, FMXTee.Series.BoxPlot,
  FMX.Layouts, FMX.Memo, FMX.ListBox, FMX.Edit, FMX.TabControl, FMX.Controls,
  FMX.Types, MtxBaseComp, FMX.Controls.Presentation, FMX.ScrollBox;



type
  TfrmPCAWiz = class(TfrmBasicWizard)
    tsInputData: TTabItem;
    tsReportConfig: TTabItem;
    GroupBox1: TGroupBox;
    tsTextReport: TTabItem;
    RichEdit: TMemo;
    ChkBoxDescStat: TCheckBox;
    ChkBoxCorrMtx: TCheckBox;
    ChkBoxEigValues: TCheckBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    EditFmtString: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    EditCols: TEdit;
    Label2: TLabel;
    EditRows: TEdit;
    Label3: TLabel;
    BtnEditData: TButton;
    Label5: TLabel;
    CBoxPCAMode: TComboBox;
    ChkBoxPrinComp: TCheckBox;
    ChkBoxZScores: TCheckBox;
    tsChart: TTabItem;
    Chart: TChart;
    TeeCommander1: TTeeCommander;
    ChkBoxBarlett: TCheckBox;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    CBoxRotation: TComboBox;
    procedure BtnEditDataClick(Sender: TObject);
    procedure EditFmtStringChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CBoxPCAModeChange(Sender: TObject);
    procedure CBoxRotationChange(Sender: TObject);
  private
    { Private declarations }
    tmpVec: TVec;
    tmpMtx: TMtx;
    ChartIndex : Integer;
    procedure TextReport;
    procedure DescStatReport;
    procedure CorrMtxReport;
    procedure EigValuesReport;
    procedure PrinCompReport;
    procedure ZScoresReport;
    procedure BarlettReport;
    procedure ChartReport(AIndex: Integer);
  protected
    // These three methods control wizard behavoir
    procedure RefreshWizardControls; override;
    procedure DoMoveForward; override;
    procedure DoMoveBack; override;
  public
    { Public declarations }
    MtxPCA: TMtxPCA;
    RotMode: TMatrixRotation;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPCAWiz: TfrmPCAWiz;

implementation

Uses FmxMtxVecTee, FmxMtxVecEdit, StatSeries;

Const
  { list first and last chart index (page) }
  firstchartindex = 3;
  lastchartindex = 5;

{$R *.FMX}

// Checks for buttons
procedure TfrmPCAWiz.RefreshWizardControls;
begin
  inherited;
  if PageControl.ActiveTab = tsInputData then btnNext.Enabled := MTXPCA.Data.Length > 0
  else if PageControl.ActiveTab = tsChart then btnNext.Enabled := chartindex < lastchartindex;
end;

// Triggered when "Next" button is clicked
procedure TfrmPCAWiz.DoMoveForward;
begin
  if (PageControl.ActiveTab = tsChart) and (chartindex<lastchartindex) then
  begin
    Inc(chartindex);
    moveforward := false;
  end else moveforward := true;

  inherited DoMoveForward;

  if (PageControl.ActiveTab = tsTextReport) then
  begin
    MtxPCA.Recalc;
    TextReport;
  end
  else if (PageControl.ActiveTab = tsChart) then ChartReport(chartindex);
end;

// Triggered when "Back" button is clicked
procedure TfrmPCAWiz.DoMoveBack;
begin
  if (PageControl.ActiveTab = tsChart) and (chartindex>firstchartindex) then
  begin
    Dec(chartindex);
    ChartReport(chartindex);
    moveback := false;
  end else moveback := true;

  inherited DoMoveBack;
end;

constructor TfrmPCAWiz.Create(AOwner: TComponent);
begin
  inherited;

  MtxPCA := TMtxPCA.Create(Self);
  tmpVec := TVec.Create;
  tmpMtx := TMtx.Create;
  RotMode := rotNone; // no rotation
  chartindex := firstchartindex;

  { initialize page }
  PageControl.ActiveTab := tsInputData;
  EditRows.Text := IntToStr(MtxPCA.Data.Rows);
  EditCols.Text := IntToStr(MtxPCA.Data.Cols);
  EditFmtString.Text := FormatString;
  CBoxPCAMode.ItemIndex := Ord(MtxPCA.PCAMode);
  CBoxRotation.ItemIndex := Ord(RotMode);
end;

procedure TfrmPCAWiz.FormDestroy(Sender: TObject);
begin
  MtxPCA.Free;
  tmpVec.Free;
  tmpMtx.Free;
  inherited;
end;

procedure TfrmPCAWiz.BtnEditDataClick(Sender: TObject);
begin
  ViewValues(MtxPCA.Data,'Editinig data...',true,true,true);
  EditCols.Text := IntToStr(MtxPCA.Data.Cols);
  EditRows.Text := IntToStr(MtxPCA.Data.Rows);
  RefreshWizardControls;
end;

procedure TfrmPCAWiz.TextReport;
begin
  RichEdit.Enabled := false;
  RichEdit.Lines.Clear;
  try
//    RichEdit.DefAttributes.Color := clBlack;
//    RichEdit.DefAttributes.Pitch := fpFixed;
//    RichEdit.DefAttributes.Style := [];
//    RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
//    RichEdit.SelAttributes.Size := 16;
    RichEdit.Lines.Add('Principal Components Analysis');
    RichEdit.Lines.Add(Chr(13));
    RichEdit.Lines.Add(Chr(13));
    if ChkBoxDescStat.IsChecked then DescStatReport;
    if ChkBoxCorrMtx.IsChecked then CorrMtxReport;
    if ChkBoxBarlett.IsChecked then BarlettReport;
    if ChkBoxEigValues.IsChecked then EigValuesReport;
    if ChkBoxPrinComp.IsChecked then PrinCompReport;
    if ChkBoxZScores.IsChecked then ZScoresReport;
  finally
    RichEdit.Enabled := true;
  end;
end;

procedure TfrmPCAWiz.DescStatReport;
var i: Integer;
  tmpMin,tmpMean,
  tmpStdDev,tmpMax: TSample;
  LineText : String;
begin
//  RichEdit.Paragraph.TabCount := 5;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Descriptive Statistics');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Variable'+chr(9)+'Mean'+chr(9)+'Std.Dev.'
                      +chr(9)+'Min'+chr(9)+'Max');
  { basic descriptive statistics }
  for i := 0 to MtxPCA.Data.Cols-1 do
  begin
    tmpVec.GetCol(MtxPCA.Data,0,i,MtxPCA.Data.Rows);
    tmpMean := tmpVec.Mean;
    tmpStdDev := tmpVec.StdDev(tmpMean);
    tmpMax := tmpVec.Max;
    tmpMin := tmpVec.Min;
    LineText :='A column '+IntToStr(i)+Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpMean)+Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpStdDev) + Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpMin) + Chr(9);
    LineText := LineText + FormatFloat(FormatString,tmpMax);
    RichEdit.Lines.Add(LineText);
  end;
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCAWiz.EditFmtStringChange(Sender: TObject);
begin
  FormatString := EditFmtString.Text;
  try
    FormatFloat(FormatString,1.22);  { dummy test }
  except
  end;
end;

procedure TfrmPCAWiz.CorrMtxReport;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
//  RichEdit.Paragraph.TabCount := MTxPCA.Data.Cols;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
  case MtxPCA.PCAMode of
    PCARawData:  begin
                  RichEdit.Lines.Add('Covariance matrix');
                  Covariance(MtxPCA.Data,tmpMtx,false);
                  tmpMtx.ValuesToStrings(RichEdit.Lines,Chr(9), ftaNone, FormatString);
                  { Ln(R)}
                  RichEdit.Lines.Add('Ln(R) = '+ FormatFloat(FormatString,(tmpMtx.Determinant)));
                  RichEdit.Lines.Add(Chr(13));
                  RichEdit.Lines.Add('Correlation matrix');
                  CorrCoef(MtxPCA.Data,tmpMtx);
                  tmpMtx.ValuesToStrings(RichEdit.Lines,Chr(9), ftaNone, FormatString);
                  { Ln(R)}
                  RichEdit.Lines.Add('Ln(R) = '+ FormatFloat(FormatString,(tmpMtx.Determinant)));
                  RichEdit.Lines.Add(Chr(13));
                end;
  end;
end;

procedure TfrmPCAWiz.EigValuesReport;
var LineText : String;
    i : Integer;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
//  RichEdit.Lines.Add('Eigenvalues');
//  RichEdit.Paragraph.TabCount := 3;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Variable'+chr(9)+'Eigenvalue'+chr(9)+'Percentage');
  for i := 0 to MtxPCA.EigValues.Length - 1 do
  begin
    LineText := IntToStr(i)+chr(9)+FormatFloat(FormatString,MtxPCA.EigValues.Values[i]);
    LineText := LineText + chr(9)+ FormatFloat(FormatString,MtxPCA.TotalVarPct.Values[i]);
    RichEdit.Lines.Add(LineText);
  end;
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCAWiz.CBoxPCAModeChange(Sender: TObject);
begin
  if CBoxPCAMode.ItemIndex <1 then MtxPCA.PCAMode := PCACorrMat else MtxPCA.PCAMode := PCARawData;
end;

procedure TfrmPCAWiz.PrinCompReport;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
//  RichEdit.Lines.Add('Principal components (Eigenvectors)');
//  RichEdit.Paragraph.TabCount := MtxPCA.Data.Cols;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
  MtxPCA.PC.ValuesToStrings(RichEdit.Lines);
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCAWiz.ZScoresReport;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Z Scores');
//  RichEdit.Paragraph.TabCount := MtxPCA.ZScores.Cols;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
  MtxPCA.ZScores.ValuesToStrings(RichEdit.Lines);
  RichEdit.Lines.Add(Chr(13));
end;

procedure TfrmPCAWiz.ChartReport(AIndex: Integer);
var i: Integer;
    tmpVec1: TVec;
begin
  Chart.FreeAllSeries;
  Chart.Title.Text.Clear;
  Chart.Axes.Left.Automatic := true;
  Chart.Axes.Bottom.Automatic := true;
  { Box plot }
  if (AIndex = firstchartindex) then
  begin
    { setup chart title and axes }
    Chart.Legend.Visible := false;
    Chart.Title.Text.Add('Box plot');
    Chart.Axes.Left.Title.Caption := 'Values';
    Chart.Axes.Bottom.Title.Caption := 'Group (Column)';
    Chart.Axes.Bottom.Increment := 1;
    tmpVec1 := TVec.Create;
    try
      { add BoxPlot series }
      for i := 0 to MtxPCA.Data.Cols - 1 do
      begin
        Chart.AddSeries(TBoxSeries.Create(Chart));
        tmpVec1.GetCol(MtxPCA.Data,i);
        Chart.Series[i].Title := 'Column' + IntToStr(i);
        with TBoxSeries(Chart.Series[i]) do
        begin
          Position := i;
          Box.Brush.Color := TAlphaColors.Yellow;
          Pen.Color := TAlphaColors.Red;
          SeriesColor := TAlphaColors.Red;
        end;
        tmpVec1.SortAscend;
        DrawValues(tmpVec1,Chart.Series[i]);
      end;
    finally
      tmpVec1.Free;
    end;
  end else
  { Scree plot }
  if (AIndex = firstchartindex+1) then
  begin
    { setup chart title and axes }
    Chart.Legend.Visible := true;
    Chart.Title.Text.Add('Scree plot');
    Chart.Axes.Left.Title.Caption := 'Percentage';
    Chart.Axes.Left.Automatic := false;
    Chart.Axes.Left.SetMinMax(0,101);
    Chart.Axes.Bottom.Title.Caption := 'Eigenvalue';
    tmpVec1 := TVec.Create;
    try
      { add Line + bar series }
      Chart.AddSeries(TBarSeries.Create(Chart));
      Chart.AddSeries(TLineSeries.Create(Chart));
      TLineSeries(Chart.Series[1]).LinePen.Width := 2;
      Chart.Series[0].Title := 'Eigenvalue' ;
      Chart.Series[1].Title := 'Cumulative value' ;
      tmpVec1.CumSum(MtxPCA.TotalVarPct);
      DrawValues(MtxPCA.TotalVarPct,Chart.Series[0]);
      DrawValues(tmpVec1,Chart.Series[1]);
    finally
      tmpVec1.Free;
    end;
  end
  else
  { Bi-plot }
  if (AIndex = firstchartindex+2) then
  begin
    { setup chart title and axes }
    Chart.Legend.Visible := true;
    Chart.Title.Text.Add('Biplot');
    Chart.Axes.Left.Title.Caption := 'Dimension 2';
    Chart.Axes.Bottom.Title.Caption := 'Dimension 1';
    Chart.Axes.Bottom.LabelStyle := talValue;
    { add point series }
    Chart.AddSeries(TPointSeries.Create(Chart));
    Chart.Series[0].Title := 'Scores';
    { add 2d biplot series }
    Chart.AddSeries(TBiPlotSeries.Create(Chart));
    Chart.Series[1].Marks.Visible := True;
    Chart.Series[1].Title := 'Coefficients';
    // populate scores
    for i := 0 to MTXPCA.ZScores.Rows -1 do
      Chart.Series[0].AddXY(MTXPCA.ZScores.Values[i,0],MTXPCA.ZScores.Values[i,1],IntToStr(i));
    // first two components of each eigenvector
    for i := 0 to MTxPCA.PC.Cols -1 do
      Chart.Series[1].AddXY(MTXPCA.PC.Values[0,i],MTXPCA.PC.Values[1,i],'Column'+IntToStr(i));
  end;
end;

procedure TfrmPCAWiz.BarlettReport;
var NumDim,i: Integer;
    SignifVec: TVec;
    LineText : String;
begin
  if MtxPCA.PCAMode = PCARawData then
  begin
//    RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
    RichEdit.Lines.Add('Barlett test for dimensionality of data');
    { Barlett test for dimensionality }
    SignifVec := TVec.Create;
    try
      BartlettTest(MtxPCA.Data,NumDim,SignifVec); { Alpha = 5 % }
      RichEdit.Lines.Add('Barlett test (Alpha =0.05 ) = '+ IntToStr(NumDim));
//      RichEdit.Paragraph.TabCount := 2;
//      SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//      RichEdit.SelAttributes.Color := clBlue;
      RichEdit.Lines.Add('Variable'+chr(9)+'Signif. probability');
      for i := 0 to SignifVec.Length - 1 do
      begin
        LineText := IntToStr(i)+chr(9)+FormatFloat(FormatString,SignifVec.Values[i]);
        RichEdit.Lines.Add(LineText);
      end;
      RichEdit.Lines.Add(Chr(13));
    finally
      SignifVec.Free;
    end;
  end;
end;

procedure TfrmPCAWiz.CBoxRotationChange(Sender: TObject);
begin
  RotMode := TMatrixRotation(CBoxRotation.ItemIndex);
end;

end.
