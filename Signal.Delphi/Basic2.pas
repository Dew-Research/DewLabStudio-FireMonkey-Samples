unit Basic2;

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
  FMX.Header, FMX.Layouts, FMX.Memo, FMX.ScrollBox, FMX.Controls.Presentation;

type
  TBasicForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RichEdit1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    TimeCheck : DWord;
    TimeElapsed : DWord;
    { Public declarations }
  end;

var
  BasicForm2: TBasicForm2;

implementation

{$R *.FMX}


procedure TBasicForm2.FormCreate(Sender: TObject);
begin
     RichEdit1.Lines.Clear;

end;

end.
