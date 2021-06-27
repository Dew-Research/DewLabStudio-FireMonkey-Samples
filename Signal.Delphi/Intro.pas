unit Intro;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Layouts,
  FMX.Memo, FMX.Memo.Types, FMX.ScrollBox, FMX.Controls.Presentation;


type
  TIntroduction = class(TForm)
    RichEdit1: TMemo;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Introduction: TIntroduction;

implementation

{$R *.FMX}

procedure TIntroduction.FormCreate(Sender: TObject);
begin
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('Welcome to DSP Master');
    Add('');

    Add('   *   Written entirely with MtxVec and taking advantage  '
      + 'of full vector/matrix design.');
    Add('   *   Supports signal processing algorithms in streaming '
      + 'or single block mode.');
    Add('   *   Features a large set of ready to use components '
      + 'covering digital filter design and frequency analysis.');
    Add('   *   Visually connect signal processing components to form ' +
        'signal processing pipes capable of streaming. ' );
    Add('   *   Supports multichannel, aribtrary sampling frequency, '+
        'complex or real, double or single precision, signal processing.');

    Add('');

    Add('"MtxVec was created to help shorten the development time of commercial scientific applications."');
    Add('');
    Add('Navigate through the demo application, to learn more about DSP Master.');
  end;
end;

initialization
  RegisterClass(TIntroduction);
end.
