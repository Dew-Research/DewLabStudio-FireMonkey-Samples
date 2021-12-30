unit BenchmarkFramework;

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
  FMX.Dialogs,
  FMX.Objects,
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,

  BenchmarkResults,
  Math387,
  AbstractMtxVec,
  MtxVec;





type
  TVecMethod = function (const src: TMtxVec): TMtxVec of object;
  TSmplFunc  = function (const x: double): double;
  TSmplFuncCdecl  = function (const x: double): double; cdecl;
  TCplxFunc  = function (const x: TCplx): TCplx;

type
  TFuncInfo = record
    func_name: string;
    smpl_func: TSmplFunc;
    smpl_func_cdecl: TSmplFuncCdecl;
    cplx_func: TCplxFunc;
    vec_method: TVecMethod;
    smpl_val: double;
    cplx_val: TCplx;
  end;

type
  TCalcProc = procedure of object;
  TBenchmarkFramework = class
  private
    fSrc, fDst: TVec;
    fSrca, fDsta: TDoubleArray;
    fSrcac, fDstac: TCplxArray;        
    fIterationCount: integer;
    fVectorLength: integer;

    fFuncs: array of TFuncInfo;
    fFuncCount: integer;
    fSelectedFunc: TFuncInfo;

    procedure InitFuncs;
    function GetFuncCount: integer;
    function GetFuncName(idx: integer): string;
    function FindFuncByName (const func_name: string): integer;
    procedure InitSmplVecs (val: double);
    procedure InitCplxVecs (const cval: TCplx);

    procedure CalcVector;
    procedure CalcSample;
    procedure CalcComplex;

    function DoUnderTimer (calc_proc: TCalcProc): double;

  public
    constructor Create;
    destructor Destroy; override;

    function RecalcIterationCount: integer;

    procedure Run (const func_name: string; var results: TBenchmarkResults);

    property VectorLength: integer read fVectorLength write fVectorLength;
    property IterationCount: integer read fIterationCount write fIterationCount;

    property FuncCount: integer read GetFuncCount;
    property FuncName[idx: integer]: string read GetFuncName;
  end;

implementation


{ TBenchmarksFramework }

constructor TBenchmarkFramework.Create;
begin
  inherited;
  fSrc := TVec.Create;
  fDst := TVec.Create;
  InitFuncs;
end;

destructor TBenchmarkFramework.Destroy;
begin
  fSrc.Free;
  fDst.Free;
  inherited;
end;

function TBenchmarkFramework.FindFuncByName (const func_name: string): integer;
begin
  for Result:= 0 to fFuncCount-1 do
    if SameText (fFuncs[Result].func_name, func_name) then
      Exit;

  raise Exception.CreateFmt ('TBenchmarkFramework.FindFuncByName: Name of function was not found', [func_name]);
end;

//type TMathFunction = function (a: double): double;

function TBenchmarkFramework.GetFuncCount: integer;
begin
  Result:= fFuncCount;
end;

function TBenchmarkFramework.GetFuncName(idx: integer): string;
begin
  Assert (idx < fFuncCount, Format('TBenchmarkFramework.GetFuncName: Index out of range: %d', [idx]));
  Result:= fFuncs[idx].func_name;
end;

procedure TBenchmarkFramework.InitFuncs;
const
  VAL1: double = 0.5;
  CVAL1: TCplx  = (Re:0.5; Im:0.5);


  procedure Add (const func_name: string; smpl_val: double; const cplx_val: TCplx;
                 smpl_func: TSmplFunc; cplx_func: TCplxFunc; vec_method: TVecMethod); overload;
  begin
    if fFuncCount >= Length(fFuncs) then
      SetLength (fFuncs, fFuncCount + 20);

    fFuncs[fFuncCount].func_name:= func_name;
    fFuncs[fFuncCount].smpl_func:= smpl_func;
    fFuncs[fFuncCount].smpl_func_cdecl:= nil;
    fFuncs[fFuncCount].cplx_func:= cplx_func;
    fFuncs[fFuncCount].vec_method:= vec_method;
    fFuncs[fFuncCount].smpl_val:= smpl_val;
    fFuncs[fFuncCount].cplx_val:= cplx_val;

    Inc (fFuncCount);
  end;

  procedure Add (const func_name: string; smpl_val: double; const cplx_val: TCplx;
                 smpl_func: TSmplFuncCdecl; cplx_func: TCplxFunc; vec_method: TVecMethod); overload;
  begin
    if fFuncCount >= Length(fFuncs) then
      SetLength (fFuncs, fFuncCount + 20);

    fFuncs[fFuncCount].func_name:= func_name;
    fFuncs[fFuncCount].smpl_func := nil;
    fFuncs[fFuncCount].smpl_func_cdecl := smpl_func;
    fFuncs[fFuncCount].cplx_func:= cplx_func;
    fFuncs[fFuncCount].vec_method:= vec_method;
    fFuncs[fFuncCount].smpl_val:= smpl_val;
    fFuncs[fFuncCount].cplx_val:= cplx_val;

    Inc (fFuncCount);
  end;

begin
  fFuncCount:= 0;

  {$IFNDEF CPUX64}
  Add ('Sin', VAL1, CVAL1, {$IF Defined(NEXTGEN) and not Defined(OSX)} System {$ELSE} Math387 {$IFEND}.Sin, Math387.Sin, fDst.Sin );
  Add ('Cos', VAL1, CVAL1,  {$IF Defined(NEXTGEN) and not Defined(OSX)} System {$ELSE} Math387 {$IFEND}.Cos, Math387.Cos, fDst.Cos);
  Add ('Exp', VAL1, CVAL1, {$IF Defined(NEXTGEN) and not Defined(OSX)} System {$ELSE}Math387 {$IFEND}.Exp, Math387.Exp, fDst.Exp );
  Add ('Ln', VAL1, CVAL1, {$IF Defined(NEXTGEN) and not Defined(OSX)} System {$ELSE} Math387 {$IFEND}.Ln, Math387.Ln, fDst.Ln );
  Add ('ArcTan', VAL1, CVAL1, {$IF Defined(NEXTGEN) and not Defined(OSX)} System.{$ELSE} Math387 {$IFEND}.ArcTan, Math387.ArcTan, fDst.ArcTan);
  {$ELSE}

  Add ( 'Sin', VAL1, CVAL1, {$IF Defined(D23) and not Defined(OSX) and not Defined(Linux)} System.{$IFEND}Sin, Math387.Sin, fDst.Sin);
  Add ('Cos', VAL1, CVAL1, {$IF Defined(D23) and not Defined(OSX) and not Defined(Linux)} System.{$IFEND}Cos, Math387.Cos, fDst.Cos);
  Add ('Exp', VAL1, CVAL1, {$IF Defined(D23) and not Defined(OSX) and not Defined(Linux)} System.{$IFEND}Exp, Math387.Exp, fDst.Exp);
  Add ('Ln', VAL1, CVAL1,  {$IF Defined(D23) and not Defined(OSX) and not Defined(Linux)} System.{$IFEND}Ln, Math387.Ln, fDst.Ln);
  Add ('ArcTan', VAL1, CVAL1, {$IF Defined(D23) and not Defined(OSX) and not Defined(Linux)} System.{$IFEND}ArcTan, Math387.ArcTan, fDst.ArcTan);

  {$ENDIF}

  Add ('Log10', VAL1, CVAL1, Math387.Log10, Math387.Log10, fDst.Log10);
  Add ('Tan', VAL1, CVAL1, Math387.Tan, Math387.Tan, fDst.Tan);
  Add ('ArcSin', VAL1, CVAL1, Math387.ArcSin, Math387.ArcSin, fDst.ArcSin);
  Add ('ArcCos', VAL1, CVAL1, Math387.ArcCos, Math387.ArcCos, fDst.ArcCos);

  Add ('ArcTanh', VAL1, CVAL1, Math387.ArcTanh, Math387.ArcTanh, fDst.ArcTanh);
  Add ('ArcSinh', VAL1, CVAL1, Math387.ArcSinh, Math387.ArcSinh, fDst.ArcSinh);

//  Add ('ArcCosh', VAL1, CVAL1, Math387.ArcCosh, Math387.ArcCosh, fDst.ArcCosh);

  Add ('Tanh', VAL1, CVAL1, Math387.Tanh, Math387.Tanh, fDst.Tanh);
  Add ('Sinh', VAL1, CVAL1, Math387.Sinh, Math387.Sinh, fDst.Sinh);
  Add ('Cosh', VAL1, CVAL1, Math387.Cosh, Math387.Cosh, fDst.Cosh);

end;

procedure TBenchmarkFramework.InitSmplVecs (val: double);
begin
  fSrc.Size (VectorLength, FALSE);
  fSrc.SetVal (val);
  FSrc.CopyToArray(FSrca);
  fDst.Size (VectorLength, FALSE);
  fDst.SetZero;
  FDst.SizeToArray(FDsta);
end;

procedure TBenchmarkFramework.InitCplxVecs (const cval: TCplx);
begin
  fSrc.Size (VectorLength, TRUE);
  fSrc.SetVal (cval);
  FSrc.CopyToArray(FSrcac);
  fDst.Size (VectorLength, TRUE);
  fDst.SetZero;
  FDst.SizeToArray(FDstac);
end;

procedure TBenchmarkFramework.Run(const func_name: string; var results: TBenchmarkResults);
var
  smpl_vec_ticks, cplx_vec_ticks, smpl_func_ticks, cplx_func_ticks: double;
begin
  fSelectedFunc:= fFuncs[FindFuncByName(func_name)];

  InitSmplVecs (fSelectedFunc.smpl_val);
  smpl_vec_ticks:= DoUnderTimer (CalcVector);

  InitCplxVecs (fSelectedFunc.cplx_val);
  cplx_vec_ticks:= DoUnderTimer (CalcVector);

  InitSmplVecs (fSelectedFunc.smpl_val);
  smpl_func_ticks:= DoUnderTimer (CalcSample);

  InitCplxVecs (fSelectedFunc.cplx_val);
  cplx_func_ticks:= DoUnderTimer (CalcComplex);

  results.Add (func_name, VectorLength, IterationCount,
    smpl_vec_ticks, cplx_vec_ticks, smpl_func_ticks, cplx_func_ticks);
end;

procedure TBenchmarkFramework.CalcVector;
var i: integer;
    vec_method: TVecMethod;
begin
  vec_method:= fSelectedFunc.vec_method;
  for i:= 1 to fIterationCount do
    vec_method(fSrc);
end;

procedure TBenchmarkFramework.CalcSample;
var
  i,j: integer;
  smpl_func: TDoubleFunc;
begin
  smpl_func:= fSelectedFunc.smpl_func;
  if Assigned(smpl_func) then
  begin
      for i:= 1 to fIterationCount do
        for j:= 0 to fDst.Length-1 do
          fDsta[j]:= smpl_func (fSrca[j]);
  end;
end;

procedure TBenchmarkFramework.CalcComplex;
var
  i,j: integer;
  cplx_func: TCplxFunc;
begin
  cplx_func:= fSelectedFunc.cplx_func;
  for i:= 1 to fIterationCount do
    for j:= 0 to fDst.Length-1 do
      fDstac[j]:= cplx_func (fSrcac[j]);
end;

function TBenchmarkFramework.DoUnderTimer(calc_proc: TCalcProc): double;
begin
  StartTimer;
  calc_proc;
  Result:= StopTimer*1000;
end;

function TBenchmarkFramework.RecalcIterationCount: integer;
var
  delta: double;
  a,b: TVec;
  n: integer;
begin
  CreateIt (a,b);
  try
    a.Size (VectorLength, FALSE);
    b.Size (VectorLength, FALSE);

    n:= 1;
    StartTimer;
    while (TRUE) do
    begin
      Inc(n);
      b.Sin(a);
      delta := StopTimer;
      if delta > 1 then break;
    end;

    Result:= n div 36;  // iterations per 1/4 second

  finally
    FreeIt (a,b)
  end;
end;

end.
