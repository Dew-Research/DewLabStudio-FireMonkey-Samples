unit PeakFiltering;

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
  FMX.Header,
  FMX.Memo,
  FMX.ListBox,
  FMX.Layouts,
  FMXTee.Procs,
  FMXTee.Editor.Chart,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Chart,
  FMXTee.Editor.EditorPanel,
  FMXTee.Tools,
  SignalToolsTee,
  SignalTools,
  FileSignal,
  SignalAnalysis,
  SignalToolsDialogs,
  MtxDialogs,
  MtxBaseComp,
  FmxSpectrumAna,
  MtxExpr, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;

type
  TPeakFilteringForm = class(TForm)
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
    CheckBox1: TCheckBox;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    ComboBox1: TComboBox;
    Label1: TLabel;                                 
    Signal1: TSignal;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Signal1AfterUpdate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private
    function GetAxisScaleTool: TAxisScaleTool;
    function GetMarkTool: TSpectrumMarkTool;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PeakFilteringForm: TPeakFilteringForm;

implementation

uses SignalUtils, MtxVec, Math387, Basic1, AbstractMtxVec;

{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.FMX}
{$ENDIF}

procedure TPeakFilteringForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TPeakFilteringForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TPeakFilteringForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TPeakFilteringForm.FormCreate(Sender: TObject);
begin
      SignalRead1.FileName := GetFile1('bz.sfs');

     SignalRead1.OpenFile;
     ComboBox1.ItemIndex := 0;
     SpectrumAnalyzer.Pull;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('   Mark a peak to filter it from the signal:');
        Add('');


        Add('   *   The "filter" computes Amplitude and Phase from the frequency spectrum '+
            'and then subtracts a single sine from the time series. The frequency spectrum '+
            'is then recalculated.');
        Add('   *   There are two data sets to chose from and it is possible to switch between ' +
            'logarithmic and linear axis.');
        
        
    end;
end;

procedure TPeakFilteringForm.CheckBox1Change(Sender: TObject);
begin
     SpectrumAnalyzer.Logarithmic := CheckBox1.IsChecked;
     SpectrumAnalyzer.Update;
end;

function TPeakFilteringForm.GetAxisScaleTool: TAxisScaleTool;
var i: integer;
begin
     Result := nil;
     for i := 0 to SPectrumChart.Tools.Count-1 do
     begin
          if SPectrumChart.Tools[i] is TAxisScaleTool then
          begin
               Result := TAxisScaleTool(SpectrumChart.Tools[i]);
               Break;
          end;
     end;
     if Result = nil then ERaise('Axis scale tool not found!');
end;

function TPeakFilteringForm.GetMarkTool: TSpectrumMarkTool;
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

procedure TPeakFilteringForm.ComboBox1Change(Sender: TObject);
begin
     Signal1.UsesInputs := false;  //indicate there is nothing connected to it
     SignalRead1.RecordPosition := 0; //reset the file position.
     case ComboBox1.ItemIndex of
     0: SpectrumAnalyzer.Input := SignalRead1;
     1: SpectrumAnalyzer.Input := Signal1;
     end;
     //Peak hold must be reset because its two different sets of data.
     GetAxisScaleTool.Reset;
     GetMarkTool.ClearMarks;
     //end peak hold reset
     SpectrumAnalyzer.Pull;
end;

procedure TPeakFilteringForm.Signal1AfterUpdate(Sender: TObject);
var ToneState: TToneState;
    a: Vector;  //generate two sine signal
begin
     a.Size(1024);
     ToneInit(0.1,0,1,ToneState);
     Tone(a,ToneState);
     Signal1.Data.Copy(a);
     ToneInit(0.12,0,1,ToneState);
     Tone(a,ToneState);
     Signal1.Data.Add(a);
end;

initialization
RegisterClass(TPeakFilteringForm);

end.
