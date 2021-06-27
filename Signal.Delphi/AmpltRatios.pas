unit AmpltRatios;

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
  Fmx.StdCtrls,
  FMX.Header, SignalTools, FileSignal, FMXTee.Editor.EditorPanel, MtxDialogs,
  SignalToolsDialogs, MtxBaseComp, SignalAnalysis, FMX.Layouts, FMX.Memo,
  FMX.ListBox, FMXTee.Engine, SignalToolsTee, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;

type
  TAmpltRatiosForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    Series1: TFastLineSeries;
    RichEdit1: TMemo;                                    
    ChartTool1: TAxisScaleTool;
    Series2: TPointSeries;
    SignalRead1: TSignalRead;
    ComboBox1: TComboBox;
    Label1: TLabel;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpectrumChartAfterMarkPeak(Sender: TObject);
  private
    function GetMarkTool: TSpectrumMarkTool;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AmpltRatiosForm: TAmpltRatiosForm;

implementation

uses Math387, Basic1;

{$R *.FMX}


procedure TAmpltRatiosForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TAmpltRatiosForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TAmpltRatiosForm.SpectrumAnalyzerParameterUpdate(
  Sender: TObject);
begin
    SpectrumAnalyzer.Update;
end;

procedure TAmpltRatiosForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

    SignalRead1.OpenFile;
    ComboBox1.ItemIndex := 0; 
    SpectrumAnalyzer.Pull;
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('In the example below ' +
          'you can examine the amplitude ratios between different frequency peaks. The first peak ' +
          'clicked will become 1.');
    end;
end;

function TAmpltRatiosForm.GetMarkTool: TSpectrumMarkTool;
var i: integer;
begin
     Result := nil;
     for i := 0 to SPectrumChart.Tools.Count-1 do
     begin
          if SPectrumChart.Tools[i] is TSpectrumMarkTool then
          begin
               Result := TSpectrumMarkTool(SpectrumChart.Tools[i]);
               Break;
          end;
     end;
     if Result = nil then ERaise('Spectrum mark tool not found!');
end;

procedure TAmpltRatiosForm.ComboBox1Change(Sender: TObject);
begin
     GetMarkTool.MarkMode := TSpectrumMarkMode(ComboBox1.ItemIndex);
end;

procedure TAmpltRatiosForm.SpectrumChartAfterMarkPeak(Sender: TObject);
begin
     if SpectrumAnalyzer.Peaks.List.Count = 1 then
     begin
          SpectrumAnalyzer.ScaleFactor := SpectrumAnalyzer.ScaleFactor/SpectrumAnalyzer.Peaks[0].Amplt;
          SpectrumAnalyzer.Update;
     end;
end;

initialization
RegisterClass(TAmpltRatiosForm);

end.
