unit CoherenceTest2;

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
  Fmx.StdCtrls,
  FMX.Header,
  SignalUtils, FMX.Menus, MtxDialogs, SignalToolsDialogs, SignalTools,
  SignalAnalysis, MtxBaseComp, FileSignal, FMXTee.Editor.EditorPanel,
  FMX.ListBox, FMXTee.Engine, SignalToolsTee, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMXTee.Store;

type
  TCoherenceTest2Form = class(TForm)
    SpectrumChart: TSpectrumChart;
    EditPanel: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    Series1: TFastLineSeries;
    ChartTool1: TAxisScaleTool;                              
    Series2: TPointSeries;
    SignalRead1: TSignalRead;
    PhaseBox: TCheckBox;
    EditSpectrumButton: TButton;
    CrossSpectrumAnalyzerDialog: TCrossSpectrumAnalyzerDialog;
    CrossAnalyzer: TCrossSpectrumAnalyzer;
    UpdateButton: TButton;
    OptionsButton: TButton;
    OpenDialog: TOpenDialog;
    SignalRead2: TSignalRead;
    SamplesBox: TComboBox;
    Label2: TLabel;
    ProgressLabel: TLabel;
    PopupMenu1: TPopupMenu;
    Openfile1: TMenuItem;
    OpenFile2: TMenuItem;
    N1: TMenuItem;
    Copychart: TMenuItem;
    Saveconfiguration: TMenuItem;
    Loadconfiguration: TMenuItem;
    N2: TMenuItem;
    SaveDialog: TSaveDialog;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpectrumBoxChange(Sender: TObject);
    procedure PhaseBoxClick(Sender: TObject);
    procedure EditSpectrumButtonClick(Sender: TObject);
    procedure CrossAnalyzerParameterUpdate(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure SamplesBoxChange(Sender: TObject);
    procedure CopychartClick(Sender: TObject);
    procedure SaveconfigurationClick(Sender: TObject);
    procedure OpenFile2Click(Sender: TObject);
    procedure Openfile1Click(Sender: TObject);
    procedure LoadconfigurationClick(Sender: TObject);
    procedure OptionsButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CoherenceTest2Form: TCoherenceTest2Form;

implementation

{$R *.FMX}

uses MtxVec, Math387, FmxMtxVecTee;


procedure TCoherenceTest2Form.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TCoherenceTest2Form.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     CrossAnalyzer.Update;
end;

procedure TCoherenceTest2Form.OptionsButtonClick(Sender: TObject);
var aPoint: TPointF;
begin
    aPoint := ClientToScreen(EditPanel.Position.Point + OptionsButton.Position.Point);
    PopupMenu1.Popup(aPoint.X, aPoint.Y);
end;

procedure TCoherenceTest2Form.FormCreate(Sender: TObject);
begin
     OpenDialog.Filter := FileSignal.SignalDialogFilter;
     SamplesBox.ItemIndex := 10;
     SamplesBoxChange(Sender);
end;

procedure TCoherenceTest2Form.SpectrumBoxChange(Sender: TObject);
begin
//     SpectrumChart.Title.Text.Clear;
//     SpectrumChart.Title.Text.Add(CrossTransformToString(CrossAnalyzer.CrossAnalyzer.Transform));
     CrossAnalyzer.UpdateSpectrum;
end;

procedure TCoherenceTest2Form.PhaseBoxClick(Sender: TObject);
begin
     SpectrumChart.SpectrumPart := TSpectrumPart(PhaseBox.IsChecked);
     Case SpectrumChart.SpectrumPart of
     sppAmplt: SpectrumChart.LeftAxis.Title.Caption := 'Amplitude';
     sppPhase: SpectrumChart.LeftAxis.Title.Caption := 'Phase [degress]';
     end;
end;

procedure TCoherenceTest2Form.EditSpectrumButtonClick(Sender: TObject);
begin
     CrossSpectrumAnalyzerDialog.Execute;
end;

procedure TCoherenceTest2Form.CrossAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumChart.SpectrumPart := TSpectrumPart(PhaseBox.IsChecked);
//     SpectrumChart.Title.Text.Clear;
//     SpectrumChart.Title.Text.Add(CrossTransformToString(CrossAnalyzer.CrossAnalyzer.Transform));
     CrossAnalyzer.UpdateSpectrum;
end;

procedure TCoherenceTest2Form.UpdateButtonClick(Sender: TObject);
begin
     SignalRead1.SelectionStart := 0;
     SignalRead2.SelectionStart := 0;
     SignalRead1.OverlappingPercent := 90;
     SignalRead2.OverlappingPercent := 90;
     SignalRead1.LastFrameCheck := lfcLastFullBlock; //because of averaging
     SignalRead2.LastFrameCheck := lfcLastFullBlock; //because of averaging

     SignalRead1.SelectionStop := SignalRead1.RecordLength;
     SignalRead1.RecordPosition := 0;
     SignalRead2.RecordPosition := 0;
     CrossAnalyzer.Input := SignalRead1;
     CrossAnalyzer.Output := SignalRead2;
     CrossAnalyzer.CrossAnalyzer.Recursive := false;
     CrossAnalyzer.ResetAveraging;
     while (CrossAnalyzer.Pull <> pipeEnd) do
     begin
          ProgressLabel.Text := 'Progress: ' + FormatSample('0',SignalRead1.RecordPosition/SignalRead1.SelectionStop*100) + ' [%]';
//          Self.Update;
     end;
     CrossAnalyzer.CrossAnalyzer.Update;  //if recursive would be True, this would not be neccessary.
     SpectrumBoxChange(Sender);
end;

procedure TCoherenceTest2Form.SamplesBoxChange(Sender: TObject);
begin
     SignalRead1.Length := StrToInt(SamplesBox.Selected.Text);
     SignalRead2.Length := StrToInt(SamplesBox.Selected.Text);
end;


procedure TCoherenceTest2Form.CopychartClick(Sender: TObject);
var bTemp: boolean;
begin
     btemp := TSpectrumMarkTool(SpectrumChart.Tools[1]).CursorActive;
     TSpectrumMarkTool(SpectrumChart.Tools[1]).CursorActive := False;
     SpectrumChart.CopyToClipboardMetafile(True, RectF(0,0,750,350));
     TSpectrumMarkTool(SpectrumChart.Tools[1]).CursorActive := btemp;
end;

procedure TCoherenceTest2Form.SaveconfigurationClick(Sender: TObject);
var a: TFileStream;
begin
     SaveDialog.Filter := 'Config files (*.cfg)|*.cfg';
     if SaveDialog.Execute then
     begin
          a := TFileStream.Create(SaveDialog.FileName, fmOpenWrite or fmCreate);     
          try
//               MtxSaveChartToStream(TCustomChart(SpectrumChart),a);
               SaveChartToStream(TCustomChart(SpectrumChart),a);
               CrossAnalyzer.SaveTemplateToStream(a);
          finally
               a.Free;
          end;
     end
end;

procedure TCoherenceTest2Form.OpenFile2Click(Sender: TObject);
begin
     OpenDialog.Filter := FileSignal.SignalDialogFilter;
     if OpenDialog.Execute then
     begin
           SignalRead2.FileName := OpenDialog.FileName;
           SignalRead2.OpenFile;
     end;
end;

procedure TCoherenceTest2Form.Openfile1Click(Sender: TObject);
begin
     OpenDialog.Filter := FileSignal.SignalDialogFilter;
     if OpenDialog.Execute then
     begin
          SignalRead1.FileName := OpenDialog.FileName;
          SignalRead1.OpenFile;
     end;
end;

procedure TCoherenceTest2Form.LoadconfigurationClick(Sender: TObject);
var a: TFileStream;
    b: TCustomChart;
begin
   OpenDialog.Filter := 'Config files (*.cfg)|*.cfg';
   if OpenDialog.Execute then
   begin
        a := TFileStream.Create(OpenDialog.FileName, fmOpenRead);
        try
//               MtxLoadChartFromStream(TCustomChart(SpectrumChart),a);
             b := TCustomChart(SpectrumChart);
             LoadChartFromStream(b,a);
             CrossAnalyzer.LoadTemplateFromStream(a);
             SpectrumChart.Spectrums[0].Input := CrossAnalyzer;
        finally
             a.Free;
        end;
   end;
end;

initialization
RegisterClass(TCoherenceTest2Form);

end.

