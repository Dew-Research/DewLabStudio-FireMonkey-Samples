unit SuperConductive;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.SyncObjs,
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
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  MtxBaseComp, MtxDialogs, MtxExpr, FmxMtxComCtrls, Math387, MtxForLoop,
  MtxVecBase, MtxVec, AbstractMtxVec, FMX.Controls.Presentation;



type

  TTestMethod = (tmGetMem, tmTVec, tmVector, tmVectorGlobal);

  TSuperConductiveForm = class(TForm)
    Panel1: TPanel;
    Label41: TLabel;
    Label31: TLabel;
    Bevel1: TPanel;
    FullRunButton: TButton;
    MultithreadBox: TCheckBox;
    VectorLenEdit: TMtxFloatEdit;
    TestBox: TComboBox;
    SuperConductiveMMBox: TCheckBox;
    Chart: TChart;
    Button2: TButton;
    AllocsLabel: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FullRunButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    TimeStart: array of Int64;
    TimedThread: array of double;
    FTestMethod: TTestMethod;
    procedure SetTestMethod(const Value: TTestMethod);
    procedure ForLoopFun(LoopIndex: integer; const Context: TObjectArray;
      ThreadIndex: integer);
    procedure GetMemFreeMem;
    procedure VectorUnmanaged(threadIndex: integer);
    procedure VectorUnmanagedGlobal(threadIndex: integer);
    procedure CreateItFreeIt;
  public
    Timings: array of array of double;
//    Threads: array of TMtxProgressDialog;
    ak,ac: integer;
    CacheIndex1, CacheIndex2: integer;
    { Public declarations }
    av,bv,cv,dv: array of Vector;
    VectorLen: integer;
    property TestMethod: TTestMethod read FTestMethod write SetTestMethod;
  end;

var
  SuperConductiveForm: TSuperConductiveForm;

implementation

uses StringVar;

{$R *.FMX}

procedure TSuperConductiveForm.FullRunButtonClick(Sender: TObject);
var i,j, k, loopCount: Integer;
    aSeries: TChartSeries;
    threadDim: StringList;
begin
    threadDim.Add('Single threaded');
    threadDim.Add('Multi-threaded, standard');
    threadDim.Add('Multi-threaded, super-conductive ');

    VectorLen := VectorLenEdit.IntPosition;
    loopCount := 120000000 div VectorLen;

    for j := 0 to TestBox.Items.Count - 1 do
    begin
        TestMethod := TTestMethod(j);

        for i := 0 to ThreadDim.Count-1 do
        begin
            for k := 0 to Length(av) - 1 do
            begin
                av[k] := dv[k];
                bv[k] := dv[k];
                cv[k] := dv[k];
            end;

            case i of
            0: begin //single threaded
               StartTimer;
               for k := 0 to LoopCount-1 do ForLoopFun(k, [], 0);
               Timings[j, i] := StopTimer;
               end;
            1: begin //multi-threaded, standard memory manager
               Controller.SuperConductive := False; // ThreadDimension := 1;
               StartTimer;
               DoForLoop(0, LoopCount-1, ForLoopFun, GlobalThreads, []);
               Timings[j, i] := StopTimer*Controller.CpuCores;
               end;
            2: begin   //multi-threaded, super conducting
               Controller.SuperConductive := True; //Controller.ThreadDimension := 4;
               StartTimer;
               DoForLoop(0, LoopCount-1, ForLoopFun, GlobalThreads, []);
               Timings[j, i] := StopTimer*Controller.CpuCores;
               end;
            end;
        end;
    end;

    for j := 0 to TestBox.Items.Count - 1 do
    begin
        if Chart.SeriesCount <= j then
        begin
            aSeries := Chart.AddSeries(TBarSeries);
            TBarSeries(aSeries).Marks.Visible := false;
            aSeries.Title := TestBox.Items[j];
        end else aSeries := Chart.Series[j];

        aSeries.Clear;
        for i := 0 to ThreadDim.Count-1 do
        begin
            aSeries.AddY(loopCount/Timings[j,i]/1E6,ThreadDim[i]);
        end;
    end;

    AllocsLabel.Text := 'Thread count = ' + IntTostr(Controller.CpuCores);
end;

procedure TSuperConductiveForm.Button2Click(Sender: TObject);
var i, k, LoopCount: integer;
begin
    MtxVec.Controller.Pool[1].Vec.DebugReport;

    TestMethod := TTestMethod(TestBox.ItemIndex);
    VectorLen := VectorLenEdit.IntPosition;
    LoopCount := 120000000 div VectorLen;

    for i := 0 to Length(av) - 1 do
    begin
        av[i] := dv[i];
        bv[i] := dv[i];
        cv[i] := dv[i];
    end;

    Controller.SuperConductive := SuperConductiveMMBox.IsChecked;

    if MultithreadBox.IsChecked then
    begin
        StartTimer;
        DoForLoop(0, LoopCount-1, ForLoopFun, GlobalThreads, []);
        AllocsLabel.Text := 'Bandwidth = ' + FormatSample('0.00',LoopCount/(StopTimer*Controller.CpuCores)/1E6) + ' MAllocs/s/thread';
    end else
    begin
        StartTimer;
        for k := 0 to LoopCount-1 do ForLoopFun(k, [], 0);
        AllocsLabel.Text := 'Bandwidth = ' + FormatSample('0.00',LoopCount/StopTimer/1E6) + ' MAllocs/s/thread';
    end;


    for i := 0 to Length(MtxVec.Controller.Pool)-1 do
    begin
        if MtxVec.Controller.Pool[i].Vec.CacheUsedCount > 0 then
            ShowMessage('MtxVec.Controller.Pool[' + IntToStr(i) + '].Vec.CacheUsed = ' + IntToStr(MtxVec.Controller.Pool[i].Vec.CacheUsedCount));
    end;
end;

procedure TSuperConductiveForm.FormCreate(Sender: TObject);
var cpuCores: integer;
begin
    GlobalThreads := TMtxForLoop.Create;

    TestBox.ItemIndex := 0;
    cpuCores := Controller.CpuCores;

    SetLength(Timings, cpuCores, TestBox.Items.Count);

    SetLength(av, cpuCores);
    SetLength(bv, Length(av));
    SetLength(cv, Length(av));
    SetLength(dv, Length(av));
    SetLength(TimeStart, cpuCores);
end;

procedure TSuperConductiveForm.FormDestroy(Sender: TObject);
begin
    GlobalThreads.Free;
end;

procedure TSuperConductiveForm.SetTestMethod(const Value: TTestMethod);
begin
  FTestMethod := Value;
end;

procedure TSuperConductiveForm.GetMemFreeMem;
var ByteLen: integer;
     ap, bp, cp: PByte;
begin
    ByteLen := VectorLen*sizeof(TSample);
    GetMem(ap,ByteLen);
    GetMem(bp,ByteLen);
    GetMem(cp,ByteLen);
    FreeMem(ap);
    FreeMem(bp);
    FreeMem(cp);
end;

procedure TSuperConductiveForm.CreateItFreeIt;
var av1,bv1,cv1: TVec;
begin
    CreateIt(av1,bv1,cv1);

    av1.Size(VectorLen);
    bv1.Size(VectorLen);
    cv1.Size(VectorLen);

    FreeIt(av1,bv1,cv1);
end;

procedure TSuperConductiveForm.VectorUnmanaged(threadIndex: integer);
var a,b,c: Vector;
begin
    a.Size(VectorLen);
    b.Size(VectorLen);
    c.Size(VectorLen);

//    a := dv[threadIndex]; //free
//    b := dv[threadIndex]; //free
//    c := dv[threadIndex]; //free
end;

procedure TSuperConductiveForm.VectorUnmanagedGlobal(threadIndex: integer);
begin
    av[threadIndex].Size(VectorLen);
    bv[threadIndex].Size(VectorLen);
    cv[threadIndex].Size(VectorLen);

    av[threadIndex] := dv[threadIndex]; //free the memory
    bv[threadIndex] := dv[threadIndex];
    cv[threadIndex] := dv[threadIndex];
end;

procedure TSuperConductiveForm.ForLoopFun(LoopIndex: integer; const Context: TObjectArray; ThreadIndex: integer);
begin
    case TestMethod of
    tmGetMem: GetMemFreeMem;
    tmTVec:   CreateItFreeIt;
    tmVector: VectorUnmanaged(ThreadIndex);
    tmVectorGlobal: VectorUnmanagedGlobal(ThreadIndex);
    end;
end;

{ TThread2 }

initialization
   RegisterClass(TSuperConductiveForm);

end.
