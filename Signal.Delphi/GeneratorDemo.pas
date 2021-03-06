unit GeneratorDemo;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMXTee.Editor.Chart,
  FMXTee.Engine,
  FMXTee.Chart,
  FMXTee.Tools,
  FMXTee.Series,
  FMXTee.Procs,
  FMXTee.Editor.EditorPanel,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Memo,
  FMX.Controls,
  FMX.Types,

  SignalToolsTee,
  SignaltoolsDialogs,
  FileSignal,
  Signaltools,
  SignalAnalysis,
  FmxSpectrumAna,
  MtxBaseComp,
  FmxMtxComCtrls,
  MtxDialogs,
  SignalProcessing, FMX.ScrollBox, FMX.Controls.Presentation;


type
  TGeneratorDemoForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    Panel2: TPanel;
    SpectrumChart: TSpectrumChart;
    Series1: TFastLineSeries;
    Series2: TPointSeries;                                  
    Splitter1: TSplitter;                                
    SignalChart: TSignalChart;
    ToolButton1: TButton;
    ChartEditor1: TChartEditor;
    Series3: TFastLineSeries;
    ChartTool1: TAxisScaleTool;
    SignalGeneratorDialog1: TSignalGeneratorDialog;
    GeneratorButton: TButton;
    ToolButton2: TButton;
    SaveDialog: TSaveDialog;
    SignalWrite: TSignalWrite;
    SignalGenerator1: TSignalGenerator;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure GeneratorButtonClick(Sender: TObject);
    procedure SignalGenerator1ParameterUpdate(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GeneratorDemoForm: TGeneratorDemoForm;

implementation

uses SignalUtils, Math387;

{$R *.FMX}

procedure TGeneratorDemoForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TGeneratorDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TGeneratorDemoForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TGeneratorDemoForm.FormCreate(Sender: TObject);
begin
     SignalGenerator1.SamplingFrequency := 1024;
     SignalGenerator1.Length := 1024;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Vectorized signal generator allows generatation of very complex signals ' +
            'in real time and needs only a small fraction of time required by the best function evaluators. ' +
            'The generator uses postfix notation. (HP style). ' +
            'It has a wide range of built-in functions and it is easy to connect ' +
            'them to form processing chains. Press on the Generator button to ' +
            'get to know the editor. For the start just select different functions ' +
            'from the template menu.');
        

     end;
     SpectrumAnalyzer.Pull;
end;

procedure TGeneratorDemoForm.Panel2Resize(Sender: TObject);
begin
     SpectrumChart.Height := Trunc(Panel2.Height/1.8);
end;

procedure TGeneratorDemoForm.ToolButton1Click(Sender: TObject);
begin
     ChartEditor1.Execute;
end;

procedure TGeneratorDemoForm.GeneratorButtonClick(Sender: TObject);
begin
     SignalGeneratorDialog1.Execute;

end;

procedure TGeneratorDemoForm.SignalGenerator1ParameterUpdate(
  Sender: TObject);
begin
     SpectrumAnalyzer.Pull;
end;

procedure TGeneratorDemoForm.ToolButton2Click(Sender: TObject);
var n,i: integer;
begin
     SaveDialog.Filter := FileSignal.SignalDialogFilter;
     if SaveDialog.Execute then
     begin
         SignalWrite.FileName := SaveDialog.FileName;
         if SignalWrite.FileFormat = ffWav then SignalWrite.Precision := prSmallInt;
         N := StrToInt(InputBox('Define file length', 'Samples count', '100000'));
         SignalGenerator1.Sounds.Template[0].Continuous := True;
         for i := 0 to (N div SignalGenerator1.Length)-1 do SignalWrite.Pull;
         SignalGenerator1.Update;
         SignalGenerator1.Data.Resize(N mod SignalGenerator1.Length);
         SignalWrite.Update;
         SignalWrite.CloseFile;
         SignalGenerator1.Data.Length := 1024;
     end;
end;

initialization
RegisterClass(TGeneratorDemoForm);

end.
