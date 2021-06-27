unit Modulator;

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
  FMX.Header,
  SignalProcessing,
  MtxVec, FMXTee.Editor.EditorPanel, SignalTools, FileSignal, SignalAnalysis,
  MtxBaseComp, MtxDialogs, SignalToolsDialogs, FMXTee.Engine, SignalToolsTee,
  FMXTee.Series, SignalSeriesTee, FMXTee.Procs, FMXTee.Chart, FmxMtxComCtrls,
  FMX.ListBox, FMX.Edit, FMX.Layouts, FMX.Memo, FMX.Controls.Presentation,
  FMX.ScrollBox;

type
  TModulatorForm = class(TForm)
    SpectrumAnalyzerDialog1: TSpectrumAnalyzerDialog;
    SignalRead1: TSignalRead;
    ChartEditor1: TChartEditor;
    SpectrumAnalyzer1: TSpectrumAnalyzer;
    SpectrumAnalyzer3: TSpectrumAnalyzer;
    RichEdit1: TMemo;
    Panel2: TPanel;                                  
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    Label1: TLabel;
    MtxFloatEdit1: TMtxFloatEdit;                           
    Label2: TLabel;
    MtxFloatEdit2: TMtxFloatEdit;
    Panel1: TPanel;
    SpectrumChart2: TSpectrumChart;
    FastLineSeries1: TFastLineSeries;
    SignalDiscreteSeries1: TSignalDiscreteSeries;
    AxisScaleTool1: TAxisScaleTool;
    Splitter2: TSplitter;
    SpectrumChart3: TSpectrumChart;
    FastLineSeries2: TFastLineSeries;
    SignalDiscreteSeries2: TSignalDiscreteSeries;
    AxisScaleTool2: TAxisScaleTool;
    ChartTool1: TSpectrumMarkTool;
    SignalBuffer: TSignalBuffer;
    SignalModulator: TSignalModulator;
    FilterDelayLabel: TLabel;
    Label3: TLabel;
    AttBox: TComboBox;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
    procedure MtxFloatEdit1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure AttBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModulatorForm: TModulatorForm;

implementation

uses SignalUtils, Math387, Basic1;

{$R *.FMX}

procedure TModulatorForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('TSignalModulator component moves the selected bandwidth from 0Hz to any ' +
            'user defined frequency. It is the reverse procedure to the zoom-spectrum ' +
            'or demodulation. The linear phase modulator features exceptional performance ' +
            'and accuracy with up to 160dB SNR speed exceeding standard multi-rate implementations ' +
            'by multiple times. The carrier frequency can be specified as a multiple of the ' +
            'sampling frequency of the original signal. The Factor parameter is used to specify ' +
            'the final sampling frequency.');
    end;

    SignalModulator.Factor := MtxFloatEdit2.FloatPosition;
    SignalModulator.CarrierFrequency := MtxFloatEdit1.FloatPosition;
    SignalRead1.OpenFile;
    SignalRead1.RecordPosition := 0;
    SignalBuffer.Reset();
    SpectrumAnalyzer3.Update;
    while (SignalBuffer.Pull <> pipeOK) do
    begin
        if SignalBuffer.PipeState = pipeEnd then Break;
    end;
    SpectrumAnalyzer1.Update;

    FilterDelayLabel.Text := 'Delay: ' + FormatSample('0.#',SignalModulator.FilterDelay);
end;

procedure TModulatorForm.SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
begin
    SpectrumAnalyzer1.Update;
    SpectrumAnalyzer3.Update;
end;

procedure TModulatorForm.MtxFloatEdit1Change(Sender: TObject);
begin
    SignalModulator.Factor := MtxFloatEdit2.FloatPosition;
    SignalModulator.CarrierFrequency := MtxFloatEdit1.FloatPosition;
    SignalModulator.Ripple := Exp10(StrToInt(AttBox.Selected.Text)/-20);
    SignalRead1.RecordPosition := 0;
    SignalBuffer.Length := LargestExp2(Round(1024*SignalModulator.Factor));
    SignalBuffer.Reset();
    SpectrumAnalyzer3.Update;
    while (SignalBuffer.Pull <> pipeOK) do
    begin
        if SignalBuffer.PipeState = pipeEnd then Break;
    end;
    SpectrumAnalyzer1.Update;

    FilterDelayLabel.Text := 'Delay: ' + FormatSample('0.#',SignalModulator.FilterDelay);
end;

procedure TModulatorForm.FormResize(Sender: TObject);
begin
    {$IFNDEF POSIX}
    SpectrumChart3.Height := Panel1.Height / 2;
    {$ENDIF}
end;

procedure TModulatorForm.AttBoxChange(Sender: TObject);
begin
    MtxFloatEdit1Change(Sender);
end;

procedure TModulatorForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor1.Execute;
end;

procedure TModulatorForm.SpectrumEditButtonClick(Sender: TObject);
begin
    SpectrumAnalyzerDialog1.Execute();
end;

initialization
RegisterClass(TModulatorForm);

end.
