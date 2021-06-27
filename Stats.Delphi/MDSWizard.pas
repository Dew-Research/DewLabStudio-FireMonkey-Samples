unit MDSWizard;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  FMXTee.Editor.Chart,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Wizard,
  StatTools, MtxVec, Math387, FMXTee.Commander, FMX.Layouts, FMX.Memo,
  FMX.ListBox, FMX.Edit, FMX.TabControl, FmxMtxComCtrls, FMXTee.Series.Point3D,
  FMX.Controls.Presentation, FMX.ScrollBox;



type
  TfrmMDSWiz = class(TfrmBasicWizard)
    tsInputData: TTabItem;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    EditFmtString: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    EditCols: TEdit;
    EditRows: TEdit;
    BtnEditData: TButton;
    CBoxDataType: TComboBox;
    Label6: TLabel;
    CBoxMetricType: TComboBox;
    Label7: TLabel;
    tsConfigReport: TTabItem;
    GroupBox1: TGroupBox;
    tsTextReport: TTabItem;
    RichEdit: TMemo;
    chkBoxEigenvalues: TCheckBox;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    chkBoxFit: TCheckBox;
    tsChart: TTabItem;
    Chart1: TChart;
    chkBoxDissimilarities: TCheckBox;
    TeeCommander1: TTeeCommander;
    EditMinDim: TMtxFloatEdit;
    EditMaxDim: TMtxFloatEdit;
    EditNumDim: TMtxFloatEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnEditDataClick(Sender: TObject);
    procedure CBoxDataTypeChange(Sender: TObject);
    procedure CBoxMetricTypeChange(Sender: TObject);
  private
    { Private declarations }
    ChartIndex: Integer;
    procedure UpdateGUI;
    procedure ChartReport(Index: Integer);
    procedure EigenValuesReport;
    procedure FitReport;
    procedure SolutionReport;
    procedure DissimilaritiesReport;
    procedure TextReport;
  protected
    // These three methods control wizard behavoir
    procedure RefreshWizardControls; override;
    procedure DoMoveForward; override;
    procedure DoMoveBack; override;
  public
    { Public declarations }
    MDScaling: TMtxMDScaling;
    procedure UpdateData;
  end;

var
  frmMDSWiz: TfrmMDSWiz;

implementation

{$R *.FMX}

Uses FmxMtxVecEdit, FmxMtxVecTee, Statistics, StatSeries;

Const
  { Define chart indexes }
  firstchartindex = 3;
  lastchartindex = 3;

function CheckDataMatrix(M: TMtx; mtype: TMDDataFormat): boolean;
begin
  Result := Not(M.Complex);
  case mtype of
    mdFormatRaw : Result := Result and (M.Length > 0);
    mdFormatDissimilarities: // for now, add additional checks (diag = 0, ...)
      begin
        Result := Result and M.Quadratic and (M.DetectMtxType = mtSymmetric);
      end;
    mdFormatSimilarities: // for now, add additional checks (diag = 0, ...)
      begin
        Result := Result and M.Quadratic and (M.DetectMtxType = mtSymmetric);
      end;
  end;
end;

procedure TfrmMDSWiz.UpdateData;
begin
  { initialize page }
  PageControl.ActiveTab := tsInputData;
  EditFmtString.Text := FormatString;
  CBoxDataType.ItemIndex := Ord(MDScaling.DataFormat);
  CBoxMetricType.ItemIndex := Ord(MDScaling.DistanceMethod);
  EditMaxDim.MaxValue := IntToStr(MDScaling.Data.Cols);
  EditMaxDim.IntPosition := StrToInt(EditMaxDim.MaxValue);
  EditMinDim.MaxValue := IntToStr(MDScaling.Data.Cols);
  EditNumDim.IntPosition := MDScaling.Dimensions;
  EditNumDim.MaxValue := IntToStr(MDScaling.Data.Cols);

  UpdateGUI;
end;

procedure TfrmMDSWiz.FormCreate(Sender: TObject);
begin
  inherited;
  MDScaling := TMtxMDScaling.Create(Self);;
  chartindex := firstchartindex;
end;

procedure TfrmMDSWiz.FormDestroy(Sender: TObject);
begin
  MDScaling.Free;
  inherited;
end;

procedure TfrmMDSWiz.BtnEditDataClick(Sender: TObject);
begin
  ViewValues(MDScaling.Data,'Data',true,false,true);
  UpdateGUI;
  RefreshWizardControls;
end;

procedure TfrmMDSWiz.UpdateGUI;
begin
  EditCols.Text := IntToStr(MDScaling.Data.Cols);
  EditRows.Text := IntToStr(MDScaling.Data.Rows);
  if  CheckDataMatrix(MdScaling.Data,MDScaling.DataFormat) then Label7.Text := 'Data matrix OK'
                                                           else Label7.Text := 'Data matrix NOT OK';
  EditMinDim.MaxValue := IntToStr(MDScaling.Data.Cols);
  EditMaxDim.MaxValue := IntToStr(MDScaling.Data.Cols);
  EditNumDim.MaxValue := IntToStr(MDScaling.Data.Cols);
end;

procedure TfrmMDSWiz.CBoxDataTypeChange(Sender: TObject);
begin
  MDScaling.DataFormat := TMDDataFormat(CBoxDataType.ItemIndex);
  UpdateGUI;
  RefreshWizardControls;
end;

procedure TfrmMDSWiz.CBoxMetricTypeChange(Sender: TObject);
begin
  MDScaling.DistanceMethod := TPWDistMethod(CBoxMetricType.ItemIndex);
  RefreshWizardControls;
end;

procedure TfrmMDSWiz.ChartReport(Index: Integer);
var bp2d: TBiPlotSeries;
    pt3d: TPoint3DSeries;
    i: Integer;
begin
  Chart1.FreeAllSeries(nil);
  case ChartIndex of
    firstchartindex:
      begin
        if EditNumDim.IntPosition = 2 then
        begin
          // Setup chart
          Chart1.View3D := False;
          Chart1.Axes.Bottom.Title.Text := 'Dimension 1';
          Chart1.Axes.Bottom.LabelStyle := talValue;
          Chart1.Axes.Left.Title.Text := 'Dimension 2';
          Chart1.Axes.Left.LabelStyle := talValue;
          bp2d := TBiPlotSeries.Create(Self);
          bp2d.Marks.Visible := True;
          bp2d.Pointer.Style := psCircle;
          bp2d.Pointer.VertSize := 6;
          bp2d.Pointer.HorizSize := 6;
          bp2d.ColorEachPoint := True;
          bp2d.ParentChart := Chart1;
          for i := 0 to MDScaling.Y.Rows -1 do
            bp2d.AddXY(MDScaling.Y.Values[i,0],MDScaling.Y.Values[i,1],'Variable '+IntToStr(i));
        end else
        if EditNumDim.IntPosition = 3 then
        begin
          // Setup chart
          Chart1.View3D := True;
          Chart1.Axes.Bottom.Title.Text := 'Dimension 1';
          Chart1.Axes.Bottom.LabelStyle := talValue;
          Chart1.Axes.Left.Title.Text := 'Dimension 2';
          Chart1.Axes.Left.LabelStyle := talValue;
          Chart1.Axes.Depth.Title.Text := 'Dimension 3';
          pt3d := TPoint3DSeries.Create(Self);
          pt3d.Marks.Visible := True;
          pt3d.Pointer.VertSize := 6;
          pt3d.Pointer.HorizSize := 6;
          pt3d.ColorEachPoint := True;
          pt3d.LinePen.Visible := False;
          pt3d.ParentChart := Chart1;
          for i := 0 to MDScaling.Y.Rows -1 do
            pt3d.AddXYZ(MDScaling.Y.Values[i,0],MDScaling.Y.Values[i,1],MDScaling.Y.Values[i,2],'Variable '+IntToStr(i),clTeeColor);
        end;
      end;
  end;
end;

procedure TfrmMDSWiz.TextReport;
begin
  RichEdit.Lines.Clear;
//  RichEdit.DefAttributes.Color := clBlack;
//  RichEdit.DefAttributes.Pitch := fpFixed;
//  RichEdit.DefAttributes.Style := [];
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
//  RichEdit.SelAttributes.Size := 16;
  RichEdit.Lines.Add('Classical Multidimensional Scaling');
  RichEdit.Lines.Add(Chr(13));
  RichEdit.Lines.Add(Chr(13));
  if chkBoxEigenValues.IsChecked then EigenValuesReport;
  if chkBoxFit.IsChecked then FitReport;
  if chkBoxFit.IsChecked then SolutionReport;
  if chkBoxDissimilarities.IsChecked then DissimilaritiesReport;
end;

procedure TfrmMDSWiz.EigenValuesReport;
var i: Integer;
  eabs: TVec;
  eabscumsum: TVec;
begin
//  RichEdit.Paragraph.TabCount := 4;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Eigenvalues');
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Dimensions'+#9+'Eigenvalue'+#9+'Percent'+#9+'Cumulative pct.');
  CreateIt(eabs,eabscumsum);
  try
    MDScaling.Dimensions := MDScaling.Data.Cols;
    MDScaling.Recalc;
    eabs.Abs(MDScaling.EigenValues);
    eabs.Mul(100.0/eabs.Sum);
    eabscumsum.CumSum(eabs);
    for i := 0 to MDScaling.EigenValues.Length -1 do
      RichEdit.Lines.Add(IntToStr(i+1)+#9+FormatSample(FormatString,MDScaling.EigenValues.Values[i])+
        #9+FormatSample('0.0%',eabs.Values[i])+#9+FormatSample('0.0%',eabscumsum.Values[i]));
  finally
    FreeIt(eabs,eabscumsum);
  end;
  RichEdit.Lines.Add('');
end;

procedure TfrmMDSWiz.FitReport;
var i,Nu: Integer;
    mu,ssd,mssd: TSample;
    a: TMtx;

    function StressToString(s: TSample): String;
    begin
      if s = 0.0 then result := 'exact'
      else if s <= 0.025 then result := 'excelent'
      else if s <= 0.050 then result := 'good'
      else if s <= 0.100 then result := 'fair'
      else result := 'poor'
    end;

begin
  CreateIt(a);
  try
    // Calculate necessary statistics
    Nu := MDScaling.D.Rows*(MDScaling.D.Rows+1) div 2 - MDScaling.D.Rows;
    Mu := 0.5*MDScaling.D.Sum/Nu; // zero diagonal, symmetric matrixd
    ssd := 0.5*MDScaling.D.SumOfSquares;
    // D-<D>
    a.Normalize(MdScaling.D,Mu,1.0);
    for i := 0 to A.Rows-1 do a.Values[i,i] := 0;
    mssd := 0.5*a.SumOfSquares;

//    RichEdit.Paragraph.TabCount := 3;
//    SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//    RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
    RichEdit.Lines.Add('Fit');
//    RichEdit.SelAttributes.Color := clBlue;
    RichEdit.Lines.Add('Dimensions'+#9+'Stress'+#9+'GOF estimate(*)');
    for i:= EditMinDim.IntPosition to EditMaxDim.IntPosition do
    begin
      MDScaling.Dimensions := i;
      MDScaling.Recalc;
      RichEdit.Lines.Add(IntToStr(i)+#9+FormatSample(FormatString,MDScaling.Stress)+#9+StressToString(MDScaling.Stress));
    end;
    RichEdit.Lines.Add('');
    RichEdit.Lines.Add('Number of dissimilarities: '+IntToStr(Nu));
    RichEdit.Lines.Add('Mean of dissimilarities: '+FormatSample(FormatString,mu));
    RichEdit.Lines.Add('Sum of Squared Dissimilarities: '+FormatSample(FormatString,ssd));
    RichEdit.Lines.Add('Mean Corrected Sum of Squared Dissimilarities: '+FormatSample(FormatString,mssd));
    RichEdit.Lines.Add('(*) Kruskal (1964) advise about stress values based on his experience. '
      + 'Some authors caution against using a table like this since acceptable values of stress depends '
      + 'on the quality of the distance matrix and the number of objects in that matrix.');
    RichEdit.Lines.Add('');
  finally
    FreeIt(a);
  end;
end;

procedure TfrmMDSWiz.SolutionReport;
var i,j: Integer;
  st: String;
begin
  MDScaling.Dimensions := EditNumDim.IntPosition;
  MDScaling.Recalc;
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Solution');
  st := 'Variable'+#9;
  for i :=1 to MDScaling.Dimensions do st := st + 'Dim('+IntToStr(i)+')'+#9;
//  RichEdit.Paragraph.TabCount := MDScaling.Dimensions +1;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add(st);
  // print Y values (reduced space matrix)
  for i := 0 to MDScaling.Y.Rows-1 do
  begin
    st := IntToStr(i)+#9;
    for j := 0 to MDScaling.Y.Cols-1 do st := st+FormatSample(FormatString,MDScaling.Y.Values[i,j])+#9;
    RichEdit.Lines.Add(st);
  end;
  RichEdit.Lines.Add('Note: Solution based on '+IntToStr(EditNumDim.IntPosition)+' dimensions.');
  RichEdit.Lines.Add('');
end;

procedure TfrmMDSWiz.DissimilaritiesReport;
var i,j: Integer;
  st: String;
  diff,pct: TSample;
begin
//  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.Lines.Add('Dissimilarities');
//  RichEdit.Paragraph.TabCount := 5;
//  SetupTabs(RichEdit.Paragraph.TabCount, RichEdit);
//  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.Lines.Add('Pair'+#9+'Actual diss.'+#9+'Predicted diss.'+#9
    + 'Difference'+#9+'Diff. percent');

  for i :=0 to MDScaling.D.Rows-1 do
    for j := i+1 to MDScaling.D.Cols -1 do
    begin
      diff := MDScaling.D.Values[i,j] - MDScaling.DHat.Values[i,j];
      pct := 100.0*diff/MdScaling.D.Values[i,j];
      st := '('+IntToStr(i)+','+IntToStr(j)+')'+#9+FormatSample(FormatString,MDScaling.D.Values[i,j])+#9;
      st := st + FormatSample(FormatString,MDScaling.DHat.Values[i,j])+#9;
      st := st + FormatSample(FormatString,diff)+#9+FormatSample('0.00%',pct);
      RichEdit.Lines.Add(st);
    end;
  RichEdit.Lines.Add('Note: Predicted values calculated for '+IntToStr(EditNumDim.IntPosition)+' dimensions.');
  RichEdit.Lines.Add('');

end;

procedure TfrmMDSWiz.DoMoveBack;
begin
  if (PageControl.ActiveTab = tsChart) and (chartindex>firstchartindex) then
  begin
    Dec(chartindex);
    ChartReport(chartindex);
    moveback := false;
  end else moveback := true;

  inherited DoMoveBack;
end;

procedure TfrmMDSWiz.DoMoveForward;
begin
  if (PageControl.ActiveTab = tsChart) and (chartindex<lastchartindex) then
  begin
    Inc(chartindex);
    moveforward := false;
  end else moveforward := true;

  inherited DoMoveForward;

  if (PageControl.ActiveTab = tsTextReport) then
  begin
    MDScaling.Recalc;
    TextReport;
  end
  else if (PageControl.ActiveTab = tsChart) then ChartReport(chartindex);

end;

procedure TfrmMDSWiz.RefreshWizardControls;
begin
  inherited;
  if PageControl.ActiveTab = tsInputData then
  begin
      btnNext.Enabled := CheckDataMatrix(MDScaling.Data,MDScaling.DataFormat)
  end
  else if PageControl.ActiveTab = tsTextReport then
  begin
      btnNext.Enabled := (EditNumdim.IntPosition = 2) or (EditNumDim.IntPosition = 3);
  end;
end;

end.
