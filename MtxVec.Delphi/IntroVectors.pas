unit IntroVectors;

interface

uses
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, System.Classes, FMX.Layouts;


type
  TIntroVec = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroVec: TIntroVec;

implementation

{$R *.FMX}

procedure TIntroVec.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Vector operations:');
    Add('');
    Add('');
    Add('   *   Real and complex FFT');
    Add('   *   Auto and cross correlations');
    Add('   *   Convolution and filtering');
    Add('   *   Complete vector arithmetic');
    Add('   *   Sorting real and complex numbers');
    Add('   *   Random generators');
  end;
end;

initialization
  RegisterClass(TIntroVec);

end.

