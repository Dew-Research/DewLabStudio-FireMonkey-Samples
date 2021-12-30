unit Multiply1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,
  MtxVec, Math387, FmxMtxComCtrls, FMX.Edit, FMX.Controls, FMX.Layouts,
  FMX.Memo, FMX.Types, PlatformHelpers, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo.Types;

{ "Regular" 2D arrays}
type TDelphi2DArray = Array of Array of TSample;

type
  TMult1 = class(TBasicForm2)
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Button4: TButton;
    RadioGroup1: TPanel;
    CPUCacheSizeLabel: TLabel;
    CPUCoreCountLabel: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    StaticText1: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ThreadCountEditChange(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    Factor: integer;
    DA,DB,DC : TDelphi2DArray; {"regular" arrays }
    A,B,C : TMtx;             {MtxVec arrays}
    MtxDim : Integer;
    RadioGroupIndex: integer;
    procedure MulDelphi(ADim: Integer);
    procedure GenerateData(ADim : Integer);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  Mult1: TMult1;

implementation

uses MtxExpr, FmxMtxVecEdit, AbstractMtxVec;

{$R *.FMX}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TMult1.MulDelphi(ADim: Integer);
var i,j,k : Integer;
    ac: TSample;
begin
   for i := 0 to ADim-1 do
      for k := 0 to ADim-1 do
      begin
         ac := DA[i,k];
         for j := 0 to ADim-1 do
              DC[i,j] := DC[i,j]+ ac*DB[k,j];
      end;
end;

procedure TMult1.GenerateData(ADim: Integer);
var i,j : Integer;
begin
     { resize matrices }
     A.Size(ADim,ADim);
     B.Size(A);
     { resize 2D arrays}
     SetLength(DA,ADim,ADim);
     SetLength(DB,ADim,ADim);
     SetLength(DC,ADim,ADim);
     { fill sample data }
     Randomize;
     for i := 0 to ADim-1 do
         for j := 0 to ADim-1 do
         begin
              DA[i,j] := random(10);
              DB[i,j] := random(10);
              A.Values[i,j] := DA[i,j];
              B.Values[i,j] := DB[i,j];
         end;
end;

procedure TMult1.ThreadCountEditChange(Sender: TObject);
begin
{  Controller.ThreadCount := ThreadCountEdit.IntPosition; }
end;

procedure TMult1.TrackBar1Change(Sender: TObject);
begin
  MtxDim := Round(TTrackBar(Sender).Value);
  StaticText1.Text := IntToStr(MtxDim);
end;

procedure TMult1.Button4Click(Sender: TObject);
var i,j: integer;
    Adim : Integer;
begin
  GenerateData(MtxDim);
  i := 2;
  SetHourGlassCursor;

  Series1.Clear;
  Series2.Clear;
  Controller.ThreadWaitBeforeSleep := 10;

  repeat
        ADim := i;
        GenerateData(ADim);
        StartTimer;
        if MtxDim <= 30 then
             for j := 0 to 99*Factor*4 do MulDelphi(ADim)
        else if MtxDim <= 60 then
             for j := 0 to 9*Factor do MulDelphi(ADim)
        else MulDelphi(ADim);
        Series1.AddXY(i, StopTimer*1000,'',clTeeColor);

        StartTimer;
        if MtxDim <= 30 then
           for j := 0 to Factor*99*4 do C.Mul(A,B)
        else if MtxDim <= 60 then
           for j := 0 to Factor*9 do C.Mul(A,B)
        else C.Mul(A,B);
        Series2.AddXY(i, StopTimer*1000,'',clTeeColor);

        if i<50 then i := i+2 else i:= i+25;
  until i >= MtxDim;

  Controller.ThreadWaitBeforeSleep := 0;
  ResetCursor;
end;

procedure TMult1.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then RadioGroupIndex := 0;
  if Sender = RadioButton2 then RadioGroupIndex := 1;
  if Sender = RadioButton3 then RadioGroupIndex := 2;

  Case RadioGroupIndex of
   0 : TrackBar1.Value := 20;
   1 : TrackBar1.Value := 60;
   2 : TrackBar1.Value := 400;
  end;
  TrackBar1Change(TrackBar1);
end;

constructor TMult1.Create(AOwner: TComponent);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('Matrix multiplication performance gives you '
      + 'an impression of the performance of MtxVec. You '
      + 'will be able to experience these performance '
      + 'gains with all MtxVec packages, when dealing '
      + 'with vectors or matrices. If you have a multi-CPU '
      + 'machine multi-threading is automatically enabled.  ');
  end;
  A := TMtx.Create;
  B := TMtx.Create;
  C := TMtx.Create;
  Factor := 1;
  CPUCoreCountLabel.Text := 'CPU core count = ' + IntToStr(Controller.CpuCores);
  CPUCacheSizeLabel.Text := 'CPU cache size = ' + FormatSample('0.0 [MB]',(Controller.CpuCacheSizeInBytes/sqr(1024)));

//  Controller.ThreadWaitBeforeSleep := 1;
  TrackBar1Change(TrackBar1);
end;

procedure TMult1.FormDestroy(Sender: TObject);
begin
  A.Free;
  B.Free;
  C.Free;
  inherited;
end;

initialization
   RegisterClass(TMult1);
end.
