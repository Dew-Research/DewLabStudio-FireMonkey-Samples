unit FractionalFiltering;

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
  FMX.Objects,
  Fmx.StdCtrls,
  FMX.Header,
  MtxDialogs,
  SignalToolsDialogs,
  SignalTools, MtxBaseComp,
  SignalAnalysis, FMXTee.Editor.EditorPanel, FMXTee.Engine, SignalToolsTee,
  FMXTee.Series, SignalSeriesTee, FMXTee.Procs, FMXTee.Chart, FMX.ListBox,
  FMX.Edit, FmxMtxComCtrls, FMX.Layouts, FMX.Memo, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo.Types;

type
  TFractionalFilteringForm = class(TForm)
    ChartEditor1: TChartEditor;
    RichEdit1: TMemo;
    Panel2: TPanel;                                  
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;                           
    Label2: TLabel;
    FractionalEdit: TMtxFloatEdit;
    Panel1: TPanel;
    SpectrumChart: TSpectrumChart;
    FastLineSeries1: TFastLineSeries;
    SignalDiscreteSeries1: TSignalDiscreteSeries;
    AxisScaleTool1: TAxisScaleTool;
    Splitter2: TSplitter;
    GroupDelayChart: TSpectrumChart;
    FastLineSeries2: TFastLineSeries;
    SignalDiscreteSeries2: TSignalDiscreteSeries;
    AxisScaleTool2: TAxisScaleTool;
    ChartTool1: TSpectrumMarkTool;
    FilterDelayLabel: TLabel;
    FractionalFilterBox: TComboBox;
    Label1: TLabel;
    Signal: TSignal;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    LogBox: TCheckBox;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    procedure FormCreate(Sender: TObject);
    procedure SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
    procedure MtxFloatEdit1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure SignalAfterUpdate(Sender: TObject);
    procedure FractionalFilterBoxChange(Sender: TObject);
    procedure FractionalEditChange(Sender: TObject);
    procedure LogBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FractionalFilteringForm: TFractionalFilteringForm;

implementation

uses SignalUtils, Math387, FmxMtxVecTee, MtxExpr, MtxVec, AbstractMtxVec;

{$R *.FMX}

procedure TFractionalFilteringForm.FormCreate(Sender: TObject);
begin
     Controller.Pool[0].Vec.DebugReport; //error checking

     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Fractional filters are linear phase filters which delay the signal by ' +
            'a user specified fraction of a sample. Their delay is composed from ' +
            'integer sample count plus the fractional part. Demonstrated are filters ' +
            'with relaxed stopband specification. Stopband is allowed to vary between 0 and 1. ' +
            'Observe the group delay and compare the actual delay as a function of frequency to the Total delay label. ' +
            'Various predefined designs are available which compromise between different filter properties.' +
            'When there is a need for other filter, any lowpass/bandpass filter can be designed to have ' +
            'a fractional delay (less than one sample) part also by using FractionalKaiserImpulse function.' );



    end;
    FractionalFilterBox.ItemIndex := integer(falp_60dB);
    FractionalFilterBoxChange(Sender);
end;

procedure TFractionalFilteringForm.SignalAfterUpdate(Sender: TObject);
begin
    //
end;

procedure TFractionalFilteringForm.SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
begin
    SpectrumAnalyzer.Update;
end;

procedure TFractionalFilteringForm.MtxFloatEdit1Change(Sender: TObject);
begin
    //
end;

procedure TFractionalFilteringForm.FormResize(Sender: TObject);
begin
    {$IFNDEF AUTOREFCOUNT}
    GroupDelayChart.Height := Panel1.Height / 2;
    {$ENDIF}
end;

procedure TFractionalFilteringForm.FractionalEditChange(Sender: TObject);
begin
    FractionalFilterBoxChange(Sender);
end;

procedure TFractionalFilteringForm.LogBoxChange(Sender: TObject);
begin
    SpectrumAnalyzer.Logarithmic := LogBox.IsChecked;
    if LogBox.IsChecked then
        SpectrumChart.LeftAxis.Title.Caption := 'Magnitude [dB]'
    else
        SpectrumChart.LeftAxis.Title.Caption := 'Amplitude';

    SpectrumAnalyzer.Update;
end;

procedure TFractionalFilteringForm.FractionalFilterBoxChange(Sender: TObject);
var H, DeltaImpulse: Vector;
    GrpDelay: Vector;
    FirState: TFirState;
    Delay: TSample;
begin
     Delay := FractionalImpulse(H, FractionalEdit.FloatPosition, TFractionalImpulse(FractionalFilterbox.ItemIndex));
     DeltaImpulse.Size(4096);
     DeltaImpulse.SetZero;
     DeltaImpulse[0] := DeltaImpulse.Length div 2;

     FirInit(H, FirState);
     FirFilter(DeltaImpulse, Signal.Data, FirState);
     FirFree(FirState);

     SpectrumAnalyzer.Update;
     GroupDelay(grpDelay, H, nil, 32);
     DrawValues(grpDelay, GroupDelayChart.Series[0],0, Signal.SamplingFrequency/(grpDelay.Length*2));

     FilterDelayLabel.Text := 'Total delay = ' + FormatSample('0.000',Delay) + ' [Samples]';
end;

procedure TFractionalFilteringForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor1.Execute;
end;

procedure TFractionalFilteringForm.SpectrumEditButtonClick(Sender: TObject);
begin
   SpectrumAnalyzerDialog.Execute();
end;

initialization
RegisterClass(TFractionalFilteringForm);

end.

