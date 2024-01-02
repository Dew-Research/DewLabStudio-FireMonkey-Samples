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
    {$IFNDEF POSIX}
    OldCodeFile: String;
    RichEditCode : TMemo;
    {$ENDIF}
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

Uses  Math387;

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

  Application.Title := 'Dew Research MtxVec ' + FormatSample('0.00',MtxVecVersion/100) +  ' - FireMonkey demo';
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

Const MtxVecRegKey='\Software\Dew Research\';

{$IFNDEF POSIX}
Function CodePath:String;
var aRegistry: TRegistry;
begin
    result:='';

    aRegistry := TRegistry.Create();
    if aRegistry.OpenKeyReadOnly(MtxVecRegKey) then
        result := aRegistry.ReadString('FmxMtxVecDemo');
    aRegistry.Free;

    if result='' then
       if FileExists('FmxMtxVecDemoW32_D21.dpr') then
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
    if not FileExists(CodePath+'\FmxMtxVecDemoW32_D28.dpr') then
    With TRegistry.Create do
    try
      DeleteKey(MtxVecRegKey);
    finally
      Free;
    end;

    btnConfig.Visible := CodePath = '';
    if (CodePath <> '') and (CodeFile <> '') then
    begin
      if OldCodeFile<>CodeFile then
      begin
        RichEditCode.Free;
        RichEditCode := TMemo.Create(Self);
        With RichEditCode do
        begin
            Align:= {$IFDEF D21} TAlignLayout.Client; {$ELSE} TAlignLayout.alClient; {$ENDIF}
            ReadOnly := True;
            WordWrap:=False;

            {$IFDEF MSWINDOWS}
                RichEditCode.TextSettings.Font.Family := 'Courier New';
                RichEditCode.StyledSettings :=  RichEditCode.StyledSettings - [TStyledSetting.Family];
            {$ENDIF}
            {$IFDEF ANDROID}
                RichEditCode.TextSettings.Font.Family := 'monospace';
                RichEditCode.StyledSettings :=  RichEditCode.StyledSettings - [TStyledSetting.Family]
            {$ENDIF}

            TextSettings.Font.Size := 11;
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
    OpenDialog.Title := 'Folder with MtxVec demo source';
    if OpenDialog.Execute then
    begin
        tmpDir := ExtractFilePath(OpenDialog.FileName);
        aRegistry := TRegistry.Create();
        if aRegistry.OpenKey(MtxVecRegKey, true) then
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
var Node: TTreeViewItem;
begin
    TreeView1.Clear;
    Node := TreeViewAdd(nil, 'Introduction','TIntroduction');
    TreeViewAdd(Node, 'Why MtxVec','TIntroWhyMtxVecForm');
    TreeViewAdd(Node, 'What is new','TfrmChanges30');
    TreeViewAdd(nil,'How to use the demo','TfrmDemoHowTo');
    Node := TreeViewAdd(nil,'Matrix operations','TIntroMtx');
    TreeViewAdd(Node,'Multiplying large matrices','TMult1','Multiply1');
    TreeViewAdd(Node,'Copy and  transpose operation','TCopyComp','CopyCompare');
    TreeViewAdd(Node,'Calculating the inverse of squared matrix','TInvMtx','InverseMtx');
    TreeViewAdd(Node,'Calculating squared root of matrix','TfrmSqrtMtx','CalcSqrtMtx');
    TreeViewAdd(Node,'Eigenvalues and eigenvectors','TEigVec1','EigenVectors1');
    TreeViewAdd(Node,'LQ and QR decomposition','TLQRDemo','LQR1');
    TreeViewAdd(Node,'Solving system of equations','TLinearSystem1','SysLinear1');
    TreeViewAdd(Node,'Viewing matrix values','TfrmMtxGridSeries','MtxGridSeries_Demo');
    Node := TreeViewAdd(nil,'Vector operations','TIntroVec');
    TreeViewAdd(Node,'Levinson Yule Walker','TYuleLev','YuleLevinson');
    TreeViewAdd(Node,'Displaying large amounts of data','TDownS','PixelDownS');
    TreeViewAdd(Node,'Block Processing','TfrmBlockProc','BlockProcessing');
    TreeViewAdd(Node,'Dirichlet and Riemann functions','TfrmDirichlet','DirichletTest');
    TreeViewAdd(Node,'Benchmarks','TBenchmarkXForm','BenchmarkX');
    TreeViewAdd(Node,'New fastline series','TMtxFastLineForm','MtxFastlineDemo');
    TreeViewAdd(Node,'Threaded for-loop','TForLoopForm','ForLoopUnit');
    Node := TreeViewAdd(nil,'Exporting/Importing','TIntroExpImp');
    TreeViewAdd(Node,'Saving/Loading','TFileH1','FileHandling1');
    TreeViewAdd(Node,'MSOffice','TMSOffice','ClipboardMSOffice');
    TreeViewAdd(Node,'Editing matrix or vector values','TfrmGridDemo','MtxVecGridDemo');
//    TreeViewAdd(Node,'Different file formats','TfrmFileFormats','DemoFileFormats');
    Node := TreeViewAdd(nil,'Memory management','TIntroMemMan');
    TreeViewAdd(Node,'Comparing CreateIt/FreeIt with Create/Destroy','TMemComp1','MemoryCompare1');
    TreeViewAdd(Node,'Super conductive multi-threaded memory alloc','TSuperConductiveForm','SuperConductive');
    TreeViewAdd(Node,'Threading concurrency','TForLoopExampleForm','ForLoopExample');
    TreeViewAdd(Node,'Using default arrays','TDefArray','DefaultArray');
    Node := TreeViewAdd(nil,'Open CL support','TIntroOpenCLForm');
    TreeViewAdd(Node,'Benchmarks','TclFunctionForm','clFunction');
    TreeViewAdd(Node,'Custom function','TclCustomFunctionForm','clCustomFunction');
    TreeViewAdd(Node,'Multi device benchmark','TclMultiDeviceFunctionForm','clMultiDeviceFunction');
    Node := TreeViewAdd(nil,'Numerical integration','');
    TreeViewAdd(Node,'Numerical integration: f(x)','TfrmInt1D','NumInt1D');
    Node := TreeViewAdd(nil,'Polynomial routines','TIntroPoly');
    TreeViewAdd(Node,'Linear and cubic interpolation','TInterpolating1','Interp1');
    TreeViewAdd(Node,'Least-square fitting','TLQRPoly','QRPoly1');
    Node := TreeViewAdd(nil,'Optimization problems','');
    TreeViewAdd(Node,'Bounded optimization (Simplex)','TfrmOptimBounded','Optim_Bounded');
    TreeViewAdd(Node,'Trust Region algorithm','TfrmTRDemo','Optim_TR');
    TreeViewAdd(Node,'Linear Programming','TfrmLP','Optim_LP');
    TreeViewAdd(Node,'Unconstrained global minimization','TfrmMtxOptim','MtxOptim');
    TreeViewAdd(nil,'Probabilities unit','TfrmProbCalc','DewProbCalc');
    Node := TreeViewAdd(nil,'Sparse matrices','TIntroSparseMtx');
    TreeViewAdd(Node,'Sparse solvers','TfrmSparseTest','SparseTest');
    Node := TreeViewAdd(nil,'MtxVec Components','');
    TreeViewAdd(Node,'Unconstrained global minimization','TfrmMtxOptim','MtxOptim');
    TreeViewAdd(Node,'TMtxFloatEdit control','TfrmFloatEdit1','FloatEdit1');
    TreeViewAdd(Node,'Progress Dialog','TfrmProgDialog','ProgDialog');
    TreeViewAdd(Node,'TMtxVecGrid control','TfrmGridDemo','MtxVecGridDemo');
    TreeViewAdd(Node,'Math Parser','TfrmParser','ParserDemo');
    Node := TreeViewAdd(nil,'MtxVec Parser','TIntroParserForm');
    TreeViewAdd(Node,'Scripting','TScriptingForm','Scripting');
    TreeViewAdd(Node,'Scripting grid','TScriptingGridForm','ScriptingGrid');
    TreeViewAdd(Node,'Parser usage','TfrmParserUsage','ParserUsage');
    TreeViewAdd(Node,'Vectorized performance','TfrmParserPerformance','ParserPerformance');
    TreeViewAdd(nil,'MtxVec package function list','TfrmListFunc');
    Node := TreeViewAdd(nil,'List of changes','');
    TreeViewAdd(Node,'Version 6.x','TfrmChanges30');
    Node := TreeViewAdd(Node,'Older versions','');
    TreeViewAdd(Node,'Version 2.1.5','TfrmChanges15');
    TreeViewAdd(Node,'Version 1.02','TfrmChanges102');
    TreeViewAdd(Node,'Version 1.01','TfrmChanges101');
    TreeViewAdd(nil,'Registering MtxVec','TRegisterM');
    TreeViewAdd(nil,'Quick Start','TQStart');
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
