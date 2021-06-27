unit HintUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  THintForm = class(TForm)
    Timer: TTimer;
    Text1: TText;
    Rectangle1: TRectangle;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    DoShow: boolean;
    IsShowing: boolean;
    Ticker: integer;
    FShowDuration: integer;
    FHintText: string;
    procedure SetHintText(const Value: string);
    procedure SetShowDuration(const Value: integer);
  public
    { Public declarations }
    procedure DoShowHint;
    procedure DoHideHint;
    property ShowDuration: integer read FShowDuration write SetShowDuration;
    property HintText: string read FHintText write SetHintText;
  end;

var HintForm: THintForm;

implementation

{$R *.fmx}

procedure THintForm.DoHideHint;
begin
    DoShow := False;
    IsShowing := False;
    Hide;
end;

procedure THintForm.DoShowHint;
begin
    DoShow := True;
end;

procedure THintForm.FormCreate(Sender: TObject);
begin
    ShowDuration := 4000;
end;

procedure THintForm.SetHintText(const Value: string);
begin
    if Value <> FHintText then
    begin
        fHintText := Value;
        IsShowing := False;
    end;;
end;

procedure THintForm.SetShowDuration(const Value: integer);
begin
  FShowDuration := Value;
end;

procedure THintForm.TimerTimer(Sender: TObject);
var aWidth, aHeight: single;
begin
    if DoShow and not IsShowing then
    begin
        DoShow := False;
        IsShowing := True;
        Ticker := 0;
        Text1.Text := HintText;

        aWidth := Text1.Canvas.TextWidth(fHintText)*Text1.Canvas.Scale;
        aHeight := Text1.Canvas.TextHeight(fHintText)*Text1.Canvas.Scale;
        Width := Round(aWidth*1.5);
        Height := Round(aHeight*1.5);

        Show;
    end;
    if IsShowing then
    begin
         Inc(Ticker,100);
         if Ticker > ShowDuration then
         begin
             Hide;
             IsShowing := False;
         end;
    end;
end;

end.
