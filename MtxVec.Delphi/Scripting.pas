unit Scripting;

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
  Fmx.StdCtrls,
  FMX.Header,
  MtxParseExpr,
  MtxParseClass,
  FMX.ListView.Types,
  FMX.ListView, System.Rtti, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid.Style, FMX.Memo.Types;


type
  TScriptingForm = class(TForm)
    Panel1: TPanel;
    RichEdit: TMemo;
    ExprEdit: TEdit;
    Splitter1: TSplitter;
    Panel2: TPanel;
    ListBox: TListBox;
    Splitter2: TSplitter;
    Label1: TLabel;
    Label2: TLabel;
    Splitter3: TSplitter;
    StatusBar: TStatusBar;
    VarView: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    MessageLabel: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RichEditMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBoxDblClick(Sender: TObject);
    procedure VarViewDblClick(Sender: TObject);
    procedure VarViewMouseEnter(Sender: TObject);
    procedure ListBoxMouseEnter(Sender: TObject);
    procedure RichEditMouseEnter(Sender: TObject);
    procedure ExprEditMouseEnter(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ExprEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    procedure EvaluateExpression;
    procedure UpdateVarView;
    { Private declarations }
  public
    { Public declarations }
    Expr: TMtxExpression;
  end;

var
  ScriptingForm: TScriptingForm;

implementation

uses Math387, MtxVec, MtxExpr, FmxMtxVecEdit,  FmxMtxVecTee, StringVar, AbstractMtxVec;

{$R *.FMX}

procedure TScriptingForm.UpdateVarView;
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
        vtBoolValue:   varView.Cells[2, i] := BoolToStr(aVar.BoolValue, true);
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
        vtDoubleValue: varView.Cells[2, i] := SampleToStr(aVar.DoubleValue);
        vtComplexValue:varView.Cells[2, i] := CplxToStr(aVar.ComplexValue);
        vtVectorValue: varView.Cells[2, i] := '1x' + IntToStr(aVar.VectorValue.Length);
        vtMatrixValue: varView.Cells[2, i] := IntToStr(aVar.MatrixValue.Rows)+ 'x' + IntToStr(aVar.MatrixValue.Cols);
        vtIntVectorValue: varView.Cells[2, i] := '1x' + IntToStr(aVar.IntVectorValue.Length);
        vtIntMatrixValue: varView.Cells[2, i] := IntToStr(aVar.IntMatrixValue.Rows)+ 'x' +
                                                 IntToStr(aVar.IntMatrixValue.Cols);
        vtBoolVectorValue: varView.Cells[2, i] := '1x' + IntToStr(aVar.IntVectorValue.Length);
        vtBoolMatrixValue: varView.Cells[2, i] := IntToStr(aVar.IntMatrixValue.Rows)+ 'x' +
                                                  IntToStr(aVar.IntMatrixValue.Cols);
        end;
    end;
end;

procedure TScriptingForm.VarViewDblClick(Sender: TObject);
var a: TValueRec;
    varName: string;
    rowidx: integer;
begin
   rowidx := VarView.Selected;
   varName := VarView.Cells[0,rowIdx];
   a := Expr.VarByName[varName];
   case a.ValueType of
   vtVectorValue: ViewValues(a.VectorValue,varName);
   vtMatrixValue: ViewValues(a.MatrixValue,varName);
   end;
end;

procedure TScriptingForm.VarViewMouseEnter(Sender: TObject);
begin
    messageLabel.Text := 'Double click vector or matrix to examine the values';
end;

procedure TScriptingForm.EvaluateExpression;
var a: TValueRec;
  aName: string;
  aCmd: string;
  i: Integer;
  funcList, hlpList: StringList;
begin
    Expr.ClearExpressions;
    aCmd := Trim(LowerCase(ExprEdit.Text));
    if aCmd = 'cls' then
    begin
        for i := 0 to RichEdit.Lines.Count - 1 do RichEdit.Lines.Delete(0);
        RichEdit.Lines[0] := '';
        Exit;
    end else
    if aCmd = 'clear' then
    begin
        Expr.ClearAll;
        for i := 0 to RichEdit.Lines.Count - 1 do RichEdit.Lines.Delete(0);
        ListBox.Clear;
        VarView.RowCount := 0;
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

        if ExprEdit.Text <> '' then
        begin
             if ListBox.Items.IndexOf(ExprEdit.Text) < 0 then
             begin
                 ListBox.ItemIndex := ListBox.Items.Add(ExprEdit.Text);
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
    except
        on E: Exception do
        begin
            RichEdit.Lines.Add(acmd + ' :');
            RichEdit.Lines.Add(E.Message);
            RichEdit.Lines.Add('');
            Exit;
        end;
    end;
    if ExprEdit.Text <> '' then
    begin
         if ListBox.Items.IndexOf(ExprEdit.Text) < 0 then
         begin
             ListBox.ItemIndex := ListBox.Items.Add(ExprEdit.Text);
         end;
         ExprEdit.Text := '';
    end;
    UpdateVarView;
    aName := Expr.EvaluatedVarName(0);
    RichEdit.Lines.Add('');
    case a.ValueType of
      vtUndefined: RichEdit.Lines.Add('Result type is undefined.');
      vtDoubleValue: RichEdit.Lines.Add(aName + ' = ' + SampleToStr(a.DoubleValue));
      vtComplexValue: RichEdit.Lines.Add(aName + ' = ' + CplxToStr(a.ComplexValue));
      vtRangeValue: if a.ExtRange then
                    begin
                        case a.ExtRangeValue.Length of
                        2: RichEdit.Lines.Add(aName + '(range) = ' + SampleToStr(a.ExtRangeValue[0]) + ':' + SampleToStr(a.ExtRangeValue[1]));
                        3: RichEdit.Lines.Add(aName + '(range) = ' + SampleToStr(a.ExtRangeValue[0]) + ':' + SampleToStr(a.ExtRangeValue[1]) + ':' + SampleToStr(a.ExtRangeValue[2]));
                        end;
                    end else
                    begin
                        case Length(a.fRange) of
                        2: RichEdit.Lines.Add(aName + '(range) = ' + IntToStr(a.fRange[0]) + ':' + IntToStr(a.fRange[1]));
                        3: RichEdit.Lines.Add(aName + '(range) = ' + IntToStr(a.fRange[0]) + ':' + IntToStr(a.fRange[1]) + ':' + IntToStr(a.fRange[2]));
                        end;
                    end;
      vtString: RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ' + a.StringValue);
      vtBoolValue: RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ' + BoolToStr(a.BoolValue, true));
      vtBoolVectorValue:
                     begin
                     RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ');
                     RichEdit.Lines.Add('');
                     a.BoolVectorValue.ValuesToStrings(RichEdit.Lines);
                     end;
      vtBoolMatrixValue:
                     begin
                     RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ');
                     RichEdit.Lines.Add('');
                     a.BoolMatrixValue.ValuesToStrings(RichEdit.Lines);
                     end;
      vtIntVectorValue:
                     begin
                     RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ');
                     RichEdit.Lines.Add('');
                     a.IntVectorValue.ValuesToStrings(RichEdit.Lines);
                     end;
      vtIntMatrixValue:
                     begin
                     RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ');
                     RichEdit.Lines.Add('');
                     a.IntMatrixValue.ValuesToStrings(RichEdit.Lines);
                     end;
      vtVectorValue: begin
                     RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ');
                     RichEdit.Lines.Add('');
                     a.VectorValue.ValuesToStrings(RichEdit.Lines);
                     end;
      vtMatrixValue: begin
                     RichEdit.Lines.Add(aname + '(' + ValTypeAsStr[a.ValueType] + ') = ');
                     RichEdit.Lines.Add('');
                     a.MatrixValue.ValuesToStrings(RichEdit.Lines);
                     end;
    end;
    RichEdit.Lines.Add('');

   if not Timer1.Enabled then RichEdit.GoToTextEnd;
end;

procedure TScriptingForm.ExprEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var i: Integer;
begin
  case Key of
  vkUP:   begin
          i := ListBox.ItemIndex;
          if (i > 0) and (ExprEdit.Text <> '') then Dec(i);
          ListBox.ItemIndex := i;
          ExprEdit.Text := ListBox.Items[I];
          end;
  vkDown: begin
          i := ListBox.ItemIndex;
          if (i < (ListBox.Items.Count-1)) and (ExprEdit.Text <> '') then Inc(i);
          ListBox.ItemIndex := i;
          ExprEdit.Text := ListBox.Items[I];
          end;
  vkReturn: EvaluateExpression;
  end;
end;

procedure TScriptingForm.ExprEditMouseEnter(Sender: TObject);
begin
    messageLabel.Text := 'Type the expression';
end;

procedure TScriptingForm.FormCreate(Sender: TObject);
begin
   Expr := TMtxExpression.Create;
  // Expr.SelfTest;

   RichEdit.Lines[0] := '';
   ExprEdit.Text := 'clear';
   EvaluateExpression;
   ExprEdit.Text := 'help';
   EvaluateExpression;
   ExprEdit.Text := 'j = -2';
   EvaluateExpression;
   ExprEdit.Text := 'y = 10:15';
   EvaluateExpression;
   ExprEdit.Text := 'y = y(:)';
   EvaluateExpression;
   ExprEdit.Text := 'x = double(y)';
   EvaluateExpression;
   ExprEdit.Text := 'm = x(0:2)''*x(2:-1:0)';
   EvaluateExpression;
   ExprEdit.Text := 'm''';
   EvaluateExpression;
   ExprEdit.Text := 'rows(m)';
   EvaluateExpression;
   ExprEdit.Text := 'length(x)';
   EvaluateExpression;
   ExprEdit.Text := 'm(0:2) = 2:-1:0';
   EvaluateExpression;
   ExprEdit.Text := 'b = m\x(0:2)';
   EvaluateExpression;
   ExprEdit.Text := 'm*b''';
   EvaluateExpression;
   ExprEdit.Text := 'c = fft([1, b])';
   EvaluateExpression;
   ExprEdit.Text := 'c1 = [1,2,3,4,5]';
   EvaluateExpression;
   ExprEdit.Text := 'c2 = [1,2;2,3]';
   EvaluateExpression;
   ExprEdit.Text := 'c3 = [[1;2],[2;3]]';
   EvaluateExpression;
   ExprEdit.Text := 'c4 = ["Rows = ", rows(m),", Complex = ", (3+12.4i)*2i]';
   EvaluateExpression;
end;

procedure TScriptingForm.FormDestroy(Sender: TObject);
begin
   Expr.Free;
end;

procedure TScriptingForm.ListBoxDblClick(Sender: TObject);
begin
    ExprEdit.Text := ListBox.Items[ListBox.ItemIndex];
    EvaluateExpression;
end;

procedure TScriptingForm.ListBoxMouseEnter(Sender: TObject);
begin
    messageLabel.Text := 'Double click to execute expression';
end;

procedure TScriptingForm.RichEditMouseEnter(Sender: TObject);
begin
    messageLabel.Text := 'Select and rigth click to copy text';
end;

procedure TScriptingForm.RichEditMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//  ShowHint
end;

procedure TScriptingForm.Timer1Timer(Sender: TObject);
begin
   RichEdit.GoToTextEnd;
   Timer1.Enabled := false;
end;

initialization
  RegisterClass(TScriptingForm);

end.
