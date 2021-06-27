unit LissajousScope;

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
  FMX.Memo,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  SignalUtils, MtxExpr,
  SignalTools, AudioSignal,
  MtxBaseComp,
  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Series.Polar, SignalSeriesTee,
  FMXTee.Procs,
  FMXTee.Chart,
  FMX.ListBox, FMX.ScrollBox, FMX.Controls.Presentation;

type
  TLissajousScopeForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartButton: TButton;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    Panel2: TPanel;
    SignalTimer1: TSignalTimer;
    SignalIn1: TSignalIn;
    Signal1: TSignal;
    Label1: TLabel;
    Signal2: TSignal;
    SamplesBox: TComboBox;
    PhaseChart: TChart;
    Series1: TSignalPolarSeries;
    procedure FormCreate(Sender: TObject);
    procedure SignalTimer1Timer(Sender: TObject);
    procedure ChartButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SamplesBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LissajousScopeForm: TLissajousScopeForm;

implementation

uses Math387, MtxVec, OptimalFir, FmxMtxVecTee;

{$R *.FMX}

procedure TLissajousScopeForm.FormCreate(Sender: TObject);
begin
    Signal1.Data.Size(1000);  //defines how much data to copy and consequently also frequency resolution
    Signal1.Data.SetZero;
    Signal1.UsesInputs := false;
    Signal2.Data.Size(1000);  //defines how much data to copy and consequently also frequency resolution
    Signal2.Data.SetZero;
    Signal2.UsesInputs := false;

    SamplesBox.ItemIndex := 1;
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('This example shows the angle of the Left versus Right channel, if Left is on the Y and Right ' +
          'is on the X axis. The coordinates are rotated by 45 degrees counterclockwise. ' +
          'This type of a phase scope is also refered to as Lissajou. ' +
          'if there will be more low frequencies the scope will start showing lines.' +
          'If there will be more high frequencies the dots will be scattered around.' +
          'Vertical line indicates a mono signal. '+
          'Horizontal line indicates that left and right channel are 180 degrees out of phase '+
          '(cancelation). ');
    end;
end;

procedure TLissajousScopeForm.SignalTimer1Timer(Sender: TObject);
var a,Re,Im: Vector;
begin
    Re.Size(0);
    Im.Size(0);

    if not SignalIn1.Active then SignalIn1.Start;
    SignalIn1.MonitorData(Signal1,Signal2);
    a.RealToCplx(Signal2.Data,Signal1.Data);
    a.CartToPolar(Re,Im);
    Im := Im*(180/Pi) + 45; //from radians to degrees //add 45 degrees
    Im := Im*(Pi/180);
    a.PolarToCart(Re, Im);
    a.CplxToReal(Signal2.Data,Signal1.Data);

    PhaseChart.LeftAxis.AutomaticMaximum := false;
    PhaseChart.LeftAxis.Maximum := 32000;
    PhaseChart.RightAxis.AutomaticMaximum := false;
    PhaseChart.RightAxis.Maximum := 32000;
    PhaseChart.BottomAxis.AutomaticMaximum := false;
    PhaseChart.BottomAxis.Maximum := 32000;
    PhaseChart.TopAxis.AutomaticMaximum := false;
    PhaseChart.TopAxis.Maximum := 32000;
//    for i := 0 to Re.Length - 1 do
//      Series1.AddPolar(Im[i], Re[i]);
    DrawValues(Signal2.Data,Signal1.Data,PhaseChart.Series[0]); //angle is x
end;

procedure TLissajousScopeForm.ChartButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TLissajousScopeForm.FormDestroy(Sender: TObject);
begin
     SignalTimer1.Enabled := false;
end;

procedure TLissajousScopeForm.SamplesBoxChange(Sender: TObject);
begin
     Signal1.Data.Length := StrToInt(SamplesBox.Selected.Text);
     Signal2.Data.Length := StrToInt(SamplesBox.Selected.Text);
end;

initialization
RegisterClass(TLissajousScopeForm);

end.
