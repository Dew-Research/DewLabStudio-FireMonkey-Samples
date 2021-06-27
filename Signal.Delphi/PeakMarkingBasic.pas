unit PeakMarkingBasic;

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
  SignalToolsDialogs, MtxBaseComp, SignalAnalysis, FMXTee.Engine,
  SignalToolsTee, FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.Layouts,
  FMX.Memo, FMX.ListBox, FMX.ScrollBox, FMX.Controls.Presentation;

type
  TPeakMarkingBasicForm = class(TForm)
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
    PhaseBox: TCheckBox;
    SpectrumAnalyzer: TSpectrumAnalyzer;               
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure PhaseBoxChange(Sender: TObject);
  private
    function GetMarkTool: TSpectrumMarkTool;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PeakMarkingBasicForm: TPeakMarkingBasicForm;

implementation

uses Math387, Basic1;

{$R *.FMX}

procedure TPeakMarkingBasicForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TPeakMarkingBasicForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TPeakMarkingBasicForm.SpectrumAnalyzerParameterUpdate(
  Sender: TObject);
begin
    SpectrumAnalyzer.Update;
end;

procedure TPeakMarkingBasicForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

    SignalRead1.OpenFile;
    ComboBox1.ItemIndex := 0;
    SpectrumAnalyzer.Pull;
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;

      Add('Test peak marking features:');
      Add('');
      Add('Move the mouse and click the left mouse button to mark a peak.');
      Add('Click with the left mouse button already marked peak once more to delete the mark.');
      Add('Double click with left mouse button to clear all marked peaks.');
      Add('Zoom-in the frequency spectrum by dragging a rectangle with the left mouse button.');
      Add('Pan the frequency spectrum by dragging with the right mouse button.');
      Add('Change the Mark mode edit box on the bottom of the the chart to Harmonics ' +
          'and move the mouse.');
      Add('Change the Mark mode edit box on the bottom of the the chart to Sidebands ' +
          'and mark two peaks. Modulation sidebands will be marked.');


    end;
end;

function TPeakMarkingBasicForm.GetMarkTool: TSpectrumMarkTool;
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

procedure TPeakMarkingBasicForm.ComboBox1Change(Sender: TObject);
begin
     GetMarkTool.MarkMode := TSpectrumMarkMode(ComboBox1.ItemIndex);
end;

procedure TPeakMarkingBasicForm.PhaseBoxChange(Sender: TObject);
begin
     SpectrumChart.SpectrumPart := TSpectrumPart(PhaseBox.IsChecked);

     Case SpectrumChart.SpectrumPart of
     sppAmplt: SpectrumChart.LeftAxis.Title.Caption := 'Amplitude';
     sppPhase: SpectrumChart.LeftAxis.Title.Caption := 'Phase [degress]';
     end;
end;

initialization
RegisterClass(TPeakMarkingBasicForm);

end.
