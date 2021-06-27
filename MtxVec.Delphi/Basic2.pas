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
  FMX.Memo,
  FMX.Grid,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;

type
  TBasicForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RichEdit1: TMemo;                                          
  private
    { Private declarations }
  public
    TimeCheck : DWord;
    TimeElapsed : double;
    { Public declarations }
  end;

var
  BasicForm2: TBasicForm2;

implementation

{$R *.FMX}

end.
