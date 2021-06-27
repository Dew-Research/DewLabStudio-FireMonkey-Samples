unit NormalProbPlot;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMX.Dialogs,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form, FMXTee.Tools, StatSeries,
  MtxVec, Math387, FMXTee.Engine, FMXTee.Procs, FMXTee.Chart,
  FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types, FMXTee.Series,
  FMXTee.Editor.Series.Custom, FMXTee.Editor.Brush,
  FMXTee.Editor.Stroke;

//Series, StatSeries, TeCanvas, TeePenDlg



type
  TfrmNormalProb = class(TfrmBasic)
    Panel2: TPanel;
    Button1: TButton;
    Chart1: TChart;
    Button2: TButton;
    GridBandTool1: TGridBandTool;
    PenButton: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PenButtonClick(Sender: TObject);
  private
    { Private declarations }
    Data,X,Y: TVec;
    StdErrs: TVec;
    ub,lb: TVec;
    MinX,MaxX, MinY, MaxY: TSample;
    ProbSeries: TStatProbSeries;
    ubseries, lbseries: TLineSeries;
    procedure Recalc;
  public
    { Public declarations }
  end;

var
  frmNormalProb: TfrmNormalProb;

implementation

Uses  FmxMtxVecTee, StatProbPlots, Probabilities, FMXTee.Editor.Chart;

{$R *.FMX}

procedure TfrmNormalProb.Button2Click(Sender: TObject);
begin
   TChartEditForm.Edit(Self, ProbSeries);
end;

procedure TfrmNormalProb.Button1Click(Sender: TObject);
var ResStr: String;
    Mu,Sigma: TSample;
begin
  ResStr := InputBox('Data size','Number of points to be generated : ','100');
  try
    Data.Size(StrToInt(ResStr));
  except
    Data.Size(100);
  end;
  ResStr := InputBox('Mu','Mu (average) : ',FormatFloat('0.00',3.5));
  try
    Mu := StrToFloat(ResStr);
  except
    Mu := 3.5;
  end;
  ResStr := InputBox('Sigma','Sigma (Std.dev.) : ',FormatFloat('0.00',0.1));
  try
    Sigma := StrToFloat(ResStr);
  except
    Sigma := 0.1;
  end;
  Data.RandGauss(Mu,Sigma);
  Recalc;
end;

procedure TfrmNormalProb.FormCreate(Sender: TObject);
begin
  inherited;
  { Setup probability plot series }
  Chart1.FreeAllSeries(nil);
  ProbSeries := TStatProbSeries.Create(Chart1);
  ProbSeries.Title := 'Probability';
  ProbSeries.ParentChart := Chart1;
  ProbSeries.SlopePen.Color := TAlphaColors.Black;

  ubSeries := TLineSeries.Create(Chart1);
  ubSeries.ParentChart := Chart1;
  ubSeries.Color := TAlphaColors.Red;
  ubSeries.Title := '95% CI';
  lbSeries := TLineSeries.Create(Chart1);
  lbSeries.ParentChart := Chart1;
  lbSeries.Color := TAlphaColors.Red;
  lbSeries.ShowInLegend := False;

  With Memo1.Lines do
  begin
    Clear;
    Add('Normal probability plot');
    Add(chr(13));
    Add('The TStatSpecialSeries can be used to plot the Normal probability Chart. '+
        'Most properties can be customized (click the "Edit" button)');
  end;
  Data := TVec.Create;
  X := TVec.Create;
  Y := TVec.Create;
  StdErrs := TVec.Create;
  Ub := TVec.Create;
  Lb := TVec.Create;
  Data.Size(100);
  Data.RandGauss(3.5,0.1);
  Recalc;
end;

procedure TfrmNormalProb.FormDestroy(Sender: TObject);
begin
  Data.Free;
  X.Free;
  Y.Free;
  StdErrs.Free;
  Ub.Free;
  Lb.Free;
  inherited;
end;

procedure TfrmNormalProb.PenButtonClick(Sender: TObject);
begin
    TStrokeEditor.Edit(Self, ProbSeries.SlopePen);
end;

procedure TfrmNormalProb.Recalc;
var zVal : TSample;
begin
  StatNormalPlot(Data,X,Y,MinX,MaxX,MinY,MaxY,StdErrs,false);
  zVal := NormalCDFInv(0.975,0,1);
  StdErrs.Mul(zVal);
  Ub.Add(Y,StdErrs);
  Lb.Sub(Y,StdErrs);
  ProbSeries.MinX := MinX;
  ProbSeries.MaxX := MaxX;
  ProbSeries.MinY := MinY;
  ProbSeries.MaxY := MaxY;
  DrawValues(X,Y,ProbSeries);
  DrawValues(X,ub,ubSeries);
  DrawValues(X,lb,lbSeries);
end;

initialization
  RegisterClass(TfrmNormalProb);

end.
