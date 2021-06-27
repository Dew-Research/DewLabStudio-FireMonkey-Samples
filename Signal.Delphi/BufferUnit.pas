unit BufferUnit;

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
  SignalTools,
  SignalAnalysis,
  SignalProcessing, MtxBaseComp,
  SignalToolsTee, FmxMtxComCtrls, FMXTee.Engine, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMX.Edit, FMX.Controls.Presentation;


type
  TBufferForm = class(TForm)
    SignalBuffer: TSignalBuffer;
    SignalChart1: TSignalChart;
    Series1: TFastLineSeries;
    Panel1: TPanel;                                              
    ButtonUpdate: TButton;
    BufferSizeEdit: TMtxFloatEdit;
    BufferSizeLabel: TLabel;
    UnreadBufferDataLabel: TLabel;
    Label3: TLabel;
    SignalUpdateLabel: TLabel;
    ReadCursorLabel: TLabel;
    DataReadLabel: TLabel;
    WriteCursorLabel: TLabel;
    SignalStoreBuffer: TSignalStoreBuffer;
    SpectrumChart1: TSpectrumChart;
    Splitter1: TSplitter;                             
    Series2: TFastLineSeries;
    Splitter2: TSplitter;
    SignalChart2: TSignalChart;
    FastLineSeries1: TFastLineSeries;
    InputBufferSizeLabel: TLabel;
    SignalGenerator: TSignalGenerator;
    SpectrumAnalyzer2: TSpectrumAnalyzer;
    SpectrumAnalyzer1: TSpectrumAnalyzer;
    StoreBufferLabel: TLabel;
    Label1: TLabel;
    InputBufferEdit: TMtxFloatEdit;
    ResetButton: TButton;
    procedure ResetButtonClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure SignalGeneratorAfterUpdate(Sender: TObject);
    procedure SignalBufferAfterUpdate(Sender: TObject);
    procedure BufferSizeEditChange(Sender: TObject);
    procedure SignalBufferBeforeUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InputBufferEditChange(Sender: TObject);
  private
    procedure DisplayUpdate;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BufferForm: TBufferForm;

implementation

uses SignalToolsDialogs, FmxMtxVecTee;

{$R *.FMX}

//What is this good for:

//Imagine you have a rational factor rate converter giving
//non constant number of samples per iteration. If rate
//conversion is 0.3 from 100Hz with input buffer length
//of 100 samples, the rate converter will be outputing
//33, 33, 34, 33, 33, 34....
// But some components like TSignalOut "require" fixed
//number of samples in the input buffer, because that is a requirement of Windows.
// TSignalBuffer allows you to ensure that fixed buffer
// length by inserting it between the rate converter
// and TSignalOut component.

procedure TBufferForm.ButtonUpdateClick(Sender: TObject);
var a: TPipeState;
begin
    SignalUpdateLabel.Text := 'Signal gen not updated';
    a := SpectrumAnalyzer1.Pull;
    case a of
    pipeOK: DataReadLabel.Text := 'Stream state = pipeOK';
    pipeStream: DataReadLabel.Text := 'Stream state = pipeStream';
    pipeBuffer: DataReadLabel.Text := 'Stream state = pipeBuffer';
    end;
end;

procedure TBufferForm.SignalGeneratorAfterUpdate(Sender: TObject);
begin
    SignalUpdateLabel.Text := 'Signal gen was updated!';
end;


procedure TBufferForm.DisplayUpdate;
begin
    BufferSizeLabel.Text := 'Buffer size: ' + IntToStr(Signalbuffer.BufferLength);
    WriteCursorLabel.Text := 'Write cursor: ' + IntToStr(SignalBuffer.BufferWritePosition);
    UnreadBufferDataLabel.Text := 'Samples in buffer: ' + IntToStr(SignalBuffer.BufferedSamplesCount);
    ReadCursorLabel.Text := 'Read cursor: ' + IntToStr(SignalBuffer.BufferReadPosition);
    InputBufferSizeLabel.Text := 'Input buffer size: ' + IntToStr(SignalGenerator.Length);
    StoreBufferLabel.Text := 'Store buffer size: ' + IntToStr(SignalStoreBuffer.Length);
end;

procedure TBufferForm.SignalBufferAfterUpdate(Sender: TObject);
begin
    DisplayUpdate;
end;

procedure TBufferForm.BufferSizeEditChange(Sender: TObject);
begin
    SignalBuffer.Length := BufferSizeEdit.IntPosition;
    DisplayUpdate;
end;

procedure TBufferForm.SignalBufferBeforeUpdate(Sender: TObject);
begin
    SignalChart2.Series[0].Clear;
end;

procedure TBufferForm.FormCreate(Sender: TObject);
begin
    BufferSizeEdit.IntPosition := SignalBuffer.Length;
    InputBufferEdit.IntPosition := SignalGenerator.Length;
    DisplayUpdate;
end;

procedure TBufferForm.InputBufferEditChange(Sender: TObject);
begin
    SignalGenerator.Length := InputBufferEdit.IntPosition;
    DisplayUpdate;
end;

procedure TBufferForm.ResetButtonClick(Sender: TObject);
begin
    SignalBuffer.Reset;
    SignalStoreBuffer.Reset;
    DisplayUpdate;
end;

initialization
RegisterClass(TBufferForm);

end.
