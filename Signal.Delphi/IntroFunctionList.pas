unit IntroFunctionList;

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
  FMX.Memo,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.ExtCtrls;

type
  TIntroFunList = class(TBasicForm3)
    ImageViewer1: TImageViewer;
    procedure FormCreate(Sender: TObject);
    procedure ImageViewer1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ImageIndex: integer;
    { Public declarations }
  end;

var
  IntroFunList: TIntroFunList;

implementation

{$R *.FMX}

procedure TIntroFunList.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    {$IFNDEf POSIX}
    LoadFromFile(ExtractFilePath(ParamStr(0))+'Routines.rtf');
    {$ENDIF}
  end;
end;

procedure TIntroFunList.ImageViewer1Click(Sender: TObject);
begin
  inherited;
  ImageIndex := (ImageIndex + 1) mod 3;
  case ImageIndex of
  0: ImageViewer1.Bitmap.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Routines1.png');
  1: ImageViewer1.Bitmap.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Routines2.png');
  2: ImageViewer1.Bitmap.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Routines3.png');
  end;
end;

initialization
   RegisterClass(TIntroFunList);

end.
