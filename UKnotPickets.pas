unit UKnotPickets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MapFunctionsC, LangLoader, Spin, ParUnit1, jpeg,
  ComCtrls, MapEditor, BasicMapObjects, Buttons, Math, Menus, GeoString,
  FloatSpinEdit, PointClasses;


type

  TRGBTripleArray = array[0..1000] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;

  TFKnotPickets = class(TForm)
    Img: TImage;
    Timer1: TTimer;
    Panel1: TPanel;
    MainPC: TPageControl;
    MainP: TTabSheet;
    Label4: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label13: TLabel;
    PktMethod: TComboBox;
    PktPages: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    l1_: TSpinEdit;
    Rdrop: TCheckBox;
    RouteBox: TComboBox;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    l2x_: TSpinEdit;
    l2y_: TSpinEdit;
    Drop2: TCheckBox;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    Label8: TLabel;
    l3_: TSpinEdit;
    a3_: TSpinEdit;
    DoRang: TRadioButton;
    DontRang: TRadioButton;
    TabSheet6: TTabSheet;
    Label11: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    l4x_: TSpinEdit;
    l4y_: TSpinEdit;
    a4: TSpinEdit;
    T7: TTabSheet;
    Label15: TLabel;
    EditTemplate: TSpeedButton;
    Label16: TLabel;
    PktTemplates: TComboBox;
    Scale5_: TSpinEdit;
    a5_: TSpinEdit;
    Drop5: TCheckBox;
    Lmax_: TSpinEdit;
    GroupBox2: TGroupBox;
    Knex: TLabel;
    Knk: TComboBox;
    Knk2: TComboBox;
    Button2: TButton;
    Button1: TButton;
    GroupBox1: TGroupBox;
    KnotLabel: TLabel;
    lk: TSpeedButton;
    KnotSize_: TSpinEdit;
    PG: TPageControl;
    TabSheet4: TTabSheet;
    Label9: TLabel;
    Label14: TLabel;
    SetKnAng_: TSpinEdit;
    SetRtAng_: TSpinEdit;
    TabSheet5: TTabSheet;
    Label20: TLabel;
    KnotAngRoute: TRadioButton;
    KnotAngOwn: TRadioButton;
    KnotAngAdd: TCheckBox;
    KnotAng_: TSpinEdit;
    EditorP: TTabSheet;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    PktBox: TListBox;
    Label17: TLabel;
    CoordPC: TPageControl;
    T10: TTabSheet;
    T11: TTabSheet;
    isSq: TRadioButton;
    isPol: TRadioButton;
    Label18: TLabel;
    pL_: TSpinEdit;
    Label19: TLabel;
    pA_: TSpinEdit;
    px_: TSpinEdit;
    Label21: TLabel;
    py_: TSpinEdit;
    Label22: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BAdd: TSpeedButton;
    bUp: TSpeedButton;
    BDel: TSpeedButton;
    bDown: TSpeedButton;
    TmpBox: TComboBox;
    Label23: TLabel;
    Label24: TLabel;
    Button6: TButton;
    Pop: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    bSort: TSpeedButton;
    Panel2: TPanel;
    snames: TSpeedButton;
    snames2: TSpeedButton;
    Pop2: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N7: TMenuItem;
    Panel3: TPanel;
    bApply: TSpeedButton;
    bCenter: TSpeedButton;
    bCancel: TSpeedButton;
    IHalf: TCheckBox;
    KnotSize2_: TSpinEdit;
    procedure KnkChange(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure KnotSize_Change(Sender: TObject);
    procedure KnotAngAddClick(Sender: TObject);
    procedure KnotAng_Click(Sender: TObject);
    procedure KnotAng_Change(Sender: TObject);
    procedure PktMethodChange(Sender: TObject);
    procedure ImgMouseEnter(Sender: TObject);
    procedure ImgMouseLeave(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PktApplySet;
    procedure PktConfirm;

    procedure MakeFloatSpins;
    procedure DestroyFloatSpins;

    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure RdropClick(Sender: TObject);

    procedure RenewKnotBox;
    procedure RouteBoxChange(Sender: TObject);
    procedure lkClick(Sender: TObject);
    procedure AddTemplateClick(Sender: TObject);
    procedure EditTemplateClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure isSqClick(Sender: TObject);
    procedure PktBoxClick(Sender: TObject);

    procedure RefreshBox;
    procedure RefreshTmps;

    procedure BAddClick(Sender: TObject);
    procedure pL_Change(Sender: TObject);
    procedure EditorPShow(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure DelPkt(N:Integer);
    procedure bUpClick(Sender: TObject);
    procedure bDownClick(Sender: TObject);
    procedure MainPShow(Sender: TObject);
    procedure PopPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PktBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure N2Click(Sender: TObject);
    procedure SaveTemplates(N:Integer; Name:String);
    procedure DelTemplate(N:Integer);
    procedure Button4Click(Sender: TObject);
    procedure T7Show(Sender: TObject);
    procedure TmpBoxChange(Sender: TObject);
    procedure Button6Click(Sender: TObject);

    procedure AppOnMessage(var MSG :TMsg; var Handled :Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure PktBoxDblClick(Sender: TObject);
    procedure ShowNamesClick(Sender: TObject);
    procedure snamesClick(Sender: TObject);
    procedure bSortClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure px_KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EnableApplyButtons(Sender: TObject);
    procedure bCenterClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure IHalfClick(Sender: TObject);
  private
    { Private declarations }
  public
    TestName: String;
    TestL   : Integer;
    Inited  : Boolean;
    HideRt  : Boolean;
    KnotN   : Integer;
    KnotA, KnotSz, pkt_cx, pkt_cy, KnotSz2 :real;

    KnotShape: Byte;
    pkt_RouteN   : Integer;
    pkt_Drop :Boolean;
    pkt_RouteA   : Double;
    pkt_StartA, pkt_Lx, pkt_Ly, pkt_Lmax :Double;
    pkt_PMethod, pkt_NameKind1, pkt_NameKind2, pkt_N :Byte;
    { Public declarations }
  end;

var
  FKnotPickets: TFKnotPickets;
  ImgScale, mx, my: integer;
  xl, yl, OldpX, OldpY : Real;
  MoveMap   :Boolean = false;
  MovePick  :Boolean = false;
  CanScroll :Boolean = false;

  ClickingApply :Boolean = false;

  KnotSize,  KnotSize2, SetKnAng, SetRtAng, KnotAng :TFloatSpinEdit;
  l1, l2x, l2y, l3, a3, l4x, l4y, a5, Scale5, Lmax :TFloatSpinEdit;
  pA, pL, pX, pY :TFloatSpinEdit;

  NeedRepaint:Boolean;
  BM :TBitMap;

  KnotColor, RouteColor :TColor;

  MyKnot :TKnot;
  Labeled, Olabeled :Integer;

  Choosing:Boolean;

  Shownames: byte = 0;
implementation

uses MapperFm;

{$R *.dfm}


procedure ScaleGraphs;
var I, m, hw : Integer;
begin
 GetKnotPickets(MyKnot, not FKnotPickets.HideRT);

 XL := 0; YL := 0; ImgScale  := 0;

 If FKnotPickets.MainPC.ActivePageIndex = 0 then
 Begin
  // if (uKnotPickets.KnotSize.Value > uKnotPickets.Lmax.Value)
  //    or (FKnotPickets.PktMethod.ItemIndex = 4)  then
     m := trunc(uKnotPickets.KnotSize.Value/2);
     if uKnotPickets.KnotSize2.Value > m*2 then
       m := trunc(uKnotPickets.KnotSize2.Value/2);
  // else
  //   m := trunc(uKnotPickets.Lmax.Value*1.25);
    
  // if (FKnotPickets.PktMethod.ItemIndex = 0) and (FKnotPickets.pkt_drop)
  //  or (FKnotPickets.PktMethod.ItemIndex = 4) then
  // begin
     for I := 0 to PktCount - 1 do
     begin
       if abs(Pkt[I].x) > m then
          m := trunc(abs(Pkt[I].x));
       if abs(Pkt[I].y) > m then
          m := trunc(abs(Pkt[I].y));
     end;
     m := trunc(m*1.5);
   //end;
 End
 Else
   Begin
     m := trunc(uKnotPickets.KnotSize.Value/2);
    if uKnotPickets.KnotSize2.Value > m*2 then
       m := trunc(uKnotPickets.KnotSize2.Value/2);
       
     for I := 0 to EdPicketsCount - 1 do
     begin
       if abs(EdPickets[I].x) > m then
         m := abs(trunc(EdPickets[I].x));
       if abs(EdPickets[I].y) > m then
         m := abs(trunc(EdPickets[I].y));
     end;
     m := trunc(m*1.5);
   End;

 try
   {if DispSize.X > DispSize.Y then
      m := trunc(m*200/DispSize.X)
   else
      m := trunc(m*200/DispSize.Y);}

   if FKnotPickets.Img.Width < FKnotPickets.Img.Height then
      HW := FKnotPickets.Img.Width
   else
      HW := FKnotPickets.Img.Height;

   for I := 0 to MaxMashtab-2 do
     if Abs(m) > TMashtab[I]/200*HW then
     begin
        if ImgScale < I+1 then
          Imgscale := I+1;
     end
         else
          break;
 except
 end;
 NeedRepaint := true;

end;

 // blend a pixel with the current colour
procedure AlphaBlendPixel(ABitmap : TBitmap ; X, Y : integer ; R, G, B : byte ; ARatio : Real);
 Var
   LBack, LNew : TRGBTriple;
   LMinusRatio : Real;
   LScan : PRGBTripleArray;
 begin
   if (X < 0) or (X > ABitmap.Width - 1) or (Y < 0) or (Y > ABitmap.Height - 1) then
     Exit; // clipping
   LScan := ABitmap.Scanline[Y];
   LMinusRatio := 1 - ARatio;
   LBack := LScan[X];
   LNew.rgbtBlue := round(B*ARatio + LBack.rgbtBlue*LMinusRatio);
   LNew.rgbtGreen := round(G*ARatio + LBack.rgbtGreen*LMinusRatio);
   LNew.rgbtRed := round(R*ARatio + LBack.rgbtRed*LMinusRatio);
   LScan[X] := LNew;
end;

procedure WuLine(ABitmap : TBitmap; Point1, Point2 : TPoint ; AColor : TColor);
 var
   deltax, deltay, loop, start, finish : integer;
   dx, dy, dydx : single; // fractional parts 
   LR, LG, LB : byte;
   x1, x2, y1, y2 : integer;
 begin
   x1 := Point1.X; y1 := Point1.Y;
   x2 := Point2.X; y2 := Point2.Y;
   deltax := abs(x2 - x1); // Calculate deltax and deltay for initialisation 
  deltay := abs(y2 - y1);
   if (deltax = 0) or (deltay = 0) then begin // straight lines 
    ABitmap.Canvas.Pen.Color := AColor;
     ABitmap.Canvas.MoveTo(x1, y1);
     ABitmap.Canvas.LineTo(x2, y2);
     exit;
   end;
   LR := (AColor and $000000FF);
   LG := (AColor and $0000FF00) shr 8;
   LB := (AColor and $00FF0000) shr 16;
   if deltax > deltay then
   begin // horizontal or vertical
    if y2 > y1 then // determine rise and run 
      dydx := -(deltay / deltax)
     else
       dydx := deltay / deltax;
     if x2 < x1 then
     begin
       start := x2; // right to left 
      finish := x1;
       dy := y2;
     end else
     begin
       start := x1; // left to right 
      finish := x2;
       dy := y1;
       dydx := -dydx; // inverse slope 
    end;
     for loop := start to finish do
     begin
       AlphaBlendPixel(ABitmap, loop, trunc(dy), LR, LG, LB, 1 - frac(dy));
       AlphaBlendPixel(ABitmap, loop, trunc(dy) + 1, LR, LG, LB, frac(dy));
       dy := dy + dydx; // next point 
    end;
   end else
   begin
     if x2 > x1 then // determine rise and run
      dydx := -(deltax / deltay)
     else
       dydx := deltax / deltay;
     if y2 < y1 then
     begin
       start := y2; // right to left 
      finish := y1;
       dx := x2;
     end else
     begin
       start := y1; // left to right 
      finish := y2;
       dx := x1;
       dydx := -dydx; // inverse slope 
    end;
     for loop := start to finish do
     begin
       AlphaBlendPixel(ABitmap, trunc(dx), loop, LR, LG, LB, 1 - frac(dx));
       AlphaBlendPixel(ABitmap, trunc(dx) + 1, loop, LR, LG, LB, frac(dx));
       dx := dx + dydx; // next point 
    end;
   end;
end;

procedure MyLine(ABitmap : TBitmap; Point1, Point2 : TMyPoint ; AColor : TColor);
var P1, P2 :TPoint;
begin
   CutLineByFrame(Point1.X, Point1.Y, Point2.X, Point2.Y);
   P1.x := round(Point1.X);     P2.x := round(Point2.X);
   P1.y := round(Point1.Y);     P2.y := round(Point2.Y);
   WuLine(ABitmap, P1, P2, AColor);
end;

procedure FatLine(ABitmap : TBitmap; Point1, Point2 : TMyPoint ; AColor : TColor;
           WU: Boolean);
var P1, P2 :TPoint;
    I, j : integer;
begin
   CutLineByFrame(Point1.X, Point1.Y, Point2.X, Point2.Y);
   for I := -1 to 1 do
     for j := -1 to 1 do
     begin
        P1.x := round(Point1.X) + I;     P2.x := round(Point2.X) + I;
        P1.y := round(Point1.Y) + j;     P2.y := round(Point2.Y) + j;
        case WU of
           true: WuLine(ABitmap, P1, P2, AColor);
           false: begin
              Bm.Canvas.Pen.Color := AColor;
              Bm.Canvas.MoveTo(P1.X, P1.y);
              Bm.Canvas.LineTo(P2.X, P2.y);
           end;
        end;

     end;
end;

procedure DrawLines(Bitmap: TBitMap; x0, y0 :real);
 var
     i, j, lcount : Integer;
     lstep : Real;
     Thick: boolean;
     S: String;
     MyLines : array [1..2] of TMyPoint;
begin
    Scale  := TMashtab[Mashtab]/100;

    lstep := TMashtab[Mashtab];

    if Bitmap.Width > Bitmap.Height then
          lcount := trunc(Bitmap.Width /2 * Scale / lstep)+2
            else
              lcount := trunc(Bitmap.Height /2 * Scale / lstep)+2;

    with Bitmap.Canvas Do
    begin
      Pen.Color := ClGray;
      Brush.Color := clWhite;

      Rectangle(0,0, Bitmap.Width, Bitmap.Height);

      Pen.Color := ClSilver;
    end;

    for J := -lcount to lcount do
    Begin
         Mylines[1].X := Trunc(x0 /lstep)*lstep;
         Mylines[1].Y := Trunc(y0 /lstep)*lstep + J*lstep;

         Mylines[2].X := (Mylines[1].X + (BitMap.Width) *Scale);
         Mylines[2].Y := (Mylines[1].Y);
         Mylines[1].X := (Mylines[1].X - (BitMap.Width) *Scale);

         Thick := Mylines[1].Y = 0;

         Mylines[1] := MapToScreen(MyLines[1].X, MyLines[1].Y, X0, Y0, 0, Scale, 0) ;
         Mylines[2] := MapToScreen(MyLines[2].X, MyLines[2].Y, X0, Y0, 0, Scale, 0);

         if Thick then
         begin
           Bitmap.Canvas.MoveTo(Trunc(MyLines[1].X), Trunc(MyLines[1].Y)+1);
           Bitmap.Canvas.LineTo(Trunc(MyLines[2].X), Trunc(MyLines[2].Y)+1);
           Bitmap.Canvas.MoveTo(Trunc(MyLines[1].X), Trunc(MyLines[1].Y)-1);
           Bitmap.Canvas.LineTo(Trunc(MyLines[2].X), Trunc(MyLines[2].Y)-1);
         end;

         Bitmap.Canvas.MoveTo(Trunc(MyLines[1].X), Trunc(MyLines[1].Y));
         Bitmap.Canvas.LineTo(Trunc(MyLines[2].X), Trunc(MyLines[2].Y));
    end;

    for I := -lcount to lcount do
    begin
         Mylines[1].X := Trunc(x0 /lstep)*lstep + I*lstep;
         Mylines[1].Y := Trunc(y0 /lstep)*lstep;

         Mylines[2].X := Mylines[1].X;
         Mylines[2].Y := Mylines[1].Y + (BitMap.Height) * Scale;
         Mylines[1].Y := Mylines[1].Y - (BitMap.Height) * Scale;

         Thick := Mylines[1].X = 0;

         Mylines[1] := MapToScreen(MyLines[1].X, MyLines[1].Y, X0, Y0, 0, Scale, 0) ;
         Mylines[2] := MapToScreen(MyLines[2].X, MyLines[2].Y, X0, Y0, 0, Scale, 0);

         if Thick then
         begin
           Bitmap.Canvas.MoveTo(Trunc(MyLines[1].X)+1, Trunc(MyLines[1].Y));
           Bitmap.Canvas.LineTo(Trunc(MyLines[2].X)+1, Trunc(MyLines[2].Y));
           Bitmap.Canvas.MoveTo(Trunc(MyLines[1].X)-1, Trunc(MyLines[1].Y));
           Bitmap.Canvas.LineTo(Trunc(MyLines[2].X)-1, Trunc(MyLines[2].Y));
         end;

         Bitmap.Canvas.MoveTo(Trunc(MyLines[1].X), Trunc(MyLines[1].Y));
         Bitmap.Canvas.LineTo(Trunc(MyLines[2].X), Trunc(MyLines[2].Y))
    End;

end;

procedure DrawScaleLine(Bitmap: TBitMap; x0, y0 :real);
 var
     S: String;

begin
    Scale  := TMashtab[Mashtab]/100;

    Bitmap.Canvas.Pen.Color := ClBlack;

    Bitmap.Canvas.MoveTo(BitMap.Width - 110, BitMap.Height - 10);
    Bitmap.Canvas.LineTo(BitMap.Width - 10, BitMap.Height - 10);
    Bitmap.Canvas.MoveTo(BitMap.Width - 110, BitMap.Height - 10);
    Bitmap.Canvas.LineTo(BitMap.Width - 110, BitMap.Height - 20);
    Bitmap.Canvas.MoveTo(BitMap.Width - 10, BitMap.Height - 10);
    Bitmap.Canvas.LineTo(BitMap.Width - 10, BitMap.Height - 20);

    if TMashtab[Mashtab]<1 then
      s :=  format('%2f',[TMashtab[Mashtab]])  + inf[40]
      else
      if TMashtab[Mashtab]<1000 then
        s := IntTostr(trunc(TMashtab[Mashtab])) + inf[40]
        else
          s := IntTostr(trunc(TMashtab[Mashtab]) div 1000) + inf[41];

    Bitmap.Canvas.TextOut( trunc(BitMap.Width - 60 - Bitmap.Canvas.TextWidth(s)/2),
                           BitMap.Height - 30, s);
end;


procedure DrawPoints(Bitmap: TBitMap; x0, y0 :real);
var mP1, mP2 :TMyPoint;
    P1, P2 :TPoint;
    I, j :Integer;
    s: string;
    _ang, a : double;
begin
 //  0. Draw the route (profile)
  if FKnotPickets.mainPC.ActivePageIndex = 0 then
    if not FKnotPickets.HideRt then
    begin
      mp1 :=  MapToScreen(-5000, -2500, X0, Y0, 0, Scale, 0);
      mp2 :=  MapToScreen(5000, 2500, X0, Y0, 0, Scale, 0);

      Fatline(Bm, mp1, mp2, RouteColor, true);
    end
     else
     if {((FKnotPickets.pkt_drop) and
        (FKnotPickets.RouteBox.ItemIndex > -1)) or} (FKnotPickets.pkt_RouteN >= 0)   then
     Begin
       if (FKnotPickets.PktMethod.ItemIndex = 0) and
          (FKnotPickets.pkt_drop) then
           j := FKnotPickets.RouteBox.ItemIndex
          else
            j := FKnotPickets.pkt_RouteN;

       if (j < RouteCount) and (j >= 0) then
       if length(Route[j].WPT) > 1 then
       for I := 0 to length(Route[j].WPT) - 2 do
       begin
          mp1 :=  MapToScreen(Route[j].WPT[I].x -
                              FKnotPickets.pkt_cx,
                              Route[j].WPT[I].y -
                              FKnotPickets.pkt_cy,
                              X0, Y0, 0, Scale, 0);
          mp2 :=  MapToScreen(Route[j].WPT[I+1].x -
                              FKnotPickets.pkt_cx,
                              Route[j].WPT[I+1].y -
                              FKnotPickets.pkt_cy,
                              X0, Y0, 0, Scale, 0);

          Fatline(Bm, mp1, mp2, RouteColor, true);
       end;
     End;

 //  1. Draw the knot
     case FKnotPickets.KnotShape of
       1: BEGIN
          with FKnotPickets do
          for j := 0 to 32 do
          begin
            mP1.x := Sin( j*pi/16 )*KnotSz;
            mP1.y := Cos( j*pi/16 )*KnotSz;
            mP2.x := Sin( (j+1)*pi/16 )*KnotSz;
            mP2.y := Cos( (j+1)*pi/16 )*KnotSz;

            mp1 :=  MapToScreen(mp1.x, mp1.y, X0, Y0, 0, Scale, 0);
            mp2 :=  MapToScreen(mp2.x, mp2.y, X0, Y0, 0, Scale, 0);

          Fatline(Bm, mp1, mp2, KnotColor, true);
        end;
       END;
       2: BEGIN
        if FKnotPickets.mainPC.ActivePageIndex = 0 then
          _ang := FKnotPickets.KnotA
        else
          _ang := 0;

        with FKnotPickets do
        for j := 1 to 4 do
        begin
          a := j * pi/2;
          case j mod 2 = 0 of
            true:  a := a + arctan2(KnotSz, KnotSz2);
            false: a := a + arctan2(KnotSz2, KnotSz);
          end;
          mP1.x := Sin(_ang + a)*Sqrt(sqr(KnotSz)+sqr(KnotSz2))/2;
          mP1.y := Cos(_ang + a)*Sqrt(sqr(KnotSz)+sqr(KnotSz2))/2;

          a := (j+1) * pi/2;
          case (j+1) mod 2 = 0 of
            true:  a := a + arctan2(KnotSz, KnotSz2);
            false: a := a + arctan2(KnotSz2, KnotSz);
          end;
          mP2.x := Sin(_ang +a)*Sqrt(sqr(KnotSz)+sqr(KnotSz2))/2;
          mP2.y := Cos(_ang +a)*Sqrt(sqr(KnotSz)+sqr(KnotSz2))/2;

          mp1 :=  MapToScreen(mp1.x, mp1.y, X0, Y0, 0, Scale, 0);
          mp2 :=  MapToScreen(mp2.x, mp2.y, X0, Y0, 0, Scale, 0);

          Fatline(Bm, mp1, mp2, KnotColor, true);
        end;


       END;
       ELSE BEGIN
        if FKnotPickets.mainPC.ActivePageIndex = 0 then
          _ang := FKnotPickets.KnotA
        else
          _ang := 0;

        with FKnotPickets do
        for j := 1 to 4 do
        begin
          mP1.x := Sin(_ang + j*pi/2 + pi/4)*Sqrt(2)*KnotSz/2;
          mP1.y := Cos(_ang + j*pi/2 + pi/4)*Sqrt(2)*KnotSz/2;
          mP2.x := Sin(_ang +(j+1)*pi/2 + pi/4)*Sqrt(2)*KnotSz/2;
          mP2.y := Cos(_ang +(j+1)*pi/2 + pi/4)*Sqrt(2)*KnotSz/2;

          mp1 :=  MapToScreen(mp1.x, mp1.y, X0, Y0, 0, Scale, 0);
          mp2 :=  MapToScreen(mp2.x, mp2.y, X0, Y0, 0, Scale, 0);

          Fatline(Bm, mp1, mp2, KnotColor, true);
        end;
       END;
     end;
 //  2. Draw the knot pickets
   if FKnotPickets.mainPC.ActivePageIndex = 0 then
   begin
     for I := 0 to PktCount-1 do
      begin
        mP1 := MapToScreen(Pkt[I].x, Pkt[I].y, X0, Y0, 0, Scale, 0);
        RedForm.ImageList1.Draw(Bm.Canvas, round(mP1.x)-8, round(mP1.y)-8, 11);
      end;

      if Shownames > 0 then
      for I := 0 to PktCount-1 do
      begin
        s:= Pkt[I].Name;
        if ShowNames = 2 then
        begin
          s:= AnsiLowerCase(s);
          if FKnotPickets.Knk.ItemIndex < 3 then
          while Pos('pkt',s) > 0 do
          begin
            j :=Pos('pkt',s);
            s := Copy(s, j+3, length(s));
          end;

          if FKnotPickets.Knk.ItemIndex = 3 then
          while Pos('_p',s) > 0 do
          begin
            j :=Pos('_p',s);
            s := Copy(s, j+2, length(s));
          end;

          if FKnotPickets.Knk.ItemIndex  > 3 then
          while Pos('_',s) > 0 do
          begin
            j :=Pos('_',s);
            s := Copy(s, j+1, length(s));
          end;
        end;

          

        mP1 := MapToScreen(Pkt[I].x, Pkt[I].y, X0, Y0, 0, Scale, 0);
        Bitmap.Canvas.TextOut(round(mp1.x) -
               Bitmap.Canvas.TextWidth(s) div 2,
               round(mp1.y) - 20, s);
      end;

      if Labeled >= 0 then
      if Labeled < PktCount then
      begin
          I := Labeled;
          mP1 := MapToScreen(Pkt[I].x, Pkt[I].y, X0, Y0, 0, Scale, 0);
          Bitmap.Canvas.TextOut(round(mp1.x) -
               Bitmap.Canvas.TextWidth(Pkt[I].Name) div 2,
               round(mp1.y) - 20, Pkt[I].Name);
      end;
   end;

   if FKnotPickets.mainPC.ActivePageIndex = 1 then
   Begin
      for I := 0 to EdPicketsCount-1 do
      begin
        mP1 := MapToScreen(EdPickets[I].x,
                           EdPickets[I].y, X0, Y0, 0, Scale, 0);
        RedForm.ImageList1.Draw(Bm.Canvas, round(mP1.x)-8, round(mP1.y)-8, 11);
      end;

      if Shownames > 0 then
      for I := 0 to EdPicketsCount-1 do
      begin
        S := 'Pkt_'+FormatFloat('00', I+1);
        mP1 := MapToScreen(EdPickets[I].x, EdPickets[I].y, X0, Y0, 0, Scale, 0);
        if ShowNames = 2 then
          S:= FormatFloat('00', I+1);
        Bitmap.Canvas.TextOut(round(mp1.x) -
              Bitmap.Canvas.TextWidth(s) div 2,
              round(mp1.y) - 20, s);
      end;

      I := FKnotPickets.PktBox.ItemIndex;
      if I <> -1 then
      begin
        mP1 := MapToScreen(EdPickets[I].x, EdPickets[I].y, X0, Y0, 0, Scale, 0);
        RedForm.ImageList1.Draw(Bm.Canvas, round(mP1.x)-8, round(mP1.y)-8, 12);
      end;

      if Labeled >=0 then
      if Labeled < EdPicketsCount then
      begin
        I := Labeled;
        mP1 := MapToScreen(EdPickets[I].x, EdPickets[I].y, X0, Y0, 0, Scale, 0);
        S := 'Pkt_'+FormatFloat('00', Labeled+1);
        Bitmap.Canvas.TextOut(round(mp1.x) -
             Bitmap.Canvas.TextWidth(s) div 2,
             round(mp1.y) - 20, s);
      end;

     
   End;

   Olabeled := Labeled;
end;

procedure RepaintLegend;
var yy:integer;
begin

  if FKnotPickets.mainPC.ActivePageIndex = 0 then
  with Bm do
  begin
    if (Width < 320) or (Height < 350) then
       exit;

    Canvas.Brush.Color := clWhite;
    Canvas.Pen.Color := clGray;
    yy := Height - 65;

    Canvas.Rectangle(10, yy, 150, yy + 55);
    Fatline(Bm, MyPoint(17,5+ yy), MyPoint(20, 15 + yy),
      RouteColor, true);

    Fatline(Bm, MyPoint(17,22 +yy), MyPoint(20, 32 + yy),
      KnotColor, true);

    Canvas.Pen.Color := clBlack;
    Canvas.Font.Color := clBlack;
    Canvas.TextOut(30, 5+yy, inf[104]);

    Canvas.TextOut(30, 8+yy + 14, inf[105]);

    RedForm.ImageList1.Draw(Canvas, 14, 38 + yy, 11);
    Canvas.TextOut(30, 38 + yy, inf[106]);
  end;

end;


procedure RepaintImg;
begin
  FKnotPickets.PktApplySet;
  GetKnotPickets(MyKnot, not FKnotPickets.HideRT);

 if FKnotPickets.HideRt then
    FKnotPickets.KnotA  := uKnotPickets.SetKnAng.Value*pi/180
 else
   if FKnotPickets.KnotAngRoute.Checked then
    FKnotPickets.KnotA  := 1.107
   else
     if FKnotPickets.KnotAngAdd.Checked then
       FKnotPickets.KnotA  := uKnotPickets.KnotAng.Value*pi/180 + 1.107
     else
       FKnotPickets.KnotA  := uKnotPickets.KnotAng.Value*pi/180 ;
  FKnotPickets.KnotSz  := uKnotPickets.KnotSize.Value;
  FKnotPickets.KnotSz2 := uKnotPickets.KnotSize2.Value;

  Mashtab := ImgScale;
  with Bm.Canvas Do
  Begin
    Bm.Height :=  FKnotPickets.Img.Height;
    Bm.Width :=   FKnotPickets.Img.Width;

    DispSize.X := Bm.Width;
    DispSize.Y := Bm.Height;
    DrawLines(Bm, xl, yl);
    DrawPoints(Bm, xl, yl);
    DrawScaleLine(Bm, xl, yl);
  End;

  RepaintLegend;

  FKnotPickets.Img.Canvas.CopyRect(Rect(0,0, Bm.Width, Bm.Height),
                       Bm.Canvas,Rect(0,0, Bm.Width, Bm.Height));

  NeedRepaint := false;
end;

procedure ApplyMyKnot;
begin
    MyKnot.PMethod  := FKnotPickets.PktMethod.ItemIndex;
    MyKnot.NameKind := FKnotPickets.pkt_NameKind1;
    MyKnot.BoxSize  := FKnotPickets.KnotSz;
    MyKnot.BoxSize2 := FKnotPickets.KnotSz2;
    MyKnot.BoxAngle := FKnotPickets.KnotA;
    MyKnot.StepOut  := FKnotPickets.pkt_N;
    if  (uKnotPickets.SetRtAng.Visible) and (FKnotPickets.HideRt = true) then
      MyKnot.RouteAngle := uKnotPickets.SetRtAng.Value*pi/180;
    MyKnot.Cx := FKnotPickets.pkt_cX;
    MyKnot.Cy := FKnotPickets.pkt_cY;

    case MyKnot.Pmethod of
       1: MyKnot.DropToRoute := not FKnotPickets.Drop2.Checked;
       2: MyKnot.DropToRoute := FKnotPickets.DoRang.Checked;
       4: MyKnot.DropToRoute := not FKnotPickets.Drop5.Checked;
       else MyKnot.DropToRoute := FKnotPickets.RDrop.Checked;
    end;

    MyKnot.Lx   := FKnotPickets.pkt_Lx;
    MyKnot.Ly   := FKnotPickets.pkt_Ly;
    MyKnot.Lmax := FKnotPickets.pkt_Lmax;

    MyKnot.NameKind2 := FKnotPickets.pkt_NameKind2;

    MyKnot.RouteAngle := 1.107;

    if FKnotPickets.HideRt then
       MyKnot.RouteAngle := FKnotPickets.pkt_RouteA;

    MyKnot.RouteN :=  FKnotPickets.pkt_RouteN;

    if (FKnotPickets.KnotN >= 0) then
      if (FKnotPickets.KnotN < Length(KnotPoints)) then
      begin
         MyKnot.Name :=  KnotPoints[FKnotPickets.KnotN].Name;
         MyKnot.L    :=  KnotPoints[FKnotPickets.KnotN].L;
      end;
end;

procedure TFKnotPickets.AddTemplateClick(Sender: TObject);
begin
 MainPC.ActivePageIndex := 1;
end;

procedure TFKnotPickets.AppOnMessage(var MSG: TMsg; var Handled: Boolean);
begin
//  if MSG.message = WM_MOUSEWHEEL then
//    if CanScroll then
//      exit;
end;

procedure TFKnotPickets.BAddClick(Sender: TObject);
begin
  if EdPicketsCount < MaxPkt-1 then
     inc(EdPicketsCount);

  case isSq.Checked of
     true: begin
       EdPickets[EdPicketsCount-1].x := pX.Value;
       EdPickets[EdPicketsCount-1].y := pY.Value;
     end;
     false: begin
       EdPickets[EdPicketsCount-1].x := pL.Value*Sin(pA.Value*pi/180);
       EdPickets[EdPicketsCount-1].y := pL.Value*Cos(pA.Value*pi/180);
     end;
  end;

  RefreshBox;
  PktBox.ItemIndex := PktBox.Count-1;
end;

procedure TFKnotPickets.bCancelClick(Sender: TObject);
var I:Integer;
begin
 bCancel.Enabled := false;   bApply.Enabled := false; ClickingApply := false;
 if PktBox.ItemIndex = -1 then
    exit;

  if (px.Text='') or (py.Text = '') or (pl.Text = '') or (pa.Text = '')then
    exit;

  I := PktBox.ItemIndex;

  EdPickets[I].x := OldPx;
  EdPickets[I].y := OldPy;

  RefreshBox;
end;

procedure TFKnotPickets.bCenterClick(Sender: TObject);
begin
 BApply.OnClick(nil);
 PktBox.OnDblClick(nil);
end;

procedure TFKnotPickets.BDelClick(Sender: TObject);
begin
 DelPkt(PktBox.ItemIndex);
 if PktBox.ItemIndex > 0 then
    PktBox.ItemIndex := PktBox.ItemIndex -1;
 RefreshBox;
end;

procedure TFKnotPickets.bDownClick(Sender: TObject);
var I:Integer;
    P:TMyPoint;
begin

 if (PktBox.ItemIndex >= 0) and (PktBox.ItemIndex < PktBox.Count-1) then
 begin
    P := EdPickets[PktBox.ItemIndex+1];
    EdPickets[PktBox.ItemIndex+1] := EdPickets[PktBox.ItemIndex];
    EdPickets[PktBox.ItemIndex] := P;
    PktBox.ItemIndex := PktBox.ItemIndex +1;
 end;
 RefreshBox;
end;

procedure TFKnotPickets.bSortClick(Sender: TObject);
begin
  N3.Click;
end;

procedure TFKnotPickets.bUpClick(Sender: TObject);
var I:Integer;
    P:TMyPoint;
begin

 if PktBox.ItemIndex > 0 then
 begin
    P := EdPickets[PktBox.ItemIndex-1];
    EdPickets[PktBox.ItemIndex-1] := EdPickets[PktBox.ItemIndex];
    EdPickets[PktBox.ItemIndex] := P;
    PktBox.ItemIndex := PktBox.ItemIndex -1;
 end;
 RefreshBox;
end;

procedure TFKnotPickets.Button1Click(Sender: TObject);
var I:Integer;
begin
  PktApplySet;
  PktConfirm;
  close;
  if MapFm.NewKnotPanel.Visible then
    if MapFm.ShowPkts.Flat then
       MapFm.ShowPkts.Click;
end;

procedure TFKnotPickets.Button2Click(Sender: TObject);
begin
  close;
  if MapFm.NewKnotPanel.Visible then
     MapFm.KnotSize_Change(nil);
end;

procedure TFKnotPickets.Button3Click(Sender: TObject);
var I: Integer;
begin
  if TmpBox.ItemIndex = -1 then
    Button4.Click
  else
    SaveTemplates(TmpBox.ItemIndex, TmpBox.Text);

  PktTemplates.Items.Clear;
  for I := 0 to TmpBox.Items.Count - 1 do
    PktTemplates.Items.Add(TmpBox.Items[I]);
  PktTemplates.ItemIndex := TmpBox.ItemIndex;
end;

procedure TFKnotPickets.Button4Click(Sender: TObject);
var S:String;  i:Integer;
begin

  if not InputQuery(inf[107], '', S) then
    exit;

  if S = '' then
    exit;

  SaveTemplates(TmpBox.Items.Count, S);

  TmpBox.ItemIndex := TmpBox.Items.Count-1;
  PktTemplates.Items.Clear;
  for I := 0 to TmpBox.Items.Count - 1 do
    PktTemplates.Items.Add(TmpBox.Items[I]);
  PktTemplates.ItemIndex := TmpBox.ItemIndex;
end;

procedure TFKnotPickets.Button5Click(Sender: TObject);
begin
  MainPC.ActivePageIndex := 0;

  if PktTemplates.ItemIndex = -1 then
     PktTemplates.ItemIndex := 0;
end;

procedure TFKnotPickets.Button6Click(Sender: TObject);
begin
  if MessageDlg(inf[111], mtConfirmation,mbYesNo,0) <> 6 then
    exit;
  DelTemplate(TmpBox.ItemIndex);
  RefreshTmps;
  RefreshBox;
end;

procedure TFKnotPickets.DelPkt(N: Integer);
var I:Integer;
begin
  if N = -1 then
    exit;
  dec(EdPicketsCount);
  for I := N to EdPicketsCount - 1 do
    EdPickets[I] := EdPickets[I+1];
    
end;

procedure TFKnotPickets.DelTemplate(N: Integer);
var S: TstringList;
    I, j, I1, I2 :Integer;
    new :Boolean;
begin
  if TmpBox.Items.Count = 0 then
     exit;
     
  S := TstringList.Create;

  try
    S.LoadFromFile(MyDir+'Data\Loops.loc');
    S.SaveToFile(MyDir+'Data\Loops_backup.loc');
    I := 0;  I1 := 0;
    j := 0;
    EdPicketsCount := 0;
    new:= true;

    if TmpBox.Items.Count = 1 then
    begin
      S.Clear;
      S.SaveToFile(MyDir+'Data\Loops.loc');
      RefreshBox;
      S.Destroy;
      exit
    end;

    if N > 0 then
    for I := 0 to S.Count - 1 do
       if S[I]= '\\' then
       begin
         inc(j);
         if j = N then
         begin
           I1 := I+1;
           break;
         end;
       end;

    I2 := S.Count-1;
    repeat
      inc(I);
      if S[I]= '\\' then
      begin
         I2 := I;
         break;
      end;
      //inc(I);
    until (I>= S.Count-1) or (S[I]='\\');

    for I := I2 Downto I1 do
      S.Delete(I);

  except
  end;
  S.SaveToFile(MyDir+'Data\Loops.loc');
  RefreshBox;
  S.Destroy;
end;

procedure TFKnotPickets.DestroyFloatSpins;
begin
   KnotSize.Destroy; SetKnAng.Destroy; SetRtAng.Destroy; KnotAng.Destroy;
   l1.Destroy; l2x.Destroy; l2y.Destroy; l3.Destroy; a3.Destroy; l4x.Destroy;
   l4y.Destroy; a5.Destroy;  Scale5.Destroy;  Lmax.Destroy;
end;

procedure TFKnotPickets.EditorPShow(Sender: TObject);
begin
  EdPicketsCount := 0;
  Choosing := false;
  Img.PopupMenu := Pop;
  NeedRepaint := true;
end;

procedure TFKnotPickets.EditTemplateClick(Sender: TObject);
begin
  MainPC.ActivePageIndex := 1;
  TmpBox.ItemIndex := PktTemplates.ItemIndex;
  TmpBox.OnChange(nil);
end;

procedure TFKnotPickets.EnableApplyButtons(Sender: TObject);
begin
  bApply.Enabled := true;     bCancel.Enabled := true;
end;

procedure TFKnotPickets.FormActivate(Sender: TObject);
begin
  NeedRepaint := true;
end;

procedure TFKnotPickets.FormCreate(Sender: TObject);
begin
  Inited := false;
  KnotN := -1;
  labeled := -1;
  Olabeled := -2;
  Img.Parent.DoubleBuffered := true;
  BM := TBitMap.Create;
  Bm.Assign(Img.Picture.Bitmap);
  Bm.Height := Img.Height;
  Bm.Width :=  Img.Width;

  MakeFloatSpins;
  ScaleGraphs;
  img.Picture.Bitmap.Width  := Img.Width;
  img.Picture.Bitmap.Height := Img.Height;

  KnotColor := clLime;//Fuchsia;
  RouteColor := clSkyBlue;

  PktApplySet;
  PktPages.ActivePageIndex := PktMethod.ItemIndex;
end;

procedure TFKnotPickets.FormDestroy(Sender: TObject);
begin
 Bm.Free;
 DestroyFloatSpins;
end;

procedure TFKnotPickets.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  mx := x;
  my := y;
end;

procedure TFKnotPickets.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if CanScroll then
  if WheelDelta < 0 then
  BEGIN
    Inc(ImgScale);
    if ImgScale > MaxMashtab-1 then
       ImgScale := MaxMashtab-1;
    NeedRepaint := true;
  END
   ELSE
  BEGIN
    Dec(ImgScale);

    if ImgScale < 5 then
       ImgScale := 5;
    NeedRepaint := true;
  END;
end;


procedure TFKnotPickets.FormResize(Sender: TObject);
begin
  img.Picture.Bitmap.Width   := Img.Width;
  img.Picture.Bitmap.Height  := Img.Height;
  RepaintImg;
  NeedRepaint := true;
end;

procedure TFKnotPickets.FormShow(Sender: TObject);
var I:Integer;
begin
  case HideRt of
     true:  PG.ActivePageIndex := 0;
     false: PG.ActivePageIndex := 1;
  end;

  case KnotShape of
     2:   lk.Top := KnotLabel.Top+4;
     else lk.Top := KnotSize.Top;
  end;

  Routebox.Enabled := HideRt;

  KnotSize.Enabled := (not HideRt) or (length(SelectedKnots) = 1);
  KnotSize2.Enabled := (not HideRt) or (length(SelectedKnots) = 1);
  KnotSize2.Visible := KnotShape = 2;
  SetKnAng.Enabled := (not HideRt) or (length(SelectedKnots) = 1);
  SetRtAng.Enabled := (not HideRt) or (length(SelectedKnots) = 1);
  lk.Visible := not KnotSize.Enabled;

  PktPages.ActivePageIndex := PktMethod.ItemIndex;
  Knk.OnChange(nil);

  PktApplySet;
  ApplyMyKnot;
  GetKnotPickets(MyKnot, not HideRT);
  ScaleGraphs;
  RepaintImg;
  NeedRepaint := true;

  Knk2.Enabled := (PktMethod.ItemIndex > 0 ) and (PktMethod.ItemIndex < 4);
  snames.Glyph.Assign(nil);
  RedForm.ImageList1.GetBitmap(13+ShowNames,snames.Glyph);
  snames.Hint := inf[108+ShowNames];
  snames2.Glyph.Assign(nil);
  snames2.Glyph := snames.Glyph;
  snames2.Hint := inf[108+ShowNames];

  I := PktMethod.ItemIndex;
  PktMethod.Items[0] := Inf[150]; PktMethod.Items[1] := Inf[151];
  PktMethod.Items[2] := Inf[152]; PktMethod.Items[3] := Inf[153];
  PktMethod.Items[4] := Inf[154];
  PktMethod.ItemIndex := I;
  I := Knk2.ItemIndex;
  Knk2.Items[0] := Inf[155];
  Knk2.Items[1] := Inf[156];
  Knk2.Items[2] := Inf[157];
  Knk2.ItemIndex := I;
end;

procedure TFKnotPickets.IHalfClick(Sender: TObject);
begin
 PktApplySet;

 NeedRepaint := true;
end;

procedure TFKnotPickets.ImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var I:Integer; P:TMyPoint;
begin

  mx := x + Img.Left;
  my := y + Img.Top;

  DispSize.X := Bm.Width;
  DispSize.Y := Bm.Height;

  MovePick := False;

  Labeled := -1;
  for I := EdPicketsCount-1 downto 0 do
  begin
    P := MapToScreen(EdPickets[I].x, EdPickets[I].y, Xl, Yl,
                       0, TMashtab[ImgScale]/100 , 0);
    if Labeled = -1 then
    if (abs(mx - P.x) <= 4) and (abs(my - P.y) <= 4) then
    begin
       Labeled :=I;
       break;
    end;
  end;

  if Button = mbLeft then
  if MainPC.ActivePageIndex = 1 then
  Begin
    if Labeled >= 0 then
    begin
      if PktBox.ItemIndex <> Labeled then
      begin
        PktBox.ItemIndex := Labeled;
        PktBox.OnClick(nil);
      end
        else
          MovePick := true;
      NeedRepaint := true;
    end
     else
       MoveMap := true;
  End
   Else
     MoveMap := true;

  if MoveMap then
  Begin
    Img.Cursor := crSizeAll;
    Screen.Cursor := crSizeAll;
  End;

  if MovePick then
  Begin
    Img.Cursor := crDrag;
    Screen.Cursor := crDrag;
  End;
end;

procedure TFKnotPickets.ImgMouseEnter(Sender: TObject);
begin
 CanScroll := true;
 case MainPC.ActivePageIndex of
 
   0: if (PktMethod.Focused) or (PktTemplates.Focused) then
      try
        Button1.SetFocus;
      except
      end;

   1: try
        PktBox.SetFocus;
      except
      end;
 end;

// PktBox.SetFocus();
end;

procedure TFKnotPickets.ImgMouseLeave(Sender: TObject);
begin
 CanScroll := false;
// MovePick := false;
end;

procedure TFKnotPickets.ImgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

var dx, dy, sc :real;
    P: TMyPoint;
    I, j: Integer;
begin
  DispSize.X := Bm.Width;
  DispSize.Y := Bm.Height;
  sc := TMashtab[ImgScale]/100;

  if (MoveMap = false)  then
  begin
    P := ScreenToMap( X, Y, XL, YL, 0, Sc, 0);

    if Sc <1 then
       Label4.Caption := format('%3f',[P.x])+' ; '+ format('%3f',[P.y])
       else
       Label4.Caption := IntToStr(trunc(P.x))+' ; '+ IntToStr(trunc(P.y));
  end;

  GetKnotPickets(MyKnot, not HideRT);
  Labeled := -1;
  if MainPC.ActivePageIndex = 1 then
    j := EdPicketsCount-1
  else
    j := PktCount-1;

  for I := j downto 0 do
  begin
    if MainPC.ActivePageIndex = 1 then
      P := MapToScreen(EdPickets[I].x, EdPickets[I].y, Xl, Yl, 0, Sc, 0)
    else
      P := MapToScreen(Pkt[I].x, Pkt[I].y, Xl, Yl, 0, Sc, 0);

    if Labeled = -1 then
    if abs(x - P.x) < 4  then
    if abs(y - P.y) < 4  then
    begin
       Labeled := I;
       break;
    end;
  end;
  NeedRepaint :=  Olabeled <> Labeled;
  //Olabeled := Labeled;

  if  MoveMap then
  begin
    sc := TMashtab[ImgScale]/100;

    dx := (mx- Img.Left - x)*Sc;
    dy := (my- Img.Top  - y)*Sc;

    xL := xL + dx;
    yL := yL - dy;

    NeedRepaint := True;
  end;

  if MovePick then
  if PktBox.ItemIndex >= 0 then
  begin
    sc := TMashtab[ImgScale]/100;

    dx := (mx- Img.Left - x)*Sc;
    dy := (my- Img.Top  - y)*Sc;

    EdPickets[PktBox.ItemIndex].x := EdPickets[PktBox.ItemIndex].x - dx;
    EdPickets[PktBox.ItemIndex].y := EdPickets[PktBox.ItemIndex].y + dy;

   // RefreshBox;
    NeedRepaint := True;

    Img.Cursor := crDrag;
    Screen.Cursor := crDrag;
  end
    else
    begin
      Img.Cursor := crCross;
      Screen.Cursor := crDefault;
    end;

  if MainPC.ActivePageIndex = 1 then
  if (labeled <> -1) and (labeled = PktBox.ItemIndex) or (MovePick) then
  begin
     Img.Cursor := crDrag;
     Screen.Cursor := crDrag;
  end else
    begin
      Img.Cursor := crCross;
      Screen.Cursor := crDefault;
    end;

  mx := x + Img.Left;
  my := y + Img.Top;
end;

procedure TFKnotPickets.ImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if MovePick then
   RefreshBox;

  MoveMap := false;   MovePick := false;
  Img.Cursor := crCross;
  Screen.Cursor := crDefault;
end;

procedure TFKnotPickets.isSqClick(Sender: TObject);
begin
  case isSq.Checked of
    true:  CoordPC.ActivePageIndex := 0;
    false: CoordPC.ActivePageIndex := 1;
  end;
  RefreshBox;
  PktBox.OnClick(nil);
end;

procedure TFKnotPickets.KnotAngAddClick(Sender: TObject);
begin
 NeedRepaint := true;
 KnotAngAdd.Enabled := KnotAngOwn.Checked;

 NeedRepaint := true;
end;

procedure TFKnotPickets.KnotAng_Change(Sender: TObject);
begin
 PktApplySet;

 NeedRepaint := true;
end;

procedure TFKnotPickets.KnotAng_Click(Sender: TObject);
begin
 PktApplySet;

 NeedRepaint := true;
end;

procedure TFKnotPickets.KnotSize_Change(Sender: TObject);
begin
 PktApplySet;

 ScaleGraphs;
end;

procedure TFKnotPickets.lkClick(Sender: TObject);
begin
  KnotSize.Enabled := true;
  SetKnAng.Enabled := true;
  SetRtAng.Enabled := true;
  lk.Visible := false;
end;

procedure TFKnotPickets.MainPShow(Sender: TObject);
begin
  Img.PopupMenu := nil;
  NeedRepaint := true;
end;

procedure TFKnotPickets.N1Click(Sender: TObject);
var P:TMyPoint;
begin
  DispSize.X := Bm.Width;
  DispSize.Y := Bm.Height;

  P := ScreenToMap(mx - Img.Left, my - Img.Top, xl, yl, 0,
                   TMashtab[ImgScale]/100 , 0);


  if EdPicketsCount < MaxPkt-1 then
     inc(EdPicketsCount);

  EdPickets[EdPicketsCount-1].x := p.X;
  EdPickets[EdPicketsCount-1].y := p.Y;

  RefreshBox;
  PktBox.ItemIndex := PktBox.Count-1;
  PktBox.OnClick(nil);

  RepaintImg;
  NeedRepaint := true;
end;

procedure TFKnotPickets.N2Click(Sender: TObject);
var P:TMyPoint;
begin
  if PktBox.ItemIndex < 0 then
    exit;

  DispSize.X := Bm.Width;
  DispSize.Y := Bm.Height;

  P := ScreenToMap(mx - Img.Left, my - Img.Top, xl, yl, 0,
                   TMashtab[ImgScale]/100 , 0);

  EdPickets[PktBox.ItemIndex].x := p.X;
  EdPickets[PktBox.ItemIndex].y := p.Y;

  PktBox.OnClick(nil);

  RepaintImg;
  NeedRepaint := true;
end;

procedure InvertPts;
var I, j :Integer;
    P    :TMyPoint;
begin
  j := trunc(EdPicketsCount / 2)-1;
  for I := 0 to j do
  begin
    P := EdPickets[I];
    EdPickets[I] := EdPickets [EdPicketsCount-1 - I];
    EdPickets[EdPicketsCount-1 - I] := P;
  end;  
  FKnotPickets.RefreshBox;
  NeedRepaint := true;
end;

procedure SortPts(Kind: Byte);

  procedure SortByX(I1, I2:Integer);
  var I, j, MinI :Integer;  P : TMyPoint;  Min :Double;
  begin
      for I := I1 to I2 do
      begin
         Min := EdPickets[I].x;       MinI := I;
         for j := I to I2 do
           if EdPickets[j].x < Min then
           begin
              Min := EdPickets[j].x;  MinI := j;
           end;
         P := EdPickets[I];
         EdPickets[I] := EdPickets[MinI];
         EdPickets[MinI] := P;
      end;
  end;

  procedure SortByY(I1, I2:Integer);
  var I, j, MinI :Integer;  P : TMyPoint;  Min :Double;
  begin
      for I := I1 to I2 do
      begin
         Min := EdPickets[I].y;       MinI := I;
         for j := I to I2 do
           if EdPickets[j].y > Min then
           begin
              Min := EdPickets[j].y;  MinI := j;
           end;
         P := EdPickets[I];
         EdPickets[I] := EdPickets[MinI];
         EdPickets[MinI] := P;
      end;
  end;

var I, I1 :Integer;
begin

  // PHASE 1
  case Kind of
    0: SortByX(0, EdPicketsCount - 1);
    1: SortByY(0, EdPicketsCount - 1);
  end;


  // PHASE 2
  I1 := 0;
  for I := 0 to EdPicketsCount - 2 do
  begin

    case Kind of
      0:if EdPickets[I+1].x <> EdPickets[I].x then
        begin
          if I <> I1 then
            SortByY(I1, I);
          I1 := I+1;
        end;

      1:if EdPickets[I+1].y <> EdPickets[I].y then
        begin
          if I <> I1 then
            SortByX(I1, I);
          I1 := I+1;
        end;

     end; // case

  end;

  FKnotPickets.RefreshBox;
  NeedRepaint := true;
end;

procedure TFKnotPickets.N3Click(Sender: TObject);
begin
   SortPts(1);
end;

procedure TFKnotPickets.N4Click(Sender: TObject);
begin
   SortPts(0);
end;

procedure TFKnotPickets.N7Click(Sender: TObject);
begin
  InvertPts;
end;

procedure ApplyKnot(N:Integer);
begin
    if (N < 0) or (N > Length(KnotPoints)-1) then
      exit;

    KnotPoints[N].PMethod  := FKnotPickets.PktMethod.ItemIndex;
    KnotPoints[N].NameKind := FKnotPickets.pkt_NameKind1;

    KnotPoints[N].Lx   := FKnotPickets.pkt_Lx;
    KnotPoints[N].Ly   := FKnotPickets.pkt_Ly;
    KnotPoints[N].Lmax := FKnotPickets.pkt_Lmax;
    KnotPoints[N].RouteAngle := FKnotPickets.pkt_RouteA;

    if (length(SelectedKnots) = 1) or (uKnotPickets.KnotSize.Enabled) then
    begin
      KnotPoints[N].BoxSize  := FKnotPickets.KnotSz;
      KnotPoints[N].BoxSize2 := FKnotPickets.KnotSz2;
      KnotPoints[N].BoxAngle := FKnotPickets.KnotA;
    end;

    KnotPoints[N].NameKind2 := FKnotPickets.pkt_NameKind2;

    if  KnotPoints[N].PMethod <> 2 then
      if  FKnotPickets.pkt_Drop then
        KnotPoints[N].RouteN  := FKnotPickets.pkt_RouteN;

    KnotPoints[N].DropToRoute := FKnotPickets.pkt_Drop;
    KnotPoints[N].StepOut :=  FKnotPickets.pkt_N;
end;

procedure TFKnotPickets.PktApplySet;
begin
  pkt_PMethod := PktMethod.ItemIndex;
  PktPages.ActivePageIndex := PktMethod.ItemIndex;

  pkt_StartA  := 0; //!
  pkt_N := 0;
  case pkt_PMethod of
   0: begin
      pkt_Lx := L1.Value;
      pkt_Ly := 0;
      if IHalf.Checked then
         pkt_Ly := 1;
      pkt_Drop := (RDrop.Checked) and (RouteBox.ItemIndex >=0);
      pkt_RouteN :=  RouteBox.ItemIndex;
   end;
   1: begin
      pkt_Lx := L2x.Value;
      pkt_Ly := L2y.Value;
      pkt_Drop := not Drop2.Checked;
   end;
   2: begin
      pkt_Lx := L3.Value;
      pkt_Ly := a3.Value;
      pkt_Drop := DoRang.Checked;
   end;
   3: begin
      pkt_Lx := L4x.Value;
      pkt_Ly := L4y.Value;
      pkt_N  := a4.Value;
   end;
   4: begin
      pkt_Lx := Scale5.Value;
      pkt_Ly := a5.Value;
      pkt_N  := PktTemplates.ItemIndex;
      pkt_Drop := not Drop5.Checked;
   end;
  end;

  pkt_Lmax := Lmax.Value;
  pkt_NameKind1 := Knk.ItemIndex;
  pkt_NameKind2 := Knk2.ItemIndex;

  if (uKnotPickets.SetRtAng.Visible) and (uKnotPickets.SetRtAng.Enabled) then
      pkt_RouteA := uKnotPickets.SetRtAng.Value*pi/180;

  Label14.Visible := not ( (pkt_PMethod = 0)and(pkt_Drop) or (pkt_PMethod = 1)and(pkt_Drop = false) );
  SetRtAng.Visible :=  Label14.Visible;

  if FKnotPickets.HideRt then
    KnotA  := uKnotPickets.SetKnAng.Value*pi/180
  else
    if FKnotPickets.KnotAngRoute.Checked then
      KnotA  := + 1.107
    else
      if FKnotPickets.KnotAngAdd.Checked then
         KnotA  := uKnotPickets.KnotAng.Value*pi/180 + 1.107
      else
         KnotA  := uKnotPickets.KnotAng.Value*pi/180 ;
   KnotSz  := uKnotPickets.KnotSize.Value;
   KnotSz2 := uKnotPickets.KnotSize2.Value;
  ApplyMyKnot;
end;

procedure TFKnotPickets.PktBoxClick(Sender: TObject);
begin
 bUp.Enabled := PktBox.ItemIndex >= 1;
 bDown.Enabled := (PktBox.ItemIndex >= 0)
                  and (PktBox.ItemIndex < PktBox.Count-1);
 bDel.Enabled := (PktBox.ItemIndex >= 0);
 //CoordPC.Enabled := (PktBox.ItemIndex >= 0);
 bSort.Enabled := PktBox.Count > 0;

 if PktBox.ItemIndex = -1 then
   exit;

 Choosing := true;
 case isSq.Checked of
     true: begin
       pX.Value := round(EdPickets[PktBox.ItemIndex].x*1000)/1000;
       pY.Value := round(EdPickets[PktBox.ItemIndex].y*1000)/1000;
    end;
     false: begin
       pL.Value := round(1000*sqrt(sqr(EdPickets[PktBox.ItemIndex].x)
                             + sqr(EdPickets[PktBox.ItemIndex].y)))/1000;
       pA.Value := round(1000*Arctan2(EdPickets[PktBox.ItemIndex].x,
                                  EdPickets[PktBox.ItemIndex].y)*180/pi)/1000;
       if pA.Value < 0 then
         pA.Value := pA.Value + 360;
     end;
 end;
 Choosing := false;
 NeedRepaint := true;

 if ClickingApply = false then
 Begin
   try
   OldPx := EdPickets[PktBox.ItemIndex].x;
   OldPy := EdPickets[PktBox.ItemIndex].y;
   except
   end;
   bCancel.Enabled := false;
   ClickingApply := false;
 End
 Else
   bCancel.Enabled := true;

 bApply.Enabled := false;
 
end;

procedure TFKnotPickets.PktBoxDblClick(Sender: TObject);
begin
 if PktBox.ItemIndex = -1 then
   exit;

   xL := EdPickets[PktBox.ItemIndex].x;
   yL := EdPickets[PktBox.ItemIndex].y;
   NeedRepaint := true;
end;

procedure TFKnotPickets.PktBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = vk_Delete then
    BDel.Click;
 RepaintImg;   
end;

procedure TFKnotPickets.PktConfirm;
var I:Integer;
begin

  case HideRT of

     false: begin
       MapFm.Label24.Caption := PktMethod.Text;
       MapFm.Label25.Caption := IntToStr(PktCount);

       MapFm.KnotAngRoute.Checked := KnotAngRoute.Checked;
       MapFm.KnotAngOwn.Checked := KnotAngOwn.Checked;
       MapFm.KnotAngAdd.Checked := KnotAngAdd.Checked;
       MapperFm.KnotAng.Value := KnotAng.Value;

       case Mapfm.NCPC.ActivePageIndex of
          0: MapperFm.KnotSize.Value := KnotSize.Value;
          1: MapperFm.KnotAreaRadius.Value := KnotSize.Value;
       end;
       
       MapFm.KnotNames.ItemIndex := Knk.ItemIndex;
       MapFm.KnotNames.OnChange(nil);
     end;


     true:  begin
       // 1) �������� �� ������
       MapFm.Label26.Caption := PktMethod.Text;
       MapFm.Label28.Caption := IntToStr(PktCount);

       // 2) �������� ��������� ��������� ������
       for I := 0 to Length(SelectedKnots) - 1 do
          ApplyKnot(SelectedKnots[I]);

       if (Length(SelectedKnots) = 1) or (MapperFm.SetKnSize.Enabled) then
       begin
         MapperFm.SetKnSize.Value := KnotSize.Value;
         MapperFm.SetKnSize2.Value := KnotSize2.Value;
         MapperFm.SetKnAng.Value  := SetKnAng.Value;
       end;

       MapFm.Label26.Font.Color := clWindowText;
       MapFm.Label28.Font.Color := clWindowText;
       //MapFm.SetKnNameKind.ItemIndex  := Knk.ItemIndex;
       //MapFm.SetKnNameKind.Font.Color := clWindowText;

     end;
  end;
end;

procedure TFKnotPickets.MakeFloatSpins;

 procedure ChangeToSpin(FormI, ObjI: Integer);
 var SPF :TFloatSpinEdit; s, s2:string; o:TWinControl; i:integer;
     e1, e2 : TNotifyEvent;
 begin
    if Application.Components[FormI] is TForm then
    with Application.Components[FormI] as TForm Do
    Try
      for I := 0 to ComponentCount - 1 do
      if Components[I] is TFloatSpinEdit then
      BEGIN
          s  := TSpinEdit(Components[ObjI]).Name;
          s2 := TFloatSpinEdit(Components[I]).Name;

          if AnsiLowerCase(s2) = AnsiLowerCase(Copy(s, 1, length(s)-1)) then
          begin
             o := TSpinEdit(Components[ObjI]).Parent;
             e1 := TSpinEdit(Components[ObjI]).OnClick;
             e2 := TSpinEdit(Components[ObjI]).OnChange;
             TFloatSpinEdit(Components[I]).Left := TSpinEdit(Components[ObjI]).Left;
             TFloatSpinEdit(Components[I]).Top := TSpinEdit(Components[ObjI]).Top;
             TFloatSpinEdit(Components[I]).Width := TSpinEdit(Components[ObjI]).Width;
             TFloatSpinEdit(Components[I]).Height := TSpinEdit(Components[ObjI]).Height;
             TFloatSpinEdit(Components[I]).Value := TSpinEdit(Components[ObjI]).Value;
             TFloatSpinEdit(Components[I]).MinValue := TSpinEdit(Components[ObjI]).MinValue;
             TFloatSpinEdit(Components[I]).MaxValue := TSpinEdit(Components[ObjI]).MaxValue;
             TFloatSpinEdit(Components[I]).Increment := TSpinEdit(Components[ObjI]).Increment;
             if o <> nil then
               TFloatSpinEdit(Components[I]).Parent := o;

             TFloatSpinEdit(Components[I]).OnClick := e1;
             TFloatSpinEdit(Components[I]).OnChange := e2;
            TSpinEdit(Components[ObjI]).Hide;
            Break;
          end;
       END;

    Except
      Showmessage('Extended spin error');
    End;
 end;



const A :Array [0..18] of String = ('KnotSize_', 'SetKnAng_', 'SetRtAng_',
  'KnotAng_', 'l1_', 'l2x_', 'l2y_', 'l3_', 'a3_', 'l4x_', 'l4y_', 'a5_', 'Scale5_',
  'Lmax_', 'pA_', 'pL_', 'pX_', 'pY_','KnotSize2_');

var I, j, k :Integer;
begin


   for i := 0 to Application.ComponentCount - 1 do
     if Application.Components[I] is TForm then
     begin
        if Application.Components[I].Name <> Name then
          continue
        else
        begin
          with Application.Components[I] as TForm Do
          Begin
            KnotSize := TFloatSpinEdit.Create(self);  KnotSize.Name := 'KnotSize';
            SetKnAng := TFloatSpinEdit.Create(self);  SetKnAng.Name := 'SetKnAng';
            SetRtAng := TFloatSpinEdit.Create(self);  SetRtAng.Name := 'SetRtAng';
            KnotAng := TFloatSpinEdit.Create(self);   KnotAng.Name := 'KnotAng';
            l1 := TFloatSpinEdit.Create(self);        l1.Name := 'l1';
            l2x := TFloatSpinEdit.Create(self);       l2x.Name := 'l2x';
            l2y := TFloatSpinEdit.Create(self);       l2y.Name := 'l2y';
            l3 := TFloatSpinEdit.Create(self);        l3.Name  := 'l3';
            a3 := TFloatSpinEdit.Create(self);        a3.Name  := 'a3';
            l4x := TFloatSpinEdit.Create(self);       l4x.Name := 'l4x';
            l4y := TFloatSpinEdit.Create(self);       l4y.Name := 'l4y';
            a5 := TFloatSpinEdit.Create(self);        a5.Name  := 'a5';
            Scale5 := TFloatSpinEdit.Create(self);    Scale5.Name := 'Scale5';
            Lmax := TFloatSpinEdit.Create(self);      Lmax.Name := 'Lmax';
            pA := TFloatSpinEdit.Create(self);        pA.Name := 'pA';
            pL := TFloatSpinEdit.Create(self);        pL.Name := 'pL';
            pX := TFloatSpinEdit.Create(self);        pX.Name := 'pX';
            pY := TFloatSpinEdit.Create(self);        pY.Name := 'pY';

            pX.OnKeyDown := pX_.OnKeyDown; pY.OnKeyDown := pX_.OnKeyDown;
            pA.OnKeyDown := pX_.OnKeyDown; pL.OnKeyDown := pX_.OnKeyDown;

            KnotSize2 := TFloatSpinEdit.Create(self);  KnotSize2.Name := 'KnotSize2';

            for k := 0 to Length(A)-1 do
            for j := 0 to ComponentCount - 1 do
            begin
              if Components[J] is TSpinEdit then
                if AnsiLowerCase(Components[J].Name) = AnsiLowerCase(A[k]) then
                begin
                   ChangeToSpin(I, J);
                   refresh;
                   break;
                end;
            end;
            break;
          end;
        end;
     end;

end;


procedure TFKnotPickets.PktMethodChange(Sender: TObject);
begin
  PktPages.ActivePageIndex := PktMethod.ItemIndex;
  Knk2.Enabled := (PktMethod.ItemIndex > 0 ) and (PktMethod.ItemIndex < 4);
  SpeedButton3.Click; NeedRepaint := true;
end;

procedure TFKnotPickets.pL_Change(Sender: TObject);
var I:Integer;
begin
//  if Choosing then
//    exit;
  ClickingApply := true;
  
  bApply.Enabled := false;  bCancel.Enabled := true;

  if PktBox.ItemIndex = -1 then
    exit;

  if (px.Text='') or (py.Text = '') or (pl.Text = '') or (pa.Text = '')then
    exit;

  I := PktBox.ItemIndex;

  OldPx := EdPickets[I].x;
  OldPy := EdPickets[I].y;
  case isSq.Checked of
     true: begin
       EdPickets[I].x := pX.Value;
       EdPickets[I].y := pY.Value;
     end;
     false: begin
       EdPickets[I].x := pL.Value*Sin(pA.Value*pi/180);
       EdPickets[I].y := pL.Value*Cos(pA.Value*pi/180);
     end;
  end;
  RefreshBox;
end;

procedure TFKnotPickets.PopPopup(Sender: TObject);
begin
  N2.Enabled := PktBox.ItemIndex >=0 ;
end;

procedure TFKnotPickets.px_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
    bApply.Click;
end;

procedure TFKnotPickets.RdropClick(Sender: TObject);
begin
 if RouteBox.Items.Count = 0 then
    RDrop.Checked := false
 else
   if RouteBox.ItemIndex = -1 then
      RouteBox.ItemIndex := 0;
 PktApplySet;
 ScaleGraphs;
end;

procedure TFKnotPickets.RefreshBox;
var I, j, x, y:Integer;
begin
   j := PktBox.ItemIndex;
   PktBox.Clear;

   for I := 0 to EdPicketsCount - 1 do
   begin
     case isSq.Checked of
       true: begin
         x := round(EdPickets[I].x);
         y := round(EdPickets[I].y);
       end;
       false: begin
         x := round( sqrt(sqr(EdPickets[I].x)
                             + sqr(EdPickets[I].y)));
         y := round( Arctan2(EdPickets[I].x,
                             EdPickets[I].y)*180/pi);
        end;
      end;

      PktBox.Items.Add('Pkt_'+FormatFloat('00', I+1)+' ('
                       +IntToStr(x)+', '+IntToStr(y)+')');
   end;

   if J > PktBox.Count-1 then
     J := PktBox.Count-1
   else
   if J < 0 then
     J := 0;

   PktBox.ItemIndex := j;
   PktBox.OnClick(nil);
   NeedRepaint := true;
end;

procedure TFKnotPickets.RefreshTmps;
var S: TstringList;
    I, j, Idx:Integer;
    new :Boolean;
begin
  S := TstringList.Create;

  try
    S.LoadFromFile(MyDir+'Data\Loops.loc');
    Idx := TmpBox.ItemIndex;
    TmpBox.Clear;
    PktTemplates.Clear;

    I:= 0;
    new:= true;
    if S.Count > 0 then
    repeat
      if New then
      begin
        TmpBox.Items.Add(S[I]);
        PktTemplates.Items.Add(S[I]);
        inc(I);
        New := false;
      end;

      if S[I]= '\\' then
         New := true;

      inc(I);
    until I>= S.Count-1;

  except
  end;

  if Idx=-1 then
    inc(Idx);
  if Idx > TmpBox.Items.Count-1 then
    Idx := TmpBox.Items.Count-1;

  TmpBox.ItemIndex:= Idx;
  LoadEpPkts(EdPicketsFileName , TmpBox.ItemIndex, 0);
  RefreshBox;
  S.Destroy;
end;

procedure TFKnotPickets.RenewKnotBox;
var I:Integer;
begin
   RouteBox.Clear;
   for I := 0 to RouteCount - 1 do
     RouteBox.Items.Add(Route[I].Name);
end;

procedure TFKnotPickets.RouteBoxChange(Sender: TObject);
begin
  PktApplySet;
  ScaleGraphs;
end;

procedure TFKnotPickets.SaveTemplates(N:Integer; Name:String);
var S: TstringList;
    I, j, I1, I2 :Integer;
    new :Boolean;
begin
  S := TstringList.Create;

  try
    S.LoadFromFile(MyDir+'Data\Loops.loc');
    S.SaveToFile(MyDir+'Data\Loops_backup.loc');
    I := 0;  I1 := 0;
    j := 0;
    new:= true;

 if N <= TmpBox.Items.Count-1 then
 begin
    if N > 0 then
    for I := 0 to S.Count - 1 do
       if S[I]= '\\' then
       begin
         inc(j);
         if j = N then
         begin
           I1 := I+1;
           break;
         end;
       end;

    I2 := S.Count-1;
    I := I1;
    repeat
      inc(I);
      if S[I]= '\\' then
      begin
         I2 := I;
         break;
      end;
      //inc(I);
    until (I>= S.Count-1) or (S[I]='\\');

    for I := I2 Downto I1 do
      S.Delete(I);

 end else
   begin
     I1 := S.Count;
     //S.Add('');
   end;


  S.Insert(I1, Name);
  inc(I1);
  S.Insert(I1, '\\');
  
  for I := 0 to EdPicketsCount - 1 do
  begin
    s.Insert(I1+I*2,   Floattostr(EdPickets[I].x));
    s.Insert(I1+I*2+1, Floattostr(EdPickets[I].y));
  end;

  except
  end;
  S.SaveToFile(MyDir+'Data\Loops.loc');
  RefreshBox;
  S.Destroy;

MainPC.ActivePageIndex := 0;
RefreshTmps;

end;

procedure TFKnotPickets.ShowNamesClick(Sender: TObject);
begin
  NeedRepaint := true;
end;

procedure TFKnotPickets.snamesClick(Sender: TObject);
begin
  inc(ShowNames);
  if Shownames >=3 then
    ShowNames := 0;
  snames.Glyph.Assign(nil);
  RedForm.ImageList1.GetBitmap(13+ShowNames,snames.Glyph);
  snames.Hint := inf[108+ShowNames];
  snames2.Glyph.Assign(nil);
  snames2.Glyph := snames.Glyph;
  snames2.Hint := inf[108+ShowNames];
  NeedRepaint := True;
end;

procedure TFKnotPickets.SpeedButton1Click(Sender: TObject);
begin
    Dec(ImgScale);

    if ImgScale < 5 then
       ImgScale := 5;
    NeedRepaint := true;
end;

procedure TFKnotPickets.SpeedButton2Click(Sender: TObject);
begin
    Inc(ImgScale);
    if ImgScale > MaxMashtab-1 then
       ImgScale := MaxMashtab-1;
    NeedRepaint := true;
end;

procedure TFKnotPickets.KnkChange(Sender: TObject);
begin
  NeedRepaint := true;

  if HideRt then
    if Knk.ItemIndex = 1 then
      Knk.ItemIndex := 0;

  case Knk.ItemIndex of
     0: KnEx.Caption := TestName + '_L001_Pkt';
     1: KnEx.Caption := 'Pr'+FormatFloat('000', MapFm.KnotStart.Value)+
                        '_L'+FormatFloat('000', TestL)+'_Pkt';
     2: KnEx.Caption := 'L'+FormatFloat('000', TestL)+'_Pkt';
     3: KnEx.Caption := FormatFloat('000', TestL)+'_P';
     4: KnEx.Caption := FormatFloat('000', TestL)+'_';
  end;

  case PktMethod.ItemIndex of
    1..3:
    case Knk2.ItemIndex of
      0: KnEx.Caption := KnEx.Caption + '01';
      1: KnEx.Caption := KnEx.Caption + '0101';
      2: KnEx.Caption := KnEx.Caption + '01-01';
    end;
    else KnEx.Caption := KnEx.Caption + '01';
  end;

  //Knk2.Visible := ((PktMethod.ItemIndex > 0) and (PktMethod.ItemIndex < 4));

  MapFm.SetKnNameKind.ItemIndex  := Knk.ItemIndex;
  MapFm.SetKnNameKind.Font.Color := clWindowText;
  MapFm.SetKnNameKind.OnChange(nil);

  PktApplySet;
  GetKnotPickets(MyKnot, not HideRT);
end;

procedure TFKnotPickets.T7Show(Sender: TObject);
var Idx:Integer;
begin
  Idx := PktTemplates.ItemIndex;
  if Idx=-1 then
    Idx := 0;
  RefreshTmps;
  PktTemplates.ItemIndex := Idx;
end;

procedure TFKnotPickets.TabSheet1Show(Sender: TObject);
var I:Integer;
begin
 if RouteBox.Items.Count = 0 then
   RDrop.Checked := false;
end;

procedure TFKnotPickets.Timer1Timer(Sender: TObject);
begin
 If needRepaint = false then
     exit;

 RepaintImg;
end;

procedure TFKnotPickets.TmpBoxChange(Sender: TObject);
begin
  if TmpBox.ItemIndex >= 0 then
  begin
    LoadEpPkts(EdPicketsFileName, TmpBox.ItemIndex, 0);
    RefreshBox;
    SpeedButton3.Click;
  end;
end;

end.
