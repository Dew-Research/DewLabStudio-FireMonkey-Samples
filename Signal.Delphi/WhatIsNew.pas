unit WhatIsNew;

interface

uses

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  Fmx.StdCtrls,
  FMX.Header,
  Basic3, FMX.Layouts, FMX.Memo, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo.Types;


type
  TWhatIsNewForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WhatIsNewForm: TWhatIsNewForm;

implementation

{$R *.FMX}

procedure TWhatIsNewForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;

    Add('');
    Add('   New features in version v6.0:');
    Add('');
    Add('');
    Add('   *   Support for RAD Studio 10.4 Sydney');
    Add('   *   TSignalCoreAudioIn/TSignalCoreAudioOut has been upgraded to support iOS and Android ' +
        'next to Windows OS. The use of the same component on both Windows and mobile platforms greatly simplifies development of audio recording/playback applications for mobile devices.');
    Add('   *   On iOS/macOS the audio uses the low level RemoteIO interface.');
    Add('   *   Performance enhancements due to support for Apple Accelerate framework on iOS and macOS.');
    Add('   *   Fix for TSignalCoreAudioIn/TSignalCoreAudioOut for 24bit Exclusive mode.');
    Add('   *   Fix for TSignalCoreAudioIn OnBufferReady call frequency. Now it triggers as soon as there are InputDataLength samples buffered.');
    Add('   *   Fix for detecting 24 bit recording/playback where WASAPI did not work without having dwChannelMask set to 3.');
    Add('   *   Added TSignalCoreAudio.TVolumeControl property.');
    Add('   *   Added TSignalCoreAudio.Volume property.');
    Add('   *   Added TSignalCoreAudio.LoopbackOutputDevices property and support for recording of playback streams.');
    Add('   *   Added TSignalCoreAudio.Thread Priority boost via Multimedia Class Scheduler Service');
    Add('   *   TSignalBuffer.StrideLength fix. Now TSignalBuffer allows arbitrary input vector length and output vector length '
      + 'and arbitray stride.');
    Add('   *   Modified TSpectrogram.Logarithmic behaviour.');
    Add('   *   Performance improvements for TSpectrogram.');
    Add('   *   TSignalAsio enhanced for compatibility.');

    Add('');
    Add('   New features in version v5.1:');
    Add('');
    Add('');
    Add('   *   Fixed a bug in CplxCepstrum and PhaseUnwrap routines.');
    Add('   *   Fixed a bug in Remez filter design, where the Grid size came to be too small for the specs.');
    Add('   *   Updated to Intel IPP v9 from v8. Some API changes were required also.');
    Add('   *   Cross platform support for FireMonkey on iOS, OS X and Android.');
    Add('   *   Support for RAD Studio 10.1 Berlin.');

    Add('');
    Add('   New features in version v5.02:');
    Add('');
    Add('');
    Add('   *   Fixed a bug with DC and Notch filter in TSignalFilter.');
    Add('   *   Update to DSP demo for FireMonkey to run also on Android tablets. (Currently there is still no support for Playback/Recording on Android).');
    Add('   *   Support for RAD Studio 10 Berlin.');


    Add('');
    Add('   New features in version v4.4:');
    Add('');
    Add('');
    Add('   *   Support for FireMonkey on Windows.');
    Add('   *   Added new overloads for ButterFilter, ChebyshevIFilter, CheybhsevIIFilter and EllipticFilter which can now return filter also in SOS format.');
    Add('   *   Fixed a bug in ZeroPoleToSOS function.');

    Add('');
    Add('   New features in version v4.3:');
    Add('');
    Add('');
    Add('   *   Support for FireMonkey on Windows.');
    Add('   *   Added new overloads for ButterFilter, ChebyshevIFilter, CheybhsevIIFilter and EllipticFilter which can now return filter also in SOS format.');
    Add('   *   Fixed a bug for ASIO driver, where data storage is 32bit, but usable bits were less.');
    Add('   *   Fixed a bug TSignalIn/TSignalOut where ChannelCount was 1.');
    Add('   *   TeeChart features updated for GDI+ support.');
    Add('   *   Support for 64bit C++Builder.');
    Add('   *   Improvements and adjustments for TSignalAsioAudio.');

    Add('');
    Add('   New features in version v4.1:');
    Add('');
    Add('');

    Add('   *   IIR Filtering based on second order sections now allows filtering with much more extreem filter designs and stability up to order of 50.');
    Add('   *   New functions SignalUtils.IirInitBQ and LinearSystems.ZeroPoleToSOS.');
    Add('   *   TSignalFilter has been updated to make use second order sections for IIR filtering.');
    Add('   *   New TSignalPolarSeries works with cartesian coordinates and is up to 50x faster than TPolarSeries.');
    Add('   *   Support for Delphi XE2 compilers in both 32bit and 64bit variants.');
    Add('   *   Updated for TeeChart 2011.');


    Add('');
    Add('');

    Add('   New features in version v4.0:');

    Add('');
    Add('');

    Add('   *   ASIO driver components.');
    Add('   *   Kalman filtering implementation.');
    Add('   *   Added pink, gray and violate noise generators.');
    Add('   *   Fixed bug for triangular noise generator.');
    Add('   *   Added new inverse FFT based FIR filter designer.');
    Add('   *   Support for TeeChart 2010.');
    Add('   *   Support for Intel AVX instructions via MtxVec.');
    Add('   *   New stand alone alternative native Delphi code for signal processing without Intel SPL.');


    Add('');
    Add('');

    Add('New features in version v3.52:');

    Add('');
    Add('');

    Add('   *   Support for Delphi 2010 and C++Builder 2010.');
    Add('   *   Reworked peak ratios calcuation for TSpectrumAnalyzer.');
    Add('   *   Fixes with relation to phase calculation for TSpectrumAnalyzer.');
    Add('   *   Spectrogram calculation example added to demo.');
    Add('   *   Various small improvements and tweaks.');

    Add('');
    Add('');

    Add('New features in version v3.5:');

    Add('');
    Add('');

    Add('   *   Updated to support Delphi 2009 and C++Builder 2009.');
    Add('   *   HtmlHelp 2 format support improved.');
    Add('   *   Support for Intel IPP v6.');
    Add('   *   Multithreading support added to many functions. Most notably FIR filtering functions!');
    Add('   *   TSignalHighLowSeries has many new features.');
    Add('   *   Several new components for rate conversion and modulation.');
    Add('   *   Enhanced TSignalModulator and TSignalDemodulator.');
    Add('   *   Bug fixes for TSignalRead and TSignalWrite.');
    Add('   *   Faster Goertzal algorithm used for single line DFT.');
    Add('   *   Much faster peak interpolation.');


    Add('');
    Add('');

    Add('New features in version v3:');

    Add('');
    Add('');

    Add('   *   Updated to support Delphi 2007 and C++Builder 2007.');
    Add('   *   Support for TeeChart 8.');
    Add('   *   Support for update Intel IPP v5.2 and consequently Core 2 Duo optimized.');
    Add('   *   HtmlHelp 2 format support added. Now F1 finally works again from code and ' +
        'components in D2007.');
    Add('   *   All code examples now also have C++ examples.');
    Add('   *   All code examples in the help have been recreated with support for Vector/Matrix expressions.');
    Add('   *   Demo updated with Vector/Matrix syntax.');
    Add('   *   New C++Builder translation of the DSP Master demo.');
    Add('   *   New set (hundreds) of true color 24x24 and 16x16 icons for components to support ' +
        'newer IDE tool palette.');
    Add('   *   Many minor enhancements and bug fixes.'); ;


    Add('');
    Add('');

    Add('New features in version 2.1:');

    Add('');
    Add('');


    Add('   *   Superfast arbitrary factor rate converter component.');
    Add('   *   TSignalBuffer component had some bugs fixed.');
    Add('   *   TSignal.Pull methods are completely rewritten. It is now possible to build much more complex processing pipes with much less code.');
    Add('   *   Fixed a bug in Complex Cepstrum, which occured during transition to .NET');
    Add('   *   TSignalChart and TSpectrumChart now accept multiple inputs. Same component ' +
        'can be connected to the same chart more than once or to multiple charts at the ' +
        'same time with centralized redraw control.');
    Add('   *   TSignalRead.RecordPositon now calls TSignal.Update.');
    Add('   *   Fixed a bug with TSignalIn for mono signal recordings.');
    Add('   *   Fixed onStart and OnStop events for the TSignalIn and TSignalOut.');
    Add('   *   Fixed the Report generation for TSpectrumAnalyzer and others. Report interface has also changed to support .NET.');
    Add('   *   Fixed Logarithmic property for TSpectrumAnalyzer. It is now possible ' +
        'to toggle between logarithmic and linear scale for averaged spectrums.' +
        'without the need to perform the averaging again.');
    Add('   *   Fixed a bug for TSignalGeneratorDialog where it did not store the changes made.');
    Add('   *   TAnalysisList now has a Continuous property.');
    Add('   *   Reset method has been added to all filtering components, and allows ' +
        'delay lines to be reset to zero.');

    Add('');
    Add('');

    Add('New features in version 2.0:');

    Add('');
    Add('');

    Add('   *   Arbitrary FFT length for 1D and 2D transforms.');
    Add('   *   Support for SSE3 instruction set.');
    Add('   *   Intel SPL interface replaced with support for IPP library.');
    Add('   *   Substantial increase in number of optimized primitive functions and methods via MtxVec v2.');
    Add('   *   Many new "multi-channel" list components.');
    Add('   *   Improved TSignalFile with several new properties.');
    Add('   *   Support for .NET');
    Add('   *   New TSignalStoreBuffer component.');
    Add('   *   New TSignalEnvelopeDetector component.');
    Add('   *   New connection mechanism for TSpectrumChart and TSignalChart.');
    Add('   *   TSignalRead component editor.');
    Add('   *   Minor bug fixes.');
    Add('   *   Improved piping mechanism for data streaming.');
    Add('   *   Substantially improved range checking and programmer safety.');


    Add('');
    Add('');
  end;
end;

initialization
   RegisterClass(TWhatIsNewForm);


end.
