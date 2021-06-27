unit SysLinear1;

interface

{$I BdsppDefs.inc}

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
  FMX.ListBox,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2, FmxMtxVecEdit, MtxVec, MtxExpr, PlatformHelpers, FMX.ScrollBox,
  FMX.Controls.Presentation;


type
  TLinearSystem1 = class(TBasicForm2)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    StringGrid2: TStringGrid;                 
    Label2: TLabel;
    Label3: TLabel;
    StringGrid3: TStringGrid;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Panel4: TPanel;
    Memo2: TMemo;
    RadioGroup1: TPanel;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Panel5: TPanel;
    StringGrid4: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    A: Matrix;
    b,x,S : Vector;
    { Private declarations }
    RadioGroupIndex: integer;
  public
    { Public declarations }
  end;

var
  LinearSystem1: TLinearSystem1;

implementation

Uses MtxDialogs;

{$R *.FMX}

procedure TLinearSystem1.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('MtxVec offers three different methods to solve a system '
      + 'of linear equations : LU, LQR and singular value '
      + 'decomposition. Each of these methods has its advantages '
      + 'and disadvantages. Try changing values in matrix A, '
      + 'vector b and method used to calculate the solution vector '
      + 'x. The displayed matrix is nearly singular. You can add '
      + 'more non-zero elements to the diagonal to make it non-singular.');
    Add('In practice, most computations are performed with rounding '
      + 'errors. The LUSolve method offers you additional tools for '
      + 'refining the solution and estimating its error. They are '
      + 'evaluated only if RefineSolution is set to true');
    Add('');

    Add('Parameters in this demo :');
    Add('ConditionNr: If your matrix is ill-conditioned '
      + '(that is, it''s ConditionNr is very small), then the error in '
      + 'the solution x is also large. ');
    Add('BackError: the smallest relative perturbation in elements '
      + 'of A and b such that x is the exact solution of the perturbed '
      + 'system.');
    Add('ForwError: the component-wise forward error in the computed '
      + 'solution.');
    Add('');
    Add('Try changing the matrix values and observe the solution, CondtionNr, ForwError and BackError.');
  end;

  {$IFDEF D20}
  StringGrid1.Options := StringGrid1.Options - [TGridOption.Header];
  StringGrid2.Options := StringGrid2.Options - [TGridOption.Header];
  StringGrid3.Options := StringGrid3.Options - [TGridOption.Header];
  {$ELSE}
  StringGrid1.ShowHeader := False;
  StringGrid2.ShowHeader := False;
  StringGrid2.ShowHeader := False;
  {$ENDIF}


  A.SetIt(4,4,false,[0.001,  0,     0, 0,
                     3    ,0.001,   0, 0,
                     2.5  ,  2,     3, 0,
                     4    , -1,   0.5, 0.1]);
  b.Size(4);
  b.Setit([3,1.5,-2,4]);
  X.Size(0);
  S.Size(0);

  StringGrid1.RowCount := A.Rows;
  SetGridColumnCount(StringGrid1, A.Cols);
  ValuesToGrid(A,StringGrid1,0,0,'0.0000',false);

  StringGrid3.RowCount := b.Length;
  SetGridColumnCount(StringGrid3,1);
  ValuesToGrid(b,StringGrid3,0,0,'0.0000',false);

  ComboBox1.ItemIndex := 0;
  ComboBox1Change(ComboBox1);
  CheckBox1Click(CheckBox1);
  RadioButton1Change(RadioButton1);
end;

procedure TLinearSystem1.Button1Click(Sender: TObject);
begin
  StringGrid1.RowCount := A.Rows;
  SetGridColumnCount(StringGrid1, A.Cols);
  GridToValues(A,StringGrid1,A.Complex,false);

  StringGrid3.RowCount := b.Length;
  SetGridColumnCount(StringGrid3, 1);
  GridToValues(b,StringGrid3,b.Complex,true,false);

  Case ComboBox1.ItemIndex of
  0:begin
      A.LUSolve(b,x);
      Memo2.Lines.Clear;
      if CheckBox1.IsChecked and (RadioGroupIndex <> 0) then
      begin
           Memo2.Lines.Add('Forward error = '+ FormatFloat('0.0000E+00 ',A.ForwError));
           Memo2.Lines.Add('Backward error = '+ FormatFloat('0.0000E+00 ',A.BackError));
           Memo2.Lines.Add('ConditionNr = '+ FormatFloat('0.0000E+00',A.ConditionNr));
      end;
    end;
  1:begin
      A.SVDSolve(b,x,S);

      StringGrid4.RowCount := S.Length;
      SetGridColumnCount(StringGrid4, 1);
      ValuesToGrid(S,StringGrid4,0,0,'0.0000E+00',false);
    end;
  end;

  StringGrid2.RowCount := X.Length;
  SetGridColumnCount(StringGrid2, 1);
  ValuesToGrid(x,StringGrid2,0,0,'0.0000E+00',false);
end;

procedure TLinearSystem1.CheckBox1Click(Sender: TObject);
begin
  A.RefineSolution := TCheckBox(Sender).IsChecked;
end;

procedure TLinearSystem1.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1 = Sender then RadioGroupIndex := 0;
  if RadioButton2 = Sender then RadioGroupIndex := 1;
  if RadioButton3 = Sender then RadioGroupIndex := 2;

   Case RadioGroupIndex of
     0:   A.ConditionNumber := cnNone;
     1:   A.ConditionNumber := cnNorm1;
     2:   A.ConditionNumber := cnNormInf;
   end;
end;

procedure TLinearSystem1.ComboBox1Change(Sender: TObject);
begin
  Panel4.Visible := TComboBox(Sender).ItemIndex = 0;
  Panel5.Visible := TComboBox(Sender).ItemIndex = 1;
  Memo2.Lines.Clear;
end;

initialization
   RegisterClass(TLinearSystem1);

end.
