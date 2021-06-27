unit Changes30;

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
  Basic_REdit, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo,
  FMX.Controls.Presentation, FMX.ScrollBox;


type
  TfrmChanges30 = class(TfrmBaseRichEdit)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChanges30: TfrmChanges30;

implementation

{$R *.FMX}

procedure TfrmChanges30.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1, RichEdit1.Lines do
  begin
    Clear;
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
    Add('   Release 4.1 (September 2011): List of changes');
    Add('   ');
    Add('   *   Support for Delphi XE2, 32bit and 64bit compiler');
    Add('   ');

    Add('   Release 4.0 (June 2010): List of changes');
    Add('   ');
    Add('   Statistics.pas');
    Add('   ');
    Add('   *   Fixed GrubbsTest');
    Add('   *   Fixed bug with RegressTest and Constant param');
    Add('   *   Fixed bug with TBiPlot demo');
    Add('   ');

    Add('   Release 3.5 (September 2008): List of changes');
    Add('   ');
    Add('   Statistics.pas');
    Add('   ');
    Add('   *   Several changes in Covatiance and CorrCoef implementation (vectorized)');
    Add('   *   Vectorization: Several routines have been vectorized.');
    Add('   *   Added: Percentile - overload when multiple percentiles were needed from the same dataset.');
    Add('   *   Added: MaxwellFit, LogisticFit routines.');
    Add('   *   Fixed: several bugs in A-D test.');
    Add('   *   Fixes: GOF Kolmogorov - fixed bug when two samples with different sizes were compared.');
    Add('   *   Fixed: Hypothesis tests - hypothesis result when test statistics was Inf or Nan.');
    Add('   ');
    Add('   StatRandom.pas');
    Add('   ');
    Add('   *   Added: Maxwell and Logistic distribution  random number generators. Stat Master now supports 25 different random number generators.');
    Add('   ');
    Add('   Regress.pas');
    Add('   ');
    Add('   *   Fixed: Several bugs in RegressTest procedure.');
    Add('   *   Added: Added Constant=true parameter to LinRegress routine.');
    Add('   *   Added: More statistical parameters for TRegStats record.');
    Add('   ');
    Add('   StatProbPlots.pas');
    Add('   ');
    Add('   *   Fixed: Q-Q plot when plotting only one dataset.');
    Add('   *   Streamlined all probability plot rutines for simplified use.');
    Add('   ');

    Add('   Release 3.0 (June 2007): List of changes');
    Add('   ');
    Add('   Statistics.pas');
    Add('   ');
    Add('   *   Expanded and moved all MV*** routines to Probabilities.pas.');
    Add('   *   Moved ACF,PACF,AutoCov routines to StatTimeSerAnalysis.pas unit.');
    Add('   *   Added Chi-Squared distribution parameter estimate (ChiSquareFit).');
    Add('   *   Added Cauchy distribution MLE parameter estimates (CauchyFit).');
    Add('   *   Added Erlang distribution parameter estimates (ErlangFit).');
    Add('   *   Added Laplace distribution MLE parameter estimates (LaplaceFit).');
    Add('   *   Added Negative Binomial distribution parameter estimates (NegBinomFit).');
    Add('   *   Anderson-Darling normal distribution p value now calculated correctly by using saddlepoint approximation.');
    Add('   ');
    Add('   Regress.pas');
    Add('   ');
    Add('   *   Added PRESS and R2 functions.');
    Add('   *   Added optimal Ridge Regress k calculation (using minimal MSE).');
    Add('   ');
    Add('   *   StatRandom.pas');
    Add('   ');
    Add('   *   Added Gumbel, Triangular, Erlang distribution random number generators.');
    Add('   *   Changed implementation for all random generators to allow either use of MtxVec.Random.dll or "inhouse" simplified random generators.');
    Add('   ');
    Add('   Help files and examples');
    Add('   ');
    Add('   *   All examples now include Delphi, C++ and C# personalities.');
    Add('   ');
  end;
end;

initialization
  RegisterClass(TfrmChanges30);

end.
