unit KalmanDemo2;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Math387, MtxVec, MtxExpr, MtxExprInt, MtxVecInt, FmxMtxVecTee,  AdaptiveFiltering,
  FMX.Layouts, FMX.Memo, FMX.Edit, FmxMtxComCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox;



type
  TKalmanFilterForm2 = class(TForm)
    Chart1: TChart;
    Chart2: TChart;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Button1: TButton;
    ErrorSeries: TFastLineSeries;
    EstimatedSeries: TFastLineSeries;
    MeasuredSeries: TFastLineSeries;
    rEdit: TMtxFloatEdit;
    Label1: TLabel;
    Label2: TLabel;
    qEdit: TMtxFloatEdit;
    DesiredSeries: TFastLineSeries;
    RichEdit1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure qEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rEditChange(Sender: TObject);
  private
    { Private declarations }
    X, NoiseSigma: TSample;
    n_iter: integer;
    Z: Vector;
    KalmanFilter: TKalmanFilter;
    procedure Compute;
  public
    { Public declarations }
  end;


var
  KalmanFilterForm2: TKalmanFilterForm2;

implementation

uses AbstractMtxVec;

{$R *.FMX}

procedure TKalmanFilterForm2.Button1Click(Sender: TObject);
begin
//   NoiseSigma := sqrt(rEdit.Position);
   z := RandGauss(n_iter, mvDouble, x,NoiseSigma);
   Compute;
end;

procedure TKalmanFilterForm2.Compute;
var  i: integer;
     xhat, P, TruthValue: Vector;
begin
    KalmanFilter.Q[0,0] := qEdit.FloatPosition;
    KalmanFilter.R[0,0] := rEdit.FloatPosition;

    truthValue.Size(n_iter);
    truthValue.SetVal(x);

    xhat.Size(n_iter); //  # a posteri estimate of x
    xhat.SetZero;

    P.Size(n_iter);
    P.SetZero;

    for i := 1 to n_iter-1 do
    begin
        KalmanFilter.z[0,0] := z[i]; //start with the second measurement

        KalmanFilter.Update;

        //Get Results:
        xhat[i] := KalmanFilter.x[0,0];
        P[i] := KalmanFilter.P[0,0];
    end;

    DrawValues(z,MeasuredSeries);
    DrawValues(xhat,EstimatedSeries);
    DrawValues(truthValue, DesiredSeries);

    p.SetSubRange(1,n_iter-1);
    DrawValues(P, ErrorSeries);
end;

procedure TKalmanFilterForm2.FormCreate(Sender: TObject);
begin
    RichEdit1.Lines.Clear;
    RichEdit1.Lines.Add('Lesson 2. Making use of the TKalmanFilter component. ');

    KalmanFilter := TKalmanFilter.Create;

    n_iter := 250;
    x := -0.37727;
    NoiseSigma := 0.1;
    z := RandGauss(n_iter,mvDouble, x,NoiseSigma);
//    z.LoadFromFile('C:\TestFile.vec');

    KalmanFilter.A.Size(1,1);
    KalmanFilter.A[0,0] := 1;

    KalmanFilter.x.Size(1,1);
    KalmanFilter.x[0,0] := 0; //-0.37727;

    KalmanFilter.z.Size(1,1);
    KalmanFilter.z[0,0] := z[0];

    KalmanFilter.Q.Size(1,1);
    KalmanFilter.Q[0,0] := 1E-5;

    KalmanFilter.R.Size(1,1);
    KalmanFilter.R[0,0] := sqr(NoiseSigma);

    KalmanFilter.H.Size(1,1);
    KalmanFilter.H[0,0] := 1;

    KalmanFilter.P.Size(1,1);
    KalmanFilter.P[0,0] := 1;

    rEdit.FloatPosition := sqr(NoiseSigma);
    qEdit.FloatPosition := 1E-5;
end;

procedure TKalmanFilterForm2.qEditChange(Sender: TObject);
begin
    Compute;
end;

procedure TKalmanFilterForm2.rEditChange(Sender: TObject);
begin
    Compute;
end;

initialization
  RegisterClass(TKalmanFilterForm2);


end.
