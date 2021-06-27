unit PinkNoise;

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
  MtxVec, AbstractMtxVec, Math387, FMXTee.Editor.EditorPanel, FMX.Edit,
  FmxMtxComCtrls, FMX.ListBox, FMXTee.Engine, FMXTee.Series, FmxMtxVecTee,
  FMXTee.Procs, FMXTee.Chart, SignalToolsTee, FMX.Controls.Presentation;


type
  TPinkNoiseForm = class(TForm)
    SpectrumChart: TSpectrumChart;
    Panel1: TPanel;
    Series1: TMtxFastLineSeries;
    NoiseBox: TComboBox;
    Label1: TLabel;
    FsLabel: TLabel;
    FSEdit: TMtxFloatEdit;
    ChartEditor1: TChartEditor;
    procedure FormCreate(Sender: TObject);
    procedure NoiseBoxChange(Sender: TObject);
    procedure FSEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PinkNoiseForm: TPinkNoiseForm;

implementation

uses MtxExpr, FmxMtxVecEdit, StringVar, Polynoms, SignalUtils;

{$R *.FMX}

procedure TPinkNoiseForm.FSEditChange(Sender: TObject);
begin
    NoiseBoxChange(Sender);
end;

procedure TPinkNoiseForm.NoiseBoxChange(Sender: TObject);
var StartBw, FS, dbPerDecade: TSample;
    H, Response: Vector;
begin
     H.Size(0);  //needed for iOS simulator
     Response.Size(0);  //needed for iOS simulator

    dbPerDecade := 0;
    FS := FSEdit.FloatPosition; //Hz
    StartBW := 0.1; //Hz
    case NoiseBox.ItemIndex of
    0: dBPerDecade := 10;  //dB  //pink
    1: dBPerDecade := 20;  //dB  //brown
    2: dBPerDecade := -10;  //dB //blue
    3: dBPerDecade := -20;  //dB //violet
    end;
    ColoredNoiseFir(H, dbPerDecade, StartBW, FS);

    FrequencyResponse(H, nil, Response,4);
    Response.Resize(Response.Length-1);
    Response.Abs;
    Response.Log10;
    Response.Scale(20);

    Series1.Title := 'Response';
    DrawValues(Response, Series1, 0, (FS/2)/Response.Length);
    Caption := 'Poink noise - filter length = ' + IntToStr(H.Length);
end;

procedure TPinkNoiseForm.FormCreate(Sender: TObject);
begin
    NoiseBox.ItemIndex := 0;
    NoiseBoxChange(Sender);
end;

initialization
    RegisterClass(TPinkNoiseForm);

end.
