unit ParUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, MapFunctionsC, ImgList, XPMan;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Timer1: TTimer;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    ListBox1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure ReDrawLeft;
    procedure ReDrawRight;

    procedure DrawLines(BitMap:TBitMap; x0, y0 : real);
    procedure DrawPoints(BitMap:TBitMap; x0, y0 : real; prj: integer);

    procedure Button1Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);

    procedure ScaleGraphs;
    function Filtered(s:String):String;
  private
    procedure AppOnMessage(var MSG :TMsg; var Handled :Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  NeedRepaint : Boolean;
  Buff1, Buff2 : TBitMap;

  LeftScale, RightScale :integer;
  xL, xR, yR, yL : Real;
  MoveMap, isMoveLeft: Boolean;
  mx, my : real;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  If needRepaint = false then
     exit;

  with Image1.Canvas do
  Begin

    /// LEFT SIDE
    ReDrawLeft;

    /// RIGHT SIDE
    ReDrawRight;



    /// Separator

    Pen.Color := ClBtnFace;
    Brush.Color := clBtnFace;
    Rectangle(Image1.Width div 2 - 2,0, Image1.Width div 2 + 2, Height);
  End;

  //NeedRepaint := ;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin

   NeedRepaint := true;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if image1<>nil then
  try
     if  Image1.Picture.Bitmap.Height <>  Image1.Height then
         Image1.Picture.Bitmap.Height:=Image1.Height;
     if  Image1.Picture.Bitmap.Width <>  Image1.Width then
         Image1.Picture.Bitmap.Width:=Image1.Width;
   except
   end;
   NeedRepaint := true;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  NeedRepaint := true;

  if ListBox1.Focused then
    exit;
  if (mY > 0) and(mY < Image1.Height) then
  if WheelDelta < 0 then
  BEGIN
    if mX < Image1.Width div 2 then
       Inc(LeftScale)
       else
         Inc(RightScale);

    if LeftScale > MaxMashtab-1 then
       LeftScale := MaxMashtab-1;

    if RightScale > MaxMashtab-1 then
       RightScale := MaxMashtab-1;

  END
   ELSE 
  BEGIN
    if mX < Image1.Width div 2 then
       Dec(LeftScale)
       else
         Dec(RightScale);

    if LeftScale < 0 then
       LeftScale := 0;

    if RightScale < 0 then
       RightScale := 0;

  END;

end;

procedure TForm1.FormCreate(Sender: TObject);
var I:Integer;
begin
  Application.OnMessage := AppOnMessage;

  DoubleBuffered := true;
  NeedRepaint := true;

  Buff1 := TbitMap.Create;
  Buff2 := TbitMap.Create;

  Image1.Parent.DoubleBuffered := true;

   for I := 0 to ComponentCount-1 do
    if Components[I] is TPanel  then
      TPanel(Components[I]).ControlStyle := ControlStyle-[csParentBackGround];
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Buff1.Free;
 Buff2.Free;
end;

procedure TForm1.ReDrawLeft;
begin
  //
  Mashtab := LeftScale;
  with Buff1.Canvas Do
  Begin
    Buff1.Width := Image1.Width div 2-2;
    Buff1.Height := Image1.Height;
    DispSize.X := Buff1.Width;
    DispSize.Y := Buff1.Height;
    DrawLines(Buff1, XL, YL);
    DrawPoints(Buff1, XL, YL,0);
  End;
  Image1.Canvas.CopyRect(Rect(0,0, Buff1.Width, Buff1.Height), Buff1.Canvas,Rect(0,0, Buff1.Width, Buff1.Height));

end;

procedure TForm1.ReDrawRight;
begin
  //
  Mashtab := RightScale;
  with Buff2.Canvas Do
  Begin
    Buff2.Width := Image1.Width div 2-2;
    Buff2.Height := Image1.Height;
    DispSize.X := Buff2.Width;
    DispSize.Y := Buff2.Height;
    DrawLines(Buff2, XR, YR);
    DrawPoints(Buff2, XR, YR, 1);
  End;
  image1.Canvas.CopyRect(Rect(Image1.Width - Buff2.Width, 0, Image1.Width, Buff2.Height),Buff2.Canvas,Rect(0,0, Buff2.Width, Buff2.Height));
end;

procedure TForm1.DrawLines(Bitmap: TBitMap; x0, y0 :real);
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


    Bitmap.Canvas.Pen.Color := ClBlack;

    Bitmap.Canvas.MoveTo(BitMap.Width - 110, BitMap.Height - 10);
    Bitmap.Canvas.LineTo(BitMap.Width - 10, BitMap.Height - 10);
    Bitmap.Canvas.MoveTo(BitMap.Width - 110, BitMap.Height - 10);
    Bitmap.Canvas.LineTo(BitMap.Width - 110, BitMap.Height - 20);
    Bitmap.Canvas.MoveTo(BitMap.Width - 10, BitMap.Height - 10);
    Bitmap.Canvas.LineTo(BitMap.Width - 10, BitMap.Height - 20);

    if TMashtab[Mashtab]<1 then
      s :=  format('%2f',[TMashtab[Mashtab]])  + ' m'
      else
      if TMashtab[Mashtab]<1000 then
        s := IntTostr(trunc(TMashtab[Mashtab])) + ' m'
        else
          s := IntTostr(trunc(TMashtab[Mashtab]) div 1000) + ' km';

    Bitmap.Canvas.TextOut( trunc(BitMap.Width - 60 - Bitmap.Canvas.TextWidth(s)/2),
                           BitMap.Height - 30,
                              s);


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    NeedRepaint := true;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var dx,dy, sc :real;
    P: TMyPoint;
begin
  if ListBox1.Focused then
    Edit1.SetFocus;

  if (MoveMap = false)and(x < Image1.Width div 2) or (MoveMap) and (isMoveLeft) then
  begin
    sc := TMashtab[leftScale]/100;
    P := ScreenToMap( X, Y, XL, YL, 0, Sc, 0);

    if Sc <1 then
       Label4.Caption := format('%3f',[P.x])+' ; '+ format('%3f',[P.y])
       else
       Label4.Caption := IntToStr(trunc(P.x))+' ; '+ IntToStr(trunc(P.y));
  end
    else
    begin
       sc := TMashtab[RightScale]/100;
       P := ScreenToMap( X-Image1.Width div 2, Y, XR, YR, 0, Sc, 0);
       if Sc <1 then
       Label4.Caption := format('%3f',[P.x])+' ; '+ format('%3f',[P.y])
         else
           Label4.Caption := IntToStr(trunc(P.x))+' ; '+ IntToStr(trunc(P.y));
    end;



  if  MoveMap then
  begin
    if isMoveLeft then
      sc := TMashtab[leftScale]/100
       else
         sc := TMashtab[RightScale]/100;

    dx := (mx-x)*Sc;
    dy := (my-y)*Sc;

    if isMoveLeft then
    begin
       xL := xL + dx;
       yL := yL - dy;
    end
     else
      begin
        xR := xR + dx;
        yR := yR - dy;
      end;


    mx := x;
    my := y;
  end;

   mx := x;
   my := y;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MoveMap := false;
  Image1.Cursor := crCross;
  Screen.Cursor := crDefault;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Cursor := crSizeAll;
  Screen.Cursor := crSizeAll;
  MoveMap := true;
  mx := x;
  my := y;
  isMoveLeft := mx < Image1.Width div 2;
end;

procedure TForm1.DrawPoints(BitMap: TBitMap; x0, y0: real; prj: integer);
var P, P2: TMyPoint;
    dx, dy, dh : real;
    S, S2: String;
begin
  P := MapToScreen(0, 0, X0, Y0, 0, Scale, 0);
  ImageList1.Draw(Bitmap.Canvas, trunc(P.x)-8, trunc(P.y)-8, 0);

  
  try
    Dx := StrToFloat(Edit1.Text);
  except
    Dx := 0;
    Edit1.Text := '0';
  end;

  try
    Dy := StrToFloat(Edit2.Text);
  except
    Dy := 0;
    Edit2.Text := '0';
  end;

  try
    Dh := StrToFloat(Edit3.Text);
  except
    Dh := 0;
    Edit3.Text := '0';
  end;


     case prj of

      0: begin
        ImageList1.Draw(Bitmap.Canvas, 6, Bitmap.Height-20, 6);
        ImageList1.Draw(Bitmap.Canvas, 6, Bitmap.Height-38, 7);
        ImageList1.Draw(Bitmap.Canvas, 24, Bitmap.Height-18, 8);

        S := Edit1.text;   S2 := Edit2.text;

        P2 := MapToScreen(dy, dx, X0, Y0, 0, Scale, 0);
        ImageList1.Draw(Bitmap.Canvas, trunc(P2.x)-8, trunc(P2.y)-8, 1);

      end;

      1: begin
        ImageList1.Draw(Bitmap.Canvas, 12, Bitmap.Height-20, 10);
        ImageList1.Draw(Bitmap.Canvas, 24, Bitmap.Height-38, 9);
        ImageList1.Draw(Bitmap.Canvas, 4, Bitmap.Height-18, 7);

        S2 := Edit1.text;   S := Edit3.text;

        P2 := MapToScreen(-dx, dh, X0, Y0, 0, Scale, 0);
        ImageList1.Draw(Bitmap.Canvas, trunc(P2.x)-8, trunc(P2.y)-8, 1);

      end;

      2: begin
        ImageList1.Draw(Bitmap.Canvas, 12, Bitmap.Height-20, 10);
        ImageList1.Draw(Bitmap.Canvas, 24, Bitmap.Height-38, 9);
        ImageList1.Draw(Bitmap.Canvas, 4, Bitmap.Height-18, 8);

        S2 := Edit2.text;   S := Edit3.text;

        P2 := MapToScreen(-dy, dh, X0, Y0, 0, Scale, 0);
        ImageList1.Draw(Bitmap.Canvas, trunc(P2.x)-8, trunc(P2.y)-8, 1);

      end;
    end;


    if P.x < -1 then p.x := -1;
    if P.x  > Bitmap.Width then p.x := BitMap.Width;
    if P2.x < -1 then p2.x := -1;
    if P2.x  > Bitmap.Width then p2.x := BitMap.Width;

    if P.y < -1 then p.y := -1;
    if P.y  > Bitmap.Height then p.y := BitMap.Height;
    if P2.y < -1 then p2.y := -1;
    if P2.y  > Bitmap.Height then p2.y := BitMap.Height;

    dx := Bitmap.Canvas.TextWidth(S2) ;
    dy := Bitmap.Canvas.TextWidth(S) ;
    Bitmap.Canvas.Font.Color := clBlue;
    Bitmap.Canvas.Pen.Color := clBlue;

    //Bitmap.Canvas.Pen.Style := psDot;
    IF Abs(P.y - P2.y) > 8 then
    Begin
      Bitmap.Canvas.MoveTo(trunc(P.x),trunc(P.y));
      Bitmap.Canvas.LineTo(trunc(P.x),trunc(P2.y));
      if p.x < p2.x then
        Bitmap.Canvas.TextOut(trunc(P.x - dy - 2) , trunc(P.y + P2.y) div 2 - 5 ,S)
        else
          Bitmap.Canvas.TextOut(trunc(P.x + 2) , trunc(P.y + P2.y) div 2 - 5 ,S)
    End;

    IF Abs(P.x - P2.x) > 8 then
    Begin
      Bitmap.Canvas.MoveTo(trunc(P.x),trunc(P2.y));
      Bitmap.Canvas.LineTo(trunc(P2.x),trunc(P2.y));

      if p.y > p2.y then
       Bitmap.Canvas.TextOut(trunc(P.x + P2.x - dx) div 2,trunc(P2.y)-14 ,S2)
        else
          Bitmap.Canvas.TextOut(trunc(P.x + P2.x - dx) div 2,trunc(P2.y)+2 ,S2)
    End;

    Bitmap.Canvas.Font.Color := clBlack;
    Bitmap.Canvas.Pen.Color := clBlack;

    Bitmap.Canvas.Pen.Style := psSolid;
end;

procedure TForm1.Edit1Change(Sender: TObject);
var I :integer;
begin
 I := Edit1.SelStart;
 Edit1.Text := Filtered(Edit1.Text);
 Edit1.SelStart := I;

 ScaleGraphs;
end;

procedure TForm1.Edit2Change(Sender: TObject);
var I :integer;
begin
 I := Edit2.SelStart;
 Edit2.Text := Filtered(Edit2.Text);
 Edit2.SelStart := I;

 ScaleGraphs;
end;

procedure TForm1.Edit3Change(Sender: TObject);
var I :integer;
begin
 I := Edit3.SelStart;
 Edit3.Text := Filtered(Edit3.Text);
 Edit3.SelStart := I;
 
 ScaleGraphs;
end;

function TForm1.Filtered(s: String): String;
var I: Integer;
   DecSep: Boolean;
Begin
 Result := '';

 DecSep := false;
 for I := 1 To Length(S) do
 Begin
   case Ord(S[i]) of
     48..57 : Result := Result + S[I];
   end;

   if (S[i] = '-') and (i = 1) then
       Result := '-';


   if (S[i] = '.') or (S[i] = ',') then
     if not DecSep then
     Begin
       Result := Result + DecimalSeparator;
       DecSep := true;
     End;
 End;
end;

procedure TForm1.AppOnMessage(var MSG: TMsg; var Handled: Boolean);
begin

  if (ListBox1.Focused) then
    exit;

  if MSG.message = WM_MOUSEWHEEL then
  Begin
    Handled := true;
    Perform(WM_MOUSEWHEEL,MSG.wParam,0);
  End;

 {  if MSG.message = WM_KEYDOWN then
  Begin
    Handled := true;
    Perform(WM_KEYDOWN,MSG.wParam,0);
  End; }
end;

procedure TForm1.ScaleGraphs;
var I : Integer;
begin

 XL := 0; YL := 0;   LeftScale  := 0;
 XR := 0; YR := 0;   Rightscale := 0;

 try
   for I := 0 To MaxMashtab-2 do
     if Abs(StrToFloat(Edit1.Text)) > TMashtab[I] then
     begin
        if LeftScale < I+1 then
          Leftscale := I+1;
        if RightScale < I+1 then
           Rightscale := I+1;
     end
         else
          break;
 except
 end;

 try
   for I := LeftScale To MaxMashtab-2 do
      if Abs(StrToFloat(Edit2.Text)) > TMashtab[I] then
      begin
         if LeftScale < I+1 then
            Leftscale := I+1
      end
         else
          break;
 except
 end;

 try
   for I := RightScale To MaxMashtab-2 do
     if Abs(StrToFloat(Edit3.Text)) > TMashtab[I] then
     begin
       if RightScale < I+1 then
          Rightscale := I+1;
     end
         else
          break;
 except
 end;
 
end;

end.
