unit Changes11;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,

  Basic_REdit, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo;


type
  TfrmChanges11 = class(TfrmBaseRichEdit)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChanges11: TfrmChanges11;

implementation

{$R *.FMX}

procedure TfrmChanges11.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1, RichEdit1.Lines do
  begin
    Clear;
    Add('   Release 1.1: List of changes');
    Add('');
    Add('   Statistics.pas');
    Add('');
    Add('   *   Added Chi-Squared and F tests for comparing variance(s).');
    Add('   *   Added Spearman rank correlation test.');
    Add('   *   Added LogNormalFit routine for fitting log-normally distributed values.');
    Add('   *   Fixed the internal TiedRank routine (in some special cases ranks were not calculated correctly) and moved it to public section.');
    Add('   *   Added autocovariance, autocorrelation and partial autocorellation functions.');
    Add('   *   Added Chi2 Goodness of fit test routines.');
    Add('   *   Added Shapiro-Wilks and Shapiro-Francia Goodness of fit test routines.');
    Add('   *   Minor bug fixes.');
    Add('');
    Add('   StatSeries.pas');
    Add('');
    Add('   *   Added control limits calculation for R-Chart.');
    Add('   *   Added EWMA chart calculation.');
    Add('   *   Removed the probability axis tool. Now the relevant code is included in probability series (simplified code - see updated example in Statistics demo).');
    Add('');
    Add('   *   Regress.pas');
    Add('   *   ');
     Add('   *   Fixed R2 calculation for Constant := false case.');
    Add('   *   Added logistic (simple and ordinal) regression routines.');
    Add('   *   Minor bug fixes');
    Add('   *   ');
    Add('   *   StatTools.pas');
    Add('   *   ');
    Add('   *   New TMtxLogistReg component which encapsulates '
      + 'logistic regression routines.');
    Add('   *   ');
    Add('   *   StatARIMA.pas (ALPHA VERSION, NOT YET OFFICIALLY SUPPORTED)');
    Add('   *   ');
    Add('   *   New unit which introduces several routines for ARMA and ARIMA processes. '
      + 'These routines are still in testing and not yet fully developed. This goes for '
      + 'EstimateArima and PredictArima routines.');
    Add('');
  end;
end;

initialization
  RegisterClass(TfrmChanges11);
end.
