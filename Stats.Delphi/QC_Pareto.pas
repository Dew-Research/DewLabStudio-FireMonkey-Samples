unit QC_Pareto;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  System.Bindings.Outputs,
  FMX.Header,
  Basic_Chart,
  MtxVec, Math387, FMXTee.Series,
  FMXTee.Engine, FMX.Layouts, FMX.Memo,
  FMX.Controls, FMX.StdCtrls, FMXTee.Procs, FMXTee.Chart, FMX.Types,
  FMX.ScrollBox, FMX.Controls.Presentation;



type
  TfrmParetoChart = class(TfrmBasicChart)
    Series1: TBarSeries;
    Series2: TLineSeries;
    Button2: TButton;
    RadioGroup1: TPanel;
    ParetoChartLabel: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Series2GetMarkText(Sender: TChartSeries; ValueIndex: Integer;
      var MarkText: String);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
  private
    { Private declarations }
    Data : TVec;
    RadioGroup1ItemIndex: integer;
    Factor : TSample;
    procedure Recalc;
  public
    { Public declarations }
  end;

var
  frmParetoChart: TfrmParetoChart;

implementation

Uses FmxMtxVecEdit, FmxMtxVecTee, Statistics, Basic_Form; // TeeJPEG, TeeGIF;

{$R *.FMX}

procedure TfrmParetoChart.Button2Click(Sender: TObject);
begin
  ViewValues(Data,'Data',True,False);
end;

procedure TfrmParetoChart.FormCreate(Sender: TObject);
var aPath: string;
begin
  inherited;

  With Memo1.Lines do
  begin
    Clear;
    Add('The Pareto and Pareto Cumulative Charts');
    Add('As with all TeeChart series, all parts of chart are fully' +
        ' configurable (click the "Edit Chart" button). ' +
        'You can also export result chart to different graphic'+
        ' formats. Click on "Edit Chart" button. Then select the "Export" tab...');
  end;
  Data := TVec.Create;
  { load prepared data }

  aPath := GetDataPath + 'QC_Pareto.vec';
  Data.LoadFromFile(aPath);
  Recalc;
end;

procedure TfrmParetoChart.FormDestroy(Sender: TObject);
begin
  Data.Free;
  inherited;
end;

procedure TfrmParetoChart.Recalc;
var DrawVec,CumSumVec: TVec;
begin
  Series2.Active := RadioGroup1ItemIndex = 1;
  Series1.Marks.Visible := RadioGroup1ItemIndex = 0;
  DrawVec := TVec.Create;
  try
    DrawVec.Copy(Data);
    { that's all there is to Pareto }
    DrawVec.SortDescend;
    { draw pareto chart }
    DrawValues(DrawVec,Series1,0.0,1.0,false);
    if RadioGroup1ItemIndex = 1 then
    begin
      CumSumVec := TVec.Create;
      try
        { Cumulative pareto }
        CumSumVec.CumSum(DrawVec);
        Factor := 100.0 / DrawVec.Sum;
	      CumSumVec.Scale(Factor);
        { draw cumulatiove pareto chart }
        Series2.GetVertAxis.SetMinMax(0.0,100);
        Series1.GetVertAxis.SetMinMax(0.0,DrawVec.Sum);
        DrawValues(CumSumVec,Series2, 0.0, 1.0,false);
      finally
        CumSumVec.Free;
      end;
    end else Series1.GetVertAxis.Automatic := True;
  finally
    DrawVec.Free;
  end;
end;

procedure TfrmParetoChart.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then RadioGroup1ItemIndex := 0;
  if Sender = RadioButton2 then RadioGroup1ItemIndex := 1;
  Recalc;
end;

procedure TfrmParetoChart.RadioButton2Change(Sender: TObject);
begin
  if Sender = RadioButton1 then RadioGroup1ItemIndex := 0;
  if Sender = RadioButton2 then RadioGroup1ItemIndex := 1;
  Recalc;
end;

procedure TfrmParetoChart.Series2GetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: String);
begin
  MarkText := FormatFloat('0.00 %', Series2.YValues[ValueIndex]);
end;

initialization
  RegisterClass(TfrmParetoChart);

end.
