unit Basic1;

//{$I BdsppDefs.inc}

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  Fmx.Forms,
  FMX.Header, MtxVec,Math387, FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types,
  FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;


type
  TBasicForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CheckDownSample: TCheckBox;
    RichEdit1: TMemo;
    Chart1: TChart;
    procedure CheckDownSampleClick(Sender: TObject);
  private
    FDownSize: boolean;
    procedure SetDownSize(const Value: boolean);
    { Private declarations }
  public
     TimeElapsed : double;
     property DownSize: boolean read FDownSize write SetDownSize;
    { Public declarations }
  end;

var
  BasicForm1: TBasicForm1;

implementation
{$R *.FMX}

procedure TBasicForm1.SetDownSize(const Value: boolean);
begin
  FDownSize := Value;
end;

procedure TBasicForm1.CheckDownSampleClick(Sender: TObject);
begin
     FDownSize := TCheckBox(Sender).IsChecked;
     Chart1.AllowZoom := Not(TCheckBox(Sender).IsChecked);
end;

end.
