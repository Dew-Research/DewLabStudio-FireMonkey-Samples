unit IntroMemoryMan;

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
  TIntroMemMan = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroMemMan: TIntroMemMan;

implementation

{$R *.FMX}

procedure TIntroMemMan.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('');
    Add('   Enhanced memory handling:');
    Add('');
    Add('');
    Add('   *   Built in dynamic memory allocation makes it easier for the user');
    Add('   *   Object cache with object precreation speeds up Create and Destroy');
    Add('   *   Memory preallocation gives instant access to new memory.');
    Add('   *   Super conductive object cache allows linear multi-core scaling with CPU core count!');
    Add('   *   Dedicated memory allocated per thread typically does not exceed CPU cache size (2MB). This makes the processing memory and CPU cache efficient.');
    Add('   *   Object cache does not interfere with other parts of the application which continue to use the default memory manager. Only those parts of code running via TMtxThread and using MtxVec object cache are affected.');
    Add('');
    Add('');
    Add('   Array access options:');
    Add('');
    Add('');
    Add('   *   Default arrays allow cleaner syntax');
    Add('   *   Array pointers give you more speed');
    Add('   *   Single memory block matrices allow even faster matrix operations');
  end;
end;

initialization
   RegisterClass(TIntroMemMan);

end.
