unit AsioPlaybackUnit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header, FMX.Dialogs, AsioAudioSignal, SignalProcessing, SignalTools,
  FileSignal, FMXTee.Editor.EditorPanel, MtxBaseComp, FmxMtxVecTee, FMX.Layouts,
  FMX.ListBox, FMXTee.Engine, SignalToolsTee, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMX.Controls.Presentation;


type
  TAsioPlaybackForm = class(TForm)
    Timer: TTimer;
    TopChart: TSignalChart;
    Panel1: TPanel;
    DriverNameListBox: TListBox;
    Label2: TLabel;
    FSListBox: TListBox;
    Label1: TLabel;
    Label3: TLabel;
    OutputChBox: TListBox;
    StartButton: TButton;
    StopButton: TButton;
    BottomChart: TSignalChart;
    Splitter1: TSplitter;
    SignalList: TSignalList;
    ChartEditor1: TChartEditor;
    Series2: TMtxFastLineSeries;
    ChartTool1: TAxisScaleTool;
    ChartTool2: TAxisScaleTool;
    SignalRead: TSignalRead;
    SignalDemuxList: TSignalDemuxList;
    Series3: TFastLineSeries;
    Button1: TButton;
    SignalRateConverterList: TSignalRateConverterList;
    SignalAsio: TSignalAsio;
    ClockSourcesBox: TListBox;
    Label5: TLabel;
    OpenDialog: TOpenDialog;
    StatusLabel: TLabel;
    VolumeTrackBar: TTrackBar;
    procedure StopButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DriverNameListBoxClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SignalRateConverterListBeforeUpdate(Sender: TObject);
    procedure SignalAsioProcessRealTime(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AsioPlaybackForm: TAsioPlaybackForm;

implementation

uses Math387, MtxVec, AbstractMtxVec, MtxExpr, Stringvar;

{$R *.FMX}

procedure TAsioPlaybackForm.Button1Click(Sender: TObject);
begin
    SignalAsio.ShowControlPanel;
end;

procedure TAsioPlaybackForm.DriverNameListBoxClick(Sender: TObject);
begin
    SignalAsio.DriverIndex := DriverNameListBox.ItemIndex;
    SignalAsio.GetSupportedSamplingFrequencies(FSListBox.Items);

    if FSListBox.Items.Count > 0 then
    begin
      FSListBox.ListItems[0].IsSelected := True;
      SignalAsio.SamplingFrequency := StrToSample(FSListBox.Items[0])
    end else ShowMessage('Supported sampling frequency not found!');

//    SignalAsio.GetInputChannels(InputChBox.Items);
    SignalAsio.GetOutputChannels(OutputChBox.Items);
    SignalAsio.GetClockSources(ClockSourcesBox.Items);
end;

procedure TAsioPlaybackForm.FormCreate(Sender: TObject);
begin
    SignalAsio.GetDriverList(DriverNameListBox.Items);
end;

procedure TAsioPlaybackForm.FormResize(Sender: TObject);
begin
    TopChart.Height := (ClientHeight - Panel1.Height) / 2;
end;

procedure TAsioPlaybackForm.StopButtonClick(Sender: TObject);
begin
    SignalAsio.Stop;
    Timer.Enabled := false;
end;

procedure TAsioPlaybackForm.TimerTimer(Sender: TObject);
var bSize, bSamples: integer;
    inL, outL: double;
begin
    try
        bSamples := 0;
        bSize := 0;

        if SignalAsio.OutputChannelCount > 0 then
        begin
            SignalAsio.MonitorOutput(SignalList);
            SignalAsio.OutputBufferStats(bSize, bSamples);
        end;

        if SignalAsio.DriverIndex >= 0 then
        begin
            SignalAsio.GetDriverLatencies(inL, outL);
            StatusLabel.Text := Format('ASIO Version = %d, BufferSize = %d, BufferedSamples = %d, ' +
                              'InLatency = %g [ms], OutLatency = %g [ms], ActualLatency = %g [ms], Elapsed time = %g',
                              [SignalAsio.DriverVersion, bSize, bSamples,
                              inL, outL, SignalAsio.ActualLatency, SignalAsio.ElapsedTime]) + ',ProcessingTime = ' + FormatSample('0.000',SignalAsio.ProcessingTime) + ' [ms]';

            SignalList.UpdateNotify;
        end;
    except
        Timer.Enabled := false;
    end;
end;

procedure TAsioPlaybackForm.SignalAsioProcessRealTime(Sender: TObject);
var i: integer;
begin
    //put real time processing code here
    // for playback take data from OutputBuffers, process and put and back in.
    // for real time recording/playback, take data from InputBuffers, process them and put them to OutputBuffers

    // THIS EVENT RUNS IN DRIVERS THREAD. DO NOT PERORM OPERATIONS ON THE SAME VARS
    // FROM MORE THAN ONE THREAD.
    // Only InputBuffers and OutputBuffers can be read/written with processing in between

    for i := 0 to SignalAsio.OutputBuffers.Count - 1 do //real time volume control, could also be echo, reverb etc..
    begin
        SignalAsio.OutputBuffers[i].Scale(VolumeTrackBar.Value/VolumeTrackBar.Max);
    end;
end;

procedure TAsioPlaybackForm.SignalRateConverterListBeforeUpdate(
  Sender: TObject);
begin
    TSignalRateConverter(Sender).Factor := SignalAsio.SamplingFrequency/SignalRead.SamplingFrequency;
end;

procedure TAsioPlaybackForm.StartButtonClick(Sender: TObject);
var i: integer;
begin
    if DriverNameListBox.ItemIndex < 0 then ERaise('Please select a valid ASIO driver first!');
    SignalASIO.Stop;

    for i := 0 to FSListBox.Count - 1 do
    begin
        if FSListBox.ListItems[i].IsSelected then
        begin
            SignalAsio.SamplingFrequency := StrToInt(FSListBox.Items[i]);
            Break;
        end;
    end;

//    for i := 0 to InputChBox.Count - 1 do
//        SignalAsio.InputsSelected[i] := InputChBox.Selected[i];

    for i := 0 to OutputChBox.Count - 1 do
        SignalAsio.OutputsSelected[i] := OutputChBox.ListItems[i].IsSelected;

    SignalRead.CloseFile;
    if OpenDialog.Execute() then
    begin
        SignalRead.FileName := OpenDialog.FileName; // 'C:\TestTone20.wav';
        SignalRead.OpenFile;
        SignalAsio.InputPrecision := prInteger;
        SignalAsio.OutputPrecision := SignalRead.Precision;

    ////////////  - Added as an example how to play more channels than stored in the file
        SignalDemuxList.Input := nil;
        SignalDemuxList.Count := SignalAsio.OutputChannelCount;
        for i := 0 to SignalDemuxList.Count - 1 do
        begin
            SignalDemuxList[i].Input := SignalRead;
            SignalDemuxList[i].Channel := i mod SignalRead.ChannelCount; //just take same channels more than once
        end;
    ////////////

        SignalAsio.Start;
        Timer.Enabled := True;

        TAxisScaleTool(TopChart.Tools[0]).Reset;
        TAxisScaleTool(BottomChart.Tools[0]).Reset;
    end;
end;

initialization
  RegisterClass(TAsioPlaybackForm);

end.
