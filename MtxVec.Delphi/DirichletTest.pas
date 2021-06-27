unit DirichletTest;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,FMXTee.RadioGroup,
  Basic2, FmxMtxVecTee,
  MtxVec, Math387, MtxExpr,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls,
  FMX.Layouts,
  FMX.Memo,
  FMX.Types,
  PlatformHelpers, FMX.Controls.Presentation, FMX.ScrollBox;

type
  TfrmDirichlet = class(TBasicForm2)
    Panel4: TPanel;
    RadioGroup1: TPanel;
    RadioGroup2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;                                     
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    RiemmanZetaBox: TRadioButton;
    DirichletEtaBox: TRadioButton;
    DirichletLambdaBox: TRadioButton;
    DirichletBetaBox: TRadioButton;
    ReBox: TRadioButton;
    Imbox: TRadioButton;
    AbsBox: TRadioButton;
    Chart1: TChart;
    procedure Chart1AfterDraw(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    GridSer: TMtxGridSeries;
    Data: Matrix;
    CVal: TCplx;
    xmin,xmax,ymin,ymax: TSample;
    xstep,ystep: TSample;
    procedure Generate;
  public
    { Public declarations }
  end;

var
  frmDirichlet: TfrmDirichlet;

implementation
{$R *.FMX}

Uses Probabilities, AbstractMtxVec;

{ TfrmDirichlet }

procedure TfrmDirichlet.Generate;
var i,j: Integer;
      z: TCplx;
begin
    xmin := StrToFloat(Edit1.Text);
    xmax := StrToFloat(Edit2.Text);
    ymin := StrToFloat(Edit3.Text);
    ymax := StrToFloat(Edit4.Text);
    xstep := (xmax-xmin)*0.02;
    ystep := (ymax-ymin)*0.02;
    Data.Size(50,50,false);
    { i = real part => data columns }
    { j = imaginary part => data rows }
    for j := 0 to Data.Rows-1 do
      for i := 0 to Data.Cols -1 do
      begin
        z.Re := xmin+i*xstep;
        z.Im := ymin+j*ystep;
        case  GetRadioItemIndex(RadioGroup1) of
          0: CVal := RiemannZeta(z);
          1: CVal := DirichletEta(z);
          2: CVal := DirichletLambda(z);
          3: CVal := DirichletBeta(z);
        end;
        case GetRadioItemIndex(RadioGroup2) of
          0: Data.Values[j,i] := CVal.Re;
          1: Data.Values[j,i] := CVal.Im;
          2: Data.Values[j,i] := CAbs(CVal);
        end;
      end;
    GridSer.XOffset := xmin;
    GridSer.XStep := xstep;
    GridSer.YOffset := ymin;
    GridSer.YStep := ystep;
    GridSer.Matrix := Data;

    GridSer.GetVertAxis.Increment := (ymax-ymin)*0.01;
    GridSer.GetHorizAxis.Increment := (xmax-xmin)*0.01;
end;


procedure TfrmDirichlet.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('Several new special functions have been added to MtxVec '
      + 'Probabilities unit. MtxVec now supports Riemann Zeta, Dirichlet Eta '
      + 'and Dirichlet Lambda functions in complex plane.');
    Add('');
    Add('');
  end;

  GridSer := TMtxGridSeries.Create(Chart1);
  GridSer.ColorPalette.BottomColor := TAlphaColors.White;
  GridSer.ColorPalette.TopColor := TAlphaColors.Red;
  GridSer.ColorPalette.MidColor := TAlphaColors.Yellow;
  GridSer.ColorPalette.PaletteSteps := 128;
  GridSer.ParentChart := Chart1;
  Generate;
end;

procedure TfrmDirichlet.Button1Click(Sender: TObject);
begin
  Generate;
end;

procedure TfrmDirichlet.RadioGroup1Click(Sender: TObject);
begin
  Generate;
end;

procedure TfrmDirichlet.RadioGroup2Click(Sender: TObject);
begin
  Generate;
end;

procedure TfrmDirichlet.Chart1AfterDraw(Sender: TObject);
var pos: integer;
begin
  inherited;
  With Chart1.ChartRect, Chart1.Canvas do
  begin
    pos := Chart1.BottomAxis.CalcPosValue(0.0);
    if (pos>Left) and (pos<Right) then
    begin
      Pen.Color := TAlphaColors.Black;
      Pen.Style := FMXTee.Canvas.TPenStyle.psDot;
      Line(pos,Bottom,pos,Top);
    end;
    pos := Chart1.LeftAxis.CalcPosValue(0.0);
    if (pos>Top) and (pos<Bottom) then
    begin
      Pen.Color := TAlphaColors.Black;
      Pen.Style := FMXTee.Canvas.TPenStyle.psDot;
      Line(Left,pos,Right,pos);
    end;
  end;
end;

initialization
  RegisterClass(TfrmDirichlet);

end.
