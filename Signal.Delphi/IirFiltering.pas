unit IirFiltering;

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
  Fmx.StdCtrls,
  FMX.Header,
  Math387,
  MtxExpr, FMXTee.Editor.EditorPanel, MtxDialogs, SignalToolsDialogs,
  MtxBaseComp, SignalTools, SignalAnalysis, FMX.Layouts, FMX.Memo, FMX.Edit,
  FmxMtxComCtrls, FMXTee.Engine, SignalToolsTee, FMXTee.Procs, FMXTee.Chart, FMXTee.Series,
  FMX.Controls.Presentation;


type
  TIirFilteringForm = class(TForm)                          
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
    OrderEdit: TMtxFloatEdit;                      
    Label1: TLabel;
    Label2: TLabel;
    AttEdit: TMtxFloatEdit;
    Label3: TLabel;
    FreqEdit: TMtxFloatEdit;                               
    procedure SpectrumEditButtonClick(Sender: TObject);
    procedure ChartEditButtonClick(Sender: TObject);
    procedure SpectrumAnalyzerParameterUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OrderEditChange(Sender: TObject);
    procedure FreqEditChange(Sender: TObject);
  private
    procedure FillSeries(Order,Att: integer; Freq: TSample);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IirFilteringForm: TIirFilteringForm;

implementation

{$R *.FMX}

uses SignalUtils, MtxVec, IIRFilters;

procedure TIirFilteringForm.SpectrumEditButtonClick(Sender: TObject);
begin
     SpectrumAnalyzerDialog.Execute;
end;

procedure TIirFilteringForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TIirFilteringForm.SpectrumAnalyzerParameterUpdate(Sender: TObject);
begin
     SpectrumAnalyzer.Update;
end;

procedure TIirFilteringForm.FormCreate(Sender: TObject);
var i: integer;
begin
     for i := 0 to 3 do SpectrumChart.AddSeries(TFastLineSeries.Create(SpectrumChart));
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('DSP for MtxVec features 4 different filter design methods for infinite impulse response filters: ' +
            'Butterworth, Chebyshev type I and type II and elliptic filters. Change the order and attenuation ' +
            'in the stop band of a low-pass IIR filter designed with all 4 methods.');

        
     end;
     FillSeries(5,40,0.1);
end;

procedure TIirFilteringForm.FillSeries(Order,Att: integer; Freq: TSample);
var i: integer;
    num,den: Vector;
begin
     SpectrumAnalyzer.Window := wtRectangular;
     SpectrumAnalyzer.Logarithmic := True;
     SpectrumAnalyzer.LogSpan := ls200;
     SpectrumAnalyzer.ZeroPadding := 128;

     num.Size(0);
     den.Size(0);
     for i := 0 to 3 do
     begin
         SpectrumChart.Spectrums[0].Series := SpectrumChart.Series[i];
         SpectrumChart.Series[i].Title := IIrFilterMethodToString(TIirFilterMethod(i));
         case TIirFilterMethod(i) of
         fimButter:      ButterFilter(Order,[Freq],ftLowPass,false,num,den);
         fimChebyshevI:  ChebyshevIFilter(Order,0.1,[Freq],ftLowPass,false,num,den);
         fimChebyshevII: ChebyshevIIFilter(Order,Att,[Freq],ftLowPass,false,num,den);
         fimElliptic:    EllipticFilter(Order,0.1,Att,[Freq],ftLowPass,false,num,den);
         end;
{            Alternative:

         FrequencyResponse(num,den,h,64);
         h.Abs;
         H.Log10;
         H.Scale(-20);
         DrawIt(h);}

         SpectrumAnalyzer.Process(num,den,nil,nil); //place result in self
     end;
     SpectrumChart.Legend.Visible := True;
end;

procedure TIirFilteringForm.OrderEditChange(Sender: TObject);
begin
     FillSeries(OrderEdit.IntPosition,AttEdit.IntPosition,FreqEdit.FloatPosition);
end;


procedure TIirFilteringForm.FreqEditChange(Sender: TObject);
begin

     FillSeries(OrderEdit.IntPosition,AttEdit.IntPosition, FreqEdit.FloatPosition);
end;

initialization
RegisterClass(TIirFilteringForm);

end.
