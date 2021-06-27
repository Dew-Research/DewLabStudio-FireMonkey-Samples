unit QC_Attr;

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
  Basic_QC,
  StatSeries,
  Math387,
  MtxVec, FMX.Layouts, FMX.Memo, FMX.Edit, FMX.Controls, FMXTee.Engine,
  FMXTee.Tools, FMXTee.Procs, FMXTee.Chart, FMX.Types,
  FMX.Controls.Presentation, FMX.ScrollBox;



type
  TfrmQCAttr = class(TfrmBasicQC)
    Label2: TLabel;
    RadioGroup1: TPanel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Series1GetMarkText(Sender: TChartSeries; ValueIndex: Integer;
      var MarkText: String);
    procedure RadioButton1Change(Sender: TObject);
  private
    { Private declarations }
    DataVec: TVec;
    SampleSize: Integer;
    RadioGroup1ItemIndex: integer;
  protected
    procedure Recalculate; override;
  public
    { Public declarations }
  end;

var
  frmQCAttr: TfrmQCAttr;

implementation

Uses FmxMtxVecEdit, FmxMtxVecTee, StatControlCharts, Basic_Form;
{$R *.FMX}

procedure TfrmQCAttr.Button2Click(Sender: TObject);
begin
  ViewValues(DataVec,'Data vector',True,False);
end;

procedure TfrmQCAttr.FormCreate(Sender: TObject);
var aPath: String;
begin
  inherited;
  DataVec := TVec.Create;
  With Memo1.Lines do
  begin
    Clear;
    Add('By using TQCSeries you can easily plot Attribute Quality Control Charts.');
    Add(' This example shows you how to construct P and U Attribute Control Charts' +
        ' Data comes from 20 samples, each of size 100. Most TQCSeries properties'+
        ' are fuly customizable. To change them , click on the "Edit Series" button.');
  end;

  { load prepared data }

  aPath := GetDataPath + 'QC_Attribute.vec';
  DataVec.LoadFromFile(aPath);

  SampleSize := 100;

  Edit2.Text := IntToStr(SampleSize);
  RadioButton1Change(RadioButton1);
end;

procedure TfrmQCAttr.FormDestroy(Sender: TObject);
begin
  DataVec.Free;
  inherited;
end;

procedure TfrmQCAttr.Edit2Change(Sender: TObject);
begin
  If Visible and (Edit2.Text <> '') then
  begin
    SampleSize := StrToInt(Edit2.Text);
    Recalculate;
  end;
end;

procedure TfrmQCAttr.Recalculate;
var CL, UCL, LCL : TSample;
begin
  Case RadioGroup1ItemIndex of
  0:  begin { P Chart }
        QCPChart(DataVec,SampleSize,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := 'P Chart';
      end;
  1:  begin { NP Chart }
        QCNPChart(DataVec,SampleSize,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := 'NP Chart';
      end;
  2:  begin { U Chart }
        QCUChart(DataVec,SampleSize,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := 'U Chart';
      end;
  3:  begin { C Chart }
        QCCChart(DataVec,DrawVec,CL,UCL,LCL,Confidence*0.01);
        Chart1.Title.Text.Strings[0] := 'C Chart';
      end;
  end;
  Series1.CL := CL;
  Series1.LCL := LCL;
  Series1.UCL := UCL;
  DrawValues(DrawVec,Series1);
  inherited;
end;

procedure TfrmQCAttr.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then RadioGroup1ItemIndex := 0;
  if Sender = RadioButton2 then RadioGroup1ItemIndex := 1;
  if Sender = RadioButton3 then RadioGroup1ItemIndex := 2;
  if Sender = RadioButton4 then RadioGroup1ItemIndex := 3;

  Recalculate;
end;

procedure TfrmQCAttr.Series1GetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: String);
begin
  inherited;
  if (Sender.YValue[ValueIndex]>TQCSeries(Sender).UCL)
  or (Sender.YValue[ValueIndex]<TQCSeries(Sender).LCL) then MarkText := IntToStr(ValueIndex)
  else MarkText := '';
end;

initialization
  RegisterClass(TfrmQCAttr);

end.
