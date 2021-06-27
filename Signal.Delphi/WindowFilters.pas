unit WindowFilters;

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
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,

  FMXTee.Procs,
  FMXTee.Engine,
  FMXTee.Chart,
  FMXTee.Editor.EditorPanel,
  FMXTee.Series,

  SignalToolsTee,
  SignalToolsDialogs,
  FmxSpectrumAna,
  SignalTools,
  SignalAnalysis,
  FileSignal,
  MtxDialogs,
  MtxBaseComp,
  FmxMtxComCtrls,
  Math387,
  MtxExpr, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;

type
  TWindowFiltersForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    SpectrumEditButton: TButton;
    ChartEditButton: TButton;
    SpectrumAnalyzerDialog: TSpectrumAnalyzerDialog;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    FreqEdit: TMtxFloatEdit;
    Label1: TLabel;
    Label2: TLabel;
    TransEdit: TMtxFloatEdit;
    Label3: TLabel;                                     
    FilterLengthEdit: TMtxFloatEdit;
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FreqEditChange(Sender: TObject);
  private
    procedure FillSeries(Freq,Att: TSample; Length: integer);
    { Private declarations }
  public
    { Public declarations }
    destructor Destroy; override;
  end;

var
  WindowFiltersForm: TWindowFiltersForm;

implementation

{$R *.FMX}

uses SignalUtils, MtxVec;

procedure TWindowFiltersForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TWindowFiltersForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TWindowFiltersForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TWindowFiltersForm.FormCreate(Sender: TObject);
begin
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Change the length of the filter to see how the width the transition bandwidth changes. ' +
            'The attenuation in dB applies only to Kaiser in Chebyshev windows. Cutoff frequency '+
            'defines the start of the attenuation.');
        
        
     end;
     FillSeries(0.2,40,128);
end;

destructor TWindowFiltersForm.Destroy;
begin
  if Controller.Pool[0].Vec.CacheUsedCount > 0 then ShowMessage('Vec.CacheUsed = ' + IntToStr(Controller.Pool[0].Vec.CacheUsedCount));
  inherited;
end;

procedure TWindowFiltersForm.FillSeries(Freq,Att:TSample; Length: integer);
var i: integer;
    H: Vector;
begin
     SpectrumAnalyzer.Window := wtRectangular;
     SpectrumAnalyzer.Logarithmic := True;
     SpectrumAnalyzer.ZeroPadding := 16;
     SpectrumAnalyzer.LogSpan := ls200;
     if Odd(Length) then Inc(Length);
     h.Length := Length;
     for i := 0 to SpectrumChart.SeriesList.Count-1 do
     begin
        SpectrumChart.Series[0].Free;
//        SpectrumChart.Series.Delete(0);
     end;
     for i := 0 to 10 do
     begin
         SpectrumChart.AddSeries(TFastLineSeries.Create(SpectrumChart));
         SpectrumChart.Spectrums[0].Series := SpectrumChart.Series[i];
         SpectrumChart.Series[i].Title := SignalWindowToString(TSignalWindowType(i));
         case TSignalWindowType(i) of
         wtBlackman: FirImpulse(h,[Freq,Freq+0.05],0.3,ftLowPass, TSignalWindowType(i),h.Length/ 2.0);
         wtKaiser: FirImpulse(h,[Freq,Freq+0.05],KaiserBetaFir(Power(10,-Att/20)),ftLowPass, TSignalWindowType(i), h.Length/ 2.0);
         else FirImpulse(h,[Freq,Freq+0.05],Att,ftLowPass, TSignalWindowType(i), h.Length/ 2.0);
         end;
         SpectrumAnalyzer.Process(h); //no denominator and place result in self, filters have gain of h.Length div 2, to compensate for internet default scaling
     end;
     SpectrumChart.Legend.Visible := True;
end;

procedure TWindowFiltersForm.FreqEditChange(Sender: TObject);
begin
     FillSeries(FreqEdit.FloatPosition,TransEdit.FloatPosition,FilterLengthEdit.IntPosition);
end;

initialization
RegisterClass(TWindowFiltersForm);

end.
