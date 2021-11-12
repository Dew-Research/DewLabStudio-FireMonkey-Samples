unit IntroCompList;

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
  FMX.Menus,
  FMX.Grid,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.ExtCtrls, FMX.Memo.Types, FMX.Controls.Presentation, FMX.ScrollBox;


type
  TIntroCompListForm = class(TBasicForm3)
    ImageViewer1: TImageViewer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroCompListForm: TIntroCompListForm;

implementation

{$R *.FMX}

procedure TIntroCompListForm.FormCreate(Sender: TObject);
begin
  inherited;
//  RichEdit1.Lines.Clear;
//  RichEdit1.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+'Components.rtf');
end;

initialization
   RegisterClass(TIntroCompListForm);

end.
