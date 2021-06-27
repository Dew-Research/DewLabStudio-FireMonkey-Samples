unit NarrowBandpass;

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
  FMX.ListBox,
  FMX.Edit,
  FMX.Layouts,
  FMX.Memo,
  FMX.Header,
  SignalProcessing, FMXTee.Editor.EditorPanel, SignalTools,
  FileSignal, SignalAnalysis, MtxBaseComp, MtxDialogs, SignalToolsDialogs, FmxMtxComCtrls,
  FMXTee.Engine, SignalToolsTee, FMXTee.Series, SignalSeriesTee, FMXTee.Procs,
  FMXTee.Chart, FMX.Controls.Presentation, FMX.ScrollBox;


type
  TNarrowBandpassForm = class(TForm)
    SpectrumAnalyzerDialog1: TSpectrumAnalyzerDialog;
    SignalRead1: TSignalRead;
    ChartEditor1: TChartEditor;
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
    SignalBandpass: TSignalBandpass;
    SignalBuffer: TSignalBuffer;
    PositionLabel: TLabel;
    FilterDelayLabel: TLabel;
    Label3: TLabel;
    AttBox: TComboBox;
    Label4: TLabel;
    SpectrumAnalyzer1: TSpectrumAnalyzer;
    SpectrumAnalyzer3: TSpectrumAnalyzer;
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
  NarrowBandpassForm: TNarrowBandpassForm;

implementation

uses SignalUtils, Math387, Basic1;

{$R *.FMX}

procedure TNarrowBandpassForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('TSignalBandpass applies a linear phase bandpass filter. ' +
            'It features exceptional performance ' +
            'and accuracy with up to 160dB SNR speed exceeding standard multi-rate implementations ' +
            'by multiple times. The bandpass filter is specified by its left edge and bandpass width. ' +
            'Both have a valid range from 0 to 0.5, but their sum may not exceed 0.5. This is a multi-rate ' +
            'implementation of a bandpass filter and is most suitable for "narrow" bandpass filters. ' +
            'Narrow bandpass filters are those whose bandpass width is much smaller than the signal bandwidth.');
        
        
    end;

    SignalBandpass.Subbandwidth := MtxFloatEdit2.FloatPosition;
    SignalBandpass.SubbandFrequency := MtxFloatEdit1.FloatPosition;
    SignalRead1.OpenFile;
    SignalRead1.RecordPosition := 0;
    SignalBuffer.Reset();
    SpectrumAnalyzer3.Update;

    SignalBuffer.Pull;
    SignalBuffer.Pull;
    SignalBuffer.Pull;

    while (SignalBuffer.Pull <> pipeEnd) and (SignalRead1.RecordPosition < SignalBandpass.FilterDelay*2) do
    begin
        if SignalBuffer.PipeState = pipeEnd then Break;
    end;

    PositionLabel.Text := 'Position: ' + IntToStr(SignalRead1.RecordPosition);

    SpectrumAnalyzer1.Update;
end;

procedure TNarrowBandpassForm.SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
begin
    SpectrumAnalyzer1.Update;
    SpectrumAnalyzer3.Update;
end;

procedure TNarrowBandpassForm.MtxFloatEdit1Change(Sender: TObject);
begin
    SignalBandpass.Subbandwidth := MtxFloatEdit2.FloatPosition;
    SignalBandpass.SubbandFrequency := MtxFloatEdit1.FloatPosition;
    SignalBandpass.Ripple := Exp10(StrToInt(AttBox.Selected.Text)/-20);
    SignalRead1.RecordPosition := 0;
    SignalBuffer.Length := 1024;
    SignalBuffer.Reset();
    SpectrumAnalyzer3.Update;

    SignalBuffer.Pull;
    SignalBuffer.Pull;
    SignalBuffer.Pull; //this is to compensate for the delay of the signal, so that that the frequency spectrum
                      //is not executed on partially zeroed out signal.
    while (SignalBuffer.Pull <> pipeEnd) and (SignalRead1.RecordPosition < SignalBandpass.FilterDelay*2) do
    begin
        if SignalBuffer.PipeState = pipeEnd then Break;
    end;

    PositionLabel.Text := 'Position: ' + IntToStr(SignalRead1.RecordPosition);
    FilterDelayLabel.Text := 'Delay: ' + FormatSample('0.#',SignalBandpass.FilterDelay);

    SpectrumAnalyzer1.Update;
end;

procedure TNarrowBandpassForm.FormResize(Sender: TObject);
begin
     {$IFNDEF POSIX}
     SpectrumChart3.Height := Panel1.Height / 2;
     {$ENDIF}
end;

procedure TNarrowBandpassForm.AttBoxChange(Sender: TObject);
begin
     MtxFloatEdit1Change(Sender);
end;

procedure TNarrowBandpassForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor1.Execute;
end;

procedure TNarrowBandpassForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog1.Execute();
end;

initialization
RegisterClass(TNarrowBandpassForm);

end.
