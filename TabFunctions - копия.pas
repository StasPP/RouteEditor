unit TabFunctions;

interface

uses Math, SysUtils;

type
  TPosAndDist = record
      Pos, Dist, DistTo0, x, y :Double;
  end;

  TMyPoint = record
      x, y :Double;
  end;

  TMy3DPoint = record
      x, y, z :Double;
  end;

  function GetPosAndDist(xb, yb, xe, ye, x, y: double): TPosAndDist;
  function GetNormalPt(xb, yb, xe,ye, x, y: double; isRight: boolean;
                                Dist: double): TMyPoint;

  function GetCols(str: string; ColN, ColCount:integer; Spc:byte): string; overload;
  function GetCols(str: string; ColN, ColCount:integer; Sep:char): string; overload;

  function ReplaceDecimals(S :String):string;  overload;
  function ReplaceDecimals(S :String; sep :char):string;  overload;

implementation

function GetPosAndDist(xb, yb, xe, ye, x, y: double): TPosAndDist;
var x1, y1, x2, y2, _x, _y, t, c, _y0: Double;
begin
  Result.Dist := 0;
  Result.Pos := 0;
  try
     x1 := xb;
     x2 := xe;
     y1 := yb;
     y2 := ye;

     if x1=x2 then
     begin
       _y := y;
       _x := x1;
        c := (_y - y1) / (y2 - y1);
     end
        else
     if y1=y2 then
     begin
       _y := y1;
       _x := x;
        c := (_x - x1) / (x2 - x1);
     end
        else
     if abs(x2-x1)>abs(y2-y1) then
     Begin
       t :=  (y2-y1)/(x2-x1);
       c := 1/t;

       _y0 := c*(x-x1) + (y-y1);

       _x := x1 + (  _y0/(t+c) );
       _y := y1 + ( t*(_x-x1) );

      

        c := (_x - x1) / (x2 - x1);
     End
        else
          Begin
            t := (x2-x1)/(y2-y1);
            c := 1/t;

            _y0 := (x-x1) + c*(y-y1);

            _y := y1 + (  _y0/(t+c) );
            _x := x1 + ( t*(_y-y1) );

            c := (_y - y1) / (y2 - y1);
          End;

     Result.x := _x;
     Result.y := _y;
     Result.Pos  := c;
     Result.Dist := SQRT(SQR(x-_x)+SQR(y-_y));
     Result.DistTo0 := c*SQRT(SQR(x2-x1)+SQR(y2-y1));
  except
    Result.Dist := 0;
  end;

end;


function GetNormalPt(xb, yb, xe,ye, x, y: double; isRight: boolean;
                                Dist: double): TMyPoint;
var
  a : double;
  PD :TPosandDist;
begin

   try
    PD := GetPosAndDist(xb, yb, xe, ye, x, y);
    a := arctan2(xe-xb,ye-yb);

    if isRight then
      a := a + pi/2
      else
        a:= a - pi/2;

     Result.x := PD.x + sin(a)*Dist;
     Result.y := PD.y + cos(a)*Dist;

   except
   end;

end;


function GetCols(str: string; ColN, ColCount:integer; Spc:byte): string;
var j,stl,b :integer;
    sep :String;
begin
   result:='';
   stl:=0;
   b:=1;
   sep:=' ';

   Case Spc of
     0: sep:=' ';
     1: sep:=#$9;
     2: sep:='/';// LoadRData.Spacer.Text[1];
     3: sep:=';';
     4: sep:=',';
   end;

   for j:=1 to length(Str)+1 do
   Begin

     if ((copy(Str,j,1)=sep)or(j=length(Str)+1))and(copy(Str,j-1,1)<>sep) then
     begin

       if (stl>=ColN) and (Stl<ColN+ColCount) then
       Begin
        if result='' then
          Result:=(Copy(Str,b,j-b))
            else
              Result:=Result+' '+(Copy(Str,b,j-b));
       End;

       inc(stl);
       b:=j+1;

       if stl>ColN+ColCount then
          break;
     end;

  End;

  if Sep<>DecimalSeparator then
     Result := ReplaceDecimals(Result);
end;

function GetCols(str: string; ColN, ColCount:integer; Sep:char): string;
var j,stl,b :integer;
begin
   result:='';
   stl:=0;
   b:=1;

   for j:=1 to length(Str)+1 do
   Begin

     if ((copy(Str,j,1)=sep)or(j=length(Str)+1))and(copy(Str,j-1,1)<>sep) then
     begin

       if (stl>=ColN) and (Stl<ColN+ColCount) then
       Begin
        if result='' then
          Result:=(Copy(Str,b,j-b))
            else
              Result:=Result+' '+(Copy(Str,b,j-b));
       End;

       inc(stl);
       b:=j+1;

       if stl>ColN+ColCount then
          break;
     end;

  End;

  if Sep<>DecimalSeparator then
     Result := ReplaceDecimals(Result);
end;


function ReplaceDecimals(S:String):string;
var j: integer;
begin
  Result :=  S;
  if result <> '' then
    for j := 1 to length(Result)+1 do
        if ((result[j] = '.') or (result[j] = ',')) then
            result[j] := DecimalSeparator;
end;

function ReplaceDecimals(S :String; sep :char):string;
var j: integer;
begin
  Result :=  S;
  if result <> '' then
    for j := 1 to length(Result)+1 do
        if ((result[j] = '.') or (result[j] = ',')) then
            result[j] := Sep;
end;


function CopToStr ( var cc ): String ;      {??????????}
var c : Array [0..1000] of char absolute cc ;
    i : Integer ;
    s : string ;
begin
       i := 0;
       s := '' ;
       while c[i] <> #0 do
          begin
             s := s + c[i];
             i := i +1;
          end ;
       CopToStr := s;
end;

procedure StrLong ( Data : int64; var str : String );   {??????????}
var s, s1 : string ;
       fl : boolean;
begin
    s := '';
    fl := FALSE ;
    repeat
      system.Str ( Data mod 1000, s1 );
      while Length ( s1 ) <3 do s1 := '0'+s1;
      IF FL THEN
            s := s1 + '.'+s
        ELSE s := s1 ;
      Data := Data div 1000;
      FL := TRUE ;
    until Data <1000;
      system.str ( data, s1 );
      while Length ( s1 ) <3 do s1 := '0'+s1;
      s := s1 + '.'+s;
     str := s ;
 end;

function DecChar(c :Char) :Integer;  {??????????}
begin
  DecChar := Ord (c) - Ord ('0');
end;

function HexToInt(Value: String): LongInt;
var
  L : Longint;
  B : Byte;
begin
  Result := 0;
  if Length(Value) <> 0 then
  begin
    L := 1;
    B := Length(Value) + 1;
    repeat
      dec(B);
      if Value[B] <= '9' then
        Result := Result + StrToInt(Value[B]) * L
      else
        Result := Result + (Ord(Value[B]) - 65) * L;
      L := L * 16;
    until B = 1;
  end;
end;
end.
