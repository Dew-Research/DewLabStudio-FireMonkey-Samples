unit Basic_Wizard;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Forms,
  Fmx.StdCtrls,
  FMX.Memo,
  FMX.Header, FMX.TabControl, FMX.Controls, FMX.Types, FMX.Controls.Presentation;


type
  TfrmBasicWizard = class(TForm)
    Panel1: TPanel;
    btnHelp: TButton;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    lblHeader: TLabel;
    PageControl: TTabControl;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    DefTabWidth : Integer;
    FFormatString: string;
    procedure SetFormatString(const Value: string);
  protected
    moveback: boolean;
    moveforward: boolean;
    chartindex: Integer;
    procedure RefreshWizardControls; virtual;
    procedure DoMoveForward; virtual;
    procedure DoMoveBack; virtual;
  public
    { Public declarations }
    procedure SetupTabs(Const NumTabs: Integer; RichEdit: TMemo);
    property FormatString: string read FFormatString write SetFormatString;
  end;

var
  frmBasicWizard: TfrmBasicWizard;

implementation

Uses Math387;

{$R *.FMX}

procedure TfrmBasicWizard.btnCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmBasicWizard.SetupTabs(const NumTabs: Integer;
  RichEdit: TMemo);
//var i : Integer;
begin
//   Not available for TMemo

//  RichEdit.Paragraph.Tab[0] := 0;
//  for i := 1 to RichEdit.Paragraph.TabCount - 1 do
//    RichEdit.Paragraph.Tab[i] := RichEdit.Paragraph.Tab[i-1]+DefTabWidth;
end;

procedure TfrmBasicWizard.SetFormatString(const Value: string);
begin
  FFormatString := Value;
end;

procedure TfrmBasicWizard.FormCreate(Sender: TObject);
begin
  FFormatString := '0.0000';
  moveback := true;
  moveforward := true;

//  RefreshWizardControls;

//  DefTabWidth := Max(60,Canvas.TextWidth('+'+FormatString)+10); //No tabs for TMemo
end;

procedure TfrmBasicWizard.btnNextClick(Sender: TObject);
begin
  DoMoveForward;
  RefreshWizardControls;
end;

procedure TfrmBasicWizard.btnBackClick(Sender: TObject);
begin
  DoMoveBack;
  RefreshWizardControls;
end;

// Refresh wizard controls
procedure TfrmBasicWizard.RefreshWizardControls;
begin
  btnBack.Enabled := PageControl.TabIndex > 0;
  btnNext.Enabled := PageControl.TabIndex < (PageControl.TabCount - 1);
  lblHeader.Text := PageControl.ActiveTab.Text;
end;

// Called when Back button is clicked
procedure TfrmBasicWizard.DoMoveBack;
var index: Integer;
begin
  index := PageControl.TabIndex;
  if (index>0) and (moveback) then
  begin
    Dec(index);
    PageControl.TabIndex := index;
  end;
end;

// Called when Next button is clicked
procedure TfrmBasicWizard.DoMoveForward;
var index: Integer;
begin
  index := PageControl.TabIndex;
  if (index < PageControl.TabCount) and (moveforward) then
  begin
    Inc(index);
    PageControl.TabIndex := index;
  end;
end;

end.
