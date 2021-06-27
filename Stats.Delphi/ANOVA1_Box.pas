unit ANOVA1_Box;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  FMXTee.Chart,
  FMXTee.Procs,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form, MtxBaseComp, StatTools, System.Rtti, FMX.Grid, FMX.Edit,
  FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types, FMX.Controls.Presentation,
  FMXTee.Editor.EditorPanel, FMX.ScrollBox, FMX.Memo.Types, FMX.Grid.Style;

type
  TfrmANOVA1Box = class(TfrmBasic)
    Chart1: TChart;
    Panel2: TPanel;
    StringGrid1: TStringGrid;           
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    MtxAnova: TMtxAnova;
    ChartEditor1: TChartEditor;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmANOVA1Box: TfrmANOVA1Box;

implementation

Uses FmxMtxVecEdit, MtxVec, FmxMtxVecTee, FMXTee.Series.BoxPlot, FMXTee.Editor.Chart;

{$R *.FMX}

procedure TfrmANOVA1Box.FormCreate(Sender: TObject);
var aPath: string;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('TMtxANOVA component - Analysis of variance in one step');
    Add(chr(13));
    Add('Just drop the TMtxANOVA component on the form, define '+
        'data, connect it to TStringGrid and .... that''s it');
    Add('By using TeeChart v5 (http://www.steema.com) series you can '+
        'also visualize results of ANOVA. Most properies of chart are fully '+
        'editable - just click "Edit Chart" button.');
  end;


  aPath := GetDataPath + 'ANOVA1_Data.mtx'; {Load signal}

  MtxANOVA.Data.LoadFromFile(aPath);


  Edit1.Text := FormatFloat('0.00',MtxANOVA.Alpha);
  Button2Click(Self); { force recalculation }
end;

procedure TfrmANOVA1Box.Edit1Change(Sender: TObject);
begin
  try
    MtxAnova.Alpha := StrToFloat(Edit1.Text);
  except
  end;
end;

procedure TfrmANOVA1Box.Button2Click(Sender: TObject);
var i : Integer;
    tmpVec: TVec;
begin
  { calculate ANOVA }
  MtxANOVA.ResultDest := StringGrid1;
  MtxANOVA.Recalc;
  CreateIt(tmpVec);
  try
    { draw box plots - one series for each column }
    Chart1.FreeAllSeries;
    for i := 0 to MtxANOVA.Data.Cols - 1 do
    begin
      Chart1.AddSeries(THorizBoxSeries.Create(Chart1));
      tmpVec.GetCol(MtxANOVA.Data,i);
      With THorizBoxSeries(Chart1.Series[i]) do
      begin
        Position := i;
        Box.Brush.Color := TAlphaColors.Yellow;
        Pen.Color := TAlphaColors.Red;
        SeriesColor := TAlphaColors.Red;
      end;
      Chart1.Series[i].Title := 'Column ' + IntToStr(i);
      tmpVec.SortAscend;
      DrawValues(tmpVec,Chart1.Series[i],0);
    end;
  finally
    FreeIt(tmpVec);
  end
end;

procedure TfrmANOVA1Box.Button3Click(Sender: TObject);
begin
   TChartEditForm.Edit(Self, Chart1);
end;

procedure TfrmANOVA1Box.Button1Click(Sender: TObject);
begin
  ViewValues(MtxANOVA.Data,'Editing data ...', true, false);
end;

initialization
  RegisterClass(TfrmANOVA1Box);

end.
