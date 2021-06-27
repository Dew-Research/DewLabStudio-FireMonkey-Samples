unit Basic3;

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
  FMX.Menus,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;


type
  TBasicForm3 = class(TForm)
    RichEdit1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public                                                             
    { Public declarations }
  end;

var
  BasicForm3: TBasicForm3;

implementation

{$R *.FMX}

procedure TBasicForm3.FormCreate(Sender: TObject);
begin
     RichEdit1.Lines.Clear;
end;

end.
