unit EigenVectors1;

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
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,MtxVec,Math387, MtxExpr, System.Rtti, PlatformHelpers, FMX.Memo.Types,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Controls.Presentation;



type
  TEigVec1 = class(TBasicForm2)
    StringGrid4: TStringGrid;
    StringGrid2: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TPanel;
    BalanceGroup: TPanel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button1: TButton;
    Label4: TLabel;
    BalanceLabel: TLabel;
    EigButton: TRadioButton;
    ShurButton: TRadioButton;
    NoneButton: TRadioButton;
    ScaleButton: TRadioButton;
    PermButton: TRadioButton;
    FullButton: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure EigButtonChange(Sender: TObject);
    procedure NoneButtonChange(Sender: TObject);
  private
    VectorFormIndex, BalanceIndex: integer;
    A,EigL,EigR: Matrix;
    EigValues : Vector;
    VecForm : TVectorForm;
    Bal     : TBalanceType;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EigVec1: TEigVec1;

implementation

Uses MtxDialogs;

{$R *.FMX}

procedure TEigVec1.EigButtonChange(Sender: TObject);
begin
    if EigButton.IsChecked then VectorFormIndex := 0;
    if ShurButton.IsChecked then VectorFormIndex := 1;
    Case VectorFormIndex of
    0 : begin
             VecForm := vfEig;
             SetRadioItemIndex(BalanceGroup, 3);
             BalanceGroup.Enabled := false;
        end;
    1 : begin
             VecForm := vfSchur;
             BalanceGroup.Enabled := true;
        end;
    end;
end;

procedure TEigVec1.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('The Eig method is a powerful tool. With it you can '
      + 'easily calculate eigenvalues and left/right eigenvectors.');

    Add('');
    Add('VectorForm');
    Add('If  "Vector Form" is vfEig, then full balance will '
      + 'be used to find eigenvalues eigenvectors (check help '
      + 'file for more on this topic). The computed eigenvectors '
      + 'are normalized to have Euclidean norm equal to 1 and '
      + 'largest component real and are stored in the rows of '
      + 'the VL and VR matrices. If "Vector Form" is vfSchur '
      + 'then  user defined balance will be used to find eigenvalues '
      + 'eigenvectors (check help file for more on this topic)');
    Add('');

    Add('Balance');
    Add('Balancing the matrix can be very useful when calculating the '
      + 'eigenvalues and eigenvector. Balancing operation can perform '
      + 'one or both of the following similarity transformations:');
    Add('1) Permutation, 2) Similarity transformation.');
    Add('');
    Add('Try changing A matrix values, "Vector Form"  and (optionally) '
      +'"Balance". The "Left" and "Right" buttons show left and right '
      + '(check help for more info on this topic) eigenvectors.');
  end;
  A.SetIt(4,4,false,[1  ,  -3,    5,  -3,
                     -1 ,  12,  0.3, 2.5,
                     5  ,1.22, 2.33,-0.5,
                     2.4,  -1,    5,   3]);


  {$IFDEF D20}
  StringGrid1.Options := StringGrid1.Options - [TGridOption.Header];
  StringGrid2.Options := StringGrid2.Options - [TGridOption.Header];
  StringGrid4.Options := StringGrid4.Options - [TGridOption.Header];
  {$ELSE}
  StringGrid1.ShowHeader := False;
  StringGrid2.ShowHeader := False;
  StringGrid4.ShowHeader := False;
  {$ENDIF}

  StringGrid4.RowCount := A.Rows + 1;
  SetGridColumnCount(StringGrid4,A.Cols + 1);
  ValuesToGrid(A,StringGrid4,0,0,' 0.000;-0.000');

  EigButtonChange(nil);
  NoneButtonChange(nil);
end;

procedure TEigVec1.NoneButtonChange(Sender: TObject);
begin
   if NoneButton.IsChecked  then BalanceIndex := 0;
   if ScaleButton.IsChecked then BalanceIndex := 1;
   if PermButton.IsChecked  then BalanceIndex := 2;
   if FullButton.IsChecked  then BalanceIndex := 3;

   Case BalanceIndex of
    0: Bal := btNone;
    1: Bal := btScale;
    2: Bal := btPerm;
    3: Bal := btFull;
  end;
end;

procedure TEigVec1.Button1Click(Sender: TObject);
var MtxType: TMtxType;
begin
    EigL.Size(0,0);
    EigR.Size(0,0);
    EigValues.Size(0);

    { get values for A }
    GridToValues(A,StringGrid4);
    MtxType := A.DetectMtxType;
    { find eigenvalues and eigenvectors }
    A.Balance := Bal;
    A.Eig(EigL,EigValues,EigR,MtxType,VecForm);
    { write results to grids,
      write eigenvalues as diagonal matrix }
    StringGrid2.RowCount := EigValues.Length + 1;

    SetGridColumnCount(StringGrid2, 3);
    StringGrid2.Cells[0,0] := 'D 4x1';

    ValuesToGrid(EigValues,StringGrid2,0,0,'0.000E+00');

    If SpeedButton1.IsPressed then SpeedButton1Click(SpeedButton1)
    else SpeedButton2Click(SpeedButton2);
end;

procedure TEigVec1.SpeedButton1Click(Sender: TObject);
begin
  StringGrid1.RowCount := EigL.Rows + 1;
  if not EigR.Complex then SetGridColumnCount(StringGrid1, EigL.Cols + 1)
                      else SetGridColumnCount(StringGrid1, EigL.Cols*2 + 1);

  ValuesToGrid(EigL,StringGrid1,0,0,'0.000E+00');
  StringGrid1.Cells[0,0] := 'VL 4x4';
end;

procedure TEigVec1.SpeedButton2Click(Sender: TObject);
begin
  StringGrid1.RowCount := EigR.Rows + 1;
  if not EigR.Complex then SetGridColumnCount(StringGrid1, EigR.Cols + 1)
                      else SetGridColumnCount(StringGrid1, EigR.Cols*2 + 1);

  ValuesToGrid(EigR,StringGrid1,0,0,'0.000E+00');
  StringGrid1.Cells[0,0] := 'VR 4x4';
end;

initialization
  RegisterClass(TEigVec1);

end.
