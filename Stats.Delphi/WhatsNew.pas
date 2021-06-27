unit WhatsNew;

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

  Basic_REdit, FMX.Controls.Presentation, FMX.ScrollBox;



//**   Original VCL Uses section : 


//**   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
//**   Dialogs, Basic_REdit, StdCtrls, ComCtrls;


type
  TfrmWhatsNew = class(TfrmBaseRichEdit)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWhatsNew: TfrmWhatsNew;

implementation

{$R *.FMX}

procedure TfrmWhatsNew.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   New features and changes for v6.0 (February 2020)');
    Add('');
    Add('   *   Support for Rad Studio XE10.3 Rio Update 3 and Android64 compiler.');
    Add('   *   Support for combined (either double or single) precision where meaningfull.');
    Add('');
    Add('   New features and changes for v5.3.2 (December 2018)');
    Add('');
    Add('   *   Support for Rad Studio XE10.3 Rio');
    Add('   *   Installer support for FMX and Delphi platforms.');
    Add('');
    Add('   New features and changes for v5.3.1 (January 2018)');
    Add('');
    Add('   *   New stepwise multiple linear regression component TMtxStepwiseReg. Suport for forward, backward and exhaustive search.');
    Add('   *   Support for Linux in Rad Studio XE10.2 Tokyo (Update 2). The following units are functional in Linux: RegModels, Regress, Statistiscs, StatRandom and StatTools');
    Add('   *   Bug fix for NegBinomPDF and NegBinomCDFInv (numerical stability)');
    Add('   *   .NET bug fix for Marquardt optimization method (giving rise to "complement of two.." type of error).');
    Add('   *   GeometricFit fix for confidence interval estimation.');
    Add('');
    Add('   New features and changes for v5.2 (May 2017)');
    Add('');
    Add('   *   Updated for MtxVec v5.2 (Intel IPP and MKL update).');
    Add('   *   Support for Rad Studio XE10.2 Tokyo.');
    Add('');
    Add('    New features and changes for v5.1.1 (September 2016)');
    Add('');
    Add('   *   Updated for MtxVec v5.1.1 (Intel IPP and MKL update).');
    Add('   *   Performance improvement for PairwiseDistance function (L2 norm) by roughly 10x.');
    Add('');
    Add('   New features and changes for v5.1 (May 2016)');
    Add('');
    Add('   *   Updated for MtxVec v5.1 (Intel IPP v9 update and Intel MKL update).');
    Add('   *   Cross platform support for FireMonkey on iOS, OS X and Android.');
    Add('   *   Support for old and new C++Builder 32bit and 64bit compilers.');
    Add('   *   Support for XE10.1 and related TeeChart updates.');
    Add('');
    Add('   New features and changes for v5.02 (April 2015)');
    Add('');
    Add('   *   Updated for MtxVec v5.02 (Performance Enhancements, Android support).');
    Add('   *   Update to Stats Master demo for FireMonkey to run also on Android tablets.');
    Add('   *   Support for XE8 and related TeeChart updates.');
    Add('');
    Add('   New features and changes for v5.0 (December 2014)');
    Add('');
    Add('   *   Update for MtxVec v5. All features are now available optionally also with full source pascal code running at lower speed, but with cross-platform portability.');
    Add('   *   Updated for FireMonkey XE7.');
    Add('');
    Add('   New features and changes for v4.4 (September 2014)');
    Add('');
    Add('   *    Added support for XE7.');
    Add('');
    Add('   New features and changes for v4.4 (February 2014)');
    Add('');
    Add('   *   Added support for FireMonkey including all UI controls, Demo and TeeChart support from including XE5 forward.');
    Add('   *   Fixed double and tripple exponential smoothing.');
    Add('   *   Fixed a potential round off error with two-level full factorial design.');
    Add('   *   Added new faster overload for histogram computation.');
    Add('');
    Add('   Release 4.1 List of changes');
    Add('');
    Add('   *   Support for Delphi XE2 32 and 64bit');
    Add('   *   Updated for MtxVec v4.1');
    Add('');
    Add('   Release 4.0 List of changes');
    Add('');
    Add('   Statistics.pas, Regress.pas');
    Add('   *   Fixed GrubbsTest');
    Add('   *   Fixed bug with RegressTest and Constant param');
    Add('   *   Fixed bug with TBiPlot demo');
    Add('');
    Add('   Release 3.5 (September 2008): List of changes');
    Add('');
    Add('');
    Add('   Statistics.pas');
    Add('   *   Several changes in Covatiance and CorrCoef implementation (vectorized)');
    Add('   *   Vectorization: Several routines have been vectorized.');
    Add('   *   Added: Percentile - overload when multiple percentiles were needed from the same dataset.');
    Add('   *   Added: MaxwellFit, LogisticFit routines.');
    Add('   *   Fixed: several bugs in A-D test.');
    Add('   *   Fixes: GOF Kolmogorov - fixed bug when two samples with different sizes were compared.');
    Add('   *   Fixed: Hypothesis tests - hypothesis result when test statistics was Inf or Nan.');
    Add('');
    Add('');
    Add('   StatRandom.pas');
    Add('   *   Added: Maxwell and Logistic distribution  random number generators. Stat Master now supports 25 different random number generators.');
    Add('');
    Add('');
    Add('   Regress.pas');
    Add('   *   Fixed: Several bugs in RegressTest procedure.');
    Add('   *   Added: Added Constant=true parameter to LinRegress routine.');
    Add('   *   Added: More statistical parameters for TRegStats record.');
    Add('');
    Add('');
    Add('   StatProbPlots.pas');
    Add('   *   Fixed: Q-Q plot when plotting only one dataset.');
    Add('   *   Streamlined all probability plot rutines for simplified use.');
    Add('');
    Add('');
    Add('   What''s new in Stats Master 3.0');
    Add('');
    Add('');
    Add('   Improved random generators.');
    Add('   *   Added Gumbel, Triangular, Erlang distribution random number generators.');
    Add('   *   Changed implementation for all random generators to allow either use of MtxVec.Random.dll or "inhouse" simplified random generators.');
    Add('   *   More examples, including C# an C++ examples.');
    Add('   *   Added Chi-Squared distribution parameter estimate (ChiSquareFit).');
    Add('   *   Added Cauchy distribution MLE parameter estimates (CauchyFit).');
    Add('   *   Added Erlang distribution parameter estimates (ErlangFit).');
    Add('   *   Added Laplace distribution MLE parameter estimates (LaplaceFit).');
    Add('   *   Added Negative Binomial distribution parameter estimates (NegBinomFit).');
    Add('   *   Expanded regression routines.');
    Add('   *   Added PRESS and R2 functions.');
    Add('   *   Several bug fixes.');
    Add('');
    Add('');
    Add('   What''s new in Stats Master 2.1');
    Add('   *   Several new routines for handling/manipulating time series.');
    Add('   *   New tests for normal distribution, detecting outliers, etc.');
    Add('   *   Improved examples and help files.');
    Add('   *   Several bug fixes.');
    Add('   *   Added Kolmogorov-Smirnov goodnes of fit test (one and two sample).');
    Add('   *   Added empirical cumulative distribution function.');
    Add('   *   Chi2 GOF test: added support for log-normal and uniform distribution.');
    Add('   *   Added ZScores for vector.');
    Add('   *   Added Bera-Jarque test of composite normality.');
    Add('   *   Added Grubbs''s test for outliers.');
    Add('   *   Several bugs in routine Histogram fixed.');
    Add('   *   Added single moving average function.');
    Add('   *   Added sigle, double and triple exponential smoothing routines.');
    Add('   *   Added sigle, double and triple exponential forecasting routines.');
    Add('   *   Added ARMA/ARIMA simulation routines.');
    Add('   *   Added ARMA/ARIMA estimation (MLE) routines.');
    Add('   *   Added ARMA/ARIMA forecasting routines.');
    Add('   *   Added Yule-Walker AR coefficients estimation.');
    Add('   *   Added Burg AR coefficients estimation.');
    Add('   *   Added Innovations ARMA and MA coefficients estimation.');
    Add('   *   Added innovations and Durbin-Levinson algorithms.');
    Add('   *   Added ARAR model fitting and forecasting routines.');
    Add('   *   Added Box-Cox and inverse Box-Cox transformation.');
    Add('   *   Added rational model fit.');
    Add('   *   Added logistic model fit.');
    Add('   *   Added Poisson regression.');
    Add('   *   Added tMtxBinaryTest component for performing one and two test(s) binary diagnostic test.');
    Add('   *   Added several new examples demonstrating time series analysis routines.');
    Add('');
    Add('');
    Add('   What''s new in Stats Master 2.0');
    Add('   *   Compatible with MtxVec v2.');
    Add('   *   Support for .NET.');
    Add('   *   Support for SSE3 instruction set.');
    Add('   *   Substantial increase in number of optimized primitive functions and methods via MtxVec v2.');
    Add('   *   Improved range checking and programmer safety.');
    Add('   *   Several bug fixes.');
    Add('   *   Enhanced and more customizable routines.');
    Add('');
  end;
end;

procedure TfrmWhatsNew.FormDestroy(Sender: TObject);
begin
  RichEdit1.Lines.Clear;
  inherited;
end;

initialization
  RegisterClass(TfrmWhatsNew);

end.
