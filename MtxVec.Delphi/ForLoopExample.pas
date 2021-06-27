unit ForLoopExample;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMXTee.Chart,
  FMXTee.Procs,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.RadioGroup,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Math387,
  MtxForLoop,
  MtxVec, MtxExpr, FMX.Types,
  FMX.Controls, FMX.Dialogs,
  PlatformHelpers, FMX.Controls.Presentation;

type
  TForLoopExampleForm = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    MultiThreadedBox: TCheckBox;
    Button2: TButton;
    Panel2: TPanel;
    Chart: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Chart1: TChart;
    FastLineSeries1: TFastLineSeries;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
  private
    procedure OnComputationEnded2(Sender: TObject);
    procedure MyLoop3(LoopIndex: integer; const Context: TObjectArray; ThreadIndex: integer);
    { Private declarations }
  public
    { Public declarations }
    TimingResults: array of array of double;
  end;

  TExecuteThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  ForLoopExampleForm: TForLoopExampleForm;

implementation

uses FmxMtxVecEdit, AbstractMtxVec;
var  ForLoop: TMtxForLoop;

{$R *.FMX}

procedure TForLoopExampleForm.FormCreate(Sender: TObject);
begin
    forLoop := TMtxForLoop.Create;
    ForLoopExampleForm := Self;
end;

procedure TForLoopExampleForm.FormDestroy(Sender: TObject);
begin
    forLoop.Free;
end;

procedure TForLoopExampleForm.Timer1Timer(Sender: TObject);
begin
    if Assigned(forLoop) then
    begin
        Label1.Text := 'Loop running time: ' + FormatSample(ForLoop.LoopRunningTime,'0.0') + 'ms';
    end;
end;

procedure TForLoopExampleForm.OnComputationEnded2(Sender: TObject);
var i, j, Len: integer;
begin
    if ForLoop.HasRaisedErrors then ShowMessage('Exceptions raised within threads: ' + ForLoop.ErrorMessages);

    for j := 0 to Length(TimingResults) - 1 do
    begin
        Len := 8;
        Chart.Series[j].Clear;
        for i := 0 to length(TimingResults[j])-1 do
        begin
            Chart.Series[j].AddXY(Len,TimingResults[j,i]);
            Len := 2*Len;
        end;
    end;

    Chart1.Series[0].Clear;
    Len := 8;
    for i := 0 to length(TimingResults[0])-1 do
    begin
        Chart1.Series[0].AddXY(Len,TimingResults[0,i]/TimingResults[1,i]);
        Len := 2*Len;
    end;

    ResetCursor;
end;

procedure TForLoopExampleForm.Panel2Resize(Sender: TObject);
begin
    Chart.Height := (Panel2.Height - Panel1.Height) / 2;
    Chart1.Height := (Panel2.Height - Panel1.Height) / 2;
end;

function TestFunction(const x,m,b: TVec): Vector;
var xm: Vector;
begin
     xm.Adopt(x); { convert to Vector to allow use of expressions }
     Result := 0.5*(1.0+ sgn(xm-m)*(1.0-Exp(-Abs(xm-m)/b)));
end;

procedure TForLoopExampleForm.MyLoop3(LoopIndex: integer; const Context: TObjectArray; ThreadIndex: integer);
var k, LoopCount: integer;
    aResult: TVecList;
    c: Vector;
begin
    aResult := TVecList(Context[3]);
    LoopCount := (1024 * 32) div TVec(Context[0]).Length; { adjust loopcount to match number of elements for each run }

    for k := 0 to LoopCount-1 do { do loop to make some work for the CPU }
    begin
        c := TestFunction(TVec(Context[0]),TVec(Context[1]),TVec(Context[2]));
      {  c := 0.5*(1.0+ sgn(x-m)*(1.0-Exp(-Abs(x-m)/b))); }
    end;
    aResult[LoopIndex].Copy(c); { use loopIndex, to indicate that all results should be distinct for each iteration. }
end;

procedure TForLoopExampleForm.Button2Click(Sender: TObject);
var aThread: TThread;    { needed only to allow monitoring of execution }
begin
    if not ForLoop.IsProcessingIdle then Exit;

    SetHourGlassCursor;

    if MultiThreadedBox.IsChecked then ForLoop.ThreadCount := Controller.CpuCores
                                  else ForLoop.ThreadCount := 1;

//    Controller.ThreadWaitBeforeSleep := 10;

    aThread := TExecuteThread.Create(true);
    aThread.FreeOnTerminate := True;
    aThread.OnTerminate := OnComputationEnded2;
    aThread.Suspended := false;
end;

{ TExecuteThread2 }

procedure TExecuteThread.Execute;
var x,b,m: Vector;
    Results: TVecList;
    vecLen: integer;
    i, LoopCount, TestIdx: Integer;
begin
    LoopCount := 10;
    SetLength(ForLoopExampleForm.TimingResults, 2);
    SetLength(ForLoopExampleForm.TimingResults[0], LoopCount);
    SetLength(ForLoopExampleForm.TimingResults[1], LoopCount);

    Controller.SuperConductive := false;
    for TestIdx := 0 to 1 do
    begin
        VecLen := 8;
        for i := 0 to LoopCount - 1 do
        begin
            x.Size(VecLen);
            x.Ramp;
            b.Size(x);
            b.SetVal(1);
            m.Size(x);
            m.Ramp(0.5,1);

            Results := TVecList.Create;
            Results.Count := 501;
            DoForLoop(0,500, ForLoopExampleForm.MyLoop3, forLoop, [TVec(x),TVec(m),TVec(b),Results]);  //blocking calls
            Results.Free; { just forget the results in this case }

            ForLoopExampleForm.TimingResults[TestIdx,i] := forLoop.LoopRunningTime;
            vecLen := vecLen*2;
        end;
        Controller.SuperConductive := true;
    end;
end;

initialization
 RegisterClass(TForLoopExampleForm);

end.
