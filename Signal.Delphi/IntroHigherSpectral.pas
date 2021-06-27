unit IntroHigherSpectral;

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
  TIntroHigherSpectralForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroHigherSpectralForm: TIntroHigherSpectralForm;

implementation

{$R *.FMX}

procedure TIntroHigherSpectralForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Make use of higher order spectral analysis:');
    Add('');
    Add('');

    Add('   *   Compute bispectrum and/or bicoherence of real and complex signals');
    Add('   *   Compute bicoherence for only preselected frequency pairs');
    Add('   *   View bicoherence in real time with running average');
    Add('   *   Select from 10 time window functions');
    Add('   *   Supports spectrum sizes with more then 16384 lines for preselected frequency pairs');
    Add('   *   Full set of peak marking/tracking features');
    Add('   *   Frequency band statistics');
  end;
end;

initialization
   RegisterClass(TIntroHigherSpectralForm);

end.
