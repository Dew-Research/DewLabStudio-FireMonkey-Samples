unit ProbEditor;

interface

{$I bdsppdefs.inc}

uses

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.DialogService,
  FMX.Objects,
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  DewProbWrapper, Math387, Probabilities, FMX.ListView.Types, FMX.ListView,
  FMX.Controls.Presentation, FMX.Grid.Style, FMX.ScrollBox;



type
  TFrameDist = class(TFrame)
    Panel1: TPanel;
    LabelDec: TLabel;
    RadioGroupOut: TPanel;
    GroupBoxRange: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditNumPoints: TEdit;
    EditLB: TEdit;
    EditUB: TEdit;
    Panel2: TPanel;
    ListBoxDist: TListBox;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label4: TLabel;
    listViewParams: TStringGrid;
    ListItem17: TListBoxItem;
    ListItem53: TListBoxItem;
    ListItem52: TListBoxItem;
    ListItem51: TListBoxItem;
    ListItem50: TListBoxItem;
    ListItem49: TListBoxItem;
    ListItem48: TListBoxItem;
    ListItem47: TListBoxItem;
    ListItem46: TListBoxItem;
    ListItem45: TListBoxItem;
    ListItem44: TListBoxItem;
    ListItem43: TListBoxItem;
    ListItem42: TListBoxItem;
    ListItem41: TListBoxItem;
    ListItem40: TListBoxItem;
    ListItem39: TListBoxItem;
    ListItem38: TListBoxItem;
    ListItem37: TListBoxItem;
    Listitem36: TListBoxItem;
    ListItem35: TListBoxItem;
    ListItem34: TListBoxItem;
    ListItem33: TListBoxItem;
    ListItem32: TListBoxItem;
    ListItem31: TListBoxItem;
    ListItem30: TListBoxItem;
    ListItem29: TListBoxItem;
    ListItem28: TListBoxItem;
    ListItem27: TListBoxItem;
    ListItem26: TListBoxItem;
    ListItem25: TListBoxItem;
    ListItem24: TListBoxItem;
    ListItem23: TListBoxItem;
    ListItem22: TListBoxItem;
    ListItem21: TListBoxItem;
    ListItem20: TListBoxItem;
    ListItem19: TListBoxItem;
    ListItem18: TListBoxItem;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    procedure ListViewParamsDblClick(Sender: TObject);
    procedure ListBoxDistClick(Sender: TObject);
    procedure RadioGroupOutClick(Sender: TObject);
    procedure EditNumPointsChange(Sender: TObject);
    procedure EditLBChange(Sender: TObject);
    procedure EditUBChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    FDistribution: TProbDistribution;
    FFormatString: String;
    { Private declarations }
    procedure SetDistType(DistType:TDistribution; Text:String);
    procedure RefreshParListView;
    procedure SetDistribution(const Value: TProbDistribution);
    procedure SetFormatString(const Value: String);
  public
    RadioGroupOutIndex: integer;
    { Public declarations }
    property Distribution: TProbDistribution read FDistribution write SetDistribution;
    property FormatString: String read FFormatString write SetFormatString;
  end;


implementation

uses PlatformHelpers;

{$R *.FMX}

procedure TFrameDist.ListViewParamsDblClick(Sender: TObject);
var parstr: String;
    par: TProbParameter;
    ri: integer;
begin
  ri := listViewParams.Selected;
  par := Distribution.DistParams[ri];

  TDialogService.InputQuery('Set parameter '+ listViewParams.Cells[0,ri],['Valid range: ' + listViewParams.Cells[2,ri]+', '+ listViewParams.Cells[1,ri]], [listViewParams.Cells[3,ri]],
              procedure(const AResult: TModalResult; const AValues: array of string)
              begin
                  case Aresult of
                  mrOK:
                    begin
                      parstr := AValues[0];

                      if par.ParameterType = parInteger then
                      begin
                          par.Value := StrToInt(parstr);
                          listViewParams.Cells[3,ri] := parstr;
                      end else
                      begin
                          par.Value := StrToFloat(parstr);
                          listViewParams.Cells[3,ri] := parstr;
                      end;

                      listViewParams.Repaint;
                    end;

                  end;
              end);
end;

procedure TFrameDist.Panel1Click(Sender: TObject);
var  I: Integer;
begin
    for i := 0 to 3 do
      ListViewParams.AddObject(TStringColumn.Create(Self));

    ListViewParams.Columns[0].Header := 'Parameter';
    ListViewParams.Columns[1].Header := 'Type';
    ListViewParams.Columns[1].Width := 60;
    ListViewParams.Columns[2].Header := 'Valid range';
    ListViewParams.Columns[3].Header := 'Value';

    ListViewParams.RowCount := 10;
    listViewParams.Repaint;
end;

procedure TFrameDist.SetDistType(DistType:TDistribution; Text:String);
begin
  Distribution.DistType := DistType;
  EditNumPoints.Text := IntToStr(Distribution.NumPoints);
  EditLB.Text := SampleToStr(Distribution.LB);
  EditUB.Text := SampleToStr(Distribution.UB);
  RefreshParListView;
end;

procedure TFrameDist.RefreshParListView;
var i: Integer;
begin
   With ListBoxDist do
   begin
     Button2.Enabled := ItemIndex < Items.Count-1;
     Button1.Enabled := ItemIndex > 0;
   end;
   ListViewParams.RowCount := Distribution.DistParams.Count + 1;
   SetGridColumnCount(ListViewParams, 4);
   //Add x
   ListViewParams.Cells[0,0] := Distribution.X.Name;
   if Distribution.X.ParameterType = parInteger then ListViewParams.Cells[1,0] := 'integer' else ListViewParams.Cells[1,0] := 'real';
   ListViewParams.Cells[2,0] := Distribution.X.Notes;
   ListViewParams.Cells[3,0] := SampleToStr(Distribution.X.Value);

   for i := 0 to Distribution.DistParams.Count-1 do
   begin
      ListViewParams.Cells[0,i+1] := Distribution.DistParams[i].Name;
      if Distribution.DistParams[i].ParameterType = parInteger then ListViewParams.Cells[1,i+1] := 'integer' else ListViewParams.Cells[1,i+1] := 'real';
      ListViewParams.Cells[2,i+1] := Distribution.DistParams[i].Notes;
      ListViewParams.Cells[3,i+1] := SampleToStr(Distribution.DistParams[i].Value);
      listViewParams.Repaint;
   end;
end;

procedure TFrameDist.SetDistribution(const Value: TProbDistribution);
begin
  if Value<>FDistribution then
  begin
    FDistribution := Value;
    RefreshParListView;
  end;
end;

procedure TFrameDist.ListBoxDistClick(Sender: TObject);
begin
  With Sender as TListBox do
    SetDistType(TDistribution(ItemIndex),Items[ItemIndex]);
end;

procedure TFrameDist.RadioButton1Change(Sender: TObject);
begin
    if RadioButton1.IsChecked then RadioGroupOutIndex := 0;
    if RadioButton2.IsChecked then RadioGroupOutIndex := 1;
    RadioGroupOutClick(Sender);
end;

procedure TFrameDist.RadioGroupOutClick(Sender: TObject);
begin
  GroupBoxRange.Visible := RadioGroupOutIndex = 1;
end;

procedure TFrameDist.EditNumPointsChange(Sender: TObject);
var ival: Integer;
begin
  ival := StrToInt(EditNumPoints.Text);
  Distribution.NumPoints := ival;
end;

procedure TFrameDist.EditLBChange(Sender: TObject);
begin
  Distribution.LB := StrToFloat(EditLB.Text);
end;

procedure TFrameDist.EditUBChange(Sender: TObject);
begin
  Distribution.UB := StrToFloat(EditUB.Text);
end;

procedure TFrameDist.Button2Click(Sender: TObject);
begin
  With ListBoxDist do
  begin
    if ItemIndex < Items.Count -1 then
      ItemIndex := ItemIndex + 1;
    SetDistType(TDistribution(ItemIndex),Items[ItemIndex]);
  end;
end;


procedure TFrameDist.Button1Click(Sender: TObject);
begin
  With ListBoxDist do
  begin
    if ItemIndex > 0 then
      ItemIndex := ItemIndex - 1;
    SetDistType(TDistribution(ItemIndex),Items[ItemIndex]);
  end;
end;

procedure TFrameDist.Edit1Change(Sender: TObject);
begin
  FFormatString := Edit1.Text;
end;

procedure TFrameDist.SetFormatString(const Value: String);
begin
  FFormatString := Value;
end;

end.
