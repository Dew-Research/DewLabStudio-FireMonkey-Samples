unit SpectrogramDemo;

interface

uses  System.SysUtils,
      System.Types,
      System.UITypes,
      System.Classes,
      System.IOUtils,

      FMX.Types,
      FMX.Controls,
      FMX.Forms,
      FMX.Dialogs,
      FMX.Controls.Presentation,
      FMX.StdCtrls,
      FMX.Header,

      FMXTee.Chart,
      FMXTee.Procs,
      FMXTee.Engine,
      FMXTee.Series,
      FMXTee.Editor.EditorPanel,

      FmxMtxVecTee,
      FmxMtxGridSerEdit,

      MtxBaseComp,
      MtxDialogs,
      MtxForLoop,
      SignalProcessing,
      SignalAnalysis,
      SignalTools,
      FileSignal;


type
  TSpectrogramDemoForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Chart1: TChart;
    OpenDialog: TOpenDialog;
    SignalRead: TSignalRead;
    Spectrogram: TSpectrogram;
    SpectrumAnalyzer: TSpectrumAnalyzer;
    SignalDemux1: TSignalDemux;
    ComputeSpectrogramThread: TMtxProgressDialog;
    Series1: TMtxGridSeries;
    ChartEditor1: TChartEditor;
    ProgressPanel: TProgressBar;
    procedure OKButtonClick(Sender: TObject);
    procedure ComputeSpectrogramThreadCompute(Sender: TObject);
    procedure ComputeSpectrogramThreadProgressUpdate(Sender: TObject;    Event: TMtxProgressEvent);
//    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure SignalDemux1AfterUpdate(Sender: TObject);
    procedure SpectrumAnalyzerAfterUpdate(Sender: TObject);
    procedure SpectrogramAfterUpdate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Chart1DblClick(Sender: TObject);
  private
    procedure UpdateSpectrogram(Src: TSpectrogram; Series: TMtxGridSeries);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SpectrogramDemoForm: TSpectrogramDemoForm;

implementation

uses Math387, MtxVec, MtxVecUtils, Basic1;

{$R *.FMX}

procedure TSpectrogramDemoForm.Chart1DblClick(Sender: TObject);
begin
    ChartEditor1.Execute;
end;

procedure TSpectrogramDemoForm.ComputeSpectrogramThreadCompute(Sender: TObject);
begin
    if not SignalRead.IsEndOfFile then
    begin
         Spectrogram.Pull;
    end else ComputeSpectrogramThread.Cancel := True;
end;

procedure TSpectrogramDemoForm.ComputeSpectrogramThreadProgressUpdate(
  Sender: TObject; Event: TMtxProgressEvent);
var bDst: TSignalRead;
    a: TSpectrumAnalyzer;
begin
     bDst := SignalRead;
     a := SpectrumAnalyzer;
     case Event of
     peInit:    begin
                with ProgressPanel do
                begin
                     Min := 0;
                     Max := 100;
                     Value := 0;
                     Caption := 'Spectrogram 0%';
                     Visible := True;
                end;

                SetHourGlassCursor;

                ComputeSpectrogramThread.UpdateInterval := 50;
                Spectrogram.Reset;
                Spectrogram.MaxSpectrumCount := bDst.MaxFrames;

                a.Stats.Averaging := avNone;
                a.Rotation := 0;
                a.Logarithmic := false; //because then it can be applied later.
                a.LogType := ltAbsolute;
                a.ResetAveraging;
                a.SuspendNotifyUpdate := true;
                end;
     peCycle:   begin
                ProgressPanel.Value := bDst.FrameNumber/bDst.MaxFrames*100;
                end;
     peCleanUp: begin
                Spectrogram.SpectralSamplingFrequency := bDst.FramesPerSecond;
                bDst.CloseFile;
                ProgressPanel.Visible := False;
                ResetCursor;

                Series1.ColorPalette.ResetPeakScale;
                UpdateSpectrogram(Spectrogram, Series1);
                end;
     end;
end;

procedure TSpectrogramDemoForm.FormCreate(Sender: TObject);
begin
    Series1.ColorPalette.UseMidColor := true;
    Series1.ColorPalette.Rainbow.BottomToMid := True;
    Series1.ColorPalette.Rainbow.MidToTop := true;
    Series1.ColorPalette.ColorBalanceMid := -0.85; //10%
    series1.ColorPalette.PaletteScale := ppsPeakHold; //do not adapt palette on zoom
    Series1.PixelResampleMethod := pdsAverage; //reduce spectrogram bitmap by averaging mask
    series1.PixelResample := true; //enable bitmap size reduction before drawing.

    SignalRead.FileName := GetFile1('bz.sfs');

    SignalRead.OpenFile;
    SignalRead.Length := 1024*SignalRead.ChannelCount;
    SignalRead.OverlappingPercent := 98;
    SignalRead.RecordPosition := 0;

    //limit the size of spectrogram so that we don't run out of mem
//    SignalRead.SelectionStop := Min(SignalRead.RecordLength, 10000 * 100);

    ComputeSpectrogramThread.Start;
end;

procedure TSpectrogramDemoForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    if Key = vkESCAPE then
    begin
        ComputeSpectrogramThread.Cancel := True;
    end;
end;

procedure TSpectrogramDemoForm.UpdateSpectrogram(Src: TSpectrogram; Series: TMtxGridSeries);
begin
     if not Assigned(Src) then
     begin
         Series.Clear;
         Exit;
     end;

     if Src.Count > 0 then
     begin
         Src.CopyAmpltTransposed(Series.Matrix);

         Series.XOffset := 0;
         Series.YOffset := 0;
         if Src.Count > 0 then
         begin
             Series.YStep := Src.Spectrum[0].HzRes;
             Series.XStep := Src.SpectralDt;
         end;

         Series.ShowInLegend := false;
         Series.Update;
     end else
     begin
        Series.Clear;
     end;
end;

procedure TSpectrogramDemoForm.OKButtonClick(Sender: TObject);
begin
    OpenDialog.Filter := SignalDialogFilter;
    OpenDialog.FilterIndex := 8;
    if OpenDialog.Execute then
    begin
        if FileExists(OpenDialog.FileName) then
        begin
            SignalRead.FileName := OpenDialog.FileName;
            SignalRead.OpenFile;
            SignalRead.Length := 1024*SignalRead.ChannelCount;
            SignalRead.OverlappingPercent := 0;
            SignalRead.RecordPosition := 0;

            //limit the size of spectrogram so that we don't run out of mem
            SignalRead.SelectionStop := Min(SignalRead.RecordLength, 10000 * 100);

            ComputeSpectrogramThread.Start;
        end;
    end;
end;

procedure TSpectrogramDemoForm.SignalDemux1AfterUpdate(Sender: TObject);
begin
    //
end;

procedure TSpectrogramDemoForm.SpectrogramAfterUpdate(Sender: TObject);
begin
        //
end;

procedure TSpectrogramDemoForm.SpectrumAnalyzerAfterUpdate(Sender: TObject);
begin
    //
end;

initialization
  RegisterClass(TSpectrogramDemoForm);

end.
