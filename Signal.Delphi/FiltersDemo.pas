unit FiltersDemo;

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
  FMX.Layouts,
  FMX.Memo,
  FMX.Header,

  SignalToolsDialogs, SignalProcessing, SignalTools,
  MtxDialogs, MtxBaseComp, SignalAnalysis,
  SignalSeriesTee, SignalToolsTee,

  FMXTee.Editor.Series.Pointer,
  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs,
  FMXTee.Chart, FMX.ScrollBox, FMX.Controls.Presentation ;


type
  TFiltersDemoForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;                            
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    Signal1: TSignal;
    Panel2: TPanel;
    SpectrumChart: TSpectrumChart;
    Series1: TFastLineSeries;
    Series2: TPointSeries;
    Splitter1: TSplitter;
    SignalChart: TSignalChart;
    ToolButton1: TButton;                            
    ChartEditor1: TChartEditor;
    ChartTool1: TAxisScaleTool;
    FilterButton: TButton;
    SignalFilterDialog1: TSignalFilterDialog;
    Signal2: TSignal;
    Series3: TSignalDiscreteSeries;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    SignalFilter1: TSignalFilter;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure FilterButtonClick(Sender: TObject);
    procedure SignalFilter1ParameterUpdate(Sender: TObject);
    procedure SignalFilter1AfterUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FiltersDemoForm: TFiltersDemoForm;

implementation

uses SignalUtils, Math387, MtxVec, AbstractMtxVec;  //TeePoEdi is for TeeChart TPointSeries editor

{$R *.FMX}

procedure TFiltersDemoForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TFiltersDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TFiltersDemoForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TFiltersDemoForm.FormCreate(Sender: TObject);
begin
     Signal1.UsesInputs := false;
     Signal1.Length := 4096;
     Signal1.Data.SetZero();
     Signal1[0] := Signal1.Length div 2;
     SpectrumAnalyzer.PhaseMode := pm360;
     SpectrumAnalyzer.Pull;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('A filter designer component is available. Click on the Filter editor ' +
            'in the example below to display a filter design window. The TSignalFilter ' +
            'component can be used to design almost any filter that comes with ' +
            'the package and provides a convinient user interface. The component ' +
            'can also be used for on-line filtering. All filter setups ' +
            'can be saved on disk as templates.');
        
        
     end;
end;

procedure TFiltersDemoForm.Panel2Resize(Sender: TObject);
begin
     SpectrumChart.Height := Trunc(Panel2.Height/1.8);
end;

procedure TFiltersDemoForm.ToolButton1Click(Sender: TObject);
begin
     ChartEditor1.Execute;
end;

procedure TFiltersDemoForm.FilterButtonClick(Sender: TObject);
begin
     SignalFilterDialog1.Execute;
end;

procedure TFiltersDemoForm.SignalFilter1ParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Pull;
end;

procedure TFiltersDemoForm.SignalFilter1AfterUpdate(Sender: TObject);
begin
     Signal2.Data.Copy(SignalFilter1.Taps);
     //In Delphi 4 and 5 this might cause floating point overflow message
     //when trying to draw axis labels.
     Signal2.UpdateNotify;
end;

initialization
RegisterClass(TFiltersDemoForm);

end.
