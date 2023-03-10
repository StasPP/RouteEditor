unit MainFm;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
  Messages, SysUtils, Classes, Controls, Forms, Dialogs, ExtCtrls, Windows,
  ComCtrls, Buttons, StdCtrls, GeoFunctions, GeoClasses,
  GeoString, GeoFiles, Menus;

//---------------------------------------------------------------------------
type

  TMainForm = class(TForm)
    Panel1: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;

    procedure N3Click(Sender: TObject);

    type TLatLong = record
      lat, long :Double
    end;

     Type TMyPoint = Record
       x, y : Double;
     end;

    function GetWGSCursor : TLatLong;

    procedure LoadFirst;

    procedure CutLineByBufferedFrame(var x,y,x2,y2: Double);
    procedure CutLineByFrame(var x,y,x2,y2: Double);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);

    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure FormResize(Sender: TObject);

    procedure Panel1Resize(Sender: TObject);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure CheckNearestMarkers(X, Y : Integer);

    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }


    procedure OnDeviceCreate(Sender: TObject; Param: Pointer;
     var Handled: Boolean);

    procedure InitData;

    procedure ShiftMap(Key : Byte);

    procedure TimerEvent(Sender: TObject);
    procedure ProcessEvent(Sender: TObject);
    procedure RenderEvent(Sender: TObject);

    procedure AxelScale;

    procedure DrawScaleAndNord;

    procedure DrawZone(x1,y1,x2,y2,x3,y3,x4,y4:Double);

    procedure MyLine(x,y,x2,y2:Double; Dash:Boolean; Col: Cardinal);
    procedure FatLine(x,y,x2,y2:Double; Thin:integer; Dash:Boolean; Col: Cardinal);

    procedure WMDisplayChange(var message:TMessage); message WM_DISPLAYCHANGE;

    procedure PutBaseHere( B,L :double);

    procedure SKToWGS(x, y, h: Double; var B, L: Double);
    procedure WGSToSK(B, L, H: Double; var x, y: Double; Zone:Integer; autozone : boolean);

    procedure GPSTimerEvent;

    procedure ReDrawLines(dash:Boolean);
    procedure ReDrawMaps;

    procedure ReDrawRoutes;
    procedure ReDrawBase;
    procedure ReDrawMarkers;

  public

   procedure AddMarker(Mname:string; mB, mL :Double);
   procedure DelMarker(DelI:integer);
   procedure EditMarker(I:integer; Mname:string; mB, mL :Double);
   procedure RefreshMarkerList;

   procedure ReLoadRoutes(FileName:String);
   procedure ReComputeRoutes(WFZ:Boolean);
   procedure ReComputeMaps(WFZ:Boolean);

   procedure LoadMaps(Filename:String);
   procedure ResetMaps;

  Type TMyPoint3D = Record
      x, y, z : Double;
  end;

  Type TMarker = Record
     B, L : Double;
     iX, iY, iW : Integer;
     x, y : Double;
     Caption : String;
     OnScreen, Show : boolean;
  End;

  const

   FrameMax = 100;

   MaxMashtab = 12 ;
   TMashtab : Array [0.. MaxMashtab-1 ] of Integer =
                    (10, 20, 50,
                     100, 200, 500,
                     1000, 2000, 5000,
                     10000, 20000, 50000);
  var

    MashtabNames : Array [0.. MaxMashtab-1] of String;

    Markers : array [0..1000] of TMarker;
    MarkerCount: Integer;

    RoutesDatum, RoutesCS : integer;
    isRoutesDatum : boolean;
    RoutesXTab, RoutesYTab, RoutesZTab, RoutesNameTab, RoutesTabStart,
    RoutesX2Tab, RoutesY2Tab, RoutesZ2Tab : Integer;

    Center : TMyPoint ;

    Base : array [1..2] of TMyPoint;
    FramePoints : array [0..FrameMax,1..2] of TMyPoint3D;

    ShowActiveZone : boolean;

    MyDir : String;

    WaitForZone, ShowFrame : boolean;

    DrawScale, ShowMaps : boolean;

    MinMap, MaxMap : integer;

    MapAlpha : integer;

    South, UTM: Boolean;

     /// COLORS
    RoutesColor, BackGroundColor, LinesColor,
    ChoosedColor, TrackColor, MenuChoosedColor, Dop1Color, RouteOKColor,
    IntColor, DoneColor, CurColor : Cardinal;

    DopFat: byte;

    ShowFPS : boolean;

    Smooth, CropRoutes, Optimized : Boolean;

    OpenGL : boolean;

    { Public declarations }
  end;

const
  SmoothScale = true;

var
  BigCur: Boolean;

  Panel1CursorX, Panel1CursorY : Integer;
  AskMark : integer;

  WGS: Integer;
  SK:  Integer;

  VYShift : Integer;

  MyZone : Integer;

  ShowCurXY : boolean = false;

  LagCount: Single;

  MShiftX, MShiftY, MShiftY0 : Integer;

  Type TRoute = record
    Name : String;
    Status : byte; /// 0 -undone, 1- Current, 2 - Done good, 3 - Done bad.
    AverageDist : double;
    badHgts : integer;
    StartTime, EndTime, RLabel :string;
    //Flag : Boolean;
    Geo : Boolean;
    x1, x2 : double;
    y1, y2 : double;
    Gx1, Gx2 : double;
    Gy1, Gy2 : double;
    Gz1, Gz2 : double;
  end ;

  TMap = Record
      imgN : integer;
      imgName : String;
      x,y : array [1..4] of Double;
      Gx,Gy : array [1..4] of Double;
  end ;

 const
     MaxDotsCount = 1000000;


 Var
    Route : Array [0..2000] of TRoute ;
    RouteCount : Integer ;

    StepTrackRecord : Double = 0.1;

 {   Gx : double;
    Gy : double;
    OldGx : double;
    OldGY : Double;}

    Mashtab : Integer;

//---------------------------------------------------------------------------

var
  MainForm: TMainForm;

  JustStarted : boolean;

  Scale  :Double =1;
  _Scale  :Double =1;

  Frame, FrameGeo : boolean;
  FrameCount : Integer;
  FrameFile : String;

  MapList : Array of TMap;

//---------------------------------------------------------------------------
implementation
uses
 Vectors2, Vectors2px, AsphyreTimer, AsphyreFactory, AsphyreTypes, AsphyreDb,
 AbstractDevices, AsphyreImages, AsphyreFonts, DX9Providers, RTypes,
 AbstractCanvas, OGLProviders, LoadData, NewMark;
{$R *.dfm}

//---------------------------------------------------------------------------

  type TPosAndDist = record
      Pos, Dist, DistTo0, x, y :Double;
  end;

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

{Type TMyPoint = Record
       x, y : Double;
     end; }
{
function TMainForm.GetNormalPt(xb, yb, xe,ye, x, y: double; isRight: boolean; Dist: double): TMyPoint;
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

end;  }


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

  if result <> '' then
    for j:= 1 to length(Result)+1 do
        if ((result[j] = '.') or (result[j] = ','))and(result[j]<>sep) then
           result[j] := DecimalSeparator;
end;


function CopToStr ( var cc ): String ;      {ИННОКЕНТИЙ}
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

procedure StrLong ( Data : int64; var str : String );   {ИННОКЕНТИЙ}
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

function DecChar(c :Char) :Integer;  {ИННОКЕНТИЙ}
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

procedure TMainForm.CheckNearestMarkers(X, Y: Integer);
var I :Integer;
begin
  PopupMenu1.Items[2].Visible := false;
  for i := 0 to MarkerCount - 1 do
   if (X > Markers[i].iX-20) and (X < Markers[i].iX+20) then
    if (Y > Markers[i].iY-20) and (Y < Markers[i].iY+20) then
    begin
      AskMark := i;
      PopupMenu1.Items[2].Visible := true;
      PopupMenu1.Items[2].Caption := {Inf[57]}'Удалить '+'"'+Markers[I].Caption+'"';
      break;
    end;
end;

{procedure TMainForm.CrackDot(x, y: Double; Col: Cardinal);
begin
  if (x > 0) and (y > 0) and (X <(DisplaySize.X)) and (y < DisplaySize.y) then
  Begin
       AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8, 8));
       AsphCanvas.TexMap(pRotate4c(Point2(x,y),Point2(8, 8), 0),cColor4(Col));

  End;
end;  }

procedure TMainForm.CutLineByBufferedFrame(var x, y, x2, y2: Double);
const
 bx = 1024;
 by = 1024;
begin
  if not( (x < 0 - bx) and (x2 < 0 - bx)) then
  if not( (x > (DisplaySize.X + bx)) and (x2 > (DisplaySize.X + bx))) then
  if not( (y < 0 - by) and (y2 < 0 - by)) then
  if not( (y > DisplaySize.y + by) and (y2 > DisplaySize.y + by)) then
  if not( (abs(y-y2) < 1) and (abs(x-x2) < 1) ) then
  Begin
    if x < 0 - bx then
    begin
      if abs(x2-x) > 0 then
        y := round( ((-bx-x)/(x2-x))*(y2-y)+y)
          else
            y := y2;
      //Col := $FFFF0000;
      x := 0 - bx;
    end
      else
       if x > (DisplaySize.X) + bx then
       begin
          if abs(x2-x) > 0 then
              y := round((((DisplaySize.X)+bx-x)/(x2-x))*(y2-y)+y)
               else
                 y := y2;
          //Col := $FFFF0000;
          x := (DisplaySize.X) + bx;
       end;

    if x2 < 0 - bx then
    begin
      if abs(x2-x) > 0 - bx then
        y2 := round(((-bx-x)/(x2-x))*(y2-y)+y)
          else
            y2 := y;
      //Col := $FFFF0000;
      x2 := 0 - bx;
    end
      else
       if x2 > (DisplaySize.X)+bx then
       begin
          if abs(x2-x) > 0 then
              y2 := round((((DisplaySize.X)+bx-x)/(x2-x))*(y2-y)+y)
               else
                 y2 := y;
          //Col := $FFFF0000;
          x2 := (DisplaySize.X) + bx;
       end;

    if y < 0 - by then
    begin
      if abs(y2-y)>0 then
          x := round(((-by-y)/(y2-y))*(x2-x)+x)
          else
            x := x2;
      //Col := $FFFF0010;
      y := 0 - by;
    end
      else
       if y > DisplaySize.y + by then
       begin
          if abs(y2-y) > 0 then
               x := round(((DisplaySize.y+by-y)/(y2-y))*(x2-x)+x)
               else
                 x := x2;
         //Col := $FFFF0010;
         y := DisplaySize.y + by;
       end;

   if y2 < 0 - by then
    begin
      if abs(y2-y) > 0 then
          x2 := round(((-by-y)/(y2-y))*(x2-x)+x)
          else
            x2 := x;
      //Col := $FFFF0010;
      y2 := 0 - by;
    end
      else
       if y2 > DisplaySize.y + by then
       begin
          if abs(y2-y) > 0 then
               x2 := round(((DisplaySize.y+by-y)/(y2-y))*(x2-x)+x)
               else
                 x2 := x;
         //Col := $FFFF0010;
         y2 := DisplaySize.y + by;
       end;
  End;
end;

procedure TMainForm.CutLineByFrame(var x, y, x2, y2 : Double);
const MenuW =0;
begin
  if not( (x < 0) and (x2 < 0)) then
  if not( (x > (DisplaySize.X - MenuW)) and (x2 > (DisplaySize.X - MenuW))) then
  if not( (y < 0) and (y2 < 0)) then
  if not( (y > DisplaySize.y) and (y2 > DisplaySize.y)) then
  if not( (abs(y-y2) < 1) and (abs(x-x2) < 1) ) then
  Begin
    if x < 0 then
    begin
      if abs(x2-x) > 0 then
        y := round( ((-x)/(x2-x))*(y2-y)+y)
          else
            y := y2;
      //Col := $FFFF0000;
      x := 0;
    end
      else
       if x > (DisplaySize.X - MenuW) then
       begin
          if abs(x2-x) > 0 then
              y := round((((DisplaySize.X - MenuW)-x)/(x2-x))*(y2-y)+y)
               else
                 y := y2;
          //Col := $FFFF0000;
          x := (DisplaySize.X - MenuW);
       end;

    if x2 < 0 then
    begin
      if abs(x2-x) >0 then
        y2 := round(((-x)/(x2-x))*(y2-y)+y)
          else
            y2 := y;
      //Col := $FFFF0000;
      x2 := 0;
    end
      else
       if x2 > (DisplaySize.X - MenuW) then
       begin
          if abs(x2-x) > 0 then
              y2 := round((((DisplaySize.X - MenuW)-x)/(x2-x))*(y2-y)+y)
               else
                 y2 := y;
          //Col := $FFFF0000;
          x2 := (DisplaySize.X - MenuW);
       end;

    if y < 0 then
    begin
      if abs(y2-y)>0 then
          x := round(((-y)/(y2-y))*(x2-x)+x)
          else
            x := x2;
      //Col := $FFFF0010;
      y := 0;
    end
      else
       if y > DisplaySize.y then
       begin
          if abs(y2-y) > 0 then
               x := round(((DisplaySize.y-y)/(y2-y))*(x2-x)+x)
               else
                 x := x2;
         //Col := $FFFF0010;
         y := DisplaySize.y;
       end;

   if y2 < 0 then
    begin
      if abs(y2-y) > 0 then
          x2 := round(((-y)/(y2-y))*(x2-x)+x)
          else
            x2 := x;
      //Col := $FFFF0010;
      y2 := 0;
    end
      else
       if y2 > DisplaySize.y then
       begin
          if abs(y2-y) > 0 then
               x2 := round(((DisplaySize.y-y)/(y2-y))*(x2-x)+x)
               else
                 x2 := x;
         //Col := $FFFF0010;
         y2 := DisplaySize.y;
       end;
  End;

end;

procedure TMainForm.AddMarker(Mname: string; mB, mL: Double);
begin
///
  if MarkerCount<1000 then
     Inc(MarkerCount);

  Markers[MarkerCount-1].B := mB;
  Markers[MarkerCount-1].L := mL;

  Markers[MarkerCount-1].Caption := mName;

  RefreshMarkerList;
end;


procedure TMainForm.DrawScaleandNord;
const MenuW = 0;
      IntColor = $FFFFFFFF;
var s, s2 : String;
    w : integer;

begin
{
  if DrawScale then
  Begin
    w := trunc(TMashtab[Mashtab]/Scale);

    AsphCanvas.FillRect(RECT( (DisplaySize.X - MenuW)-20 - w, DisplaySize.Y - 50,
                    (DisplaySize.X - MenuW), DisplaySize.Y),
                    cRGB4(GetBValue(IntColor),GetGValue(IntColor),GetRValue(IntColor),190));

    FatLine((DisplaySize.X - MenuW) - 10 - w, DisplaySize.Y - 10,
                (DisplaySize.X - MenuW) - 10, DisplaySize.Y - 10 , 1, false, $FFFFFFFF);

    FatLine((DisplaySize.X - MenuW) - 10 - w, DisplaySize.Y - 20,
                (DisplaySize.X - MenuW) - 10 - w, DisplaySize.Y - 10 , 1, false, $FFFFFFFF);

    FatLine((DisplaySize.X - MenuW) - 10, DisplaySize.Y - 20,
                (DisplaySize.X - MenuW) - 10, DisplaySize.Y - 10 , 1, false, $FFFFFFFF);

    w := trunc(w/2 + AsphFonts[Font4].TextWidth(MashtabNames[Mashtab])/2) ;

    AsphFonts[Font4].TextOut( Point2((DisplaySize.X - MenuW) - w -10, DisplaySize.Y - 45), MashtabNames[Mashtab],
                              clWhite2, 1.0);

  End;
           }

end;


procedure TMainForm.DrawZone(x1, y1, x2, y2, x3, y3, x4, y4: Double);
const ChoosedColor = $FFFF0000;
begin
  if not( (x1 < 0) and (x2 < 0) and (x3 < 0) and (x4 < 0)) then

  if not( (x1 > (DisplaySize.X)) and (x2 > (DisplaySize.X)) and
          (x3 > (DisplaySize.X)) and (x4 > (DisplaySize.X)) ) then

  if not( (y1 < 0) and (y2 < 0)and (y3 < 0) and (x4 < 0)) then

  if not( (y1 > DisplaySize.y) and (y2 > DisplaySize.y) and
          (y3 > DisplaySize.y) and (y4 > DisplaySize.y) ) then

  if not( (abs(y1-y2) < 1) and (abs(x1-x2) < 1) and (abs(y3-y4) < 1) and (abs(x3-x4) < 1) ) then

  try
     CutLineByBufferedFrame(x1,y1,x2,y2);
     CutLineByBufferedFrame(x3,y3,x4,y4);

     AsphCanvas.FillQuad(Point4(x1, y1, x2, y2, x3, y3, x4, y4),
                        cRGB4( GetBValue(ChoosedColor),GetGValue(ChoosedColor),
                                GetRValue(ChoosedColor),100));
  except

  end;

end;

procedure TMainForm.EditMarker(I: integer; Mname: string; mB, mL: Double);
begin
  with  Markers[I] do
  begin
    Caption := mName;
    B := mB;
    L := mL;
  end;

  RefreshMarkerList;
end;

procedure TMainForm.FatLine(x, y, x2, y2: Double; Thin:integer; Dash:Boolean; Col: Cardinal);
var i,j :integer;
begin
 for I := -Thin to Thin do
   for J := -Thin to Thin do
        MyLine( x+I, y+J, x2+I, y2+J, Dash, Col)

end;


procedure TMainForm.FormActivate(Sender: TObject);
begin
 // InitData;
  JustStarted := false;

  if not Timer.Enabled then
      Timer.Enabled:= true;

  FormResize(nil);
end;

procedure TMainForm.FormCreate(Sender: TObject);
  var Year, Month, Day : Word ;
      s : string;
      i : integer;
begin
 MyDir := GetCurrentDir + '\';

 GeoInit('Data\Sources.loc');
 SK := FindDatum('SK42');
 WGS := FindDatum('WGS84') ;

 JustStarted := true;
 MarkerCount := 0;

 // Enable Delphi debugger
 ReportMemoryLeaksOnShutdown:= DebugHook <> 0;

 // Set the display size
 DisplaySize:= Point2px(ClientWidth, ClientHeight);

 // Indicate that we're using DirectX 9
 OpenGL := false;
 if ParamStr(1)='-gl' then
     OpenGL := true;
     
 if OpenGL then
   Factory.UseProvider(idOpenGL)
     else
      Factory.UseProvider(idDirectX9);

 // Create Asphyre components in run-time.
 AsphDevice:= Factory.CreateDevice();
 AsphCanvas:= Factory.CreateCanvas();
 AsphImages:= TAsphyreImages.Create();
 AsphMapImages:= TAsphyreImages.Create(); 

 AsphFonts:= TAsphyreFonts.Create();
 AsphFonts.Images:= AsphImages;
 AsphFonts.Canvas:= AsphCanvas;

 MediaASDb:= TASDb.Create();
 MediaASDb.FileName:= ExtractFilePath(PChar(MyDir)) + 'Data\media.asdb';
 MediaASDb.OpenMode:= opReadOnly;

 AsphDevice.WindowHandle:= Self.Handle;
 AsphDevice.Size    := DisplaySize;
 AsphDevice.Windowed:= True;
 AsphDevice.VSync   := True;

 EventDeviceCreate.Subscribe(OnDeviceCreate, 0);

 // Attempt to initialize Asphyre device.
 if (not AsphDevice.Initialize()) then
  begin
   ShowMessage('Failed to initialize Asphyre device.');
   Application.Terminate();
   Exit;
  end;

 // Create rendering timer.
 Timer.OnTimer  := TimerEvent;
 Timer.OnProcess:= ProcessEvent;
 Timer.Speed    := 60.0;
 Timer.MaxFPS   := 4000;
 Timer.Enabled  := True;


 MarkerCount :=0;
end;

//---------------------------------------------------------------------------
procedure TMainForm.FormDestroy(Sender: TObject);
begin
 Timer.Enabled:= False;



 FreeAndNil(AsphFonts);
 FreeAndNil(AsphImages);
 FreeAndNil(AsphMapImages);
 FreeAndNil(MediaASDb);
 FreeAndNil(AsphCanvas);
 FreeAndNil(AsphDevice);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_F2 then
    if Windowstate = wsMaximized then
    begin
      Windowstate := wsNormal;
      BorderStyle := BsSingle;
    end
      else
        Begin
          BorderStyle := BsNone;
          Windowstate := wsMaximized;
        End;

  if Key = VK_F1 then
  begin

  end;


  if Key = VK_F5 then
    Panel5.Visible := not (Panel5.Visible);

  if Key = VK_F4 then
    ShowFPS := not (ShowFPS);


//// + - клавиши

 if (Key = 187) or (Key = 107) then
    Shiftmap(1);

 if (Key = 189) or (Key = 109) then
    Shiftmap(0);

//// W S A D

 if (Key = 87) then
    Shiftmap(2);

 if (Key = 83) then
    Shiftmap(3);

 if (Key = 65) then
    Shiftmap(4);

 if (Key = 68) then
    Shiftmap(5);

end;

procedure TMainForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var Max : Integer;
begin

    ShiftMap(0)
end;

procedure TMainForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

    ShiftMap(1)
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  DisplaySize := Point2px(Panel1.ClientWidth, Panel1.ClientHeight);
  AsphDevice.Size := DisplaySize;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin

  if not Timer.Enabled then
      Timer.Enabled:= true;

  Resize;

end;


function TMainForm.GetWGSCursor: TLatLong;
var xm, ym, x2: double;
Begin

      xm := Panel1CursorX - (DisplaySize.X)/2;
      ym := -Panel1CursorY + DisplaySize.Y/2 + VYShift;
      x2 := xm;

      xm := xm * Scale + Center.X;
      ym := ym * Scale + Center.Y;

      if UTM then
         UTMToGeo(WGS,ym,xm,South,Result.lat,Result.long)
        else
          SKToWGS(ym,xm,0,Result.lat,Result.long);

End;


procedure TMainForm.GPSTimerEvent;
begin

end;


procedure TMainForm.InitData;
begin
  MyZone :=0;

  Optimized :=true;

  MashtabNames [0] := '10 м' ;
  MashtabNames [1] := '20 м' ;
  MashtabNames [2] := '50 м' ;
  MashtabNames [3] := '100 м';
  MashtabNames [4] := '200 м';
  MashtabNames [5] := '500 м';
  MashtabNames [6] := '1 км' ;
  MashtabNames [7] := '2 км' ;
  MashtabNames [8] := '5 км' ;
  MashtabNames [9] := '10 км' ;
  MashtabNames [10] := '20 км' ;
  MashtabNames [11] := '50 км' ;

 { with LoadRData do
  begin
    LatS := 'Широта B, ';
    LonS := 'Долгота L, ';
    XS := 'X, м'; YS := 'Y, м'; ZS := 'Z, м';
    NordS := 'Север, м';
    SouthS:= 'Юг, м';
    NSS := 'Север/Юг, м';
    EWS := 'Запад/Восток, м';
    WestS := 'Запад, м';
    EastS := 'Восток, м';
    NameS := 'Имя'
  end; }

  Center.x := 0;
  Center.y := 0;

  Mashtab := 7;
end;


procedure TMainForm.LoadFirst;
begin
if (Center.x = 0) and (Center.y = 0) then
    Begin
      if ((Base[1].x<>0) and (Base[1].y<>0)) then
      Begin
        // RecomputeTracks(WaitForZone);
         RecomputeMaps(WaitForZone);
         RecomputeRoutes(false);
         Center.x  := Base[1].x;
         Center.y  := Base[1].y;
      End
      Else
      if (RouteCount > 0) then
      Begin
      //  RecomputeRoutes(WaitForZone);
        RecomputeMaps(WaitForZone);
        Center.x := Route[0].x1;
        Center.y := Route[0].y1;
      End
       Else
      if (Length(MapList)> 0) then
      Begin
        RecomputeMaps(WaitForZone);
        Center.x := MapList[0].x[3];
        Center.y := MapList[0].y[3];
      End;

    End
end;

procedure TMainForm.LoadMaps(Filename:String);
var
 MapAsdb : TASDB;
 i, j, N, k : integer;
 S : TStringList;
 Stream : TFileStream;
 ImgName, CurImgName : String;
 xx, yy : Double;
begin

{ FLoadGPS.Show;
 FLoadGPS.GPSLoad.Visible := false;
 FLoadGPS.GPSLoad2.Visible := false;
 FLoadGPS.MapLoad.Visible := true;
 FLoadGPS.LCount.Visible := true;
 FLoadGPS.Repaint;
 FloadGPS.ProgressBar1.Position := 0;

                            }
 MapASDb:= TASDb.Create();
 MapASDb.FileName:= FileName;
 MapASDb.OpenMode:= opReadOnly;

 MapAsdb.Update;

 S := TStringList.Create;
 S.SaveToFile(MyDir+'Data\stream.tmp');


 for I := 0 to MapASDb.RecordCount-1 do
   if MapASDb.RecordType[i] = recFile then
   Begin
     Stream := TFileStream.Create(MyDir+'Data\stream.tmp',1);
   //  Stream := MapASDb.ReadStream(MapASDb.RecordKey[i])
     MapASDb.ReadStream(MapASDb.RecordKey[i] ,Stream);

     Stream.Destroy;
     S.Clear;
     //S.LoadFromStream(Stream);
     S.LoadFromFile(MyDir+'Data\stream.tmp');

     ImgName := MapASDb.RecordKey[i];
     ImgName := Copy(ImgName,1,length(ImgName)-4);

     for J := 0 to S.Count - 1 do
     begin
         { FLoadGPS.ProgressBar1.Position := Trunc(100*j/(S.Count-1));}

          CurImgName := ImgName+'_'+GetCols(S[j],0,1,0)+'_'+GetCols(S[j],1,1,0);
          N := AsphMapImages.AddFromASDb(CurImgName+'_t', MapASDb, CurImgName+'_t', true);
          N := AsphMapImages.AddFromASDb(CurImgName+'_s', MapASDb, CurImgName+'_s', true);
          N := AsphMapImages.AddFromASDb(CurImgName, MapASDb, CurImgName, true);
          if N > -1 then
          Begin
//           AsphMapImages.Items[N].

            SetLength(MapList,Length(MapList)+1);
            MapList[Length(MapList)-1].imgName := CurImgName;
            MapList[Length(MapList)-1].imgN := N;

            for k := 1 to 4 do
            Begin
              MapList[Length(MapList)-1].Gx[k] := StrToFloat(GetCols(S[j],k*2,1,0));
              MapList[Length(MapList)-1].Gy[k] := StrToFloat(GetCols(S[j],k*2+1,1,0));

              if UTM then
                 GeoToUTM(WGS,MapList[Length(MapList)-1].Gx[k],
                          MapList[Length(MapList)-1].Gy[k],
                          South, yy,xx, Myzone, WaitForZone)
               else
                   WGSToSK(MapList[Length(MapList)-1].Gx[k],
                           MapList[Length(MapList)-1].Gy[k],
                           0, xx,yy, MyZone, WaitForZone);

              MapList[Length(MapList)-1].x[k] := xx;
              MapList[Length(MapList)-1].y[k] := yy;
            End;  /// k cycle

          End;  /// N>-1

     end;

   End;
if Stream<>nil then

 Stream.Destroy;
{ FLoadGPS.Hide;}
 S.Destroy;
 MapAsdb.Destroy;
end;

procedure TMainForm.MyLine(x,y,x2,y2:Double; Dash:Boolean; Col: Cardinal);
var i, l :integer;
    dx, dy :real;
const dashstep = 20;
begin
  if not( (x < 0) and (x2 < 0)) then
  if not( (x > (DisplaySize.X)) and (x2 > (DisplaySize.X))) then
  if not( (y < 0) and (y2 < 0)) then
  if not( (y > DisplaySize.y) and (y2 > DisplaySize.y)) then
  if not( (abs(y-y2) < 1) and (abs(x-x2) < 1) ) then
  Begin

   CutLineByFrame(x,y,x2,y2);

   try
    if Dash then
    Begin
       L := trunc(Sqrt (Sqr(x2-x)+sqr(y2-y)));
       if L>0 then
       BEGIN
          dx := (x2 - x)/L;
          dy := (y2 - y)/L;
          for I := 0 to L div dashstep do
          begin

            if Smooth then
                AsphCanvas.WuLine( Point2(x+i*dashstep*dx, y+i*dashstep*dy),
                Point2(x+(i+0.5)*dashstep*dx,y+(i+0.5)*dashstep*dy ), Col, Col)
            else
              AsphCanvas.Line( Point2(x+i*dashstep*dx, y+i*dashstep*dy),
                Point2(x+(i+0.5)*dashstep*dx,y+(i+0.5)*dashstep*dy ), Col, Col)

          end;

        

       END;



    End else
      Begin


          if Smooth then
          begin
            if not( (abs(y-y2) < 1) and (abs(x-x2) < 1) ) then
                AsphCanvas.WuLine( Point2(x, y), Point2(x2, y2), Col, Col)
          end
          else
                AsphCanvas.Line( Point2(x, y), Point2(x2, y2), Col);


      End;

   except
   end;
  End;
end;

procedure TMainForm.N1Click(Sender: TObject);
var CurPosBL : TLatLong;
begin
  CurPosBL := GetWGSCursor;
  NewMarkerForm.Top := Top + Panel1CursorY + Panel1.Top;
  NewMarkerForm.Left := Left + Panel1CursorX + Panel1.Left;
  NewMarkerForm.ShowModal;

  if NewMarkerForm.isOk then
     AddMarker(NewMarkerForm.MarkerName.Text, CurPosBL.lat, CurPosBL.long);
end;

procedure TMainForm.N2Click(Sender: TObject);
var CurPosBL : TLatLong;
begin
  CurPosBL := GetWGSCursor;
  PutBaseHere(CurPosBL.lat, CurPosBL.long);
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
 if AskMark<>-1 then
   DelMarker(AskMark);

  AskMark :=-1;
end;

//---------------------------------------------------------------------------
procedure TMainForm.OnDeviceCreate(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
begin
 // This variable returns "Success" to Device initialization, so if you
 // set it to False, device creation will fail.

// Success:= PBoolean(Param)^;

 try
   AsphImages.RemoveAll();
   AsphMapImages.RemoveAll();
   AsphFonts.RemoveAll();

   // This image is used by our bitmap font.
   AsphImages.AddFromASDb('font0.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('font1.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('font2.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('font3.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('font4.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('font5.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('font6.image', MediaASDb, '', False);

   AsphImages.AddFromASDb('arrow1.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('arrow2.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('arrow3.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('arrow4.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('az.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('spd.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('spd2.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('h.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('lh.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('rh.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('lock.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('unlock.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('flag.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('flag_big.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('marker1.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('marker1_big.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('arrow1_big.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('sat.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('dop.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('dot.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('hgtm.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('hgta.image', MediaASDb, '', False);

   AsphImages.AddFromASDb('s_inf.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_gps.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_aux.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_map.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_hgt.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_set.image', MediaASDb, '', False);

   AsphImages.AddFromASDb('s_tr1.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_tr2.image', MediaASDb, '', False);
   AsphImages.AddFromASDb('s_tr3.image', MediaASDb, '', False);


   Font0:= AsphFonts.Insert('Data/media.asdb | font0.xml', 'font0.image');
   Font1:= AsphFonts.Insert('Data/media.asdb | font1.xml', 'font1.image');
   Font2:= AsphFonts.Insert('Data/media.asdb | font2.xml', 'font2.image');
   Font3:= AsphFonts.Insert('Data/media.asdb | font3.xml', 'font3.image');
   Font4:= AsphFonts.Insert('Data/media.asdb | font4.xml', 'font4.image');
   Font5:= AsphFonts.Insert('Data/media.asdb | font5.xml', 'font5.image');
   Font6:= AsphFonts.Insert('Data/media.asdb | font6.xml', 'font6.image');

   AsphFonts[Font0].Kerning:=2;
   AsphFonts[Font1].Kerning:=1.2;
   AsphFonts[Font2].Kerning:=-1.5;
   AsphFonts[Font3].Kerning:= -1.5;
   AsphFonts[Font4].Kerning:= -1.5;
 finally
  // Success:= true ;
 end;

// PBoolean(Param)^:= Success;
end;


//---------------------------------------------------------------------------
procedure TMainForm.TimerEvent(Sender: TObject);
begin

  if Timer.FrameRate>0 then
    LagCount := 1 // Timer.FrameRate
      else
        LagCount := 0;

  AsphDevice.Render(Panel1.Handle, RenderEvent, clGray1);

  Timer.Process();
  
end;

//---------------------------------------------------------------------------
procedure TMainForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

          MShiftX := x ;
          MShiftY := y ;

end;

procedure TMainForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var Mas: Single;

begin

   Panel1CursorX  := x;
   Panel1CursorY  := y;

   ShowCurXY := ssRight in Shift;

    if ssLeft in Shift then
        begin
            Mas := Scale;
            Center.x := Center.x - ( x - MShiftX ) * Mas ;
            Center.y := Center.y + ( y - MShiftY ) * Mas ;
            MShiftX := x ;
            MShiftY := y ;
        end;

end;

procedure TMainForm.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var w: integer;
begin

            if Button = mbRight then
            begin
              if borderStyle<>bsNone then
                w:= GetSystemMetrics(SM_CYCAPTION)
              else
                w:=0;
              CheckNearestMarkers(x,y);
              PopupMenu1.Popup(x+left,y+top+w);
            end;

end;

procedure TMainForm.Panel1Resize(Sender: TObject);
begin
  MainForm.OnResize(nil);
end;


procedure TMainForm.ProcessEvent(Sender: TObject);
begin
//
end;

procedure TMainForm.PutBaseHere(B, L:Double);
var xx, yy : Double;
begin
  Base[2].x := B;
  Base[2].y := L;

  if UTM then
     GeoToUTM(WGS,Base[2].x,Base[2].y,South,yy,xx, Myzone, WaitForZone)
       else
          WGSToSK(Base[2].x,Base[2].y,0,xx,yy, MyZone, WaitForZone);

  Base[1].x := xx;
  Base[1].y := yy;
end;

//---------------------------------------------------------------------------
procedure TMainForm.ReComputeMaps(WFZ: Boolean);
var i,j :integer;
    xx, yy:Double;
begin
   WaitForZone := WFZ;

   for I := 0 to Length(MapList)- 1 do
      for j := 1 to 4 do
      Begin
         if UTM then
            GeoToUTM(WGS,MapList[i].Gx[j],MapList[i].Gy[j],South, yy,xx, Myzone, WaitForZone)
               else
                   WGSToSK(MapList[i].Gx[j],MapList[i].Gy[j],0, xx,yy, MyZone, WaitForZone);

         MapList[i].x[j] := xx;
         MapList[i].y[j] := yy;
         WaitForZone := false;
      End;
end;

procedure TMainForm.ReComputeRoutes(WFZ:Boolean);
var i:integer;
    xx,yy : Double;
    Str: String;
begin
//  ReCalcWay := true;

 // LoadedRoutesList.ListBox1.Clear;
  {if  RouteCount > 0 then
  Begin
    LoadedRoutesList.StringGrid1.RowCount :=RouteCount +1;
  End
   else
      Begin
        LoadedRoutesList.StringGrid1.RowCount :=2;
        for I := 0 to LoadedRoutesList.StringGrid1.ColCount-1 do
          LoadedRoutesList.StringGrid1.Cells[I,1] := '';
      End;}

  for I := 0 to RouteCount - 1 do
  begin
     if i=0 then
      WaitForZone := WFZ
       else
           WaitForZone := false;
           
    { LoadedRoutesList.ListBox1.Items.Add(Route[i].Name);
                                                                             ///11-05
     LoadedRoutesList.StringGrid1.Cells[0,I+1] := Route[I].Name;
     LoadedRoutesList.StringGrid1.Cells[1,I+1] := DegToDMS(Route[I].Gx1,true,4,false);
     LoadedRoutesList.StringGrid1.Cells[2,I+1] := DegToDMS(Route[I].Gy1,false,4,false);
     LoadedRoutesList.StringGrid1.Cells[3,I+1] := DegToDMS(Route[I].Gx2,true,4,false);
     LoadedRoutesList.StringGrid1.Cells[4,I+1] := DegToDMS(Route[I].Gy2,false,4,false);
     case Route[i].Status of
                 0 : Str := inf[38];
                 1 : Str := inf[39];
                 2 : Str := inf[40];
                 3 : Str := inf[41];
     end;
     LoadedRoutesList.StringGrid1.Cells[5,I+1] := Str;
      if Route[i].Geo = false then
      Begin
        if UTM then /// UTM
          UTMToGeo(WGS,Route[i].x1, Route[i].y1,South, xx, yy)
          else
           SKToWGS(Route[i].y1, Route[i].x1,0, xx, yy);
        Route[i].Gx1 := xx;
        Route[i].Gy1 := yy;

        if UTM then /// UTM
          UTMToGeo(WGS,Route[i].x2, Route[i].y2,South, xx, yy)
          else
            SKToWGS(Route[i].y2, Route[i].x2,0, xx, yy);
        Route[i].Gx2 := xx;
        Route[i].Gy2 := yy;

        Route[i].Geo := true;
      End;   }

      if Route[i].Geo then
      Begin
        if UTM then
            GeoToUTM(WGS,Route[i].gx1,Route[i].gy1,South,yy,xx, Myzone, WaitForZone)
             else
               WGSToSK(Route[i].gx1, Route[i].gy1,0, xx, yy, MyZone, WaitForZone);
        Route[i].x1 := xx;
        Route[i].y1 := yy;

        if UTM then
            GeoToUTM(WGS,Route[i].gx2,Route[i].gy2,South,yy, xx, Myzone, WaitForZone)
             else
                WGSToSK(Route[i].gx2, Route[i].gy2,0, xx, yy, MyZone, WaitForZone);
        Route[i].x2 := xx;
        Route[i].y2 := yy;
      End;

  end;

  if Frame then
  Begin
   if FrameGeo = false then
   for I := 0 to FrameCount - 1 do
   begin
     if UTM then /// UTM
          UTMToGeo(WGS,FramePoints[i,1].x, FramePoints[i,1].y,South, xx, yy)
            else
              SKToWGS(FramePoints[i,1].y, FramePoints[i,1].x,0, xx, yy);
      FramePoints[i,2].x := xx;
      FramePoints[i,2].y := yy;
      FrameGeo := True;
   end;
   
   if FrameGeo then
   for I := 0 to FrameCount - 1 do
   begin
     if UTM then
        GeoToUTM(WGS,FramePoints[i,2].x,FramePoints[i,2].y,South,yy,xx,Myzone, WaitForZone)
          else
            WGSToSK(FramePoints[i,2].x, FramePoints[i,2].y,0, xx, yy, MyZone, WaitForZone);
      FramePoints[i,1].x := xx;
      FramePoints[i,1].y := yy;
   end;
  End;

end;

procedure TMainForm.RefreshMarkerList;
var i:integer;
begin

 for I := 0 to MarkerCount - 1 do
   begin
     if Markers[I].Caption ='' then
       Markers[I].Caption := '*';

     if UTM then
        GeoToUTM(WGS,Markers[i].B, Markers[i].L,South,Markers[i].x, Markers[i].y,MyZone,False)
       else
         WGSToSK(Markers[i].B, Markers[i].L,0,Markers[i].x, Markers[i].y, MyZone, False);

   end;

end;

procedure TMainForm.DelMarker(DelI: integer);
var I:Integer;
begin
  Dec(MarkerCount);
  if MarkerCount>0 then
     for I := DelI to MarkerCount - 1 do
       Markers[I] := Markers[I+1];

  RefreshMarkerList;
end;


procedure TMainForm.ReLoadRoutes(FileName: String);
 var
     F : TStringList;
     I, J, I1, I2 : Integer;
     s1, s2 : String ;
     found, isBegin : Boolean;
     _X,_Y,_Z : double;
begin
   F := TStringList.Create;
   RouteCount := 0;

   FrameCount := 0;
   Frame := false;
   FrameGeo := false;


   if filename<>'' then
   try
     F.LoadFromFile(FileName);

     J :=0;
     for I := RoutesTabStart-1 to F.Count - 1 do
     if F[i]<>'' then
     begin

        i2 := i;

        isBegin := false;
        case LoadRData.RoutesBE.ItemIndex of
           0: begin
                s1 := GetCols(F[I2],RoutesNameTab,1, LoadRData.RSpacer.itemIndex);
                J := I;
                RouteCount := J+1;
              end;
           1: begin
                 s1 := GetCols(F[I2],RoutesNameTab,1, LoadRData.RSpacer.itemIndex);
                 J := Trunc(I/2);
                 RouteCount := J+1;
                 if I mod 2 = 0 then
                   isBegin := true;
              end;
           2: BEGIN
                s1 := GetCols(F[I2],RoutesNameTab,1, LoadRData.RSpacer.itemIndex);
                isBegin := (Copy(s1,length(s1),1)='a') or (Copy(s1,length(s1),1)='A');
                s1 := Copy(s1,1,length(s1)-1);

                if RouteCount=0 then
                begin
                  J :=0;
                  RouteCount:=1;

                end else
                  begin    /// ИЩУ ПО ИМЕНИ
                    found := false;
                    for J := 0 to RouteCount-1 do
                      if Route[J].Name = s1 then
                      begin
                        found := true;
                        break;
                      end;
                     if not found then
                     begin
                       J := RouteCount;
                       inc(RouteCount);
                     end;
                   end;
              END;
        end;

        Route[J].Name := s1;
        Route[J].Status := 0;

        Route[J].StartTime :='';
        Route[J].EndTime :='';
        Route[J].Rlabel :='';

        Route[J].Geo := (RoutesDatum = WGS) and (isRoutesDatum) and (RoutesCS = 0); //Settings.SK.ItemIndex=0;

        if LoadRData.RoutesBE.ItemIndex = 0 then
        begin

            // начало и конец
            if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesXTab,1, LoadRData.RSpacer.itemIndex),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesYTab,1, LoadRData.RSpacer.itemIndex),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesXTab,1, LoadRData.RSpacer.itemIndex));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesYTab,1, LoadRData.RSpacer.itemIndex));
                end;

            Route[J].Gx1 := _X;
            Route[J].Gy1 := _Y;
            if RoutesZTab<>-1 then
               Route[J].Gz1 := StrToFloat(GetCols(F[I2],RoutesZTab,1, LoadRData.RSpacer.itemIndex))
                  else
                    Route[J].Gz1 := 0;

            if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesX2Tab,1, LoadRData.RSpacer.itemIndex),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesY2Tab,1, LoadRData.RSpacer.itemIndex),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesX2Tab,1, LoadRData.RSpacer.itemIndex));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesY2Tab,1, LoadRData.RSpacer.itemIndex));
                end;

            Route[J].Gx1 := _X;
            Route[J].Gy1 := _Y;
            if RoutesZTab<>-1 then
              Route[J].Gz2 := StrToFloat2(GetCols(F[I2],RoutesZ2Tab,1, LoadRData.RSpacer.itemIndex))
                 else
                    Route[J].Gz2 := 0;

        end
          else
            if isBegin then
            begin
                // начало

               if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesXTab,1, LoadRData.RSpacer.itemIndex),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesYTab,1, LoadRData.RSpacer.itemIndex),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesXTab,1, LoadRData.RSpacer.itemIndex));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesYTab,1, LoadRData.RSpacer.itemIndex));
                end;

                Route[J].Gx1 := _X;
                Route[J].Gy1 := _Y;
                if RoutesZTab<>-1 then
                   Route[J].Gz1 := StrToFloat2(GetCols(F[I2],RoutesZTab,1, LoadRData.RSpacer.itemIndex))
                     else
                       Route[J].Gz1 := 0;
            end
              else
              begin
                // конец
                if ((isRoutesDatum)and(RoutesCS=0))
                or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
                begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesXTab,1, LoadRData.RSpacer.itemIndex),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesYTab,1, LoadRData.RSpacer.itemIndex),false);
                end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesXTab,1, LoadRData.RSpacer.itemIndex));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesYTab,1, LoadRData.RSpacer.itemIndex));
                end;

                Route[J].Gx2 := _X;
                Route[J].Gy2 := _Y;
                if RoutesZTab<>-1 then
                  Route[J].Gz2 := StrToFloat2(GetCols(F[I2],RoutesZTab,1, LoadRData.RSpacer.itemIndex))
                    else
                      Route[J].Gz2 := 0;

              end;

     end;

     for J := 0 to RouteCount-1 do
      if not Route[J].Geo then
      Begin
         Route[J].Geo := True;
         // ПЕРЕВОД В WGS

          if isRoutesDatum = false then
          begin
            /// RouteCS - CК

            if  CoordinateSystemList[RoutesCS].ProjectionType <=1 then
                CoordinateSystemToDatum(RoutesCS,
                                    Route[J].Gx1, Route[J].Gy1, Route[J].Gz1,
                                    Route[J].Gx1, Route[J].Gy1, Route[J].Gz1)
                else
                   CoordinateSystemToDatum(RoutesCS,
                                      Route[J].Gy1, Route[J].Gx1, Route[J].Gz1,
                                      Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);


            Geo1ForceToGeo2(Route[J].Gx1, Route[J].Gy1, Route[J].Gz1,
                            CoordinateSystemList[RoutesCS].DatumN, WGS,
                            Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);




            if  CoordinateSystemList[RoutesCS].ProjectionType <=1 then
                CoordinateSystemToDatum(RoutesCS,
                                    Route[J].Gx2, Route[J].Gy2, Route[J].Gz2,
                                    Route[J].Gx2, Route[J].Gy2, Route[J].Gz2)
                else
                   CoordinateSystemToDatum(RoutesCS,
                                      Route[J].Gy2, Route[J].Gx2, Route[J].Gz2,
                                      Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);

            Geo1ForceToGeo2(Route[J].Gx2, Route[J].Gy2, Route[J].Gz2,
                            CoordinateSystemList[RoutesCS].DatumN, WGS,
                            Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);


          end
            else
            begin
              /// RouteCS - тип проекции
              case RoutesCS of
                 0: begin
                   // B L
                   if RoutesDatum <> WGS then
                   Begin
                     Geo1ForceToGeo2(Route[J].Gx1,Route[J].Gy1,0, RoutesDatum,
                                   WGS, Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);
                     Geo1ForceToGeo2(Route[J].Gx2,Route[J].Gy2,0, RoutesDatum,
                                   WGS, Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);
                   End;
                 end;

                 1:   begin
                   // XYZ
                   ECEFToGeo(RoutesDatum,  Route[J].Gx1, Route[J].Gy1, Route[J].Gz1,
                             Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);
                   ECEFToGeo(RoutesDatum,  Route[J].Gx2, Route[J].Gy2, Route[J].Gz2,
                             Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);

                   if RoutesDatum <> WGS then
                   Begin
                     Geo1ForceToGeo2(Route[J].Gx1,Route[J].Gy1,0, RoutesDatum,
                                   WGS, Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);
                     Geo1ForceToGeo2(Route[J].Gx2,Route[J].Gy2,0, RoutesDatum,
                                   WGS, Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);
                   End;

                 end;
                 2:  begin
                   // GK
                   GaussKrugerToGeo(Route[J].Gy1, Route[J].Gx1,
                                    Route[J].Gx1, Route[J].Gy1 );
                   GaussKrugerToGeo(Route[J].Gy2, Route[J].Gx2,
                                    Route[J].Gx2, Route[J].Gy2 );

                   if RoutesDatum <> WGS then
                   Begin
                     Geo1ForceToGeo2(Route[J].Gx1,Route[J].Gy1,0, RoutesDatum,
                                   WGS, Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);
                     Geo1ForceToGeo2(Route[J].Gx2,Route[J].Gy2,0, RoutesDatum,
                                   WGS, Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);
                   End;

                 end;
                 3,4:  begin
                   // UTM
                   UTMToGeo(RoutesDatum, Route[J].Gy1, Route[J].Gx1, RoutesCS = 4,
                                    Route[J].Gx1, Route[J].Gy1 );
                   UTMToGeo(RoutesDatum, Route[J].Gy2, Route[J].Gy2, RoutesCS = 4,
                                    Route[J].Gx2, Route[J].Gy2 );

                   if RoutesDatum <> WGS then
                   Begin
                     Geo1ForceToGeo2(Route[J].Gx1,Route[J].Gy1,0, RoutesDatum,
                                   WGS, Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);
                     Geo1ForceToGeo2(Route[J].Gx2,Route[J].Gy2,0, RoutesDatum,
                                   WGS, Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);
                   End;

                 end;
              end;
            end;
      End;
    // FrameFile :='';

     Insert ('_f', Filename, Length(filename)-3);
     if Fileexists(Filename) then
     begin
         Frame := true;
         FrameFile := Filename;
         F.LoadFromFile(FileName);
         Frame := True;
         FrameGeo := (RoutesDatum = WGS) and (isRoutesDatum) and (RoutesCS = 0);


         j := 2;

         for I := 0 to F.Count - 1 do
         Begin
              if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I],1,1, LoadRData.RSpacer.itemIndex),true);
                 _Y := StrToLatLon(GetCols(F[I],2,1, LoadRData.RSpacer.itemIndex),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I],1,1, LoadRData.RSpacer.itemIndex));
                  _Y := StrToFloat2(GetCols(F[I],2,1, LoadRData.RSpacer.itemIndex));
                end;


             FramePoints[I, j].x := _X;// StrToFloat(GetCols(F[I],1,1, LoadRData.RSpacer.itemIndex));
             FramePoints[I, j].y := _Y;//StrToFloat(GetCols(F[I],2,1, LoadRData.RSpacer.itemIndex));
             if RoutesZTab<>-1 then
                FramePoints[I, j].z := StrToFloat2(GetCols(F[I],2,1, LoadRData.RSpacer.itemIndex))
                  else
                    FramePoints[I, j].z := 0;

             inc(FrameCount);
         End;

         if FrameCount>1  then
         begin
            inc(FrameCount);
            FramePoints[FrameCount-1, j].x := FramePoints[0, j].x;
            FramePoints[FrameCount-1, j].y := FramePoints[0, j].y;
         end;


         if not FrameGeo then
            for J := 0 to FrameCount - 1 do
            Begin
               if isRoutesDatum = false then
               begin

                 if  CoordinateSystemList[RoutesCS].ProjectionType <=1 then
                      CoordinateSystemToDatum(RoutesCS,
                                    FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z,
                                    FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z)
                      else
                         CoordinateSystemToDatum(RoutesCS,
                                      FramePoints[J, 2].y, FramePoints[J, 2].x, FramePoints[J, 2].z,
                                      FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);

                 Geo1ForceToGeo2(FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z,
                            CoordinateSystemList[RoutesCS].DatumN, WGS,
                            FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);

                //  ShowMessage(FloaTToStr(FramePoints[J, 2].x)+'  '+ FloaTToStr(FramePoints[J, 2].y))
               end
                else
                BEGIN
                   case RoutesCS of
                   0: begin
                   // B L
                     if RoutesDatum <> WGS then
                        Geo1ForceToGeo2(FramePoints[J, 2].x, FramePoints[J, 2].y,0, RoutesDatum,
                                   WGS, FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);


                   end;

                   1: begin
                   // XYZ
                     ECEFToGeo(RoutesDatum,  FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z,
                               FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);

                    if RoutesDatum <> WGS then
                        Geo1ForceToGeo2(FramePoints[J, 2].x, FramePoints[J, 2].y,0, RoutesDatum,
                                   WGS, FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);


                   end;
                   2:  begin
                   // GK
                     GaussKrugerToGeo(FramePoints[J, 2].y, FramePoints[J, 2].x,
                                      FramePoints[J, 2].x, FramePoints[J, 2].y);

                     if RoutesDatum <> WGS then
                        Geo1ForceToGeo2(FramePoints[J, 2].x, FramePoints[J, 2].y,0, RoutesDatum,
                                   WGS, FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);

                     // ShowMessage(FloaTToStr(FramePoints[J, 2].x)+'  '+ FloaTToStr(FramePoints[J, 2].y))
                   end;
                   3,4:  begin
                   // UTM
                   UTMToGeo(RoutesDatum, FramePoints[J, 2].y, FramePoints[J, 2].x, RoutesCS = 4,
                                    FramePoints[J, 2].x, FramePoints[J, 2].y );


                    if RoutesDatum <> WGS then
                        Geo1ForceToGeo2(FramePoints[J, 2].x, FramePoints[J, 2].y,0, RoutesDatum,
                                   WGS, FramePoints[J, 2].x, FramePoints[J, 2].y, FramePoints[J, 2].z);



                   end;
                   end;
                END;
            End;
         FrameGeo := True;
     end;

     ///---
   {

            else
            begin
              /// RouteCS - тип проекции

            end;
                  }
     ///---

     ReComputeRoutes(false);
 except
   MessageDlg('Unable to load routes',mtError, [mbOk],0);
 end;

 F.Destroy;

end;


procedure TMainForm.AxelScale;
const k = 1.5;
var Stp : double;
begin
////
  _Scale  := TMashtab[Mashtab]/100;

  Stp := Timer.Delta;
 /// Caption := FloatTostr(stp);
  if Stp > 5 then
     Stp := 5;
  if Stp < 0.25 then
     Stp := 0.25;

     Stp := 5*k/Stp;

  if Abs((Scale - _Scale)) > _Scale/100 then
  Begin
     if True then
     
     Scale := Scale - (Scale - _Scale)/Stp
  End
     else
        Scale := _Scale;

end;

procedure TMainForm.RenderEvent(Sender: TObject);
begin

  if not SmoothScale then
  Begin
     Scale  := TMashtab[Mashtab]/100;
     _Scale := Scale;
  End
     else
        AxelScale;

  if ShowMaps then
     ReDrawMaps;

  ReDrawLines(true);

  ReDrawRoutes;
  RedrawBase;
  RedrawMarkers;

  DrawScaleAndNord;

end;



procedure TMainForm.ResetMaps;
begin
   ShowMaps := False;
   AsphMapImages.RemoveAll();
   SetLength(MapList,0);
end;

procedure TMainForm.ReDrawBase;
var dx, dy, dx2, dy2, x, y, fi : Double;
    csize: integer;
begin
//// Base
///
     fi := 0;

     dx := (Center.x - Base[1].x)/ Scale ;
     dy := (Center.y - Base[1].y)/ Scale ;

     dx2 := dx * Cos (Fi) + dy * Sin(Fi);
     dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

     x := round ((DisplaySize.X) div 2 - dx2 );
     y := DisplaySize.y -  round (DisplaySize.y div 2 - dy2 ) + VYShift;

     csize := 32;
     if BigCur then
        csize := 64;

     if (x > - csize)and(x < (DisplaySize.X) + csize) then
       if (y > - csize)and(y < DisplaySize.y + csize) then
         begin
            if BigCur then
                AsphCanvas.UseImagePx(AsphImages.Image['flag_big.image'], pxBounds4(0, 0, 64, 64))
                else
                   AsphCanvas.UseImagePx(AsphImages.Image['flag.image'], pxBounds4(0, 0, 32, 32));

             AsphCanvas.TexMap(pRotate4c(Point2(x,
                    y),Point2(csize, csize), 0),
                    cColor4(ClRed1));

         end;
end;

procedure TMainForm.ReDrawLines(dash:Boolean);
var  i, j, lcount, lstep : Integer;
     x1, y1, x2, y2, dx, dy, dx2, dy2 : Double ;
     Mas, fi    : double ;
begin
    Mas := Scale; //TMashtab[Mashtab]/100 ;

    fi := 0;

    if Mashtab<MaxMashtab-2 then
      lstep := TMashtab[Mashtab+1]
        else
          lstep := TMashtab[Mashtab];

      if (DisplaySize.X) > DisplaySize.y then
          lcount := trunc((DisplaySize.X) /2 * mas / lstep)+1
            else
              lcount := trunc(DisplaySize.y /2 * mas / lstep)+1;

    for J := -lcount to lcount do
    Begin

         x1 :=Trunc(Center.x /lstep)*lstep;// + I*lstep;
         y1 :=Trunc(Center.y /lstep)*lstep + J*lstep;

         x2 := x1 + (DisplaySize.X) * mas;
         y2 := y1;// + (DisplaySize.X - MenuW) * mas;
         x1 := x1 - (DisplaySize.X) * mas;
         y1 := y1;// - (DisplaySize.X - MenuW) * mas;

         dx := (Center.x - x1)/ Mas ;
         dy := (Center.y - y1)/ Mas ;

         dx2 := dx * Cos (Fi) + dy * Sin(Fi);
         dy2 := -dx * Sin (Fi) + dy * Cos(Fi);

         x1 := round ((DisplaySize.X ) div 2 - dx2);
         y1 := DisplaySize.y -  round (DisplaySize.y div 2 - dy2) + VYShift;

         dx := (Center.x - x2)/ Mas ;
         dy := (Center.y - y2)/ Mas ;

         dx2 := dx * Cos (Fi) + dy * Sin(Fi);
         dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

         x2 := round((DisplaySize.X ) div 2 - dx2);
         y2 := DisplaySize.y - round(DisplaySize.y div 2 - dy2) + VYShift;

         MyLine(x1, y1, x2, y2, Dash, {LinesColor} ClWhite1);
    end;

    for I := -lcount to lcount do
    begin
         x1 :=Trunc(Center.x /lstep)*lstep + I*lstep;
         y1 :=Trunc(Center.y /lstep)*lstep; //+ J*lstep;

         x2 := x1;// + (DisplaySize.X - MenuW) * mas;
         y2 := y1 + (DisplaySize.X) * mas;
         x1 := x1;// - (DisplaySize.X - MenuW) * mas;
         y1 := y1 - (DisplaySize.X) * mas;

         dx := (Center.x - x1)/ Mas ;
         dy := (Center.y - y1)/ Mas ;

         dx2 := dx * Cos (Fi) + dy * Sin(Fi);
         dy2 := -dx * Sin (Fi) + dy * Cos(Fi);

         x1 := round ((DisplaySize.X) div 2 - dx2);
         y1 := DisplaySize.y -  round (DisplaySize.y div 2 - dy2) + VYShift;

         dx := (Center.x - x2)/ Mas ;
         dy := (Center.y - y2)/ Mas ;

         dx2 := dx * Cos (Fi) + dy * Sin(Fi);
         dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

         x2 := round((DisplaySize.X) div 2 - dx2);
         y2 := DisplaySize.y - round(DisplaySize.y div 2 - dy2) + VYShift;

         MyLine(x1, y1, x2, y2, dash, {LinesColor}ClWhite1);
    End;

end;

procedure TMainForm.ReDrawMaps;
const MenuW = 0;
var  i, j, ImgN : Integer;
     _x, _y : array [1..4] of Double;
     Mas, fi, dx, dy, dx2, dy2, L, xmin, ymin, xmax, ymax : double ;
     Col : TColor4;
begin


     fi := 0;


    for I := 0 to Length(MapList) - 1 do
    Begin
       for j := 1 to 4 do
       Begin
          dx := (Center.x - MapList[i].x[j])/ Scale ;
          dy := (Center.y - MapList[i].y[j])/ Scale ;

          dx2 := dx * Cos (Fi) + dy * Sin(Fi);
          dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

          _x[j] := round ((DisplaySize.X - MenuW) div 2 - dx2 );
          _y[j] := DisplaySize.y -  round (DisplaySize.y div 2 - dy2 ) + VYShift;
       End;

       try
          L := sqrt(sqr(_x[4]-_x[1])+sqr(_y[4]-_y[1]));
       except
         continue;
       end;

       if (L < 5 * MinMap) then
         continue;

       if (L > 5 * MaxMap) then
         continue;


       xmin := _x[1];
       ymin := _y[1];
       xmax := _y[1];
       ymax := _y[1];
       for j := 2 to 4 do
       begin
         if _x[j] < xmin then
           xmin := _x[j];
         if _y[j] < ymin then
           ymin := _y[j];

         if _x[j] > xmax then
           xmax := _x[j];
         if _y[j] > ymax then
           ymax := _y[j];
       end;

       if (xmax<0)and(xmin<0) or (xmax > DisplaySize.X)and(xmin > DisplaySize.X) then
           continue;
           
       if (ymax<0)and(ymin<0) or (ymax > DisplaySize.Y)and(ymin > DisplaySize.Y) then
           continue;


       if L<45 then
           ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName+'_t'] )
          //AsphCanvas.UseImagePx(AsphMapImages.Image[MapList[i].imgName+'_t'], pxBounds4(0, 0, 32, 32))
           else
           if l<220 then
              ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName+'_s'] )
             //AsphCanvas.UseImagePx(AsphMapImages.Image[MapList[i].imgName+'_s'], pxBounds4(0, 0, 128, 128))
               else
                 ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName] );
                 // AsphCanvas.UseImagePx(AsphMapImages.Image[MapList[i].imgName], pxBounds4(0, 0, 512, 512));

       if ImgN=-1 then
          ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName] );
       AsphCanvas.UseImagePx(AsphMapImages.Items[ImgN], pxBounds4(0, 0,
                  AsphMapImages.Items[ImgN].PatternSize.x, AsphMapImages.Items[ImgN].PatternSize.y ));

       if MapAlpha=255 then
         Col := ClWhite4
          else
           Col := cRGB4(255,255,255,MapAlpha);

        AsphCanvas.TexMap(Point4( _x[1], _y[1],  _x[2], _y[2],
                          _x[3], _y[3],  _x[4], _y[4]), Col)


   End;


end;

procedure TMainForm.ReDrawMarkers;
var dx, dy, dx2, dy2, x, y, fi: Double;
    csize, i, j, Fnt, w : integer;
    canLabel :boolean;
begin
//// Base
///
     if MarkerCount<1 then
       exit;


     fi := 0;

     for I := 0 to MarkerCount - 1 do
     Begin
       dx := (Center.x - Markers[I].x)/ Scale ;
       dy := (Center.y - Markers[I].y)/ Scale ;

       dx2 := dx * Cos (Fi) + dy * Sin(Fi);
       dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

       x := round ((DisplaySize.X) div 2 - dx2 );
       y := DisplaySize.y -  round (DisplaySize.y div 2 - dy2 ) + VYShift;

       Markers[i].iX := trunc(x);
       Markers[i].iY := trunc(y);
       
       csize := 16;
       if BigCur then
         csize := 32;

       if (x > - csize)and(x < (DisplaySize.X) + csize) then
       if (y > - csize)and(y < DisplaySize.y + csize) then
          begin
            if BigCur then
                AsphCanvas.UseImagePx(AsphImages.Image['marker1_big.image'], pxBounds4(0, 0, csize , csize ))
                else
                   AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'], pxBounds4(0, 0, csize , csize ));

             AsphCanvas.TexMap(pRotate4c(Point2(x,
                    y),Point2(csize, csize), 0),
                    cColor4(ClRed1{MenuChoosedColor}));

            canLabel := true;
            
            Markers[i].OnScreen := true;

            if Markers[i].Caption<>'*' then
            try

              if BigCur then
                Fnt := Font4
                  else Fnt := Font5;

              w := round(AsphFonts[Fnt].TextWidth(Markers[i].Caption)/2);
              Markers[i].iW := w;

              for J := 0 to MarkerCount - 1 do
                if I<>j then
                 if Markers[j].OnScreen then
                  if (y > Markers[j].iY-csize*2)and(y < Markers[j].iY+csize*2) then
                   if (x+w > Markers[j].iX-Markers[j].iw)and(x-w < Markers[j].iX+Markers[j].iw) then
                     begin
                        canlabel := false;
                        break;
                     end;

              if BigCur then
                dy := 0
                else
                  dy := cSize;

              if CanLabel then
                 AsphFonts[Fnt].TextOut(Point2(trunc(x)-w,trunc(y)-cSize-trunc(dy)),
                                         Markers[i].Caption,clWhite2);
            except
            end;
         end
           else
            Markers[i].OnScreen := false;

     End;
end;


procedure TMainForm.ReDrawRoutes;
       var i  : Integer;
           L      : Double;
           x, y   : integer;
           x2, y2 : Integer;
           _x, _y   : integer;
           _x2, _y2 : Integer;
           cur1, cur2: TMyPoint;
           Mas    : double;
           w, h   : Integer;
           fi, fi2: double;
           dx, dy : double;
           dx2,dy2 : double;
           s      : string;
begin

    if RouteCount = 0  then
      exit ;

      w := (DisplaySize.X);
      h := DisplaySize.y;

      Mas := Scale; //TMashtab[Mashtab]/100 ;

      for i := 0 to RouteCount  -1 do
      begin

             fi := 0;

             dx := (Center.x - Route[i].x1)/ Mas ;
             dy := (Center.y - Route[i].y1)/ Mas ;

             dx2 := dx * Cos (Fi) + dy * Sin(Fi);
             dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

             x := round (w div 2 - dx2 );
             y := h -  round (h div 2 - dy2 ) + VYShift;

             dx := (Center.x - Route[i].x2)/ Mas ;
             dy := (Center.y - Route[i].y2)/ Mas ;

             dx2 := dx * Cos (Fi) + dy * Sin(Fi);
             dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

             x2 := round(w div 2 - dx2);
             y2 := h - round(h div 2 - dy2) + VYShift;


                      FatLine(x, y, x2, y2, 0+DopFat, false, {RoutesColor}ClLime1)


      end ;

  //////////// FRAME

      if Frame and ShowFrame then
         if FrameCount  >1 then
         Begin
            for i := 0 to FrameCount  -2 do
            begin

               dx := (Center.x - FramePoints[i,1].x)/ Mas ;
               dy := (Center.y - FramePoints[i,1].y)/ Mas ;

               dx2 := dx * Cos (Fi) + dy * Sin(Fi);
               dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

               x := round (w div 2 - dx2 );
               y := h -  round (h div 2 - dy2 ) + VYShift;

               dx := (Center.x - FramePoints[i+1,1].x)/ Mas ;
               dy := (Center.y - FramePoints[i+1,1].y)/ Mas ;

               dx2 := dx * Cos (Fi) + dy * Sin(Fi);
               dy2 :=-dx * Sin (Fi) + dy * Cos(Fi);

               x2 := round(w div 2 - dx2);
               y2 := h - round(h div 2 - dy2) + VYShift;

               FatLine(x, y, x2, y2, 1+DopFat, false,clRed1);
            end;
       End;

   ///////////// CURRENT ПОВЕРХ ВСЕГО



end;


function SecToHMS(Sec : double) :string ;
var H,M: Integer;
    s, Hh :Double;
    sH, sM, sS, SMm : String;
begin

  Hh := Sec/3600;

  H := trunc(Hh);
  M := trunc(frac(Hh)*60);
  s := (frac(Hh)*60-M)*60;

  if round(s*1000) >= 60000 then
  begin
     s := s - 60;
     if s < 0 then
       s := 0;
     inc(M);
  end;
  if M >=60 then
  begin
     M := M - 60;
     if M < 0 then
       M := 0;
     inc(H);
  end;

  sH  := inttostr(H);
  sM  := inttostr(M);
  sS  := format('%.2f',[s]);

  if M < 10 then
  begin
    sM := '0' + sM;
  end;

  if s < 10 then
    sS := '0' + sS;

  Result:= sH + ':'+ sM + ':' + Ss ;
end;

procedure TMainForm.ShiftMap(Key: Byte);
var Mas, mShiftX, mShiftY :real;
begin
  Mas := Scale;
  mShiftX := 0;
  mShiftY := 0;

  case Key of
   0: if Mashtab < MaxMashtab-1 then
          Inc(Mashtab);
   1: if Mashtab > 0 then
          Dec(Mashtab);

   2:  mShiftY := DisplaySize.y *0.15;
   3:  mShiftY := -DisplaySize.y *0.15;
   4:  mShiftX := (DisplaySize.X ) *0.25;
   5:  mShiftX := -(DisplaySize.X ) *0.25;
 end;

 Center.x := Center.x - MShiftX*Mas ;
 Center.y := Center.y + MShiftY*Mas ;
end;

procedure TMainForm.SKToWGS(x, y, h: Double; var B, L: Double);
var B2, L2, H2, h1 : Double;
begin

  GaussKrugerToGeo(x, y, B2, L2);
  Geo1ToGeo2(B2, L2, 0, SK, WGS, B, L, H1);

end;

{procedure TMainForm.SmartMenuKeyCommand(Key: Byte);
begin
 ///
 case Key of
    1: Begin  /// UP
       if SmartN > 4 then
         SmartN := SmartN-4;
       if SmartN < 0 then
         SmartN := SmartN+4;
    End;

    2: Begin   /// DOWN
      if SmartN<= SmartCount then
         SmartN := SmartN+4;
      if SmartN > SmartCount then
         SmartN := SmartN-4;    
    End;

    3: Begin   /// LEFT
      if SmartN<=0 then
         SmartN := SmartCount
           else
          dec(SmartN);
         
       if SmartN < 0 then
         SmartN := SmartCount;
    End;

    4: Begin
     // if SmartN = 0 then
     //  SmartN := 5
     //  else
        //if (SmartN <> 4) then
         inc(SmartN)  ;
        //  else SmartN := 0; 

      if SmartN > SmartCount then
         SmartN := 0;
    End;

    5: Begin   ///  ENTER
        case SmartN of
          -1, 0: inSmart := false;
	        1: begin
            ShowInfo := not (ShowInfo);

          end;
          2: begin
             if MaxDotsVisible = 0 then
               MaxDotsVisible := MaxDotsCount
             else
             if MaxDotsVisible = MaxDotsCount then
              MaxDotsVisible := 1000
              else
                if MaxDotsVisible = 1000 then
                   MaxDotsVisible := 0
          end;
          3: begin 
            if Length(MapList)<>0 then
                ShowMaps := not ShowMaps;
            if ShowMaps then
                RecomputeMaps(False);
          end;
          4: begin
             Timer.Enabled:= False;
             Settings.ShowModal;
            
          end;
          5: begin
             ConnectCOM(ComPort1);
          end;
          6: begin
             ConnectCOM(ComPort2);
          end;

          7: begin
            HgtLine := not (HgtLine);
          end;

          8: Begin

          End;
        end;

    End;

    6: Begin   ///  ESC
       
       inSmart := false;

    End;

  end;
end;    }
//---------------------------------------------------------------------------

procedure TMainForm.WGSToSK(B, L, H: Double; var x, y: Double; Zone: Integer;
  autozone: boolean);
var Bsk, Lsk, Hsk : Double;
begin

  Geo1ToGeo2(B, L, H, WGS, SK, Bsk, Lsk, Hsk);
  GeoToGaussKruger(Bsk, Lsk, y, x, Zone, AutoZone);

  if AutoZone then
  begin
     MyZone := Zone;
  end;
end;

procedure TMainForm.WMDisplayChange(var message: TMessage);
begin
 // This event happens when user changes screen resolution.
 //
 // We also detect if the screen resolution has changed because of our
 // full screen mode, in which case we simply exit.
 if (Tag = 1) then Exit;

 if (AsphDevice <> nil)and(AsphDevice.Active)and(AsphDevice.Windowed) then
  AsphDevice.Reset();
end;

//---------------------------------------------------------------------------
end.
