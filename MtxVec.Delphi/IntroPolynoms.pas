unit IntroPolynoms;

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo;


type
  TIntroPoly = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroPoly: TIntroPoly;

implementation

{$R *.FMX}

procedure TIntroPoly.FormCreate(Sender: TObject);
begin
  inherited;
  with RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Robust polynomials handling methods:');
    Add('');
    Add('');
    Add('   *   Polynomial evaluation, root finding');
    Add('   *   Piece-wise polynomials');
    Add('   *   Fast cubic spline algorithm');
    Add('   *   Linear or cubic interpolation');
    Add('   *   Fit high order polynomials to data');
    Add('');

  end;
end;

initialization
   RegisterClass(TIntroPoly);

end.
