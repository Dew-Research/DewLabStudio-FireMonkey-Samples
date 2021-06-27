unit Basic1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMXTee.Chart,FMXTee.Procs,FMXTee.Engine,FMXTee.Series,
  Fmx.StdCtrls,
  FMX.Header, FMX.Layouts, FMX.Memo, FMX.ScrollBox, FMX.Controls.Presentation,
  FMX.Memo.Types;


type
  TBasicForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CheckDownSample: TCheckBox;
    RichEdit1: TMemo;
    Chart1: TChart;
    procedure CheckDownSampleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDownSize: boolean;
    procedure SetDownSize(const Value: boolean);
    { Private declarations }
  public
     TimeCheck : DWord;
     TimeElapsed : DWord;
     property DownSize: boolean read FDownSize write SetDownSize;
    { Public declarations }
  end;

function GetFile1(FileName: string): string;

var BasicForm1: TBasicForm1;

implementation

function GetFile1(FileName: string): string;
begin
    {$IFDEF POSIX}
         {$IFDEF OSX}
         Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)) ,LowerCase(FileName));
         {$ELSE}
         Result := TPath.Combine(TPath.GetDocumentsPath, UpperCase(FileName));
         {$ENDIF}
     {$ELSE}
     Result := ExtractFileDir(ParamStr(0)) + '\' + LowerCase(FileName);
     {$ENDIF}
end;

{$R *.FMX}

procedure TBasicForm1.SetDownSize(const Value: boolean);
begin
  FDownSize := Value;
end;

procedure TBasicForm1.CheckDownSampleClick(Sender: TObject);
begin
     FDownSize := TCheckBox(Sender).IsChecked;
     Chart1.AllowZoom := Not(TCheckBox(Sender).IsChecked);
end;

procedure TBasicForm1.FormCreate(Sender: TObject);
begin
     RichEdit1.Lines.Clear;
end;

end.

