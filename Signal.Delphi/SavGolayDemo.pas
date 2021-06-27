unit SavGolayDemo;

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
  FMX.Memo,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  SignalTools,
  FileSignal,

  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs,
  FMXTee.Chart,

  SignalToolsTee,
  MtxDialogs,
  SignalToolsDialogs,
  MtxBaseComp,
  SignalAnalysis,
  FmxMtxComCtrls,
  FMXSpectrumAna, FMX.Controls.Presentation, FMX.ScrollBox;


type
  TSavGolayDemoForm = class(TForm)
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
    Label1: TLabel;                                  
    FrameSizeEdit: TMtxFloatEdit;
    Label2: TLabel;
    OrderEdit: TMtxFloatEdit;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpectrumAnalyzerAfterUpdate(Sender: TObject);
    procedure FrameSizeEditChange(Sender: TObject);
    procedure OrderEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SavGolayDemoForm: TSavGolayDemoForm;

implementation

uses Math387, SignalUtils, MtxVec, Basic1;

{$R *.FMX}

procedure TSavGolayDemoForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TSavGolayDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TSavGolayDemoForm.SpectrumAnalyzerParameterUpdate(
  Sender: TObject);
begin
    SpectrumAnalyzer.Update; 
end;

procedure TSavGolayDemoForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

    SignalRead1.OpenFile;
    SpectrumAnalyzer.Pull;
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('Savitzky-golay filter is a polynomial smoothing FIR filter. In the example ' +
          'below it is applied to the logarithmic frequency spectrum. ' +
          'Change the frame size and the order of the polynomial. The frame ' +
          'size must be odd and order can not be bigger then frame size. ' +
          'Set both parameters to zero to see the raw spectrum.');
      
      
    end;
end;

procedure TSavGolayDemoForm.SpectrumAnalyzerAfterUpdate(Sender: TObject);
var H,D: TMtx;
    Frs,Ord: integer;
begin
     CreateIt(H,D);
     try
         Frs := FrameSizeEdit.IntPosition;
         if not Odd(Frs) then Inc(Frs);
         Ord := OrderEdit.IntPosition;
         SavGolayImpulse(H,D,Frs,Ord,nil);
         SavGolayFilter(SpectrumAnalyzer.Amplt,H);
     finally
         FreeIt(H,D);
     end;
end;

procedure TSavGolayDemoForm.FrameSizeEditChange(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TSavGolayDemoForm.OrderEditChange(Sender: TObject);
begin

     SpectrumAnalyzer.Update;
end;

initialization
RegisterClass(TSavGolayDemoForm);

end.
