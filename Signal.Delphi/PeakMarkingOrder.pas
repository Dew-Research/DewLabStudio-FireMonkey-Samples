unit PeakMarkingOrder;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  Fmx.StdCtrls,
  FMX.Header, SignalTools, FileSignal, FMXTee.Editor.EditorPanel, MtxDialogs,
  SignalToolsDialogs, MtxBaseComp, SignalAnalysis, FMX.Layouts, FMX.Memo,
  FMX.ListBox, FMXTee.Engine, SignalToolsTee, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMX.ScrollBox, FMX.Controls.Presentation;


type
  TPeakMarkingOrderForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    Series1: TFastLineSeries;
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    Series2: TPointSeries;
    SignalRead1: TSignalRead;                            
    ComboBox1: TComboBox;                              
    Label1: TLabel;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpectrumChartAfterMarkPeak(Sender: TObject);
  private
    function GetMarkTool: TSpectrumMarkTool;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PeakMarkingOrderForm: TPeakMarkingOrderForm;

implementation

uses Math387, Basic1;

{$R *.FMX}

procedure TPeakMarkingOrderForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TPeakMarkingOrderForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TPeakMarkingOrderForm.SpectrumAnalyzerParameterUpdate(
  Sender: TObject);
begin
    SpectrumAnalyzer.Update; 
end;

procedure TPeakMarkingOrderForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

    SignalRead1.OpenFile;
    ComboBox1.ItemIndex := 0; 
    SpectrumAnalyzer.Pull;
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('Order tracking is a method known from vibration analysis of shafts, which makes ' +
          'the sampling frequency of the A/D to be an ' +
          'integer multiple of the frequency of the rotating shaft. In the example below ' +
          'you can examine the ratios between different frequency peaks. The first peak ' +
          'clicked will become the order frequency.');
    end;
end;

function TPeakMarkingOrderForm.GetMarkTool: TSpectrumMarkTool;
var i: integer;
begin
     Result := nil;
     for i := 0 to SPectrumChart.Tools.Count-1 do
     begin
          if SPectrumChart.Tools[i] is TSpectrumMarkTool then
          begin
               Result := TSpectrumMarkTool(SpectrumChart.Tools[i]);
               Break;
          end;
     end;
     if Result = nil then ERaise('Spectrum mark tool not found!');
end;

procedure TPeakMarkingOrderForm.ComboBox1Change(Sender: TObject);
begin
     GetMarkTool.MarkMode := TSpectrumMarkMode(ComboBox1.ItemIndex);
end;

procedure TPeakMarkingOrderForm.SpectrumChartAfterMarkPeak(
  Sender: TObject);
begin
     if SpectrumAnalyzer.Peaks.List.Count = 1 then
     begin
          SpectrumAnalyzer.Peaks.NormalizedFreq.NormFrequency := SpectrumAnalyzer.Peaks[0].Freq*SpectrumAnalyzer.Peaks.NormalizedFreq.NormFrequency;
     end;
     SpectrumAnalyzer.Peaks.Update;
     SpectrumAnalyzer.UpdateNotify;     
end;

initialization
RegisterClass(TPeakMarkingOrderForm);

end.
