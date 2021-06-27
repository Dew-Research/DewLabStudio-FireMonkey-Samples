unit QC_XR;

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
  StatSeries,
  MtxVec,
  Basic_QC, FMXTee.Engine, FMXTee.Tools, FMXTee.Procs, FMXTee.Chart,
  FMX.Layouts, FMX.Memo, FMX.Controls.Presentation, FMX.Edit, FMX.Controls,
  FMX.Types, FMX.ScrollBox;

type
  TfrmQCXR = class(TfrmBasicQC)
    RadioGroup1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Series1GetMarkText(Sender: TChartSeries; ValueIndex: Integer;
      var MarkText: String);
    procedure RadioButton1Change(Sender: TObject);
  private
    { Private declarations }
    tmpVec: TVec;
    RadioGroup1ItemIndex: integer;
  protected
    procedure Recalculate; override;
  public
    { Public declarations }
  end;

var
  frmQCXR: TfrmQCXR;

implementation

Uses FmxMtxVecTee, Statistics, Probabilities, Math387, StatControlCharts, Basic_Form;
{$R *.FMX}

procedure TfrmQCXR.Recalculate;
var CL, UCL, LCL : TSample;
begin
  Case RadioGroup1ItemIndex of
  0:  begin { X Chart }
        QCXChart(Data,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := '<X> Chart';
      end;
  1:  begin { R Chart }
        QCRChart(Data,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := 'R Chart';
      end;
  2:  begin { S Chart }
        QCSChart(Data,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := 'S Chart';
      end;
  end;
  Series1.CL := CL;
  Series1.LCL := LCL;
  Series1.UCL := UCL;
  DrawValues(DrawVec,Series1);
  inherited;
end;

procedure TfrmQCXR.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1 = Sender then RadioGroup1ItemIndex := 0;
  if RadioButton2 = Sender then RadioGroup1ItemIndex := 1;
  if RadioButton3 = Sender then RadioGroup1ItemIndex := 2;

  Recalculate;
end;

procedure TfrmQCXR.RadioGroup1Click(Sender: TObject);
begin
  Recalculate;
end;

procedure TfrmQCXR.FormCreate(Sender: TObject);
var aPath: string;
begin
  inherited;
  tmpVec := TVec.Create;
  With Memo1.Lines do
  begin
    Clear;
    Add('By using TQCSeries you can easily plot all Quality Control Charts.');
    Add(' This example shows you how to construct <X>, R and S Variable Control Charts' +
        ' Most TQCSeries properties are fuly customizable. To change them , click on the "Edit Series" button.');
  end;

  { load prepared data }

  aPath := GetDataPath + 'QC_XR.mtx';
  Data.LoadFromFile(aPath);

  RadioGroup1Click(RadioGroup1);
end;

procedure TfrmQCXR.FormDestroy(Sender: TObject);
begin
  tmpVec.Free;
  inherited;
end;

procedure TfrmQCXR.Series1GetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: String);
begin
  inherited;
  if (Sender.YValue[ValueIndex]>TQCSeries(Sender).UCL)
  or (Sender.YValue[ValueIndex]<TQCSeries(Sender).LCL) then MarkText := IntToStr(ValueIndex)
  else MarkText := '';
end;

initialization
  RegisterClass(TfrmQCXR);

end.
