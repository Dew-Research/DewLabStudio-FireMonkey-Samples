unit IntroApplication;

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
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Memo;

type
  TIntroApplicationForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroApplicationForm: TIntroApplicationForm;

implementation

{$R *.FMX}

procedure TIntroApplicationForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('');

    Add('   Building applications:');
    Add('');
    Add('');

    Add('   *   All key components have ready to use user dialogs.');
    Add('   *   All components support streaming of their states and/or data ' +
        'to and from TStream. Partial or complete application configuration ' +
        'can be saved or restored instantly.');
    Add('   *   With only a few drop-in components a signal analysis ' +
        'application with complete user interface can be built!');
    Add('   *   Real-time and off-line processing.');
    Add('   *   By changing a DEFINE statement the application can be recompiled ' +
        'in double or single precision!');
    Add('   *   Instant support for latest CPU architectures via dll update!');
    
    
  end;
end;

initialization
   RegisterClass(TIntroApplicationForm);


end.
