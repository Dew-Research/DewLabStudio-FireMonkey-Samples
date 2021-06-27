unit DemoHowTo;

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
  TfrmDemoHowTo = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemoHowTo: TfrmDemoHowTo;

implementation

  {$R *.FMX}

procedure TfrmDemoHowTo.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('');
    Add('   Usage instructions for the demo app:');
    Add('');
    Add('');
    Add('   *   You can see the source code of each form by pressing the "Source Code" tab at the bottom of the form.');
    Add('   *   Each form can be recompiled as a standalone application. ' +
        'All you have to do is add the form to a newly created project and press F9.');
    Add('   *   There are no code dependancies between individual forms. Each form is a ' +
        'standalone working application and entire source required to implement the ' +
        'behaviour is implemented in that one unit.');
    Add('   *   Many forms have usage instructions at the top of the window.');
    Add('');
  end;

end;

initialization
  RegisterClass(TfrmDemoHowTo);

end.
