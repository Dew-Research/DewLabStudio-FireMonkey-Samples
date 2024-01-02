unit OnLineCoherence;

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
  FMX.Memo,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.ListBox,

  FmxSpectrumAna,
  SignalToolsTee,
  SignalToolsDialogs,
  SignalTools,
  SignalAnalysis,
  FileSignal,
  SignalUtils,
  AudioSignal,
  MtxDialogs,
  MtxBaseComp,

  FMXTee.Editor.EditorPanel,
  FMXTee.Chart,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs, FMX.Memo.Types, FMX.ScrollBox, FMX.Controls.Presentation;

type
  TOnLineCoherenceForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    Series1: TFastLineSeries;
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    Series2: TPointSeries;                      
    CrossAnalyzer: TCrossSpectrumAnalyzer;
    SpectrumBox: TComboBox;
    Label1: TLabel;
    SignalTimer1: TSignalTimer;
    Signal1: TSignal;
    SignalIn1: TSignalIn;
    Signal2: TSignal;
    ToolButton1: TButton;
    CrossSpectrumAnalyzerDialog: TCrossSpectrumAnalyzerDialog;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpectrumBoxChange(Sender: TObject);
    procedure SignalTimer1Timer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure CrossAnalyzerParameterUpdate(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  OnLineCoherenceForm: TOnLineCoherenceForm;

implementation

{$R *.FMX}

uses MtxVec;

procedure TOnLineCoherenceForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TOnLineCoherenceForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     CrossAnalyzer.Update;
end;

procedure TOnLineCoherenceForm.FormCreate(Sender: TObject);
begin
     Signal1.Data.Size(2048);  // defines how much data to copy and
                               // consequently also frequency resolution
     Signal1.Data.SetZero;
     Signal1.UsesInputs := false;
     Signal1.SamplingFrequency := SignalIn1.SamplingFrequency;

     Signal2.Data.Size(2048);  // defines how much data to copy and
     Signal2.UsesInputs := false;
     Signal2.SamplingFrequency := SignalIn1.SamplingFrequency;

     CrossAnalyzer.Stats.Averaging := avExponentInf;
     CrossAnalyzer.Stats.ExpDecay := 20;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('The cross spectral analysis is usefull when trying to determine:');
        Add('');


        Add('What is the transfer function of the system.');
        Add('Is the system linear or not. If it is not linear, at which frequencies ' +
            'is the system non-linear.');


        Add('');
        Add('This example shows how you can run this tests in real time. You could ' +
            'connect your test signal to the left channel and microphone input to the ' +
            'right channel. If your test signal would be going to the speakers, the microphone ' +
            'will be recording the sound comming from them and the transfer function ' +
            'would show you what is the frequency response of your audio system: '+
            'amplifier + cables + speakers + room + microphone. ');

    end;
end;

procedure TOnLineCoherenceForm.SpectrumBoxChange(Sender: TObject);
begin
   CrossAnalyzer.CrossAnalyzer.Transform := TCrossTransform(SpectrumBox.ItemIndex);
   SpectrumChart.Title.Text.Clear;
   SpectrumChart.Title.Text.Add(CrossTransformToString(CrossAnalyzer.CrossAnalyzer.Transform));
   CrossAnalyzer.UpdateSpectrum; //copy the correct TCrossTransfrom to CrossAnalyzer.Amplt
                                 //update bands, peaks and chart, but do not perform average
end;

procedure TOnLineCoherenceForm.SignalTimer1Timer(Sender: TObject);
begin
   if not SignalIn1.Active then SignalIn1.Start;
   SignalIn1.MonitorData(Signal1,Signal2);
   CrossAnalyzer.Pull;
end;

procedure TOnLineCoherenceForm.ToolButton1Click(Sender: TObject);
begin
   CrossSpectrumAnalyzerDialog.Execute;
end;

procedure TOnLineCoherenceForm.CrossAnalyzerParameterUpdate(Sender: TObject);
begin
   SpectrumBox.ItemIndex := Byte(CrossAnalyzer.CrossAnalyzer.Transform);
   SpectrumChart.Title.Text.Clear;
   SpectrumChart.Title.Text.Add(CrossTransformToString(CrossAnalyzer.CrossAnalyzer.Transform));
   CrossAnalyzer.UpdateSpectrum; //copy the correct TCrossTransfrom to CrossAnalyzer.Amplt
                                 //update bands, peaks and chart, but do not perform average
end;

initialization
RegisterClass(TOnLineCoherenceForm);

end.
