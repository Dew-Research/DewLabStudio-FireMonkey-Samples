unit BrowseDemo;

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
    FMX.Header,
    FMX.Layouts,
    FMX.Memo,
    FMX.ListBox,
    FMX.Memo.Types,
    FMX.ScrollBox,
    FMX.Controls.Presentation,

    FMXTee.Editor.EditorPanel,
    FMXTee.Engine,
    FMXTee.Series.Error,
    FMXTee.Procs,
    FMXTee.Chart,

    Math387,
    MtxVec,
    MtxExpr,
    MtxForLoop,
    MtxBaseComp,
    FmxMtxComCtrls,
    MtxDialogs,

    FileSignal,
    SignalToolsTee,
    SignalSeriesTee,
    FmxSpectrumAna,
    SignalUtils,
    SignalTools;


type
  TBrowseDemoForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartButton: TButton;
    RichEdit1: TMemo;
    Panel2: TPanel;
    SignalChart1: TSignalChart;
    Signal1: TSignal;
    Series1: TSignalHighLowSeries;
    SignalBrowse1: TSignalBrowse;
    OpenDialog1: TOpenDialog;
    OpenFileButton: TButton;
    ChartEditor: TChartEditor;
    Label1: TLabel;
    ChannelBox: TComboBox;
    ThreadedBox: TCheckBox;
    PositionPanel: TProgressBar;
    MtxThread: TMtxProgressDialog;
    procedure FormCreate(Sender: TObject);
    procedure ChartButtonClick(Sender: TObject);
    procedure OpenFileButtonClick(Sender: TObject);
    procedure ChannelBoxChange(Sender: TObject);
    procedure SignalBrowse1ProgressUpdate(Sender: TObject; Event: TMtxProgressEvent);
    procedure ToolButton1Click(Sender: TObject);
    procedure SignalChart1UndoZoom(Sender: TObject);
    procedure SignalChart1Zoom(Sender: TObject);
    procedure SignalChart1Scroll(Sender: TObject);
  private
    procedure BrowseChartUpdate(DtOffset: TSample);
    procedure DrawOverviewSeries(Src: TVec; Series: TChartSeries; DtOffset, Dt: TSample);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrowseDemoForm: TBrowseDemoForm;

implementation

uses FmxMtxVecTee, MtxVecUtils;

{$R *.FMX}

procedure TBrowseDemoForm.FormCreate(Sender: TObject);
begin
     ChannelBox.ItemIndex := 0;
     SignalBrowse1.ProgressRuntime := MtxThread.Runtime;
     SignalBrowse1.ProgressRuntime.UpdateInterval := 50; //20x times per second updates progress bar
     SignalBrowse1.OverviewRepositoryPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Data';
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Open a few 10MB long uncompressed wav file. The chart will display signal overview.' +
          'For 200 MB long wav file, it takes a little less then 6 seconds to create the overview. ' +
          '(.pk file). This demo will place a .pk file with same name as the opened wav file in the ' +
          'same directory where the opened .wav file resides. If the wav file date/time stamp ' +
          'has changed, since the time when the .pk file was first created, ' +
          'the old .pk file will be deleted and new one created.');
    end;
end;


procedure TBrowseDemoForm.ChartButtonClick(Sender: TObject);
begin
     ChartEditor.Execute;
end;

procedure TBrowseDemoForm.DrawOverviewSeries(Src: TVec; Series: TChartSeries; DtOffset,Dt: TSample);
begin
     if SignalBrowse1.IsOverview then
     begin
         TSignalHighLowSeries(Series).SeriesDataType := ssdHighLow;
         TSignalHighLowSeries(Series).SeriesMode := ssmAuto;
         TSignalHighLowSeries(Series).AddHighLowValues(Src, DtOffset, Dt);
     end else
     begin
         TSignalHighLowSeries(Series).SeriesDataType := ssdLine;
         TSignalHighLowSeries(Series).SeriesMode := ssmAuto;
         DrawValues(Src,Series,DtOffset, Dt,True);
     end;
end;


procedure TBrowseDemoForm.BrowseChartUpdate(DtOffset: TSample);
var a1: Vector;
begin
     a1.Size(0); //required by CLR to initialize the Vector, you can also call the constructor
     SignalChart1.Series[0].Clear;
     case SignalBrowse1.ChannelCount of
     1: begin
        Demultiplex(SignalBrowse1.Data,a1,SignalBrowse1.ChannelCount, 0);
        DrawOverviewSeries(a1,SignalChart1.Series[0], DtOffset, SignalBrowse1.Dt);
        end;
     2: begin
        case ChannelBox.ItemIndex of
        0: begin //left channel
            Demultiplex(SignalBrowse1.Data,a1,SignalBrowse1.ChannelCount, 0);
            DrawOverviewSeries(a1,SignalChart1.Series[0], DtOffset, SignalBrowse1.Dt);
           end;
        1: begin
            Demultiplex(SignalBrowse1.Data,a1,SignalBrowse1.ChannelCount, 1);
            DrawOverviewSeries(a1,SignalChart1.Series[0], DtOffset, SignalBrowse1.Dt);
           end;
        end;
        end;
     end;
end;

procedure TBrowseDemoForm.OpenFileButtonClick(Sender: TObject);
begin
     if OpenDialog1.Execute then
     begin
          SignalBrowse1.Threaded := ThreadedBox.IsChecked;
          SetHourGlassCursor;
          SignalBrowse1.OpenBrowseFile(OpenDialog1.FileName);
          if not SignalBrowse1.Threaded then
          begin
                SignalBrowse1.LoadFullRecord;
                BrowseChartUpdate(0);
          end;
          ResetCursor;
     end;
end;


procedure TBrowseDemoForm.ChannelBoxChange(Sender: TObject);
begin
     BrowseChartUpdate(0);
end;

procedure TBrowseDemoForm.SignalBrowse1ProgressUpdate(Sender: TObject;
  Event: TMtxProgressEvent);
begin
     case Event of
     peCycle:   begin
                PositionPanel.Value := SignalBrowse1.SignalFile.RecordPosition/SignalBrowse1.SignalFile.RecordLength*100;
//                PositionPanel.Caption := FormatFloat('0',PositionPanel.Value) + '[%]';
                end;
     peCleanUp: begin
                PositionPanel.Value := 100;
//                PositionPanel.Caption := FormatFloat('0',PositionPanel.SliderSpan) + '[%]';
                SignalBrowse1.LoadFullRecord;
                BrowseChartUpdate(0);
                end;
     end;
end;

procedure TBrowseDemoForm.SignalChart1Scroll(Sender: TObject);
begin
    signalBrowse1.RecordTimePosition := Max(signalChart1.Axes.Bottom.Minimum, 0);
    BrowseChartUpdate(signalBrowse1.RecordTimePosition);
end;

procedure TBrowseDemoForm.SignalChart1UndoZoom(Sender: TObject);
begin
    signalBrowse1.LoadFullRecord();
    BrowseChartUpdate(0);
end;

procedure TBrowseDemoForm.SignalChart1Zoom(Sender: TObject);
begin
    signalBrowse1.SpanTime := signalChart1.Axes.Bottom.Maximum - signalChart1.Axes.Bottom.Minimum;
		signalBrowse1.RecordTimePosition := Max(signalChart1.Axes.Bottom.Minimum, 0);
    BrowseChartUpdate(signalBrowse1.RecordTimePosition);
end;

procedure TBrowseDemoForm.ToolButton1Click(Sender: TObject);
begin
    PositionPanel.Value := 0;
end;

initialization
RegisterClass(TBrowseDemoForm);

end.
