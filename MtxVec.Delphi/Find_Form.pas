unit Find_Form;

interface

uses
//** Converted to FireMonkey with Mida BASIC 270     http://www.midaconverter.com

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IniFiles,
  Data.DB,
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
  Datasnap.DBClient,
  System.Rtti,
  System.Bindings.Outputs,
  Fmx.StdCtrls,
  FMX.Header, FMX.Controls.Presentation;

//**   Original VCL Uses section : 


//**   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//**   StdCtrls;


type
  TfrmFind = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    FindAll: boolean;
    FindText: String;
  end;

var
  frmFind: TfrmFind;

implementation

{$R *.FMX}

procedure TfrmFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FindText := Edit1.Text;
  FindAll := CheckBox1.IsChecked;
end;

end.

