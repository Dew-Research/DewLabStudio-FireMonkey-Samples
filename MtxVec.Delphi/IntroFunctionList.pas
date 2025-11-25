unit IntroFunctionList;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Controls,
  FMX.Forms,
  FMX.Header,
  Basic3, FMX.Types, FMX.Layouts, FMX.Memo, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox;


type
  TIntroFunList = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroFunList: TIntroFunList;

implementation

{$R *.FMX}

procedure TIntroFunList.FormCreate(Sender: TObject);
begin
  inherited;

  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;


    Add('');
    Add('   Basic MtxVec package gives you:');
    Add('');
    Add('');
    Add('   *   Over 1200 well documented routines');
    Add('   *   Full support (where appropriate) for complex numbers');
    Add('   *   TMtx and TVec objects provide you with full matrix, vector and matrix-vector arithmetics');
    Add('   *   16 different probability functions (PDF,CDF and inverse CDF)');
    Add('   *   4 minimization algorithms (BGFS, Marquard, Simplex and Brent)');
    Add('   *   9 special functions (Bessel functions, elliptic integrals, …)');
    Add('   *   Math387 unit - it fully replaces and extends Delphi Math unit ');
    Add('   *   Polynomial handling routines (splines, piece-wise polynomials, polynomial root finding,..)');
    Add('   *   Symmetric multiprocessing support for up to 8 CPUs');
    Add('   *   Processor specific optimization');
    Add('   *   Multi-threading safe');
    Add('   *   Built-in dynamic memory allocation');
    Add('   *   Fee free tech support with 24h response');


  end;
end;

initialization
   RegisterClass(TIntroFunList);

end.
