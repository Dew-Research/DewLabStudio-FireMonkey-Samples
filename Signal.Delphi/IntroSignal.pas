unit IntroSignal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Memo;


type
  TIntroSignalForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroSignalForm: TIntroSignalForm;

implementation

{$R *.FMX}

procedure TIntroSignalForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('');
    Add('   A wide range of signal filtering routines includes:');
    Add('');
    Add('');

    Add('   *   Elliptic,Butterworth, Bessel and Chebyshev filter designers');
    Add('   *   Parks-McClellan optimal FIR filter design routine');
    Add('   *   Savitzky-Golay polynomial FIR filter');
    Add('   *   Windowed FIR filter design with Kaiser window.');
    Add('   *   Simple DC filters, Median filters, Moving average, Exponential decay and delay filters.');
    Add('   *   Fractional delay filters.');
    Add('   *   Signal generators.');

    Add('');
    Add('');
  end;
end;

initialization
  RegisterClass(TIntroSignalForm);

end.
