unit Welcome_Stat;

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

  Basic_REdit;



//**   Original VCL Uses section : 


//**   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
//**   Dialogs, Basic_REdit, StdCtrls, ComCtrls;


type
  TfrmWelcome = class(TfrmBaseRichEdit)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWelcome: TfrmWelcome;

implementation

{$R *.FMX}

procedure TfrmWelcome.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1, RichEdit1.Lines do
  begin
    Clear;
    Add('');
    Add('');
    Add('   Welcome to Stats Master');
    Add('');
    Add('');
    Add('   Stats Master is a (c) MtxVec Add-On library with many statistical and mathematical routines. It comes with:');
    Add('');
    Add('   *   25 different distributions random generators');
    Add('   *   One and two parameter(s) hypothesis testing');
    Add('   *   Non-parametric hypothesis testing');
    Add('   *   Analysis of variance');
    Add('   *   Principal component analysis');
    Add('   *   Multidimensional scaling, FA');
    Add('   *   Linear and multiple linear regression');
    Add('   *   Non-linear regression');
    Add('   *   Poissom, Logistic regression');
    Add('   *   Special statistical plots');
    Add('   *   Quality control charts');
    Add('   *   Time series analysis and prediction');
    Add('   *   Easy-to-use set of components');
    Add('   *   and many more...');
    Add('');
    Add('Stats Master demonstrates how easy, fast and performance efficient it'+
        ' is to build advanced numerical algorithms with MtxVec. Many of the essential'+
        ' statistical routines presented in this package were not available to'+
        ' Delphi developers at all - until now.');
    Add('');
    Add('Navigate through the demo application, to learn more '+
        'about Stats Master and experience it''s unmatched '+
        ' performance and ease of use.');
  end;
end;

initialization
  RegisterClass(TfrmWelcome);

end.
