unit BispectrumSurface;

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
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Layouts,

  FMXTee.Procs,
  FMXTee.Editor.EditorPanel,
  FMXTee.Engine,
  FMXTee.Series.Surface,
  FMXTee.Editor.Chart,
  FMXTee.Chart,
  FMXTee.Series,

  SignalToolsDialogs,
  FmxSpectrumAna,
  SignalTools,
  SignalAnalysis,
  FileSignal,
  SignalToolsTee,

  MtxBaseComp,
  MtxDialogs,
  MtxVec,
  FmxMtxComCtrls,
  MtxExpr, FMX.ScrollBox, FMX.Controls.Presentation;

type
  TBiSpectrumSurfaceForm = class(TForm)
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
    Series1: TSurfaceSeries;
    SingleLinesOnlyBox: TCheckBox;
    Button1: TButton;
    procedure ChartEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SingleLinesOnlyBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BiSpectrumSurfaceForm: TBiSpectrumSurfaceForm;

implementation

{$R *.FMX}

uses FmxMtxVecEdit, FmxMtxVecTee, SignalUtils, Math387, MtxVecUtils, Basic1;

procedure TBiSpectrumSurfaceForm.ChartEditButtonClick(Sender: TObject);
begin
    ChartEditor.Execute;
end;

procedure TBiSpectrumSurfaceForm.FormCreate(Sender: TObject);
begin
    SignalRead1.FileName := GetFile1('bz.sfs');

     BispectrumAnalyzer.Amplt.SetZero;
     With RichEdit1.Lines, RichEdit1 do
     begin
        Clear;
        Add('Bicoherence shows peaks where the frequency pair is related to a third frequency component ' +
            'defined as e^jw1 * e^jw2 = e^j(w1+w2). Bicoherence  ' +
            'will be 1 for a frequency pair (w1,w2) which has a product of itself (e^jw1*e^jw2) ' +
            'in the frequency spectrum. You can also compute only ' +
            'preselected frequency lines by checking the Single lines only box.');
        
        
     end;
     Button1Click(Sender);
end;

procedure TBiSpectrumSurfaceForm.Button1Click(Sender: TObject);
var av: Vector;
    i,j: integer;
begin
    SignalRead1.OpenFile;
    SignalRead1.RecordPosition := 0;
    SignalRead1.OverlappingPercent := 50;

    SetHourglassCursor;

    if SingleLinesOnlyBox.IsChecked then
    begin
        BispectrumAnalyzer.BiAnalyzer.SingleLinesOnly := True;
        BispectrumAnalyzer.BiAnalyzer.Lines.Length := 32; //compute only 32 lines
        BispectrumAnalyzer.BiAnalyzer.Lines.Ramp(16*SignalRead1.HzRes,SignalRead1.HzRes);
    end else BispectrumAnalyzer.BiAnalyzer.SingleLinesOnly := False;
    BispectrumAnalyzer.ResetAveraging;
    while (BispectrumAnalyzer.Pull <> pipeEnd) do
    begin
        ProgressLabel.Text := 'Progress: ' + FormatSample('0',SignalRead1.FrameNumber/SignalRead1.MaxFrames*100) + ' [%]';
//        Update;
    end;
    BispectrumAnalyzer.BiAnalyzer.Update; //compute bicoherence

    ClearFPU; //Required only for Delphi 4 and 5

    Series1.Clear;
    Series1.IrregularGrid := True;
    av.Size(0); //required by CLR only
    with BispectrumAnalyzer,BiAnalyzer do
    for i := 0 to Length div 2 - 1 do
    begin
         Frequency := i*HzRes;
         if not SingleLinesOnly then DecodeBispectrumMatrix(av) else DecodeSingleLineMatrix(av);
         for j := 0 to Length-1 do
         begin
             if av[j] <> 0 then
             Series1.AddXYZ(j*HzRes,av[j],i*HzRes);
         end;
    end;

    ResetCursor;
end;

procedure TBiSpectrumSurfaceForm.SingleLinesOnlyBoxClick(Sender: TObject);
begin
     Button1Click(Sender);
end;

initialization
RegisterClass(TBiSpectrumSurfaceForm);

end.
