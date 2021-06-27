unit IntroSignalRate;

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
  TIntroSignalRateForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroSignalRateForm: TIntroSignalRateForm;

implementation

{$R *.FMX}

procedure TIntroSignalRateForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Fractional rate conversion algorithms:');
    Add('');
    Add('');

    Add('   *   Unique filtering logic with exceptional speed.');
    Add('   *   All linear phase, multi-rate filter design.');
    Add('   *   All filter designs allow 160dB maximum stop band attenuation.');
    Add('   *   User definable transition bandwidth.');
    Add('   *   Real number sampling rate conversion factor.');

    Add('');
    Add('');
  end;
end;

initialization
  RegisterClass(TIntroSignalRateForm);

end.
