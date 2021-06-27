unit RegisterSignal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Memo, FMX.ExtCtrls;

type
  TRegisterSignalForm = class(TBasicForm3)
    ImageViewer1: TImageViewer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegisterSignalForm: TRegisterSignalForm;

implementation

{$R *.FMX}

procedure TRegisterSignalForm.FormCreate(Sender: TObject);
begin
  inherited;
//  RichEdit1.Lines.Clear;
//  RichEdit1.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+'RegisterSignal.rtf');
end;

initialization
   RegisterClass(TRegisterSignalForm);

end.
