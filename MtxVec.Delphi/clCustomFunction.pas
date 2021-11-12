unit clCustomFunction;

interface

{$I bdsppdefs.inc}

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Header, Math387, MtxForLoop, OpenCL_Dynamic, clMtxVec,  AbstractMtxVec,
  FMX.Memo, FMX.ListBox,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Dialogs, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;

type
  TclCustomFunctionForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Button1: TButton;
    PlatformListBox: TListBox;
    DeviceListBox: TListBox;
    VectorLengthBox: TComboBox;
    RichEdit1: TMemo;
    AutoDeviceButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PlatformListBoxClick(Sender: TObject);
    procedure AutoDeviceButtonClick(Sender: TObject);
  private
    { Private declarations }
    SelectedDevice: TOpenCLDevice;
    procedure DoCompute;
    procedure CreateCustom;
    procedure LoadTest(Sender: TObject);
  public
    { Public declarations }
  end;

var
  clCustomFunctionForm: TclCustomFunctionForm;
  VectorLen :integer;

implementation

uses FmxMtxVecEdit, MtxVec,  StringVar, MtxExpr, clMtxExpr, ZLib, MtxVecInt, PlatformHelpers;

{$R *.FMX}

procedure TclCustomFunctionForm.CreateCustom; { compile custom function }
var SourceCode: stringList;
    aBinFileName: string;
    aProgram: TOpenCLProgram;
begin
    if selectedDevice.Programs.Count > 1 then selectedDevice.Programs.Delete(1);
    aProgram := selectedDevice.Programs.Add;

    SourceCode.Add('__kernel void vec_sin_f (__global const float *a, const int aIdx,');
    SourceCode.Add('  	               __global const float *b, const int bIdx,      ');
    SourceCode.Add('		       	     __global float *c, const int cIdx,              ');
    SourceCode.Add('                             const int Length)                   ');
    SourceCode.Add('{                                                                ');
    SourceCode.Add('	size_t i = get_global_id(0);                                   ');
    SourceCode.Add('                                                                 ');
    SourceCode.Add('	c[i + cIdx] = sin(a[i + aIdx]) + b[i + bIdx];                  ');
    SourceCode.Add('                                                                 ');
    SourceCode.Add('}                                                                ');

    aBinFileName := aProgram.BinaryFileName('MySource.cl'); { give a unique and descriptive name }
    aProgram.LoadProgram(aBinFileName, SourceCode, '', '', true); { always rebuild source }
end;

function vec_sin_f(a, b: TOpenCLVector): clVector;
var aKernel: TOpenCLKernel;
begin
    if a.Length <> b.Length then raise Exception.Create('a.Length <> b.Length');
    Result.Size(a);

    aKernel := a.Device.Kernels.Locate('vec_sin_f');
    aKernel.SetArgBuffer(0, a.SData);
    aKernel.SetArgInt32(1, a.SDataIndex(0)); { SDataIndex typically does not return 0 (!!) }
    aKernel.SetArgBuffer(2, b.SData);
    aKernel.SetArgInt32(3, b.SDataIndex(0)); { SDataIndex typically does not return 0 (!!) }
    aKernel.SetArgBuffer(4, TOpenCLVector(Result).SData);
    aKernel.SetArgInt32(5, TOpenCLVector(Result).SDataIndex(0)); { SDataIndex typically does not return 0 (!!) }
    aKernel.SetArgInt32(6, a.Length);

    aKernel.Enqueue(a.CmdQueue, a.Length, false); { auto local work size and no CPU adjust }
end;

procedure TclCustomFunctionForm.DoCompute;
var B,C, A, R: Vector;
    clB, clC, clA: clVector;
begin
    case clC.FloatPrecision of
    clFloat: A.Size(VectorLen, mvSingle);
    clDouble: A.Size(VectorLen, mvDouble);
    end;

    A.SetVal(2);

    B.Size(A);
    B.SetVal(1);

    clA.Copy(A);
    clB.Copy(B);
    clC := vec_sin_f(clA, clB);  { call custom function here }
    c := sin(A) + b;

    clC.CopyTo(R);

    if not C.IsEqual(R, 1E-4) then ERaise('Not equal') else ShowMessage('Function works!');
end;

procedure TclCustomFunctionForm.Button1Click(Sender: TObject);
begin
    if VectorLengthBox.ItemIndex >= 0 then
        VectorLen := StrToInt(VectorLengthBox.Items[VectorLengthBox.ItemIndex]);

    clPlatform.UnmarkThreads;
    selectedDevice := clPlatform[PlatformListBox.ItemIndex].Device[DeviceListBox.ItemIndex];
    SelectedDevice.Cache.SetCacheSize(50, Round(VectorLen), 50, 50);
    SelectedDevice.CommandQueue[0].MarkThread; { UserThread := GetCurrentThreadID; }

    CreateCustom;
    DoCompute;
end;

procedure TclCustomFunctionForm.FormCreate(Sender: TObject);
var i, k, kernelSum: Integer;
begin
    With RichEdit1.Lines do
    begin
      Clear;
      Add('The platform list shows the Open CL drivers  '
        + 'available on your computer. Note that GPU device speed is sensitive '
        + 'to vector lengths which are not divisable by 4. ');
      Add('Press run to execute the custom function on the selected platform.');
    end;

    if clPlatform.Count = 0 then Exit;

    for i := 0 to clPlatform.Count - 1 do
         PlatformListBox.Items.Add(clPlatform[i].Name);

    PlatformListBox.ItemIndex := 0;

    for i := 0 to clPlatform[0].Count - 1 do
         DeviceListBox.Items.Add(clPlatform[0].Device[i].Name);

    DeviceListBox.ItemIndex := 0;

    kernelSum := 0;
    for i := 0 to clPlatform.Count-1 do
    begin
        for k := 0 to clPlatform[i].Count-1 do
        begin
            kernelSum := kernelSum + clPlatform[i].Device[k].Kernels.Count;
        end;
    end;

    if kernelSum = 0 then
    begin
        { load default kernels }
        ShowMessage('When loading the first time, the Open CL drivers need to compile new kernels.'
                  + 'This may take a minutes.');
        SetHourGlassCursor;
        clPlatform.LoadProgramsForDevices(false, false, true, false, false);
        ResetCursor;
    end;

    VectorLen := Round(Exp2(19));
    VectorLengthBox.ItemIndex := VectorLengthBox.Items.IndexOf(IntToStr(VectorLen));
end;

procedure TclCustomFunctionForm.PlatformListBoxClick(Sender: TObject);
var i: integer;
    DeviceList: StringList;
begin
    for i := 0 to clPlatform[PlatformListBox.ItemIndex].Count - 1 do
         DeviceList.Add(clPlatform[PlatformListBox.ItemIndex].Device[i].Name);

    DeviceListBox.Items.Assign(TStringList(DeviceList));
    DeviceListBox.ItemIndex := 0;
end;

procedure TclCustomFunctionForm.AutoDeviceButtonClick(Sender: TObject);
var aDevice: TOpenCLDevice;
begin
   if VectorLengthBox.ItemIndex >= 0 then
       VectorLen := StrToInt(VectorLengthBox.Items[VectorLengthBox.ItemIndex]);

   SetHourGlassCursor;

   aDevice := clPlatform.AutoDeviceSelect(LoadTest, 10, VectorLen);

   PlatformListBox.ItemIndex := aDevice.PlatformIndex;
   PlatformListBoxClick(nil);
   DeviceListBox.ItemIndex := aDevice.DeviceIndex;

   ResetCursor;
end;

procedure TclCustomFunctionForm.LoadTest(Sender: TObject);
var clB, clC, clA: clVector;
    i: integer;
begin
    clA.Size(VectorLen, clFloat, false);
    clA.SetVal(1);

    clB.Size(VectorLen, clFloat, false);
    clB.SetVal(2);

    for i := 0 to 300 do
        clC := sin(clA) + clB;

    TOpenCLVector(clC).Finish;
end;

initialization
   RegisterClass(TclCustomFunctionForm);

end.
