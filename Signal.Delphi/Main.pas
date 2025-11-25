unit Main;

{ Some features taken from TeeChart v5.0 demo program }
{ Coded by David Berneda, Steema SL                   }

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
  FMX.Dialogs,
  FMX.TreeView,
  FMX.Layouts,
  FMX.TabControl,
  FMX.Controls,
  FMX.Types,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Styles,
  FMX.Types3D,
  FMX.Forms3D,
  FMX.Viewport3D,
  CoreAudioSignal,

  {$IFDEF MSWINDOWS}
  System.Win.Registry,
  {$ENDIF}
  FMX.Objects, FMX.Controls.Presentation
  ;


type

  TFormClass = class of TCommonCustomForm;

  TfrmMain = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    PageControl1: TTabControl;
    TabForm: TTabItem;
    TabSource: TTabItem;
    btnConfig: TButton;
    Image3: TImage;
    Image2: TImage;
    TreeView1: TTreeView;
    btnClose: TSpeedButton;
    btnNext: TSpeedButton;
    btnPrevious: TSpeedButton;
    Image1: TImage;
    Label1: TLabel;
    DemoPanel: TPanel;
    TreeViewItem1: TTreeViewItem;
    OpenDialog: TOpenDialog;
    StatusBarLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Change(Sender: TObject);
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
    { Private declarations }
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
{$R *.FMX}

Uses  MtxVec, Math387;

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
  Caption := Application.Title + ', Float precision = ' + IntToStr(Sizeof(TSample)*8) + 'bit';
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

Const MtxVecRegKey='\Software\Dew Research';

{$IFNDEF POSIX}
Function CodePath:String;
var aRegistry: TRegistry;
begin
  result:='';
  aRegistry := TRegistry.Create();
  if aRegistry.OpenKeyReadOnly(MtxVecRegKey) then
     result:= aRegistry.ReadString('FmxDSPDemoPath');
  aRegistry.Free;

  if result='' then
     if FileExists('FmxBasicDemoW32_D19.dpr') then
        result := GetCurrentDir;
end;
{$ENDIF}

(*
Procedure HighLight(RichEdit:TCustomRichEdit);
var p   : Integer;
    tmp : String;

  Function IsKeyword(Const S:String):Boolean;
  Const Keywords:Array[0..46] of String=
         ('UNIT','INTERFACE','IMPLEMENTATION','USES',
          'INITIALIZATION','FINALIZATION','INHERITED','OBJECT','RECORD','PACKED','ARRAY',
          'BEGIN','END','CLASS','INTERFACE','TYPE','VAR','CONST','IN','OUT',
          'PRIVATE','PUBLIC','PROTECTED','PUBLISHED','FUNCTION','PROCEDURE','CONSTRUCTOR','DESTRUCTOR',
          'IF','ELSE','WHILE','FOR','REPEAT','UNTIL','AND','NOT','IN','DO','THEN','WITH','CASE','OF',
          'TRY','FINALLY','EXCEPT',
          'STRING','NIL');

  var t:Integer;
  begin
    result:=False;
    for t:=0 to High(Keywords) do
    if Keywords[t]=S then
    begin
      result:=True;
      break;
    end;
  end;

  Function NextWordIsKeyword:Boolean;
  Const Valid=['A'..'Z','a'..'z','_'];
  var p2  : Integer;
      Key : String;
  begin
    While p<=Length(tmp) do
    begin
      if CharInSet(tmp[p], Valid) then
         break
      else
      if tmp[p]='{' then
      begin
        RichEdit.SelStart:=p-1;
        Inc(p);
        While tmp[p]<>'}' do Inc(p);
        With RichEdit do
        begin
          SelLength:=p-SelStart;
          With SelAttributes do
          begin
            Style:=[fsItalic];
            Color:=clGreen;
          end;
          SelStart:=0;
          SelLength:=0;
        end;
      end
      else Inc(p);
    end;

    p2:=p;
    While (p<=Length(tmp)) and CharInSet(tmp[p], Valid) do Inc(p);
    if p=Length(tmp) then Inc(p);
    if p>p2 then
    begin
      key:=Copy(tmp,p2,p-p2);
      result:=IsKeyword(UpperCase(Key));
      RichEdit.SelStart:=p2-1;
      RichEdit.SelLength:=p-p2;
      Inc(p);
    end
    else result:=False;
  end;

begin
  p:=1;
  tmp:=RichEdit.Lines.Text;
  While p<Length(tmp) do
     if NextWordIsKeyword then
        RichEdit.SelAttributes.Style:=[fsBold];
  RichEdit.SelStart:=0;
  RichEdit.SelLength:=0;
end;
*)

procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  {$IFNDEF POSIX}
  if PageControl1.ActiveTab = TabSource then
  begin
    if not FileExists(CodePath+'\FmxBasicDemoW32_D19.dpr') then
    With TRegistry.Create do
    try
      DeleteKey(MtxVecRegKey);
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
{$IFNDEF POSIX}  aRegistry: TRegistry; {$ENDIF}
begin
  {$IFNDEF POSIX}
  OpenDialog.Title := 'Folder with DSP Master demo source';
  if OpenDialog.Execute then
  begin
      tmpDir := ExtractFilePath(OpenDialog.FileName);
      aRegistry := TRegistry.Create();
      if aRegistry.OpenKey(MtxVecRegKey, true) then
          aRegistry.WriteString('FmxDSPDemoPath',tmpDir);
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
              Node.TagObject.Free;
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
var Node: TTreeViewItem;
begin
    TreeView1.Clear;

    TreeViewAdd(nil,'Introduction','TIntroduction');
    TreeViewAdd(nil,'What is new','TWhatIsNewForm');
    Node := TreeViewAdd(nil,'Spectral analysis','TIntroSpectralForm');
        TreeViewAdd(Node,'Windows','TWindowsDemoForm','WindowsDemo');
        TreeViewAdd(Node,'Cross-spectrum','TCoherenceTestForm','CoherenceTest');
        TreeViewAdd(Node,'Spectrum estimation','TAutoregressDemoForm','AutoregressDemo');
        TreeViewAdd(Node,'Chirp-Z-transform','TCZTDemoForm','CZTDemo');
        TreeViewAdd(Node,'Signal browsing','TBrowseDemoForm','BrowseDemo');
        TreeViewAdd(Node,'Energy of bands','TFrequencyBandsForm','FrequencyBands');
        TreeViewAdd(Node,'Cepstral analysis','TCepstrumDemoForm','CepstrumDemo');
        TreeViewAdd(Node,'Spectrogram','TSpectrogramDemoForm','SpectrogramDemo');
    Node := TreeViewAdd(nil,'Spectrum peak analysis','TIntroPeakSpectralForm');
        TreeViewAdd(Node,'Peak marking','TPeakMarkingBasicForm','PeakMarkingBasic');
        TreeViewAdd(Node,'Peak formating','TPeakMarkingFormatingForm','PeakMarkingFormating');
        TreeViewAdd(Node,'Peak filtering','TPeakFilteringForm','PeakFiltering');
        TreeViewAdd(Node,'Peak interpolation','TPeakInterpolateForm','PeakInterpolate');
        TreeViewAdd(Node,'Order tracking','TPeakMarkingOrderForm','PeakMarkingOrder');
        TreeViewAdd(Node,'Amplt ratios','TAmpltRatiosForm','AmpltRatios');
    Node := TreeViewAdd(nil,'Higher order spectral analysis','TIntroHigherSpectralForm');
        TreeViewAdd(Node,'Bicoherence','TBispectrumTestForm','BispectrumTest');
        TreeViewAdd(Node,'Bicoherence surface','TBispectrumSurfaceForm','BispectrumSurface');
        TreeViewAdd(Node,'Bicoherence grid','TBispectrumGridForm','BispectrumColorGrid');
        TreeViewAdd(Node,'Bicoherence test','TBicoherenceTestForm','BicoherenceTest');
    Node := TreeViewAdd(nil,'Rate conversion','TIntroSignalRateForm');
        TreeViewAdd(Node,'Decimation/interpolation','TInterpolateDecimateForm','InterpolateDecimate');
        TreeViewAdd(Node,'Zoom-spectrum','TDemodulatorForm','Demodulator');
        TreeViewAdd(Node,'Signal Modulator','TModulatorForm','Modulator');
        TreeViewAdd(Node,'Narrow bandpass','TNarrowBandpassForm','NarrowBandpass');
        TreeViewAdd(Node,'Envelope detection','TEnvelopeDemoForm','EnvelopeDemo');
        TreeViewAdd(Node,'Rate conversion','TRateConvertForm','RateConvertUnit');
//        TreeViewAdd(Node,'Variable rate conversion','TVarResampleForm','VarResample');
//        TreeViewAdd(Node,'Variable rate conversion','TVariableRateConverterForm','VariableRateConverter');
    Node := TreeViewAdd(nil,'Signal processing','TIntroSignalForm');
        TreeViewAdd(Node,'Window based filters','TWindowFiltersForm','WindowFilters');
        TreeViewAdd(Node,'Parks McClellan','TOptimalFiltersForm','OptimalFilters');
        TreeViewAdd(Node,'IIR filters','TIirFilteringForm','IIRFiltering');
        TreeViewAdd(Node,'Pole-Zero','TIirZerosForm','IIRZeros');
        TreeViewAdd(Node,'Group delay','TIirGroupDelayForm','IirGroupDelay');
        TreeViewAdd(Node,'Integration/Differentiation','TDifferentiatorForm','Differentiator');
        TreeViewAdd(Node,'Phase shifters','TPhaseShifterForm','PhaseShifter');
        TreeViewAdd(Node,'Savitzky-Golay filter','TSavGolayDemoForm','SavGolayDemo');
        TreeViewAdd(Node,'Median filter','TMedianDemoForm','MedianDemo');
        TreeViewAdd(Node,'Discrete series','TDiscreteSeriesDemoForm','DiscreteSeriesDemo');
        TreeViewAdd(Node,'Phase demo','TPhaseDemoForm','PhaseDemo');
        TreeViewAdd(Node,'Filter editor','TFiltersDemoForm','FiltersDemo');
        TreeViewAdd(Node,'Signal analysis','TSignalAnalysisDemoForm','SignalAnalysisDemo');
        TreeViewAdd(Node,'Circular buffer','TBufferForm','BufferUnit');
        TreeViewAdd(Node,'Fractional filters','TFractionalFilteringForm','FractionalFiltering');
    Node := TreeViewAdd(nil,'Signal generation','TIntroSignalGenerationForm');
//        TreeViewAdd(Node,'Signal generator','TGeneratorDemoForm','GeneratorDemo');
        TreeViewAdd(Node,'Noise generation filters','TPinkNoiseForm','PinkNoise');
//        TreeViewAdd(Node,'Audio signal generator','TNoiseGeneratorForm','NoiseGenerator');
        TreeViewAdd(Node,'Signal forecasting','TSpectralDecomposition','SpectralDecompositionForecast');

    Node := TreeViewAdd(nil,'Kalman filter','TIntroKalmanForm');
        TreeViewAdd(Node,'Kalman Basic filter','TBasicKalmanForm','BasicKalman');
        TreeViewAdd(Node,'Kalman Standard filter','TKalmanFilterForm2','KalmanDemo2');
        TreeViewAdd(Node,'Kalman Extended filter','TKalmanFilterForm3','KalmanDemo3');
    {$IFNDEF DEW_MOBILE}
    Node := TreeViewAdd(nil,'ASIO Support','TIntroASIOForm');
        TreeViewAdd(Node,'Playback','TAsioPlaybackForm','AsioPlaybackUnit');
        TreeViewAdd(Node,'Recording','TAsioRecordForm','AsioRecordingUnit');
    Node := TreeViewAdd(nil,'Playback and Recording','TIntroPlaybackForm');
        TreeViewAdd(Node,'Monitor playback','TPlaybackDemoForm','PlaybackDemo');
        TreeViewAdd(Node,'Monitor recording','TMonitorDemoForm','MonitorDemo');
        TreeViewAdd(Node,'Recording trigger','TTriggerDemoForm','TriggerDemo');
        TreeViewAdd(Node,'Cross spectrum','TOnLineCoherenceForm','OnLineCoherence');
        TreeViewAdd(Node,'Bicoherence','TOnLineBicoherenceForm','OnLineBicoherence');
        TreeViewAdd(Node,'Phase scope','TPhaseScopeForm','PhaseScope');
        TreeViewAdd(Node,'Lissajous','TLissajousScopeForm','LissajousScope');
    {$ENDIF}
    Node := TreeViewAdd(nil,'Applications','TIntroApplicationForm');
        TreeViewAdd(Node,'Spectrum analyzer','TSpcAnalyzerForm','SpcAnalyzer');
        TreeViewAdd(Node,'Transfer function','TCoherenceTest2Form','CoherenceTest2');
        TreeViewAdd(Node,'Bicoherence analyzer','TBiSpcAnalyzerForm','BiSpcAnalyzer');
    TreeViewAdd(nil,'Design','TIntroDesignForm');
    TreeViewAdd(nil,'Performance','TIntroPerformanceForm');
    TreeViewAdd(nil,'Function list','TIntroFunList');
    TreeViewAdd(nil,'Component list','TIntroCompListForm');
    TreeViewAdd(nil,'Registration','TRegisterSignalForm');
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
