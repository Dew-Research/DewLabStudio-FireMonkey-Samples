unit VarResample;

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
  FMX.Layouts,
  FMX.Memo,
  FMX.Header, SignalProcessing, SignalTools, FileSignal,
  FMXTee.Editor.EditorPanel, MtxDialogs, SignalToolsDialogs, MtxBaseComp,
  SignalAnalysis, SignalToolsTee, FMXTee.Engine, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart;


type
  TVarResampleForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    SignalRead1: TSignalRead;
    Panel2: TPanel;
    SpectrumChart: TSpectrumChart;
    Series1: TFastLineSeries;
    Series2: TPointSeries;
    ChartTool1: TAxisScaleTool;
    Splitter1: TSplitter;                           
    SignalChart1: TSignalChart;
    Series3: TFastLineSeries;
    SignalDecimator1: TSignalDecimator;
    SignalIncBuffer1: TSignalIncBuffer;
    SignalIncBuffer2: TSignalIncBuffer;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VarResampleForm: TVarResampleForm;

implementation

uses Math387;

{$R *.FMX}

procedure TVarResampleForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TVarResampleForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TVarResampleForm.SpectrumAnalyzerParameterUpdate(
  Sender: TObject);
begin
    SpectrumAnalyzer.Update; 
end;

procedure TVarResampleForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := ExtractFileDir(ParamStr(0)) + '\bz.sfs';
    SignalRead1.OpenFile;
    SignalIncBuffer2.SuspendNotifyUpdate := True; //prevent chart updates for every call to Update
    SignalIncBuffer2.Factor := 13;  //increase the buffer by 13x, because SignalRead1.Length = 1024 and SignalRead1.RecordLength = 14000
    SignalIncBuffer1.Factor := 11;  //increase the buffer of the decimator output only by 11x,
                             //because the first two blocks will contain FIR filter delay
                             //in that way the 12th and 13th block will push out blocks 0 and 1
                             //from the circular buffer
    while (SignalIncBuffer1.Pull <> pipeEnd) do //Pull is True until the end of file. (Until the last full frame)
    begin
         SignalincBuffer2.Update; //Copy data from SignalRead1 to SignalIncBuffer2
    end;
    SpectrumAnalyzer.ZeroPadding := 4;
    SpectrumAnalyzer.Update; //compute the spectrum and update TSpectrumChart
    SignalIncBuffer2.UpdateNotify;  //update TSignalChart
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('The strongest peak in the spectrum shows the frequency of the envelope. ' +
          'That frequency is noticed on the bottom chart when looking at the peaks ' +
          'of the time signal only. The sampling frequency is reduced by 64 times.');
    end;
end;


procedure TVarResampleForm.Panel2Resize(Sender: TObject);
begin
     SpectrumChart.Height := Panel2.Height / 2;
end;

initialization
RegisterClass(TVarResampleForm);

end.
