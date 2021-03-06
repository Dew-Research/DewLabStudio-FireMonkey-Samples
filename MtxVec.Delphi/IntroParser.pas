unit IntroParser;

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo;


type
  TIntroParserForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroParserForm: TIntroParserForm;

implementation

{$R *.FMX}

procedure TIntroParserForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Math expression evaluator features:');
    Add('');
    Add('');
    Add('   *   Support for real and complex numbers');
    Add('   *   Support for vectors and matrices');
    Add('   *   Many matrix operations are multithreaded');
    Add('   *   Most built-in vectorized functions are optimized for SSE2/SSE3');
    Add('   *   Performance of vectorized expression evaluation is 10 to 20x higher than classical expression parsers.');
    Add('   *   It can solve systems of linear equations, do QR or LQ compositions.');
    Add('   *   Operator support for per element and matrix/vector operations');
    Add('   *   Complete set of standard math routines (Log, Power, Sin,...)');
    Add('   *   Very fast also when evaluating not vectorized expressions');
    Add('   *   Constant expressions evaluated during the parsing stage');
    Add('   *   You can add user defined variables, constants, functions and operators');
    Add('   *   Custom functions can be object methods.');
    Add('   *   Functions can be overloaded allowing same name but different param count.');
    Add('   *   Vectors and matrices can be accessed by elements a(i) or m(r,c).');
    Add('   *   Function parameters and results can be string types.');
    Add('   *   Colon operator allows selection of ranges of rows and colums m(:), m(1,:), v(2:3)');
    Add('   *   Assign operator supports colon operator: m(2:3) = 4');
    Add('   *   Colon operator supports step <> 1 and allows: m(10:-1:3) = 4');
    Add('   *   Vectors and matrices can return elements from conditions: a = m(m > 4)');
    Add('   *   Evaluation of a list of expressions.');
  end;
end;

initialization
  RegisterClass(TIntroParserForm);

end.
