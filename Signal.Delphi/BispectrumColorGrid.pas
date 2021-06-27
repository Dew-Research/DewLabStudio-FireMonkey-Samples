unit BispectrumColorGrid;

interface

uses

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Menus,
  FMX.Layouts,
  FMX.Memo,
  FMX.StdCtrls,

  FMXTee.Editor.EditorPanel,
  FMXTee.Chart,
  FMXTee.Procs,
  FMXTee.Engine,
  FMXTee.Series,
  FMXTee.Editor.Chart,
  FMXTee.Series.Surface,

  SignalToolsTee,
  SignalToolsDialogs,
  FmxSpectrumAna,
  SignalTools,
  SignalAnalysis,
  FileSignal,
  MtxBaseComp,
  FmxMtxVecTee,
  MtxExpr,
  FmxMtxComCtrls,
  MtxVec,
  MtxDialogs, FMX.ScrollBox, FMX.Controls.Presentation;

type
  TBiSpectrumGridForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ChartEditButton: TButton;
    ChartEditor: TChartEditor;
    RichEdit1: TMemo;
    SignalRead1: TSignalRead;
    BiSpectrumAnalyzer: TBiSpectrumAnalyzer;
    Panel2: TPanel;
    ProgressLabel: TLabel;
    Chart1: TChart;
    SingleLinesOnlyBox: TCheckBox;                                       
    Series1: TMtxGridSeries;
    Button1: TButton;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SingleLinesOnlyBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BMtx: Matrix;
  end;

var
  BiSpectrumGridForm: TBiSpectrumGridForm;

implementation

{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.FMX}
{$ENDIF}

uses FmxMtxVecEdit, SignalUtils, Math387, MtxVecUtils, Basic1;

procedure TBiSpectrumGridForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TBiSpectrumGridForm.FormCreate(Sender: TObject);
begin
     SignalRead1.FileName := GetFile1('bz.sfs');

     BispectrumAnalyzer.Amplt.SetZero;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Bicoherence shows dark blue dots where the frequency pair is related to a third frequency component ' +
            'defined as e^jw1 * e^jw2 = e^j(w1+w2). Bicoherence  ' +
            'will be 1 for a frequency pair (w1,w2) which has a product of itself (e^jw1*e^jw2) ' +
            'in the frequency spectrum. You can also compute only ' +
            'preselected frequency lines by checking the Only a few lines box.');
        
        
     end;
     Button1Click(Sender);
end;

procedure TBiSpectrumGridForm.Button1Click(Sender: TObject);
begin
//    Screen.Cursor := crHourGlass;
    SetHourGlassCursor;
    SignalRead1.OpenFile;
    SignalRead1.RecordPosition := 0;
    SignalRead1.OverlappingPercent := 50;
    if SingleLinesOnlyBox.IsChecked then
    begin
        BispectrumAnalyzer.BiAnalyzer.SingleLinesOnly := True;
        BispectrumAnalyzer.BiAnalyzer.Lines.Length := 128; //compute only 256 lines
        BispectrumAnalyzer.BiAnalyzer.Lines.Ramp(64*SignalRead1.HzRes,SignalRead1.HzRes);
    end else BispectrumAnalyzer.BiAnalyzer.SingleLinesOnly := False;
    BispectrumAnalyzer.ResetAveraging;
    while (BispectrumAnalyzer.Pull <> pipeEnd) do
    begin
        ProgressLabel.Text := 'Progress: ' + FormatSample('0',SignalRead1.FrameNumber/SignalRead1.MaxFrames*100) + ' [%]';
//        Update;
    end;
    BispectrumAnalyzer.BiAnalyzer.Update; //compute bicoherence

//    BMtx.Size(0,0); //required by CLR only;
    BispectrumAnalyzer.BiAnalyzer.GetFullSpectrum(BMtx.Size(0,0),True);

    ClearFPU; //Required only for Delphi 4 and 5
    Series1.Clear;
    Series1.ColorPalette.TopColor := TAlphaColors.Blue;
    Series1.ColorPalette.BottomColor := clWhite;
    Series1.Matrix := BMtx; //must be set...
    ResetCursor;
//    Screen.Cursor := crDefault;
end;

procedure TBiSpectrumGridForm.SingleLinesOnlyBoxClick(Sender: TObject);
begin
     Button1Click(Sender);
end;

initialization
RegisterClass(TBiSpectrumGridForm);

end.
