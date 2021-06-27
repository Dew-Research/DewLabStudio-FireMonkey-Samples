unit ClipboardMSOffice;

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
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2, MtxVec, FmxMtxVecEdit, FMX.ScrollBox, FMX.Controls.Presentation;


type
  TMSOffice = class(TBasicForm2)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);     
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    AMtx: TMtx;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MSOffice: TMSOffice;

implementation

uses FmxMtxVecTee;

{$R *.FMX}

procedure TMSOffice.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('MtxVecEdit form allows you to export/import TVec '
      + 'or TMtx values to MSOffice (Excel, Word) programs.');
    Add('');
    
    Add('Copying values to Excel (Word):');

    Add('1)	Click on the "MtxVec->Excel" button');
    Add('2)	Select "Copy" from the "Edit" menu');
    Add('3)	Go to Excel and select "Edit->Paste" menu item.');

    Add('');
    
    Add('Pasting values from Word:');

    Add('1)	Go to Word and create 2x2 table,');
    Add('2)	Enter values:''+1+2i, 0+2i, 3+1i, 2+0i''');
    Add('3)	Select table and copy it to clipboard');
    Add('4)	Click on the "Word->MtxVec" button');
    Add('5)	Select  "Edit->Paste" menu. As you can see, '
      + 'complex values are copied to TMtx.');
  end;
  CreateIt(AMtx);
end;

procedure TMSOffice.Button1Click(Sender: TObject);
begin
   AMtx.Size(5,4,false);
   AMtx.RandGauss(3,1);
   ViewValues(AMtx,'Exporting to Excel',true);
end;

procedure TMSOffice.Button2Click(Sender: TObject);
begin
  inherited;
  { initialize to zero }
  AMtx.SetZero;
  ViewValues(AMtx,'Importing from Word',true);
end;

procedure TMSOffice.FormDestroy(Sender: TObject);
begin
  FreeIt(AMtx);
  inherited;
end;

initialization
   RegisterClass(TMSOffice);

end.
