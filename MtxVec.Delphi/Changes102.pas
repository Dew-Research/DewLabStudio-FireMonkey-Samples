unit Changes102;

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
  TfrmChanges102 = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChanges102: TfrmChanges102;

implementation

{$R *.FMX}

procedure TfrmChanges102.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('List of new features in v1.0.2:');
    Add('');
    Add('');
    Add('MtxVec.pas and Math387.pas :');
    Add('* Added TMtx.Determinant method (calculates determinant of a squared matrix)');
    Add('* Added TMtx.OnSetSize event (triggers when matrix Rows or Cols is changed)');
    Add('* Added TVec.Shift methid (similar to rotate method)');
    Add('* Added IsNANInf boolean function');
    Add('* Most Math387.pas functions are now written in assembler (much faster)'+#10+#13);
    Add('');
    Add('MtxVecEdit.pas :');


    Add('*  Added StayOnTop boolean parameter to ViewValues procedure'+#10+#13);
    Add('');
    Add('Optimization.pas :');
    Add('* Improved all existing optimization algorithms');
    Add('* Added new optimization algorithms: Conjugate gradient (Fletcher '
      + 'and Polak algorithm)');
    Add('* Upgraded existing BFGS algorithm. Now BFGS and DFP update '
      + 'schemes are supported (see Optimization demo)'+#10+#13);

    Add('');
    Add('MtxVecTools, MtxVecDBTools and MtxVecComCtrls.pas :');
    Add('* Added TMtxOptimization.Assign and TMtxDataset.Assign methods');
    Add('* Added TMtxOptimization.StopReason, GradTolerance properties');
    Add('* Added TMtxDataSet.ColumnsToMtx method');
    Add('* Improved TMtxDataSet reading/writing to DB algorithms');
    Add('* Added new TMtxFloatEdit component to allow easy complex '
      + 'number editing');
    Add('* Added new TMtxProgressDialog component. It can be used '
      + 'to show progress bar while executing loop tests'+#10+#13);

    Add('');
    Add('MtxVecTee.pas :');
    Add('* Improved drawing routines (support for Teechart v5 '
      + 'TChartValueList.Value)'+#10+#13);
    Add('');
    Add('Miscellaneous :');
    Add('* Added support for Delphi 6');
    Add('* Reorganized MtxVec packages  - separated runtime packages '
      + 'from design time packages');
    Add('* Combined all Delphi (and C++ Builder) versions into single '
      + 'distribution *.exe file.'+#10+#13);


  end;
end;

initialization
  RegisterClass(TfrmChanges102);

end.
