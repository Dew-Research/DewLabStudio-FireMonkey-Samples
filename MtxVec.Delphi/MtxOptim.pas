unit MtxOptim;

interface

{$I BdsppDefs.inc }

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
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2, MtxVecTools,
  MtxBaseComp,  FMX.Controls.Presentation, FMX.ScrollBox;


type
  TfrmMtxOptim = class(TBasicForm2)
    CheckBox1: TCheckBox;
    Memo2: TMemo;
    CheckBox2: TCheckBox;          
    RadioGroup1: TPanel;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar2: TTrackBar;
    Label12: TLabel;
    Label13: TLabel;
    TrackBar6: TTrackBar;
    Label10: TLabel;
    Label11: TLabel;
    TrackBar5: TTrackBar;
    Label5: TLabel;
    TrackBar3: TTrackBar;
    Label7: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    TrackBar4: TTrackBar;
    Label8: TLabel;
    Button1: TButton;
    Button2: TButton;
    TrackBar7: TTrackBar;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
  private
    MtxOptimization1: TMtxOptimization;
    { Private declarations }
    RadioGroupIndex: integer;
  public
    { Public declarations }
  end;

var
  frmMtxOptim: TfrmMtxOptim;

implementation

Uses Math387, MtxVec, FmxMtxVecEdit, Optimization, MtxIntDiff, AbstractMtxVec;

{$R *.FMX}

{ Definition for "banana" function
  This function is used to evaluate "banana" function in all optimization methods }
function Banana(const Pars: TVec; const Constants: TVec; Const ObjConst: Array of TObject): double;
begin
  Result := 100*Sqr(Pars[1]-Sqr(Pars[0]))+Sqr(1-Pars[0]);
end;

{ the exact calculation of gradient  for "banana" function
  this procedure is used by BFGS method to evaluate grad }
procedure GradBanana(Fun : TRealFunction; const Pars: TVec; Const Consts: TVec; Const PConsts: Array of TObject; const Grad: TVec);
begin
  Grad.Values[0] := -400*(Pars[1]-Sqr(Pars[0]))*Pars[0]-2*(1-Pars[0]); { dF/dPars[0] }
  Grad.Values[1] := 200*(Pars[1]-Sqr(Pars[0])); { dF/dPars[1] }
end;

{ the exact calculation of gradient and Hessian matrix for "banana" function
  this procedure is used by Marquardt method to evaluate grad and Hessian matrix }
procedure GradHessBanana(Fun: TRealFunction; const Pars: TVec; Const Consts: TVec; Const ObjConst: Array of TObject; const Grad: TVec; const Hess: TMtx);
begin
  Grad.Values[0] := -400*(Pars[1]-Sqr(Pars[0]))*Pars[0]-2*(1-Pars[0]);   { dF/dPars[0] }
  Grad.Values[1] := 200*(Pars[1]-Sqr(Pars[0]));  { dF/dPars[1] }
  Hess.Values[0,0] := -400*Pars[1]+1200*Sqr(Pars[0])+2;  { d^2F/dPars[0]^2 }
  Hess.Values[0,1] := -400*Pars[0]; { d^2F/dPars[0]dPars[1] }
  Hess.Values[1,0] := -400*Pars[0]; { d^2F/dPars[1]dPars[0] }
  Hess.Values[1,1] := 200; { d^2F/dPars[1]^2 }
end;

procedure TfrmMtxOptim.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.IsChecked then MtxOptimization1.Verbose := Memo2.Lines
  else MtxOptimization1.Verbose := nil;
end;

procedure TfrmMtxOptim.CheckBox2Change(Sender: TObject);
begin
  MtxOptimization1.SoftSearch := CheckBox2.IsChecked;
  if CheckBox2.IsChecked then
  begin { numerical approximation }
    MtxOptimization1.GradProcedure := nil;
    MtxOptimization1.GradHessProcedure := nil;
  end else
  begin  { exact grad and grad hess }
    MtxOptimization1.GradProcedure := GradBanana;
    MtxOptimization1.GradHessProcedure := GradHessBanana;
  end;
end;

procedure TfrmMtxOptim.FormCreate(Sender: TObject);
begin
  inherited;
  MtxOptimization1 := TMtxOptimization.Create(Self);
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('Optimization unit comes with several algorithms for '
    + 'finding the unconstrained minimum of a scalar function of several variables. '
    + 'TMtxOptimization component offers the same functionality as Optimization '
    + 'routines, but simplifies the user interface. '
    + 'In this example the algorithms are tested against the '
    + '"banana" function:');
    Add('');
    Add('f(a,b) = 100*Sqr(b-Sqr(a)) + Sqr(1-a)');
    Add('');

    Add('Parameters in this demo:');
    Add('Method:'+#9+'optimization method used');
    Add('Log:'+#9+'write every optimization step to log');
    Add('Numerical derivative:'+#9+'use numerical approximation of grad and Hess');
    Add('Max. number of iter.:'+#9+'maximum number of iterations');
    Add('GradTolerance:'+#9+'minimum gradient C-Norm');
    Add('Initial lambda:'+#9+'initial lambda used in Marquardt method');
    Add('a,b:'+#9+'initial values for "banana" function parameters');
    Add('');
    Add('The Quasi-Newton (BFGS, DFP), Marquardt and Conjugate Gradient '
      + '(Fletcher and Polak algorithm) require exact or numerical '
      + 'gradient/Hessian matrix. On the other hand, Simplex '
      + 'algorithm does not require gradient nor Hessian matrix.');
  end;  { assign function }
  MtxOptimization1.RealFunction := Banana;
  { define two variable parameters }
  MtxOptimization1.VariableParameters.Length := 2;
  {$IFDEF TTDouble }
  TrackBar2.Max := 16; { tolerance }
  TrackBar6.Max := 16; { GradEPS }
  TrackBar7.Max := 16; { GradStepSize }
  TrackBar5.Max := 9; { Lambda }
  TrackBar2.Value := 6;
  TrackBar5.Value := 5;
  TrackBar6.Value := 10;
  TrackBar7.Value := 4;
  {$ELSE}
  TrackBar2.Max := 4; { tolerance }
  TrackBar6.Max := 4; { GradEPS }
  TrackBar7.Max := 4; { GradStepSize }
  TrackBar5.Max := 4; { Lambda }
  TrackBar2.Value := 3;
  TrackBar5.Value := 3;
  TrackBar6.Value := 4;
  TrackBar7.Value := 4;
  {$ENDIF}

  TrackBar1Change(TrackBar1);
  TrackBar2Change(TrackBar2);
  TrackBar3Change(TrackBar3);
  TrackBar4Change(TrackBar4);
  CheckBox1Change(nil);
  CheckBox2Change(nil);
  TrackBar5Change(TrackBar5);
  TrackBar6Change(TrackBar6);
  TrackBar7Change(TrackBar7);
end;

procedure TfrmMtxOptim.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1.IsChecked then RadioGroupIndex := 0;
  if RadioButton2.IsChecked then RadioGroupIndex := 1;
  if RadioButton3.IsChecked then RadioGroupIndex := 2;
  if RadioButton4.IsChecked then RadioGroupIndex := 3;
  if RadioButton5.IsChecked then RadioGroupIndex := 4;
  if RadioButton6.IsChecked then RadioGroupIndex := 5;
  MtxOptimization1.OptimizationMethod := TOptMethod(RadioGroupIndex);
end;

procedure TfrmMtxOptim.TrackBar1Change(Sender: TObject);
begin
  MtxOptimization1.MaxIterations := Round(TrackBar1.Value);
  Label2.Text :=IntToStr(MtxOptimization1.MaxIterations);
end;

procedure TfrmMtxOptim.TrackBar2Change(Sender: TObject);
begin
  MtxOptimization1.Tolerance := IntPower(10, Round(-TrackBar2.Value));
  Label4.Text := FloatToStrF(MtxOptimization1.Tolerance, ffExponent, 2, 2);
end;

procedure TfrmMtxOptim.TrackBar6Change(Sender: TObject);
begin
  MtxOptimization1.GradTolerance := IntPower(10, Round(-TrackBar6.Value));
  Label13.Text := FloatToStrF(MtxOptimization1.GradTolerance, ffExponent, 2, 2);
end;

procedure TfrmMtxOptim.TrackBar5Change(Sender: TObject);
begin
  { define initial Lambda for Marquardt method}
  MtxOptimization1.Lambda0 := IntPower(10, Round(-TrackBar5.Value));
  Label11.Text := FloatToStrF(MtxOptimization1.Lambda0,ffExponent,2,2);
end;

procedure TfrmMtxOptim.TrackBar3Change(Sender: TObject);
begin
  { change the intial value of parameter a }
  MtxOptimization1.VariableParameters.Values[0] := TTrackBar(Sender).Value*0.02;
  Label7.Text :=FormatFloat('0.00',MtxOptimization1.VariableParameters.Values[0]);
end;

procedure TfrmMtxOptim.TrackBar4Change(Sender: TObject);
begin
  MtxOptimization1.VariableParameters.Values[1] := TTrackBar(Sender).Value*0.02;
  Label8.Text :=FormatFloat('0.00',MtxOptimization1.VariableParameters.Values[1]);
end;

procedure TfrmMtxOptim.Button2Click(Sender: TObject);
begin
  { show inverse Hessian matrix }
  if (MtxOptimization1.OptimizationMethod = optMarquardt) or (MtxOptimization1.OptimizationMethod = optBFGS) or (MtxOptimization1.OptimizationMethod = optDFP) then
    ViewValues(MtxOptimization1.InverseHess);
end;

procedure TfrmMtxOptim.Button1Click(Sender: TObject);
var tmpStr: String;
begin
  TrackBar3Change(TrackBar3);
  TrackBar4Change(TrackBar4);
  Memo2.Lines.Clear;
  MtxOptimization1.Recalculate;
  Memo2.Lines.Add('----------------------------');
  Memo2.Lines.Add('a = '+FloatToStrF(MtxOptimization1.VariableParameters[0],ffFixed,1,Round(TrackBar2.Value)));
  Memo2.Lines.Add('b = '+FloatToStrF(MtxOptimization1.VariableParameters[1],ffFixed,1,Round(TrackBar2.Value)));
  Memo2.Lines.Add('F(min) = '+FloatToStrF(MtxOptimization1.MinValue,ffFixed,1,Round(TrackBar2.Value)));
  tmpStr := 'Stop Reason = ';
  case MtxOptimization1.StopReason of
    OptResConverged : tmpStr := tmpStr + 'Converged';
    OptResMaxIter : tmpStr := tmpStr + 'Iterations > Max. Iterations';
    OptResSmallStep : tmpStr := tmpStr + 'X step < Tolerance';
    OptResZeroStep : tmpStr := tmpStr + 'Zero x step';
    OptResSmallGrad : tmpStr := tmpStr + 'C Norm(Grad) < gradient tolerance';
    OptResBigLambda : tmpStr := tmpStr + 'Big Lambda';
  end;
  Memo2.Lines.Add(tmpStr);
  Memo2.GoToTextEnd;
end;

procedure TfrmMtxOptim.TrackBar7Change(Sender: TObject);
begin
  Math387.GradStepSize := IntPower(10, Round(-TrackBar7.Value));
  Label15.Text := FloatToStrF(Math387.GradStepSize,ffExponent,2,2);
end;

initialization
  RegisterClass(TfrmMtxOptim);

end.
