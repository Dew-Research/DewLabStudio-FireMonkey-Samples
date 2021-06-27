unit MtxFastLineDemo;

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
  Basic1, MtxExpr, FmxMtxVecTee, Series, FmxMtxComCtrls, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, math387, FMX.Controls.Presentation, FMX.ScrollBox;



type
  TMtxFastLineForm = class(TBasicForm1)
    Timer1: TTimer;
    MtxFloatEdit: TMtxFloatEdit;
    Label1: TLabel;
    procedure MtxFloatEditChange(Sender: TObject);
  private
    { Private declarations }
    normalFast: TChartSeries;
    mtxFast: TChartSeries;
    Data: Vector;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  MtxFastLineForm: TMtxFastLineForm;

implementation

uses MtxVec;

{$R *.FMX}
{$R *.Windows.fmx MSWINDOWS}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

constructor TMtxFastLineForm.Create(AOwner: TComponent);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('New TMtxFastLinesSeires draws 3x faster than TFastLineSeries.');
    Add('Allows zoom-in and zoom-out with pixeldownsamle enabled.');
    Add('TMtxFastLineSeries can be used '
      + 'with all TeeChart versions (v4 Standard, v4 Pro, 5,6,7 and 8). ');
    Add('');
    Add('Try different data sizes and zooming and panning in the chart.');
  end;

  Chart1.FreeAllSeries(nil);
  normalfast := Chart1.AddSeries(TFastLineSeries.Create(Chart1));
  normalfast.Title := 'TFastlineSeries';

  mtxfast := Chart1.AddSeries(TMtxFastLineSeries.Create(Chart1));
  mtxfast.Title := 'TMTxFastLineSeries';

  MtxFloatEditChange(nil);
end;

procedure TMtxFastLineForm.MtxFloatEditChange(Sender: TObject);
begin
  chart1.Zoom.Allow := True;
  Data.Size(MtxFloatEdit.IntPosition);
  Data.RandGauss(4.0,1.0);

  StartTimer;
  try
    DrawValues(Data,mtxfast,0,1,false);
  finally
    TimeElapsed := Round(StopTimer*1000);
  end;

  StartTimer;
  try
    DrawValues(Data,normalfast,0,1,CheckDownSample.IsChecked);
  finally
    TimeElapsed := Round(StopTimer*1000);
  end;
end;

initialization
  RegisterClass(TMtxFastLineForm);

end.

