unit Changes101;

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
  Basic3;


type
  TfrmChanges101 = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChanges101: TfrmChanges101;

implementation

  {$R *.FMX}

procedure TfrmChanges101.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('List of new features in v1.0.1:');
    Add('');

    Add('');
    Add('MtxVec.pas and Math387.pas :');
    Add('* More thread safety for dlls and MtxVec.pas');
    Add('* Better single precision support for Delphi');
    Add('* StrToCplx now works with any string formating');
    Add('* StrToVal same as StrToFloat except for NAN and INF');
    Add('* StringsToValues uses new StrToCplx and StrToVal methods');
    Add('* SaveToStream now has a parameter for precision rounding type');
    Add('* LoadFromStream now loads any precision and has new version control');
    Add('* LoadFromFile now uses LoadFromStream');
    Add('* Added property editors and IDE streaming to TMtx and TVec objects');
    Add('* TVec Rotate method now accepts negative indexes');
    Add('* Most trigonometric functions now use VML');
    Add('* TVec : added DivideVec, Cbrt, InvCbrt, InvSqrt methods');
    Add('* Improved algorithm for CreateIt and FreeIt procedures'+#10+#13);

    Add('');
    Add('Probabilities.pas :');
    Add('* Added 4 new distributions : Cauchy, Maxwell, '
      + 'Pareto and  Rayleigh PDF,CDF and inverse CDF'+#10+#13);

    Add('');
    Add('Optimization.pas :');
    Add('* Removed global variables/functions. Now all '
        + 'procedures/functions are thread-safe');
    Add('* Improved the numerical gradient and Hessian '
        + 'matrix calculation algorithm');
    Add('* Improved BFGS method');
    Add('* MinBrent now returns number of iterations '
        + 'needed to reach minimum value. Minimum position '
        + 'is now stored in MinX variable'+#10+#13);

    Add('');
    Add('MtxVecEdit.pas :');
    Add('* MtxVecEdit form does not save changes if not '
        + 'displayed modaly');
    Add('* "Copy as Real" option allows copying complex '
        + 'matrix as real columns');
    Add('* "Paste as Complex" option allows pasting '
        + 'real colums as complex matrix');
    Add('* The new "Copy as Real" and "Paste as Complex" '
        + 'options allow copying/pasting tables from '
        + 'Word or Excel');
    Add('* TeeChart dependant code has been moved from '
        + 'MtxVecEdit to MtxVecTee unit'+#10+#13);

    Add('');
    Add('MtxVecTools.pas :');
    Add('* New unit encapsulates all MtxVec components');
    Add('* TMtxOptimization component - interfaces Optimization unit'+#10+#13);

    Add('');
    Add('MtxDBTools.pas :');
    Add('* New unit encapsulates all MtxVec DB components');
    Add('* TMtxDataset component - provides direct read/write '
        + 'access to any TDataset descendant'+#10+#13);

    Add('');
    Add('Miscellaneous :');
    Add('* New installer automatically instals help files, '
        + 'runtime/design time packages and all MtxVec files.'+#10+#13);
  end;
end;

initialization
  RegisterClass(TfrmChanges101);


end.
