unit Basic_Form;

interface

{$I bdsppdefs.inc}

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,
  FMX.Forms,
  FMX.Dialogs,
  Fmx.StdCtrls,
  FMX.Header, FMX.Layouts, FMX.Memo, FMX.Types, FMX.Controls, StatTools,
  MtxBaseComp, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Memo.Types;


type
  TfrmBasic = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function EmbeddForm(const AForm:TCommonCustomForm; const AParent:TFmxObject): TCommonCustomForm;
  function GetDataPath: string;

var
  frmBasic: TfrmBasic;

implementation

{$R *.FMX}

function GetDataPath: string;
begin
   {$IFDEF POSIX}
       {$IFDEF OSX}
       Result := TPath.GetDirectoryName(ParamStr(0)) + '/';
       {$ELSE}
       Result := TPath.GetDocumentsPath + '/';
       {$ENDIF}
   {$ELSE}
    Result := TPath.GetDirectoryName(ParamStr(0)) + '/';
   {$ENDIF}
end;

function EmbeddForm(const AForm:TCommonCustomForm; const AParent:TFmxObject): TCommonCustomForm;
begin
  result:=AForm;

  while AForm.ChildrenCount>0 do
        AForm.Children[0].Parent:=AParent;
end;

procedure TfrmBasic.FormCreate(Sender: TObject);
begin
  {}
end;

end.
