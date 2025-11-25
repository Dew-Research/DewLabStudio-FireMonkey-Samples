unit ScriptingGrid;

interface


uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IniFiles,
  System.Rtti,
  FMX.Types,
  FMX.Grid.Style,
  FMX.Graphics,
  FMX.Memo,
  FMX.Objects,
  FMX.Memo.Types,
  FMX.Forms,
  FMX.StdCtrls,
  FMX.DialogService,
  FMX.TextLayout,
  FMX.Memo.Style,
  FMXTee.Engine,
  FMXTee.Series,
//  FMXTee.Procs,
  FMXTee.Chart,
  FMX.ScrollBox,
  FMX.Grid,
  FMX.Controls,
  FMX.TabControl,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Edit,
  FMX.Text,
  FMX.Controls.Presentation,
  Math387,
  MtxParseExpr,
  MtxParseClass,
  ExprToolTipUnit, FmxMtxGrid, FMXTee.Procs;

type

  TScriptingGridForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter2: TSplitter;
    Label1: TLabel;
    Splitter3: TSplitter;
    StatusBar: TStatusBar;
    ScriptLabel: TLabel;
    ScriptBox: TComboBox;
    Panel4: TPanel;
    Panel5: TPanel;
    PageControl: TTabControl;
    Sheet1: TTabItem;
    Sheet2: TTabItem;
    RunButton: TButton;
    ChartTab: TTabItem;
    Chart1: TChart;
    Chart2: TChart;
    Splitter5: TSplitter;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    ResetButton: TButton;
    StepButton: TButton;
    SaveAsButton: TButton;
    DeleteScriptButton: TButton;
    GridInsertScriptButton: TButton;
    GridAssignScriptButton: TButton;
    Bevel1: TPanel;
    Panel8: TPanel;
    Label3: TLabel;
    WorkspaceBox: TComboBox;
    SaveWorkButton: TButton;
    DeleteWorkButton: TButton;
    Splitter6: TSplitter;
    ResetWorkspaceButton: TButton;
    Bevel2: TPanel;
    Label2: TLabel;
    VarView: TStringGrid;
    ScriptEdit: TMemo;
    StatusLabel: TLabel;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    ListBox: TStringGrid;
    HistoryCmdColumn: TStringColumn;
    TextTab: TTabItem;
    RichEdit: TMemo;
    Panel6: TPanel;
    ExprEdit: TEdit;
    GridInsertEditButton: TButton;
    GridAssignEditButton: TButton;
    Grid1: TStringGrid;
    Grid2: TStringGrid;
    Panel3: TPanel;
    LineLabel: TLabel;
    Panel7: TPanel;
    LiveButton: TButton;
    SaveButton: TButton;
    NewButton: TButton;
    BackPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VarViewMouseEnter(Sender: TObject);
    procedure ListBoxMouseEnter(Sender: TObject);
    procedure RichEditMouseEnter(Sender: TObject);
    procedure ExprEditMouseEnter(Sender: TObject);
    procedure ScriptBoxChange(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure StepButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure AssignButtonClick(Sender: TObject);
    procedure EditModeButtonClick(Sender: TObject);
    procedure Grid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveAsButtonClick(Sender: TObject);
    procedure DeleteScriptButtonClick(Sender: TObject);
    procedure GridInsertScriptButtonClick(Sender: TObject);
    procedure GridAssignScriptButtonClick(Sender: TObject);
    procedure GridInsertEditButtonClick(Sender: TObject);
    procedure GridAssignEditButtonClick(Sender: TObject);
    procedure SaveWorkButtonClick(Sender: TObject);
    procedure DeleteWorkButtonClick(Sender: TObject);
    procedure WorkspaceBoxChange(Sender: TObject);
    procedure ResetWorkspaceButtonClick(Sender: TObject);
    procedure ExprEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Grid1SelChanged(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Grid1DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure Grid2DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure Grid2SelChanged(Sender: TObject);
    procedure Grid1SelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Panel6Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure FormResize(Sender: TObject);
    procedure ListBoxCellDblClick(const Column: TColumn; const Row: Integer);
    procedure ListBoxCellClick(const Column: TColumn; const Row: Integer);
    procedure VarViewCellDblClick(const Column: TColumn; const Row: Integer);
    procedure ScriptEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ScriptEditMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ScriptEditMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure ScriptEditPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure LiveButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
  private
    procedure EvaluateExpression;
    procedure SetupGrids;
    procedure SetupGrid(const aGrid: TStringGrid);

    procedure DoSetGrid1(const Sender: TExprGridVariable; const Src: string; const row, col: integer);
    procedure DoSetGrid2(const Sender: TExprGridVariable; const Src: string; const row, col: integer);
    procedure DoGetGrid1(const Sender: TExprGridVariable; var Dst: string; const row, col: integer);
    procedure DoGetGrid2(const Sender: TExprGridVariable; var Dst: string; const row, col: integer);
    procedure PopulateScriptList;
    function GridSelection: string;
    function GridSelectionValues: string;
    procedure SaveWorkspace(const dst: TExprWorkspace; const dstName: string);
    procedure DefineCustomValues;
    function ScriptEditActiveLine: integer;
    procedure GridClear(const Src: TStringGrid);
    procedure UpdateHistoryBox;
    procedure DefineUserVars;
    procedure UpdateVarView;
    { Private declarations }
  public
    WorkspaceIndex: integer;
    Editing: boolean;
    { Public declarations }
    Expr: TMtxExpression;
    grid1var: TExprGridVariable;
    grid2var: TExprGridVariable;
    mtxToolTip: TExprToolTipForm;
    HistoryList: TStringList;
    IsShift: boolean;
    Grid1Selection, Grid2Selection: TRect;
    StatusBarColor: TAlphaColor;
    LContext: TRttiContext;
    ScriptEditStyled: IControl;
    ScriptStepping: boolean;
    UserVars: TStringList;
    procedure SilentRun;
  end;

//  TStyledMemoCrack = class(TStyledMemo)
//  public
//      function CaretPos(X,Y: Single; var LineHeight: single): TCaretPosition;
//  end;

  procedure _drawvalues5(const Param: TExprRec);
  procedure _drawvalues4(const Param: TExprRec);

var
  ScriptingGridForm: TScriptingGridForm;

implementation

uses MtxVec, MtxExpr, FmxMtxVecEdit,  FmxMtxVecTee, StringVar, AbstractMtxVec, HintUnit, MtxVecBase,
     MtxVecInt, AbstractMtxVecInt, Main;

{$R *.FMX}

procedure TScriptingGridForm.UpdateHistoryBox;
var i: integer;
begin
    ListBox.RowCount := HistoryList.Count;
    for i := 0 to HistoryList.Count-1 do ListBox.Cells[0,i] := HistoryList[i];
end;

procedure TScriptingGridForm.GridClear(const Src: TStringGrid);
begin
    Src.RowCount := 0;
end;

procedure TScriptingGridForm.UpdateVarView;
var i: Integer;
    aVarList: TStringList;
    aVar: TValueRec;
begin
    aVarList:= TStringList.Create;
    Expr.GetVarList(aVarList);
    VarView.RowCount := aVarList.Count;
    for i := 0 to aVarList.Count - 1 do
    begin
        varView.Cells[0, i] := aVarList[i];
        aVar := Expr.VarByName[aVarList[i]];
        varView.Cells[1, i] := ValTypeAsStr[avar.ValueType];
        case aVar.ValueType of
        vtString:      varView.Cells[2, i] := aVar.StringValue;
        vtIntegerValue:varView.Cells[2, i] := IntToStr(aVar.IntegerValue);
        vtBoolValue:   varView.Cells[2, i] :=  BoolToStr(aVar.BoolValue, true);
        vtRangeValue:  begin
                          if aVar.ExtRange then
                          begin
                              case aVar.ExtRangeValue.Length of
                              2: varView.Cells[2, i] := SampleToStr(aVar.ExtRangeValue[0]) + ':' + SampleToStr(aVar.ExtRangeValue[1]);
                              3: varView.Cells[2, i] := SampleToStr(aVar.ExtRangeValue[0]) + ':' + SampleToStr(aVar.ExtRangeValue[1]) + ':' + SampleToStr(aVar.ExtRangeValue[2]);
                              end;
                          end else
                          begin
                              case Length(aVar.fRange) of
                              2: varView.Cells[2, i] := IntToStr(aVar.fRange[0]) + ':' + IntToStr(aVar.fRange[1]);
                              3: varView.Cells[2, i] := IntToStr(aVar.fRange[0]) + ':' + IntToStr(aVar.fRange[1]) + ':' + IntToStr(aVar.fRange[2]);
                              end;
                          end;
                       end;
        vtCustomValue: varView.Cells[2, i] := aVar.CustomValue.ClassName;
        vtDoubleValue: varView.Cells[2, i] := SampleToStr(aVar.DoubleValue);
        vtComplexValue:varView.Cells[2, i] := CplxToStr(aVar.ComplexValue);
        vtVectorValue: varView.Cells[2, i] := '1x' + IntToStr(aVar.VectorValue.Length);
        vtMatrixValue: varView.Cells[2, i] := IntToStr(aVar.MatrixValue.Rows)+ 'x' +
                                              IntToStr(aVar.MatrixValue.Cols);
        vtIntVectorValue: varView.Cells[2, i] := '1x' + IntToStr(aVar.IntVectorValue.Length);
        vtIntMatrixValue: varView.Cells[2, i] := IntToStr(aVar.IntMatrixValue.Rows)+ 'x' +
                                                 IntToStr(aVar.IntMatrixValue.Cols);
        vtBoolVectorValue: varView.Cells[2, i] := '1x' + IntToStr(aVar.BoolVectorValue.Length);
        vtBoolMatrixValue: varView.Cells[2, i] := IntToStr(aVar.BoolMatrixValue.Rows)+ 'x' +
                                                  IntToStr(aVar.BoolMatrixValue.Cols);

        end;
    end;
end;

procedure TScriptingGridForm.VarViewCellDblClick(const Column: TColumn; const Row: Integer);
var a: TValueRec;
    varName: string;
begin
   varName := VarView.Cells[0, Row];
   a := Expr.VarByName[varName];
   case a.ValueType of
   vtBoolVectorValue: ViewValues(a.BoolVectorValue, varName);
   vtIntVectorValue: ViewValues(a.IntVectorValue, varName);
   vtVectorValue:    ViewValues(a.VectorValue, varName);
   vtBoolMatrixValue: ViewValues(a.BoolMatrixValue, varName);
   vtIntMatrixValue: ViewValues(a.IntMatrixValue, varName);
   vtMatrixValue:    ViewValues(a.MatrixValue, varName);
   end;
end;

procedure TScriptingGridForm.VarViewMouseEnter(Sender: TObject);
begin
    StatusLabel.Text := 'Double click vector or matrix to examine the values';
end;

procedure TScriptingGridForm.LiveButtonClick(Sender: TObject);
var i: integer;
begin
    if LiveButton.IsPressed then
    begin
        try
            try
                Expr.ClearExpressions;
                for i := 0 to ScriptEdit.Lines.Count-1 do Expr.AddExpr(ScriptEdit.Lines[i]);
                Expr.Compile;
            except
                on E: Exception do
                begin
                    LiveButton.Pressed := False;

                    RichEdit.Lines.Add('');
                    RichEdit.Lines.Add(E.Message);
                    Expr.ClearExpressions;

                    ScriptStepping := false;
                end;
            end;
        finally
            UpdateVarView;
        end;
    end else
    begin
        //
    end;
end;

procedure TScriptingGridForm.NewButtonClick(Sender: TObject);
begin
    TDialogService.InputQuery('Create new script',['Please specify script name'],['aScript'],
              procedure(const AResult: TModalResult; const AValues: array of string)
              var aScript: TStringList;
              begin
                  aScript := TStringList.Create;
                  ScriptBox.ItemIndex := ScriptBox.Items.AddObject(aValues[0], aScript);
                  Focused := ScriptEdit;
              end
             );
end;

procedure TScriptingGridForm.SilentRun; //same as run, but printing only error and stopping live if error
//var a: TValueRec;
begin
    if LiveButton.IsPressed then
    begin
        try
            try
                Expr.EvaluateCompiled;
            except
                on E: Exception do
                begin
                    LiveButton.Pressed := False;

                    RichEdit.Lines.Add('');
                    RichEdit.Lines.Add(E.Message);
                    Expr.ClearExpressions;
                end;
            end;

        finally
            UpdateVarView;
            ScriptStepping := false;
        end;
    end;
end;

procedure TScriptingGridForm.RunButtonClick(Sender: TObject);
var a: TValueRec;
    i: integer;
    a2: double;
begin
    a2 := 0;
    Expr.ClearExpressions;
    for i := 0 to ScriptEdit.Lines.Count-1 do Expr.AddExpr(ScriptEdit.Lines[i]);
    try
        try
            Expr.Compile;
            StartTimer;
            a := Expr.EvaluateCompiled;
            a2 := StopTimer;
            expr.VarPrint(a, Expr.EvaluatedVarName(0), RichEdit.Lines);
        except
            on E: Exception do
            begin
                RichEdit.Lines.Add('');
                RichEdit.Lines.Add(E.Message);
                Expr.ClearExpressions;
            end;
        end;

    finally
        RichEdit.Lines.Add('');
        RichEdit.Lines.Add('Elapsed time: ' + FormatSample('0.0000s',a2) + ', sizeof(TSample) = ' + IntToStr(sizeof(TSample)));
        UpdateVarView;
        ScriptStepping := false;
        Focused := ScriptEdit;
    end;
end;


procedure TScriptingGridForm.EvaluateExpression;
var a: TValueRec;
  aCmd: string;
  i: Integer;
  funcList, hlpList: StringList;
begin
    richEdit.Lines.BeginUpdate;
    try
        Expr.ClearExpressions;
        aCmd := Trim(ExprEdit.Text);
        if aCmd = 'cls' then
        begin
            RichEdit.Lines.Clear;
            RichEdit.Lines.Add('');
            ExprEdit.Text := '';
            Exit;
        end else
        if aCmd = 'clear' then
        begin
            Expr.ClearAll;
            RichEdit.Lines.Clear;
            RichEdit.Lines.Add('');
            ExprEdit.Text := '';
            GridClear(ListBox);
            GridClear(VarView);
            Exit;
        end else
        if aCmd = 'help' then
        begin
            Expr.GetFuncList(TStringList(funcList), TStringList(hlpList), true);
            RichEdit.Lines.Add('');
            RichEdit.Lines.Add('Function listing:');
            RichEdit.Lines.Add('');
            for i := 0 to hlpList.Count - 1 do
                RichEdit.Lines.Add(hlpList[i]);

            Expr.GetOperList(TStringList(funcList), TStringList(hlpList));
            RichEdit.Lines.Add('');
            RichEdit.Lines.Add('Operator listing:');
            RichEdit.Lines.Add('');
            for i := 0 to hlpList.Count - 1 do
                RichEdit.Lines.Add(hlpList[i]);
            RichEdit.Lines.Add('');

            if ExprEdit.Text <> '' then
            begin
                 if HistoryList.IndexOf(ExprEdit.Text) < 0 then
                 begin
                     HistoryList.Add(ExprEdit.Text);
                     UpdateHistoryBox;
                     ListBox.Row := HistoryList.count-1; //check the index
                 end;
                 ExprEdit.Text := '';
            end;
            Exit;
        end;

        try
            Expr.AddExpr(ExprEdit.Text);
            a := Expr.Evaluate;

            RichEdit.Lines.Add('');
            RichEdit.Lines.Add('> ' + ExprEdit.Text);
            RichEdit.Lines.Add('');

            RichEdit.Lines.Add('');
            if not TerminatedWithSemicolon(ExprEdit.Text) then
                expr.VarPrint(a, Expr.EvaluatedVarName(0), RichEdit.Lines);

            UpdateVarView;

            Expr.ClearExpressions;
        except
            on E: Exception do
            begin
                RichEdit.Lines.Add(acmd + ' :');
                RichEdit.Lines.Add(E.Message);
                RichEdit.Lines.Add('');
                Expr.ClearExpressions;
                Exit;
            end;
        end;
    finally
       richEdit.Lines.EndUpdate;
       richEdit.GoToTextEnd;
    end;

    if ExprEdit.Text <> '' then
    begin
        i := HistoryList.IndexOf(ExprEdit.Text);
        if i < 0 then
        begin
            HistoryList.Add(ExprEdit.Text);
            UpdateHistoryBox;
            ListBox.Row := HistoryList.Count-1;
        end else
        begin
           ListBox.Row := i;
        end;
        ExprEdit.Text := '';
    end;
end;

procedure TScriptingGridForm.ExprEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var i: Integer;
begin
    case Key of
    vkUP:  begin
            i := ListBox.Row;
            if (i > 0) and (ExprEdit.Text <> '') then Dec(i);
            ListBox.Row := i;
            ExprEdit.Text := HistoryList[I];
            ExprEdit.SelStart := Length(HistoryList[I]);
            end;
    vkDOWN:begin
            i := ListBox.Row;
            if (i < (ListBox.RowCount-1)) and (ExprEdit.Text <> '') then Inc(i);
            ListBox.Row := i;
            ExprEdit.Text := HistoryList[I];
            ExprEdit.SelStart := Length(HistoryList[I]);
            end;
    vkRETURN: EvaluateExpression;
    end;
end;

procedure TScriptingGridForm.ExprEditMouseEnter(Sender: TObject);
begin
    StatusLabel.Text := 'Type the expression';
end;

procedure TScriptingGridForm.DoSetGrid1(const Sender: TExprGridVariable; const src: string; const row, col: integer);
begin
    Grid1.Cells[col+1, row] := src;
end;

procedure TScriptingGridForm.DoSetGrid2(const Sender: TExprGridVariable; const Src: string; const row, col: integer);
begin
    Grid2.Cells[col+1, row] := src;
end;

procedure TScriptingGridForm.AssignButtonClick(Sender: TObject);
begin
    case PageControl.TabIndex of
    0: ScriptEdit.Text := Format('grid1(%d,%d) = %s', [Grid1.Row-1, Grid1.Col-1, Grid1.Cells[Grid1.Col, Grid1.Row]]);
    1: ScriptEdit.Text := Format('grid2(%d,%d) = %s', [Grid2.Row-1, Grid2.Col-1, Grid2.Cells[Grid2.Col, Grid2.Row]]);
    end;
    ScriptEdit.SelStart := Length(ScriptEdit.Text);
end;

procedure TScriptingGridForm.DoGetGrid1(const Sender: TExprGridVariable; var Dst: string; const row, col: integer);
begin
     Dst := Grid1.Cells[col+1, row];
end;

procedure TScriptingGridForm.DoGetGrid2(const Sender: TExprGridVariable; var dst: string; const row, col: integer);
begin
     Dst := Grid2.Cells[col+1, row];
end;

procedure TScriptingGridForm.SetupGrid(const aGrid: TStringGrid);
var i: integer;
begin
    for i := 0 to 100 do aGrid.AddObject(TStringColumn.Create(aGrid));
    aGrid.RowCount := 100000;

    for i := 0 to aGrid.ColumnCount-1 do aGrid.Columns[i].Width := 90;
    aGrid.Cells[0,0] := aGrid.Name;

    for i := 0 to aGrid.ColumnCount-2 do aGrid.Columns[i+1].Header := IntToStr(i);
    for i := 0 to aGrid.RowCount-1 do aGrid.Cells[0, i] := IntToStr(i);

    aGrid.Model.CellReturnAction := TCellReturnAction.GotoNextRow;
    aGrid.Columns[0].ReadOnly := True;
end;

procedure TScriptingGridForm.SetupGrids;
begin
    SetupGrid(Grid1);
    SetupGrid(Grid2);

    ListBox.Columns[0].Width := ListBox.Width;

    VarView.Columns[0].Width := 60;
    VarView.Columns[1].Width := 120;
    VarView.Columns[2].Width := 300;
end;

function TScriptingGridForm.ScriptEditActiveLine: integer;
begin
    Result := ScriptEdit.CaretPosition.Line;
end;

procedure TScriptingGridForm.ScriptEditKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    LineLabel.Text := 'Line: ' + IntToStr(ScriptEditActiveLine);
end;

procedure TScriptingGridForm.StepButtonClick(Sender: TObject);
var k: integer;
    scriptPresent: boolean;
    cPos: TCaretPosition;
begin
    //check first, if the script was already added to expression parser
    scriptPresent := True;
    if Expr.ExprCount <> ScriptEdit.Lines.Count then
    begin
        scriptPresent := False;
    end else
    for k := 0 to ScriptEdit.Lines.Count-1 do
    begin
        if Expr.Expression[k] <> ScriptEdit.Lines[k] then
        begin
            scriptPresent := false;
            Break;
        end;
    end;

    if not scriptPresent then
    begin
        Expr.ClearExpressions;
        for k := 0 to ScriptEdit.Lines.Count-1 do Expr.AddExpr(ScriptEdit.Lines[k]);
        expr.Compile;
    end;
    //then execute one line

    k := ScriptEditActiveLine;

    if k >= Expr.ExprCount then
    begin
        RichEdit.Lines.Add('The script is past the last line!');
        RichEdit.Lines.Add('');
        Exit;
    end;
    k := Expr.EvaluateStep(k);
    if k >= Expr.ExprCount then
    begin
        RichEdit.Lines.Add('The script has reached the end!');
        RichEdit.Lines.Add('');
        Exit;
    end;

    Focused := ScriptEdit;
    ScriptStepping := True;
    cPos.Line := k;           //Zero-based
    cPos.Pos := 0;

    ScriptEdit.CaretPosition := cPos;
//    ScriptEdit.SelStart := ScriptEdit.PosToTextPos(cPos);
//    ScriptEdit.SelLength := Length(ScriptEdit.Lines[k]);}

    LineLabel.Text := 'Line: ' + IntToStr(ScriptEditActiveLine);

    UpdateVarView;
end;

procedure TScriptingGridForm.EditModeButtonClick(Sender: TObject);
begin
    Editing := not Editing;
//    EditModeButton.IsPressed := Editing;

    if Editing then
    begin
        Grid1.Options := Grid1.Options + [TGridOption.Editing];
        Grid2.Options := Grid2.Options + [TGridOption.Editing];
    end else
    begin
        Grid1.Options := Grid1.Options - [TGridOption.Editing];
        Grid2.Options := Grid2.Options - [TGridOption.Editing];
    end;
end;

procedure TScriptingGridForm.ResetButtonClick(Sender: TObject);
begin
//    k := 0;
//    ScriptEdit.Perform(EM_LINEINDEX, k, 0); //go to line 0
//    ScriptEdit.SelStart :=  ScriptEdit.Perform(EM_LINEINDEX, k, 0);

//    cPos.Line := k;           //Zero-based
//    cPos.Pos := 0;
//    ScriptEdit.SelStart := ScriptEdit.PosToTextPos(cPos);
//    ScriptEdit.SelLength := Length(ScriptEdit.Lines[k]);

    ScriptEdit.CaretPosition := TCaretPosition.Zero;
    Focused := ScriptEdit;
    ScriptStepping := False;
    LineLabel.Text := 'Line: ' + IntToStr(ScriptEditActiveLine);
end;

procedure TScriptingGridForm.ResetWorkspaceButtonClick(Sender: TObject);
begin
    Expr.ClearAll;
    DefineCustomValues;
    DefineUserVars;

    UpdateVarView;
end;

procedure TScriptingGridForm.DefineCustomValues;
begin
   expr.DefineCustomValue('grid1', grid1var);
   expr.DefineCustomValue('grid2', grid2var);

   if Chart1.SeriesCount > 0 then expr.DefineCustomValue('series1', Chart1.Series[0]);
   if Chart2.SeriesCount > 0 then expr.DefineCustomValue('series2', Chart2.Series[0]);
end;

procedure TScriptingGridForm.DefineUserVars;
var i: integer;
begin
    for i := 0 to UserVars.Count-1 do
    begin
        case TMtxVecBase(UserVars.Objects[i]).MtxVecType of
        TMtxVecType.mvTVec:    expr.DefineVector(UserVars[i], TVec(UserVars.Objects[i]));
        TMtxVecType.mvTVecInt: expr.DefineIntVector(UserVars[i], TVecInt(UserVars.Objects[i]));
        TMtxVecType.mvTMtx:    expr.DefineMatrix(UserVars[i], TMtx(UserVars.Objects[i]));
        TMtxVecType.mvTMtxInt: expr.DefineIntMatrix(UserVars[i], TMtxInt(UserVars.Objects[i]));
        end;
    end;
end;

procedure TScriptingGridForm.FormCreate(Sender: TObject);
begin
   UserVars := TStringList.Create(false);

   LContext := TRttiContext.Create;

   HistoryList := TStringList.Create;
//   StyleBookForm := TStyleBookForm.Create(Self);
//   StyleBook := StyleBookForm.

   grid1var := TExprGridVariable.Create;
   grid2var := TExprGridVariable.Create;

   Expr := TMtxExpression.Create;
//   Expr.ConstantsAlwaysReal := True;
//   Expr.SelfTest;

   RichEdit.Lines.Clear;
   ExprEdit.Text := 'clear';
   EvaluateExpression;
   ExprEdit.Text := 'help';
   EvaluateExpression;
   ExprEdit.Text := 'j = -2';
   EvaluateExpression;

   grid1var.OnSetValue := DoSetGrid1;
   grid1var.OnGetValue := DoGetGrid1;

   grid2var.OnSetValue := DoSetGrid2;
   grid2var.OnGetValue := DoGetGrid2;

   DefineCustomValues;

   //define custom functions
   expr.DefineFunction('drawvalues', _drawvalues5, 5, 0, 'drawvalues(vector Y, TChartSeries series, double xOffset, double xStep, boolean pixeldownsample Draws values from Y to second "TChartSeries" custom object.');
   expr.DefineFunction('drawvalues', _drawvalues4, 4, 0, 'drawvalues(vector X, vector Y, TChartSeries series, boolean pixeldownsample Draws values with (X,Y) coordinates to second "TChartSeries" custom object.');

   UpdateVarView;

   WorkspaceIndex := -1;

   PopulateScriptList;
   ScriptBox.ItemIndex := 0;
   Scriptbox.OnChange(Self);

   SetupGrids;
//   VarView.Column[2].Width := 200;
   HintForm := THintForm.Create(Self);
end;

procedure TScriptingGridForm.FormDestroy(Sender: TObject);
var i: integer;
begin
   for i := 0 to ScriptBox.Items.Count-1 do
   begin
       {$IFNDEF AUTOREFCOUNT}
       ScriptBox.Items.Objects[i].Free;
       {$ENDIF}
       ScriptBox.Items.Objects[i] := nil;
   end;


   for i := 0 to WorkSpaceBox.Items.Count-1 do
   begin
       {$IFNDEF AUTOREFCOUNT}
        WorkSpaceBox.Items.Objects[i].Free;
       {$ENDIF}
        WorkSpaceBox.Items.Objects[i] := nil; //for ARC
   end;

   HistoryList.Free;

   Expr.Free;
   grid1var.Free;
   grid2var.Free;

   UserVars.Free;
   LContext.Free;

   VarView.ClearColumns;
   ListBox.ClearColumns;
   Grid1.ClearColumns;
   Grid2.ClearColumns;
end;

procedure TScriptingGridForm.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (ssShift in Shift) then IsShift := True;
end;

procedure TScriptingGridForm.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    if not (ssShift in Shift) then IsShift := False;

    if (Focused = (Grid1 as IControl)) or (Focused = (Grid2 as IControl)) then Grid1KeyUp(Sender, Key, Shift);
end;

procedure TScriptingGridForm.FormResize(Sender: TObject);
begin
    richEdit.GoToTextEnd;

    Chart1.Height := PageControl.Height/2;
end;

procedure TScriptingGridForm.ScriptEditPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var LVar: TStyledMemo;
    LClass: TRttiInstanceType;
    aLines, aLine: TObject;
    aMethod: TRttiMethod;
    aValue: TValue;
    intValue: TValue;
    lineRectF: TRectF;
    cBounds: TRectF;
    af,bf: TPointF;
    srcForm: TForm;
    tmpControl: IControl;
    tmpObj: TFmxObject;
begin
    if ChildrenCount = 0 then srcForm := frmMain //special case for MtxVec demo
                         else srcForm := Self;

    if not Assigned(ScriptEditStyled) then
    begin
        bf := ScriptEdit.LocalToAbsolute(TPointF.Create(3,3));

        af := srcForm.ClientToScreen(bf);
        tmpControl := srcForm.ObjectAtPoint(af);
        if Assigned(tmpControl) then
        begin
            tmpObj := TFmxObject(tmpControl);
            if tmpObj is TStyledMemo then
            begin
                if TStyledMemo(tmpObj).Model.Owner.Name = 'ScriptEdit' then
                begin
                    ScriptEditStyled := tmpControl;
                end;
            end;
        end;
    end;

    if Assigned(ScriptEditStyled) and ScriptStepping then //draw blue bar over the line when stepping through the code
    begin
        LVar := TStyledMemo(ScriptEditStyled);

        LClass := LContext.GetType(TStyledMemo) as TRttiInstanceType;
        aLines := LClass.GetField('FLineObjects').GetValue(LVar).AsObject;

        LClass := LContext.GetType(aLines.ClassType) as TRttiInstanceType;
        aMethod := LClass.GetMethod('GetItem');

        intValue := TValue.From<integer>(ScriptEdit.CaretPosition.Line);
        aLine := aMethod.Invoke(aLines, [intValue]).AsObject;

        LClass := LContext.GetType(aLine.ClassType) as TRttiInstanceType;
        aValue := LClass.GetField('FRect').GetValue(aLine);

        cBounds := ScriptEdit.Content.LocalRect;

        lineRectF := aValue.AsType<TRectF>;
        LineRectF.Top := Max(LineRectF.Top, cBounds.Top) + 3*Canvas.Scale;
        LineRectF.Bottom := EnsureRange(cBounds.Top, LineRectF.Bottom, cBounds.Bottom) + 3*Canvas.Scale;
        if LineRectF.Bottom < LineRectF.Top then LineRectF.Bottom := LineRectF.Top;

        LineRectF.Left := Max(LineRectF.Left, cBounds.Left) + 3*Canvas.Scale;
        LineRectF.Right := Min(LineRectF.Right, cBounds.Right) + 3*Canvas.Scale;

        if LineRectF.Top = LineRectF.Bottom then Exit;

        Canvas.Fill.Color := $7F2A96FF;
        Canvas.Fill.Kind := TBrushKind.Solid;
        Canvas.FillRect(lineRectF, 0, 0, AllCorners, 1);
    end;
end;

procedure TScriptingGridForm.Grid1DrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var R: TRectF;
begin
    if (Grid1Selection.Top <> Grid1Selection.Bottom) or (Grid1Selection.Left <> Grid1Selection.Right) then
    begin
        if (Grid1Selection.Top <= Row) and (Row <= Grid1Selection.Bottom) and
           (Grid1Selection.Left <= Column.Index) and (Column.Index <= Grid1Selection.Right) then
        begin
            R := Bounds;
            R.Inflate(3 * Canvas.Scale, 3 * Canvas.Scale);
            Canvas.Fill.Color := $7F2A96FF;
            Canvas.Fill.Kind := TBrushKind.Solid;
            Canvas.FillRect(R, 0, 0, AllCorners, 1);
        end;
    end;

{    if Column.Index = 0 then
    begin
        R := Bounds;
        R.Inflate(3 * Canvas.Scale, 3 * Canvas.Scale);  //dont know the color to paint row header
        Canvas.Fill.Color := StatusBarColor;
        Canvas.Fill.Kind := TBrushKind.Solid;
        Canvas.FillRect(R, 0, 0, AllCorners, 1);
    end;  }
end;

procedure TScriptingGridForm.Grid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var i, j: integer;
begin
    if Key = vkDELETE then
    begin
          case PageControl.TabIndex of
          0: begin
               for i := Grid1Selection.Top to Grid1Selection.Bottom do
                  for j := Grid1Selection.Left to Grid1Selection.Right do Grid1.Cells[j, i] := '';
             end;
          1: begin
               for i := Grid2Selection.Top to Grid2Selection.Bottom do
                  for j := Grid2Selection.Left to Grid2Selection.Right do Grid2.Cells[j, i] := '';
             end;
          end;
    end;
end;

procedure TScriptingGridForm.Grid1SelChanged(Sender: TObject);
begin
    if IsShift then
    begin
        Grid1Selection.Bottom := TCustomGrid(Sender).Row;
        Grid1Selection.Right :=  TCustomGrid(Sender).Col;

        Grid1.Repaint;
    end else
    begin
        Grid1Selection.Top := TCustomGrid(Sender).Row;
        Grid1Selection.Left := TCustomGrid(Sender).Col;
        Grid1Selection.Bottom := TCustomGrid(Sender).Row;
        Grid1Selection.Right :=  TCustomGrid(Sender).Col;

        Grid1.Repaint;
    end;
end;

procedure TScriptingGridForm.Grid1SelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
begin
    CanSelect := aCol <> 0;
end;

procedure TScriptingGridForm.Grid2DrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var R: TRectF;
begin
    if (Grid2Selection.Top <> Grid2Selection.Bottom) or (Grid2Selection.Left <> Grid2Selection.Right) then
    begin
        if (Grid2Selection.Top <= Row) and (Row <= Grid2Selection.Bottom) and
           (Grid2Selection.Left <= Column.Index) and (Column.Index <= Grid2Selection.Right) then
        begin
            R := Bounds;
            R.Inflate(3 * Canvas.Scale, 3 * Canvas.Scale);
            Canvas.Fill.Color := $7F2A96FF;
            Canvas.Fill.Kind := TBrushKind.Solid;
            Canvas.FillRect(R, 0, 0, AllCorners, 1);
        end;
    end;
end;

procedure TScriptingGridForm.Grid2SelChanged(Sender: TObject);
begin
    if IsShift then
    begin
        Grid2Selection.Bottom := TCustomGrid(Sender).Row;
        Grid2Selection.Right :=  TCustomGrid(Sender).Col;

        Grid2.Repaint;
    end else
    begin
        Grid2Selection.Top := TCustomGrid(Sender).Row;
        Grid2Selection.Left := TCustomGrid(Sender).Col;
        Grid2Selection.Bottom := TCustomGrid(Sender).Row;
        Grid2Selection.Right :=  TCustomGrid(Sender).Col;

        Grid2.Repaint;
    end;
end;

function TScriptingGridForm.GridSelection: string;
var rowr, colr: string;
begin
    case PageControl.TabIndex of
    0:  begin
           if (grid1Selection.Top <> grid1Selection.Bottom) then //row range
           rowr := Format('%d:%d',[grid1Selection.Top,grid1Selection.Bottom])
           else rowr := IntToStr(grid1Selection.Top);

           if (grid1Selection.Left <> grid1Selection.Right) then //column range
           colr := Format('%d:%d',[grid1Selection.Left-1,grid1Selection.Right-1])
           else colr := IntToStr(grid1Selection.Left-1);

           Result := 'grid1(' + rowr + ',' + colr + ')';
       end;
   1:  begin
           if (grid2Selection.Top <> grid2Selection.Bottom) then //row range
           rowr := Format('%d:%d',[grid2Selection.Top,grid2Selection.Bottom])
           else rowr := IntToStr(grid2Selection.Top);

           if (grid2Selection.Left <> grid2Selection.Right) then //column range
           colr := Format('%d:%d',[grid2Selection.Left-1,grid2Selection.Right-1])
           else colr := IntToStr(grid2Selection.Left-1);

           Result := 'grid2(' + rowr + ',' + colr + ')';
       end;
   end;
end;

function TScriptingGridForm.GridSelectionValues: string;
var rowr, colr: string;
    i, j: integer;
begin
    case PageControl.TabIndex of
    0:  begin
           for i := grid1Selection.Top to grid1Selection.Bottom do //across rows
           begin
               colr := '';
               for j := grid1Selection.Left to grid1Selection.Right do //across cols
               begin
                    if j < grid1Selection.Right then colr := colr + grid1.Cells[j, i] + ','
                                                 else colr := colr + grid1.Cells[j, i];

               end;
               if i < grid1Selection.Bottom then rowr := rowr + colr + ';'
                                             else rowr := rowr + colr;
           end;
       end;
   1:  begin
           for i := grid1Selection.Top to grid1Selection.Bottom do //across rows
           begin
               colr := '';
               for j := grid1Selection.Left to grid1Selection.Right do //across cols
               begin
                    if j < grid1Selection.Right then colr := colr + grid1.Cells[j, i] + ','
                                                else colr := colr + grid1.Cells[j, i];

               end;
               if i < grid1Selection.Bottom then rowr := rowr + colr + ';'
                                            else rowr := rowr + colr;
           end;
       end;
   end;
   Result := '[' + rowr  +']';
end;

procedure TScriptingGridForm.GridInsertEditButtonClick(Sender: TObject);
var aStr: string;
begin
    aStr := ExprEdit.Text;
    Insert(GridSelection, aStr, ExprEdit.CaretPosition);
    ExprEdit.Text := aStr;

    Focused := ExprEdit;
    ExprEdit.SelStart := Length(ExprEdit.Text);
end;

procedure TScriptingGridForm.GridInsertScriptButtonClick(Sender: TObject);
begin
    ScriptEdit.InsertAfter(ScriptEdit.CaretPosition, GridSelection, []);
end;

procedure TScriptingGridForm.GridAssignEditButtonClick(Sender: TObject);
var aStr: string;
begin
    aStr := ExprEdit.Text;
    Insert(Format('%s = %s', [GridSelection, GridSelectionValues]), aStr, ExprEdit.CaretPosition);
    ExprEdit.Text := aStr;

    Focused := ExprEdit;
    ExprEdit.SelStart := Length(ExprEdit.Text);
end;

procedure TScriptingGridForm.GridAssignScriptButtonClick(Sender: TObject);
begin
    ScriptEdit.InsertAfter(ScriptEdit.CaretPosition, Format('%s = %s', [GridSelection, GridSelectionValues]), []);
end;

procedure TScriptingGridForm.ListBoxCellClick(const Column: TColumn; const Row: Integer);
begin
    ExprEdit.Text := HistoryList[Row];// ListBox.Items[ListBox.ItemIndex];
end;

procedure TScriptingGridForm.ListBoxCellDblClick(const Column: TColumn; const Row: Integer);
begin
    ExprEdit.Text := HistoryList[Row];
    EvaluateExpression;
end;

procedure TScriptingGridForm.ListBoxMouseEnter(Sender: TObject);
begin
    StatusLabel.Text := 'Double click to execute expression';
end;

procedure TScriptingGridForm.RichEditMouseEnter(Sender: TObject);
begin
    StatusLabel.Text := 'Select and rigth click to copy text';
end;

{
procedure TScriptingGridForm.ScriptEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var aName: string;
    aVar: TValueRec;
    aPoint: TPoint;
begin
    LineLabel.Text := 'Line: ' + IntToStr(ScriptEditActiveLine);

    aName := WordUnderMouseInRichEdit(Point(X,Y));
    if Expr.IsCompiled then
    begin
        aVar := Expr.VarByName[aName];
    //    if Assigned(aVar) then
    //    begin
    //        ScriptEdit.ShowHint := True;
    //        ScriptEdit.Hint := expr.VarToolTip(aName, aVar);
    //        Application.ActivateHint(ScriptEdit.ClientToScreen(Point(X,Y)));
    //        Application.HintHidePause := 4000;
    //    end else ScriptEdit.ShowHint := False;

        if Assigned(aVar) then
        begin
            if not Assigned(mtxToolTip) then mtxToolTip := TExprToolTipForm.Create(Self);
            if not mtxToolTip.Visible then
            begin
                aPoint := ScriptEdit.ClientToScreen(Point(X,Y));
                mtxToolTip.Left := aPoint.X-4;
                mtxToolTip.Top := aPoint.Y+2;
            end;
            case aVar.ValueType of
              vtUndefined,
              vtDoubleValue,
              vtRangeValue,
              vtString,
              vtComplexValue,
              vtIntegerValue,
              vtBoolValue: begin
                           ScriptEdit.ShowHint := True;
                           ScriptEdit.Hint := expr.VarToolTip(aName, aVar);
                           Application.ActivateHint(ScriptEdit.ClientToScreen(Point(X,Y)));
                           Application.HintHidePause := 4000;
                           end;

              vtVectorValue:     mtxToolTip.UpdateGrid(aVar.VectorValue, aName);
              vtIntVectorValue:  mtxToolTip.UpdateGrid(aVar.IntVectorValue, aName);
              vtIntMatrixValue:  mtxToolTip.UpdateGrid(aVar.IntMatrixValue, aName);
              vtBoolVectorValue: mtxToolTip.UpdateGrid(aVar.BoolVectorValue, aName);
              vtBoolMatrixValue: mtxToolTip.UpdateGrid(aVar.BoolMatrixValue, aName);
              vtMatrixValue:     mtxToolTip.UpdateGrid(aVar.MatrixValue, aName);
              vtCustomValue: ;
            end;

        end else
        begin
            if Assigned(MtxToolTip) then MtxToolTip.Hide;
            ScriptEdit.ShowHint := False;
        end;
    end;
end;
}


procedure TScriptingGridForm.ScriptEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var cp: TCaretPosition;
    aName: string;
    LVar: TStyledMemo;
    LClass: TRttiInstanceType;
    aLines, aLine: TObject;
    aMethod: TRttiMethod;
    aValue: TValue;
    pointValue, boolValue, intValue: TValue;
    aVar: TValueRec;
    aLayout: TTextLayout;
    srcForm: TForm;
    tmpControl: IControl;
    tmpObj: TFmxObject;
    af, bf: TPointF;
begin
    if ChildrenCount = 0 then srcForm := frmMain //special case for MtxVec demo
                         else srcForm := Self;

    if not Assigned(ScriptEditStyled) then
    begin
        bf := ScriptEdit.LocalToAbsolute(TPointF.Create(3,3));

        af := srcForm.ClientToScreen(bf);
        tmpControl := srcForm.ObjectAtPoint(af);
        if Assigned(tmpControl) then
        begin
            tmpObj := TFmxObject(tmpControl);
            if tmpObj is TStyledMemo then
            begin
                if TStyledMemo(tmpObj).Model.Owner.Name = 'ScriptEdit' then
                begin
                    ScriptEditStyled := tmpControl;
                end;
            end;
        end;
    end;

    if not ScriptStepping then Exit;

    if Assigned(ScriptEditStyled) then
    begin
        if (X > 0) and (Y > 0) then
        begin
            LVar := TStyledMemo(ScriptEditStyled);

            LClass := LContext.GetType(TStyledMemo) as TRttiInstanceType;
            aLines := LClass.GetField('FLineObjects').GetValue(LVar).AsObject;

            af := TPointF.Create(X,Y);
            pointValue := TValue.From<TPointF>(af);  //        TValue.Make(@af, TypeInfo(TPointF), cValue);
            boolValue := TValue.From<Boolean>(false);

            LClass := LContext.GetType(aLines.ClassType) as TRttiInstanceType;
            aMethod := LClass.GetMethod('GetPointPosition');
            aValue := aMethod.Invoke(aLines, [pointValue, boolValue]);

            cp := aValue.AsType<TCaretPosition>;

            // now check, if we are above text:

            LClass := LContext.GetType(aLines.ClassType) as TRttiInstanceType;
            aMethod := LClass.GetMethod('GetItem');

            intValue := TValue.From<integer>(cp.Line);
            aLine := aMethod.Invoke(aLines, [intValue]).AsObject;

            LClass := LContext.GetType(aLine.ClassType) as TRttiInstanceType;
            aLayout := TTextLayout(LClass.GetField('FLayout').GetValue(aLine).AsObject);

            af := TPointF.Create(EnsureRange(X, aLayout.TextRect.Left, aLayout.TextRect.Right), Y);
            cp.Pos := aLayout.PositionAtPoint(af, false);

            if not cp.IsInvalid then
            begin
                if cp.Line < ScriptEdit.Lines.Count then
                begin
                    aName := Expr.ExpandCharToWord(ScriptEdit.Lines[cp.Line], cp.Pos);
                    aVar := Expr.VarByName[aName];
                end else aVar := nil;
            end else aVar := nil;

            if Assigned(aVar) then
            begin
                bf := ScriptEdit.LocalToAbsolute(TPointF.Create(X,Y));
                af := SrcForm.ClientToScreen(bf);

                case aVar.ValueType of
                  vtUndefined,
                  vtDoubleValue,
                  vtRangeValue,
                  vtString,
                  vtComplexValue,
                  vtIntegerValue,
                  vtBoolValue:    if Assigned(MtxToolTip) then MtxToolTip.Hide;

                  vtVectorValue,
                  vtIntVectorValue,
                  vtIntMatrixValue,
                  vtBoolVectorValue,
                  vtBoolMatrixValue,
                  vtMatrixValue,
                  vtCustomValue: begin
                                     HintForm.DoHideHint;

                                     if not Assigned(mtxToolTip) then mtxToolTip := TExprToolTipForm.Create(Self);
                                     if not mtxToolTip.Visible then
                                     begin
                                         mtxToolTip.Left := Round(af.X - 4);
                                         mtxToolTip.Top := Round(af.Y + 2);
                                     end;
                                 end;
                end;

                case aVar.ValueType of
                  vtUndefined,
                  vtDoubleValue,
                  vtRangeValue,
                  vtString,
                  vtComplexValue,
                  vtIntegerValue,
                  vtBoolValue:       begin
                                        HintForm.Left := Round(af.X + 4);
                                        HintForm.Top := Round(af.Y - 2);
                                        HintForm.HintText := expr.VarToolTip(aName, aVar);
                                        HintForm.DoShowHint;
                                     end;

                  vtVectorValue:     if not MtxToolTip.Visible then mtxToolTip.UpdateGrid(aVar.VectorValue, aName);
                  vtIntVectorValue:  if not MtxToolTip.Visible then mtxToolTip.UpdateGrid(aVar.IntVectorValue, aName);
                  vtIntMatrixValue:  if not MtxToolTip.Visible then mtxToolTip.UpdateGrid(aVar.IntMatrixValue, aName);
                  vtBoolVectorValue: if not MtxToolTip.Visible then mtxToolTip.UpdateGrid(aVar.BoolVectorValue, aName);
                  vtBoolMatrixValue: if not MtxToolTip.Visible then mtxToolTip.UpdateGrid(aVar.BoolMatrixValue, aName);
                  vtMatrixValue:     if not MtxToolTip.Visible then mtxToolTip.UpdateGrid(aVar.MatrixValue, aName);
                  vtCustomValue: ;
                end;
            end else
            begin
                if Assigned(MtxToolTip) then MtxToolTip.Hide;
                HintForm.DoHideHint;
            end;
        end;
    end;
end;

procedure TScriptingGridForm.ScriptEditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    LineLabel.Text := 'Line: ' + IntToStr(ScriptEditActiveLine);
end;


procedure TScriptingGridForm.SaveAsButtonClick(Sender: TObject);
begin
    TDialogService.InputQuery('Create new script',['Please specify script name'],['aScript'],
              procedure(const AResult: TModalResult; const AValues: array of string)
              var aScript: TStringList;
              begin
                  aScript := TStringList.Create;
                  aScript.Assign(ScriptEdit.Lines);
                  ScriptBox.Items.AddObject(aValues[0], aScript);
              end
              );
end;

procedure TScriptingGridForm.SaveButtonClick(Sender: TObject);
begin
    TStringList(ScriptBox.Items.Objects[ScriptBox.ItemIndex]).Assign(ScriptEdit.Lines);
end;

procedure TScriptingGridForm.SaveWorkspace(const dst: TExprWorkspace; const dstName: string);
var i: integer;
begin
    dst.Name := dstName;
    dst.History.Assign(HistoryList);
    dst.ScriptNames.Assign(ScriptBox.Items);

    dst.Scripts.Clear;
    //traverse the ScriptBox Object contents:
    for i := 0 to ScriptBox.Items.Count - 1 do
        dst.Scripts.Add(TStringList(ScriptBox.Items.Objects[i]).Text);

    Expr.SaveContext(dst.Variables);
end;

procedure TScriptingGridForm.SaveWorkButtonClick(Sender: TObject);
var aStr: string;
begin
    aStr := 'aWorkspace';
    TDialogService. InputQuery('Create new workspace',['Workspace name'],[aStr],
        procedure(const AResult: TModalResult; const AValues: array of string)
        var aWSpace: TExprWorkspace;
        begin
            if AResult = mrOK then
            begin
                if ScriptBox.ItemIndex >= 0 then //save changes to current script
                    TStringList(ScriptBox.Items.Objects[ScriptBox.ItemIndex]).Assign(ScriptEdit.Lines);

                aStr := aValues[0];
                aWSpace := TExprWorkspace.Create;
                SaveWorkspace(aWspace, aStr);
                WorkspaceBox.Items.AddObject(aStr, aWSpace);

                if WorkspaceBox.Items.Count = 1 then
                begin
                    WorkspaceBox.ItemIndex := 0;
                    WorkspaceBoxChange(nil);
                end;
            end;
        end
        );
end;

procedure TScriptingGridForm.DeleteWorkButtonClick(Sender: TObject);
var i: integer;
begin
    if WorkspaceBox.Items.Count > 0 then
    begin
        {$IFNDEF AUTOREFCOUNT}
        WorkSpaceBox.Items.Objects[WorkSpaceBox.ItemIndex].Free;
        {$ENDIF}
        WorkSpaceBox.Items.Objects[WorkSpaceBox.ItemIndex] := nil;

        i := WorkSpaceBox.ItemIndex;

        WorkSpaceBox.OnChange := nil;
        WorkSpaceBox.Items.Delete(i);

        if WorkSpaceBox.Items.Count > 0 then WorkSpaceBox.ItemIndex := EnsureRange(0, i, WorkSpaceBox.Items.Count-1)
                                        else WorkSpaceBox.ItemIndex := -1;

        WorkSpaceBox.OnChange := WorkspaceBoxChange;

        WorkspaceBoxChange(nil);
    end;
end;

procedure TScriptingGridForm.WorkspaceBoxChange(Sender: TObject);
var aWSpace: TExprWorkspace;
    i: integer;
begin
    if (WorkspaceIndex >= 0) and (WorkspaceIndex < WorkspaceBox.Items.Count) then //save previous state
    begin
        if ScriptBox.ItemIndex >= 0 then //save changes to current script
            TStringList(ScriptBox.Items.Objects[ScriptBox.ItemIndex]).Assign(ScriptEdit.Lines);

        aWSpace := TExprWorkspace(WorkSpaceBox.Items.Objects[WorkspaceIndex]);
        SaveWorkspace(aWspace, aWSpace.Name);
    end;

    WorkspaceIndex := WorkspaceBox.ItemIndex;

    if WorkspaceIndex >= 0 then //loda new state
    begin
        //load workspace
        aWSpace := TExprWorkspace(WorkspaceBox.Items.Objects[WorkspaceIndex]);

        HistoryList.Assign(aWSpace.History);
        UpdateHistoryBox;

        //release ScriptBox items
        for i := 0 to ScriptBox.Items.Count-1 do
        begin
            {$IFNDEF AUTOREFCOUNT}
            TStringList(ScriptBox.Items.Objects[i]).Free;
            {$ENDIF}
            ScriptBox.Items.Objects[i] := nil;
        end;

        ScriptBox.Items.Assign(aWSpace.ScriptNames);

        //traverse the ScriptBox Object contents:
        for i := 0 to ScriptBox.Items.Count-1 do
        begin
            ScriptBox.Items.Objects[i] := TStringList.Create;
            TStringList(ScriptBox.Items.Objects[i]).Text := aWspace.Scripts[i];
        end;
        ScriptBox.ItemIndex := 0;
        ScriptBoxChange(Sender);

        Expr.LoadContext(aWSpace.Variables);
        Expr.ClearExpressions;
        DefineCustomValues;

        UpdateVarView;
    end else
    begin
        ScriptEdit.Lines.Clear;
        expr.ClearExpressions;

        //release ScriptBox items
        for i := 0 to ScriptBox.Items.Count-1 do
        begin
            {$IFNDEF AUTOREFCOUNT}
            TStringList(ScriptBox.Items.Objects[i]).Free;
            {$ENDIF}
            ScriptBox.Items.Objects[i] := nil;
        end;

        ScriptBox.Clear;
        WorkspaceBox.Clear;
    end;
end;

procedure TScriptingGridForm.DeleteScriptButtonClick(Sender: TObject);
var i: integer;
begin
    if Scriptbox.Items.Count > 0 then
    begin
        {$IFNDEF AUTOREFCOUNT}
        ScriptBox.Items.Objects[Scriptbox.ItemIndex].Free;
        {$ENDIF}
        ScriptBox.Items.Objects[Scriptbox.ItemIndex] := nil; //for ARC

        Scriptbox.OnChange := nil;

        i := Scriptbox.ItemIndex;
        Scriptbox.Items.Delete(i);

        if Scriptbox.Items.Count > 0 then Scriptbox.ItemIndex := EnsureRange(0, i, Scriptbox.Items.Count-1)
                                     else Scriptbox.ItemIndex := -1;

        Scriptbox.OnChange := ScriptBoxChange;

        ScriptBoxChange(nil);
    end;
end;

procedure TScriptingGridForm.Panel6Paint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
//   StatusBarColor := Canvas.Fill.C
end;

procedure TScriptingGridForm.PopulateScriptList;
var aScript: TStringList;
begin
    aScript := TStringList.Create;
    aScript.Add('//initialize');
    aScript.Add('a = 0.1');
    aScript.Add('grid1(0:500,0:10) = "" //clear the grid');
    aScript.Add('grid1(1,0) = "Frequency ="');
    aScript.Add('grid1(1,1) = a');
    aScript.Add('');
    aScript.Add('//do the math');
    aScript.Add('f = grid1(1,1)  //pick up value from the grid');
    aScript.Add('b = cos([0.0:1023]*pi*f) //create time series');
    aScript.Add('(mag, phase) = carttopolar(fft(b))');
    aScript.Add('');
    aScript.Add('grid1(2,0) = "Peak value ="');
    aScript.Add('grid1(2,1) = max(mag)');
    aScript.Add('');
    aScript.Add('xOffset = 0.0;');
    aScript.Add('xStep = 2.0/length(b);');
    aScript.Add('drawvalues(mag(0:511),series1,xOffset, xStep,false);');
    aScript.Add('drawvalues(b,series2,0, 0.5/length(b),false);');
    aScript.Add('');
    aScript.Add('//display in the grid');
    aScript.Add('len = length(mag)/.2');
    aScript.Add('grid2(0,0) = "Magnitude"');
    aScript.Add('grid2(1:,0) = mag(0:(len-1))');
    aScript.Add('grid2(0,1) = "Phase"');
    aScript.Add('grid2(1:,1) = phase(0:(len-1))');
    ScriptBox.Items.AddObject('FFT Spectrum', aScript);

    aScript := TStringList.Create;
    aScript.Add('grid1(0:500,0:10) = "" //clear the grid');
    aScript.Add('grid1(0,0) = "Student PDF"');
    aScript.Add('grid1(1,0) = "x"');
    aScript.Add('');
    aScript.Add('ax = [0:0.01:10]');
    aScript.Add('grid1(2:,0) = ax');
    aScript.Add('for i = 1:10');
    aScript.Add('    b = StudentPDF(ax, i);');
    aScript.Add('    grid1(1,i) = ["DOF ", i];');
    aScript.Add('    grid1(2:,i) = b;');
    aScript.Add('end');
    ScriptBox.Items.AddObject('Student distribution', aScript);

    aScript := TStringList.Create;
    aScript.Add('undefine(a,k) //undefine type of a, k vars if defined');
    aScript.Add('');
    aScript.Add('// some comment');
    aScript.Add('');
    aScript.Add('a = -2.0');
    aScript.Add('i = 0');
    aScript.Add('for k = 0:6666666');
    aScript.Add('   a = a + 0.0000003');
    aScript.Add('   i = i + 1');
    aScript.Add('end');
    ScriptBox.Items.AddObject('for-loop', aScript);
  //
end;

procedure TScriptingGridForm.ScriptBoxChange(Sender: TObject);
var aList: TStringList;
begin
    if Scriptbox.ItemIndex >= 0 then
    begin
        aList := TStringList(ScriptBox.Items.Objects[Scriptbox.ItemIndex]);

        ScriptEdit.Lines.Clear;
        ScriptEdit.Lines.Assign(aList);

        expr.ClearExpressions;
        Expr.AddExpr(aList);

        ResetButtonClick(Sender);
        ScriptEdit.SelLength := 0;
    end else
    begin
        ScriptBox.Clear;
        ScriptEdit.Lines.Clear;
        expr.ClearExpressions;
    end;
end;

procedure _drawvalues5(const Param: TExprRec);
var vt1,vt2,vt3, vt4, vt5: TExprValueType;
begin
    vt1 := Param.Args[0].ValueType;
    vt2 := Param.Args[1].ValueType;
    vt3 := Param.Args[2].ValueType;
    vt4 := Param.Args[3].ValueType;
    vt5 := Param.Args[4].ValueType;
    if (vt1 <> vtVectorValue) or (vt2 <> vtCustomValue) or (not Param.Args[2].IsRealValue) or (not Param.Args[3].IsRealValue) or
       (vt5 <> vtBoolValue) then UnsupportedValueTypesError(Param, vt1, vt2, vt3, vt4, vt5);

    DrawValues(Param.Args[0].VectorValue, TChartSeries(Param.Args[1].CustomValue),
               Param.Args[2].DoubleValue, Param.Args[3].DoubleValue, Param.Args[4].BoolValue);
end;

procedure _drawvalues4(const Param: TExprRec);
var vt1,vt2,vt3, vt4: TExprValueType;
begin
    vt1 := Param.Args[0].ValueType;
    vt2 := Param.Args[1].ValueType;
    vt3 := Param.Args[2].ValueType;
    vt4 := Param.Args[3].ValueType;
    if (vt1 <> vtVectorValue) or (vt2 <> vtVectorValue) or
       (vt3 <> vtCustomValue) or (vt4 <> vtBoolValue) then UnsupportedValueTypesError(Param, vt1, vt2, vt3, vt4);

    DrawValues(Param.Args[0].VectorValue, Param.Args[1].VectorValue, TChartSeries(Param.Args[2].CustomValue),Param.Args[3].BoolValue);
end;

{ TStyledMemoCrack }

//function TStyledMemoCrack.CaretPos(X, Y: Single; var LineHeight: Single): TCaretPosition;
//var tmp: TCaretPosition;
//begin
//    tmp := CaretPosition;
//    MouseDown(TMouseButton.mbLeft, [], X, Y);
//    MouseUp(TMouseButton.mbLeft, [], X, Y);
//    Result := CaretPosition;
//    CaretPosition := tmp;
//
//    LineHeight := Self.GetLineHeight;
//end;

initialization
  RegisterClass(TScriptingGridForm);

end.
