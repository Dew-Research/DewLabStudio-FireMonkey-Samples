unit IntroWhyMtxVec;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Memo,
  FMX.Header,
  Basic3,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox;

type
  TIntroWhyMtxVecForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroWhyMtxVecForm: TIntroWhyMtxVecForm;

implementation

{$R *.FMX}

procedure TIntroWhyMtxVecForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('Why MtxVec:');
    Add('');
    Add('');
    Add('   *    Features a comprehensive set of math functions for science and engineering.');
    Add('   *    Provides a platform which delivers linear scaling across multiple CPU cores when multithreaded.');
    Add('   *    Based on vectorized code which scales excellent with releases of new CPU architectures.');
    Add('   *    Many linear algebra routines are internally multithreaded, including FFT’s and sparse matrix solvers.');
    Add('   *    Powerfull debugger visualizers provided can be used with any project, including those not using MtxVec.');
    Add('   *    All routines have internal and automatic memory management. This frees the user from a wide range of possible errors like, allocating insufficient memory, forgetting to free ');
    Add('        the memory, keeping too much memory allocated at the same time and similar.');
    Add('   *    Parameters are explicitly range checked, before they are passed to the dll routines. This ensures that all dll calls are safe to use.');
    Add('   *    Organized in to a set of “primitive” highly optimized functions covering all the basic math operations, which are used by all higher level algorithms, in a similar way as the BLAS is used by LAPACK.');
    Add('   *    When calling Lapack routines MtxVec automatically compensates for the fact that in FORTRAN the matrices are stored by columns and in other languages by rows.');
    Add('   *    Many LAPACK functions take many parameters. Most of them can be filled-in automatically by MtxVec, thus reducing the time to study each function extensively, before it can be used.');
    Add('   *    Although some compilers support native AVX/AVX2/AVX512 instruction set, the resulting code can never be as optimal as a hand optimized version.');
    Add('   *    By writing MtxVec code, your application is instantly ready for future CPU instructions, with release of new dlls.');
    Add('   *    All MtxVec functions must pass very strict automated tests. It is these tests, which give the library the highest possible level of reliability, accuracy and error protection.');
    Add('   *    All low level code is abstracted away from the user. This allows a very easy transition to any future platform supported by MtxVec.');
    Add('   *    C/C++ and FORTRAN based functions were compiled with the latest version’s Intel C/C++ and FORTRAN compilers and with support for all CPU architectures.');
    Add('');
  end;
end;

initialization
  RegisterClass(TIntroWhyMtxVecForm);

end.
