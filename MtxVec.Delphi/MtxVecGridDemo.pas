unit MtxVecGridDemo;

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
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2, MtxExpr, FmxMtxGrid, Math387, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.ScrollBox;


type
  TfrmGridDemo = class(TBasicForm2)
    Panel4: TPanel;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;                   
    CheckBox4: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBox5: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    CheckBox6: TCheckBox;
    Item0: TListBoxItem;
    Item1: TListBoxItem;
    Item2: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
  private
    { Private declarations }
    Grid: TMtxVecGrid;
    testMatrix: Matrix;
    testVector: Vector;
  public
    { Public declarations }
  end;

var
  frmGridDemo: TfrmGridDemo;

implementation

uses MtxVecBase, MtxVec;

{$R *.FMX}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TfrmGridDemo.Button1Click(Sender: TObject);
begin
  Grid.Datasource := testVector;
  Grid.UpdateDimensions;
end;

procedure TfrmGridDemo.Button2Click(Sender: TObject);
begin
  Grid.Datasource := testMatrix;
  Grid.UpdateDimensions;
end;

procedure TfrmGridDemo.CheckBox1Change(Sender: TObject);
begin
  Grid.Editable := CheckBox1.IsChecked;
end;

procedure TfrmGridDemo.CheckBox3Change(Sender: TObject);
begin
  Grid.AutoSizeColumns := CheckBox3.IsChecked;
end;

procedure TfrmGridDemo.CheckBox4Change(Sender: TObject);
begin
  Grid.SplitComplexNumbers := CheckBox4.IsChecked;
end;

procedure TfrmGridDemo.CheckBox5Change(Sender: TObject);
begin
  Grid.Scientific := CheckBox5.IsChecked;
end;

procedure TfrmGridDemo.CheckBox6Change(Sender: TObject);
begin
    Grid.ShowInfo := CheckBox6.IsChecked;
end;

procedure TfrmGridDemo.ComboBox1Change(Sender: TObject);
begin
  Grid.TextAlign := TTextAlign(ComboBox1.ItemIndex);
end;

procedure TfrmGridDemo.Edit1Change(Sender: TObject);
begin
  Grid.StringFormat := Edit1.Text;
end;

procedure TfrmGridDemo.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('TMtxVecGrid control allows you easy viewing/editing of real or complex '
      + 'matrices or vectors. The control is derived from TCustomGrid and inherits '
      + 'all it''s properties/methods and introduces some new features: cell text alignment, '
      + 'cell string format, full support for complex numbers, ability to edit, remove or '
      + 'append/insert rows into matrix or vector.');
  end;
  // Create a grid at runtime
  Grid := TMtxVecGrid.Create(Self);
  Grid.Parent := Panel3;
  Grid.Align := {$IFDEF D21} TAlignLayout.Client; {$ELSE} TAlignLayout.alClient; {$ENDIF}
  Grid.AutoSizeColumns := True;

  // Setup test matrix and vector
  testMatrix.Size(30,30,true);
  testMatrix.RandGauss;
  testVector.Size(50,false);
  testVector.RandUniform(5,12);

  // initially, connect Grid with testmatrix
  Grid.Datasource := testmatrix;

  ComboBox1.ItemIndex := Ord(Grid.TextAlign);
  Edit1.Text := Grid.StringFormat;
  CheckBox1.isChecked := Grid.Editable;
  CheckBox3.IsChecked := Grid.AutoSizeColumns;
  CheckBox4.IsChecked := Grid.SplitComplexNumbers;
  CheckBox6.isChecked := Grid.ShowInfo;
end;


initialization
  RegisterClass(TfrmGridDemo);

end.
