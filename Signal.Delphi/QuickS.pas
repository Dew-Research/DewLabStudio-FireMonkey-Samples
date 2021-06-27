unit QuickS;

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
  TQStart = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QStart: TQStart;

implementation

{$R *.FMX}

procedure TQStart.FormCreate(Sender: TObject);
begin
  inherited;
  try
     RichEdit1.Lines.LoadFromFile('Texts\QuickStart.rtf');
  except
  end;
  TButton(Self.Owner.FindComponent('btnHelp')).Enabled := false;
end;

initialization
   RegisterClass(TQStart);

end.
