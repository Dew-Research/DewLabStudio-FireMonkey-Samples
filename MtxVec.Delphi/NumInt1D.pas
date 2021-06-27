unit NumInt1D;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  FMX.Header,
  Basic2, MtxParseClass, MtxParseExpr,
  MtxIntDiff, MtxExpr, Math387,
  MtxVec, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit, FMX.Controls,
  FMX.Layouts, FMX.Memo, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo.Types;


type
  TfrmInt1D = class(TBasicForm2)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;          
    Label2: TLabel;
    Editlb: TEdit;
    Label3: TLabel;
    Editub: TEdit;
    Label4: TLabel;
    ComboBox1: TComboBox;
    Label5: TLabel;
    EditIntervals: TEdit;
    Chart1: TChart;
    Series1: TLineSeries;
    FItem0: TListBoxItem;
    FItem1: TListBoxItem;
    FItem2: TListBoxItem;
    FItem3: TListBoxItem;
    FItem4: TListBoxItem;
    FItem5: TListBoxItem;
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    parser: TMtxExpression;
    function ExtractFormula(out varname: String): boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmInt1D: TfrmInt1D;

implementation

uses AbstractMtxVec;

{$R *.FMX}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiTb.fmx ANDROID}

// A bit tricky, but ObjConsts hold all necessary objects, strings, etc..
// needed for calculation of f(x)
// ObjConsts[0] = TMtxExpression
// ObjConsts[1] = x name
// Pars[0] = x value
function IntObjFun(const Pars: TVec; const Constants: TVec; Const ObjConsts: Array of TObject): double;
var parname: String;
begin
  with ObjConsts[0] as TMtxExpression do
  begin
    parname := string(ObjConsts[1]);
    VarByName[parname].DoubleValue := Pars.Values[0];
    Result := EvaluateDouble;
  end;
end;

constructor TfrmInt1D.Create(AOwner: TComponent);
begin
  inherited;
  parser := TMtxExpression.Create;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('You can use Gauss quadrature formula to evaluate single, double and '
      + 'n-dimensional integrals. This example demonstrates how to use numerical '
      + 'integration routines together with TMtxParser class to evaluate integral '
      + 'of f(x) on interval [a,b].');
    Add('');
    Add('1. Enter any function (using single variable) in "Function" edit box.');
    Add('2. Define integration lower and upper bounds.');
    Add('3. Select integration method.');
    Add('4. Press the "Evaluate" button.');
  end;
  Button1Click(Self);
end;

function TfrmInt1D.ExtractFormula(out varname: String) : boolean;
var list: TStrings;
begin
  varname := '';
  list := TStringList.Create;
  try
    parser.ClearAll;
    parser.Expressions := Edit1.Text;
    // Get a list of all variables, use only first variable
    parser.GetVarList(list);
    Result := list.Count = 1;
    if Result then
    begin
//      parser.DefineDouble(list[0]); //would cause recompile of the expression
      varname := list[0];
    end;
  finally
    list.Free;
  end;
end;

procedure TfrmInt1D.Button1Click(Sender: TObject);
var
  lb,ub: TSample;
  step: TSample;
  i: Integer;
  integral: TSample;
  bp,w,cnst: Vector;
  nquad: Integer;
  xv,yv: TSample;
  vname: String;
  numpoints: Integer;
begin
  // Get function from edit text box
  if ExtractFormula(vname) then
  begin
    // Read bounds
    lb := StrToSample(Editlb.Text);
    ub := StrToSample(Editub.Text);

    // Evaluate integral
    // Step 1 : calculate base points and weights
    nquad := StrToInt(EditIntervals.Text);
    case (ComboBox1.ItemIndex) of
      0: WeightsNewtonCotes(1,bp,w);
      1: WeightsNewtonCotes(2,bp,w);
      2: WeightsNewtonCotes(3,bp,w);
      3: WeightsNewtonCotes(4,bp,w);
      4: WeightsGauss(10,bp,w);
      5: WeightsGauss(16,bp,w);
    end;
    numpoints := Max(nQuad,100);
    step := (ub-lb)/numpoints;

    // plot function (100 points)
    Series1.Clear;
    for i := 0 to numpoints-1 do
    begin
      xv := lb + i*step;
      parser.VarByName[vname].DefineDouble; //!! (without this it wont work, because the variable has been defined implicitely (it was used in the expression, but its type was not specified)
      parser.VarByName[vname].DoubleValue := xv;
      yv := parser.EvaluateDouble;
      If Not(IsNANInf(yv)) then
        Series1.AddXY(xv,yv);
    end;

    // Step 2: evaluate integral
    integral := QuadGauss( IntObjFun,lb,ub,cnst,[parser,TObject(vname)],bp,w,nquad);

    Chart1.Title.Clear;
    Chart1.Title.Text.Add('Integral of f('+vname+') from '+ FormatSample('0.000',lb) + ' to '
      + FormatSample('0.000',ub));
    Chart1.Title.Text.Add(FormatSample(integral,'0.00000000'));
    Chart1.BottomAxis.Title.Text := vname;
    Chart1.LeftAxis.Title.Text := 'f('+vname+')';
  end
  else
  begin
    ShowMessageBox('Use only one variable');
//    Edit1.Undo;
  end;
end;


procedure TfrmInt1D.FormDestroy(Sender: TObject);
begin
  parser.Free;
  inherited;
end;

initialization
  RegisterClass(tfrmInt1D);

end.
