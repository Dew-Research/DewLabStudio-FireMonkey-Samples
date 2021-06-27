unit ParserPerformance;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Forms,
  Basic2,
  FmxMtxComCtrls,MtxParseClass, MtxParseExpr,MtxVec, Math387, MtxExpr,
  FMX.Edit, FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;




type
  TfrmParserPerformance = class(TBasicForm2)
    Chart1: TChart;
    FormulaEdit: TEdit;
    Label1: TLabel;                         
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TPanel;
    ComputationGroup: TPanel;
    UpdateButton: TButton;
    Series1: TFastLineSeries;
    BenchmarkButtom: TButton;
    StandardLabel: TLabel;
    vectorLabel: TLabel;
    RatioLabel: TLabel;
    StartXEdit: TMtxFloatEdit;
    StopXEdit: TMtxFloatEdit;
    StepXEdit: TMtxFloatEdit;
    Label5: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure BenchmarkButtomClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StepXEditChange(Sender: TObject);
    procedure StopXEditChange(Sender: TObject);
    procedure StartXEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
  private
    procedure UpdateX;
    { Private declarations }
  public
    ComputationGroupIndex: integer;
    { Public declarations }
    x,y: Vector;
    yResult: TVec;
    Expr: TMtxExpression;
    x1,y1: TValueRec;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmParserPerformance: TfrmParserPerformance;

implementation

uses FmxMtxVecTee, FmxMtxVecEdit, AbstractMtxVec;

{$R *.FMX}

procedure TfrmParserPerformance.BenchmarkButtomClick(Sender: TObject);
var i, j, Loops: integer;
    Tick, Tick1: double;
    xValues,yValues: TSampleArray;
begin
    UpdateButtonClick(Sender);
    StandardLabel.Visible := true;
    vectorlabel.Visible := true;
    ratioLabel.Visible := true;

    Loops := (1000*1000 div 2) div x.Length;

    Expr.ClearAll;
    x1 := Expr.DefineDouble('x');
    Expr.Expressions := FormulaEdit.Text;

    x.CopyToArray(xValues);
    y.SizeToArray(yValues);

    StartTimer;
    for j := 0 to Loops - 1 do
    begin
        for i := 0 to x.Length - 1 do
        begin
             x1.DoubleValue :=  xValues[i];
             yValues[i] := Expr.EvaluateDouble;
        end;
    end;

    Tick := StopTimer*1000;
    StandardLabel.Text := 'Standard = ' + FormatSample('0.00ms',Tick);

    Expr.ClearAll;
    Expr.DefineVector('x',x);
    Expr.Expressions := FormulaEdit.Text;

    StartTimer;
    for j := 0 to Loops - 1 do
    begin
        yResult := Expr.EvaluateVector;
    end;

    Tick1 := StopTimer*1000;
    VectorLabel.Text := 'Vectorized = ' + FormatSample('0.00ms',Tick1);

    RatioLabel.Text := 'Ratio = ' + FormatSample('0.00',Tick/Tick1);
end;

constructor TfrmParserPerformance.Create(AOwner: TComponent);
begin
  inherited;
  FormCreate(Self);
end;

procedure TfrmParserPerformance.FormCreate(Sender: TObject);
begin
    inherited;
    With RichEdit1.Lines do
    begin
      Clear;
      Add('Example demonstrates performance benefits and usage differences ' +
          'when using a classical single value parser and a vectorized parser.' +
          'Try changing the math formula and measure the time needed with both ' +
          'approaches.');
    end;
    Expr := TMtxExpression.Create;
    UpdateX;
end;

procedure TfrmParserPerformance.UpdateButtonClick(Sender: TObject);
var i: integer;
begin
    StandardLabel.Visible := false;
    vectorlabel.Visible := false;
    ratiolabel.Visible := false;

    Expr.ClearAll;
    case ComputationGroupIndex of
    0: begin
          x1 := Expr.DefineDouble('x');
          Expr.Expressions := FormulaEdit.Text;

          for i := 0 to x.Length - 1 do
          begin
               x1.DoubleValue :=  X.Values[i];
               y.Values[i] := Expr.EvaluateDouble;
          end;
          yResult := y;
       end;
    1: begin
          Expr.DefineVector('x',x);
          Expr.Expressions := FormulaEdit.Text;

          yResult := Expr.EvaluateVector;
       end;
    end;

    Chart1.Title.Text.Clear;
    Chart1.Title.Text.Add('y = ' + FormulaEdit.Text);
    DrawValues(x,yresult,Series1);
end;

procedure TFrmParserPerformance.UpdateX;
begin
    x.Length := Round(abs(StopXEdit.FloatPosition - StartXEdit.FloatPosition)/StepXEdit.FloatPosition);
    x.Ramp(Math387.Min(StopXEdit.FloatPosition,StartXEdit.FloatPosition),StepXEdit.FloatPosition);
    y.Size(x);
end;

procedure TfrmParserPerformance.FormDestroy(Sender: TObject);
begin
   Expr.Free;
end;

procedure TfrmParserPerformance.RadioButton2Change(Sender: TObject);
begin
  if Sender = RadioButton1 then ComputationGroupIndex := 0;
  if Sender = RadioButton2 then ComputationGroupIndex := 1;
end;

procedure TfrmParserPerformance.StartXEditChange(Sender: TObject);
begin
    UpdateX;
end;

procedure TfrmParserPerformance.StepXEditChange(Sender: TObject);
begin
    UpdateX;
end;

procedure TfrmParserPerformance.StopXEditChange(Sender: TObject);
begin
    UpdateX;
end;

initialization
  RegisterClass (TfrmParserPerformance);
end.

