unit IntroExport;

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
  FMX.Objects,
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Controls.Presentation;

type
  TIntroExpImp = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroExpImp: TIntroExpImp;

implementation

{$R *.FMX}

procedure TIntroExpImp.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('    Quick and easy Export/Import to screen, file, database... text or binary.');
    Add('');
    Add('');
    Add('   *   Values to string, Strings to values (real and complex)');
    Add('   *   Read/Write stream');
    Add('   *   Read/Write file');
    Add('   *   Read/Write string grid');
    Add('');
    Add('');
    Add('   Ready to use Matrix Viewer and charting tools:');
    Add('');
    Add('');
    Add('   *   Use ViewValues to display the contents of the matrix or vector');
    Add('   *   Edit data on the fly');
    Add('   *   Draw data while viewing');
    Add('   *   Save/Load from file');
    Add('   *   Use DrawValues and DrawIt for immediate data display');
  end;
end;

initialization
   RegisterClass(TIntroExpImp);

end.
