unit DubinsPath;

// Станислав Шевчук для RouteNav, 2021

interface

uses Math;

type TTurnPoint = record
   x, y :Double;
end;

function DubinsLSR(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
function DubinsLSL(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
function DubinsRSR(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
function DubinsRSL(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
function DubinsLRL(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
function DubinsRLR(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;

function Dubins(x1, y1, a1, x2, y2, a2, r, astep  :Double;
                LSR, LSL, RSR, RSL, LRL, RLR :boolean):boolean;  overload;
function Dubins(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;  overload;
function Dubins(x1, y1, a1, x2, y2, a2, r  :Double):boolean;  overload;

(*
function OptimizedDubins(x1, y1, a1, x2, y2, a2 :Double):boolean;   *)

const
  MaxTPCount = 128;

var
   TurnPoints:array [0..MaxTPCount-1] of TTurnPoint;
   TPCount : Integer = 0;

implementation

/////////////////////////////////////////---------------------------------------

procedure AddLinePoints(x, y:Double); overload;
begin
   if TPCount < MaxTPCount-1 then
     inc(TPCount);
   TurnPoints[TPCount-1].x := x;        TurnPoints[TPCount-1].y := y;
end;

procedure AddLinePoints(T:TTurnPoint); overload;
begin
  AddLinePoints(T.x, T.y);
end;

procedure AddLinePoints(T1, T2 :TTurnPoint); overload;
begin
  AddLinePoints(T1);     AddLinePoints(T2);
end;

procedure AddCirclePoints(cur_a, next_a, cx, cy, r, step :Double; clockwise: boolean);
var
    I, j :Integer;
//const
   // step = pi/20;
begin
  while next_a - cur_a > 2*pi do
  begin
     next_a := next_a - 2*pi;
  end;
  while   cur_a - next_a> 2*pi do
  begin
     next_a := next_a + 2*pi;
  end;

  IF clockwise THEN
  BEGIN
    while next_a < cur_a do
       next_a := 2*pi + next_a;

    I := TPCount-1;
    while next_a > cur_a do
    begin
      cur_a := cur_a + step;
      if next_a < cur_a then
         cur_a := next_a;
      
      if I < MaxTPCount-1  then
        Inc(I);

      TurnPoints[I].x := cx + r*sin(cur_a);
      TurnPoints[I].y := cy + r*cos(cur_a);

      TPCount := I+1;
    end;

  END
   ELSE
   BEGIN
      while next_a > cur_a do
         next_a := -2*pi + next_a;

      I := TPCount-1;
      while cur_a > next_a do
      begin
        cur_a := cur_a - step;
        if cur_a < next_a then
          cur_a := next_a;

        if I < MaxTPCount-1  then
          Inc(I);

        TurnPoints[I].x := cx + r*sin(cur_a);
        TurnPoints[I].y := cy + r*cos(cur_a);

        TPCount := I+1;
      end;

   END;
  
end;

/////////////////////////////////////////---------------------------------------

function DubinsLSR(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
var L1, R2, a, Adot, u, v, T1, T2, RSL :TTurnPoint;
    _a, alfa :Double;
begin
 ///
   TPCount := 0;
   result := true;
   try
     L1.x := x1 + r * sin(a1);    L1.y := y1 - r * cos(a1);
     R2.x := x2 - r * sin(a2);    R2.y := y2 + r * cos(a2);

     a.x  := R2.x - L1.x;         a.y := R2.y - L1.y;
     Adot.x := L1.x + a.x/2;      Adot.y := L1.y + a.y/2;

     _a := sqrt(sqr(a.x) + sqr(a.y));
     if abs(2*r/_a) <= 1 then
       alfa := arccos(2*r / _a)
     else
     begin
       result := false;
       exit;
     end;

     u.x := r * cos(alfa) * a.x/_a;          u.y :=  r * cos(alfa) * a.y/_a;
     v.x := -r * sin(alfa) * a.y/_a;          v.y :=  r * sin(alfa) * a.x/_a;

     T1.x := L1.x + u.x + v.x;               T1.y := L1.y + u.y + v.y;
     RSL.x := 2*(Adot.x - T1.x);             RSL.y :=  2*(Adot.y - T1.y);
     T2.x := T1.x + RSL.x;                   T2.y := T1.y + RSL.y;

     /// Подготовка путевых точек
     alfa := arctan2(RSL.y, RSL.x);
     AddLinePoints(x1, y1);
     AddCirclePoints(-a1, -alfa, L1.x, L1.y, r, astep, true);
     AddLinePoints(T1, T2);
     AddCirclePoints(pi-alfa, pi-a2, R2.x, R2.y, r, astep, false);

   except
     result := false;
     TPCount := 0;
   end;
end;

function DubinsLSL(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
var L1, L2, a,  T1, T2 :TTurnPoint;
    _a, alfa :Double;
begin
 ///
   TPCount := 0;
   result := true;
   try
     L1.x := x1 + r * sin(a1);    L1.y := y1 - r * cos(a1);
     L2.x := x2 + r * sin(a2);    L2.y := y2 - r * cos(a2);

     a.x  := L2.x - L1.x;         a.y := L2.y - L1.y;
     _a := sqrt(sqr(a.x) + sqr(a.y));

     T1.x := L1.x - r* a.y/_a;    T1.y := L1.y + r* a.x/_a;
     T2.x := T1.x + a.x;          T2.y := T1.y + a.y;

     /// Подготовка путевых точек
     alfa := arctan2(a.y, a.x);
     AddLinePoints(x1, y1);
     AddCirclePoints(-a1, -alfa, L1.x, L1.y, r, astep, true);
     AddLinePoints(T1, T2);
     AddCirclePoints(- alfa, - a2, L2.x, L2.y, r, astep, true);

   except
     result := false;
     TPCount := 0;
   end;
end;

function DubinsRSR(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
var R1, R2, a, T1, T2 :TTurnPoint;
    _a, alfa :Double;
begin

   TPCount := 0;
   result := true;
   try
     R1.x := x1 - r * sin(a1);    R1.y := y1 + r * cos(a1);
     R2.x := x2 - r * sin(a2);    R2.y := y2 + r * cos(a2);

     a.x  := R2.x - R1.x;         a.y := R2.y - R1.y;
     _a := sqrt(sqr(a.x) + sqr(a.y));

     T1.x := R1.x + r* a.y/_a;    T1.y := R1.y - r* a.x/_a;
     T2.x := T1.x + a.x;          T2.y := T1.y + a.y;

     /// Подготовка путевых точек
     alfa := arctan2(a.y, a.x);
     AddLinePoints(x1, y1);
     AddCirclePoints(pi - a1, pi - alfa, R1.x, R1.y, r, astep, false);
     AddLinePoints(T1, T2);
     AddCirclePoints(pi - alfa, pi - a2, R2.x, R2.y, r, astep, false);

   except
     result := false;
     TPCount := 0;
   end;
end;

function DubinsRSL(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
var R1, L2, a, Adot, u, v, T1, T2, RSL :TTurnPoint;
    _a, alfa :Double;
begin

   TPCount := 0;
   result := true;
   try
     R1.x := x1 - r * sin(a1);    R1.y := y1 + r * cos(a1);
     L2.x := x2 + r * sin(a2);    L2.y := y2 - r * cos(a2);

     a.x  := L2.x - R1.x;         a.y := L2.y - R1.y;
     Adot.x := R1.x + a.x/2;      Adot.y := R1.y + a.y/2;

     _a := sqrt(sqr(a.x) + sqr(a.y));
     if abs(2*r/_a) <= 1 then
       alfa := arccos(2*r / _a)
     else
     begin
       result := false;
       exit;
     end;

     u.x := r * cos(alfa) * a.x/_a;          u.y :=  r * cos(alfa) * a.y/_a;
     v.x := r * sin(alfa) * a.y/_a;          v.y :=  -r * sin(alfa) * a.x/_a;

     T1.x := R1.x + u.x + v.x;               T1.y := R1.y + u.y + v.y;
     RSL.x := 2*(Adot.x - T1.x);             RSL.y := 2*(Adot.y - T1.y);
     T2.x := T1.x + RSL.x;                   T2.y := T1.y + RSL.y;

     /// Подготовка путевых точек
     alfa := arctan2(RSL.y, RSL.x);
     AddLinePoints(x1, y1);
     AddCirclePoints(pi - a1, pi - alfa, R1.x, R1.y, r, astep, false);
     AddLinePoints(T1, T2);
     AddCirclePoints(-alfa, -a2, L2.x, L2.y, r, astep, true);
   except
     result := false;
     TPCount := 0;
   end;
end;

function DubinsRLR(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
var R1, R2, L3, a, Adot, w, T1, T2, aT :TTurnPoint;
     _a, _w, alfa, alfa2, _t :Double;
begin

   TPCount := 0;
   result := true;
   try
     R1.x := x1 - r * sin(a1);    R1.y := y1 + r * cos(a1);
     R2.x := x2 - r * sin(a2);    R2.y := y2 + r * cos(a2);

     a.x  := R2.x - R1.x;         a.y := R2.y - R1.y;
     _a := sqrt(sqr(a.x) + sqr(a.y));

     Adot.x := R1.x + a.x/2;      Adot.y := R1.y + a.y/2;

     _w :=  4 * sqr(r) - sqr(_a) / 4;

     if _w < 0 then
     begin
      result := false;
      exit;
     end
      else
       _w := sqrt(_w);

     w.x  := - _w * a.y / _a;     w.y  := _w * a.x / _a;
     L3.x := Adot.x + w.x;        L3.y :=  Adot.y + w.y;

     T1.x := R1.x + 0.5 * (L3.x - R1.x);   T1.y := R1.y + 0.5 * (L3.y - R1.y);
     T2.x := R2.x + 0.5 * (L3.x - R2.x);   T2.y := R2.y + 0.5 * (L3.y - R2.y);

     /// Подготовка путевых точек
     AddLinePoints(x1, y1);
     aT.x :=  L3.x - R1.x;                 aT.y :=  L3.y - R1.y;
     alfa := arctan2(aT.y, aT.x);
     if alfa < pi/2  then alfa := alfa + 2*pi;
     
     AddCirclePoints(pi - a1, pi/2-alfa, R1.x, R1.y, r, astep, false);

     aT.x :=  T2.x - L3.x;                 aT.y :=  T2.y - L3.y;
     alfa2 := arctan2(aT.y, aT.x);
     AddCirclePoints(3*pi/2 - alfa, pi/2 - alfa2, L3.x, L3.y, r, astep, true);

     AddCirclePoints(3*pi/2 - alfa2, pi - a2, R2.x, R2.y, r, astep, false);

   except
     result := false;
     TPCount := 0;
   end;
end;

function DubinsLRL(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;
var L1, L2, R3, a, Adot, w, T1, T2, aT :TTurnPoint;
     _a, _w, alfa, alfa2, _t :Double;
begin

   TPCount := 0;
   result := true;
   try
     L1.x := x1 + r * sin(a1);    L1.y := y1 - r * cos(a1);
     L2.x := x2 + r * sin(a2);    L2.y := y2 - r * cos(a2);

     a.x  := L2.x - L1.x;         a.y := L2.y - L1.y;
     _a := sqrt(sqr(a.x) + sqr(a.y));

     Adot.x := L1.x + a.x/2;      Adot.y := L1.y + a.y/2;

     _w :=  4 * sqr(r) - sqr(_a) / 4;

     if _w < 0 then
     begin
      result := false;
      exit;
     end
      else
       _w := sqrt(_w);
     //w.x  := - _w * a.y / _a;     w.y  := _w * a.x / _a;
     w.x  :=  _w * a.y / _a;      w.y  := -_w * a.x / _a;
     R3.x := Adot.x + w.x;        R3.y :=  Adot.y + w.y;

     T1.x := L1.x + 0.5 * (R3.x - L1.x);   T1.y := L1.y + 0.5 * (R3.y - L1.y);
     T2.x := L2.x + 0.5 * (R3.x - L2.x);   T2.y := L2.y + 0.5 * (R3.y - L2.y);

     /// Подготовка путевых точек
     AddLinePoints(x1, y1);
     aT.x :=  R3.x - L1.x;                 aT.y := R3.y - L1.y;
     alfa := arctan2(aT.y, aT.x);
     if alfa < pi/2  then alfa := alfa + 2*pi;
                                   
     AddCirclePoints( - a1, pi/2-alfa, L1.x, L1.y, r, astep, true);

     aT.x :=  T2.x - R3.x;                 aT.y :=  T2.y - R3.y;
     alfa2 := arctan2(aT.y, aT.x);
     AddCirclePoints(3*pi/2 - alfa, pi/2 - alfa2, R3.x, R3.y, r, astep, false);

     AddCirclePoints(3*pi/2 - alfa2,  - a2, L2.x, L2.y, r, astep, true);
   except
     result := false;
     TPCount := 0;
   end;
end;

/////////////////////////////////////////---------------------------------------

function Dubins(x1, y1, a1, x2, y2, a2, r, astep  :Double;
                LSR, LSL, RSR, RSL, LRL, RLR :boolean):boolean;  overload;
var
   _TurnPoints:array [0..MaxTPCount-1] of TTurnPoint;
   _TPCount, I, j : Integer;

   L, Lmin :Double;
   isOk :boolean;
begin
  /// ПРОВЕРКА ВСЕХ ИЛИ НЕСКОЛЬКИХ
  Lmin := -1;

  if a1 < 0 then  a1 := a1 + 2*pi;      if a1 > 2*pi then  a1 := a1 - 2*pi;
  if a2 < 0 then  a2 := a2 + 2*pi;      if a2 > 2*pi then  a2 := a2 - 2*pi;
  
  for I := 1 to 6 do
  begin

    isOk := false;

    case I of
      1: if LSR then isOk := DubinsLSR(x1, y1, a1, x2, y2, a2, r, astep );
      2: if LSL then isOk := DubinsLSL(x1, y1, a1, x2, y2, a2, r, astep );
      3: if RSR then isOk := DubinsRSR(x1, y1, a1, x2, y2, a2, r, astep );
      4: if RSL then isOk := DubinsRSL(x1, y1, a1, x2, y2, a2, r, astep );
      5: if LRL then isOk := DubinsLRL(x1, y1, a1, x2, y2, a2, r, astep );
      6: if RLR then isOk := DubinsRLR(x1, y1, a1, x2, y2, a2, r, astep );
      else break;
    end;

    if not isOk then
      continue;

    {ВЫБОР КРАТЧАЙШЕГО ПУТИ}
    L := 0;
    for j := 1 to TPCount-1 do
      L := L + sqrt( sqr(TurnPoints[j].x - TurnPoints[j-1].x) +
                     sqr(TurnPoints[j].y - TurnPoints[j-1].y));

    if (L < Lmin)and(abs(L - Lmin) > 0.01*Lmin) or (Lmin = -1) then
    begin
      for j := 0 to TPCount-1 do
        _TurnPoints[j] := TurnPoints[j];
      _TPCount := TPCount;
      Lmin := L;
    end;
  end;

  result := Lmin > 0;

  if result = false then
    TPCount := 0
  else
    begin
      for j := 0 to _TPCount-1 do
        TurnPoints[j] := _TurnPoints[j];
      TPCount := _TPCount;
    end;
end;

function Dubins(x1, y1, a1, x2, y2, a2, r  :Double):boolean;   overload;
begin
  // Упрощенный вызов
  result := Dubins(x1, y1, a1, x2, y2, a2, r, pi/20,
                   true, true, true, true, true, true);
end;

function Dubins(x1, y1, a1, x2, y2, a2, r, astep  :Double):boolean;   overload;
begin
  // Упрощенный вызов
  result := Dubins(x1, y1, a1, x2, y2, a2, r, astep,
                   true, true, true, true, true, true);
end;

end.
