unit IntroPlayback;

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
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Memo;


type
  TIntroPlaybackForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroPlaybackForm: TIntroPlaybackForm;

implementation

{$R *.FMX}

procedure TIntroPlaybackForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Playback and record:');
    Add('');
    Add('');


    Add('   *   96kHz/24 bit extensible audio format support.');
    Add('   *   8,16,24 and 32 bit support for reading/writing, playback/recording');
    Add('   *   Arbitrary sampling frequency.');
    Add('   *   Multichannel audio card support.');
    Add('   *   Audio compression manager support when reading wav files.');
    Add('   *   Real time signal monitor during playback and recording.');
    Add('   *   Triggering support with pre-trigger, post-trigger,..');
    Add('   *   Configurable display delay and skip protection for trigger and monitoring.');
    Add('   *   Full access to audio buffers.');
    Add('   *   Additional binary/text file format support.');
    Add('   *   Ready to use user interface instantly adds playback/recording capabilities to any application.');
    
    
  end;
end;

initialization
   RegisterClass(TIntroPlaybackForm);


end.
