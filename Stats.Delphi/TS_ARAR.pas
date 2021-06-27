unit TS_ARAR;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  FMX.Dialogs,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Chart,
  MtxVec,
  Math387,
  FMX.Edit, FMXTee.Engine, FMXTee.Series, FMX.Layouts, FMX.Memo,
  FMX.Controls, FMXTee.Procs, FMXTee.Chart, FMX.Types, FmxMtxComCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox;

type
  TfrmARAR = class(TfrmBasicChart)
    Series1: TLineSeries;
    Series2: TLineSeries;
    btnLoad: TButton;
    OpenDialog: TOpenDialog;
    chkShorten: TCheckBox;
    Label1: TLabel;
    MemoLog: TMemo;
    NEdit: TMtxFloatEdit;
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkShortenClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    tau,noForecasts: Integer;
    l1,l2,l3: Integer;
    Sigma2: TSample;
    timeSer: TVec; { original time series }
    sTS,Forecasts,Filter,Phi: TVec; { transformed time series }
    stdErrs: TVec;
    procedure TransformSeries;
    procedure DoForecasts;
    procedure UpdateChart;
  public
    { Public declarations }
  end;

var
  frmARAR: TfrmARAR;

implementation

{$R *.FMX}

Uses FmxMtxVecTee, StatTimeSerAnalysis, Basic_Form;

procedure TfrmARAR.btnLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    timeSer.LoadFromFile(OpenDialog.FileName);
    UpdateChart;
  end;
end;

procedure TfrmARAR.TransformSeries;
begin
  if chkShorten.IsChecked then ShortenFilter(timeSer,sTS,tau,Filter)
  else
  begin
    sTS.Copy(timeSer);
    tau := 0;
    Filter.SetIt([1.0]);
  end;
end;

procedure TfrmARAR.UpdateChart;
var i: Integer;
    st: String;
begin
  With MemoLog.Lines do
  begin
    Clear;
    TransformSeries;
    if chkShorten.IsChecked then
    begin
      Add('#1: Shortening');
      Add('tau : '+IntToStr(tau));
      Add('Filter:');
      st := '[  ';
      for i := 0 to Filter.Length -1 do st := st + FormatSample('0.000',Filter.Values[i])+ '  ';
      st := st + ']';
      Add(st);
      Add('');
    end;

    ARARFit(sTS,Phi,l1,l2,l3,Sigma2,13);
    Add('#2: Fitting');
    Add('Optimal lags'+chr(9)+'Coefficient');
    Add('1'+chr(9)+chr(9)+FormatSample('0.000',Phi.Values[0]));
    Add(IntToStr(l1)+chr(9)+chr(9)+FormatSample('0.000',Phi.Values[1]));
    Add(IntToStr(l2)+chr(9)+chr(9)+FormatSample('0.000',Phi.Values[2]));
    Add(IntToStr(l3)+chr(9)+chr(9)+FormatSample('0.000',Phi.Values[3]));
    Add('WN variance : '+FormatFloat('0.000',Sigma2));
    Add('');

    DrawValues(timeSer,Series1);
    DoForecasts;
  end;
end;

procedure TfrmARAR.FormCreate(Sender: TObject);
var aPath: string;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('The idea of ARAR algorithm is to apply automatically selected '
      + '"memory-shortening" algorithm (if necessary) to the time series '
      + 'and then fit AR model to the transformed series. Stats Master implements '
      + 'algorithm, in which fitting of a subset AR model is done on the transformed '
      + 'time series.');
    Add('Stats Master allows the ARAR algorithm on shortened or unshortened time '
      + 'time series (try selecting/unselecting "Shorten memory filter" checkbox).');
  end;
  timeSer := TVec.Create;
  sTS := TVec.Create;
  Forecasts := TVec.Create;
  Filter := TVec.Create;
  Phi := TVec.Create;
  StdErrs := TVec.Create;
  aPath := GetDataPath + 'deaths.vec';
  timeSer.LoadFromFile(aPath);
  UpdateChart;
end;

procedure TfrmARAR.FormDestroy(Sender: TObject);
begin
  timeSer.Free;
  sTS.Free;
  Forecasts.Free;
  Filter.Free;
  Phi.Free;
  StdErrs.Free;
  inherited;
end;

procedure TfrmARAR.chkShortenClick(Sender: TObject);
begin
  UpdateChart;
end;

procedure TfrmARAR.Edit1Change(Sender: TObject);
begin
  DoForecasts;
end;

procedure TfrmARAR.DoForecasts;
var rmse: TSample;
begin
  noForecasts := NEdit.IntPosition;
  ARARForecast(timeSer,Phi,Filter,tau,l1,l2,l3,sTS.Mean,noForecasts,Forecasts,StdErrs,rmse);
  DrawValues(Forecasts,Series2,timeSer.Length);
end;

initialization
  RegisterClass(TfrmARAR);

end.
