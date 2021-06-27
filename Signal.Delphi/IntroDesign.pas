unit IntroDesign;

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
  FMX.Bind.DBEngExt,
  FMX.Bind.Editors,
  FMX.Bind.DBLinks,
  FMX.Bind.Navigator,
  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.Bind.DBLinks,
  Datasnap.DBClient,
  Fmx.Bind.Grid,
  System.Rtti,
  System.Bindings.Outputs,
  Data.Bind.Grid,
  Fmx.StdCtrls,
  FMX.Header,

  Basic3;



//**   Original VCL Uses section : 


//**   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//**   Basic3, StdCtrls, ComCtrls;


type
  TIntroDesignForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroDesignForm: TIntroDesignForm;

implementation

{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.FMX}
{$ENDIF}

procedure TIntroDesignForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Architecture of the library is organized in three layers: ');
    Add('');
    Add('');
    Add('   *   Complete set of signal processing routines based on MtxVec.');
    Add('   *   With a set of components based on signal processing routines ' +
        ' your application gets a jump start in user interface and processing power.');
    Add('   *   Connectivity layer gives you the capability to visually programm ' +
        'DSP algorithm''s by connecting components.');
    
    
  end;
end;

initialization
   RegisterClass(TIntroDesignForm);

end.
