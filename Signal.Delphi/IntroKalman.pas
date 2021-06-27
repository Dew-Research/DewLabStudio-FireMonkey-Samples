unit IntroKalman;

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
  TIntroKalmanForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroKalmanForm: TIntroKalmanForm;

implementation

{$R *.FMX}

procedure TIntroKalmanForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('');
    Add('   Kalman filtering:');
    Add('');
    Add('');

    Add('   *   Standard and extended Kalman filtering algorithms.');
    Add('   *   Fully customizable user interface allowing variation of all variables with every iteration.');
		Add('   *   Vectorized implementation optimized for handling of large states.');

    Add('');
    Add('');
  end;
end;

initialization
  RegisterClass(TIntroKalmanForm);

end.
