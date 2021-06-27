unit Wizard_MLReg;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IOUtils,

  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form, FMX.Layouts, FMX.Memo, FMX.Types, FMX.Controls, FMX.ScrollBox,
  FMX.Controls.Presentation;


type
  TfrmShowMLRWizard = class(TfrmBasic)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShowMLRWizard: TfrmShowMLRWizard;

implementation

uses MLRegWizard;  { <--- Custom wizard, you can chage it at will <g> }

{$R *.FMX}

procedure TfrmShowMLRWizard.FormCreate(Sender: TObject);
var aForm: TfrmMulLinRegWiz;
    aPath: string;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('By using TMtxMulLinReg component you can easiliy perform'+
        ' multiple linear regression. Just add a matrix of independent'+
        ' variables, vector of dependent variable and (optionally)'+
        ' weights and let Statistics regression routines do the rest.');
  end;

  aForm := TfrmMulLinRegWiz.Create(Self);
  EmbeddForm(aForm, Self.Panel1);
  aForm.BtnCancel.Visible := false; { in this case hide Cancel button }

  aPath := GetDataPath + 'MulLinReg_Y.vec';
  aForm.MtxMulLinReg.Y.LoadFromFile(aPath);

  aPath := GetDataPath + 'MulLinReg_A.mtx';
  aForm.MtxMulLinReg.A.LoadFromFile(aPath);

  aForm.UpdateData;
end;

initialization
  RegisterClass(TfrmShowMLRWizard);

end.
