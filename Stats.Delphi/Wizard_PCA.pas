unit Wizard_PCA;

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
  FMX.Controls.Presentation, FMX.Memo.Types;

type
  TfrmShowPCAWizard = class(TfrmBasic)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShowPCAWizard: TfrmShowPCAWizard;

implementation

Uses PCAWizard, Statistics;

{$R *.FMX}

procedure TfrmShowPCAWizard.FormCreate(Sender: TObject);
var  aForm: TfrmPCAWiz;
     aPath: string;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('Principal Component Analysis (PCA)');
    Add(chr(13));
    Add('PCA can be done with only one procedure call :');
    Add('PCA(Data,PrinCom,EigValues,ZScores,VarPercent);');
    Add('This form demonstrates how you can use basic and advanced '+
        ' Statistics procedures. In this case PCA data is pre-loaded.' +
        ' But you can test this with your data - just press the "Edit" '+
        ' button...');
  end;

  aForm := TfrmPCAWiz.Create(Self);
  EmbeddForm(aForm, Self.Panel1);
  AForm.BtnCancel.Visible := false; { in this case hide Cancel button }
    { load prepared data }

  aPath := GetDataPath + 'PCA_Data.mtx';
  aForm.MTXPCA.Data.LoadFromFile(aPath);
  aForm.MTXPCA.PCAMode := PCARawData;

//  Show();
end;

initialization
  RegisterClass(TfrmShowPCAWizard);

end.
