unit CalcSqrtMtx;

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
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,
  Math387, MtxVec, System.Rtti,
  PlatformHelpers, FMX.Controls.Presentation, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Memo.Types;


type
  TfrmSqrtMtx = class(TBasicForm2)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel4: TPanel;
    RadioGroup2: TPanel;
    Panel5: TPanel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    SymmetricButton: TRadioButton;
    GeneralButton: TRadioButton;
    Label1: TLabel;
    procedure Panel5Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SymmetricButtonChange(Sender: TObject);
  private
    MatrixTypeIndex: integer;
    { Private declarations }
    A,B, C: TMtx;
  public
    { Public declarations }
  end;

var
  frmSqrtMtx: TfrmSqrtMtx;

implementation

{$R *.FMX}

Uses FmxMtxVecEdit, MtxDialogs, AbstractMtxVec;

procedure MakeSymmetric(Mtx: TMtx);
var i,j : Integer;
begin
  for i := 0 to Mtx.Rows-1 do
    for j := 0 to Mtx.Cols -1 do
      if i > j then Mtx.Values[i,j] := Mtx.Values[j,i];
end;

procedure TfrmSqrtMtx.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('SqrtMtx is an example of a matrix function.');
    Add('');
    Add('You can apply any function (Log, Exp, Power...) '
      + 'to the matrix via the MtxFunction method. In this '
      + 'case the result is obtained via eigenvalue '
      + 'decomposition.');
  end;
  {$IFDEF D20}
  StringGrid1.Options := StringGrid1.Options - [TGridOption.Header];
  StringGrid2.Options := StringGrid2.Options - [TGridOption.Header];
  {$ELSE}
  StringGrid1.ShowHeader := False;
  StringGrid2.ShowHeader := False;
  {$ENDIF}
  A := TMtx.Create;
  B := TMtx.Create;
  C := TMtx.Create;

  Button1Click(Self);

  StringGrid1.Cells[0,0] := 'A';
  StringGrid2.Cells[0,0] := 'Sqrt(A)';
end;

procedure TfrmSqrtMtx.Button1Click(Sender: TObject);
begin
  A.Size(4,4);
  { Resize StringGrid1 to A size}
  StringGrid1.RowCount := A.Rows + 1;
  SetGridColumnCount(StringGrid1,A.Cols + 1);
  StringGrid2.RowCount := A.Rows + 1;
  SetGridColumnCount(StringGrid2, A.Cols*2 + 1);

  A.RandUniform(2,10);
  { symmetric matrix }
  if MatrixTypeIndex = 0 then  MakeSymmetric(A);
  {Write A to StringGrid1 }
  ValuesToGrid(A,StringGrid1,0,0,'0.0000',true);
  StringGrid1.Repaint; //required to refresh content in DXE6
  Button2.Enabled := true;
  Button3.Enabled := false;
end;

procedure TfrmSqrtMtx.Button2Click(Sender: TObject);
begin
  { resize B to match the size of A }
  B.Size(A);
  { copy values for StringGrid1 }
  GridToValues(B,StringGrid1,B.Complex,True);
  { calculate the inverse }
  if MatrixTypeIndex = 0 then C.MtxSqrt(B,mtSymmetric)
                         else C.MtxSqrt(B,mtGeneral);
  {show the SQRT(matrix) in StringGrid2 }
  ValuesToGrid(C,StringGrid2,0,0,'0.0000',True);
  Button3.Enabled := true;
end;

procedure TfrmSqrtMtx.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  try
     StrToFloat(Value);
  except
  end;
end;

procedure TfrmSqrtMtx.SymmetricButtonChange(Sender: TObject);
begin
  if SymmetricButton.IsChecked then MatrixTypeIndex := 0;
  if GeneralButton.IsChecked then MatrixTypeIndex := 0;
end;

procedure TfrmSqrtMtx.Button3Click(Sender: TObject);
begin
  B.Mul(C,C,opNone,opNone);

  if B.Complex then C.RealPart(B) { get only real part }
               else C.Copy(B);
  { compare }
  if C.Equal(A,1.0E-3) then ShowMessageBox('Succeeded!')
                       else ShowMessageBox('Failed!');
  Button3.Enabled := False;
end;

procedure TfrmSqrtMtx.FormDestroy(Sender: TObject);
begin
  A.Free;
  B.Free;
  C.Free;
  inherited;
end;

procedure TfrmSqrtMtx.Panel5Resize(Sender: TObject);
begin
  inherited;
  StringGrid1.Width := Panel5.Width - 2;
  StringGrid1.Position.X := 1;
  StringGrid1.Position.Y := 1;
  StringGrid1.Height := Panel5.Height/2 - 2;

  StringGrid2.Position.X := 1;
  StringGrid2.Position.Y := StringGrid1.Height + 5;
  StringGrid2.Width := StringGrid1.Width;
  StringGrid2.Height := StringGrid1.Height;
end;

initialization
  RegisterClass(TfrmSqrtMtx);

end.
