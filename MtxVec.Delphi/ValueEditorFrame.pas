unit ValueEditorFrame;

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
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,  Math387, MtxVec, FmxMtxComCtrls, MtxParseClass,
  FMX.Controls.Presentation, FMX.Grid.Style, FMX.ScrollBox;



type
  TfrmValueEditor = class(TFrame)
    RadioGroup1: TPanel;
    GroupBox1: TGroupBox;
    btnOk: TButton;
    btnCancel: TButton;
    pnlDoubleEditor: TPanel;
    edtDouble: TMtxFloatEdit;
    pnlComplexEditor: TPanel;
    edtReal: TMtxFloatEdit;
    pnlVectorEditor: TPanel;
    Label1: TLabel;
    grdVector: TStringGrid;
    cbVecComplex: TCheckBox;
    pnlMatrixEditor: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    grdMatrix: TStringGrid;
    cbMtxComplex: TCheckBox;
    btnLoadVector: TSpeedButton;
    btnSaveVector: TSpeedButton;
    btnLoadMatrix: TSpeedButton;
    btnSaveMatrix: TSpeedButton;
    edtImage: TMtxFloatEdit;
    Label4: TLabel;
    Label5: TLabel;
    odLoadVector: TOpenDialog;
    odLoadMatrix: TOpenDialog;
    sdSaveVector: TSaveDialog;
    sdSaveMatrix: TSaveDialog;
    edtLen: TMtxFloatEdit;
    edtRows: TMtxFloatEdit;
    edtCols: TMtxFloatEdit;
    Label6: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    procedure RadioGroup1Click(Sender: TObject);
    procedure edtLenExit(Sender: TObject);
    procedure edtLenKeyPress(Sender: TObject; var Key: Char);
    procedure edtRowsExit(Sender: TObject);
    procedure edtRowsKeyPress(Sender: TObject; var Key: Char);
    procedure btnLoadVectorClick(Sender: TObject);
    procedure btnSaveVectorClick(Sender: TObject);
    procedure btnLoadMatrixClick(Sender: TObject);
    procedure btnSaveMatrixClick(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private { Private declarations }
    fVR: TValueRec;
    fLastUsedDir: string;
    RadioGroupIndex: integer;
    procedure SetVR(const Value: TValueRec);
    function GetVR: TValueRec;
    procedure PanelChanged;
    procedure ResizeMatrixGrid;
    procedure ResizeVectorGrid;

    function GetSampleValue: TSample;
    procedure SetSampleValue (v: TSample);
    function GetComplexValue: TCplx;
    procedure SetComplexValue (v: TCplx);
    procedure GetVectorValue (vec: TVec);
    procedure SetVectorValue (vec: TVec);
    procedure GetMatrixValue (mtx: TMtx);
    procedure SetMatrixValue (mtx: TMtx);

  public { Public declarations }
    constructor Create (aOwner: TComponent); override;
    property VR: TValueRec read GetVR write SetVR;
  end;

implementation

uses MtxDialogs, MtxVecBase, AbstractMtxVec;

{$R *.FMX}

{ TFrame1 }

constructor TfrmValueEditor.Create(aOwner: TComponent);
begin
  inherited;
  pnlDoubleEditor.Align := TAlignLayout.Client;
  pnlComplexEditor.Align := TAlignLayout.Client;
  pnlVectorEditor.Align := TAlignLayout.Client;
  pnlMatrixEditor.Align := TAlignLayout.Client;
end;

function TfrmValueEditor.GetSampleValue: TSample;
begin
  try
    Result:= Math387.StrToSample (edtDouble.Text);
  except
    if edtDouble.CanFocus then
      edtDouble.SetFocus;
    raise;
  end;
end;

procedure TfrmValueEditor.SetSampleValue(v: TSample);
begin
  edtDouble.Text:= Math387.SampleToStr(v);
end;

function TfrmValueEditor.GetComplexValue: TCplx;
begin
  try
    Result.Re:= Math387.StrToSample (edtReal.Text);
  except
    if edtReal.CanFocus then
      edtReal.SetFocus;
    raise;
  end;
  try
    Result.Im:= Math387.StrToSample (edtImage.Text);
  except
    if edtImage.CanFocus then
      edtImage.SetFocus;
    raise;
  end;
end;

procedure TfrmValueEditor.SetComplexValue(v: TCplx);
begin
  edtReal.Text:= Math387.SampleToStr(v.Re);
  edtImage.Text:= Math387.SampleToStr(v.Im);
end;

procedure InvalidCellValue (grd: TStringGrid; row,col: integer);
begin
//  grd.Row:= row;
//  grd.Col:= col;
//  if grd.CanFocus then
//    grd.SetFocus;
//  grd.EditorMode:= TRUE;
end;

procedure TfrmValueEditor.GetVectorValue (vec: TVec);
var
  i: integer;
begin
  vec.Size (edtLen.IntPosition, cbVecComplex.IsChecked);
  for i:= 0 to edtLen.IntPosition-1 do begin
    try
      if cbVecComplex.IsChecked then
        vec.CValues1D[i]:= Math387.StrToCplx(grdVector.Cells[0,i])
      else
        vec.Values1D[i]:= Math387.StrToSample(grdVector.Cells[0,i]);
    except
      InvalidCellValue (grdVector, i, 0);
      raise;
    end;
  end;
end;

procedure TfrmValueEditor.SetVectorValue(vec: TVec);
var
  i: integer;
begin
  if Assigned(vec) then begin
    edtLen.IntPosition:= vec.Length;
    cbVecComplex.IsChecked:= vec.Complex;
    grdVector.RowCount:= vec.Length;

    for i:= 0 to vec.Length-1 do
      if vec.Complex then
        grdVector.Cells[0,i]:= Math387.CplxToStr(vec.CValues[i])
      else
        grdVector.Cells[0,i]:= Math387.SampleToStr(vec.Values[i]);

  end else begin
    edtLen.IntPosition:= 0;
    cbVecComplex.IsChecked:= FALSE;
    grdVector.RowCount:= 0;
    grdVector.Cells[0,0]:= '';
  end;
end;

procedure TfrmValueEditor.GetMatrixValue(mtx: TMtx);
var
  i,j: integer;
begin
  mtx.Size (edtRows.IntPosition, edtCols.IntPosition, cbMtxComplex.IsChecked);
  for i:= 0 to edtRows.IntPosition-1 do begin
    for j:= 0 to edtCols.IntPosition-1 do begin
      try
        if cbMtxComplex.IsChecked then
          mtx.CValues[i,j]:= Math387.StrToCplx (grdMatrix.Cells[j,i])
        else
          mtx.Values[i,j]:= Math387.StrToSample (grdMatrix.Cells[j,i]);
      except
        InvalidCellValue (grdMatrix, i, j);
        raise;
      end;
    end;
  end;
end;

procedure SetGridColumnCount(aGrid: TStringGrid; Count: integer);
var i: integer;
begin
    for i := aGrid.ColumnCount to Count-1 do
         aGrid.AddObject(TStringColumn.Create(aGrid));

    for i := aGrid.ColumnCount downto Count-1 do
    begin
         {$IFDEF AUTOREFCOUNT}
         aGrid.RemoveObject(aGrid.Columns[i]);
         {$ELSE}
         aGrid.Columns[i].Free;
         {$ENDIF}
    end;
end;

procedure TfrmValueEditor.SetMatrixValue(mtx: TMtx);
var
  i,j: integer;
begin
  if Assigned(mtx) then begin
    edtRows.IntPosition:= mtx.Rows;
    edtCols.IntPosition:= mtx.Cols;
    cbMtxComplex.IsChecked:= mtx.Complex;
    grdMatrix.RowCount:= mtx.Rows;
     SetGridColumnCount(grdMatrix,  mtx.Cols);

    for i:= 0 to mtx.Rows-1 do
      for j:= 0 to mtx.Cols-1 do
        if mtx.Complex then
          grdMatrix.Cells[j,i]:= Math387.CplxToStr(mtx.CValues[i,j])
        else
          grdMatrix.Cells[j,i]:= Math387.SampleToStr(mtx.Values[i,j]);

  end else begin
    edtRows.IntPosition:= 0;
    edtCols.IntPosition:= 0;
    cbMtxComplex.IsChecked:= FALSE;
    grdMatrix.RowCount:= 0;
    SetGridColumnCount(grdMatrix, 0);
  end;
end;


function TfrmValueEditor.GetVR: TValueRec;
begin
  case RadioGroupIndex of
    0: begin
         fVR.Undefine;
       end;
    1: begin
         fVR.DefineDouble;
         fVR.DoubleValue:= GetSampleValue;
       end;
    2: begin
         fVR.DefineComplex;
         fVR.ComplexValue:= GetComplexValue;
       end;
    3: begin
         fVR.DefineVector;
         GetVectorValue (fVR.VectorValue);

       end;
    4: begin
         fVR.DefineMatrix;
         GetMatrixValue (fVR.MatrixValue);
       end;
  end;

  Result:= fVR;
end;

procedure TfrmValueEditor.SetVR (const Value: TValueRec);
begin
  fVR:= Value;

  if fVR.ValueType in [vtDoubleValue..vtMatrixValue] then
    RadioGroupIndex:= Ord(fVR.ValueType)
  else
    RadioGroupIndex:= 0; // undefined

  SetSampleValue (fVR.DoubleValue);
  SetComplexValue (fVR.ComplexValue);
  SetVectorValue (fVR.VectorValue);
  SetMatrixValue (fVR.MatrixValue);
  PanelChanged;
end;

procedure TfrmValueEditor.PanelChanged;
begin
    pnlDoubleEditor.Visible:= RadioGroupIndex = 1;
    pnlComplexEditor.Visible:= RadioGroupIndex = 2;
    pnlVectorEditor.Visible:= RadioGroupIndex = 3;
    pnlMatrixEditor.Visible:= RadioGroupIndex = 4;
end;

procedure TfrmValueEditor.RadioButton1Change(Sender: TObject);
begin
    if Sender = Radiobutton1 then RadioGroupIndex := 0;
    if Sender = Radiobutton2 then RadioGroupIndex := 1;
    if Sender = Radiobutton3 then RadioGroupIndex := 2;
    if Sender = Radiobutton4 then RadioGroupIndex := 3;
    if Sender = Radiobutton5 then RadioGroupIndex := 4;
end;

procedure TfrmValueEditor.RadioGroup1Click(Sender: TObject);
begin
  PanelChanged;
end;

procedure TfrmValueEditor.ResizeVectorGrid;
var
  i: integer;
begin
  if not TryStrToInt (edtLen.Text, i) or (i < 0) then
    raise Exception.Create ('Vector length must be >= 0');

  grdVector.RowCount:= edtLen.IntPosition;
end;

procedure TfrmValueEditor.ResizeMatrixGrid;
var
  i: integer;
begin
  if not TryStrToInt (edtRows.Text, i) or (i < 0) then
    raise Exception.Create ('Rows number must be >= 0');

  if not TryStrToInt (edtCols.Text, i) or (i < 0) then
    raise Exception.Create ('Columns number must be >= 0');

  grdMatrix.RowCount:= edtRows.IntPosition;
  SetGridColumnCount(grdMatrix, edtCols.IntPosition);
end;

procedure TfrmValueEditor.edtLenExit(Sender: TObject);
begin
  ResizeVectorGrid;
end;

procedure TfrmValueEditor.edtLenKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    ResizeVectorGrid;
    Key:= #0;
  end;
end;

procedure TfrmValueEditor.edtRowsExit(Sender: TObject);
begin
  ResizeMatrixGrid;
end;

procedure TfrmValueEditor.edtRowsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    ResizeMatrixGrid;
    Key:= #0;
  end;
end;

procedure TfrmValueEditor.btnLoadVectorClick(Sender: TObject);
var
  vec: TVec;
begin
  CreateIt (vec);
  try
    odLoadVector.InitialDir:= fLastUsedDir;
    if not odLoadVector.Execute then
      Abort;

    fLastUsedDir:= ExtractFilePath (odLoadVector.FileName);
    
    vec.LoadFromFile (odLoadVector.FileName);
    SetVectorValue (vec);
  finally
    FreeIt(vec);
  end;
end;

procedure TfrmValueEditor.btnSaveVectorClick(Sender: TObject);
var
  vec: TVec;
begin
  CreateIt (vec);
  try
    sdSaveVector.InitialDir:= fLastUsedDir;
    if not sdSaveVector.Execute then
      Abort;

    fLastUsedDir:= ExtractFilePath (sdSaveVector.FileName);

    GetVectorValue (vec);
    vec.SaveToFile (sdSaveVector.FileName);
  finally
    FreeIt(vec);
  end;
end;

procedure TfrmValueEditor.btnLoadMatrixClick(Sender: TObject);
var
  mtx: TMtx;
begin
  CreateIt (mtx);
  try
    odLoadMatrix.InitialDir:= fLastUsedDir;
    if not odLoadMatrix.Execute then
      Abort;
    fLastUsedDir:= ExtractFilePath (odLoadMatrix.FileName);

    mtx.LoadFromFile (odLoadMatrix.FileName);
    SetMatrixValue (mtx);
  finally
    FreeIt (mtx);
  end;
end;

procedure TfrmValueEditor.btnSaveMatrixClick(Sender: TObject);
var
  mtx: TMtx;
begin
  CreateIt (mtx);
  try
    sdSaveMatrix.InitialDir:= fLastUsedDir;
    if not sdSaveMatrix.Execute then
      Abort;

    fLastUsedDir:= ExtractFilePath (sdSaveMatrix.FileName);

    GetMatrixValue (mtx);
    mtx.SaveToFile (sdSaveMatrix.FileName);
  finally
    FreeIt (mtx);
  end;
end;

end.
