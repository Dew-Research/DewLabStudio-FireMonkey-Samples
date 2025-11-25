unit PeakInterpolate;

interface

uses

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Controls.Presentation,
  FMX.Memo.Types,
  FMX.Layouts,
  FMX.Memo,
  FMX.Edit,
  FMX.ScrollBox,

  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs,
  FMXTee.Chart,
  FMXTee.Editor.EditorPanel,

  MtxDialogs,
  MtxBaseComp,
  FmxMtxComCtrls,
  SignalUtils,
  SignalTools,
  SignalToolsDialogs,
  SignalAnalysis,
  SignalToolsTee;


type
  TPeakInterpolateForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    Signal1: TSignal;
    FreqEdit: TMtxFloatEdit;
    Label1: TLabel;
    Label2: TLabel;
    PhaseEdit: TMtxFloatEdit;
    Label3: TLabel;
    AmpltEdit: TMtxFloatEdit;              
    Panel2: TPanel;
    SpectrumChart: TSpectrumChart;
    Series1: TFastLineSeries;
    Series2: TPointSeries;
    Splitter1: TSplitter;
    SignalChart: TSignalChart;
    ToolButton1: TButton;
    ChartEditor1: TChartEditor;
    Series3: TFastLineSeries;
    ChartTool1: TAxisScaleTool;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Signal1AfterUpdate(Sender: TObject);
    procedure FreqEditChange(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PeakInterpolateForm: TPeakInterpolateForm;

implementation

uses Math387;

{$R *.FMX}

procedure TPeakInterpolateForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TPeakInterpolateForm.Button1Click(Sender: TObject);
//var i: integer;
begin
//    RichEdit1.Lines.Clear;
//    StartTimer;
//    for i := 0 to 1000 do
//    begin
//        SpectrumAnalyzer.PeakApproximate(SpectrumAnalyzer.Marks[0].Freq);
//    end;
//    RichEdit1.Lines.Add(FormatSample('0ms',StopTimer*1000));
end;

procedure TPeakInterpolateForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TPeakInterpolateForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TPeakInterpolateForm.FormCreate(Sender: TObject);
begin
     Signal1.UsesInputs := false;
     SpectrumAnalyzer.PhaseMode := pm360;
     SpectrumAnalyzer.Pull;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Numeric peak interpolation works with any window and any zero padding setting. ' +
            'Change the value of frequency, amplitude and phase and compare value measured ' +
            'on the marked peak with the actual sine parameter. Notice also that ' +
            'marked peak follows the frequency. This feature is called peak tracing. '+
            'In the example below, peak tracking is set to always find and mark the largest peak.');
        
        
     end;
end;

procedure TPeakInterpolateForm.Signal1AfterUpdate(Sender: TObject);
var ts: TToneState;
begin
     ToneInit(FreqEdit.FloatPosition,DegToRad(PhaseEdit.FloatPosition),AmpltEdit.FloatPosition,ts);
     Tone(Signal1.Data,ts);
end;

procedure TPeakInterpolateForm.FreqEditChange(Sender: TObject);
begin
     SpectrumAnalyzer.Pull;
end;

procedure TPeakInterpolateForm.Panel2Resize(Sender: TObject);
begin
     SpectrumChart.Height := Trunc(Panel2.Height/1.8);
end;

procedure TPeakInterpolateForm.ToolButton1Click(Sender: TObject);
begin
     ChartEditor1.Execute;
end;

initialization
RegisterClass(TPeakInterpolateForm);

end.
