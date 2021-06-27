unit FileHandling1;

interface
uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IniFiles,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  System.Rtti,
  Fmx.StdCtrls,
  FMX.Header,
  Basic2,MtxVec,FmxMtxVecEdit, MtxExpr, FMX.Controls.Presentation, FMX.ScrollBox;



type
  TFileH1 = class(TBasicForm2)
    CheckBox1: TCheckBox;
    Label1: TLabel;
    RichEdit2: TMemo;
    Button1: TButton;                            
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    AMtx: Matrix;
    AVec: Vector;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
  end;

var
  FileH1: TFileH1;

implementation

uses IOUtils;

{$R *.FMX}

procedure TFileH1.Button1Click(Sender: TObject);
var AStream : TMemoryStream;
    tmpMtx : Matrix;
{    AStream1: MemoryStream; }
begin
  With RichEdit2.Lines, RichEdit2 do
  begin
    Clear;
    Add('AMtx.Size(10,10);');
    Add('AMtx.RandGauss; {add random data }');
    Add('{ save header & values to stream}');
    Add('AStream := TMemoryStream.Create;');
    Add('try');
    Add(' AMtx.SaveToStream(AStream);');
    Add(' { now load header & values from stream }');
    Add(' CreateIt(tmpMtx);');
    Add(' try');
    Add('   AStream.Seek(0,0);');
    Add('   tmpMtx.LoadFromStream(AStream);');
    Add('   If CheckBox1.Checked then ViewValues(AMtx);');
    Add(' finally');
    Add('   FreeIt(tmpMtx);');
    Add(' end;');
    Add('finally');
    Add('  AStream.Free;');
    Add('end;');
  end;
  AMtx.Size(10,10);
  AMtx.RandGauss; {add random data }

  { save header & values to stream}
  AStream := TMemoryStream.Create;
  try
     AMtx.SaveToStream(AStream);
    { now load header & values from stream }
     AStream.Seek(0, TSeekOrigin.soBeginning);
     tmpMtx.LoadFromStream(AStream);
     If CheckBox1.IsChecked then ViewValues(AMtx,'Memory stream',true);
  finally
     AStream.Free;
  end;

end;

procedure TFileH1.Button2Click(Sender: TObject);
var tmpVec: Vector;
    aFile: string;
begin
  With RichEdit2.Lines, RichEdit2 do
  begin
    Clear;
    Add('AVec.Size(100);');
    Add('AVec.RandUniform(-2,2);');
    Add('{save header & values to file}');
    Add('AVec.SaveToFile(''TestVec1.vec'');');
    Add('CreateIt(tmpVec);');
    Add('try');
    Add(' { load header & values into tmpVec}');
    Add(' tmpVec.LoadFromFile(''TestVec1.vec'');');
    Add(' if CheckBox1.Checked then ViewValues(tmpVec);');
    Add('finally');
    Add(' FreeIt(tmpVec);');
    Add('end;');
  end;
  AVec.Size(100);
  AVec.RandUniform(-2,2);

  aFile := TPath.Combine(TPath.GetDocumentsPath, 'TestVec1.vec');

 {save header & values to file}
  AVec.SaveToFile(aFile);

  { load header & values into tmpVec}
  tmpVec.LoadFromFile(aFile);
  if CheckBox1.IsChecked then ViewValues(tmpVec,'File Stream',true);
end;

procedure TFileH1.Button4Click(Sender: TObject);
var StringList : TStringList;
    tmpMtx: Matrix;
    aFile: string;
begin
  With RichEdit2.Lines, RichEdit2 do
  begin
    Clear;
    Add('AMtx.Size(20,20,true);');
    Add('AMtx.RandUniform(-1,2);');
    Add('StringList := TStringList.Create;');
    Add('try');
    Add(' { use tab = chr(9) as delimiter }');
    Add(' AMtx.ValuesToStrings(StringList,#9);');
    Add(' { Save matrix values to txt file }');
    Add(' StringList.SaveToFile(''ASCIIMtx.txt'');');
    Add('finally');
    Add(' StringList.Free;');
    Add('end;');
    Add('');
    Add('StringList := TStringList.Create;');
    Add('CreateIt(tmpMtx);');
    Add('try');
    Add(' { get matrix values from text file }');
    Add(' StringList.LoadFromFile(''ASCIIMtx.txt'');');
    Add(' { use tab = chr(9) as delimiter }');
    Add(' tmpMtx.StringsToValues(StringList,#9);');
    Add(' if CheckBox1.Checked then ViewValues(tmpMtx);');
    Add('finally');
    Add(' FreeIt(tmpMtx);');
    Add(' StringList.Free;');
    AdD('end;');
  end;

  aFile := TPath.Combine(TPath.GetDocumentsPath, 'ASCIIMtx.txt');

  AMtx.Size(20,20,true);
  AMtx.RandUniform(-1,2);
  StringList := TStringList.Create;
  try
     { use tab = chr(9) as delimiter }
     AMtx.ValuesToStrings(StringList,#9);
     { Save matrix values to txt file }
     StringList.SaveToFile(aFile);
  finally
     StringList.Free;
  end;

  StringList := TStringList.Create;
  try
     { get matrix values from text file }
     StringList.LoadFromFile(aFile);
     { use tab = chr(9) as delimiter }
     tmpMtx.StringsToValues(StringList,#9);
     if CheckBox1.IsChecked then ViewValues(tmpMtx,'TEXT file',true);
  finally
     StringList.Free;
  end;
end;

constructor TFileH1.Create(Aowner: TComponent);
begin
  inherited;
  With RichEdit1.Lines do
  begin
    Clear;
    Add('Importing and exporting values is an important feature '
      + 'of MtxVec. MtxVec offers you the ability to save vector/'
      + 'matrix to memory stream, binary files, text files, BLOBs, Clipboard ...');
    Add('Click on buttons bellow to introduce yourself with various '
      + 'methods available. If "View loaded values" option is '
      + 'checked, you''ll get a visual representation of loaded matrix/vector.');
  end;
end;

procedure TFileH1.Button3Click(Sender: TObject);
(*
var
    tmpBlob : TStream;
    Table1  : TTable;
*)
begin
  With RichEdit2.Lines, RichEdit2 do
  begin
    Clear;
    Add('AVec.Size(100);');
    Add('AVec.RandGauss(0,1);');
    Add('AVec.SortAscend;');
    Add('Table1 := TTable.Create(Self);');
    Add('With Table1 do');
    Add(' try');
    Add(' DatabaseName := ''DBDemos'';');
    Add(' TableType := ttDefault;');
    Add(' TableName := ''TableVec'';');
    Add(' with FieldDefs do');
    Add(' begin');
    Add('   Clear;');
    Add('   with AddFieldDef do');
    Add('   begin');
    Add('     Name := ''Field1'';');
    Add('     DataType := ftBLOB;');
    Add('     Required := False;');
    Add('   end;');
    Add(' end;');
    Add(' CreateTable;');
    Add(' { save to table1}');
    Add(' Active := true;');
    Add(' Insert;');
    Add(' tmpBLOB := CreateBLOBStream(FieldByName(''Field1''),bmReadWrite);');
    Add(' CreateIt(tmpVec);');
    Add(' try');
    Add('   AVec.SaveToStream(tmpBlob);');
    Add('   Post;');
    Add('   tmpBlob.Seek(0,0); { "reset" BLOB stream}');
    Add('   tmpVec.LoadFromStream(tmpBlob);');
    Add('   If CheckBox1.Checked then ViewValues(tmpVec);');
    Add(' finally');
    Add('   FreeIt(tmpVec);');
    Add('   tmpBLOB.Free;');
    Add(' end;');
    Add('finally');
    Add(' Active := false;');
    Add(' DeleteTable;');
    Add(' Destroy;');
    Add('end;');
  end;

end;

initialization
   RegisterClass(TFileH1);
end.



