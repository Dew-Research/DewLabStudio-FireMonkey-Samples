unit RateConvertUnit;

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
  FMX.Header, FMXTee.Editor.EditorPanel, MtxDialogs, SignalToolsDialogs,
  SignalTools, SignalAnalysis, SignalProcessing, MtxBaseComp, FMX.Layouts,
  FMX.Memo, SignalToolsTee, FMX.Edit, FmxMtxComCtrls, FMXTee.Engine,
  FMXTee.Series, FMXTee.Procs, FMXTee.Chart, Math387,
  FMX.Controls.Presentation;

type
  TRateConvertForm = class(TForm)
    SignalRateConverter: TSignalRateConverter;
    SignalStoreBuffer: TSignalStoreBuffer;
    SignalStoreBuffer1: TSignalStoreBuffer;
    SignalChart: TSignalChart;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Updatebutton: TButton;
    SpectrumChart: TSpectrumChart;
    ConvertedSignal: TFastLineSeries;
    OriginalSignal: TFastLineSeries;
    ConvertedSpectrum: TFastLineSeries;
    OriginalSpectrum: TFastLineSeries;
    SpectrumAnalyzer1: TSpectrumAnalyzer;              
    RateFactorEdit: TMtxFloatEdit;                     
    Label1: TLabel;
    ResetButton: TButton;
    SignalGeneratorDialog: TSignalGeneratorDialog;
    Button1: TButton;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    RichEdit: TMemo;
    SignalGenerator: TSignalGenerator;
    Button2: TButton;
    ChartEditor1: TChartEditor;
    procedure SignalGeneratorParameterUpdate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SignalGenButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure RateFactorEditChange(Sender: TObject);
    procedure UpdatebuttonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure Reset;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  end;

var
  RateConvertForm: TRateConvertForm;

implementation

{$R *.FMX}

procedure TRateConvertForm.Button1Click(Sender: TObject);
begin
  SignalGeneratorDialog.Execute;
end;

procedure TRateConvertForm.Button2Click(Sender: TObject);
var i: integer;
begin
    StartTimer;
    for i := 0 to 1000 - 1 do SignalRateConverter.Update;

    Button2.Text  :=  FormatSample('0.00ms', StopTimer*1000);
end;

constructor TRateConvertForm.Create(AOwner: TComponent);
begin
    inherited;

    RateFactorEdit.FloatPosition := SignalrateConverter.Factor;
    With RichEdit.Lines, RichEdit do
    begin
      Clear;
      Add('Change rate conversion factor and observe the frequency response. For this ' +
          'example, the noise attenuation is set to 100dB. Maximum range is 150dB.  ' +
          'Signal generator allows you to test the rate converter with two preset signals. '+
          'Gaussian noise and 3 independent single tone frequencies. Each time you press update ' +
          'signal generator advances and a new block data is streamed in to the buffers through ' +
          'the rate converter. The Reset button resets the buffers and the rate conversion.' +
          'There is no limit on maximum or minimum rate conversion factor or its precision. ' +
          'All filters used are linear phase. The rate converter is of substantially higher quality' +
          'than those provided by Windows or by Soundcard makers. The test is not very responsive ' +
          'because the charts have to do a lot of drawing, but the conversion itself is very fast.' );
    end;
end;

destructor TRateConvertForm.Destroy;
begin
  inherited;
end;

procedure TRateConvertForm.RateFactorEditChange(Sender: TObject);
begin
    SignalrateConverter.Factor := RateFactorEdit.FloatPosition;
    Reset;    
    UpdateButtonClick(Sender);
    UpdateButtonClick(Sender);
end;

procedure TRateConvertForm.Reset;
begin
    SignalStoreBuffer.Reset;
    SignalStoreBuffer1.Reset;
    SignalGenerator.Reset;
    SignalRateConverter.Reset;
end;

procedure TRateConvertForm.ResetButtonClick(Sender: TObject);
begin
    Reset;
end;

procedure TRateConvertForm.SignalGenButtonClick(Sender: TObject);
begin
    SignalGeneratorDialog.Execute;
end;

procedure TRateConvertForm.SignalGeneratorParameterUpdate(Sender: TObject);
begin
   Reset;
   UpdateButtonClick(Sender);
   UpdateButtonClick(Sender);
end;

procedure TRateConvertForm.UpdatebuttonClick(Sender: TObject);
begin
    SpectrumAnalyzer.Pull;
    SpectrumAnalyzer1.Pull;
end;

initialization
RegisterClass(TRateConvertForm);


end.
