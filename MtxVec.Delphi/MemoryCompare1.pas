unit MemoryCompare1;

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
  FMX.Menus,
  FMX.Grid,
  FMX.Memo,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,
  System.Rtti,
  Basic2, MtxVec, FMX.StdCtrls, PlatformHelpers, FMX.ScrollBox,
  FMX.Controls.Presentation, FMX.Memo.Types;



type
  TMemComp1 = class(TBasicForm2)
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Memo2: TMemo;
    Label2: TLabel;
    Button3: TButton;
    Chart1: TChart;
    Series1: TBarSeries;
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    Len : Integer;
    procedure DoWithCreate;
    procedure DoWithCreateIt(Index: Integer; AColor: TAlphaColor);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  MemComp1: TMemComp1;

implementation

uses Math387, AbstractMtxVec;

{$R *.FMX}

constructor TMemComp1.Create(AOwner: TComponent);
var i : integer;
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('Frequent memory allocation can cost a lot of CPU. '
    + 'Frequent object create and destroy costs even more. '
    + 'One object create and destroy can take about the '
    + 'same as scalling an array of 200 elements. One '
    + 'GetMem/FreeMem pair is equal to scalling an array '
    + 'of 40 elements. CreateIt/FreeIt pair equals only '
    + '"15 scale elements" while creating an object and '
    + 'allocating memory for you at the same time.');
  Add('Try many different vectors sizes and rerun the test '
    + 'several times. Results with memory allocation may '
    + 'vary greatly.');
  Add('Zoom in on the chart (left-click and drag mouse '
    + 'over the chart) to see more details.');
  end;

  { Set up chart }
  for i := 0 to 3 do
  begin
       Series1.Add(0,'',clTeeColor);
  end;
  Series1.XLabel[0] := '(32,1024)';
  Series1.XLabel[1] := '(32,0)';
  Series1.XLabel[2] := '(0,0)';
  Series1.XLabel[3] := '(Create/Destroy)';
  TrackBar1Change(TrackBar1);
end;

Procedure TMemComp1.DoWithCreate;
var vec1,vec2,vec3,vec4,
    vec5,vec6,vec7,vec8,
    vec9,vec10,vec11,vec12: TVec;
    i         : integer;
begin
  StartTimer;
  for i := 1 to 110000 do
  begin
     { use Create to create 12 vectors }
     Vec1 := TVec.Create;
     Vec2 := TVec.Create;
     Vec3 := TVec.Create;
     Vec4 := TVec.Create;
     Vec5 := TVec.Create;
     Vec6 := TVec.Create;
     Vec7 := TVec.Create;
     Vec8 := TVec.Create;
     Vec9 := TVec.Create;
     Vec10 := TVec.Create;
     Vec11 := TVec.Create;
     Vec12 := TVec.Create;
     try
        vec1.Size(Len);
        vec2.Size(Len);
        vec3.Size(Len);
        vec4.Size(Len);
        vec5.Size(Len);
        vec6.Size(Len);
        vec7.Size(Len);
        vec8.Size(Len);
        vec9.Size(Len);
        vec10.Size(Len);
        vec11.Size(Len);
        vec12.Size(Len);
     finally
       { use Destroy to destroy 12 vectors }
        Vec1.Free;
        Vec2.Free;
        Vec3.Free;
        Vec4.Free;
        Vec5.Free;
        Vec6.Free;
        Vec7.Free;
        Vec8.Free;
        Vec9.Free;
        Vec10.Free;
        Vec11.Free;
        Vec12.Free;
     end;
  end;
  
  ResetCursor;
  { store the time elapsed to series }
  Series1.YValues[3] := StopTimer*1000;
  Series1.ValueColor[3] := TAlphaColors.Red;
  Series1.Repaint;
end;

Procedure TMemComp1.DoWithCreateIt(Index: Integer; AColor: TAlphaColor);
var vec1,vec2,vec3,vec4,
    vec5,vec6,vec7,vec8,
    vec9,vec10,vec11,vec12: TVec;
    i         : integer;
begin
  StartTimer;
  for i := 1 to 110000 do
  begin
     { use CreateIt to create 8 vectors }
     CreateIt(vec1,vec2,vec3,vec4);
     CreateIt(vec5,vec6,vec7,vec8);
     CreateIt(vec9,vec10,vec11,vec12);
     try
        vec1.Size(Len);
        vec2.Size(Len);
        vec3.Size(Len);
        vec4.Size(Len);
        vec5.Size(Len);
        vec6.Size(Len);
        vec7.Size(Len);
        vec8.Size(Len);
        vec9.Size(Len);
        vec10.Size(Len);
        vec11.Size(Len);
        vec12.Size(Len);
     finally
        { use FreeIt to destroy 8 vectors }
        FreeIt(vec1,vec2,vec3,vec4);
        FreeIt(vec5,vec6,vec7,vec8);
        FreeIt(vec9,vec10,vec11,vec12);
     end;
  end;

  { store the time elapsed to series }
  Series1.YValues[Index] := StopTimer*1000;
  Series1.ValueColor[Index] := AColor;
  Series1.Repaint;
end;

procedure TMemComp1.Button1Click(Sender: TObject);
begin
  SetHourGlassCursor;

  { do full comparison }
  Controller.SetVecCacheSize(32,1024);
  DoWithCreateIt(0,TAlphaColors.Yellow);
  Controller.SetVecCacheSize(32,0);
  DoWithCreateIt(1,TAlphaColors.Green);
  Controller.SetVecCacheSize(0,0);
  DoWithCreateIt(2,TAlphaColors.Blue);
  Controller.SetVecCacheSize(0,0);
  DoWithCreate;
  Controller.SetVecCacheSize(60,4272);


  ResetCursor;
end;

procedure TMemComp1.TrackBar1Change(Sender: TObject);
begin
  Len := Round(TTrackBar(Sender).Value);
  Label2.Text := IntToStr(Len);
end;

initialization
  RegisterClass(TMemComp1);

end.

