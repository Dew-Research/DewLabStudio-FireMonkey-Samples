unit YuleLevinson;

interface

uses

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Objects,
  FMX.ExtCtrls,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  Basic1, MtxVec,
  Toeplitz, Math387, FmxMtxVecEdit, MtxExpr, AbstractMtxVec, FMXTee.Engine,
  FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.ListBox, FMX.ScrollBox,
  FMX.Controls.Presentation, FMX.Memo.Types;


type
  TYuleLev = class(TBasicForm1)
    Panel3: TPanel;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar2: TTrackBar;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label7: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Item0: TListBoxItem;
    Item1: TListBoxItem;
    Item2: TListBoxItem;
    Item3: TListBoxItem;
    Item4: TListBoxItem;
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    CorrLen : Integer;
    ZeroPadding : Integer;
    LPCCoef : Integer;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  YuleLev: TYuleLev;

implementation

Uses FmxMtxVecTee, IOUtils, MtxVecInt;

{$R *.FMX}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}
{$R *.XLgXhdpiTb.fmx ANDROID}

procedure TYuleLev.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex  of
  0    : ZeroPadding := 1;
  1    : ZeroPadding := 2;
  2    : ZeroPadding := 4;
  3    : ZeroPadding := 8;
  4    : ZeroPadding := 16;
  end;
end;

constructor TYuleLev.Create(AOwner: TComponent);
begin
  inherited;
  FormCreate(Self);
end;

procedure TYuleLev.FormCreate(Sender: TObject);
begin
  Controller.Pool[0].Vec.DebugReport;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('YuleWalker autoregressive spectra uses Levinson '
      + 'Durbin recursion to solve a toeplitz systems of '
      + 'linear equations taking only O(n2) operations '
      + 'instead of O(n3) as required by LUSolve. The chart '
      + 'compares FFT and YuleWalker AR. The corrLen defines '
      + 'the number of samples on which the Autocorrelation '
      + 'is performed and LPCCoef defines the number of '
      + 'computed autocorrelation coefficients. The method '
      + 'uses biased autocorrelation. FFT uses only LPCoef '
      + 'parameter to determine the number of sample to '
      + 'include. It then rounds LPCCoef to the nearest '
      + 'power of two. FFT uses no windowing.');
    Add('Zoom in on a chart (left-click and drag mouse '
      + 'over the chart) to see differences. Please note '
      + 'that it takes less then 10ms to compute a 32000 '
      + 'point FFT on P366.');
  end;
  ComboBox1Change(nil);
  TrackBar1Change(TrackBar1);
  TrackBar2Change(TrackBar2);
end;

procedure TYuleLev.Button1Click(Sender: TObject);
var aPath: string;
    y,spec,corr: Vector;
begin
  Series1.Clear;
  Series2.Clear;
  StartTimer;
  { Levinson Yule Walker }
  {$IFDEF POSIX}
      {$IF defined(OSX) or defined(LINUX)}
      aPath := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'FFTData.vec');
      {$ELSE}
      aPath := TPath.Combine(TPath.GetDocumentsPath, 'FFTData.vec');
      {$IFEND}
  {$ELSE}
  aPath := 'FFTData.vec'; {Load signal}
  {$ENDIF}
  y.LoadFromFile(aPath);
  y.Resize(CorrLen);
  corr := AutoCorrBiased(y,LPCCoef);  {auto correlation}
  Levinson(corr, y);            {Levinson recursion}
  y.Resize(LargestExp2(y.Length*ZeroPadding),True); {zero padder}
  spec := Log10(1/Mag(FFT(y)));
  Label5.Text := 'Time needed for Levinson YW : '+ FormatSample(StopTimer*1000,'0.000') +' ms';

  DrawValues(spec,Series1,0,1,DownSize);

  StartTimer;
  { "Regular" FFT }
  y.LoadFromFile(aPath); {Load signal}
  y.Resize(LPCCoef);
  y.Resize(LargestExp2(LPCCoef)*ZeroPadding,True);
  spec := Mag(FFT(y));
  spec := Log10(ThreshBottom(spec,1E-5));
  Label6.Text := 'Time needed for FFT : '+ FormatSample(StopTimer*1000,'0.000')+' ms';
  DrawValues(spec,Series2,0,1,DownSize);

  Chart1.Repaint;
end;

procedure TYuleLev.TrackBar1Change(Sender: TObject);
begin
  CorrLen := Round(TTrackBar(Sender).Value);
  Label2.Text := IntToStr(CorrLen);
  TrackBar2.Max := CorrLen;
  TrackBar2.Frequency := CorrLen div 20;
  TrackBar2.Value := CorrLen/2;
  TrackBar2Change(TrackBar2);
end;

procedure TYuleLev.TrackBar2Change(Sender: TObject);
begin
  LPCCoef := Round(TTrackBar(Sender).Value);
  Label4.Text := IntToStr(LPCCoef);
end;


initialization
   RegisterClass(TYuleLev);

end.


