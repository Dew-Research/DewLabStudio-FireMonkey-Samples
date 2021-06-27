unit IntroPerformance;

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
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,

  Basic3, FMX.Layouts;

type
  TIntroPerformanceForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroPerformanceForm: TIntroPerformanceForm;

implementation

{$R *.FMX}

procedure TIntroPerformanceForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Optimal signal processing performance is ensured with:');
    Add('');
    Add('');
    Add('   *   CPU specific support and code optimization. Exceptional performance for multi-core systems.');
    Add('   *   Data is processed in "blocks". This allows highly efficient optimization of tight loops.');
    Add('   *   Ultra fast decimation and interpolation algorithm with multi-rate, multi-stage, half-band filters.');
    Add('   *   All critical routines are vectorized and can take advantage of SSE2, SSE3, SSE4, AVX and AVX2 instruction sets.');
    
    
  end;
end;

initialization
   RegisterClass(TIntroPerformanceForm);

end.
