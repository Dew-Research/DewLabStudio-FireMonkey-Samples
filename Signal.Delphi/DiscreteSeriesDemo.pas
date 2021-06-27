unit DiscreteSeriesDemo;

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
  Fmx.StdCtrls,
  FMX.Header,
  SignalUtils, FMXTee.Editor.EditorPanel, FMXTee.Engine, FMXTee.Series,
  SignalSeriesTee, FMXTee.Procs, FMXTee.Chart, SignalToolsTee, FMX.Layouts,
  FMX.Memo, FMX.Edit, FmxMtxComCtrls, MtxExpr, FMX.Controls.Presentation;


type
  TDiscreteSeriesDemoForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SignalChart1: TSignalChart;
    Series1: TSignalDiscreteSeries;
    StepEdit: TMtxFloatEdit;
    Label1: TLabel;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StepEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DiscreteSeriesDemoForm: TDiscreteSeriesDemoForm;

implementation

uses Math387, MtxVec, FmxMtxVecTee;

{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.FMX}
{$ENDIF}

procedure TDiscreteSeriesDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TDiscreteSeriesDemoForm.FormCreate(Sender: TObject);
begin
    StepEditChange(Sender); 
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('A new chart series for drawing discrete signals. The example below ' +
          'shows an oversampled FIR filter.');
    end;
end;

procedure TDiscreteSeriesDemoForm.StepEditChange(Sender: TObject);
var H: Vector;
    Step: TSample;
begin
    H.Size(0);
    Step := StepEdit.FloatPosition;
    FractionalFirImpulse(30,H,[0.2,0.25],0,Step,ftLowpass,1);
    SignalChart1.Series[0].Clear;
    DrawValues(H,SignalChart1.Series[0],0,Step);
end;

initialization
RegisterClass(TDiscreteSeriesDemoForm);

end.
