unit Wizard_ARIMA;

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
  TfrmWizardARIMA = class(TfrmBasic)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWizardARIMA: TfrmWizardARIMA;

implementation

{$R *.FMX}

Uses ARIMAWizard; { <--- ARMA/ARIMA wizard }

procedure TfrmWizardARIMA.FormCreate(Sender: TObject);
var aForm: TfrmARIMAWizard;
    aPath: string;
begin
  inherited;
  With Memo1.Lines do
  begin
    Clear;
    Add('ARMA/ARIMA model fitting and forecasting');
    Add(chr(13));
    Add('Time series analysis by using ARMA/ARIMA models');
    Add('This form demonstrates how you can use time series analysis routines for '+
        ' approximating and forecasting time series values with ARMA/ARIMA models. '+
        '  In this case sample time series is preloaded with it''s mean value removed.' +
        ' Time series still doesn''t "look" stationary. Try differencing time series to obtain'+
        ' approximately stationary series.');
    Add('You can also test this wizard with your data - just press the "Load" '+
        ' button on the first wizard page.');
  end;

  aForm := TfrmARIMAWizard.Create(Self);

  EmbeddForm(aForm, Self.Panel1);
  aForm.BtnCancel.Visible := false; { in this case hide Cancel button }
  { load prepared data }

  aPath := GetDataPath + 'dowjones.vec';
  aForm.TimeSeries.LoadFromFile(aPath);
  aForm.TimeSeries.Caption := aPath;

  aForm.UpdateData;
end;

initialization
  RegisterClass(TfrmWizardARIMA);

end.
