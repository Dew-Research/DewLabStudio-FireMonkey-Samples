unit PhaseDemo;

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
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,

  SignalSeriesTee,
  SignalToolsTee,

  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Procs, FMXTee.Chart,
  FmxMtxComCtrls,
  MtxExpr,
  SignalUtils, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox;

type
  TPhaseDemoForm = class(TForm)
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
    Label2: TLabel;
    ZeroPaddEdit: TMtxFloatEdit;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StepEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PhaseDemoForm: TPhaseDemoForm;

implementation

uses Math387, MtxVec, FmxMtxVecTee, FmxMtxVecEdit, AbstractMtxVec;

{$R *.FMX}

procedure TPhaseDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TPhaseDemoForm.FormCreate(Sender: TObject);
begin
    StepEditChange(Sender); 
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('The package also provides phase unwrapping algorithm. The example below ' +
          'shows the phase of a lowpass FIR filter. In the passband, the linear ' +
          'phase is clearly visible. The success of phase unwrapping stronly ' +
          'depends upon the level of zero padding.');
    end;
end;

procedure TPhaseDemoForm.StepEditChange(Sender: TObject);
var H,Resp,Amplt,Phase: Vector;
    ActualZeropadding: TSample;
begin
    Resp.Size(0);
    Amplt.Size(0);
    H.Length := StepEdit.IntPosition;
    FirImpulse(H,[0.25,0.28],ftLowpass);
    ActualZeroPadding := FrequencyResponse(H,nil,Resp,Trunc(Exp2(ZeroPaddEdit.IntPosition)));
    Phase.PhaseSpectrum(Resp);
    Phase := Phase*(180/Pi);
    PhaseUnwrap(Phase,Amplt,rpConstPhase,ActualZeroPadding*H.Length/(h.Length-1),false,180);
    SignalChart1.Series[0].Clear;
    DrawValues(Amplt,SignalChart1.Series[0]);
end;

initialization
RegisterClass(TPhaseDemoForm);

end.
