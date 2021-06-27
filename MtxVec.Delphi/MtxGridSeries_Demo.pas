unit MtxGridSeries_Demo;

{$I BdsppDefs.inc}

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
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
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,
  FmxMtxVecTee, MtxVec, FmxMtxComctrls, MtxExpr, Sparse, System.Classes,FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo.Types;


type
  TfrmMtxGridSeries = class(TBasicForm2)
    Panel4: TPanel;
    CheckBox2: TCheckBox;
    Timer1: TTimer;
    Button2: TButton;
    RadioGroup1: TPanel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    PaletteBar: TScrollBar;
    Label2: TLabel;
    ThreeColorBox: TCheckBox;
    PixelResampleBox: TCheckBox;
    SharpContrastBox: TCheckBox;
    Splitter1: TSplitter;
    NonZeroBox: TRadioButton;
    AverageBox: TRadioButton;
    AverageMagnitudeBox: TRadioButton;
    PeakBox: TRadioButton;
    PeakMagnitudeBox: TRadioButton;
    Chart1: TChart;
    ColorChart: TChart;
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Chart1GetAxisLabel(Sender: TChartAxis; Series: TChartSeries; ValueIndex: Integer; var LabelText: String);
    procedure NonZeroBoxChange(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure PixelResampleBoxChange(Sender: TObject);
    procedure ThreeColorBoxChange(Sender: TObject);
    procedure PaletteBarChange(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure SharpContrastBoxChange(Sender: TObject);
  private
    { Private declarations }
    A: Matrix;
    v1,v2: Vector;
    SparseA: TSparseMtx;
    RadioGroupIndex : integer;
    procedure UpdateData;
  public
    GridSeries,LegendSeries : TMtxGridSeries;
    procedure UpdateCharts;
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMtxGridSeries: TfrmMtxGridSeries;

implementation

Uses FmxMtxGridSerEdit, { <--- add grid series editor to uses clause }
     AbstractMtxVec;

{$R *.FMX}

procedure TfrmMtxGridSeries.UpdateData;
begin
    SparseA.Size(2000,2000,100000,False);
    SparseA.RandomSparse(v1,v2,False,1,100000);
    SparseA.PixelDownSample(A,500, TPixelDownSample(RadioGroupIndex));
    GridSeries.PixelResampleMethod := TPixelDownSample(RadioGroupIndex);

  {  SparseA.SparseToDense(a); }

  {  B.Size(2000,400,False);
    B.SetZero;
    B.PixelDownSample(A,500,TPixelDownSample(RadioGroup1.ItemIndex));}

    UpdateCharts;
end;

procedure TfrmMtxGridSeries.FormDestroy(Sender: TObject);
begin
  SparseA.Free;
  inherited;
end;

procedure TfrmMtxGridSeries.NonZeroBoxChange(Sender: TObject);
begin
    if NonZeroBox.IsChecked then RadioGroupIndex := 0;
    if AverageBox.IsChecked then RadioGroupIndex := 1;
    if AverageMagnitudeBox.IsChecked then RadioGroupIndex := 2;
    if PeakBox.IsChecked then RadioGroupIndex := 3;
    if PeakMagnitudeBox.IsChecked then RadioGroupIndex := 4;

    SparseA.PixelDownSample(A,500,TPixelDownSample(RadioGroupIndex));
    GridSeries.PixelResampleMethod := TPixelDownSample(RadioGroupIndex);
    UpdateCharts;
end;

procedure TfrmMtxGridSeries.CheckBox1Change(Sender: TObject);
begin
    Timer1.Enabled := CheckBox2.IsChecked;
    RadioGroup1.Enabled := Not Timer1.Enabled;
    Button2.Enabled := Not Timer1.Enabled;
    CheckBox1.IsChecked := Not CheckBox2.IsChecked;
end;

procedure TfrmMtxGridSeries.CheckBox2Change(Sender: TObject);
begin
    Timer1.Enabled := CheckBox2.IsChecked;
    RadioGroup1.Enabled := Not Timer1.Enabled;
    Button2.Enabled := Not Timer1.Enabled;
    CheckBox1.IsChecked := Not CheckBox2.IsChecked;
end;

constructor TfrmMtxGridSeries.Create(AOwner: TComponent);
begin
  inherited;

  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('TMtxGridSeries which can be used '
      + 'with Standard and Pro version of TeeChart. '
      + 'Using TMtxGridSeries you can visualize matrix values. '
      + 'Key properties/methods are:');
    Add('');
    Add('property PaletteSteps : Defines the number of palette steps for legend');
    Add('property BottomColor, TopColor : Defines color for lowest and highest value.');
    Add('property PaletteStyle : Default value is palRange meaning palette '
      + 'colors will be calculated from BottomColor, TopColor and PaletteSteps '
      + 'properties.  If you want to define custom palette levels, set '
      + 'PaletteStyle to palCustom and then define level and it''s color by using '
      + 'AddPalette method.');
    Add('method AddPalette : adds new palette level (works only if PaletteStyle is palCustom).');
    Add('method CreateRangePalette : Recreates range palette values. Call this method if matrix '
      + 'maximum/minimum value changes.');
    Add('method ClearPalette : clears palette.'+#10+#13);
    Add('');
    Add('Some properties are accessible via the MtxGridSeries editor (click on "Edit Grid Series" button).');
  end;
  {$IFDEF TEESTD}
  Button2.Visible := False;
  Chart1.Legend.Visible := False;
  {$ELSE}
  Chart1.Legend.Visible := True;
  Button2.Visible := True;
  {$ENDIF}
  { setup grid series }
  With Chart1.LeftAxis do
  begin
    Title.Text := 'Index';
    Increment := 1.0;
    RoundFirstLabel := False;
 {    LabelsOnAxis := True; }
  end;
  With Chart1.LeftAxis do
  begin
    Title.Text := 'Index';
    Increment := 1.0;
    RoundFirstLabel := False;
{    LabelsOnAxis := True; }
  end;
  GridSeries := TMtxGridSeries.Create(Chart1);
  GridSeries.Name := 'GridSeriesName';
  GridSeries.ValueFormat := '0.00';
  GridSeries.ColorPalette.BottomColor := TAlphaColors.White;
  GridSeries.ColorPalette.TopColor :=  TAlphaColors.Blue;
  GridSeries.HorizAxis := aTopAxis;
  GridSeries.ParentChart := Chart1;
{  GridSeries.PixelResample := True; }
  { now setup sparse matrix }
  SparseA := TSparseMtx.Create;
  { zero count is only estimated zero count. If the value is too small.
    then this will result in many memory reallocations by RandomSparse. }

  A.Size(0,0);
  { Setup legend }
  LegendSeries := TMtxGridSeries.Create(ColorChart);
  LegendSeries.Name := 'LegendSeriesName';
  LegendSeries.ParentChart := ColorChart;

  UpdateData;
end;

procedure TfrmMtxGridSeries.Timer1Timer(Sender: TObject);
begin
  UpdateData;
end;

type  TCustomFormClass=class of TCustomForm;

procedure TfrmMtxGridSeries.Button2Click(Sender: TObject);
var SeriesForm: TCustomForm;
    tmpClass: TPersistentClass;
begin
  tmpClass:=GetClass(GridSeries.EditorClass);
  SeriesForm:= TCustomFormClass(tmpClass).Create(Self);
  SeriesForm.TagObject:=GridSeries;
  SeriesForm.OnActivate(Self);
  {$IFDEF ANDROID}
  SeriesForm.Show; // not implemented on Android
  {$ELSE}
  SeriesForm.ShowModal;
  {$ENDIF}

  ThreeColorBox.IsChecked := (GridSeries.ColorPalette.MidColor <> TAlphaColors.Null);
  UpdateCharts;
end;

procedure TFrmMtxGridSeries.UpdateCharts;
begin
  ColorChart.Visible := GridSeries.PixelResample;
  Splitter1.Visible := GridSeries.PixelResample;
  DrawValues(A,GridSeries); { showing A }
end;

procedure TfrmMtxGridSeries.SharpContrastBoxChange(Sender: TObject);
begin
    GridSeries.ColorPalette.SharpContrast := SharpContrastBox.IsChecked;
    LegendSeries.SeriesToLegend(GridSeries,cslVertical);
end;

procedure TfrmMtxGridSeries.Chart1GetAxisLabel(Sender: TChartAxis; Series: TChartSeries; ValueIndex: Integer; var LabelText: String);
var tmp : Integer;
begin
    inherited;
    { invert axis labels}
    if (Sender = Chart1.LeftAxis) and (Assigned(GridSeries.Matrix)) then
    begin
        {$IFNDEF D15}
        tmp := Round(StrToFloat(StringReplace(LabelText,ThousandSeparator,'',[rfReplaceAll])));
        {$ELSE}
        tmp := Round(StrToFloat(StringReplace(LabelText,FormatSettings.ThousandSeparator,'',[rfReplaceAll])));
        {$ENDIF}
        tmp := GridSeries.Matrix.Rows - 1 - tmp;
        LabelText := IntToStr(tmp);
    end;
end;

procedure TfrmMtxGridSeries.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var index: Integer;
begin
    inherited;
    if CheckBox1.IsChecked then
    begin
        Chart1.Title.Text.Clear;
        index := GridSeries.Clicked(X,Y);
        if index <> -1 then
          Chart1.Title.Text.Add('Value at cursor: '+FormatFloat('0.00',GridSeries.Matrix.Values1D[index]))
        else Chart1.Title.Text.Add(' ');
    end;
end;

procedure TfrmMtxGridSeries.PaletteBarChange(Sender: TObject);
begin
    GridSeries.ColorPalette.ColorBalance :=  PaletteBar.Value/100;
    LegendSeries.SeriesToLegend(GridSeries,cslVertical);

    UpdateCharts;
end;

procedure TfrmMtxGridSeries.ThreeColorBoxChange(Sender: TObject);
begin
   if ThreeColorBox.IsChecked then GridSeries.ColorPalette.MidColor := TAlphaColors.Red
                              else GridSeries.ColorPalette.MidColor := TAlphaColors.Null;


   SharpContrastBox.Enabled := ThreeColorBox.IsChecked;

   LegendSeries.SeriesToLegend(GridSeries,cslVertical);
end;

procedure TfrmMtxGridSeries.PixelResampleBoxChange(Sender: TObject);
begin
   GridSeries.PixelResample := PixelResampleBox.IsChecked;
   GridSeries.ShowInLegend := not PixelResampleBox.IsChecked;
   LegendSeries.SeriesToLegend(GridSeries,cslVertical);

   UpdateCharts;
end;

initialization
  RegisterClass(TfrmMtxGridSeries);

end.

