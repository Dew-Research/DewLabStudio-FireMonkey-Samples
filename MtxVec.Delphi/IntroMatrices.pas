unit IntroMatrices;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo;


type
  TIntroMtx = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroMtx: TIntroMtx;

implementation

{$R *.FMX}

procedure TIntroMtx.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;


    Add('');
    Add('   Matrix operations:');
    Add('');
    Add('');

    Add('   *   Least squares solution to a system of linear equations');
    Add('   *   Refining solution of linear systems and error estimate');
    Add('   *   Singular value decomposition and solution of a system of equations');
    Add('   *   Eigenvalues and eigenvectors');
    Add('   *   Toeplitz systems of linear equations');
    Add('   *   Complete support for complex numbers');
    Add('   *   2D FFT');
    Add('   *   Complete matrix arithmetics');
    Add('   *   Support for sparse matrices');


  end;
end;

initialization
   RegisterClass(TIntroMtx);
end.
