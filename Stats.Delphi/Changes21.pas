unit Changes21;

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
  TfrmChanges21 = class(TfrmBaseRichEdit)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var                                                         
  frmChanges21: TfrmChanges21;

implementation

{$R *.FMX}

procedure TfrmChanges21.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1, RichEdit1.Lines do
  begin
    Clear;
    Add('');
    Add('   Release 2.1 (June 2006): List of changes');
    Add('');
    Add('   Statistics.pas');
    Add('');
    Add('   *   Added Hotelling T2 one or two sample test.');
    Add('   *   Added M-Box test for equal covariance matrices.');
    Add('   *   Added Mann--Whitney U test.');
    Add('   *   Added Metric (classical) Multidimensional Scaling routine.');
    Add('   *   Added Cronbach Alpha coefficient routine (Item Analysis).');
    Add('   *   Added Latin Hypercube DOE.');
    Add('');
    Add('   Regress.pas');
    Add('');
    Add('   *   Added Principal Component Regression (PCR).');
    Add('');
    Add('   StatSeries.pas');
    Add('');
    Add('   *   Added TBiPlotSeries.');
    Add('');
    Add('   Release 2.1 (March 2006): List of changes');
    Add('');
    Add('   Statistics.pas');
    Add('');
    Add('   *   Added Kolmogorov-Smirnov goodnes of fit test (one and two sample).');
    Add('   *   Added empirical cumulative distribution function.');
    Add('   *   Chi2 GOF test: added support for log-normal and uniform distribution.');
    Add('   *   Added ZScores for vector.');
    Add('   *   Added Bera-Jarque test to normal distribution.');
    Add('   *   Added Lilliefors test to normal distribution.');
    Add('   *   Added Grubb''s test for outliers.');
    Add('   *   Fixed several bugs in Histogram routine.');
    Add('');
    Add('   StatTimeSerAnalysis.pas');
    Add('');
    Add('   *   Added sigle, double and triple exponential smoothing routines.');
    Add('   *   Added single, double and triple exponential forecasting routines.');
    Add('   *   Added single moving average function.');
    Add('   *   Added ARMA/ARIMA simulation routines.');
    Add('   *   Added ARMA/ARIMA forecasting routines.');
    Add('   *   Added ARMA/ARIMA predicting (MLE) routines.');
    Add('   *   Added Yule-Walker and Burg AR coefficients estimation.');
    Add('   *   Added innovations ARMA and MA coefficients estimation.');
    Add('   *   Added innovations and Durbin-Levinson algorithms.');
    Add('   *   Added ARAR model fitting and forecasting routines.');
    Add('   *   Added Box-Cox and inverse Box-Cox transformation.');
    Add('');
    Add('   RegModels.pas');
    Add('');
    Add('   *   Added rational fit model.');
    Add('   *   Added logistic fit model.');
    Add('');
    Add('   Regress.pas');
    Add('');
    Add('   Added Poisson regression.');
    Add('');
    Add('   *   StatTools.pas');
    Add('');
    Add('   *   Added TMtxBinaryTest component for performing one and two test(s) binary diagonstic test.');
    Add('');
    Add('   StatControlCharts.pas');
    Add('');
    Add('   *   Added Levey-Jennings Westgard rules check.');
    Add('   *   Added CumSum QC chart.');
    Add('');
  end;

end;

initialization
  RegisterClass(TfrmChanges21);

end.
