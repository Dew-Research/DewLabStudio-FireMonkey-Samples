unit ExprToolTipUnit;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.DateUtils,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Graphics,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Forms,
  FmxMtxGrid,
  MtxVec, MtxVecInt, MtxVecBase;


type
  TExprToolTipForm = class(TForm)
    MtxVecGrid: TMtxVecGrid;
  private
    bName: string;
    mark: TDateTime;
  protected
//    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    { Private declarations }
  public
    procedure UpdateGrid(const Src: TMtxVecBase; const aName: string);
    { Public declarations }
  end;

var
  ExprToolTipForm: TExprToolTipForm;

implementation

{$R *.FMX}

procedure TExprToolTipForm.UpdateGrid(const Src: TMtxVecBase; const aName: string);
begin
    if aName = bName then
    begin
        if (Now - Mark) > (0.25*OneSecond) then
        begin
            case src.MtxVecType of
            mvTVec: Caption := 'Vector ' + aName;
            mvTMtx: Caption := 'Matrix ' + aName;
            mvTVecInt: Caption := 'Integer vector ' + aName;
            mvTMtxInt: Caption := 'Integer matrix ' + aName;
            end;

            MtxVecGrid.Datasource := Src;
            MtxVecGrid.UpdateDimensions;
            Show;
            Mark := Now;
        end;
    end else
    begin
        Mark := Now;
        bName := aName;
    end;
end;

//procedure TExprToolTipForm.WMNCHitTest(var Message: TWMNCHitTest);
//const EDGEDETECT = 7; // adjust
//var deltaRect: TRect;
//begin
//  inherited;
//  if BorderStyle = bsNone then
//    with Message, deltaRect do
//    begin
//      Left := XPos - BoundsRect.Left;
//      Right := BoundsRect.Right - XPos;
//      Top := YPos - BoundsRect.Top;
//      Bottom := BoundsRect.Bottom - YPos;
//      if (Top < EDGEDETECT) and (Left < EDGEDETECT) then
//        Result := HTTOPLEFT
//      else if (Top < EDGEDETECT) and (Right < EDGEDETECT) then
//        Result := HTTOPRIGHT
//      else if (Bottom < EDGEDETECT) and (Left < EDGEDETECT) then
//        Result := HTBOTTOMLEFT
//      else if (Bottom < EDGEDETECT) and (Right < EDGEDETECT) then
//        Result := HTBOTTOMRIGHT
//      else if (Top < EDGEDETECT) then
//        Result := HTTOP
//      else if (Left < EDGEDETECT) then
//        Result := HTLEFT
//      else if (Bottom < EDGEDETECT) then
//        Result := HTBOTTOM
//      else if (Right < EDGEDETECT) then
//        Result := HTRIGHT
//    end;
//end;

end.
