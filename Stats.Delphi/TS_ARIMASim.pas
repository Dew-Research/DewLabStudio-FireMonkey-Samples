unit TS_ARIMASim;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Chart,
  MtxVec, FMX.Edit, FMXTee.Engine, FMXTee.Series, FMX.Layouts, FMX.Memo,
  FMX.Controls, FMXTee.Procs, FMXTee.Chart, FMX.Types, FmxMtxComCtrls,
  FMX.Controls.Presentation;



type
  TfrmARIMASim = class(TfrmBasicChart)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Button3: TButton;
    Series1: TLineSeries;
    Button4: TButton;
    Button5: TButton;
    RadioGroupCT: TPanel;
    Series2: TLineSeries;
    MemoLog: TMemo;
    EditAR: TMtxFloatEdit;
    EditMA: TMtxFloatEdit;
    EditD: TMtxFloatEdit;
    EditN: TMtxFloatEdit;
    Label5: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure EditARChange(Sender: TObject);
    procedure EditMAChange(Sender: TObject);
    procedure EditDChange(Sender: TObject);
    procedure EditNChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    { Private declarations }
    d,n: Integer;
    RadioGroupItemIndex: integer;
    Phi,Theta,zinit,timeSer: TVec;
    procedure Simulate;
    procedure PlotSeries(stype: Integer);
  public
    { Public declarations }
  end;

var
  frmARIMASim: TfrmARIMASim;

implementation

Uses StatTimeSerAnalysis, FmxMtxVecTee, FmxMtxVecEdit, Math387, Statistics;
{$R *.FMX}

{ TfrmARIMASim }

procedure TfrmARIMASim.Simulate;
var s2: TSample;
    i: Integer;
    phiest,thetaest: TVec;
begin
  MemoLog.Lines.Clear;
  if d=0 then
  begin
    ARMASimulate(Phi,Theta,n,timeSer);
    phiest := TVec.Create;
    thetaest := TVec.Create;
    try
      phiest.Length := phi.Length;
      thetaest.Length := theta.Length;
      if (Phi.Length<>0) and (Theta.Length=0) then ARYuleWalkerFit(timeSer,phiest,s2)
      else if (Phi.Length=0) and (Theta.Length<>0) then ARMAInnovationsFit(timeSer,thetaest,s2)
      else ARMAInnovationsFit(timeSer,phiest,thetaest,s2);
      with MemoLog.Lines do
      begin
        Add('Initial estimates');
        if Phi.Length>0 then
        begin
          Add('AR coefficients');
          for i := 0 to Phi.Length-1 do Add('AR['+IntToStr(i+1)+']='+FormatSample('0.000',phiest.Values[i]));
        end;
        if Theta.Length>0 then
        begin
          Add('MA coefficients');
          for i := 0 to Theta.Length-1 do Add('MA['+IntToStr(i+1)+']='+FormatSample('0.000',thetaest.Values[i]));
        end;
      end;
    finally
      phiest.Free;
      thetaest.Free;
    end;
end
  else ARIMASimulate(Phi,Theta,d,zinit,n,timeSer);

  With Chart1.Title.Text do
  begin
    Clear;
    Add('Simulating :');
    if d=0 then Add('ARMA ('+IntToStr(Phi.Length)+','+IntToStr(Theta.Length)+') process')
    else Add('ARIMA ('+IntToStr(Phi.Length)+','+IntToStr(Theta.Length)+','+IntToStr(d)+') process')
  end;
  PlotSeries(RadioGroupItemIndex);
end;

procedure TfrmARIMASim.EditARChange(Sender: TObject);
begin
  Phi.Length := StrToInt(EditAR.Text);
  Phi.SetZero;
  Series1.Clear;
end;

procedure TfrmARIMASim.EditMAChange(Sender: TObject);
begin
  Theta.Length := StrToInt(EditMA.Text);
  Theta.SetZero;
  Series1.Clear;
end;

procedure TfrmARIMASim.EditDChange(Sender: TObject);
begin
  d := StrToInt(EditD.Text);
  { an example ONLY }
  zinit.Size(d);
  zinit.SetZero;
  Series1.Clear;
end;

procedure TfrmARIMASim.EditNChange(Sender: TObject);
begin
  N := StrToInt(EditN.Text);
  Series1.Clear;
end;

procedure TfrmARIMASim.Button2Click(Sender: TObject);
begin
  ViewValues(Phi,'AR coefficients',True,False,True);
end;

procedure TfrmARIMASim.Button3Click(Sender: TObject);
begin
  ViewValues(Theta,'MA coefficients',True,False,True);
end;

procedure TfrmARIMASim.FormCreate(Sender: TObject);
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('New in Stats Master 2.1: ARMA/ARIMA routines.');
    Add('This example demonstrates usage of ARMA and ARIMA simulation and prediction routines.'
        + ' Change AR, MA and d parameters to simulate different ARMA and ARIMA models.');
    Add('');
    Add('Press the "Simulate" button for random ARMA/ARIMA model time series.');
  end;
  Phi := TVec.Create;
  Theta := TVec.Create;
  timeSer := TVec.Create;
  zInit := TVec.Create;

  EditARChange(Sender);
  EditMAChange(Sender);
  EditDChange(Sender);
  EditNChange(Sender);
end;

procedure TfrmARIMASim.FormDestroy(Sender: TObject);
begin
  Phi.Free;
  Theta.Free;
  timeSer.Free;
  zInit.Free;
  inherited;
end;

procedure TfrmARIMASim.Button4Click(Sender: TObject);
begin
  Simulate;
end;

procedure TfrmARIMASim.Button5Click(Sender: TObject);
begin
  ViewValues(zinit,'initial values for d',True,False,True);
end;

procedure TfrmARIMASim.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then RadioGroupItemIndex := 0;
  if Sender = RadioButton2 then RadioGroupItemIndex := 1;
  if Sender = RadioButton3 then RadioGroupItemIndex := 2;

  PlotSeries(RadioGroupItemIndex);
end;

procedure TfrmARIMASim.PlotSeries(stype: Integer);
var acfv,pacfv: TVec;
begin
  CreateIt(acfv,pacfv);
  try
    Series2.Active := False;
    case sType of
      0:  begin
            DrawValues(timeSer,Series1);
            Series1.Title := 'Time series';
          end;
      1:  begin {ACF}
            ACF(timeSer,acfv,timeSer.Length div 2);
            Series1.Title := 'Time series ACF';
            DrawValues(acfv,Series1);
            if d = 0 then
            begin
              Series2.Active := True;
              ARMAAcf(Phi,Theta,timeSer.Length div 2,pacfv);
              DrawValues(pacfv,Series2);
            end
          end;
      2:  begin
            ACF(timeSer,acfv,timeSer.Length div 2);
            PACF(acfv,pacfv);
            Series1.Title := 'Time series PACF';
            DrawValues(pacfv,Series1);
          end;
    end;
  finally
    FreeIt(acfv,pacfv);
  end;
end;

initialization
  RegisterClass(TfrmArimaSim);

end.
