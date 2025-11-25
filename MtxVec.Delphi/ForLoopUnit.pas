unit ForLoopUnit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Dialogs,
  FMX.Types,
  Basic2,
  MtxVec,
  FmxMtxVecEdit,
  FMX.StdCtrls,
  PlatformHelpers,
  FMX.Controls,
  FMX.Layouts,
  FMX.Memo, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;


type
  TForLoopForm = class(TBasicForm2)
    Button1: TButton;
    Timer: TTimer;
    Label1: TLabel;
    ThreadedBox: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure OnComputationEnded(Sender: TObject);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

  TExecuteThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  ForLoopForm: TForLoopForm;

implementation

uses FmxMtxVecTee, MtxExpr, MtxForLoop, Math387, AbstractMtxVec;

{$R *.FMX}

var B1: Matrix;
    forLoop: TMtxForLoop;

constructor TForLoopForm.Create(AOwner: TComponent);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('Threading a for or while loop can be very easy with MtxVec components. ' +
        'Press the button to see the code execute and then examine the source code by ' +
        'clicking the tab at the bottom of the form. The code automaticaly detects core count ' +
        'and executes at maximum speed. Code example also shows how to monitor the progress of execution.');
  end;

  B1 := Matrix.Create(0,0);
  forLoop := TMtxForLoop.Create;
end;

procedure TForLoopForm.FormDestroy(Sender: TObject);
begin
  forLoop.Free;
end;

procedure TForLoopForm.TimerTimer(Sender: TObject);
begin
    if Assigned(ForLoop) then    
        Label1.Text := 'Loop running time: ' + FormatSample(ForLoop.LoopRunningTime,'0.0') + 'ms';
end;

procedure TForLoopForm.Button1Click(Sender: TObject);
var aThread: TThread;   { needed only to allow monitoring of execution}
begin
    if not ForLoop.IsProcessingFinished then Exit;

    if ThreadedBox.IsChecked then forLoop.ThreadCount := Controller.CpuCores
                             else forLoop.ThreadCount := 1;

    SetHourGlassCursor;
    aThread := TExecuteThread.Create(true);
    aThread.FreeOnTerminate := True;
    aThread.OnTerminate := OnComputationEnded;
    aThread.Suspended := false;
end;

procedure TForLoopForm.OnComputationEnded(Sender: TObject);
begin
    ViewValues(b1);
    if ForLoop.HasRaisedErrors then ShowMessage('Exceptions raised within threads: ' + ForLoop.ErrorMessages);
    ResetCursor;
end;

procedure MyLoop(LoopIndex: integer; const Context: TObjectArray; ThreadIndex: integer);
var j,k: integer;   { threaded function, where every LoopIndex can be called from a different thread }
    a: TMtx;
begin
    a := TMtx(Context[0]);

    for k := 0 to 1000 - 1 do
    begin
        for j := 0 to a.Cols - 1 do
        begin
            a[LoopIndex, j] := a[LoopIndex, j] + 1;
        end;
    end;
end;

{ TExecuteThread }

procedure TExecuteThread.Execute;
var am: Matrix;
begin
    am.Size(1001,100);
    am.SetVal(1);

    DoForLoop(0,1000, MyLoop,  forLoop, [TMtx(am)]);  { blocking call }

    B1.Copy(am); { fetch the Result }
end;

initialization
   RegisterClass(TForLoopForm);

end.
