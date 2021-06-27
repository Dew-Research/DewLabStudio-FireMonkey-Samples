unit NoiseGenerator;

interface

Uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Header,
  SignalUtils,
  MtxBaseComp, SignalProcessing, SignalTools, AudioSignal, FMX.ListBox,
  FMX.Edit, FmxMtxComCtrls, FMX.Controls.Presentation;




type
  TNoiseGeneratorForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    F2Edit: TMtxFloatEdit;
    Label8: TLabel;
    FunctionGroup: TPanel;
    ToneGroup: TPanel;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    MtxFloatEdit4: TMtxFloatEdit;
    MtxFloatEdit6: TMtxFloatEdit;
    MtxFloatEdit5: TMtxFloatEdit;
    MtxFloatEdit8: TMtxFloatEdit;
    F2SweepEdit: TMtxFloatEdit;
    F1SweepEdit: TMtxFloatEdit;
    ComboBox1: TComboBox;
    SampleRateEdit: TMtxFloatEdit;
    BitRateEdit: TMtxFloatEdit;
    ChannelEdit: TMtxFloatEdit;
    F3Edit: TMtxFloatEdit;
    F4Edit: TMtxFloatEdit;
    A1Edit: TMtxFloatEdit;
    F1Edit: TMtxFloatEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    StartButton: TButton;
    StopButton: TButton;
    F5Edit: TMtxFloatEdit;
    Label21: TLabel;
    F6Edit: TMtxFloatEdit;
    Label23: TLabel;
    SignalOut: TSignalOut;
    SignalMux: TSignalMux;
    Signal: TSignal;
    A1SweepEdit: TMtxFloatEdit;
    A2SweepEdit: TMtxFloatEdit;
    SignalGenerator: TSignalGenerator;
    SineRadioButton: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    SingleToneRadioButton: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    Label22: TLabel;
    Label24: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure SignalGeneratorAfterUpdate(Sender: TObject);
    procedure F1EditChange(Sender: TObject);
    procedure F2EditChange(Sender: TObject);
    procedure F3EditChange(Sender: TObject);
    procedure F4EditChange(Sender: TObject);
    procedure F5EditChange(Sender: TObject);
    procedure F6EditChange(Sender: TObject);
    procedure A1EditChange(Sender: TObject);
    procedure A1SweepEditChange(Sender: TObject);
    procedure A2SweepEditChange(Sender: TObject);
    procedure F1SweepEditChange(Sender: TObject);
    procedure F2SweepEditChange(Sender: TObject);
    procedure SampleRateEditChange(Sender: TObject);
    procedure SineRadioButtonChange(Sender: TObject);
    procedure SingleToneRadioButtonChange(Sender: TObject);
  private
    { Private declarations }
    FunctionItemIndex: integer;
    SelectionItemIndex: integer;
    procedure UpdateFunctions;
    procedure UpdateSelection;
  public
    { Public declarations }
    PinkState: TFirState;
    SignalIndex: integer;
    FirInitialized: boolean;
  end;

var
  NoiseGeneratorForm: TNoiseGeneratorForm;

implementation

uses MtxExpr, Math387;

{$R *.FMX}
procedure TNoiseGeneratorForm.SampleRateEditChange(Sender: TObject);
begin
    F1Edit.MaxValue := IntToStr(SampleRateEdit.IntPosition div 2);
    F2Edit.MaxValue := IntToStr(SampleRateEdit.IntPosition div 2);
    F3Edit.MaxValue := IntToStr(SampleRateEdit.IntPosition div 2);
    F4Edit.MaxValue := IntToStr(SampleRateEdit.IntPosition div 2);
    F5Edit.MaxValue := IntToStr(SampleRateEdit.IntPosition div 2);
    F6Edit.MaxValue := IntToStr(SampleRateEdit.IntPosition div 2);
end;

procedure TNoiseGeneratorForm.SignalGeneratorAfterUpdate(Sender: TObject);
var Temp: Vector;
begin
     if SignalIndex = 4 then //Pink noise
     begin
          FirFilter(SignalGenerator.Data, Temp, PinkState);
          SignalGenerator.Data.Copy(temp)
     end;
end;

procedure TNoiseGeneratorForm.StartButtonClick(Sender: TObject);
begin
    ComboBox1.Enabled := false;
    SampleRateEdit.Enabled := false;
    BitRateEdit.Enabled := false;
    ChannelEdit.Enabled := false;

    SignalOut.SamplingFrequency := SampleRateEdit.FloatPosition;
    SignalOut.Quantization := BitRateEdit.IntPosition;

    if channelEdit.IntPosition = 0 then
    begin
        SignalMux.Inputs[0].Input := SignalGenerator;
        SignalMux.Inputs[1].Input := Signal;
    end else
    begin
        SignalMux.Inputs[0].Input := Signal;
        SignalMux.Inputs[1].Input := SignalGenerator;
    end;

    SignalOut.BufferSize := SignalOut.RecomendedBufferSize div 2;
    Signal.Length := SignalOut.RecomendedBufferLength div 2;
    SignalGenerator.Size(Signal);

    SignalGenerator.SamplingFrequency := SignalOut.SamplingFrequency;
    Signal.SamplingFrequency := SignalOut.SamplingFrequency;

    Signal.Data.SetZero;

    SignalOut.Start;
end;

procedure TNoiseGeneratorForm.StopButtonClick(Sender: TObject);
begin
    SignalOut.StopAtOnce;

    ComboBox1.Enabled := true;
    SampleRateEdit.Enabled := true;
    BitRateEdit.Enabled := true;
    ChannelEdit.Enabled := true;
end;

procedure TNoiseGeneratorForm.A1EditChange(Sender: TObject);
begin
    try
        if SignalGenerator.Sounds.Template.Count > 1 then //assume mult-channel
        begin
            SignalGenerator.Sounds.Template[0].P3 :=  Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20) / 6;
            SignalGenerator.PartialUpdate(0);
            SignalGenerator.Sounds.Template[1].P3 := SignalGenerator.Sounds.Template[0].P3;
            SignalGenerator.PartialUpdate(1);
            SignalGenerator.Sounds.Template[2].P3 := SignalGenerator.Sounds.Template[0].P3;
            SignalGenerator.PartialUpdate(2);
            SignalGenerator.Sounds.Template[3].P3 := SignalGenerator.Sounds.Template[0].P3;
            SignalGenerator.PartialUpdate(3);
            SignalGenerator.Sounds.Template[4].P3 := SignalGenerator.Sounds.Template[0].P3;
            SignalGenerator.PartialUpdate(4);
            SignalGenerator.Sounds.Template[5].P3 := SignalGenerator.Sounds.Template[0].P3;
            SignalGenerator.PartialUpdate(5);
        end else
        begin
            if SignalGenerator.Sounds.Template[0].Func = funRandUniform then
            begin
                SignalGenerator.Sounds.Template[0].P1 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
                SignalGenerator.Sounds.Template[0].P2 := -SignalGenerator.Sounds.Template[0].P1;
            end else SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);

            SignalGenerator.PartialUpdate(0);
        end;
    except

    end;
end;

procedure TNoiseGeneratorForm.A1SweepEditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)*Exp10(A1SweepEdit.FloatPosition/20);
        SignalGenerator.PartialUpdate(0);
    except

    end;
end;

procedure TNoiseGeneratorForm.A2SweepEditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[0].P6 := Exp2(BitRateEdit.IntPosition-1)*Exp10(A2SweepEdit.FloatPosition/20);
        SignalGenerator.PartialUpdate(0);
    except

    end;
end;

procedure TNoiseGeneratorForm.ComboBox1Change(Sender: TObject);
begin
    SignalOut.WaveDevice := ComboBox1.ItemIndex;
end;

procedure TNoiseGeneratorForm.F1EditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[0].P1 := F1Edit.FloatPosition;
        SignalGenerator.PartialUpdate(0);
    except

    end;
end;

procedure TNoiseGeneratorForm.F1SweepEditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[0].P1 := F1SweepEdit.FloatPosition;
        SignalGenerator.PartialUpdate(0);
    except

    end;
end;

procedure TNoiseGeneratorForm.F2EditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[1].P1 := F2Edit.FloatPosition;
        SignalGenerator.PartialUpdate(1);
    except

    end;
end;

procedure TNoiseGeneratorForm.F2SweepEditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[0].P5 := F2SweepEdit.FloatPosition;
        SignalGenerator.PartialUpdate(0);
    except

    end;
end;

procedure TNoiseGeneratorForm.F3EditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[2].P1 := F3Edit.FloatPosition;
        SignalGenerator.PartialUpdate(2);
    except

    end;
end;

procedure TNoiseGeneratorForm.F4EditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[3].P1 := F4Edit.FloatPosition;
        SignalGenerator.PartialUpdate(3);
    except

    end;
end;

procedure TNoiseGeneratorForm.F5EditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[4].P1 := F5Edit.FloatPosition;
        SignalGenerator.PartialUpdate(4);
    except

    end;
end;

procedure TNoiseGeneratorForm.F6EditChange(Sender: TObject);
begin
    try
        SignalGenerator.Sounds.Template[5].P1 := F6Edit.FloatPosition;
        SignalGenerator.PartialUpdate(5);
    except

    end;
end;

procedure TNoiseGeneratorForm.FormCreate(Sender: TObject);
begin
    AudioSignal.GetOutSoundDevices(ComboBox1.Items);
    SignalGenerator.Sounds.TemplateIndex := 0;

    SignalGenerator.SamplingFrequency := SampleRateEdit.IntPosition;
    UpdateSelection;
    SampleRateEditChange(Sender);
end;


procedure TNoiseGeneratorForm.UpdateFunctions;
var H: Vector;
begin
    case FunctionItemIndex of
    0: UpdateSelection;
    1: begin
       SignalIndex := 1; // square

       SignalGenerator.Sounds.TemplateIndex := SignalIndex;

       SignalGenerator.Sounds.Template[0].P1 := F1Edit.FloatPosition;
       SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
       SignalGenerator.PartialUpdate(0);

       SignalGenerator.Reset;
       end;
    2: begin
       SignalIndex := 2; // triangle
       SignalGenerator.Sounds.TemplateIndex := SignalIndex;

       SignalGenerator.Sounds.Template[0].P1 := F1Edit.FloatPosition;
       SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
       SignalGenerator.PartialUpdate(0);

       SignalGenerator.Reset;
       end;
    3: begin
       SignalIndex := 3; // white
       SignalGenerator.Sounds.TemplateIndex := SignalIndex;

       SignalGenerator.Sounds.Template[0].P1 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
       SignalGenerator.Sounds.Template[0].P2 := -SignalGenerator.Sounds.Template[0].P1;
       SignalGenerator.PartialUpdate(0);

       SignalGenerator.Reset;
       end;
    4: begin
       if FirInitialized then FirFree(PinkState);

       SignalIndex := 4; // pink
       SignalGenerator.Sounds.TemplateIndex := SignalIndex;

       ColoredNoiseFir(H, 10, 0.1, SampleRateEdit.FloatPosition);
       FirInit(H, PinkState);
       FirInitialized := True;

       SignalGenerator.Sounds.Template[0].P1 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
       SignalGenerator.Sounds.Template[0].P2 := -SignalGenerator.Sounds.Template[0].P1;
       SignalGenerator.PartialUpdate(0);

       SignalGenerator.Reset;
       end;
    end;

end;

procedure TNoiseGeneratorForm.UpdateSelection;
begin
    case SelectionItemIndex of
    0: SignalIndex := 0;
    1: SignalIndex := 5;
    2: SignalIndex := 6;
    3: SignalIndex := 6;
    end;

    if SignalGenerator.Sounds.TemplateIndex <> SignalIndex then
    begin
        SignalGenerator.Sounds.TemplateIndex := SignalIndex;
        SignalGenerator.Reset;
    end;

    A1Edit.Enabled := false;

    F1Edit.Enabled := false;
    F2Edit.Enabled := false;
    F3Edit.Enabled := false;

    F4Edit.Enabled := false;
    F5Edit.Enabled := false;
    F6Edit.Enabled := false;

    A1SweepEdit.Enabled := false;
    A2SweepEdit.Enabled := false;

    F1SweepEdit.Enabled := false;
    F2SweepEdit.Enabled := false;

    case SelectionItemIndex of
    0: begin  //single tone
       A1Edit.Enabled := True;
       F1Edit.Enabled := True;
       //The P1, P2, P3... etc are parameters for the tone generator function.
       //See TFuncSignalType and TFuncSignalRecord for more info
       SignalGenerator.Sounds.Template[0].P1 := F1Edit.FloatPosition;
       SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
       SignalGenerator.PartialUpdate(0);
       end;
    1: begin    //multi-tone, different frequencies, same amplitude
       A1Edit.Enabled := true;

       F1Edit.Enabled := true;
       F2Edit.Enabled := true;
       F3Edit.Enabled := true;

       F4Edit.Enabled := true;
       F5Edit.Enabled := true;
       F6Edit.Enabled := true;

       SignalGenerator.Sounds.Template[0].P1 := F1Edit.FloatPosition;

       SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20) / 6;
       SignalGenerator.PartialUpdate(0);
       SignalGenerator.Sounds.Template[1].P3 := SignalGenerator.Sounds.Template[0].P3;
       SignalGenerator.PartialUpdate(1);
       SignalGenerator.Sounds.Template[2].P3 := SignalGenerator.Sounds.Template[0].P3;
       SignalGenerator.PartialUpdate(2);
       SignalGenerator.Sounds.Template[3].P3 := SignalGenerator.Sounds.Template[0].P3;
       SignalGenerator.PartialUpdate(3);
       SignalGenerator.Sounds.Template[4].P3 := SignalGenerator.Sounds.Template[0].P3;
       SignalGenerator.PartialUpdate(4);
       SignalGenerator.Sounds.Template[5].P3 := SignalGenerator.Sounds.Template[0].P3;
       SignalGenerator.PartialUpdate(5);
       end;
    2: begin //Amplitude sweep
       F1Edit.Enabled := true;
       A1SweepEdit.Enabled := true;
       A2SweepEdit.Enabled := true;

       SignalGenerator.Sounds.Template[0].P1 := F1Edit.FloatPosition;
       SignalGenerator.Sounds.Template[0].P5 := SignalGenerator.Sounds.Template[0].P1;

       SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)*Exp10(A1SweepEdit.FloatPosition/20);
       SignalGenerator.Sounds.Template[0].P6 := Exp2(BitRateEdit.IntPosition-1)*Exp10(A2SweepEdit.FloatPosition/20);
       SignalGenerator.PartialUpdate(0);
       end;
    3: begin //Frequency sweep
       A1Edit.Enabled := true;
       F1SweepEdit.Enabled := true;
       F2SweepEdit.Enabled := true;

       SignalGenerator.Sounds.Template[0].P1 := F1SweepEdit.FloatPosition;
       SignalGenerator.Sounds.Template[0].P5 := F2SweepEdit.FloatPosition;

       SignalGenerator.Sounds.Template[0].P3 := Exp2(BitRateEdit.IntPosition-1)* Exp10(A1Edit.FloatPosition/20);
       SignalGenerator.Sounds.Template[0].P6 := SignalGenerator.Sounds.Template[0].P3;

       SignalGenerator.PartialUpdate(0);
       end;
    end;

end;


procedure TNoiseGeneratorForm.SineRadioButtonChange(Sender: TObject);
begin
    if Sender = SineRadioButton then FunctionItemIndex := 0;
    if Sender = RadioButton2 then FunctionItemIndex := 1;
    if Sender = RadioButton3 then FunctionItemIndex := 2;
    if Sender = RadioButton4 then FunctionItemIndex := 3;
    if Sender = RadioButton9 then FunctionItemIndex := 4;

    UpdateFunctions;
end;

procedure TNoiseGeneratorForm.SingleToneRadioButtonChange(Sender: TObject);
begin
    if Sender = SingleToneRadioButton then SelectionItemIndex := 0;
    if Sender = RadioButton6 then SelectionItemIndex := 1;
    if Sender = RadioButton7 then SelectionItemIndex := 2;
    if Sender = RadioButton8 then SelectionItemIndex := 3;

    UpdateSelection;
end;

initialization
      RegisterClass(TNoiseGeneratorForm);

end.
