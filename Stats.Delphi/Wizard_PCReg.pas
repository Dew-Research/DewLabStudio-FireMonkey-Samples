unit Wizard_PCReg;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  FMX.Dialogs,
  Fmx.StdCtrls,
  FMX.Header,
  Basic_Form, FMX.Layouts, FMX.Memo, FMX.Types, FMX.Controls;


type
  TfrmShowPCRegWizard = class(TfrmBasic)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShowPCRegWizard: TfrmShowPCRegWizard;

implementation

{$R *.FMX}

Uses PCRegWizard;

procedure TfrmShowPCRegWizard.FormCreate(Sender: TObject);
var aForm: TfrmPCRegWizard;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('Principal Components Regression (PC Regression) is a technique for analyzing multiple regression data that suffer '
      + 'from multicollinearity. When multicollinearity occurs, least squares estimates are unbiased, but their variances '
      + 'are large so they may be far from the true value. By adding a degree of bias to the regression estimates, principal '
      + 'components regression reduces the standard errors. It is hoped that the net effect will be to give more reliable '
      + 'estimates.');
  end;

  aForm := TfrmPCRegWizard.Create(Self);
  EmbeddForm(aForm, Self.Panel1);
  aForm.BtnCancel.Visible := false; { in this case hide Cancel button }
    { load prepared data }
    try
      aForm.A.SetIt(18,3,false,[1,	2,	1,
                          2,	4,	2,
                          3,	6,	4,
                          4,	7,	3,
                          5, 7,	2,
                          6,	7,	1,
                          7,	8,	1,
                          8,	10,	2,
                          9,	12,	4,
                          10,	13,	3,
                          11,	13,	2,
                          12,	13,	1,
                          13,	14,	1,
                          14,	16,	2,
                          15,	18,	4,
                          16,	19,	3,
                          17,	19,	2,
                          18,	19,	1]);
      aForm.Y.SetIt([3,9,11,15,13,13,17,21,25,27,25,27,29,33,35,37,37,39]);
    except
    end;
  aForm.UpdateData;
end;

initialization
  RegisterClass(TfrmShowPCRegWizard);

end.
