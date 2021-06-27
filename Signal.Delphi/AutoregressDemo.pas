unit AutoregressDemo;

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
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  FMXTee.Procs,
  FMXTee.Engine,
  FMXTee.Chart,
  FMXTee.Editor.Chart,
  FMXTee.Editor.EditorPanel,
  FMXTee.Series,
  SignalToolsTee,
  SignalToolsDialogs,
  FmxSpectrumAna,
  MtxBaseComp,
  SignalTools,
  SignalAnalysis,
  FileSignal,
  MtxDialogs, FMX.Layouts, FMX.ScrollBox, FMX.Controls.Presentation;





type                                                             
  TAutoRegressDemoForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;                              
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    SignalRead1: TSignalRead;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure FillSeries;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoRegressDemoForm: TAutoRegressDemoForm;

implementation

{$R *.FMX}

uses SignalUtils, MtxVec, Basic1;

procedure TAutoRegressDemoForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TAutoRegressDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TAutoRegressDemoForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TAutoRegressDemoForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

     SignalRead1.OpenFile;
     SignalRead1.RecordPosition := 0; //moves to the start and loads Length samples

     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Different frequency estimation methods have different success estimating frequency spectrum .' +
            'Press the spectrum button to modify the parameters ' +
            'for the first series. Press the chart button and move the series ' +
            'of your choice to the first place so that it can be modified '+
            'with the spectrum analyzer dialog. Autoregressive methods are affected ' +
            'by the AROrder paramter and FFT is affected by the Window parameter. All ' +
            'methods are affected by the "Zero padding".');

     end;
     FillSeries;
end;

procedure TAutoRegressDemoForm.FillSeries;
var i: integer;
begin
     SpectrumAnalyzer.Window := wtHanning;
     SpectrumAnalyzer.ZeroPadding := 8;
     SpectrumAnalyzer.Logarithmic := True;
     SpectrumAnalyzer.LogType := ltRelative;
     SpectrumAnalyzer.AROrder := 180; //guess
     for i := 0 to 4 do
     begin
         SpectrumChart.AddSeries(TFastLineSeries.Create(SpectrumChart));
         SpectrumChart.SeriesList.Exchange(0,SpectrumChart.SeriesList.Count-1);
         SpectrumAnalyzer.Method := TSpectrumMethod(i);
         SpectrumChart.Series[0].Title := SpectrumMethodToString(SpectrumAnalyzer.Method);
         SpectrumChart.Spectrums[0].Series := SpectrumChart.Series[0];
         SpectrumAnalyzer.Pull;
     end;
{     SpectrumChart.Series[0].Color := clRed;
     SpectrumChart.Series[1].Color := clGreen;
     SpectrumChart.Series[2].Color := clPurple;
     SpectrumChart.Series[3].Color := clBlack;
     SpectrumChart.Series[4].Color := clBlue;}
     SpectrumChart.Legend.Visible := True;
end;


initialization
RegisterClass(TAutoRegressDemoForm);

end.
