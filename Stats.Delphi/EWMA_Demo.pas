unit EWMA_Demo;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup, FMXTee.Canvas,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form,
  MtxVec,
  Math387, FMX.Edit, FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types,
  FMX.Controls.Presentation, FMX.ScrollBox;

type
  TfrmEWMA = class(TfrmBasic)
    Panel2: TPanel;
    Chart1: TChart;
    RadioGroup1: TPanel;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    AsymptoteButton: TRadioButton;
    ExactButton: TRadioButton;
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Chart1AfterDraw(Sender: TObject);
    procedure ExactButtonChange(Sender: TObject);
    procedure AsymptoteButtonChange(Sender: TObject);
  private
    { Private declarations }
    RadioGroup1ItemIndex: integer;
    Data: TMtx;
    vucl,vlcl, DrawVec: TVec;
    ucl,lcl,cl, r, Confidence: TSample;
  public
    { Public declarations }
  end;

var
  frmEWMA: TfrmEWMA;

implementation

Uses StatSeries, FmxMtxVecTee, FmxMtxVecEdit, StatControlCharts;

{$R *.FMX}

procedure TfrmEWMA.RadioGroup1Click(Sender: TObject);
begin
  Chart1.FreeAllSeries;
  case RadioGroup1ItemIndex of
    0:  begin
          Chart1.AddSeries(TQCSeries.Create(Chart1));
          EWMAChart(Data,DrawVec,cl,ucl,lcl,r,Confidence);
          Chart1.Legend.Visible := False;
          DrawValues(DrawVec,Chart1.Series[0],0,1,false);
          Chart1.Series[0].SeriesColor := TAlphaColors.Blue;
          (Chart1.Series[0] as TQCSeries).ControlLimitPen.Color := TAlphaColors.Red;
          (Chart1.Series[0] as TQCSeries).CL := cl;
          (Chart1.Series[0] as TQCSeries).UCL := ucl;
          (Chart1.Series[0] as TQCSeries).LCL := lcl;
        end;
    1:  begin
          Chart1.AddSeries(TLineSeries.Create(Chart1));
          Chart1.AddSeries(TLineSeries.Create(Chart1));
          Chart1.AddSeries(TLineSeries.Create(Chart1));
          EWMAChart(Data,DrawVec,cl,vucl,vlcl,r,Confidence);
          Chart1.Legend.Visible := True;
          With Chart1.Series[0] as TLineSeries do
          begin
            Pointer.Visible := True;
            SeriesColor := TAlphaColors.Blue;
            Title := 'Data';
          end;
          Chart1.Series[1].SeriesColor := TAlphaColors.Red;
          (Chart1.Series[1] as TLineSeries).Pen.Style := TPenStyle.psDot;
          Chart1.Series[1].Title := 'UCL';
          Chart1.Series[2].SeriesColor := TAlphaColors.Red;
          (Chart1.Series[2] as TLineSeries).Pen.Style := TPenStyle.psDot;
          Chart1.Series[2].Title := 'LCL';
          DrawValues(DrawVec,Chart1.Series[0],0,1,false);
          DrawValues(vucl,Chart1.Series[1],0,1,false);
          DrawValues(vlcl,Chart1.Series[2],0,1,false);
        end;
    end;
end;

procedure TfrmEWMA.FormCreate(Sender: TObject);
var aPath: string;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('New in release 1.1: support for Exponential weighted moving average chart (EWMA)');
    Add(' This example shows you how to construct EWMA chart. EWMAChart procedure supports '+
        'asymptote value and exact value for control limits.');
  end;

  Data := TMtx.Create;
  DrawVec := TVec.Create;
  vucl := TVec.Create;
  vlcl := TVec.Create;

  aPath := GetDataPath + 'ewma_data.MTX';
  Data.LoadFromFile(aPath);

  r := 0.35;
  Confidence := 0.9987;
  Edit1.Text := FloatToStr(r);
  Edit2.Text := FloatToStr(Confidence);
  RadioGroup1Click(RadioGroup1);
end;

procedure TfrmEWMA.FormDestroy(Sender: TObject);
begin
  Data.Free;
  DrawVec.Free;
  vucl.Free;
  vlcl.Free;
  inherited;
end;

procedure TfrmEWMA.AsymptoteButtonChange(Sender: TObject);
begin
    if AsymptoteButton.IsChecked then RadioGroup1ItemIndex := 0;
    RadioGroup1Click(RadioGroup1);
end;

procedure TfrmEWMA.Button1Click(Sender: TObject);
begin
  ViewValues(Data,'EWMA data',true,false);
end;

procedure TfrmEWMA.Edit1Change(Sender: TObject);
begin
  if Visible then
  begin
    try
      r := StrToFloat(Edit1.Text);
    except
      r := 0.35;
    end;
    RadioGroup1Click(RadioGroup1);
  end;
end;

procedure TfrmEWMA.Edit2Change(Sender: TObject);
begin
  if Visible then
  begin
    try
      Confidence := StrToFloat(Edit2.Text);
    except
      Confidence := 0.9987;
    end;
    RadioGroup1Click(RadioGroup1);
  end;
end;

procedure TfrmEWMA.ExactButtonChange(Sender: TObject);
begin
    if ExactButton.IsChecked then RadioGroup1ItemIndex := 1;
    RadioGroup1Click(RadioGroup1);
end;

procedure TfrmEWMA.Chart1AfterDraw(Sender: TObject);
begin
  if RadioGroup1ItemIndex = 1 then
  with Chart1.Canvas, Chart1 do
  begin
    Pen.Color := TAlphaColors.Blue;
    MoveTo(ChartRect.Left,Chart1.LeftAxis.CalcPosValue(cl));
    ClipRectangle(ChartRect);
    LineTo(ChartRect.Right,Chart1.LeftAxis.CalcPosValue(cl));
    UnclipRectangle;
  end;
end;

Initialization
  RegisterClass(TfrmEWMA);

end.

