unit ProgDialog;

interface

uses
    System.SysUtils,
    System.Types,
    System.UITypes,
    System.Classes,
    FMX.Types,
    FMX.Controls,
    FMX.Forms,
    FMX.Objects,
    FMX.Grid,
    FMX.ExtCtrls,
    FMX.ListBox,
    FMX.Memo,
    FMX.Layouts,
    FMX.Edit,
    FMX.Platform,
    System.Rtti,
    Fmx.StdCtrls,
    FMX.Header,
    Basic2,
    MtxBaseComp,
    MtxDialogs,
    Optimization,
    FmxMtxComCtrls,
    MtxVec,
    MtxForLoop,
    FMX.Controls.Presentation,
    FMX.ScrollBox,
    FMX.Memo.Types;

type
  TfrmProgDialog = class(TBasicForm2)
    Label1: TLabel;
    ProgressLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;                         
    IteratorGroup: TPanel;
    LoopTypeGroup: TPanel;
    ShowFormBox: TCheckBox;
    ThreadBox: TComboBox;
    StartButton: TButton;
    ProgressBar: TProgressBar;
    UpdateIntervalEdit: TMtxFloatEdit;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MinEdit: TMtxFloatEdit;
    MaxEdit: TMtxFloatEdit;
    MtxThread: TMtxProgressDialog;
    Label7: TLabel;
    Label8: TLabel;
    IteratorButton1: TRadioButton;
    IteratorButton2: TRadioButton;
    IteratorButton3: TRadioButton;
    LoopButton1: TRadioButton;
    LoopButton2: TRadioButton;
    procedure MtxThreadCompute(Sender: TObject);
    procedure MtxThreadProgressUpdate(Sender: TObject;  Event: TMtxProgressEvent);
    procedure MinEditChange(Sender: TObject);
    procedure MaxEditChange(Sender: TObject);
    procedure UpdateIntervalEditChange(Sender: TObject);
    procedure ThreadBoxChange(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IteratorButton1Change(Sender: TObject);
    procedure LoopButton1Change(Sender: TObject);
    procedure ShowFormBoxChange(Sender: TObject);
  private
    IteratorGroupIndex, LoopGroupIndex: integer;
    { Private declarations }
    A,B,C: TMtx;
    procedure WhileLoopInProcedure();

  public
    { Public declarations }
  end;

var
  frmProgDialog: TfrmProgDialog;

implementation

{$R *.FMX}

procedure TfrmProgDialog.ShowFormBoxChange(Sender: TObject);
begin
    MtxThread.ShowDialog := ShowFormBox.IsChecked;
end;
{
Procedure that has been thread:
begin
         CreateIt(A,B,C);
         A.Size(100,100);
         A.RandGauss;
         B.Copy(a);
         for i := 0 to Count-1 do C.Mul(A,B);
         FreeIt(A,B,C);
end;
}

procedure TfrmProgDialog.MtxThreadCompute(Sender: TObject);
var i: integer;
begin
  case IteratorGroupIndex of
    0: C.Mul(a,b);  //Internal loop
    1: for i := MtxThread.Min to MtxThread.Max do
       begin  //external loop,
             MtxThread.Counter := i;
             if MtxThread.Cancel then Break;
             //
             C.Mul(A,B);
       end;
    2: WhileLoopInProcedure();
  end;
end;



procedure TfrmProgDialog.MtxThreadProgressUpdate(Sender: TObject;
  Event: TMtxProgressEvent);
begin
  case Event of
  peInit: begin
            MtxThread.DefineProgressBar(ProgressBar);
            CreateIt(A,B,C);
            A.Size(100,100);
            A.RandGauss;
            B.Copy(a);
          end;
  peCycle:begin
            ProgressBar.Value := MtxThread.Counter;
            ProgressLabel.Text := 'Progress indicator: ' + FormatFloat('0 %',MtxThread.Counter/MtxThread.Max*100);
          end;
  peCleanUp:
          begin
            if not MtxThread.Cancel then
            begin
              ProgressBar.Value := MtxThread.Max;
              ProgressLabel.Text := 'Progress indicator: ' + FormatFloat('0.00',100);
            end;
            StartButton.Text := 'Start';

            FreeIt(A,B,C);
          end;
  end;
end;
procedure TfrmProgDialog.IteratorButton1Change(Sender: TObject);
begin
  if Sender = IteratorButton1 then IteratorGroupIndex := 0;
  if Sender = IteratorButton2 then IteratorGroupIndex := 1;
  if Sender = IteratorButton3 then IteratorGroupIndex := 2;

  case IteratorGroupIndex of
    0:  MtxThread.InternalLoop := True;
    1,2:  MtxThread.InternalLoop := False;
  end;
end;

procedure TfrmProgDialog.LoopButton1Change(Sender: TObject);
begin
  if Sender = LoopButton1 then LoopGroupIndex := 0;
  if Sender = LoopButton2 then LoopGroupIndex := 1;

  case LoopGroupIndex of
    0: MtxThread.InfiniteLoop := False;
    1: MtxThread.InfiniteLoop := True;
  end;
end;

procedure TfrmProgDialog.MinEditChange(Sender: TObject);
begin
  MtxThread.Min := StrToInt(MinEdit.Value);
end;

procedure TfrmProgDialog.MaxEditChange(Sender: TObject);
begin
  MtxThread.Max := StrToInt(MaxEdit.Value);
end;

procedure TfrmProgDialog.UpdateIntervalEditChange(Sender: TObject);
begin
  MtxThread.UpdateInterval := StrToInt(UpdateIntervalEdit.Value);
end;

procedure TfrmProgDialog.ThreadBoxChange(Sender: TObject);
begin
//  MtxThread.ThreadPriority := TThreadPriority(ThreadBox.ItemIndex);
end;

procedure TfrmProgDialog.StartButtonClick(Sender: TObject);
begin
  if StartButton.Text = 'Start' then
  begin
      StartButton.Text := 'Stop';
      MtxThread.Start;
  end else
  begin
      MtxThread.Stop;
  end;
  {Sequence of calls:}

  {
   1. Calls  MtxThread OnProgressUpdate event with peInit
   2. Calls  OnCompute once or more times depending of InternalLoop
   3. Calls  MtxThread OnProgressUpdate event with peCycle in
      regular intervals to advance progress indicators.
   4. Calls MtxThread OnProgressUpdate event with peCleanUp to
      continue with the further processing of the processed data,
      once the the thread has finished.
  }
end;

procedure TfrmProgDialog.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('MtxVec 1.5 introduces new TMtxProgressDialog control. '
      + 'The TMtxProgressDialog component greatly simplifies '
      + 'the threading of numerical algorithms and offers '
      + 'built-in support to cancel the execution of algorithms '
      + 'running in it''s thread, provide information about the '
      + 'progress of the executing numerical algorithm and even '
      + 'display progress dialog showing progress indications '
      + 'updated with user defined update frequency. Component '
      + 'design does not use the Synchronize procedure to update '
      + 'progress indicators and makes the most out of the '
      + 'available CPU power.');
  end;
  ThreadBox.ItemIndex := 3;
  MtxThread.InfiniteLoop := false;
  MtxThread.InternalLoop := True;
  MtxThread.DefineLoop(0,1500);
end;

procedure TfrmProgDialog.WhileLoopInProcedure();
begin
    while not (MtxThread.Max = MtxThread.Counter) do
    begin
        if MtxThread.Cancel then Break;
        C.Mul(A,B);
        MtxThread.Counter := MtxThread.Counter + 1;
    end;
end;

procedure TfrmProgDialog.FormDestroy(Sender: TObject);
begin
  MtxThread.Stop;
  inherited;
end;

initialization
   RegisterClass(TfrmProgDialog);

end.
 
