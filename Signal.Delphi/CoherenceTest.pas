unit CoherenceTest;

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
  Fmx.StdCtrls,
  FMX.Header,

  SignalUtils, MtxExpr, MtxDialogs, SignalToolsDialogs, SignalTools,
  SignalAnalysis, MtxBaseComp, FileSignal, FMXTee.Editor.EditorPanel,
  FMX.Layouts, FMX.Memo, FMX.ListBox, FMXTee.Engine, SignalToolsTee,
  FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.ScrollBox,
  FMX.Controls.Presentation, FMX.Memo.Types;


type
  TCoherenceTestForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    Series1: TFastLineSeries;
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    Series2: TPointSeries;
    SignalRead1: TSignalRead;
    FilteredSignal: TSignal;
    SpectrumBox: TComboBox;
    Label1: TLabel;                                               
    PhaseBox: TCheckBox;
    EditSpectrumButton: TButton;
    CrossSpectrumAnalyzerDialog: TCrossSpectrumAnalyzerDialog;
    UpdateButton: TButton;
    FilterLengthLabel: TLabel;
    CrossAnalyzer: TCrossSpectrumAnalyzer;
    procedure SignalRead1AfterUpdate(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure SpectrumBoxChange(Sender: TObject);
    procedure EditSpectrumButtonClick(Sender: TObject);
    procedure CrossAnalyzerParameterUpdate(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure PhaseBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FirState: TFirState;
  end;

var
  CoherenceTestForm: TCoherenceTestForm;

implementation

{$R *.FMX}

uses MtxVec, Math387, Basic1;


procedure TCoherenceTestForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TCoherenceTestForm.SignalRead1AfterUpdate(Sender: TObject);
begin
     if Assigned(FilteredSignal) then
     begin
           FirFilter(SignalRead1.Data, FilteredSignal.Data,FirState);
           FilteredSignal.SamplingFrequency := SignalRead1.SamplingFrequency;
     end;
end;

procedure TCoherenceTestForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     CrossAnalyzer.Update;
end;

procedure TCoherenceTestForm.FormCreate(Sender: TObject);
var h: Vector;
    Delay: integer;
begin
     SignalRead1.FileName := GetFile1('bz.sfs');
     SignalRead1.OpenFile;

     h.Size(0); //required by .NET only
     KaiserImpulse(h,[0.2,0.25],0.001,ftLowPass,1,2,true);
     Delay := (H.Length-1) div 2;
     FilterLengthLabel.Text := 'Filter delay = ' + IntToStr(Delay) + ' samples, ' +
                                FormatSample('0.00000s',Delay*SignalRead1.Dt);

     FirInit(H,FirState);

     FilteredSignal.UsesInputs := false;
//     SpectrumBox.ItemIndex := 4;
     SpectrumChart.Spectrums[0].Series := SpectrumChart.Series[0];
     ToolButton1Click(Sender);

     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('The cross spectral analysis is usefull when trying to determine:');
        Add('');


        Add('What is the transfer function of the system.');
        Add('Is the system linear or not. If it is not linear, at which frequencies ' +
            'is the system non-linear.');


        Add('');
        Add('Change the value of the spectrum box to see the frequency spectrum of the signal that was' +
            'send in to the system (input spectrum), what came out (output spectrum), what is the ' +
            'frequency response of the system (transfer function) and the test for linearity (coherence). ' +
            'The system in this test case is a low pass FIR filter. With sufficient averaging, coherence ' +
            'would converge to 1. A coherence of 1 means that the system is linear at that frequency.');


    end;
end;

procedure TCoherenceTestForm.FormDestroy(Sender: TObject);
begin
     FirFree(FirState);
end;

procedure TCoherenceTestForm.ToolButton1Click(Sender: TObject);
begin
     SignalRead1.OpenFile;
     SignalRead1.RecordPosition := 0;
     SignalRead1.LastFrameCheck := lfcLastFullBlock;
//   SignalRead1.OverlappingPercent := 50;  we can not use this, because of the filter
     with CrossAnalyzer do
     begin
          ResetAveraging;
          Logarithmic := True;
          Window := wtHanning;
          LogType := ltRelative;
     end;
     CrossAnalyzer.CrossAnalyzer.Recursive := false;
     while (CrossAnalyzer.Pull <> pipeEnd) do
     begin
          //fast enough so there is no need for a progress indicator here
     end;
     CrossAnalyzer.CrossAnalyzer.Update;  //if recursive would be True, this would not be neccessary.
     SpectrumBoxChange(Sender);
end;

procedure TCoherenceTestForm.SpectrumBoxChange(Sender: TObject);
begin
     CrossAnalyzer.CrossAnalyzer.Transform := TCrossTransform(SpectrumBox.ItemIndex);
     SpectrumChart.Title.Text.Clear;
     SpectrumChart.Title.Text.Add(CrossTransformToString(CrossAnalyzer.CrossAnalyzer.Transform));
     CrossAnalyzer.UpdateSpectrum;
end;

procedure TCoherenceTestForm.PhaseBoxChange(Sender: TObject);
begin
     SpectrumChart.SpectrumPart := TSpectrumPart(PhaseBox.IsChecked);
     Case SpectrumChart.SpectrumPart of
     sppAmplt: SpectrumChart.LeftAxis.Title.Caption := 'Amplitude';
     sppPhase: SpectrumChart.LeftAxis.Title.Caption := 'Delay [seconds]';
     end;
end;

procedure TCoherenceTestForm.EditSpectrumButtonClick(Sender: TObject);
begin
     CrossSpectrumAnalyzerDialog.Execute;
end;

procedure TCoherenceTestForm.CrossAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumBox.ItemIndex := Byte(CrossAnalyzer.CrossAnalyzer.Transform);
     SpectrumChart.SpectrumPart := TSpectrumPart(PhaseBox.IsChecked);
     SpectrumChart.Title.Text.Clear;
     SpectrumChart.Title.Text.Add(CrossTransformToString(CrossAnalyzer.CrossAnalyzer.Transform));
     CrossAnalyzer.UpdateSpectrum;
end;

procedure TCoherenceTestForm.UpdateButtonClick(Sender: TObject);
begin
     SignalRead1.RecordPosition := 0;
     CrossAnalyzer.CrossAnalyzer.Recursive := false;
     CrossAnalyzer.PullUntilEnd;
     CrossAnalyzer.CrossAnalyzer.Update;  //if recursive would be True, this would not be neccessary.
     SpectrumBoxChange(Sender);
end;

initialization
RegisterClass(TCoherenceTestForm);

end.
