unit Main;

interface

{$I BdsppDefs.inc}

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.IniFiles,
  System.IOUtils,

  FMX.Memo,
  FMX.Edit,
  FMX.Platform,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Styles,
  FMX.Types3D,
  FMX.Forms3D,
  FMX.Viewport3D,

  {$IFDEF MSWINDOWS}
  System.Win.Registry,
  {$ENDIF}

  FMX.Dialogs, FMX.TreeView, FMX.Layouts, FMX.TabControl,
  FMX.Controls, FMX.Objects, FMX.Types, FMX.Controls.Presentation
  ;

type

  TFormClass = class of TCommonCustomForm;

  TfrmMain = class(TForm)
    TreeView1: TTreeView;
    Panel2: TPanel;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    Image1: TImage;
    PageControl1: TTabControl;
    TabForm: TTabItem;
    TabSource: TTabItem;
    btnConfig: TButton;
    btnClose: TSpeedButton;
    btnNext: TSpeedButton;
    btnPrevious: TSpeedButton;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    DemoPanel: TPanel;
    StatusBarLabel: TLabel;
    // XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    tmpForm : TCommonCustomForm;
    OldCodeFile: String;
    RichEditCode : TMemo;
    procedure InitTreeItems;
    procedure ShowForm;
    procedure ShowFormClass(AClass: TFormClass);
    function  CodeFile:String;
    function TreeViewAdd(Child: TTreeViewItem; const Title, TypeName: string; UnitName: string = ''): TTreeViewItem;
  public
    { Public declarations }
  end;


type TFormExampleInfo=class
       FormClass : TFormClass;
       UnitName  : String;
    end;

    TTreeViewTagItem = class(TTreeViewItem)
    Ref: TObject;
    end;

var
  frmMain: TfrmMain;

implementation

Uses  MtxVec, Math387;

{$R *.FMX}

function EmbeddForm(const AForm:TCommonCustomForm; const AParent:TFmxObject):TCommonCustomForm;
begin
  result:=AForm;

  while AForm.ChildrenCount>0 do
        AForm.Children[0].Parent:=AParent;
end;

procedure TfrmMain.ShowFormClass(AClass: TFormClass);
var tmpV: TViewport3D;
begin
    DemoPanel.DeleteChildren;
    if Assigned(tmpForm) then tmpForm.Free;
    if Assigned(AClass) then
    begin
        tmpForm := AClass.Create(Self);

        if tmpForm is TCustomForm3D then
        begin
          tmpV:=TViewport3D.Create(tmpForm);
          EmbeddForm(tmpForm,tmpV);
          tmpV.Color := TCustomForm3D(tmpForm).Color;
          tmpV.Align := TAlignLayout.Client;
          tmpV.Parent := DemoPanel;
        end
        else
          EmbeddForm(tmpForm,DemoPanel);

        tmpForm.Activate;
    end;
end;

procedure TfrmMain.TreeView1Change(Sender: TObject);
begin
  PageControl1.ActiveTab := TabForm;
  ShowForm;

  btnPrevious.Enabled := Assigned(TreeView1.Selected);
  btnNext.Enabled := Assigned(TreeView1.Selected);
  TabSource.Visible := CodeFile <> '';
end;

procedure TfrmMain.ShowForm;
var Item: TTreeViewItem;
begin
  Item := TreeView1.Selected;
  if Assigned(Item) then
  begin
    if Assigned(Item.TagObject) then
    begin
        {$IFDEF AUTOREFCOUNT}
        tmpForm.DisposeOf;
        {$ENDIF}
        FreeAndNil(tmpForm);
        ShowFormClass(TFormExampleInfo(Item.TagObject).FormClass);
    end;
    Label1.Text := Item.Text;
    StatusBarlabel.Text := Item.Text;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFDEF AUTOREFCOUNT}
  tmpForm.DisposeOf;
  {$ENDIF}
  FreeAndNil(tmpForm);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitTreeItems;

  TreeView1.Visible := True;
  TreeView1.ExpandAll;

  Application.Title := 'Dew Research MtxVec ' + FormatSample('0.0',MtxVecVersion/100) +  ' - FireMonkey demo';
  Caption := Application.Title;
end;

Function TfrmMain.CodeFile:String;
begin
  if Assigned(TreeView1.Selected) and
     Assigned(TreeView1.Selected.TagObject) then
     result:= TFormExampleInfo(TreeView1.Selected.TagObject).UnitName
  else
     result:='';
end;


procedure TfrmMain.btnNextClick(Sender: TObject);
var aItem: TTreeViewItem;
    gIndex: integer;
begin
     gIndex := TreeView1.Selected.GlobalIndex+1;
     if gIndex > (TreeView1.GlobalCount-1) then gIndex := TreeView1.GlobalCount-1;

     aItem := TreeView1.ItemByGlobalIndex(gIndex);
     aItem.Select;
end;

Const StatisticsRegKey='\Software\Dew Research';

{$IFNDEF POSIX}

Function CodePath: String;
begin
  result:='';
  With TRegistry.Create do
  try
    if OpenKeyReadOnly(StatisticsRegKey) then
       result:=ReadString('StatsMasterDemoPath');
  finally
    Free;
  end;
  if result='' then
     if FileExists('StatDemo.dpr') then
        result:=GetCurrentDir;
end;

{$ENDIF}

//Procedure HighLight(RichEdit:TCustomRichEdit);
//var p   : Integer;
//    tmp : String;
//
//  Function IsKeyword(Const S: String):Boolean;
//  Const Keywords:Array[0..33] of String=
//         ('UNIT','INTERFACE','BEGIN','IMPLEMENTATION','PROCEDURE','INHERITED',
//          'INITIALIZATION','END','CLASS','TYPE','VAR','PRIVATE','PUBLIC',
//          'IF','ELSE','WHILE','FOR','REPEAT','RECORD','OBJECT','FUNCTION',
//          'STRING','CONST','AND','NOT','IN','DO','THEN','WITH','USES',
//          'TRY','FINALLY','EXCEPT','PACKED');
//
//  var t:Integer;
//  begin
//    result:=False;
//    for t:=0 to High(Keywords) do
//    if Keywords[t]=S then
//    begin
//      result:=True;
//      break;
//    end;
//  end;
//
//  Function NextWordIsKeyword:Boolean;
//  Const Valid=['A'..'Z','a'..'z','_'];
//  var p2  : Integer;
//      Key : String;
//  begin
//    While p<=Length(tmp) do
//    begin
//      if CharInSet(tmp[p], Valid) then
//         break
//      else
//      if tmp[p]='{' then
//      begin
//        RichEdit.SelStart:=p-1;
//        Inc(p);
//        While tmp[p]<>'}' do Inc(p);
//        With RichEdit do
//        begin
//          SelLength:=p-SelStart;
//          With SelAttributes do
//          begin
//            Style:=[fsItalic];
//            Color:=clNavy;
//          end;
//          SelStart:=0;
//          SelLength:=0;
//        end;
//      end
//      else Inc(p);
//    end;
//
//    p2:=p;
//    While (p<=Length(tmp)) and CharInSet(tmp[p], Valid) do Inc(p);
//    if p=Length(tmp) then Inc(p);
//    if p>p2 then
//    begin
//      key:=Copy(tmp,p2,p-p2);
//      result:=IsKeyword(UpperCase(Key));
//      RichEdit.SelStart:=p2-1;
//      RichEdit.SelLength:=p-p2;
//      Inc(p);
//    end
//    else result:=False;
//  end;
//
//begin
//  p:=1;
//  tmp:=RichEdit.Lines.Text;
//  While p<Length(tmp) do
//     if NextWordIsKeyword then
//        RichEdit.SelAttributes.Style:=[fsBold];
//  RichEdit.SelStart:=0;
//  RichEdit.SelLength:=0;
//end;


procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  {$IFNDEF POSIX}
  if PageControl1.ActiveTab = TabSource then
  begin
    if not FileExists(CodePath+'\FmxStatDemoW32_D19.dpr') then
    With TRegistry.Create do
    try
      DeleteKey(StatisticsRegKey);
    finally
      Free;
    end;

    btnConfig.Visible := CodePath='';
    if (CodePath<>'') and (CodeFile<>'') then
    begin
      if OldCodeFile<>CodeFile then
      begin
        RichEditCode.Free;
        RichEditCode:=TMemo.Create(Self);
        With RichEditCode do
        begin
          Align:= {$IFDEF D21} TAlignLayout.Client; {$ELSE} TAlignLayout.alClient; {$ENDIF}
          ReadOnly := True;
          WordWrap:=False;
//           ScrollBars := ssBoth;
          Font.Family := 'Courier New';
          Font.Size:=9;
          Parent:=TabSource;
          Lines.LoadFromFile(CodePath+'\'+CodeFile+'.pas');
        end;
//        HighLight(RichEditCode, clGreen);
        OldCodeFile:=CodeFile;
      end;
    end
    else RichEditCode.Free;
  end;
  {$ENDIF}
end;

procedure TfrmMain.btnConfigClick(Sender: TObject);
var tmpDir : String;
{$IFNDEF POSIX}    aRegistry: TRegistry; {$ENDIF}
begin
  {$IFNDEF POSIX}
  OpenDialog.Title := 'Folder with MtxVec demo source';
  if OpenDialog.Execute then
  begin
      tmpDir := ExtractFilePath(OpenDialog.FileName);
      aRegistry := TRegistry.Create();
      if aRegistry.OpenKey(StatisticsRegKey, true) then
          aRegistry.WriteString('FmxMtxVecDemo',tmpDir);
      aRegistry.Free;

      PageControl1Change(Self);
  end;
  {$ENDIF}
end;

procedure TfrmMain.btnPreviousClick(Sender: TObject);
var aItem: TTreeViewItem;
    gIndex: integer;
begin
     gIndex := TreeView1.Selected.GlobalIndex-1;
     if gIndex < 0 then gIndex := 0;

     aItem := TreeView1.ItemByGlobalIndex(gIndex);
     aItem.Select;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var i: Integer;
    Node: TTreeViewItem;
begin
  for i := 0 to TreeView1.ChildrenCount - 1 do
  begin
      if (Self.Children[i] is TTreeViewItem) then
      begin
          Node := TTreeViewItem(Children[i]);
          if Assigned(Node.TagObject) then
          begin
              {$IFDEF AUTOREFCOUNT}
              Node.TagObject := nil;
              {$ELSE}
              Node.TagObject.Free;
              {$ENDiF}
              TTreeViewTagItem(Node).Ref := nil;  //for NEXTGEN
          end;
      end;
  end;
end;

function TfrmMain.TreeViewAdd(Child: TTreeViewItem; const Title, TypeName: string; UnitName: string): TTreeViewItem;
var aInfo: TFormExampleInfo;
begin
    aInfo := TFormExampleInfo.Create;

    if TypeName <> '' then aInfo.FormClass := TFormClass(FindClass(TypeName))
                      else aInfo.FormClass := nil;

    aInfo.UnitName := UnitName;

    Result := TTreeViewTagItem.Create(Self);
    Result.Text := Title;
    Result.TagObject := aInfo;
    TTreeViewTagItem(Result).Ref := aInfo; // for nextgen compiler, because TagObject is marked with [Weak]

    if Child = nil then TreeView1.AddObject(Result)
                   else Child.AddObject(Result);
end;

procedure TfrmMain.InitTreeItems;
var Node, Node1, Node2, Node3: TTreeViewItem;
begin
    TreeView1.Clear;
    Node := TreeViewAdd(nil,'Welcome to Stats Master','TfrmWelcome');
    TreeViewAdd(Node,'What''s new','TfrmWhatsNew');
    TreeViewAdd(Node,'Function List','TfrmListFunc');
    TreeViewAdd(nil,'Random number generators','TfrmRandomGen','Random_Generator');
    TreeViewAdd(nil,'Fitting various models','TfrmModels','Fit_Model');
    Node := TreeViewAdd(nil,'Hypothesis testing','');
    TreeViewAdd(Node,'Hypothesis testing editor','TfrmHypTest','Hypothesis_Test');
    TreeViewAdd(Node,'Goodnes of Fit - Chi2 test','TfrmGOFChi2','GOF_Chi2');
    TreeViewAdd(Node,'Goodnes of Fit - Kolmogorov-Smirnov test','TFrmGOFKS','GOF_KS');
    Node := TreeViewAdd(nil,'Multivariate Analysis','');
    TreeViewAdd(Node,'Principal Component Analysis','TfrmShowPCAWizard','Wizard_PCA');
    TreeViewAdd(Node,'Multidimensional scaling','TfrmShowMDSWizard','Wizard_MDS');
    TreeViewAdd(Node,'Hotelling T2','TfrmShowHotellingWizard','Wizard_Hotelling');
    TreeViewAdd(Node,'Item Analysis','TfrmItemAnalysis','Item_Analysis');
    Node := TreeViewAdd(nil,'ANOVA (Analysis of variance)','');
    TreeViewAdd(Node,'Doing one way ANOVA','TfrmANOVA1Box','ANOVA1_Box');
    Node := TreeViewAdd(nil,'Regression','');
    TreeViewAdd(Node,'ML Regression','TfrmShowMLRWizard','Wizard_MLReg');
    TreeViewAdd(Node,'ML Regression Design-time Editor','TfrmMLREditor','MLR_Editor');
    TreeViewAdd(Node,'Non-linear Regression','TfrmNonLinTest','NLin_Tests');
    TreeViewAdd(Node,'Logistic Regression','TfrmLogReg','LogReg_Demo');
    TreeViewAdd(Node,'Principal Component Regression','TfrmShowPCRegWizard','Wizard_PCReg');
    Node := TreeViewAdd(nil,'NIST Statistical Tests','TfrmNISTIntro');
    TreeViewAdd(Node,'Non-linear regression tests','TfrmNonLinTest','NLin_Tests');
    TreeViewAdd(Node,'Analysis of variance','TfrmANOVATest','ANOVA_Tests');
    Node := TreeViewAdd(nil,'Time series analysis','');
    TreeViewAdd(Node,'ACF and PACF plots','TfrmTSPACF','TS_PACF');
    TreeViewAdd(Node,'Exponential smoothing','TfrmExpSmooth','TS_ExpSmooth');
    TreeViewAdd(Node,'Decomposition forecasting','TfrmDecompDemo','Wizard_Decomp');
    TreeViewAdd(Node,'Simulating ARMA/ARIMA models','TfrmARIMASim','TS_ARIMASim');
    TreeViewAdd(Node,'ARMA and ARIMA models','TfrmWizardARIMA','WizardARIMA');
    TreeViewAdd(Node,'Using ARAR model','TfrmARAR','TS_ARAR');
    Node := TreeViewAdd(nil,'Quality Control Charts','');
    TreeViewAdd(Node,'Variables Control Charts','TfrmQCXR','QC_XR');
    TreeViewAdd(Node,'Attribute Charts','TfrmQCAttr','QC_Attr');
    TreeViewAdd(Node,'CP and CPK Charts','TfrmQCCP','QC_CP');
    TreeViewAdd(Node,'Pareto Chart','TfrmParetoChart','QC_Pareto');
    TreeViewAdd(Node,'EWMA Chart','TfrmEWMA','EWMA_Chart');
    TreeViewAdd(Node,'Levey-Jennings Chart','TfrmLevey','QC_Levey');
    Node1 := TreeViewAdd(Node,'Special statistical plots','');
    TreeViewAdd(Node1,'Quantile-Quantile plot','TfrmQQPlot','QQPlot');
    TreeViewAdd(Node1,'Normal plot','TfrmNormalProb','NormalProbPlot');
    TreeViewAdd(Node1,'Weibull plot','TfrmWeibullProb','WeibullProbPlot');
    Node := TreeViewAdd(nil,'TeeChart tools','');
    TreeViewAdd(Node,'Box Plot Chart','TfrmANOVA1Box','ANOVA1_Box');
    TreeViewAdd(Node,'Histogram','TfrmRandomGen','Random_Generator');
    TreeViewAdd(Node,'Pareto Chart','TfrmParetoChart','QC_Pareto');
    TreeViewAdd(Node,'Using TColorLineTool','TfrmQCCP','QC_CP');
    Node := TreeViewAdd(nil,'Custom series','');
    TreeViewAdd(Node,'TStatSpecialSeries','TfrmQQPlot','QQPlot');
    TreeViewAdd(Node,'TQCSeries','TfrmQCXR','QC_XR');
    TreeViewAdd(Node,'TBiPlotSeries','TfrmBiPlot','BiPlotDemo');
    Node := TreeViewAdd(nil,'List of Changes','');
    Node1 := TreeViewAdd(Node,'Release 4.0','');
    TreeViewAdd(Node1,'List of changes','TfrmChanges30');
    TreeViewAdd(Node,'Principal Component Regression','TfrmShowPCRegWizard','Wizard_PCReg');
    Node1 := TreeViewAdd(Node,'Older versions','');
//    TreeViewAdd(Node,'  Ridge Regression','TfrmShowRidgeReg','Wizard_RidgeReg');
    Node2 := TreeViewAdd(Node1,'  Release 2.1','');
    TreeViewAdd(Node2,'List of changes','TfrmChanges21');
    TreeViewAdd(Node2,'Goodnes of Fit - Kolmogorov-Smirnov test','TFrmGOFKS','GOF_KS');
    TreeViewAdd(Node2,'Levey-Jennings Chart','TfrmLevey','QC_Levey');
    TreeViewAdd(Node2,'Hotelling T2','TfrmShowHotellingWizard','Wizard_Hotelling');
    TreeViewAdd(Node2,'Multidimensional scaling','TfrmShowMDSWizard','Wizard_MDS');
    TreeViewAdd(Node2,'Item Analysis','TfrmItemAnalysis','Item_Analysis');
    TreeViewAdd(Node2,'Biplot','TfrmBiPlot','BiPlotDemo');
    Node3 := TreeViewAdd(Node2,'Time series analysis','');
    TreeViewAdd(Node3,'ACF and PACF plots','TfrmTSPACF','TS_PACF');
    TreeViewAdd(Node3,'Exponential smoothing','TfrmExpSmooth','TS_ExpSmooth');
    TreeViewAdd(Node3,'Simulating ARMA/ARIMA models','TfrmARIMASim','TS_ARIMASim');
    TreeViewAdd(Node3,'ARMA and ARIMA models','TfrmWizardARIMA','WizardARIMA');
    TreeViewAdd(Node3,'ARAR model','TfrmARAR','TS_ARAR');
    TreeViewAdd(Node3,'Decomposition forecasting','TfrmDecompDemo','Wizard_Decomp');
    Node2 := TreeViewAdd(Node1,'Release 1.1','');
    TreeViewAdd(Node2,'List of changes','TfrmChanges11');
    TreeViewAdd(Node2,'EWMA Chart','TfrmEWMA','EWMA_Chart');
    TreeViewAdd(Node2,'Logistic regression','TfrmLogReg','LogReg_Demo');
    TreeViewAdd(Node2,'Goodnes of Fit - Chi2 test','TfrmGOFChi2','GOF_Chi2');
    TreeViewAdd(nil,'How to order','TfrmOrder');
    TreeViewAdd(nil,'Quick Start','TfrmQuickStart');
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  PageControl1.ActiveTab := TabForm;
  TreeView1.Items[0].Select;

//  ShowMessageBox('Each form in the demo is a stand-alone application which can ' +
//              'be added to a new project to form a self contained application. ' +
//              'There are no code dependancies between individual forms!');
end;

end.
