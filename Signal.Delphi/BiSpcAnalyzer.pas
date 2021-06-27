unit BiSpcAnalyzer;

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
  MtxVec, SignalToolsDialogs, FMX.Menus, SignalAnalysis, SignalTools,
  FileSignal, FMXTee.Editor.EditorPanel, MtxDialogs, MtxBaseComp, FMXTee.Tools,
  FMXTee.Engine, SignalToolsTee, FMXTee.Series, FMXTee.Procs, FMXTee.Chart,
  FMX.Edit, FmxMtxComCtrls, FMXTee.Store, FMX.Controls.Presentation;


type
  TBiSpcAnalyzerForm = class(TForm)
    EditPanel: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    SignalRead1: TSignalRead;
    FrequencyEdit: TMtxFloatEdit;
    FrequencyLabel: TLabel;                               
    Panel2: TPanel;                                        
    SpectrumChart: TSpectrumChart;
    Series1: TFastLineSeries;
    Series2: TPointSeries;
    ChartTool1: TAxisScaleTool;
    Splitter1: TSplitter;
    SpectrumChart1: TSpectrumChart;
    FastLineSeries1: TFastLineSeries;
    PointSeries1: TPointSeries;
    AxisScaleTool1: TAxisScaleTool;
    ChartTool2: TSpectrumMarkTool;
    ProgressLabel: TLabel;
    OptionsButton: TButton;
    WindowEditMenu: TPopupMenu;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SaveConfig: TMenuItem;
    LoadConfig: TMenuItem;
    N1: TMenuItem;
    Copy1: TMenuItem;
    N2: TMenuItem;
    Openfile1: TMenuItem;
    ToolButton1: TButton;
    Recalculate1: TMenuItem;
    BiSpectrumAnalyzerDialog: TBiSpectrumAnalyzerDialog;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    BiSpectrumAnalyzer: TBiSpectrumAnalyzer;
    ChartTool3: TSpectrumMarkTool;
    ChartTool4: TColorLineTool;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure Openfile1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure SaveConfigClick(Sender: TObject);
    procedure LoadConfigClick(Sender: TObject);
    procedure BiSpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure Recalculate1Click(Sender: TObject);
    procedure FrequencyEditChange(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure OptionsButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BiSpcAnalyzerForm: TBiSpcAnalyzerForm;

implementation

{$R *.FMX}

uses FmxMtxVecEdit, FmxMtxVecTee, SignalUtils, Math387, MtxVecUtils, Basic1 ;

procedure TBiSpcAnalyzerForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TBiSpcAnalyzerForm.OptionsButtonClick(Sender: TObject);
var aPoint: TPointF;
begin
    aPoint := ClientToScreen(EditPanel.Position.Point + OptionsButton.Position.Point);
    WindowEditMenu.Popup(aPoint.X, aPoint.Y);
end;

procedure TBiSpcAnalyzerForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TBiSpcAnalyzerForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TBiSpcAnalyzerForm.FormCreate(Sender: TObject);
begin
     SignalRead1.FileName := GetFile1('bz.sfs');

     BispectrumAnalyzer.Amplt.SetZero;
     FrequencyEditChange(Sender);
end;


procedure TBiSpcAnalyzerForm.Panel2Resize(Sender: TObject);
begin
      SpectrumChart1.Height := Panel2.Height / 2;
end;

procedure TBiSpcAnalyzerForm.Openfile1Click(Sender: TObject);
begin
     OpenDialog.Filter := FileSignal.SignalDialogFilter;
     if OpenDialog.Execute then
     begin
          SignalRead1.FileName := OpenDialog.FileName;
          SignalRead1.OpenFile;
     end;
end;

procedure TBiSpcAnalyzerForm.ToolButton1Click(Sender: TObject);
begin
     BispectrumAnalyzerDialog.Execute;
end;

procedure TBiSpcAnalyzerForm.SaveConfigClick(Sender: TObject);
var a: TFileStream;
begin
     SaveDialog.Filter := 'Config files (*.cfg)|*.cfg';
     if SaveDialog.Execute then
     begin
          a := TFileStream.Create(SaveDialog.FileName, fmOpenWrite or fmCreate);
          try
//               MtxSaveChartToStream(TCustomChart(SpectrumChart),a);
//               MtxSaveChartToStream(TCustomChart(SpectrumChart1),a);
               SaveChartToStream(TCustomChart(SpectrumChart),a);
               SaveChartToStream(TCustomChart(SpectrumChart1),a);
               SpectrumAnalyzer.SaveTemplateToStream(a);
               BiSpectrumAnalyzer.SaveTemplateToStream(a);               
          finally
               a.Free;
          end;
     end
end;

procedure TBiSpcAnalyzerForm.LoadConfigClick(Sender: TObject);
var a: TFileStream;
    CustomChart: TCustomChart;
begin
     OpenDialog.Filter := 'Config files (*.cfg)|*.cfg';
     if OpenDialog.Execute then
     begin
          a := TFileStream.Create(OpenDialog.FileName, fmOpenRead);
          try
//               MtxLoadChartFromStream(TCustomChart(SpectrumChart),a);
//               MtxLoadChartFromStream(TCustomChart(SpectrumChart1),a);
               CustomChart := TCustomChart(SpectrumChart);
               LoadChartFromStream(CustomChart,a);
               CustomChart := TCustomChart(SpectrumChart1);
               LoadChartFromStream(CustomChart,a);
               SpectrumAnalyzer.LoadTemplateFromStream(a);
               BiSpectrumAnalyzer.LoadTemplateFromStream(a);
               SpectrumChart.Spectrums[0].Input := SpectrumAnalyzer;
               SpectrumChart1.Spectrums[0].Input := BiSpectrumAnalyzer;
          finally
               a.Free;
          end;
     end;
end;

procedure TBiSpcAnalyzerForm.BiSpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
    TColorLineTool(SpectrumChart.Tools[2]).Value := BispectrumAnalyzer.BiAnalyzer.Frequency;
    BispectrumAnalyzer.UpdateSpectrum;
end;

procedure TBiSpcAnalyzerForm.Recalculate1Click(Sender: TObject);
begin
//     Screen.Cursor := crHourGlass;
     SetHourGlassCursor;
     try
         SignalRead1.Length := 1024;
         SignalRead1.RecordPosition := 0;
         Signalread1.LastFrameCheck := lfcLastFullBlock;
         SignalRead1.OverlappingPercent := 0;
         //just make sure that the processing does not take too long
         SignalRead1.SelectionStart := 0;
         SignalRead1.SelectionStop := 50000;
         SpectrumAnalyzer.Update;
         BispectrumAnalyzer.ResetAveraging;
         while (BispectrumAnalyzer.Pull <> pipeEnd) do  // do averaging
         begin
              ProgressLabel.Text := 'Progress: ' + FormatSample('0',SignalRead1.FrameNumber/SignalRead1.MaxFrames*100) + ' [%]';
//              Update;
         end;
         BispectrumAnalyzer.BiAnalyzer.Update; //compute bicoherence
         BispectrumAnalyzer.UpdateSpectrum;
     finally
         ResetCursor;
//         Screen.Cursor := crDefault;
     end;
end;

procedure TBiSpcAnalyzerForm.FrequencyEditChange(Sender: TObject);
begin
    BispectrumAnalyzer.BiAnalyzer.Frequency := FrequencyEdit.FloatPosition;
    BiSpectrumAnalyzerParameterUpdate(Sender);
end;

procedure TBiSpcAnalyzerForm.Copy1Click(Sender: TObject);
begin
     TSpectrumMarkTool(SpectrumChart1.Tools[1]).CursorActive := False;
     SpectrumChart1.CopyToClipboardMetafile(True,RectF(0,0,750,400));
     TSpectrumMarkTool(SpectrumChart1.Tools[1]).CursorActive := True;
end;

initialization
RegisterClass(TBiSpcAnalyzerForm);

end.
