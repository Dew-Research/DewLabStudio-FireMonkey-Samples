program FmxStatDemoW32_D29;

uses
  System.StartUpCopy,
  FMX.Forms,
  SysUtils,
  Basic_Form in 'Basic_Form.pas' {frmBasic},
  Basic_QC in 'Basic_QC.pas' {frmBasicQC},
  Basic_REdit in 'Basic_REdit.pas' {frmBaseRichEdit},
  Basic_Wizard in 'Basic_Wizard.pas' {frmBasicWizard},
  Basic_Chart in 'Basic_Chart.pas' {frmBasicChart},
  Anova_Tests in 'Anova_Tests.pas' {frmANOVATest},
  ANOVA1_Box in 'ANOVA1_Box.pas' {frmANOVA1Box},
  ARIMAWizard in 'ARIMAWizard.pas' {frmARIMAWizard},
  BiPlotDemo in 'BiPlotDemo.pas' {frmBiPlot},
  Changes11 in 'Changes11.pas' {frmChanges11},
  Changes21 in 'Changes21.pas' {frmChanges21},
  Changes30 in 'Changes30.pas' {frmChanges30},
  DecompWizard in 'DecompWizard.pas' {frmDecompositionWizard},
  EWMA_Demo in 'EWMA_Demo.pas' {frmEWMA},
  Fit_Model in 'Fit_Model.pas' {frmModels},
  HotellingT2 in 'HotellingT2.pas' {frmHotellingWizard},
  Hypothesis_Test in 'Hypothesis_Test.pas' {frmHypTest},
  Item_Analysis in 'Item_Analysis.pas' {frmItemAnalysis},
  List_Func in 'List_Func.pas' {frmListFunc},
  LogMemo in 'LogMemo.pas' {frmLogForm},
  LogReg_Demo in 'LogReg_Demo.pas' {frmLogReg},
  Main in 'Main.pas' {frmMain},
  MDSWizard in 'MDSWizard.pas' {frmMDSWiz},
  MLR_Editor in 'MLR_Editor.pas' {frmMLREditor},
  MLRegWizard in 'MLRegWizard.pas' {frmMulLinRegWiz},
  NIST_Introduction in 'NIST_Introduction.pas' {frmNISTIntro},
  NLin_Tests in 'NLin_Tests.pas' {frmNonLinTest},
  NormalProbPlot in 'NormalProbPlot.pas' {frmNormalProb},
  Oder_Form in 'Oder_Form.pas' {frmOrder},
  PCAWizard in 'PCAWizard.pas' {frmPCAWiz},
  PCRegWizard in 'PCRegWizard.pas' {frmPCRegWizard},
  GOF_Chi2 in 'GOF_Chi2.pas' {frmGOFChi2},
  GOF_KS in 'GOF_KS.pas' {frmGOFKS},
  QC_Attr in 'QC_Attr.pas' {frmQCAttr},
  QC_CP in 'QC_CP.pas' {frmQCCP},
  QC_Levey in 'QC_Levey.pas' {frmLevey},
  QC_Pareto in 'QC_Pareto.pas' {frmParetoChart},
  QC_XR in 'QC_XR.pas' {frmQCXR},
  QQPlot in 'QQPlot.pas' {frmQQPlot},
  Quick_Start in 'Quick_Start.pas' {frmQuickStart},
  Random_Generator in 'Random_Generator.pas' {frmRandomGen},
  RidgeRegWizard in 'RidgeRegWizard.pas' {frmRidgeRegWizard},
  TS_ARAR in 'TS_ARAR.pas' {frmARAR},
  TS_ARIMASim in 'TS_ARIMASim.pas' {frmARIMASim},
  TS_ExpSmooth in 'TS_ExpSmooth.pas' {frmExpSmooth},
  TS_PACF in 'TS_PACF.pas' {frmTSPACF},
  WeibullProbPlot in 'WeibullProbPlot.pas' {frmWeibullProb},
  Welcome_Stat in 'Welcome_Stat.pas' {frmWelcome},
  WhatsNew in 'WhatsNew.pas' {frmWhatsNew},
  Wizard_ARIMA in 'Wizard_ARIMA.pas' {frmWizardARIMA},
  Wizard_Decomp in 'Wizard_Decomp.pas' {frmDecompDemo},
  Wizard_Hotelling in 'Wizard_Hotelling.pas' {frmShowHotellingWizard},
  Wizard_MDS in 'Wizard_MDS.pas' {frmShowMDSWizard},
  Wizard_MLReg in 'Wizard_MLReg.pas' {frmShowMLRWizard},
  Wizard_PCA in 'Wizard_PCA.pas' {frmShowPCAWizard},
  Wizard_PCReg in 'Wizard_PCReg.pas' {frmShowPCRegWizard},
  Wizard_RidgeReg in 'Wizard_RidgeReg.pas' {frmShowRidgeReg};

{$R *.res}

begin
  Application.Initialize;
  FormatSettings := TFormatSettings.Create('en-EN');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.