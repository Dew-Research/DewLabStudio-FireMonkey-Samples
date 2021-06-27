unit DewProbCalc;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMXTee.Chart,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Math387,
  DewProbWrapper,
  ProbEditor, FMX.Layouts, FMX.Memo, FMX.Controls, FMX.TabControl, FMX.Types,
  FMX.Forms, FMX.Menus, FMX.ListBox, System.Actions, FMX.ActnList,
  FMX.Grid, FMX.Controls.Presentation, FMXTee.Engine,
  FMXTee.Series, FMXTee.Procs, FMX.ScrollBox, FMX.DialogService;

type
  TfrmProbCalc = class(TForm)
    PageControl1: TTabControl;
    TabSheetResults: TTabItem;     
    TabSheetChart: TTabItem;
    MemoResults: TMemo;
    Chart1: TChart;
    Series1: TLineSeries;
    Panel2: TPanel;
    Panel3: TPanel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ItemPDF: TMenuItem;
    ItemCDF: TMenuItem;
    ItemICDF: TMenuItem;
    MenuBar1: TMenuBar;
    ActionList: TActionList;
    MenuBar2: TMenuBar;
    ItemClearAll: TMenuItem;
    ItemCalculate: TMenuItem;
    aPDF: TAction;
    aCDF: TAction;
    aICDF: TAction;
    aClearAll: TAction;
    aCalc: TAction;
    FrameDist1: TFrameDist;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aAdditionalInfoExecute(Sender: TObject);
    procedure Chart1AfterDraw(Sender: TObject);
    procedure FrameDist1RadioGroupOutClick(Sender: TObject);
    procedure aICDFExecute(Sender: TObject);
    procedure aClearAllExecute(Sender: TObject);
    procedure aClearAllUpdate(Sender: TObject);
    procedure aPDFExecute(Sender: TObject);
    procedure aCDFExecute(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure aCalcExecute(Sender: TObject);
  private
    {
    procedure ItemCalculateClick(Sender: TObject); Private declarations }
    Dist: TProbDistribution;
  public
    { Public declarations }
  end;

var
  frmProbCalc: TfrmProbCalc;

implementation

{$R *.FMX}

procedure TfrmProbCalc.FormCreate(Sender: TObject);
begin
  { Setup distribution }
  Dist := TProbDistribution.Create;
  Dist.LB := 0;
  Dist.UB := 1;
  Dist.NumPoints := 50;
  { temporary, will be replaced with true editor later }
  FrameDist1.Distribution := Dist;
  FrameDist1.ListBoxDist.ItemIndex := Ord(Dist.DistType);

  FrameDist1.RadioGroupOutClick(nil);
end;

procedure TfrmProbCalc.FormDestroy(Sender: TObject);
begin
  Dist.Free;
end;

procedure TfrmProbCalc.aAdditionalInfoExecute(Sender: TObject);
begin
  Chart1.Repaint;
end;

procedure TfrmProbCalc.Chart1AfterDraw(Sender: TObject);
var i,linc: Integer;
    xstart,ystart: single;
    tstr: String;
begin
  if CheckBox3.IsChecked then
  with Chart1, Chart1.Canvas do
  begin
    Font.Size := Title.Font.Size;
    linc := Round(Font.Size*1.3);
    xstart := ChartRect.Left + 30;
    ystart := ChartRect.Top + 30;
    tstr :=Dist.Text+' distribution';
    TextOut(xstart,ystart,tstr);
    ystart := ystart + linc*2;
    TextOut(xstart,ystart,'parameters:');
    ystart := ystart + linc;
    for i := 0 to Dist.DistParams.Count -1 do
    begin
      tstr := Dist.DistParams[i].Name+':'+FloatToStrF(Dist.DistParams[i].Value,ffFixed,6,6);
      TextOut(xstart,ystart,tstr);
      ystart := ystart + linc;
    end;
    ystart := ystart + linc;
    TextOut(xstart,ystart,'Plot range:'+FloatToStrF(Dist.LB,ffFixed,6,6)+' to '+FloatToStrF(Dist.UB,ffFixed,6,6));
  end;
end;

procedure TfrmProbCalc.CheckBox4Click(Sender: TObject);
begin
  Chart1.Repaint;
end;

procedure TfrmProbCalc.FrameDist1RadioGroupOutClick(Sender: TObject);
begin
  FrameDist1.RadioGroupOutClick(Sender);
  TabSheetChart.Visible := (aPDF.Checked) and (FrameDist1.RadioGroupOutIndex = 0);
end;

procedure TfrmProbCalc.aCalcExecute(Sender: TObject);

    function ResToStr(res: TSample): String;
    begin
      Result := SampleToStr(res,6,6);
    end;

    function Val2Str(x,val:TSample): String;
    begin
      Result := ResToStr(x)+#9+#9+ResToStr(val);
    end;

    procedure AddPointToSeries(aSeries:TChartSeries; x,y: TSample);
    begin
      if Not(IsNAN(x) or IsNan(y) or IsInf(x) or IsInf(y)) then
        aSeries.AddXY(x,y);
    end;

var i: Integer;
    calcstep,parvalue,yval: TSample;
    clb,cub: TSample;
begin
  if CheckBox4.IsChecked then aClearAllExecute(Self);
  Chart1.Title.Text.Clear;

  With MemoResults.Lines do
  begin
    Add(Dist.Text+ ' distribution');
    for i := 0 to Dist.DistParams.Count -1 do
      Add(Dist.DistParams[i].Name + '= ' + SampleToStr(Dist.DistParams[i].Value,6,6));

    if aPDF.Checked then
    begin
      Chart1.Title.Text.Add('Probability density function');
      Chart1.Axes.Left.Title.Text := 'PDF';
      Chart1.Axes.Bottom.Title.Text := 'x';
      Add('Calculating probability density function (PDF)');
      Add('x'+#9+#9+'PDF(x)')
    end else if aCdf.Checked then
    begin
      Chart1.Title.Text.Add('Cumulative distribution function');
      Chart1.Axes.Left.Title.Text := 'CDF';
      Chart1.Axes.Bottom.Title.Text := 'x';
      Add('Calculating cumulative distribution function (CDF)');
      Add('x'+#9+#9+'CDF(x)')
    end else
    begin
      Chart1.Axes.Left.Title.Text := 'PPF';
      Chart1.Axes.Left.Title.Text := 'PPF';
      Chart1.Axes.Bottom.Title.Text := 'p';
      Add('Calculating point percent function (PPF)');
      Add('p'+#9+#9+'x(p)')
    end;
    Add('---------------------------------------------');
    if FrameDist1.RadioGroupOutIndex = 0 then { single point }
    begin
      if (aICDF.Checked) then Add(Val2Str(Dist.p.Value,Dist.PPF))
      else if aPDF.Checked then Add(Val2Str(Dist.X.Value,Dist.PDF))
      else if aCDF.Checked then Add(Val2Str(Dist.X.Value,Dist.CDF))
    end
    else { range }
    begin
      clb := Dist.LB;
      cub := Dist.UB;
      calcstep := (cub-clb)/Dist.NumPoints;
      for i := 0 to Dist.NumPoints -1 do
      begin
        if aICDF.Checked then parvalue := 0+i/Dist.NumPoints
        else parvalue := clb + i*calcstep;
        yval := 0.0;
        if aPDf.Checked then yval := Dist.CalculatePDF(parvalue)
        else if ACDf.Checked then yval := Dist.CalculateCDF(parvalue)
        else if aICDF.Checked then yval := Dist.CalculatePPF(parvalue);

        Add(Val2Str(parvalue,yval));
        AddPointToSeries(Chart1.Series[0],parvalue,yval);
      end
    end;
    Add('---------------------------------------------');
  end;
end;

procedure TfrmProbCalc.aCDFExecute(Sender: TObject);
begin
  TabSheetChart.Visible := (FrameDist1.RadioGroupOutIndex <> 0);
  aCalc.Execute;
end;

procedure TfrmProbCalc.aPDFExecute(Sender: TObject);
begin
  TabSheetChart.Visible := (FrameDist1.RadioGroupOutIndex <> 0);
  aCalc.Execute;
end;

procedure TfrmProbCalc.aICDFExecute(Sender: TObject);
begin
  TabSheetChart.Visible := (FrameDist1.RadioGroupOutIndex <> 0);
  if FrameDist1.RadioGroupOutIndex = 0 then
  begin
     TDialogService.InputQuery('Set p',['Valid range: 0<=p<=1'],[FloatToStrF(Dist.p.Value,ffFixed,6,6)],
        procedure(const AResult: TModalResult; const AValues: array of string)
        begin
              case AResult of
              mrOk:
              begin
                  Dist.p.Value := StrToFloat(aValues[0]);
                  aCalc.Execute;
              end;
              end;
        end
    );
  end;
end;

procedure TfrmProbCalc.aClearAllExecute(Sender: TObject);
var i: Integer;
begin
  MemoResults.Lines.Clear;
  for i := 0 to Chart1.SeriesCount -1 do Chart1.Series[i].Clear;
end;

procedure TfrmProbCalc.aClearAllUpdate(Sender: TObject);
begin
  aClearAll.Enabled := MemoResults.Lines.Count > 0;
end;

initialization
  RegisterClass(TfrmProbCalc);

end.

