unit UClone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, BasicMapObjects, MapEditor, ExtCtrls, Buttons, Math,
  FloatSpinEdit;

type

  TMyPixelDescriptor = record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
  end;
 
  PMyPixelArray = ^TMyPixelArray;
  { use an array of 32768 pixels if you want to make sure
    you'll be able to use extra large images sometime in the future }
  TMyPixelArray = array[0..32767] of TMyPixelDescriptor;

  TCloneFm = class(TForm)
    ECount: TSpinEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    EShift_: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    EDeg_: TSpinEdit;
    Label05: TLabel;
    Image1: TImage;
    Image2: TImage;
    Bevel1: TBevel;
    NameEdit: TEdit;
    Label6: TLabel;
    AddN: TCheckBox;
    Nfrom: TSpinEdit;
    Label7: TLabel;
    NStep: TSpinEdit;
    Label8: TLabel;
    NameSep: TEdit;
    Label9: TLabel;
    DoShiftR: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure EDeg_Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ECountChange(Sender: TObject);
    procedure AddNClick(Sender: TObject);
    procedure DoShiftRClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CloneRouteNum: Integer;
  end;

var
  CloneFm: TCloneFm;
  EDeg, EShift: TFloatSpinEdit;
implementation

uses MapperFm;

{$R *.dfm}

type
  PixelArray=array [0..32768] of TRGBTriple;
  pPixelArray=^PixelArray;
var
  b: TBitmap;


procedure RotateBitmap_ads(SourceBitmap: TBitmap;
          out DestBitmap: TBitmap; Center: TPoint; Angle: Double);
var
  cosRadians : Double;
  inX : Integer;
  inXOriginal : Integer;
  inXPrime : Integer;
  inXPrimeRotated : Integer;
  inY : Integer;
  inYOriginal : Integer;
  inYPrime : Integer;
  inYPrimeRotated : Integer;
  OriginalRow : pPixelArray;
  Radians : Double;
  RotatedRow : pPixelArray;
  sinRadians : Double;
begin
  DestBitmap.Width := SourceBitmap.Width;
  DestBitmap.Height := SourceBitmap.Height;
  DestBitmap.PixelFormat := pf24bit;
  Radians := -(Angle) * PI / 180;
  sinRadians := Sin(Radians);
  cosRadians := Cos(Radians);
  for inX := DestBitmap.Height-1 downto 0 do
  begin
    RotatedRow := DestBitmap.Scanline[inX];
    inXPrime := 2*(inX - Center.y) + 1;
    for inY := DestBitmap.Width-1 downto 0 do
    begin
      inYPrime := 2*(inY - Center.x) + 1;
      inYPrimeRotated := Round(inYPrime * CosRadians - inXPrime * sinRadians);
      inXPrimeRotated := Round(inYPrime * sinRadians + inXPrime * cosRadians);
      inYOriginal := (inYPrimeRotated - 1) div 2 + Center.x;
      inXOriginal := (inXPrimeRotated - 1) div 2 + Center.y;
      if (inYOriginal >= 0) and (inYOriginal <= SourceBitmap.Width-1) and
      (inXOriginal >= 0) and (inXOriginal <= SourceBitmap.Height-1) then
      begin
        OriginalRow := SourceBitmap.Scanline[inXOriginal];
        RotatedRow[inY] := OriginalRow[inYOriginal];
      end
      else
      begin
        RotatedRow[inY].rgbtBlue := 0;
        RotatedRow[inY].rgbtGreen := 0;
        RotatedRow[inY].rgbtRed := 0
      end;
    end;
  end;
end;

procedure TCloneFm.AddNClick(Sender: TObject);
begin
  Label7.Enabled := AddN.Checked;
  Label8.Enabled := AddN.Checked;
  Label9.Enabled := AddN.Checked;
  NFrom.Enabled :=  AddN.Checked;
  NStep.Enabled :=  AddN.Checked;
  NameSep.Enabled :=  AddN.Checked;
end;

procedure TCloneFm.Button1Click(Sender: TObject);
var DS: String;
    Sh: Double;
begin
  Sh := 0;
  if DoShiftR.Checked then
     Sh := EShift.Value;
  DS := '';
  if AddN.Checked then
     DS := NameSep.Text;
  CopyRoute(CloneRouteNum, Ecount.Value, Sh, EDeg.Value,
            NameEdit.Text + DS, AddN.Checked, NFrom.Value, Nstep.Value);

  MapFm.SaveCtrlZ;
  close;
end;

procedure TCloneFm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TCloneFm.DoShiftRClick(Sender: TObject);
begin
  Label3.Enabled := DoShiftR.Checked;
  Label4.Enabled := DoShiftR.Checked;
  Label05.Enabled := DoShiftR.Checked;
  EDeg.Enabled   := DoShiftR.Checked;
  EShift.Enabled := DoShiftR.Checked;
end;

procedure TCloneFm.ECountChange(Sender: TObject);
begin
  AddN.Enabled := ECount.Value = 1;
  if AddN.Enabled = false then
      AddN.Checked := True;
  AddN.OnClick(nil);    
end;

procedure TCloneFm.EDeg_Change(Sender: TObject);
var P: TPoint;

begin
   if (EDeg.Text = '')or(EDeg.Text = '-') then
      exit;

   try

   if EDeg.Value <= -361 then
      Edeg.Value := 0;
   if EDeg.Value >= 361 then
      Edeg.Value := 0;
   P.X := Image1.Width div 2;
   P.Y := Image1.Height div 2;

   RotateBitmap_ads(Image1.Picture.Bitmap, b, P, EDeg.Value);
   Image2.Picture.Bitmap := B;

   except
   end;
end;

procedure TCloneFm.FormCreate(Sender: TObject);
begin
 B := TBitMap.Create;
 B.Height := 64;
 B.Width  := 64;

 Edeg   := TFloatSpinEdit.Create(CloneFm);
 EShift := TFloatSpinEdit.Create(CloneFm);

 Edeg.Parent  := Edeg_.Parent;
 Edeg.OnClick := Edeg_.OnClick;
 Edeg.OnChange := Edeg_.OnChange;
 Edeg.Left := Edeg_.Left;
 Edeg.Top := Edeg_.Top;
 Edeg.Width := Edeg_.Width;
 Edeg.Height := Edeg_.Height;
 Edeg.Value := Edeg_.Value;
 Edeg.MinValue := Edeg_.MinValue;
 Edeg.MaxValue := Edeg_.MaxValue;
 Edeg.Increment := Edeg_.Increment;
 Edeg_.Hide;

 EShift.Parent  := EShift_.Parent;
 EShift.OnClick := EShift_.OnClick;
 EShift.OnChange := EShift_.OnChange;
 EShift.Left := EShift_.Left;
 EShift.Top := EShift_.Top;
 EShift.Width := EShift_.Width;
 EShift.Height := EShift_.Height;
 EShift.Value := EShift_.Value;
 EShift.MinValue := EShift_.MinValue;
 EShift.MaxValue := EShift_.MaxValue;
 EShift.Increment := EShift_.Increment;
 EShift_.Hide;

end;

procedure TCloneFm.FormDestroy(Sender: TObject);
begin
  B.Free;
  EShift.Destroy;
  EDeg.Destroy;
end;

procedure TCloneFm.SpeedButton1Click(Sender: TObject);
var A:Double;
begin

try
  A :=  Arctan2( Route[CloneRouteNum].x2 - Route[CloneRouteNum].x1,
                 Route[CloneRouteNum].y2 - Route[CloneRouteNum].y1) - pi/2;
  if A < 0 then
    A := A+ 2*pi;
  if A > 2*pi then
    A := A - 2*pi;
except
end;
  EDeg.Value := Round(1000*A*180/pi)/1000;
end;

procedure TCloneFm.SpeedButton2Click(Sender: TObject);
var A:Double;
begin
try
  A :=  Arctan2( Route[CloneRouteNum].x1 - Route[CloneRouteNum].x2,
                 Route[CloneRouteNum].y1 - Route[CloneRouteNum].y2) - pi/2;
  if A < 0 then
    A := A+ 2*pi;
  if A > 2*pi then
    A := A - 2*pi;
except
end;
  EDeg.Value := Round(1000*A*180/pi)/1000;
end;

end.
