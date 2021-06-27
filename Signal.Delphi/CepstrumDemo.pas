unit CepstrumDemo;

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
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Layouts,

  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs,
  FMXTee.Chart,

  MtxBaseComp,
  SignalTools,
  SignalAnalysis,
  SignalToolsDialogs,
  FmxSpectrumAna,
  SignalToolsTee,
  FileSignal,
  SignalSeriesTee,
  SignalProcessing,
  MtxVec,
  MtxDialogs,
  FmxMtxComCtrls,
  Math387,
  MtxExpr, FMX.Controls.Presentation, FMX.ScrollBox;

type
  TCepstrumDemoForm = class(TForm)
    SpectrumAnalyzerDialog1: TSpectrumAnalyzerDialog;
    SignalRead1: TSignalRead;
    ChartEditor1: TChartEditor;
    RichEdit1: TMemo;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    Panel1: TPanel;
    SpectrumChart2: TSpectrumChart;
    FastLineSeries1: TFastLineSeries;
    SignalDiscreteSeries1: TSignalDiscreteSeries;     
    AxisScaleTool1: TAxisScaleTool;
    Splitter2: TSplitter;
    CepstrumBox: TComboBox;
    Label1: TLabel;
    SignalChart1: TSignalChart;
    Signal1: TSignal;
    Series1: TFastLineSeries;
    Series2: TPointSeries;
    ToolButton1: TButton;
    ChartEditor2: TChartEditor;
    SpectrumAnalyzer1: TSpectrumAnalyzer;
    procedure FormCreate(Sender: TObject);
    procedure SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure CepstrumBoxChange(Sender: TObject);
    procedure SpectrumAnalyzer1AfterUpdate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Data: Vector;
  end;

var
  CepstrumDemoForm: TCepstrumDemoForm;

implementation

uses SignalUtils, AbstractMtxVec, Basic1;

{$R *.FMX}

procedure TCepstrumDemoForm.FormCreate(Sender: TObject);
begin
     SignalRead1.Length := 4096;
     SignalRead1.FileName := GetFile1('bz.sfs');


     SignalRead1.OverlappingPercent := 50;
     SignalRead1.OpenFile;
     With RichEdit1.Lines, RichEdit1 do
     begin
         Clear;
         Add('Complex cepstrum can be used to measure echo delays and for homomorphic filtering.' +
             'Real cepstrum can detect periodicities in the frequency spectrum. ');
         
         
     end;
     CepstrumBox.ItemIndex := 0;
     CepstrumBoxChange(Sender);
end;

procedure TCepstrumDemoForm.FormDestroy(Sender: TObject);
begin
    //
end;

procedure TCepstrumDemoForm.SpectrumAnalyzer1ParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer1.Update;
end;

procedure TCepstrumDemoForm.FormResize(Sender: TObject);
begin
     {$IFNDEF POSIX}
     SpectrumChart2.Height := Panel1.Height / 2;
     {$ENDIF}
end;

procedure TCepstrumDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor1.Execute;
end;

procedure TCepstrumDemoForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog1.Execute();
end;

procedure TCepstrumDemoForm.CepstrumBoxChange(Sender: TObject);
begin
     SignalRead1.RecordPosition := 0;
     SpectrumAnalyzer1.ResetAveraging;
     SpectrumAnalyzer1.PullUntilEnd;
     SpectrumAnalyzer1.UpdateNotify; //Notify disabled within PullUntilEnd 
     Signal1.SamplingTime := Signal1.Length;
     Signal1.UpdateNotify;  //update connected chart.
end;

procedure TCepstrumDemoForm.SpectrumAnalyzer1AfterUpdate(Sender: TObject);
begin
     Data.Size(0); //required by CLR only because data is passed as parameter and was initialized before
     case CepstrumBox.ItemIndex of
     0: RealCepstrum(SignalRead1.Data,Data,True,wtHanning,True);
     1: CplxCepstrum(SignalRead1.Data,Data);
     end;
     Signal1.Data[0] := 0; //set DC to zero
     RunningAverage(Signal1.Data,Data,SignalRead1.FrameNumber);
end;

procedure TCepstrumDemoForm.ToolButton1Click(Sender: TObject);
begin
     ChartEditor2.Execute;
end;

initialization
RegisterClass(TCepstrumDemoForm);

end.
