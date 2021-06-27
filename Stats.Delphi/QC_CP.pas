unit QC_CP;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form,
  MtxVec,
  Math387, Statistics, FMXTee.Tools, FMXTee.Functions.Stats, FMX.Edit,
  FMX.Controls, FMX.Layouts, FMX.Memo, FMX.Types, FMX.Controls.Presentation,
  FMX.ScrollBox;



type
  TfrmQCCP = class(TfrmBasic)
    Chart1: TChart;
    ChartTool1: TColorLineTool;
    ChartTool2: TColorLineTool;
    Series1: THistogramSeries;
    Panel2: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Series2: TLineSeries;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChartTool1EndDragLine(Sender: TColorLineTool);
    procedure ChartTool2EndDragLine(Sender: TColorLineTool);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    Data: TVec;
    p, CP, CPK, Alpha: TSample;
    CPConfInt, CPKConfInt: TTwoElmReal;
    procedure Recalculate;
  public
    { Public declarations }
  end;

var
  frmQCCP: TfrmQCCP;

implementation

Uses Probabilities, FmxMtxVecTee, StatControlCharts;
{$R *.FMX}

procedure TfrmQCCP.FormCreate(Sender: TObject);
var tmpMtx: TMtx;
    X, XDense, Bell,Y : TVec;
    Mean, StdDev: TSample;
    aPath: string;
begin
  inherited;

  with Series1.GetVertAxis do
  begin
    AutomaticMinimum := false;
    Minimum := 0.0;
  end;
  Alpha := 0.05;
  Edit1.Text := FormatFloat('0.000',Alpha);
  With Memo1.Lines do
  begin
    Clear;
    Add('CP and CPK charts');
    Add('By using new TeeChart v5 TColorLineTool you can easily' +
        ' do Process Capability Charts. Try dragging upper and ' +
        ' lower control limit (red lines) - p, CP and CPK coefficients '+
        ' and their confidence intervals (CI) are recalculated automatically.');
  end;
  Data := TVec.Create;
  tmpMtx := TMtx.Create;
  X := TVec.Create;
  XDense := TVec.Create;
  Y := TVec.Create;
  Bell := TVec.Create;
  try
    { load prepared data }
    try
      aPath := GetDataPath + 'QC_XR.mtx';
      tmpMtx.LoadFromFile(aPath);

      Data.Copy(tmpMtx);
      Histogram(Data,10,Y,X,true);
       // get values for Bell curve
      Mean := Data.Mean;
      StdDev := Data.StdDev(Mean);
      // 200 calc points
      XDense.Length := 500;
      XDense.Ramp(0.0,(X.Max-0.0)*0.005);
      NormalPDF(XDense,Mean,StdDev,Bell);
      With Series1.GetHorizAxis do
      begin
        Automatic := false;
        SetMinMax(Data.Min - 10, Data.Max + 10);
      end;
      DrawValues(X,Y,Series1,false);
      DrawValues(XDense,Bell,Series2,false);
      ChartTool1.Value := X.Min + 1;
      ChartTool2.Value := X.Max - 1;
      Recalculate;
    finally
      tmpMtx.Free;
      X.Free;
      XDense.Free;
      Bell.Free;
      Y.Free;
    end;
  except
  end;
end;

procedure TfrmQCCP.FormDestroy(Sender: TObject);
begin
  Data.Free;
  inherited;
end;

procedure TfrmQCCP.Recalculate;
var LB, UB: TSample;
begin
  LB := ChartTool1.Value;
  UB := ChartTool2.Value;
  QCCapIndexes(Data,LB,UB,p,CP,CPK,CPConfInt,CPKConfInt, Alpha);
  Label1.Text := 'p = ' + FormatFloat('0.0000',p);
  Label3.Text := 'CP = ' + FormatFloat('0.0000',CP);
  Label4.Text := 'CP CI = [' + FormatFloat('0.0000',CPConfInt[0])+' ; '+
                    FormatFloat('0.0000',CPConfInt[1])+']';
  Label5.Text := 'CPK = ' + FormatFloat('0.0000',CPK);
  Label6.Text := 'CPK CI = [' + FormatFloat('0.0000',CPKConfInt[0])+' ; '+
                    FormatFloat('0.0000',CPKConfInt[1])+']';
end;

procedure TfrmQCCP.ChartTool1EndDragLine(Sender: TColorLineTool);
begin
  If ChartTool1.Value >= ChartTool2.Value then ChartTool1.Value := ChartTool2.Value - EPS;
  Recalculate;
end;

procedure TfrmQCCP.ChartTool2EndDragLine(Sender: TColorLineTool);
begin
  If ChartTool2.Value <= ChartTool1.Value then ChartTool2.Value := ChartTool1.Value + EPS;
  Recalculate;
end;

procedure TfrmQCCP.Edit1Change(Sender: TObject);
begin
  if Visible then
  begin
    Alpha := StrToFloat(Edit1.Text);
    Recalculate;
  end
end;

procedure TfrmQCCP.CheckBox1Click(Sender: TObject);
begin
  Series2.Active := CheckBox1.IsChecked;
end;

initialization
  RegisterClass(TfrmQCCP);

end.
