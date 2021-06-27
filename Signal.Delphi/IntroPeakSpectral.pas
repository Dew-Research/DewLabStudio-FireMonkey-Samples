unit IntroPeakSpectral;

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
  Basic3, FMX.Layouts, FMX.Memo;

type
  TIntroPeakSpectralForm = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroPeakSpectralForm: TIntroPeakSpectralForm;

implementation

{$R *.FMX}

procedure TIntroPeakSpectralForm.FormCreate(Sender: TObject);
begin
  inherited;
  With RichEdit1.Lines, RichEdit1 do
  begin
    Clear;
    Add('   Frequency spectrum peak analysis:');
    Add('');


    Add('   *   6 methods for frequency and amplitude interpolation: '+
        'Numeric, Quadratic, Barycentric, Quinn''s First, Quinn''s second, Jain''s');
    Add('   *   Auto find peaks in the frequency spectrum: largest, harmonics or retrace existing');
    Add('   *   Add and delete peak marks on the fly with a dedicated TeeTool');
    Add('   *   Peak order tracking');
    Add('   *   Limit search for peaks within a frequency band');
    Add('   *   Link RMS calculation of frequency bands to peak position');
    
    
  end;
end;

initialization
   RegisterClass(TIntroPeakSpectralForm);


end.
