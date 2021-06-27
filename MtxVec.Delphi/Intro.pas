unit Intro;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Forms,
  FMX.Header, FMX.Controls, FMX.Objects, FMX.Layouts, FMX.Memo, FMX.Types,
  FMX.ScrollBox, FMX.Controls.Presentation;

type
  TIntroduction = class(TForm)
    RichEdit1: TMemo;
    Label1: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Introduction: TIntroduction;

implementation

uses Math387;

{$R *.FMX}

procedure TIntroduction.FormCreate(Sender: TObject);
begin
  Label1.Text := 'Welcome to MtxVec v' + FormatSample('0.0',MtxVecVersion/100);
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('Welcome to MtxVec, an object oriented threaded and vectorized numerical library '
      + 'for Delphi, FireMonkey and .NET platform');
    Add('');
    Add('');
    Add('MtxVec adds the following capabilities to your development environment:');
    Add('');
    Add('   *    Comprehensive set of mathematical and statistical functions');
    Add('   *    Support for run-time selection of computational precision (32bit or 64bit floating point).');
    Add('   *    Substantial performance improvements of floating point math by exploiting the SSE4.x and AVX/AVX2/AVX512 instruction sets.');
    Add('   *    Support for 32/64bit applications.');
    Add('   *    Certified support for 4GB address range on 64bit OS for 32bit applications.');
    Add('   *    Function calls mapped to Accelerator pack on Apple devices.');
    Add('   *    Open CL support allows high performance cross platform portable code and gives you access to the power of GPUs.');
    Add('   *    Improved compactness and readability of code.');
    Add('   *    Significantly shorter development times by protecting the developer from a wide range of possible errors.');
    Add('   *    Same API interface in Delphi for W32/W64, FireMonkey on iOS 64bit, OS X 64bit, Android 32/64bit, Linux and also on .NET');
    Add('');
    Add('Typical performance improvements observed by most users are 4-6 times for ' +
        'vector functions, but speed ups up to 20 times are not rare. The matrix ' +
        'multiplication for example is faster up to 50 times.');
    Add('');
    Add('Navigate through the demo application, to learn more about MtxVec and experience it''s unmatched '
        + 'performance and ease of use.');
  end;
end;

initialization
  RegisterClass(TIntroduction);
end.
