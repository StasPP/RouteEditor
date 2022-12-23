unit MapFunctionsC;

interface

uses Windows, PointClasses;

  function BoxInBox(Rx, Ry: array of double; x1, y1, x2, y2: Double): boolean;
  function PointInBox(Rx, Ry: array of double; x, y: Double): boolean;
  function MapPointInBox(Rx, Ry: array of double; x, y: Double): boolean;
  function IsPIn_Vector(aAx, aAy, aBx, aBy, aCx, aCy, aPx, aPy: single): boolean;

  function MyPoint(x, y:Double):TMyPoint;

  procedure AxcelScale(TimerDelta: Double);
  procedure ShiftMap(Key: Byte);

  function MapToScreen(x, y, x0, y0, FalseY0, Scale, fi : Double):TMyPoint; overload;
  function MapToScreen(x,y: Double): TMyPoint;  overload;
  function MapToScreenRound(x, y: Double): TPoint;

  function ScreenToMap(x, y, x0, y0, FalseY0, Scale, fi : Double):TMyPoint; overload;
  function ScreenToMap(x, y: Double):TMyPoint;  overload;

  procedure CutLineByFrame(var x, y, x2, y2: Double);

  const

  MaxMashtab_ = 14;
  MaxMashtab = 18;
  TMashtab : Array [0.. MaxMashtab-1] of Real =
                    (0.01, 0.02, 0.05,
                     0.1, 0.2, 0.5,
                     1.0, 2.0, 5.0,
                     10.0, 20.0, 50.0,
                     100.0, 200.0, 500.0,
                     1000.0, 2000.0, 5000.0);
  var

  /// Screen
  DispSize :TPoint;

   /// Map
  Center    :TMyPoint;
  Scale     :Double =1;
  _Scale    :Double =1;
  Fi        :Double = 0;    /// MapRotation
  Mashtab   :Integer = 10;
  VshiftY   :Integer = 0;
  ClickMode :integer = 1;
  MKeyShift :TMyPoint;
  MShift, CanvCursor :TPoint;
  CanvCursorBL       :TLatLong;

  /// Projection
  UTM          :Boolean = true;
  South        :Boolean = false;
  MyZone       :Integer = 14;
  WaitForZone  :Boolean = true;
  WaitForCenter:Boolean = true;
  WGS, SK      :Integer;

implementation


procedure CutLineByFrame(var x, y, x2, y2: Double);
begin
  if not( (x < 0) and (x2 < 0)) then
  if not( (x > DispSize.X) and (x2 > DispSize.X)) then
  if not( (y < 0) and (y2 < 0)) then
  if not( (y > DispSize.y) and (y2 > DispSize.y)) then
  if not( (abs(y-y2) < 1) and (abs(x-x2) < 1) ) then
  Begin
    if x < 0 then
    begin
      if abs(x2-x) > 0 then
        y := round( ((-x)/(x2-x))*(y2-y)+y)
          else
            y := y2;
      x := 0;
    end
      else
       if x > DispSize.X then
       begin
          if abs(x2-x) > 0 then
              y := round(((DispSize.X-x)/(x2-x))*(y2-y)+y)
               else
                 y := y2;
          x := DispSize.X;
       end;

    if x2 < 0 then
    begin
      if abs(x2-x) >0 then
        y2 := round(((-x)/(x2-x))*(y2-y)+y)
          else
            y2 := y;
      x2 := 0;
    end
      else
       if x2 > (DispSize.X) then
       begin
          if abs(x2-x) > 0 then
              y2 := round(((DispSize.X-x)/(x2-x))*(y2-y)+y)
               else
                 y2 := y;
          x2 := DispSize.X;
       end;

    if y < 0 then
    begin
      if abs(y2-y)>0 then
          x := round(((-y)/(y2-y))*(x2-x)+x)
          else
            x := x2;
      y := 0;
    end
      else
       if y > DispSize.y then
       begin
          if abs(y2-y) > 0 then
               x := round(((DispSize.y-y)/(y2-y))*(x2-x)+x)
               else
                 x := x2;
         y := DispSize.y;
       end;

   if y2 < 0 then
    begin
      if abs(y2-y) > 0 then
          x2 := round(((-y)/(y2-y))*(x2-x)+x)
          else
            x2 := x;
      y2 := 0;
    end
      else
       if y2 > DispSize.y then
       begin
          if abs(y2-y) > 0 then
               x2 := round(((DispSize.y-y)/(y2-y))*(x2-x)+x)
               else
                 x2 := x;
         y2 := DispSize.y;
       end;
  End;
end;

/// Geo

{procedure CheckMyZone(x, y:Double, UTM: Boolean);
const ZoneW = 6;

  function GetMyZoneCenter:integer;
  var Linit:integer;
      Lo   :integer;
  begin
     if UTM then
        Linit := 30
         else
           Linit := 0;
     Result := Zone*ZoneW-ZoneW/2+Linit;
  end;

  function GetMinX:integer;
  begin

  end;

  function GetMaxX:integer;
  begin

  end;

begin
 if X>MaxX then
 Begin
   inc(MyZone);
   RecomputeBasicObjects(False);
 End;

 
end; }


/// Math

function IsPIn_Vector(aAx, aAy, aBx, aBy, aCx, aCy, aPx, aPy: single): boolean;
var
  Bx, By, Cx, Cy, Px, Py : single;
  m, l : single; // мю и лямбда
begin
  Result := False;
  // переносим треугольник точкой А в (0;0).
  Bx := aBx - aAx; By := aBy - aAy;
  Cx := aCx - aAx; Cy := aCy - aAy;
  Px := aPx - aAx; Py := aPy - aAy;
  //
  m := (Px*By - Bx*Py) / (Cx*By - Bx*Cy);
  if (m >= 0) and (m <= 1) then
  begin
    l := (Px - m*Cx) / Bx;
    if (l >= 0) and ((m + l) <= 1) then
      Result := True;
  end;
end;

function MyPoint(x, y:Double):TMyPoint;
begin
  result.x := x;
  result.y := y;
end;

////// Scales

procedure AxcelScale(TimerDelta: Double);
const k = 1.5;
var Stp, ShiftStp : double;
begin
////
  _Scale  := TMashtab[Mashtab]/100;

  Stp := TimerDelta;

  if Stp > 5 then
     Stp := 5;
  if Stp < 0.25 then
     Stp := 0.25;

     Stp := 5*k/Stp;

  if Abs((Scale - _Scale)) > _Scale/100 then
     Scale := Scale - (Scale - _Scale)/Stp
     else
        Scale := _Scale;


 if abs(MKeyShift.X*Scale) > 1  then
 Begin
  ShiftStp := MKeyShift.X/Stp;
  MKeyShift.X := MKeyShift.X - ShiftStp;
  Center.x := Center.x - MKeyShift.X*Scale;
 End;

 if abs(MKeyshift.Y*Scale) > 1  then
 Begin
  ShiftStp := MKeyShift.Y/Stp;
  MKeyShift.Y := MKeyShift.Y - ShiftStp;
  Center.y := Center.y + MKeyShift.Y*Scale;
 End;

end;

procedure ShiftMap(Key: Byte);
begin

  case Key of
   0: if Mashtab < MaxMashtab-1 then
          Inc(Mashtab);
   1: if Mashtab > 0 then
          Dec(Mashtab);

   2:  mKeyShift.Y := DispSize.y *0.05;
   3:  mKeyShift.Y := -DispSize.y *0.05;
   4:  mKeyShift.X := DispSize.y*0.05;
   5:  mKeyShift.X := -DispSize.y*0.05;

 end;
end;

function BoxInBox(Rx, Ry: array of double; x1, y1, x2, y2: Double): boolean;
var Xmin, Ymin, Xmax, Ymax, i: Double;
    j: integer;
begin

       xmin := Rx[0];
       ymin := Ry[0];
       xmax := Rx[0];
       ymax := Ry[0];

       for j := 1 to 3 do
       begin
         if Rx[j] < xmin then
           xmin := Rx[j];
         if Ry[j] < ymin then
           ymin := Ry[j];

         if Rx[j] > xmax then
           xmax := Rx[j];
         if Ry[j] > ymax then
           ymax := Ry[j];
       end;

       if x1 > x2  then
       begin
         i := x2;
         x2 := x1;
         x1 := i;
       end;

       if y1 > y2  then
       begin
         i  := y2;
         y2 := y1;
         y1 := i;
       end;

   result := ((xmin < x2) and (xmax > x1) and (ymin < y2) and (ymax > y1)) or
             ((xmin > x1) and (xmax < x2) and (ymin > y1) and (ymin < y2));


  //
 //  result := (xmin > x1) and (xmax < x2) and (ymin > y1) and (ymax < y2) ;
end;

function PointInBox(Rx, Ry: array of double; x, y: Double): boolean;
var Xmin, Ymin, Xmax, Ymax: Double;
    j: integer;
begin
     {
       xmin := Rx[1];
       ymin := Ry[1];
       xmax := Rx[1];
       ymax := Ry[1];

       for j := 1 to 3 do
       begin
         if Rx[j] < xmin then
           xmin := Rx[j];
         if Ry[j] < ymin then
           ymin := Ry[j];

         if Rx[j] > xmax then
           xmax := Rx[j];
         if Ry[j] > ymax then
           ymax := Ry[j];

       end;

      for j := 0 to 3 do
       Begin
          Rx[j] := Rx[j] - xmin;
          Ry[j] := Ry[j] - ymin;
       End;
       x := x - xmin;
       y := y - ymin;  

     result := false;
     if (x > xmin) and (x < xmax) then
     if (y > ymin) and (y < ymax) then }

      result :=  IsPIn_Vector(Rx[0], Ry[0], Rx[1], Ry[1], Rx[2], Ry[2],  x, y)
              or IsPIn_Vector(Rx[2], Ry[2], Rx[1], Ry[1], Rx[3], Ry[3],  x, y);
end;

function MapPointInBox(Rx, Ry: array of double; x, y: Double): boolean;
var Xmin, Ymin, Xmax, Ymax: Double;
    j: integer;
begin
      result :=  IsPIn_Vector(Rx[0], Ry[0], Rx[2], Ry[2], Rx[1], Ry[1],  x, y)
              or IsPIn_Vector(Rx[0], Ry[0], Rx[3], Ry[3], Rx[2], Ry[2],  x, y);
end;


////// Screen x,y to X,Y to B,L

function ScreenToMap(x, y, x0, y0, FalseY0, Scale, fi : Double):TMyPoint;
var x2, xm, ym : double;
begin
   try
       xm :=  x - DispSize.X/2;
       ym := -y + DispSize.Y/2 + FalseY0;
       x2 := xm;

       xm := xm * Cos(fi) + ym * sin(fi);
       ym := ym * Cos(fi) - x2 * sin(fi);

       xm := xm * Scale + X0;
       ym := ym * Scale + Y0;

       Result.x := xm;
       Result.Y := ym;
   except
     Result.X := 0;
     Result.Y := 0;
   end;
end;

function ScreenToMap(x, y: Double):TMyPoint;  overload;
begin
  Result := ScreenToMap(X, Y,Center.X, Center.Y, VShiftY, Scale, fi);
end;

////////////// X,Y to Screen

function MapToScreen(x, y, x0, y0, FalseY0, Scale, fi : Double):TMyPoint;
var dx, dy, dx2, dy2 : double;
begin
   try
     dx := (x0 - x)/ Scale ;
     dy := (y0 - y)/ Scale ;

     dx2 := dx * Cos (Fi) + dy * Sin(Fi);
     dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

     Result.x := round (DispSize.X div 2 - dx2);
     Result.y := DispSize.y - round (DispSize.y div 2 - dy2) + FalseY0;
   except
     Result.X := 0;
     Result.Y := 0;
   end;
end;

function MapToScreen(x,y: Double): TMyPoint;
begin
  Result := MapToScreen(x, y, Center.X, Center.Y, VShiftY, Scale, fi);
end;

function MapToScreenRound(x, y: Double): TPoint;
var Point : TMyPoint;
begin
  Point := MapToScreen(x, y);
  Result.X := round(Point.X);
  Result.Y := round(Point.Y);
end;


//////////////////////////

end.
