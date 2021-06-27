unit SparseTest;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IniFiles,
  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2, Sparse, MtxVec, MtxExpr, FMX.ListBox, FMX.Controls, FMX.Layouts,
  FMX.Memo, FMX.Types, FMX.Controls.Presentation, FMX.ScrollBox;


                                 
  {$I bdsppdefs.inc}

type
  TfrmSparseTest = class(TBasicForm2)
    Panel4: TPanel;
    Button1: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Chart1: TChart;
    Series1: TBarSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    SparseA: TSparseMtx;
    A: Matrix;
    B: Vector;
    x1,x2,x3,x4: Vector; { compare solutions }
    DecSep,ThSep: Char;
  public
    { Public declarations }
  end;

var
  frmSparseTest: TfrmSparseTest;

implementation

Uses FmxMtxVecEdit, lapack_umfpack, Math387;

{$R *.FMX}

procedure TfrmSparseTest.FormCreate(Sender: TObject);
begin
  inherited;
  DecSep := GetDecimalSeparator;
  ThSep := FormatSettings.ThousandSeparator;
  FormatSettings.DecimalSeparator := '.';
  FormatSettings.ThousandSeparator := ',';

  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;


    Add('The system of 256 linear equations (sparse) sytstem is solved with four methods:');
    Add('');
    Add('1) TMtx.LUSolve method is used to solve the system of equations');
    Add('2) TSparseMtx.Solve direct method (umfpack) is used to solve the system of equations');
    Add('3) TSparseMtx.Solve direct method (pardiso) is used to solve the system of equations');
    Add('4) TSparseMtx iterative method is used to solve the system of equations');
    Add('');
    Add('The test''s should be ran at least twice because the pardiso solver '+
        'has a long initialization period! Umfpack can optionally report also ' +
        'statistics about the solver!');
  end;

  A.Size(0,0);
  x1.Size(0);
  x2.Size(0);
  x3.Size(0);
  x4.Size(0);

  SparseA := TSparseMtx.Create;
  SparseA.ReportLevel := prlNone; { no report - fastest }
  SparseA.AutoClearReport := True; { force clear }
  SparseA.LoadFromMatrixMarketFile('pde225.mtx');

//  SparseA.SparseToDense(A);
//  ShowMessage(MtxTypeToString(A.DetectMtxType(true)));

//  SparseA.Pardiso.CpuCount := 4;
//  SparseA.Pardiso.OutOfCoreMode := pooAutomatic;
  { random data for Ax=b i.e. b constants }
  B.Size(SparseA.Rows, False);
  B.RandGauss;
end;

procedure TfrmSparseTest.FormDestroy(Sender: TObject);
begin
  {$IFDEF D15}
  FormatSettings.DecimalSeparator := DecSep;
  FormatSettings.ThousandSeparator := ThSep;
  {$ELSE}
  SysUtils.DecimalSeparator := DecSep;
  SysUtils.ThousandSeparator := ThSep;
  {$ENDIF}
  SparseA.Free;
  inherited;
end;

procedure TfrmSparseTest.Button1Click(Sender: TObject);
var i : Integer;
  tmpStr: String;
begin
  Series1.Clear;
  { Ordinary Mtx.LuSolve }
  SparseA.SparseToDense(A);
  StartTimer;
  for i := 1 to 100 do A.LUSolve(B,x1);
  Series1.Add(StopTimer*1000,'LUSolve', TAlphaColors.Red);

  { "UMFPack" sparse solve }
  SparseA.ReportLevel := TReportLevel(ComboBox1.ItemIndex);
  SparseA.SparseSolver := ssUmfPack;
  MtxVec.Report.Clear;
  StartTimer;
  for i := 1 to 100 do SparseA.Solve(B,x2);
  Series1.Add(StopTimer*1000,'UMFPack'+chr(13)+'Solve', TAlphaColors.Blue);

  { load report from MtxVec.Report class }
  Memo1.Lines.Clear();
  MtxVec.Report.Position := 0;
  Memo1.Lines.LoadFromStream(MtxVec.Report);

  { "Pardiso" sparse solve }
  {$IFDEF TTDOUBLE}

  SparseA.SparseSolver := ssPardiso;
  StartTimer;
  for i := 1 to 100 do
  begin
      SparseA.Solve(B,x3);
  end;
  Series1.Add(StopTimer*1000,'Pardiso'+chr(13)+'Solve', TAlphaColors.Green);

  {$ENDIF}

  { Iterative sparse solve }
  x4.Size(B);
  SparseA.SparseSolver := ssIterative;
  SparseA.IterativeMethod := itmLUGMRES;
  StartTimer;
  for i := 1 to 100 do
  begin
       x4.Ramp; {Approximate solution}
       SparseA.Solve(B,x4);
  end;
  Series1.Add(StopTimer*1000,'Sparse'+chr(13)+'IterativeSolve', TAlphaColors.Yellow);


  if x1.Equal(x2,1.0e-2) then tmpStr := 'LU Solve solution equal to UMFPack solve solution'
  else tmpStr := 'LU Solve solution NOT equal to UMFPack solve solution';

  {$IFDEF TTDOUBLE}

  if x1.Equal(x3,1.0e-2) then tmpStr := tmpStr+chr(10)+chr(13)+'LU Solve solution equal to Pardiso solve solution'
  else tmpStr := tmpStr+chr(10)+chr(13)+'LU Solve solution NOT equal to Pardiso solve solution';

  {$ENDIF}

  if x1.Equal(x4,1.0e-2) then tmpStr := tmpStr+chr(10)+chr(13)+'LU Solve solution equal to iterative solve solution'
  else tmpStr := tmpStr+chr(10)+chr(13)+ 'LU Solve solution NOT equal to iterative solve solution';

  ShowMessageBox(tmpStr);
end;

initialization
  RegisterClass(TfrmSparseTest);

end.

