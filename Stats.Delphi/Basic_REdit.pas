unit Basic_REdit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Memo,
  FMX.Header, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ScrollBox;


type
  TfrmBaseRichEdit = class(TForm)
    RichEdit1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseRichEdit: TfrmBaseRichEdit;

implementation

{$R *.FMX}

//procedure IniTMemoURLDetection(RE: TMemo);
//var mask: Word;
//begin
//  mask := SendMessage(RE.Handle, EM_GETEVENTMASK, 0, 0);
//  SendMessage(RE.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
//  SendMessage(RE.Handle, EM_AUTOURLDETECT, Integer(True), 0);
//end;


procedure TfrmBaseRichEdit.FormCreate(Sender: TObject);
begin
//  IniTMemoURLDetection(RichEdit1);
end;

end.
