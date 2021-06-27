unit OnLineBicoherence;

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
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Layouts,
  FMX.Memo,
  FMX.Edit,
  SignalTools,
  SignalAnalysis,
  SignalToolsTee,
  FileSignal,
  FmxMtxComCtrls,
  AudioSignal,
  SignalToolsDialogs,
  MtxDialogs,
  MtxVec,
  MtxBaseComp,
  FmxTee.Series,
  FMXTee.Tools,
  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Procs,
  FMXTee.Chart, FMX.Controls.Presentation;

type
  TOnLineBicoherenceForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    FreqEdit: TMtxFloatEdit;
    Label1: TLabel;
    Panel2: TPanel;
    SpectrumChart: TSpectrumChart;                           
    Series1: TFastLineSeries;
    Series2: TPointSeries;
    ChartTool1: TAxisScaleTool;                    
    Splitter1: TSplitter;
    SpectrumChart1: TSpectrumChart;
    FastLineSeries1: TFastLineSeries;
    PointSeries1: TPointSeries;
    AxisScaleTool1: TAxisScaleTool;
    ChartTool2: TSpectrumMarkTool;
    SignalIn1: TSignalIn;
    Signal1: TSignal;
    SignalTimer1: TSignalTimer;
    ChannelBox: TComboBox;
    Label2: TLabel;
    ToolButton1: TButton;
    BiSpectrumAnalyzerDialog1: TBiSpectrumAnalyzerDialog;
    BiSpectrumAnalyzer: TBiSpectrumAnalyzer;
    ChartTool3: TSpectrumMarkTool;
    ChartTool4: TColorLineTool;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FreqEditChange(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure SignalTimer1Timer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ChannelBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OnLineBicoherenceForm: TOnLineBicoherenceForm;

implementation

{$R *.FMX}

uses FmxMtxVecEdit, FmxMtxVecTee, SignalUtils, Math387;

procedure TOnLineBicoherenceForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TOnLineBicoherenceForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TOnLineBicoherenceForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TOnLineBicoherenceForm.FormCreate(Sender: TObject);
begin
     Signal1.Data.Size(1024);  // defines how much data to copy and
                               // consequently also frequency resolution
     Signal1.Data.SetZero;
     Signal1.UsesInputs := false;
     Signal1.SamplingFrequency := SignalIn1.SamplingFrequency;
     BiSpectrumAnalyzer.Stats.Averaging := avExponentInf;
     BispectrumAnalyzer.Stats.ExpDecay := 20;
     with BispectrumAnalyzer do
     begin
          Amplt.SetZero;
          BiAnalyzer.SingleLinesOnly := True;
          BispectrumAnalyzer.BiAnalyzer.Lines.Size(100);
          BispectrumAnalyzer.BiAnalyzer.Lines.Ramp(20,10);  //becase resolution is about 10 Hz/line
     end;
     ChannelBox.ItemIndex := 0;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Bicoherence shows the frequencies related to the selected frequency. ' +
            'The bicoherence can also be run in real time, but before the ' +
            'spectrum is representative, sufficient number of running averages must be made.' +
            'A very limiting condition is that the frequency spectrum of the analyzed ' +
            'signal may not change significantly during the analysis.' +
            'Bicoherence can therefore be applied only in cases where it is possible ' +
            'to acquire sufficiently long signals whose frequency content does not change with time ' +
            'very quickly. For example, usually about 20 averages will be sufficient and with 90% ' +
            'overlapping. With a sampling frequency of 11kHz and frequency spectrum length of ' +
            '1024 frequency bins, that would mean that at least 6144/11025 = 0.4 seconds are needed ' +
            'during which the frequency content of the signal may not change significantly.');
        
        
     end;
//     SignalIn1.Start(SignalIn1)  //will not work from here...
     FreqEditChange(Sender);
end;

procedure TOnLineBicoherenceForm.FreqEditChange(Sender: TObject);
begin
      BispectrumAnalyzer.SamplingFrequency := SignalIn1.SamplingFrequency; //needed only for the first call
      //because the sampling frequency has not yet been set by the Update method,
      //simply because the timer has not yet triggered.  
      BispectrumAnalyzer.BiAnalyzer.Frequency := FreqEdit.FloatPosition;
      TColorLineTool(SpectrumChart.Tools[2]).Value := FreqEdit.FloatPosition;
      SpectrumChart1.Title.Text.Clear;
      SpectrumChart1.Title.Text.Add('Bicoherence of frequency: ' + FormatSample('0',FreqEdit.FloatPosition) + 'Hz');
end;

procedure TOnLineBicoherenceForm.Panel2Resize(Sender: TObject);
begin
      SpectrumChart1.Height := Panel2.Height / 2;
end;

procedure TOnLineBicoherenceForm.SignalTimer1Timer(Sender: TObject);
begin
     if not SignalIn1.Active then SignalIn1.Start;
     case TChannel(ChannelBox.ItemIndex) of
     chLeft:  SignalIn1.MonitorData(Signal1, nil    );
     chRight: SignalIn1.MonitorData(nil    , Signal1);
     end;
     SpectrumAnalyzer.Pull;
     BispectrumAnalyzer.Pull;
end;

procedure TOnLineBicoherenceForm.ToolButton1Click(Sender: TObject);
begin
     BispectrumAnalyzerDialog1.Execute;
end;

procedure TOnLineBicoherenceForm.ChannelBoxChange(Sender: TObject);
begin
     BispectrumAnalyzer.ResetAveraging;
end;

initialization
RegisterClass(TOnLineBicoherenceForm);

end.
