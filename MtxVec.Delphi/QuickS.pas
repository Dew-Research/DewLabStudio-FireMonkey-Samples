unit QuickS;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo;


type
  TQStart = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QStart: TQStart;

implementation

uses MtxExpr, MtxVec;

{$R *.FMX}

procedure TQStart.FormCreate(Sender: TObject);
var St: String;
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('');
    Add('   Quick start: Computing a frequency spectrum.');
    Add('   Using MtxVec routines is a peace of cake. Now you can perform complex numeric tasks with only few function calls:');
    Add('');
    Add('');
    Add('   1.) Start a new project.');
    Add('   2.)Place one TChart component ("Additional" panel) on the panel and one Button ("Standard" panel)');
    Add('   3.)Double click on the TChart component and click the Add button and the select the Fast Line seires. Press Close;');
    Add('   4.)Move cursor to the top of the unit and add MtxExpr and MtxVecTee to the uses clause.');
    Add('   5.)Double click the Button.');
    Add('   6.)Insert the following code:');
    Add('');
    St := 'procedure TForm1.Button1Click(Sender: TObject);'+#13
      +'var y,x,spec: Vector;'+#13+'begin'+#13
      +'  { Please include the full path of the file.}'+#13
      +'  { The file is included with the MtxVec BasicDemo }'+#13
      +'  { distribution and has 8000 values only. }'+#13
      +'  y.LoadFromFile(''C:\MtxVecDemo\FFTData.vec'');'+#13
      +'  y.Resize(1024);'+#13+'  x.FFT(y);'+#13
      +'  spec.Mag(x);'+#13+'  DrawValues(spec,Series1);'+#13
      +'end;';
    Add(st);
    Add('');
    Add('   7.)F9 to compile and press Button1.');
    Add('   8.)should be looking at the frequency spectra displaying one series of harmonics.');
    Add('');
    Add('   Things to try:');
    Add('');
    Add('   *   Change the 1024 value to some other values that are power of two. (512 or 2048).');
    Add('   *   Use TAreaSeries chart series.');
    Add('   *   Make the spectra logarithmic in the amplitude (use the Log10 method).');
    Add('   *   Save spectra to a file, then load it and draw to the chart with DrawValues.');
    Add('   *   Replace DrawValues(spec,Series1) with ViewValues(spec) and then try ViewValues(x). Play with the menu options in the displayed form.');
    Add('');
  end;
end;

initialization
   RegisterClass(TQStart);

end.
