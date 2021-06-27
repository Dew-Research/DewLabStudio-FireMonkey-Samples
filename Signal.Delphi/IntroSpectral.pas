unit IntroSpectral;

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

  Basic3;



//**   Original VCL Uses section : 


//**   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//**   Basic3, StdCtrls, ComCtrls;


type
  TIntroSpectralForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroSpectralForm: TIntroSpectralForm;

implementation

{$R *.FMX}

procedure TIntroSpectralForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('');
    Add('   Frequency spectrum analysis features:');
    Add('');
    Add('');
    Add('   *   Very fast FFT for real and complex signals');
    Add('   *   Chirp-Z Transform for high speed frequency zoom-in');
    Add('   *   4 autoregressive methods for spectral estimation: Yulle-Walker, Burg, Covariance and Modified covariance');
    Add('   *   10 different time signal windows: Hanning, Hamming, FlatTop, Bartlet, Blackman, BlackmanHarris, BlackmanExact, '+
        'Cosine-tappered, Kaiser, Chebyshev and  Exponential');
    Add('   *   THD, THD-N, SNR, NF, RMS, SFDR spectral statistics');
    Add('   *   Integration and differentiation in the frequency domain');
    Add('   *   Amplitude, power, peak-peak and RMS spectrums.');
    Add('   *   Real and complex cepstrum.');
  end;
end;

initialization
   RegisterClass(TIntroSpectralForm);


end.
