unit SignalAnalysisDemo;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  FMX.Dialogs,
  Fmx.StdCtrls,
  FMX.Header, MtxDialogs, SignalToolsDialogs, SignalAnalysis, MtxBaseComp,
  SignalTools, FileSignal, FMXTee.Editor.EditorPanel, FMXTee.Engine,
  SignalToolsTee, FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.Layouts,
  FMX.Memo, FMX.ListBox, FMX.Controls, FMX.Types, FMX.ScrollBox,
  FMX.Controls.Presentation;


type
  TSignalAnalysisDemoForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SignalChart1: TSignalChart;
    Series3: TFastLineSeries;
    FilterBox: TComboBox;
    Label1: TLabel;
    SignalRead1: TSignalRead;
    SignalAnalyzerDialog1: TSignalAnalyzerDialog;
    AnalysisButton: TButton;
    Series1: TPointSeries;
    SignalAnalyzer1: TSignalAnalyzer;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FilterBoxChange(Sender: TObject);
    procedure StepEditChange(Sender: TObject);
    procedure AnalysisButtonClick(Sender: TObject);
    procedure SignalAnalyzer1ParameterUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SignalAnalysisDemoForm: TSignalAnalysisDemoForm;

implementation

uses Math387, MtxVec, FmxMtxVecTee, Basic1;

{$R *.FMX}

procedure TSignalAnalysisDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TSignalAnalysisDemoForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

    SignalRead1.RecordPosition := 0;
    FilterBox.ItemIndex := 0;
    FilterBoxChange(Sender);
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('A simple drop-in component gives instant access to a wide array ' +
          'of standard signal processing operations like autocorrelation, discrete ' +
          'cosine transform, signal statistics and more...');
    end;
end;

procedure TSignalAnalysisDemoForm.FilterBoxChange(Sender: TObject);
begin
     SignalAnalyzer1.Transform := TTimeTransform(FilterBox.ItemIndex);
     SignalAnalyzer1.Update;
end;

procedure TSignalAnalysisDemoForm.StepEditChange(Sender: TObject);
begin
     FilterBoxChange(Sender);
end;

procedure TSignalAnalysisDemoForm.AnalysisButtonClick(Sender: TObject);
begin
     SignalAnalyzerDialog1.Execute;
end;

procedure TSignalAnalysisDemoForm.SignalAnalyzer1ParameterUpdate(
  Sender: TObject);
begin
     SignalAnalyzer1.Update;
end;

initialization
RegisterClass(TSignalAnalysisDemoForm);

end.
