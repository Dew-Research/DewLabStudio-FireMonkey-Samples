unit MedianDemo;

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
  Fmx.StdCtrls,
  FMX.Header, FMXTee.Editor.EditorPanel, FMXTee.Engine, FMXTee.Series,
  FMXTee.Procs, FMXTee.Chart, SignalToolsTee, FMX.Layouts, FMX.Memo, FMX.Edit,
  FmxMtxComCtrls, FMX.ListBox, SignalUtils, FMX.Controls.Presentation,
  FMX.ScrollBox;


type
  TMedianDemoForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SignalChart1: TSignalChart;
    Series3: TFastLineSeries;
    Series1: TFastLineSeries;
    FilterBox: TComboBox;
    Label1: TLabel;
    StepEdit: TMtxFloatEdit;
    Label2: TLabel;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FilterBoxChange(Sender: TObject);
    procedure StepEditChange(Sender: TObject);
  private
    MedianState: TMedianState;
    DelayState: TDelayFilterState;
    procedure UpdateDelay;
    procedure UpdateMedian;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MedianDemoForm: TMedianDemoForm;

implementation

uses Math387, MtxVec, FmxMtxVecTee, MtxVecInt;

{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.FMX}
{$ENDIF}

procedure TMedianDemoForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TMedianDemoForm.FormCreate(Sender: TObject);
begin
    SignalChart1.Legend.Visible := True; 
    FilterBox.ItemIndex := 0; 
    FilterBoxChange(Sender);
    With RichEdit1.Lines, RichEdit1 do
    begin
      Clear;
      Add('The chart shows a ramp filtered through a median or an integer delay filter. ' +
          'Median and delay filter are both streaming filters. The size of the block ' +
          'is set to 10 and the mask size can be varied. Change the mask size to test both ' +
          'filters. If the filter work Ok, increasing the mask size will shift the ramp to the right.');
    end;
end;

procedure TMedianDemoForm.UpdateMedian;
var a,b: TVec;
    i,BlockLength, MaskSize: integer;
begin
    CreateIt(a,b);
    MaskSize := StepEdit.IntPosition;
    MedianInit(MaskSize,MedianState, a.FloatPrecision);
    try
         a.Size(1000,false);
         b.Size(a);
         a.Ramp;
         BlockLength := 10; 
         for i := 0 to (a.Length div BlockLength) - 1 do
         begin
             a.SetSubRange(i*BlockLength,BlockLength);
             b.SetSubRange(i*BlockLength,BlockLength);
             MedianFilter(a,b,MedianState);
         end;
         a.SetFullRange;
         b.SetFullRange;
         DrawValues(a,SignalChart1.Series[0]);
         DrawValues(b,SignalChart1.Series[1]);
    finally
         MedianFree(MedianState);
         FreeIt(a,b);
    end;
end;

procedure TMedianDemoForm.UpdateDelay;
var a,b: TVec;
    i,BlockLength, DelayLength: integer;
begin
    CreateIt(a,b);
    DelayLength := StepEdit.IntPosition;
    DelayInit(DelayLength,DelayState, a.FloatPrecision);
    try
         a.Size(1000,false);
         b.Size(a);
         a.Ramp;
         BlockLength := 10;  //try with n >  mask size
         for i := 0 to (a.Length div BlockLength) - 1 do
         begin
             a.SetSubRange(i*BlockLength,BlockLength);
             b.SetSubRange(i*BlockLength,BlockLength);
             DelayFilter(a,b,DelayState);
         end;
         a.SetFullRange;
         b.SetFullRange;
         DrawValues(a,SignalChart1.Series[0]);
         DrawValues(b,SignalChart1.Series[1]);
    finally
         DelayFree(DelayState);
         FreeIt(a,b);
    end;
end;

procedure TMedianDemoForm.FilterBoxChange(Sender: TObject);
begin
     case FilterBox.ItemIndex of
     0: UpdateMedian;
     1: UpdateDelay;
     end;
end;

procedure TMedianDemoForm.StepEditChange(Sender: TObject);
begin
     FilterBoxChange(Sender);
end;

initialization
RegisterClass(TMedianDemoForm);

end.
