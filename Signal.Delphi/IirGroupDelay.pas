unit IirGroupDelay;

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
  FMXTee.Editor.EditorPanel,
  FMX.Layouts, FMX.Memo, FMX.Edit,
  FmxMtxComCtrls,
  FMXTee.Engine,
  SignalToolsTee,
  FMXTee.Procs,
  FMXTee.Chart,
  FMXTee.Series,
  MtxExpr, FMX.Controls.Presentation;

type
  TIirGroupDelayForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    ChartTool1: TAxisScaleTool;
    OrderEdit: TMtxFloatEdit;
    Label1: TLabel;
    Label2: TLabel;
    AttEdit: TMtxFloatEdit;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OrderEditChange(Sender: TObject);
  private
    procedure FillSeries(Order,Att: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IirGroupDelayForm: TIirGroupDelayForm;

implementation

{$R *.FMX}

uses SignalUtils, MtxVec, IIRFilters, FmxMtxVecTee, Math387;


procedure TIirGroupDelayForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TIirGroupDelayForm.FormCreate(Sender: TObject);
var i: integer;
begin
     for i := 0 to 3 do SpectrumChart.AddSeries(TFastLineSeries.Create(SpectrumChart));
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Group delay of IIR filters. Group delay is the first ' +
            'derivate of the continuous phase. Change the filter parameters ' +
            'and observer what happens to the group delay!')
     end;
     FillSeries(5,40);
end;

procedure TIirGroupDelayForm.FillSeries(Order,Att: integer);
var i: integer;
    num,den,h: Vector;
begin
     num.Size(0);
     den.Size(0);
     h.Size(0);
     for i := 0 to 3 do
     begin
         SpectrumChart.SeriesList.Move(0,3);
         SpectrumChart.Series[0].Title := IIrFilterMethodToString(TIirFilterMethod(i));
         case TIirFilterMethod(i) of
         fimButter:      ButterFilter(Order,[0.2],ftLowPass,false,num,den);
         fimChebyshevI:  ChebyshevIFilter(Order,0.1,[0.2],ftLowPass,false,num,den);
         fimChebyshevII: ChebyshevIIFilter(Order,Att,[0.2],ftLowPass,false,num,den);
         fimElliptic:    EllipticFilter(Order,0.1,Att,[0.2],ftLowPass,false,num,den);
         end;
         GroupDelay(h,Num,Den,128);
         h.SetSubRange(0,Trunc(0.95*h.Length)); //problems on the right edge
         DrawValues(h,SpectrumChart.Series[0],0,0.95*0.5/h.Length);
         h.SetFullRange;
     end;
end;

procedure TIirGroupDelayForm.OrderEditChange(Sender: TObject);
begin
     FillSeries(OrderEdit.IntPosition,AttEdit.IntPosition);
end;

initialization
RegisterClass(TIirGroupDelayForm);

end.
