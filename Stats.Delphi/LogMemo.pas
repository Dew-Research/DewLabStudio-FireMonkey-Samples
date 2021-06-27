unit LogMemo;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  System.Rtti,
  System.Bindings.Outputs,
  Data.Bind.Grid,
  Fmx.StdCtrls,
  FMX.Header, FMX.Layouts, FMX.Memo, FMX.Controls, FMX.Types;


type
  TfrmLogForm = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogForm: TfrmLogForm;

implementation

{$R *.FMX}

procedure TfrmLogForm.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

end.
