unit Basic_Chart;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form, FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types, FMX.ScrollBox,
  FMX.Controls.Presentation;


type
  TfrmBasicChart = class(TfrmBasic)
    Chart1: TChart;
    Panel2: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBasicChart: TfrmBasicChart;

implementation

Uses FMXTee.Editor.Chart;
{$R *.FMX}

procedure TfrmBasicChart.Button1Click(Sender: TObject);
begin
    TChartEditForm.Edit(Self,Chart1);
end;

end.
