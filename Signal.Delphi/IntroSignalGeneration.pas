unit IntroSignalGeneration;

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
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Memo;


type
  TIntroSignalGenerationForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroSignalGenerationForm: TIntroSignalGenerationForm;

implementation

{$R *.FMX}

procedure TIntroSignalGenerationForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Powerful signal generation algorithms:');
    Add('');
    Add('');

    Add('   *   Generate, white, pink, brownian, blue and violate noise by filtering white noise with appropriate FIR filters.');
    Add('   *   Generate triangular, square and multi-tone signals.');
    Add('   *   Vary frequency and/or amplitude between specified ranges (chirp signal).');
    Add('   *   Use HP style calculator to define equations for noise generation from multiple sources.');
    Add('   *   TSignalGenerator component uses vectorized signal generation for lowest CPU usage.');
  end;
end;

initialization
  RegisterClass(TIntroSignalGenerationForm);

end.
