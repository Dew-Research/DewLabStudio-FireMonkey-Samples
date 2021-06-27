unit Optim_LP;

interface

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
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,
  MtxVecTools,
  MtxBaseComp,
  FmxMtxComCtrls,
  FmxMtxGrid, FMX.Controls.Presentation, FMX.ScrollBox;



type
  TfrmLP = class(TBasicForm2)
    Label1: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Splitter1: TSplitter;
    Memo1: TMemo;
    LabelA: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    EditRelations: TEdit;
    MtxLP1: TMtxLP;
    MtxVecGrid1: TMtxVecGrid;
    MtxVecGrid2: TMtxVecGrid;
    MtxVecGrid3: TMtxVecGrid;
    MtxFloatEdit1: TMtxFloatEdit;
    MtxFloatEdit2: TMtxFloatEdit;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure MtxFloatEdit1Change(Sender: TObject);
    procedure MtxFloatEdit2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditRelationsChange(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
  private
    { Private declarations }
    formCreating: boolean;
  public
    { Public declarations }
  end;

var
  frmLP: TfrmLP;

implementation

{$R *.FMX}

Uses Optimization, Math387;

procedure TfrmLP.Button1Click(Sender: TObject);
begin

  Memo1.Lines.Clear;
  Memo1.Lines.Add('Algorithm log');
  Memo1.Lines.Add('');
  mtxLP1.Recalculate;
  //
  case MtxLP1.SolutionType of
    LPEmptyFeasableRegion:   Memo1.Lines.Add('Empty feasable region.');
    LPFiniteSolution:   Memo1.Lines.Add('Problem has finite optimal solution.');
    LPUnboundedObjectiveFunction:   Memo1.Lines.Add('Unbounded optimal solution.');
  end;
  Memo1.Lines.Add('');
  Memo1.Lines.Add('Values of legitimate variables:');
  MtxLP1.x.ValuesToStrings(Memo1.Lines);
  Memo1.Lines.Add('');
  Memo1.Lines.Add('f(x) value at optimal point:'+chr(9)+FormatSample(mtxLP1.z));
  Memo1.GoToTextEnd;
end;

procedure TfrmLP.CheckBox1Change(Sender: TObject);
begin
  MtxLP1.Minimize := CheckBox1.IsChecked;
end;

procedure TfrmLP.CheckBox2Change(Sender: TObject);
begin
  if not(formCreating) then
    if (CheckBox2.IsChecked) then mtxLP1.Verbose := Memo1.Lines else MtxLP1.Verbose := nil;
end;

procedure TfrmLP.ComboBox1Change(Sender: TObject);
begin
  MtxLP1.Algorithm := TLPAlgorithm(Combobox1.ItemIndex);
end;

procedure TfrmLP.EditRelationsChange(Sender: TObject);
begin
  if not(formCreating) then
    MtxLP1.Relations := EditRelations.Text;
end;

procedure TfrmLP.FormCreate(Sender: TObject);
begin
  inherited;
  formCreating := true;

  With RichEdit1.Lines do
  begin
    Clear;
    Add('New in MtxVec 3.0: Optimization unit now includes several routines plus component for solving linear programming problems (LP). Routines include support for solving dual, two phase and ordinary LP problems. '
      + 'Now the following LP problems can be solved:');
    Add('');
    Add('f(x) =c(T)*x ; A*x>=b; x=>0  (Dual Simplex)');
    Add('f(x) =c(T)*x ; A*x relation b; x=>0 (Two Phase Simplex)');
    Add('f(x) =c(T)*x ; A*x<=b; x=>0 (Simplex)');
    Add('f(x) =c(T)*x ; A*x<=b; x=>0, integers (Gomory''s CPA)');
    Add('');
    Add('In the example bellow a system with 7 equations and 2 constraints is minimized. The system is defined by:');
    Add('f(x) = 3x1 + 4x2 + 6x3 + 7x4 +x5');
    Add('subject to:');
    Add('2x1 - x2 + x3 +6x4 -5x5 -x6 = 6');
    Add('x1 + x2 +2x3 + x4 +2x5 -x7 = 3');
    Add('');
    Add('In this case a two-phase Simplex algorithm (because of the constraints) should be used to solve the LP problem. '
      + 'Also try changing LP problem parameters (number of equations, constraint type, ... and use other appropriate algorithms to solve the problem.');
  end;

  // Setup LP problem
  mtxLP1.Verbose := Memo1.Lines;
  MtxLP1.Minimize := CheckBox1.IsChecked;
  MtxLP1.Algorithm := TLPAlgorithm(ComboBox1.ItemIndex);
  MtxLP1.Relations := '==';
  MtxLP1.A.SetIt(2,7,false,[2, -1, 1, 6, -5, -1, 0,
                            1, 1, 2, 1, 2, 0, -1]);
  MtxLP1.c.SetIt(false,[3, 4, 6, 7, 1, 0, 0 ]);
  MtxLP1.b.SetIt(false,[6, 3]);

  MtxFloatEdit1.IntPosition := MtxLP1.c.Length;
  MtxFloatEdit2.IntPosition := MtxLP1.b.Length;
  EditRelations.Text := MtxLP1.Relations;
  MtxVecGrid1.Datasource := MtxLP1.A;
  MtxVecGrid1.UpdateDimensions;
  MtxVecGrid2.Datasource := MtxLP1.b;
  MtxVecGrid2.UpdateDimensions;
  MtxVecGrid3.Datasource := MtxLP1.c;
  MtxVecGrid3.UpdateDimensions;

  formCreating := false;
end;

procedure TfrmLP.MtxFloatEdit1Change(Sender: TObject);
begin
  if not(formCreating) then
  begin
    MtxLP1.c.Resize(MtxFloatEdit1.IntPosition);
    MtxLP1.A.Resize(MtxLP1.A.Rows, MtxLP1.c.Length);
    MtxVecGrid1.UpdateDimensions;
    MtxVecGrid2.UpdateDimensions;
    MtxVecGrid3.UpdateDimensions;
  end;
end;

procedure TfrmLP.MtxFloatEdit2Change(Sender: TObject);
begin
  if not(formCreating) then
  begin
    MtxLP1.b.Resize(MtxFloatEdit2.IntPosition);
    MtxLP1.A.Resize(MtxLP1.A.Rows, MtxLP1.b.Length);
    MtxVecGrid1.UpdateDimensions;
    MtxVecGrid2.UpdateDimensions;
    MtxVecGrid3.UpdateDimensions;
  end;
end;

initialization
  RegisterClass(TfrmLP);

end.
