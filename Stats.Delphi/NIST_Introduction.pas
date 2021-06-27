unit NIST_Introduction;

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
  FMX.Header;

//**   Original VCL Uses section : 


//**   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//**   StdCtrls;


type
  TfrmNISTIntro = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNISTIntro: TfrmNISTIntro;

implementation

{$R *.FMX}

procedure TfrmNISTIntro.FormCreate(Sender: TObject);
begin
  With Memo1.Lines do
  begin
    Clear;
    Add('Taken from NIST introduction (http://www.itl.nist.gov/div898/strd/index.html)');
    Add(chr(13));
    Add('"In response to industrial concerns about the numerical accuracy' +
        ' of computations from statistical software, the Statistical Engineering'+
        ' and Mathematical and Computational Sciences Divisions of NISTs Information'+
        ' Technology Laboratory are providing datasets with certified values for a'+
        ' variety of statistical methods.');
    Add('Currently datasets and certified values are provided for assessing the accuracy' +
        ' of software for univariate statistics, linear regression, nonlinear regression,' +
        ' and analysis of variance. The collection includes both generated and "real-world"' +
        ' data of varying levels of difficulty. Generated datasets are designed to challenge '+
        ' specific computations. Certified values are "best-available" solutions.');
    Add('Datasets are ordered by level of difficulty (lower, average, and higher).'+
        ' Strictly speaking the level of difficulty of a dataset depends on the algorithm. These' +
        ' levels are merely provided as rough guidance for the user. Producing correct results on'+
        ' all datasets of higher difficulty does not imply that your software will pass all datasets'+
        ' of average or even lower difficulty. Similarly, producing correct results for all datasets'+
        ' in this collection does not imply that your software will do the same for your particular'+
        ' dataset. It will, however, provide some degree of assurance, in the sense that your package'+
        ' provides correct results for datasets known to yield incorrect results for some software."');
    end;
end;

initialization
  RegisterClass(TfrmNISTIntro);

end.
