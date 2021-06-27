unit PeakMarkingFormating;

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
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Layouts,

  SignalTools,
  FileSignal,
  MtxDialogs,
  SignalToolsDialogs,
  MtxBaseComp,
  SignalAnalysis,
  SignalToolsTee,

  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs,
  FMXTee.Chart,
  FMXTee.Editor.Chart,
  FMXTee.Tools, FMX.ScrollBox, FMX.Controls.Presentation;


type
  TPeakMarkingFormatingForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    Series1: TFastLineSeries;
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    Series2: TPointSeries;                            
    SignalRead1: TSignalRead;                               
    ToolButton1: TButton;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PeakMarkingFormatingForm: TPeakMarkingFormatingForm;

implementation

uses Basic1;

{$R *.FMX}

procedure TPeakMarkingFormatingForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TPeakMarkingFormatingForm.ChartEditButtonClick(Sender: TObject);
begin
//    ChartEditor.DefaultTab := cetSeriesMarks;
    ChartEditor.Execute;
end;

procedure TPeakMarkingFormatingForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TPeakMarkingFormatingForm.FormCreate(Sender: TObject);
begin
     SignalRead1.FileName := GetFile1('bz.sfs');

     SignalRead1.OpenFile;
     SpectrumAnalyzer.Pull;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('');
        Add('   Marked peaks can be formated in many ways:');
        Add('');
        Add('');

        Add('   *   Change the formating of the associated chart series2 by clicking on the Chart button.');
        Add('   *   Change the formating of displayed amplitude labels, by clicking on the Mark tool.');


     end;
end;

procedure TPeakMarkingFormatingForm.ToolButton1Click(Sender: TObject);
begin
//    ChartEditor.DefaultTab := cetTools;
    ChartEditor.Execute;
end;

initialization
RegisterClass(TPeakMarkingFormatingForm);

end.
