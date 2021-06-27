unit LQR1;

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
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  Basic2,
  MtxVec, Math387, FmxMtxVecEdit, MtxExpr, PlatformHelpers;



type
  TLQRDemo = class(TBasicForm2)
    RadioGroup1: TPanel;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    A,L,Q,R,tmpM1,tmpM2, tmpM3: Matrix;
    S       : Vector;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  LQRDemo: TLQRDemo;

implementation

Uses MtxDialogs;

{$R *.FMX}

procedure RefreshGrid(AStringGrid: TStringGrid; Mtx: TMtx);
begin
  AStringGrid.RowCount := Mtx.Rows+1;
  SetGridColumnCount(AStringGrid,  Mtx.Cols+1);
  AStringGrid.Width := (AStringGrid.ColumnCount) * 100 + 10;
  AStringGrid.Height := (AStringGrid.RowCount) * 28 + 10;

  ValuesToGrid(Mtx,AStringGrid,0,0);
  AStringGrid.Cells[0,0] := Mtx.Caption;
end;

procedure TLQRDemo.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('MtxVec offers several methods for matrix decomposition. '
      + 'If matrix is squared, then LU decomposition can be used. '
      + 'If this is not the case (number of rows <> number of columns) '
      + 'then either LQ,QR, or SVD decomposition method can be used. '
      + 'All these methods are used extensively for solving system of '
      + 'linear equations (LUSolve, LQRSolve, SVDSolve). In this example '
      + 'the following decompositions are demonstrated.');
    Add('');


    Add('LQ decomposition : Mtx.Rows < Mtx.Cols;  Mtx = L*Q; Mtx must have full rank');
    Add('QR decomposition : Mtx.Rows > Mtx.Cols; Mtx = Q*R; Mtx must have full rank');
    Add('SVD decomposition : Mtx = U*S*V''; Mtx does not have full rank'+#10+#13);



    Add('');
    Add('The "Economy size" checkbox indicates economy size matrices will be calculated. '
      + 'For more on this check the help file.');
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

  S.Caption := 'Singular values';
  A.Size(0,0);
  L.Size(0,0);
  Q.Size(0,0);
  R.Size(0,0);

  RadioButton1Change(RadioButton1);
end;

procedure TLQRDemo.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then
  begin
       A.Size(2,4);
       A.RandUniform(2,10);
       Button3.Text := 'LQ = A ? ';
  end else if Sender = RadioButton2 then
  begin
       A.Size(3,2);
       A.RandUniform(-10,-3);
       Button3.Text := 'QR = A ? ';
  end else if Sender = RadioButton3 then
  begin
       A.Size(2,4);
       A.RandUniform(2,10);
       A.SetZero(0,0,1,0);
       Button3.Text := 'USV'+''''+' = A ? ';
  end else if Sender = RadioButton4 then
  begin
       A.Size(3,2);
       A.RandUniform(2,10);
       A.SetZero(0,0,0,1);
       Button3.Text := 'USV'+''''+' = A ? ';
  end;
  Button3.Enabled := false;
  Button2.Enabled := false;
  A.Caption := 'A '+IntToStr(A.Rows)+'x'+IntToStr(A.Cols);
  RefreshGrid(StringGrid1,A);
end;

procedure TLQRDemo.Button1Click(Sender: TObject);
begin
  RefreshGrid(StringGrid1,A);
  if RadioButton1.IsChecked then
    begin
       A.LQR(L,Q,nil,CheckBox1.IsChecked);
       L.Caption := 'L';
       Q.Caption := 'Q';
       RefreshGrid(StringGrid2,L);
       RefreshGrid(StringGrid3,Q);
    end
  else if RadioButton2.IsChecked then
    begin
       A.LQR(nil,Q,R,CheckBox1.IsChecked);
       R.Caption := 'R';
       Q.Caption := 'Q';
       RefreshGrid(StringGrid2,Q);
       RefreshGrid(StringGrid3,R);
    end
  else if RadioButton3.IsChecked then
    begin
       Button2.Enabled := true;
       A.SVD(L,S,Q,CheckBox1.IsChecked);
       L.Caption := 'U';
       Q.Caption := 'V';
       RefreshGrid(StringGrid2,L);
       RefreshGrid(StringGrid3,Q);
    end
  else if RadioButton4.IsChecked then
    begin
       Button2.Enabled := true;
       A.SVD(L,S,Q,CheckBox1.IsChecked);
       L.Caption := 'U';
       Q.Caption := 'V';
       RefreshGrid(StringGrid2,L);
       RefreshGrid(StringGrid3,Q);
    end;
  Button3.Enabled := true;
  StringGrid3.Position.X := StringGrid2.Position.X + StringGrid2.Width + 10;
end;

procedure TLQRDemo.Button2Click(Sender: TObject);
begin
  { Q.Cols because we are multiplying with V' }
  tmpM1.Size(L.Cols,Q.Cols,S.Complex); {  D size }

  tmpM1.SetZero;
  tmpM1.Diag(S,0);
  ViewValues(tmpM1,'Singular values',true);
end;

procedure TLQRDemo.Button3Click(Sender: TObject);
begin
  if RadioButton1.IsChecked then
    begin
         tmpM2.Mul(L,Q,opNone);
         ViewValues(tmpM2,'LQ = A ?',true);
    end
  else if RadioButton2.IsChecked then
    begin
        tmpM2.Mul(Q,R,opNone);
        ViewValues(tmpM2,'QR = A ?',true);
    end
  else if (RadioButton3.IsChecked or RadioButton4.IsChecked) then
    begin
         { Q.Cols because we are multiplying with V' }
         { First, calculate S  }
         tmpM1.Size(L.Cols,Q.Cols,S.Complex);
         tmpM1.SetZero;
         tmpM1.Diag(S,0);
         { Multiply S by V'=Q' }
         tmpM2.Mul(tmpM1,Q,opNone,opTran);
         { Multiply from left by U=L }
         tmpM3.Mul(L,tmpM2,opNone);
         ViewValues(tmpM3,'U*S*V'+''''+' = A ?',true);
    end;
end;

constructor TLQRDemo.Create(AOwner: TComponent);
begin
  inherited;
  FormCreate(Self);
end;

initialization
   RegisterClass(TLQRDemo);

end.
