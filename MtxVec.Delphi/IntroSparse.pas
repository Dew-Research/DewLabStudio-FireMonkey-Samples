unit IntroSparse;

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo;


type
  TIntroSparseMtx = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroSparseMtx: TIntroSparseMtx;

implementation

{$R *.FMX}

procedure TIntroSparseMtx.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('Sparse matrix class features:');
    Add('');
    Add('');
    Add('   *   Support for real and complex sparse matrices');
    Add('   *   UMFPack v4.3 direct sparse sparse solver');
    Add('   *   Pardiso multithreaded sparse solver');
    Add('   *   Iterative sparse solvers (cg, bcg, gmres,..)');
    Add('   *   Many conversion routines to convert to and from different matrix formats '+
        '(triplet, banded, dense, Harwell Boeing)');
    Add('   *   Support for MatrixMarket file format.');
    Add('   *   Very fast banded matrix solvers already available in TMtx');
    Add('   *   Add, subtract, multiply routines for sparse/sparse and dense/sparse matrices/vectors');
    Add('   *   PixelDownSample routine to allow fast display of the non-zero ' +
        'pattern of the matrices of large sizes.  (1000 000 x 1000 000 elements)');
    Add('   *   Complete set of standard math routines (Log, Power, Sin,...)');
  end;
end;

initialization
  RegisterClass(TIntroSparseMtx);

end.
