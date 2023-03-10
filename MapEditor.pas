unit MapEditor;

interface

uses MapFunctions, GeoFunctions, TabFunctions, Vectors2, Windows,
     AbstractCanvas, AbstractDevices, AsphyreImages, AsphyreTypes, AsphyreDb,
     Classes, FLoader, SysUtils, GeoClasses, GeoString, Dialogs, DrawFunctions,
     BasicMapObjects, RTypes, Math, GeoMath, LangLoader, UDF_reader,
     PointClasses, DubinsPath;

type
  TRouteCut = record
    x, y : Double;
    RouteN, SegmentN, CutN : integer;
  end;

  type
  TPicket = record
    x, y : Double;
    Name :String;
  end;

  type
  TKnot = record
    Name    :String;   // ??? ???????
    L       :Integer;  // ????? ???????????
    NameKind:Byte;     // ??? ?????
    NameKind2:Byte;    // ?????????/??????? ??????

    Cx, Cy  :Double;   // ?????????? ??????
    BoxSize :Double;   // ??????? ?????
    BoxAngle:Double;   // ???? ??????????
    BoxSize2:Double;  // ??????? 2 ?????

    RouteAngle:Double; // StartA

    PMethod:Integer;       // ????? ??????????? ???????
    Lx, Ly, Lmax: Double;  // ??????????? ???????
    StepOut :Integer;      // ????? ????? ??? ??? ? ???????

    DropToRoute :Boolean;
    RouteN :Integer;

    Shp    :Byte;
    ShStep :Double;
  end;

  TKnotStat = record
    Count: Integer;
    InArea: Integer;

    Pickets, Pmin, Pmax :Integer;
    AvgPicketsByLoop:Double;
    AvgSize, SizeMin, SizeMax: Double;
  end;

 //// MarkerEd
  procedure MouseMarkers(minX, minY, maxX, maxY :Double; Max: Integer; Mode:Byte);
  procedure MouseKnots(minX, minY, maxX, maxY :Double; Max: Integer; Mode:Byte);

  procedure GetKnotMarkerList(var SL:TStringList; FromN:Integer);
  function GetKnotStat(byMarkers:Boolean):TKnotStat;

  procedure DelKnot(DelI: integer);

  procedure JumpToSelRoutesMap;

 ///// MapEditor
  procedure GetMapsUnderPoint(B,L: Double);
  procedure MapInfoHUD;
  procedure DeleteMap(N:Integer);

  procedure SaveToAsdb(FileName: String; NewFileName:String);
//  procedure MapUp(I:Integer);
//  pocedure MapDown(I:Integer);

 //// RouteEditor
 ///
  function  isFrameClockWise :boolean;
  procedure RotateFrameOrder(Fwd:boolean);

  procedure AddRTSInfo(var S:TStringList);

  procedure SaveRTSFile(FileName:String; AskifExist:boolean);
  procedure SaveTXTFile(FileName:String; Datum, CS, RT, fmt:Integer;  Sep:String;
      AskifExist:boolean);
  procedure SaveBLNFile(FileName:String; isUTM:boolean; AskifExist:boolean);
  procedure SaveBLNKnotFile(FileName:String; CS, StartI: Integer;
                          fKind, fOrder:Byte; AskifExist:boolean);
  procedure SaveLstFile(FileName:String; AskifExist:boolean);
  procedure SaveMission(FileName:String; AskifExist:boolean);
  procedure SaveKmlFile(FileName, HgtMode:String; AskifExist:boolean);
  procedure SaveGPXFile(FileName:String; AskifExist:boolean; doPickets,
     doCorners, doCenters, doRoutes, doKnots, doArea, AskArea: boolean;
     StartI:integer; DoEachFile, DoDir: boolean);  overload;

  procedure SaveGPXFile(FileName:String; AskifExist:boolean);  overload;
  procedure SaveGPXFile(FileName:String; StartI:integer; AskifExist:boolean);  overload;
  procedure SaveXYZFile(FileName:String; CS, StartI:integer;
             DoRound, DoExt, AskifExist:boolean);
  procedure SaveMXYZFile(FileName:String;
             CS, StartI:integer; DoRound, DoNames, DoExt, AskifExist:boolean);

  procedure LoadGPXFile(FileName:String; doAdd:Boolean);
  procedure LoadRoutesMission(FileName:String; doAdd:Boolean);
  procedure LoadKMLFile(FileName:String; doRoutes, doPoints, doArea,
                            doTrack, doAdd:Boolean);

  procedure SaveMarkers(FileName:String; AskifExist: Boolean);
  procedure SaveTXTMarkers(FileName:String; CS, Fmt:Integer;  Sep:String;
                     SaveH, SaveHGeo:Boolean; AskifExist: Boolean);

  procedure SaveTXTKnotMarkers(FileName:String; CS, StartI:Integer;  Sep:String;
         dPickets, dCorners, dCenters, doHeader, doNumbers :Boolean;
         AskifExist:boolean; DoEachFile, DoDir: boolean);

  procedure ReverseFrame;
  procedure SplitFrame(step, FirstDeg :Double; StartN:integer;  XShift :Double;
           ExtraEnd, DegIsDA, doAdd, doFixD: boolean);
  procedure FrameLeadSide(Col:Cardinal);
  procedure ExpandShortRoutes(MinL: real; N:integer);

  procedure DoKnots(RN: Integer; Step, Radius, Angle: Double;
      AddAngle:Boolean; NameKind:Byte; FromN:Integer; ShiftL: Double;
      DoContinue:Boolean; PMethod:Integer; StartA, dA, Lx, Ly, Lmax: Double;
      NameKind1, NameKind2, StepOut :Byte; DropToRoute :Boolean;
      AllL:Boolean; LFrom:Integer; Chess:Byte);

  procedure DoAreaKnots(isChess: Byte; StepX, StepY, StepA, Radius, Angle: Double;
      AddAngle:Boolean; NameKind:Byte; FromN:Integer; ShiftL: Double;
      PMethod:Integer; StartA, dA, Lx, Ly, Lmax: Double;
      NameKind1, NameKind2, StepOut :Byte; StepOutX, StepOutY :Double;
      DropToRoute :Boolean; RNames:String; FromSouth:Boolean;
      AllL:Boolean; LFrom:Integer);

  procedure OrthoRoutes(RN: Integer; Do1:Boolean; StepOut, Step, Ls, Rs : Double;
      FromN:Integer; Name, NameSep:String);

  function EdPktsCount(FN: String; StartFrom: Integer):integer;
  function LoadEpPkts(FN: String; N, StartFrom: Integer):string;

  function SaveKnots(FileName:String; AskifExist:boolean):boolean;
  procedure LoadKnots(FileName:String; DoAdd:Boolean);

  procedure GetKnotPickets(Knot:TKnot; TestOnly :Boolean);
  procedure LoadCurrentLT(N:Integer);

  procedure KnotsToMarkers(doPickets, doCorners, doCenters :Boolean);

  procedure KillNewKnots;

  procedure RenumberKnots(RMethod: Byte; isAll: Boolean;
      AddL, StepL:Integer; DoSort:Boolean);

  procedure DrawRoutesEd(AsphCanvas: TAsphyreCanvas; EdMode: Integer;
      ChoosedColor, RoutesColor, DoneColor, FrameColor, FntColor, MenuColor,
      HiddenColor:Cardinal;
      Smooth: Boolean; RouteN:integer; DrawAll:Boolean; Lstyle: Integer);

  procedure RefreshSelectionArrays;

  procedure CreateFramePoint(B, L : Double);
  procedure DeleteFramePoint(Num:integer);
  procedure ShiftSelectedFramePoints(N, E : real);
  procedure DeleteSelectedFramePoints;
  procedure AddPointToFrame;

  
  procedure MergeRoutesArr(A: array of Integer; DoRad, DoLoop :Boolean;
                Rad :Double; Step, RadStep, NewH : Integer; RName :String);

  procedure AddRoute(RName:String);
  procedure AddPointToRoute(RouteN: integer);
  procedure DeleteRoutePoint(RouteN, N: integer);
  procedure DelRoute(RouteN: integer);
  procedure ReplaceRoute(N1, N2: integer);
  procedure RewerseRoute(RouteN: integer);
  procedure DeleteSelectedRoutePoints;
  procedure ShiftSelectedRoutePoints(N, E : real);
  procedure ShiftSelectedMarker(N, E : real);
  procedure ShiftSelectedKnot(N, E : real);

  procedure MarksFromRoute(R:TRoute;  SpecialName, Sep:String; Shifted:boolean);

  function  RouteStepBreak(RouteN: Integer; Step: Double;
     AddM :Boolean; MnameKind:Byte; Mfrom, Mstep :Double; MSep:string; DoEnd:Boolean):TRoute;   overload;
  function  RouteStepBreak(RouteN: Integer; Step: Double):TRoute;   overload;
  procedure RouteFromMarkers(RName:String);

  procedure DrawSelectionDot(x, y: Double);

  procedure DrawFrameSelectionPoints(P1, P2:TMyPoint); overload;
  procedure DrawFrameSelectionPoints(L1, L2:TLatLong); overload;
  procedure DrawFrameSelectionPoints(L1 :TLatLong); overload;

  procedure DrawRoutesSelectionPoints(P1, P2:TMyPoint; RouteN:Integer); overload;
  procedure DrawRoutesSelectionPoints(L1, L2:TLatLong; RouteN:Integer); overload;
  procedure DrawRoutesSelectionPoints(L1 :TLatLong; RouteN:Integer); overload;

  procedure DrawChoosedMarker(Color: Cardinal; DoLoops:Boolean);
  procedure DrawMarkersToChoose(BL1, BL2:TLatLong);
  procedure DrawKnots(Col, NewCol, ChoosedCol,  MenuColor, FntColor: Cardinal;
      LStyle:Byte; Smooth:Boolean; BL1, BL2 :TLatLong; AllLabels, NewPickets :Boolean);

  procedure SelectFramePoints(P1, P2 :TMyPoint; DelMode: boolean);  overload;
  procedure SelectFramePoints(L1, L2 :TLatLong; DelMode: boolean);  overload;
  procedure SelectFramePoints(L1 :TLatLong; DelMode: boolean);  overload;

  function SelectFrameSide(x, y: real):integer;   overload;
  function SelectFrameSide(P :TMyPoint):integer;  overload;

  procedure SelectRoutesPoints(P1, P2 :TMyPoint; DelMode: boolean; RouteN:Integer);  overload;
  procedure SelectRoutesPoints(L1, L2 :TLatLong; DelMode: boolean; RouteN:Integer);  overload;
  procedure SelectRoutesPoints(L1 :TLatLong; DelMode: boolean; RouteN:Integer);  overload;

  procedure SelectRoutes(P1, P2 :TMyPoint; DelMode: boolean);  overload;
  procedure SelectRoutes(L1, L2 :TLatLong; DelMode: boolean);  overload;
  procedure SelectRoutes(L1 :TLatLong; DelMode: boolean);  overload;

  procedure FindPointsForFrame(P: TMyPoint); overload;
  procedure FindPointsForFrame(L: TLatLong); overload;

  procedure FindPointsForRoutes(P: TMyPoint; RouteN: Integer); overload;
  procedure FindPointsForRoutes(L: TLatLong; RouteN: Integer); overload;

  function DropPointToFrame(P: TMyPoint):TMyPoint;  overload;
  function DropPointToFrame(L: TLatLong):TMyPoint;  overload;

  function DropPointToRoute(P: TMyPoint):TMyPoint;  overload;
  function DropPointToRoute(L: TLatLong):TMyPoint;  overload;

  function DropPointToPoint(P: TMyPoint; Sens, EdMode: Integer):TMyPoint;  overload;
  function DropPointToPoint(L: TLatLong; Sens, EdMode: Integer):TMyPoint;  overload;

  function DropPointToLoop(P: TMyPoint; Sens, EdMode: Integer):TMyPoint;   overload;

  procedure DrawAllLabels(PointNumbers, FrameNumbers: boolean; FntColor,
               MenuColor, SelColor :Cardinal; DrawAll:Boolean; LStyle, PMode:Integer);
  procedure DrawFrameLabels(FntColor, MenuColor :Cardinal; DrawAll:Boolean; Lstyle:integer);

  procedure GetCuttingPoints(RouteN:Integer; InfCut :boolean);
  procedure CutRoutes;
  procedure DrawCuttingPlane(FntColor:Cardinal; Smooth: Boolean; InfCut :boolean);

  procedure CollapseRoutes(R1, R2: Integer);
  procedure CopyRoute(CopyRouteN, CopyCount: Integer; CopyShift, ShiftAngle :Double;
            CopyName :String; AddN : Boolean; NStart, NStep: Integer);
  procedure MadeDevStar(DCenter :TMyPoint; DRad : Double; RNumber:Integer;
                         DName:String; Gap:Integer; DoFD:Boolean; Az:Double);

  procedure RoutesToGeo;
  procedure FrameToGeo;
  procedure MarkersToGeo;

  procedure AnalyseUDF(FN:String; uCS, uDatum: integer; isDatum,
           skipH, ROrder: boolean;  var X, Y, H, B, L, RMSp, RMSh :Double);

  procedure UDFToMarker(FN:String; uCS, uDatum: integer; isDatum,
           skipH, ROrder: boolean);

  function GetMarkerKnotCenter(Mname :string; var x, y : Double) :boolean;

  function FrameUnderMouse(sens :integer): boolean;
  function MarkersUnderMouse(sens :integer): boolean;
  function KnotsUnderMouse(sens :integer): boolean;
  function RouteUnderMouse(Mx, My :Double; RouteN, sens :integer): boolean; overload;
  function RouteUnderMouse(RouteN, sens :integer): boolean; overload;
  function RoutePointUnderMouse(RouteN, PointN, sens :integer): boolean;
  function CuttingPointUnderMouse(sens :integer): byte;

  //function NormalToRoute():
  function PosAndDistToRoute(x,y: Double; RouteN:Integer):TRoutePosAndDist;

  procedure DrawSubCursor(ObjColor, DopObjColor, ChoosedColor: cardinal; Ticks:real);

  procedure AddRulerPoint(X, Y : Double);
  procedure ResetRuler;
  procedure ReComputeRuler(Mode:Integer);
  procedure RulCurrent(X, Y :Double);
  procedure DrawRuler(CurXY:TMyPoint; RColor, TxColor, MnColor: cardinal;
                      Ticks:real; Smooth, DrawAll, HideRuler, DrawAngle, isAzmt, DrawCur:Boolean);

  var

  ChoosedMaps:array of Integer;
  ChoosedMapsInfo:array of String;

  SelectedKnots: array of Integer;
  SelectedMarkers: array of Integer;

  const MaxKnots = 2000000;
  const MaxPkt = 512;
        MinStep = 5;
  var

  CutPoints: array [1..2] of TMyPoint;
  CutMode: integer; /// 0 -off // 1 - wait for 2nd // 2 -ready to cut
  RouteCutPoints: array of TRouteCut;

//  EditRouteN : Integer;

  SelectedFramePoints: array of Boolean;
  SelectedFramePointsCount : integer = 0;

  SelectedRoutePoints: array of array of Boolean;
  SelectedRoutePointsCount : integer = 0;
  SelectedRoutesCount : integer = 0;
  SelectedRouteN : integer = -1;

  PointToAdd: TMyPoint;
  PointToAddRefPoints: array [1..2] of TMyPoint;
  RefPointsFound: boolean = false;
  PointToAddNum: integer; PointToAddRouteNum: integer;

  WaitForChoose : boolean;

  CheckL : boolean = True;

  HasDropPoint  :boolean = false;
  DropPoint     :TMyPoint;

  CanvCursorBL0   :TLatLong;
  CanvMoveOnly    :boolean;
  ShiftMode       :boolean = false;
  AlreadySelected :boolean = false;
  CanvMove        :integer = 0;
  MultiSelectMode :integer = 0;

  MouseSenseZone : Integer = 10;

  SubCursor : integer = 0;

  RulPoints : array [0..1000] of TMyPoint;
  RulLengths: array [0..1000] of Double;
  RulElLengths: array [0..1000] of Double;
  RulFullLength: Double;
  RulFullElLength: Double;
  RulCount  : integer = 0;

  KnotPoints :Array of TKnot;
  KnotCount  :Integer;

  PktCount   :Integer = 0;
  Pkt : Array [0..MaxPkt-1] of TPicket;

  RulDA, RulAzmt, RulCurrL : Double;

  CurrentLT_N :Integer = -1;
  CurrentLT_Count :Integer = 0;
  CurrentLT :Array[0..MaxPkt-1] of TMyPoint;
  MapDataDir: String;

  EdPickets :Array [0..MaxPkt-1] of TMyPoint;
  EdPicketsCount, EdTmpCount :Integer;
  EdPicketsFileName : string = 'Data\Loops.loc';

  LCounter:Integer;
  SpecialI         :Integer = 0;
implementation


procedure JumpToSelRoutesMap;
var xmax, ymax, xmin, ymin: real;
    i, j: integer;
    k: Boolean;
begin
 if (FrameCount = 0) and (RouteCount = 0) then
    exit;

  k := true;

{  xmax := Base[1].x;
  ymax := Base[1].y;
  xmin := Base[1].x;
  ymin := Base[1].y;}

  RecomputeBaseObjects(WaitForZone);
// RecomputeRoutes(WaitForZone);
//  RefreshSelectionArrays;
  if length(SelectedFramePoints) > 0 then
  if FrameCount > 0 then
  begin
     
     for j := 0 to FrameCount - 1 do
     if SelectedFramePoints[j] = true then
     Begin
        if K then
        begin
          xmax := FramePoints[j,1].x;
          ymax := FramePoints[j,1].y;
          xmin := FramePoints[j,1].x;
          ymin := FramePoints[j,1].y;

          k := false
        end;

        if FramePoints[j,1].x < xmin then
           xmin := FramePoints[j,1].x;
        if FramePoints[j,1].x > xmax then
           xmax := FramePoints[j,1].x;

        if FramePoints[j,1].y < ymin then
           ymin := FramePoints[j,1].y;
        if FramePoints[j,1].y > ymax then
           ymax := FramePoints[j,1].y;
     End;
  end;

  if length(SelectedRoutePoints) > 0 then
  if RouteCount > 0 then
  Begin


     for I := 0 to RouteCount-1 do
     Begin
       for j := 0 to length(Route[i].WPT)- 1 do
       if SelectedRoutePoints[I][J] = true then
       Begin
          if k then
          begin
           xmax := Route[i].WPT[j].x;
           ymax := Route[i].WPT[j].y;
           xmin := Route[i].WPT[j].x;
           ymin := Route[i].WPT[j].y;

           k := false;
          end;
          
          if Route[i].WPT[j].x < xmin then
             xmin := Route[i].WPT[j].x;
          if Route[i].WPT[j].x > xmax then
             xmax := Route[i].WPT[j].x;

           if Route[i].WPT[j].y < ymin then
             ymin := Route[i].WPT[j].y;
          if Route[i].WPT[j].y > ymax then
             ymax := Route[i].WPT[j].y;
       End;
     End;
  End;

  if k then
     exit;

  Center.x := (xmin+xmax)/2;
  Center.y := (ymin+ymax)/2;
  ShiftCenter.x := Center.x;
  ShiftCenter.y := Center.y;

  if (xmin=xmax)and(ymin = ymax) then
    exit;

  I := 0;
  repeat
     inc(i);
     if abs(xmin-xmax) > abs(ymin-ymax) then
       J := trunc( abs(xmin-xmax) /TMashtab[I])
         else
          J := trunc( abs(ymin-ymax) /TMashtab[I])
  until (I >= MaxMashtab-1) or (J<= DispSize.Y div 100);
  Mashtab := I;

  
end;

procedure DelKnot(DelI: integer);
var I:Integer;
begin
  if Length(KnotPoints) > 0 then
  begin
     for I := DelI to Length(KnotPoints) - 2 do
       KnotPoints[I] := KnotPoints[I+1];

     SetLength(KnotPoints, Length(KnotPoints)-1);
  end;
  Dec(KnotCount);
end;

procedure FixAngle(var Angle: Double);
begin
  if Angle < 0 then
     Angle := Angle + 2*pi
     else
     if Angle > 2*pi then
        Angle := Angle - 2*pi;
end;

procedure GetMapsUnderPoint(B,L: Double);

  function GetW(M:TMap):integer;
  begin
    Result := Trunc( abs(M.x[4] - M.x[1])+abs(M.y[4]-M.y[1]) / Scale);
  end;

  var
    I:Integer;
    P :TMyPoint;
begin
  MapChoosed := -1;
  SetLength(ChoosedMaps,0);

  P := BLToMap(B, L);
  for I := 0 to Length(MapList) - 1 do
  Begin
    if MapPointInBox(MapList[i].x, MapList[i].y,P.x,P.y)  then
        Begin
          SetLength(ChoosedMaps,Length(ChoosedMaps)+1);

          if Length(ChoosedMaps)= 1 then
             MapChoosed := I
              else
                 MapChoosed := -1;

          ChoosedMaps[Length(ChoosedMaps)-1] := i;

          SetLength(ChoosedMapsInfo,Length(ChoosedMaps));
          ChoosedMapsInfo[Length(ChoosedMaps)-1] := MapList[I].imgName +
                ' ('+ InttoStr(GetW(MapList[I])) +' px)';

        End;

  End;
end;

procedure MapInfoHUD;
begin

end;

procedure DeleteMap(N:Integer);
var I:Integer;
begin
  for I := N to Length(MapList) - 2 do
    MapList[i] := MapList[i+1];
    
  SetLength(MapList,Length(MapList)-1);  
end;

procedure SaveToAsdb(FileName: String; NewFileName:String);
var
  OldAsdb :TAsdb;
  I, J, K :Integer;
  Found   :Boolean;
  DelList :array of String;
begin

  if Copy(FileName, Length(NewFilename)-4,5)<>'.asdb' then
       NewFileName := NewFileName + '.asdb';

  if (fileexists(NewFileName)) then
  Begin
      CopyFile(PChar(NewFilename),PChar(Copy(NewFilename,1, Length(NewFilename)-5)
             +'-backup.asdb'), false);

     if FileName <> NewFileName then
        DeleteFile(PChar(NewFilename));
  End;

  if FileName = NewFileName then
     CopyFile(PChar(Filename),PChar(Copy(Filename,1, Length(Filename)-5)
             +'-backup.asdb'), false)
      else
         CopyFile(PChar(Filename),PChar(NewFilename), false);


  OldASDb:= TASDb.Create();
  OldASDb.FileName:= NewFileName;
  OldASDb.OpenMode:= opReadOnly;
  OldAsdb.Update;

  for J := OldAsdb.RecordCount - 1 downto 0 do
  Begin
      Found := false;
      if OldAsdb.RecordType[J] = recGraphics then
      Begin
          for K := 0 to Length(MapList) - 1 do
             if (OldAsdb.RecordKey[J] = MapList[K].imgName) or
                (OldAsdb.RecordKey[J] = MapList[K].imgName+'_s') or
                (OldAsdb.RecordKey[J] = MapLIst[K].imgName+'_t') then
                begin
                   Found := true;
                   break;
                end;
                  if not Found then
           Begin
             SetLength(DelList, Length(DelList)+1);
             DelList[Length(DelList)-1] := OldAsdb.RecordKey[J];
           End;
      End;
   End;

   for I := 0 to Length(DelList) - 1 do
     OldAsdb.RemoveRecord(DelList[I]);

//   OldAsdb.Update;
   OldAsdb.Destroy;

end;

procedure MouseMarkers(minX, minY, maxX, maxY: Double; Max: Integer; Mode:Byte);

 procedure CheckMinMax;
 var D:Double;
 Begin
   if minX > maxX then
   begin
     D := maxX;
     maxX := minX;
     minX := D;
   end;
   if minY > maxY then
   begin
     D := maxY;
     maxY := minY;
     minY := D;
   end;

   if (minX = maxX)and(minY = maxY) then
   begin
      D := MouseSenseZone{*Scale}/2;
      maxx := maxx + D;   maxy := maxy + D;
      minx := minx - D;   miny := miny - D;
   end;
 End;

 procedure DelSelMark(I:Integer);
 var j, k :integer;
 begin
    for j := Length(SelectedMarkers) - 1 downto 0 do
       if SelectedMarkers[j] = I then
       begin
         for k := j to Length(SelectedMarkers) - 2 do
            SelectedMarkers[k] := SelectedMarkers[k+1];
         SetLength(SelectedMarkers, Length(SelectedMarkers)-1);
         break;
       end;
 end;

var I, j : Integer;
    P : TMyPoint;
begin
  CheckMinMax;


  {if I >= KnotCount then
       break;

    j := Trunc(2*KnotPoints[i].BoxSize);
    P1.x := KnotPoints[i].Cx - j;  P1.y := KnotPoints[i].Cy - j;
    P2.x := KnotPoints[i].Cx + j;  P2.y := KnotPoints[i].Cy + j;

    if (P2.x > minX) and (P1.x < maxX) then
    if (P2.y > minY) and (P1.y < maxY) then
    begin
        /// ????????? ? ?????????
        P1.x := KnotPoints[i].Cx -(minX + maxX)/2;
        P1.y := KnotPoints[i].Cy -(minY + maxY)/2;                dscsdc

        P2.x := P1.x*Cos(-KnotPoints[i].BoxAngle-fi)-P1.y*Sin(-KnotPoints[i].BoxAngle-fi);
        P2.y := P1.x*Sin(-KnotPoints[i].BoxAngle-fi)+P1.y*Cos(-KnotPoints[i].BoxAngle-fi);

        P1 := P2;
        P1.x := P2.x - abs(maxX-minX)/2;   P1.y := P2.y - abs(maxY-minY)/2;
        P2.x := P2.x + abs(maxX-minX)/2;   P2.y := P2.y + abs(maxY-minY)/2;
    end}

  if Mode <= 1 then
    SetLength(SelectedMarkers,0);

  for I := 0 to Length(Markers) - 1 do
  begin
    P := MapToScreen( Markers[i].x, Markers[i].y);
   // P.x := Markers[i].x;  P.y := Markers[i].y;
    if (P.x > minX) and (P.x < maxX) then
    if (P.y > minY) and (P.y < maxY) then
    begin
      if Mode < 3 then
      begin
        SetLength(SelectedMarkers, Length(SelectedMarkers)+1);
        SelectedMarkers[Length(SelectedMarkers)-1] := I;
      end
      else
        DelSelMark(I);
    end;
    if Length(SelectedMarkers) >= Max then
       exit;
  end;
end;

procedure GetKnotMarkerList(var SL:TStringList; FromN:Integer);
var I, j: integer;
    s, s2: string;
    NeedAdd: boolean;
begin
    SL.Clear;
    // 1) Find corners
    for I := FromN to Length(Markers) - 1 do
    begin
      s := AnsiLowerCase(Markers[I].MarkerName);
      s := Copy(s, Length(s)-2, 3);

      if s = '_k1' then
      begin
       s2 := Copy(Markers[I].MarkerName, 1,
                 Length(Markers[I].MarkerName)-3);

       SL.Add(s2);
	    end;
    end;

    // 2) Find Pickets

    for I := FromN to Length(Markers) - 1 do
    begin
       if (Markers[I].MarkerKind <> 0) and (Markers[I].MarkerKind <> 3) then
         continue;

       s := Markers[I].MarkerName;
       for j := length(s) - 1 downto 2 do
         if s[j] = '_' then
         begin
           s2 := copy(s, 1, j-1);           {name}
           s  := copy(s, j+1, length(s)-j); {number}
           break;
         end;

     if length(s) < 2 then
        continue;
     if (AnsiLowerCase(s[1]) = 'k') or (AnsiLowerCase(s[1]) = 'l') then
        continue;
     if not( (AnsiLowerCase(s[1]) = 'p') or  (s[1] in ['0'..'9']) ) then
        continue;

     needAdd := true;
     for j := SL.count - 1 downto 0 do
        if (AnsiLowerCase(s2) = AnsiLowerCase(SL[j])) or
           (CheckL) and (
           (AnsiLowerCase(s2) = AnsiLowerCase('L'+SL[j])) or
           (AnsiLowerCase('L'+s2) = AnsiLowerCase(SL[j])))
            then
        begin
          needAdd := false;
          break;
        end;
     if needAdd then
     begin
       SL.Add(s2);
     end;
   end;
end;

function GetKnotStat(byMarkers:Boolean):TKnotStat;

  function CentersInArea :Integer;
  var XsCount:Integer;
      Xs :array[0..8] of Double;
  const XsMax = 8;

    procedure GetXs(Yi:Double);
    var I:Integer;
        Ximin, Ximax, Yimin, Yimax, c:Double;
    begin
      XsCount := 0;
      for I := 1 to FrameCount - 1 do
      Begin
          Ximin := FramePoints[I-1, 1].x;   Ximax := FramePoints[I, 1].x;
          Yimin := FramePoints[I-1, 1].y;   Yimax := FramePoints[I, 1].y;

          if Yimin > Yimax then
          begin
            c := Yimax;  Yimax := Yimin; Yimin := c;
            c := Ximax;  Ximax := Ximin; Ximin := c;
          end;

          if (Yi >= Yimin) and (Yi <= Yimax) then
          begin
            c := 0;
            if Yimax <> Yimin then
              c := (Yi - Yimin) / (Yimax - Yimin);

              Xs[XsCount] := Ximin + c*(Ximax - Ximin);
              inc(XsCount);

              if (Yi = Yimin) or (Yi = Yimax) then
              begin
                 // ?????? ???, ??? ?????????? ????????
                 Xs[XsCount] := Ximin + c*(Ximax - Ximin);
                 inc(XsCount);
              end;

            if XsCount >= XsMax -1  then
              exit;
          end;
      End;
    end;

    procedure SortXs;
    var I, j, jmin :Integer;   Xc, Xjmin:Double;
    begin
      for I := 0 to XsCount - 1 do
      begin
        Xjmin := Xs[I];  jmin := I;
        for j := I to XsCount - 1 do
           if Xs[j] < Xjmin then
           begin
              Xjmin := Xs[j];
              jmin := j;
            end;
        if jmin = I then
          continue;

        xc :=  Xs[I];
        Xs[I] := Xs[jmin];
        Xs[jmin] := xc;
      end;
    end;

  var I, j :Integer;
      minX, maxX :Double;
  begin
    result := 0;

    if FrameCount < 3 then
      exit;

    minX:= FramePoints[0,1].x; maxX:= FramePoints[0,1].x;
    for I := 0 to FrameCount-1 do
    begin
      if FramePoints[I,1].x < minX then
         minX := FramePoints[I,1].x;
      if FramePoints[I,1].x > maxX then
         maxX := FramePoints[I,1].x;
    end;

    if minx = maxx then
       exit;

    case byMarkers of
      true:
       for I := 0 to Length(Markers) - 1 do
          if Markers[I].MarkerKind = 1 then
          begin
             if (Markers[I].x < minx) or (Markers[I].x > maxx) then
               continue;

             GetXs(Markers[I].y);
             SortXs;
             for j := 1 to XsCount-1 do
               if (Markers[I].x >= Xs[j-1]) and
                  (Markers[I].x <= Xs[j]) then
               begin
                 if (j mod 2) <> 0 then
                   inc(result);
                 break;
               end;
          end;

       false: for I := 0 to KnotCount-1 do
         begin
             if (KnotPoints[I].Cx < minx) or (KnotPoints[I].Cx > maxx) then
               continue;

             GetXs(KnotPoints[I].Cy);
             SortXs;

             for j := 1 to XsCount-1 do
               if (KnotPoints[I].Cx >= Xs[j-1]) and
                  (KnotPoints[I].Cx <= Xs[j]) then
               begin
                 if (j mod 2) <> 0 then
                   inc(result);
                 break;
               end;
         end;
    end;


  end;

  procedure StatMarkerLoops;
  var I, j, k :Integer;
      s, s2: string;
      needAdd:boolean;
      sz: array of double;
      LoopNameList: array of String;
  begin
    SetLength(LoopNameList, 0);
    // 1) Find corners
    for I := 0 to Length(Markers) - 1 do
    begin
      s := AnsiLowerCase(Markers[I].MarkerName);
      s := Copy(s, Length(s)-2, 3);
      k := 0;
      if s = '_k1' then
      begin
       s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));

       SetLength(LoopNameList, Length(LoopNameList)+1);
       LoopNameList[Length(LoopNameList)-1] := s2;
       if  Markers[I].MarkerKind = 0 then
         Markers[I].MarkerKind := 2;

       for j := 1 to 3 do
         if i+j <=  Length(Markers) - 1 then
         begin
           s := AnsiLowerCase(Markers[I+j].MarkerName);
           if s = s2 + '_k' + IntToStr(j+1) then
             if  Markers[I+j].MarkerKind = 0 then
               Markers[I+j].MarkerKind := 2;
         end;


         for j := 1 to 3 do
         if i+j <=  Length(Markers) - 1 then
         begin
           s := AnsiLowerCase(Markers[I+j].MarkerName);
           if s = s2 + '_k' + IntToStr(j+1) then
           begin
             SetLength(sz, Length(sz)+1);
             sz[Length(sz)-1] := sqrt(sqr(Markers[I+j].x - Markers[I+j-1].x)+
                                      sqr(Markers[I+j].y - Markers[I+j-1].y));

             if (result.SizeMax = 0) or
                (result.SizeMax< sz[Length(sz)-1]) then
                 result.SizeMax := sz[Length(sz)-1];
             if (result.SizeMin = 0) or
                (result.SizeMin > sz[Length(sz)-1]) then
                result.SizeMin := sz[Length(sz)-1];

             if j = 3 then
             begin
               SetLength(sz, Length(sz)+1);
               sz[Length(sz)-1] := sqrt(sqr(Markers[I+j].x - Markers[I].x)+
                                        sqr(Markers[I+j].y - Markers[I].y));
               if (result.SizeMax = 0) or
                (result.SizeMax< sz[Length(sz)-1]) then
                 result.SizeMax := sz[Length(sz)-1];
               if (result.SizeMin = 0) or (result.SizeMin > sz[Length(sz)-1]) then
                 result.SizeMin := sz[Length(sz)-1];
             end;

           end;
         end;
      end;
   end;

   for I := 0 to Length(sz) - 1 do
     result.AvgSize := result.AvgSize + sz[I]/Length(sz);

   // 2) Find Pickets

   for I := 0 to Length(Markers) - 1 do
   begin
       if Markers[I].MarkerKind <> 0 then
         continue;

       s := AnsiLowerCase(Markers[I].MarkerName);
       for k := length(s) - 1 downto 2 do
         if s[k] = '_' then
         begin
           s2 := copy(s,1,k-1);     {name}
           s  := copy(s,k+1, length(s)-k); {number}
           break;
         end;

       if length(s) < 2 then
          continue;
       if (s[1] = 'k') or (s[1] = 'l') then
          continue;
       if not( (s[1] = 'p') or  (s[1] in ['0'..'9']) ) then
          continue;

       inc(result.Pickets);
       if  Markers[I].MarkerKind = 0 then
          Markers[I].MarkerKind := 3;

       needAdd := true;
       for j := Length(LoopNameList)- 1 downto 0 do
          if s2 = LoopNameList[j] then
          begin
            needAdd := false;
            break;
          end;
       if needAdd then
       begin
         SetLength(LoopNameList, Length(LoopNameList)+1);
         LoopNameList[Length(LoopNameList)-1] := s2;
       end;
   end;

   result.Count := 0;
   // 3) Find Centers
   for I := 0 to Length(Markers) - 1 do
   begin
     if Markers[I].MarkerKind <> 0 then
         continue;
     s := AnsiLowerCase(Markers[I].MarkerName);
     for j := 0 to  Length(LoopNameList)- 1 do
       if s = LoopNameList[j]  then
         begin
           inc(result.Count);
           if  Markers[I].MarkerKind = 0 then
              Markers[I].MarkerKind := 1;
         end;
   end;

   if result.Count  = 0 then
     result.Count  := Length(LoopNameList);

   setlength(sz, Length(LoopNameList));

   for I := 0 to Length(LoopNameList) - 1 do
   begin
     sz[I] := 0;
     for j := 0 to Length(Markers) - 1 do
       if Markers[j].MarkerKind = 3 then
       begin
         if Pos(LoopNameList[I]+'_', AnsiLowerCase(Markers[j].MarkerName)) = 1 then
         begin
            sz[I] := sz[I] + 1;
         end;
       end;
         if (result.PMax = 0) or
           (result.PMax < sz[I]) then
           result.PMax := trunc(sz[I]);
         if (result.PMin > sz[I]) or
            (result.Pmin = 0) then
           result.PMin := trunc(sz[I]);
   end;

   for I := 0 to Length(sz) - 1 do
   Begin
     result.AvgPicketsByLoop := result.AvgPicketsByLoop + sz[I]/Length(sz);
     result.Pickets := result.Pickets + trunc(sz[I]);
   End;
end;



var I:Integer;
begin
  result.Count   := 0;   result.Pickets := 0;             result.Pmin    := 0;
  result.InArea  := 0;   result.AvgPicketsByLoop := 0;    result.Pmax    := 0;
  result.AvgSize := 0;   result.SizeMin := 0;             result.SizeMax := 0;

  case byMarkers of
    true: StatMarkerLoops;

    false:  begin
       result.Count := KnotCount;

       for I := 0 to KnotCount - 1 do
       begin
         result.AvgSize := result.AvgSize + KnotPoints[I].BoxSize/(KnotCount);
         if (result.SizeMax = 0) or
           (result.SizeMax < KnotPoints[I].BoxSize) then
           result.SizeMax := KnotPoints[I].BoxSize;
         if (result.SizeMin = 0) or (result.SizeMin > KnotPoints[I].BoxSize) then
           result.SizeMin := KnotPoints[I].BoxSize;

         GetKnotPickets(KnotPoints[I], true);
         result.AvgPicketsByLoop := result.AvgPicketsByLoop +
                                    PktCount/(KnotCount);

         if (result.PMax = 0) or
           (result.PMax < PktCount) then
           result.PMax := PktCount;
         if (result.PMin = 0) or
            (result.PMin > PktCount) then
           result.PMin := PktCount;

         result.Pickets := result.Pickets + PktCount;
       end;

    end;
  end;

  result.InArea := CentersInArea;

end;

procedure MouseKnots(minX, minY, maxX, maxY: Double; Max: Integer; Mode:Byte);

 procedure CheckMinMax;
 var D:Double;
 Begin
   if minX > maxX then
   begin
     D := maxX;
     maxX := minX;
     minX := D;
   end;
   if minY > maxY then
   begin
     D := maxY;
     maxY := minY;
     minY := D;
   end;

   if (minX = maxX)and(minY = maxY) then
   begin
      D := MouseSenseZone{*Scale}/2;
      maxx := maxx + D;   maxy := maxy + D;
      minx := minx - D;   miny := miny - D;
   end;
 End;

 procedure DelSelKnot(I:Integer);
 var j, k :integer;
 begin
    for j := 0 to Length(SelectedKnots) - 1 do
       if SelectedKnots[j] = I then
       begin
         for k := j to Length(SelectedKnots) - 2 do
            SelectedKnots[k] := SelectedKnots[k+1];
         SetLength(SelectedKnots, Length(SelectedKnots)-1);
         break;
       end;
 end;

var I, j : Integer;
    P1, P2, P3 : TMyPoint;
    Catch: boolean;
begin
  CheckMinMax;

  if Mode <= 1 then
    SetLength(SelectedKnots,0);

  for I := 0 to Length(KnotPoints) - 1 do
  begin
    if I >= KnotCount then
       break;

    j := Trunc(KnotPoints[i].BoxSize/Scale)+1;  {!!!!! 06-02-2022}

    P3 := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
    P1 := PointXY(P3.x - j, P3.Y - j);
    P2 := PointXY(P3.x + j, P3.Y + j);
    Catch := false;
    if (P2.x > minX) and (P1.x < maxX) then
    if (P2.y > minY) and (P1.y < maxY) then
    begin
        /// ????????? ? ?????????
      if Mode = 0 then
      BEGIN
         case KnotPoints[i].Shp of
           1: begin
              Catch := (sqrt(sqr(P3.x - (minX + maxX)/2)+sqr(P3.y - (minY + maxY)/2)) < j);
           end;

           else begin
            P1.x := P3.x -(minX + maxX)/2;
            P1.y := P3.y -(minY + maxY)/2;

            P2.x := P1.x*Cos(-KnotPoints[i].BoxAngle-fi)-P1.y*Sin(-KnotPoints[i].BoxAngle-fi);
            P2.y := P1.x*Sin(-KnotPoints[i].BoxAngle-fi)+P1.y*Cos(-KnotPoints[i].BoxAngle-fi);

            P1 := P2;
            P1.x := P2.x - abs(maxX-minX)/2;   P1.y := P2.y - abs(maxY-minY)/2;
            P2.x := P2.x + abs(maxX-minX)/2;   P2.y := P2.y + abs(maxY-minY)/2;

            Catch := (P2.x > - j/2) and (P1.x < j/2) and (P2.y > - j/2) and (P1.y < j/2);
           end;

         end;
      END
        ELSE
          Catch := true
    end
    else
      continue;

    if Catch then
    begin
      if Mode < 3 then
      begin
        SetLength(SelectedKnots, Length(SelectedKnots)+1);
        SelectedKnots[Length(SelectedKnots)-1] := I;
      end
      else
       DelSelKnot(I);
    end;
    if Length(SelectedKnots) >= Max then
       exit;
  end;
end;

function  isFrameClockWise :boolean;
var ang1, ang2, cx, cy, x1, y1, x2, y2: double;
    i, c1, c2 : integer;
begin
  result := false;

  cx := 0;
  cy := 0;

  for I := 0 to FrameCount - 1 do
  Begin
    cx := cx + FramePoints[I,1].x;
    cy := cy + FramePoints[I,1].y;
  End;
    cx := cx / FrameCount;
    cy := cy / FrameCount;

  c1 := 0;
  c2 := 0;
  for I := 0 to FrameCount - 2 do
  Begin


     ang1 := arctan2((FramePoints[i,1].x-cX),(FramePoints[i,1].y-cy));
     ang2 := arctan2((FramePoints[i+1,1].x-cX),(FramePoints[i+1,1].y-cy));

    if ang1<0 then
       ang1 := ang1 + 2*pi;

    if ang2<0 then
      ang2 := ang2 + 2*pi;

    if ang1 > ang2  then
       inc(c1)
        else
         inc(c2)
  End;

 Result := c1 > c2;
end;

procedure SaveRTSFile(FileName:String; AskifExist :boolean);
var i, j :integer;
    S :TSTringList;
begin
  if (RouteCount = 0) and (FrameCount = 0) then
    Exit;

  if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.rts' then
     FileName := FileName + '.rts';

  if AskifExist then
    if Fileexists(FileName) then
      if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

  S := TStringList.Create;

  AddRTSInfo(S);
  S.SaveToFile(FileName);
  S.Free;
end;

procedure AddRTSInfo(var S:TStringList);
var i, j :integer;
    fxd: char;
    endp:string;
begin
  if (RouteCount = 0) and (FrameCount = 0) then
    Exit;

  S.Add('//Routes');
  for I := 0 to RouteCount - 1 do
  Begin
    fxd := '0';
    if Route[I].Fixed then
      fxd := '1';

    case Route[I].Status of
       2, 3, 6, 7: endp :='100';
       else endp :='0';
    end;


    if Length(Route[I].GWPT)=0 then
    Begin
       S.Add(Route[I].Name + #$9 + FloatToSTr(Route[I].Gx1)
                           + #$9 + FloatToSTr(Route[I].Gy1)
                           + #$9 + IntToSTr(Route[I].Status)
                           + #$9 + '0' + #$9 + endp + #$9 + fxd
                           + #$9 + FloatToStr(GetRoutePointA (I,0)));

       S.Add(Route[I].Name + #$9 + FloatToSTr(Route[I].Gx2)
                           + #$9 + FloatToSTr(Route[I].Gy2)
                           + #$9 + IntToSTr(Route[I].Status)
                           + #$9 + '0' + #$9 + endp + #$9 + fxd
                           + #$9 + FloatToStr(GetRoutePointA (I,1)));
    End
     else
       for J := 0 to Length(Route[I].GWPT) - 1 do
          S.Add(Route[I].Name + #$9 + FloatToSTr(Route[I].GWPT[J].x)
                              + #$9 + FloatToSTr(Route[I].GWPT[J].y)
                              + #$9 + IntToSTr(Route[I].Status)
                              + #$9 + '0' + #$9 + endp + #$9 + fxd
                              + #$9 + FloatToStr(GetRoutePointA (I,J)));

  End;

  if FrameCount>0 then
  S.Add('//Frame');
  for I := 0 to FrameCount - 1 do
     S.Add(IntToStr(I) + #$9 + FloatToStr(FramePoints[I,2].x)
                       + #$9 + FloatToStr(FramePoints[I,2].y));

end;

procedure SaveRoutesToFile(FileName:String; Datum, CS, RT, Fmt:Integer;  Sep:String);
var    csX, csY, csZ :String;
       newZone: integer;
       waitZ: boolean;
  procedure BLToCS(B,L :double);
  var H, cX, cY, cZ: Double;
      I : integer;
  begin
       csZ :='';
       H := 0;

       if Datum > -1 then
       begin
          Geo1ForceToGeo2(B, L, 0, WGS, Datum, B, L, H);

          case CS of
              0: if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) = '.lst' then
                begin
                   csX := Format('%.6f',[B]);
                   csY := Format('%.6f',[L]);

                   for I := 1 to length(csx) do
                      if csx[i]=',' then
                         csx[i]:='.';

                   for I := 1 to length(csy) do
                      if csy[i]=',' then
                         csy[i]:='.'
                end
                else
                  begin
                  csX := DegToDMS(B,true, Fmt, Fmt mod 2 = 0);
                  csY := DegToDMS(L,false,Fmt, Fmt mod 2 = 0);
                  end;

              1:begin
                 GeoToECEF(Datum, B, L, 0, cx, cy, cz);
                 csX := Format('%.3f',[cX]);
                 csY := Format('%.3f',[cY]);
                 csZ := Format('%.3f',[cZ]);
              end;
              2..4:begin
                  if CS = 2 then
                     GeoToGaussKruger(Datum, B, L, cY, cX, newZone, waitZ);
                  if CS = 3 then
                     GeoToUTM(Datum, B, L, false, cX, cY, newZone, waitZ);
                  if CS = 4 then
                     GeoToUTM(Datum, B, L, true, cX, cY, newZone, waitZ);

                  waitZ := False;

                  csY := Format('%.3f',[cX]);
                  csX := Format('%.3f',[cY]);
              end;

          end;
       end
         else
         begin
              Geo1ForceToGeo2(B, L, 0, WGS, CoordinateSystemList[CS].DatumN, B, L, H);

              DatumToCoordinateSystem(CS, B, L, H, cX, cY, cZ);

              case CoordinateSystemList[CS].ProjectionType of
                0:begin
                  csX := DegToDMS(cX,true, Fmt, Fmt mod 2 = 0);
                  csY := DegToDMS(cY,false,Fmt, Fmt mod 2 = 0);
                end;
                1:begin
                 csX := Format('%.3f',[cX]);
                 csY := Format('%.3f',[cY]);
                 csZ := Format('%.3f',[cZ]);
                end;
                2..4:begin
                  csY := Format('%.3f',[cX]);
                  csX := Format('%.3f',[cY]);
                end;
              end;
        end;
  end;

var i, j :integer;
    S :TSTringList;
begin

  if (RouteCount = 0) and (FrameCount = 0) then
    Exit;

  newZone:= 0;
  WaitZ := True;
  S := TStringList.Create;

  for I := 0 to RouteCount - 1 do
    case RT of
      0: begin
         BLToCS(Route[I].Gx1, Route[I].Gy1);
         S.Add(Route[I].Name + Sep + csX + Sep + csY );
         if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;

         BLToCS(Route[I].Gx2, Route[I].Gy2);
         S[S.Count-1] := S[S.Count-1]+ Sep + csX + Sep + csY ;
         if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;
      end;
      1: begin
         BLToCS(Route[I].Gx1, Route[I].Gy1);
         S.Add(Route[I].Name + Sep + csX + Sep + csY);
         if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;

         BLToCS(Route[I].Gx2, Route[I].Gy2);
         S.Add(Route[I].Name + Sep + csX + Sep + csY);
         if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;
      end;
      2: begin
         BLToCS(Route[I].Gx1, Route[I].Gy1);
         S.Add(Route[I].Name+'a' + Sep + csX + Sep + csY);
         if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;

         BLToCS(Route[I].Gx2, Route[I].Gy2);
         S.Add(Route[I].Name+'b' + Sep + csX + Sep + csY);
         if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;
      end;
      3: begin
         if (Length(Route[I].GWPT) = 0) or (Length(Route[I].GWPT)=2)  then
         Begin
           BLToCS(Route[I].Gx1, Route[I].Gy1);
           S.Add(Route[I].Name + Sep + csX + Sep + csY);
           if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;

           BLToCS(Route[I].Gx2, Route[I].Gy2);
           S.Add(Route[I].Name + Sep + csX + Sep + csY);
           if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;
         End
           else
           for J := 0 to Length(Route[I].GWPT) - 1 do
           Begin
              BLToCS(Route[I].GWPT[J].x, Route[I].GWPT[J].y);
              S.Add(Route[I].Name + Sep + csX + Sep + csY);
              if csZ<>'' then
                S[S.Count-1] := S[S.Count-1] + Sep + csZ;
           End;
      end;

    end;
   if RouteCount > 0 then
   S.SaveToFile(FileName);

   S.Clear;
   if not (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) = '.lst') and
      not (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) = '.bln') then
   if FrameCount>0 then
   Begin
     Insert('_F', FileName, Length(FileName)-3);
     for I := 0 to FrameCount - 1 do
     Begin
       BLToCS(FramePoints[I,2].x, FramePoints[I,2].y);
       S.Add(IntToStr(I) + Sep + csX + Sep + csY);
       if csZ<>'' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;
     End;
     S.SaveToFile(FileName);
   End;


  S.Free;
end;

procedure SaveBLNFile(FileName:String; isUTM:boolean; AskifExist:boolean);
var    csX, csY, csZ :String;
       waitZ, N :boolean;
       newZone: integer;

  procedure BLToCS(B,L :double);
  var H, cX, cY, cZ: Double;
      I : integer;
  begin
       csZ :='';
       H := 0;

       if isUTM then
       begin
         GeoToUTM(WGS, B, L, N, cY, cX, newZone, waitZ);
           waitZ := false;
       end
         else
         begin
           Geo1ForceToGeo2(B, L, 0, WGS, SK, B, L, H);
           GeoToGaussKruger(SK, B, L, cY, cX, newZone, waitZ);
           waitZ := false;
         end;

       csX := Format('%.2f',[cX]);
       csY := Format('%.2f',[cY]);

       for I := 1 to length(csx) do
         if csx[i]=',' then
            csx[i]:='.';

       for I := 1 to length(csy) do
         if csy[i]=',' then
             csy[i]:='.'

  end;

var i, j :integer;
    S :TSTringList;
begin
   if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.bln' then
     FileName := FileName + '.bln';

    if AskifExist then
    if Fileexists(FileName) then
      if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;
                
  if (RouteCount = 0) then
    Exit;

  WaitZ := True;
  newZone := 0;
  S := TStringList.Create;

  N := Route[0].GWPT[0].x < 0;

  for I := 0 to RouteCount - 1 do
  begin
    S.Add(IntToStr(length(Route[I].GWPT))+',1, "'+ Route[I].Name +'"');
    for J := 0 to length(Route[I].GWPT) - 1 do
    begin
      BLToCS(Route[I].GWPT[J].x,Route[I].GWPT[J].y);
      S.Add(csx +','+csy);
    end;

  end;

   if RouteCount > 0 then
   S.SaveToFile(FileName);

  S.Free;
end;

procedure SaveBLNKnotFile(FileName:String; CS, StartI: Integer;
                          fKind, fOrder:Byte; AskifExist:boolean);
var    csX, csY, csZ :String;

  procedure BLToCS(B,L :double);
  var H, cX, cY, cZ: Double;
      I : integer;
  begin
       csZ :='';
       H := 0;

       Geo1ForceToGeo2(B, L, H, WGS, CoordinateSystemList[CS].DatumN, B, L, H);

       DatumToCoordinateSystem(CS, B, L, H, cX, cY, cZ);

       case CoordinateSystemList[CS].ProjectionType of
          0:begin
             csX := Format('%.12f',[cX]); //DegToDMS(cX,true, 5, false);
             csY := Format('%.12f',[cY]); //DegToDMS(cY,false,5, false);
             //csH  := Format('%.3f',[cZ]);
          end;
          1:begin
            csX := Format('%.2f',[cX]);
            csY := Format('%.2f',[cY]);
            csZ := Format('%.2f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.2f',[cX]);
            csX := Format('%.2f',[cY]);
            //csH  := Format('%.2f',[cZ]);
          end;
       end;


       for I := 1 to length(csx) do
         if csx[i]=',' then
            csx[i]:='.';

       for I := 1 to length(csy) do
         if csy[i]=',' then
             csy[i]:='.';

       if csz<>'' then
       for I := 1 to length(csz) do
         if csz[i]=',' then
             csz[i]:='.'
  end;

  function CoordString(B, L:Double):string;
  begin
     result := '';
     BLToCS(B, L);
     case CoordinateSystemList[CS].ProjectionType of
        0: case fOrder of
             0: result := csx +','+csy;
             1: result := csy +','+csx;
           end;
        1: result := csx +','+csy+','+csz;
        2..4: case fOrder of
             0: result := csx +','+csy;
             1: result := csy +','+csx;
           end;
     end;
  end;

var i, j, collected :integer;
    S :TSTringList;
    s1, s2: string;
    found: boolean;
begin
   if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.bln' then
     FileName := FileName + '.bln';

    if AskifExist then
    if Fileexists(FileName) then
      if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;
                
  if (RouteCount = 0)and(Length(Markers)=0) then
    Exit;

  S := TStringList.Create;

  case fKind of
     0: for I := StartI to Length(Markers) - 1 do
        begin
          s1 := AnsiLowerCase(Markers[I].MarkerName);
          s1 := Copy(s1, Length(s1)-2, 3);

          if s1 = '_k1' then
          begin
            s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));

            found := true;
            {for j := 1 to 3 do
            if i+j <=  Length(Markers) - 1 then
            begin
              s1 := AnsiLowerCase(Markers[I+j].MarkerName);
              if not (s1 = s2 + '_k' + IntToStr(j+1)) then
              begin
                 found := false;
                 break;
              end;
            end
            else found := false;   }
            collected := 0;
            repeat
              s1 := AnsiLowerCase(Markers[I+collected].MarkerName);
              if s1 = s2 + '_k' + IntToStr(collected+1) then
                 inc(collected)
              else
                break;
            until I+collected > Length(Markers)-1;
            found := collected >= 3;

            if found then
            begin
              s2 := Copy(Markers[I].MarkerName, 1,
                         Length(Markers[I].MarkerName)-3);

              S.Add(inttostr(collected+1)+',1, "'+s2+'"');
              
              for j := 0 to Collected - 1 do
                S.Add(CoordString(Markers[I+j].Gx, Markers[I+j].Gy));

              S.Add(CoordString(Markers[I].Gx, Markers[I].Gy));
            end;
          end;
        end;
     1: for I := 0 to RouteCount - 1 do
        begin
          S.Add(IntToStr(length(Route[I].GWPT))+',1, "'+ Route[I].Name +'"');
          for J := 0 to length(Route[I].GWPT) - 1 do
            S.Add(CoordString(Route[I].GWPT[J].x,Route[I].GWPT[J].y));
        end;
     2: if frameCount > 0 then
        begin
          S.Add(IntToStr(FrameCount)+',1');
          for I := 0 to FrameCount - 1 do
            S.Add(CoordString(FramePoints[I,2].x, FramePoints[I,2].y));
        end;

  end;

  if S.Count > 0 then
     S.SaveToFile(FileName);

  S.Free;
end;


procedure SaveTXTFile(FileName:String; Datum, CS, RT, Fmt:Integer;  Sep:String; AskifExist:boolean);
begin
     if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.txt' then
     FileName := FileName + '.txt';

     if AskifExist then
       if Fileexists(FileName) then
          if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
              exit;
              
     SaveRoutesToFile(FileName, Datum, CS, RT, Fmt, Sep);
end;

procedure SaveKmlFile(FileName, HgtMode:String; AskifExist:boolean);
var S: TStringList;
    I, j:Integer;
begin
    if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.kml' then
     FileName := FileName + '.kml';

    if AskifExist then
       if Fileexists(FileName) then
         if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
             exit;

    S:= TStringList.Create;
    S.LoadFromFile('Data\Kml_Header.loc');
    //showmessage(Hgtmode);

    // 1. Markers
    for I := 0 to Length(Markers) - 1 do
    if Markers[I].MarkerKind <> 5 then
    begin
      S.Add('   <Placemark>');
      S.Add('    <name>'+Markers[I].MarkerName+'</name>');
      S.Add('    <styleUrl>#BalloonStyle</styleUrl>');
      S.Add('    <description><![CDATA[Index: '+Markers[I].MarkerName);
      S.Add('Waypoint');
      S.Add('Alt AMSL: ' + Dot( Format('%.2f',[Markers[I].HGeo])) + ' m');
      S.Add('Alt Rel: '  + Dot( Format('%.2f',[Markers[I].Alt]))  + ' m');
      S.Add('Lat: ' + Dot( Format('%.7f',[Markers[I].Gx])));
      S.Add('Lon: ' + Dot( Format('%.7f',[Markers[I].Gy])));
      S.Add(']]></description>');
      S.Add('    <Point>');
      S.Add('     <altitudeMode>'+HgtMode+'</altitudeMode>');
      S.Add('     <coordinates>'+ Dot( Format('%.7f',[Markers[I].Gy])) +','
            + Dot( Format('%.7f',[Markers[I].Gx])));

      if (HgtMode = 'clampToGround') or (HgtMode = 'relativeToGround') then
         S[S.Count-1] := S[S.Count-1] + ','
            + Dot( Format('%.2f',[Markers[I].Alt])) + '</coordinates>'
      else
      if HgtMode = 'absolute' then
         S[S.Count-1] := S[S.Count-1] +','
            + Dot( Format('%.2f',[Markers[I].HGeo])) + '</coordinates>' //// H
      else
         S[S.Count-1] := S[S.Count-1] +','
             + Dot( Format('%.2f',[Markers[I].HGeo])) + '</coordinates>';
      S.Add('     <extrude>1</extrude>');
      S.Add('    </Point>');
      S.Add('   </Placemark>');
    end;
    S.Add('  </Folder>');


    // 2.Routes
    for I := 0 to RouteCount - 1 do
    if length(Route[I].GWPT) > 0 then
    begin
      S.Add('  <Placemark>');
      S.Add('   <styleUrl>#MissionLineStyle</styleUrl>');
      S.Add('   <name>'+Route[I].Name+'</name>');
      S.Add('   <visibility>1</visibility>');
      for j := 0 to Length(Markers) - 1 do
      if Markers[j].MarkerName = Route[I].Name then
      begin
        S.Add('   <LookAt>');
        S.Add('    <latitude>' +Dot( Format('%.7f',[Markers[j].Gx]))+'</latitude>');
        S.Add('    <longitude>'+Dot( Format('%.7f',[Markers[j].Gy]))+'</longitude>');
        if (HgtMode = 'clampToGround') or  (HgtMode = 'relativeToGround') then
          S.Add('    <altitude>' +Dot( Format('%.2f',[Markers[j].Add1]))+'</altitude>')
        else
        if HgtMode = 'absolute' then
          S.Add('    <altitude>' +Dot( Format('%.2f',[Markers[j].HGeo]))+'</altitude>') /// H
        else
          S.Add('    <altitude>' +Dot( Format('%.2f',[Markers[j].HGeo]))+'</altitude>');

        S.Add('    <heading>'+inttostr(round(Markers[j].Alt))+'</heading>');
        S.Add('    <tilt>45</tilt>');
        S.Add('    <range>2500</range>');
        S.Add('   </LookAt>');
        break;
      end;


      S.Add('   <LineString>');
      S.Add('    <extruder>1</extruder>');
      S.Add('    <tessellate>1</tessellate>');
      S.Add('    <altitudeMode>'+HgtMode+'</altitudeMode>');
      S.Add('    <coordinates>'+ Dot( Format('%.7f',[Route[I].GWPT[0].y])) +','
            + Dot( Format('%.7f',[Route[I].GWPT[0].x])));
      if Length(Route[I].ALT) > 0 then
        S[S.Count-1] := S[S.Count-1] +',' + Dot( Format('%.2f',[Route[I].Alt[0]]))
      else
        S[S.Count-1] := S[S.Count-1] +',0.00';

      for j := 1 to Length(Route[I].GWPT) - 1 do
      begin
           S.Add(Dot( Format('%.7f',[Route[I].GWPT[j].y])) + ','
               + Dot( Format('%.7f',[Route[I].GWPT[j].x])));
           if Length(Route[I].ALT) >= j then
              S[S.Count-1] := S[S.Count-1] +',' + Dot( Format('%.2f',[Route[I].Alt[j]]))
           else
              S[S.Count-1] := S[S.Count-1] +',0.00';
      end;
      S.Add('</coordinates>');
      S.Add('   </LineString>');
      S.Add('  </Placemark>');
    end;

    // 3.Area
    if (Frame) and (FrameCount > 2) then
    begin
      S.Add('  <Placemark>');
      S.Add('   <name>Survey Area</name>');
      S.Add('   <visibility>1</visibility>');
      S.Add('   <Polygon>');
      S.Add('    <altitudeMode>clampToGround</altitudeMode>');
      S.Add('    <outerBoundaryIs>');
      S.Add('     <LinearRing>');
      S.Add('      <coordinates>'+ Dot( Format('%.7f',[FramePoints[0,2].y])) +','
            + Dot( Format('%.7f',[FramePoints[0,2].x]))+',0.00');
      for j := 1 to FrameCount - 1 do
      begin
           S.Add(Dot( Format('%.7f',[FramePoints[j,2].y])) +','
               + Dot( Format('%.7f',[FramePoints[j,2].x])) +',0.00');
      end;
      S.Add('</coordinates>');
      S.Add('     </LinearRing>');
      S.Add('    </outerBoundaryIs>');
      S.Add('   </Polygon>');
      S.Add('   <styleUrl>#SurveyPolygonStyle</styleUrl>');
      S.Add('  </Placemark>');
    end;

    S.Add(' </Document>');
    S.Add('</kml>');

    for j := 0 to S.Count - 1 do
      S[j] := ANSIToUTF8(S[j]);
      
    S.SaveToFile(FileName);
    S.Destroy;
end;

procedure SaveLstFile(FileName:String; AskifExist:boolean);
begin
     if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.lst' then
     FileName := FileName + '.lst';

     if AskifExist then
       if Fileexists(FileName) then
         if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
             exit;

     SaveRoutesToFile(FileName, WGS, 0, 0, 5, #$9);
end;

procedure SaveMission(FileName:String; AskifExist:boolean);
 
var I, j:Integer;
    S:TStringList;
    bx, by :Double;
begin
   if RouteCount = 0 then
     exit;
   if AnsiLowerCase(Copy(FileName, Length(FileName)-7,8)) <> '.mission' then
      FileName := FileName + '.mission';

   if AskifExist then
     if Fileexists(FileName) then
       if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
         exit;

    S := TSTringList.Create;
    S.Add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    S.Add('<mission>');
    S.Add(#$9+'<version value="2.3-pre8"/>');
    if (Base[2].x <> 0) and (Base[2].y <> 0) then
    begin
      bx := Base[2].x;
      by := Base[2].y;
    end
      else
      begin
         bx := Route[RouteCount-1].GWPT[0].x;
         by := Route[RouteCount-1].GWPT[0].y;
      end;
    S.Add(#$9+'<mwp cx="'+ Dot(Format('%.7f',[by])) +'" cy="'+  Dot(Format('%.7f',[bx]))
          +'" home-x="0" home-y="0" zoom="15"/>');

    if Length(Route[RouteCount-1].ALT) < Length(Route[RouteCount-1].GWPT) then
    begin
       j := Length(Route[RouteCount-1].ALT);
       SetLength( Route[RouteCount-1].ALT, Length(Route[RouteCount-1].GWPT) );

       for I := j to Length(Route[RouteCount-1].GWPT) - 1 do
          Route[RouteCount-1].ALT[I] := 0;
    end;

    for I := 0 to Length(Route[RouteCount-1].GWPT) - 1 do
    begin
       S.Add(#$9+'<missionitem no="' + inttostr(I+1) +
             '" action="WAYPOINT" lat="' + Dot(Format('%.7f',[Route[RouteCount-1].GWPT[I].x])) +
             '" lon="' + Dot(Format('%.7f',[Route[RouteCount-1].GWPT[I].y])) +
             '" alt="' + IntToStr(round(Route[RouteCount-1].ALT[I])) +
             '" parameter1="0" parameter2="0" parameter3="0" flag="'
       );

       if I < Length(Route[RouteCount-1].GWPT) - 1 then
         S[S.Count-1] :=  S[S.Count-1] + '0"/>'
       else
         S[S.Count-1] :=  S[S.Count-1] + '1"/>';
    end;

    S.Add('</mission>') ;
    for j := 0 to S.Count - 1 do
       S[j] := ANSIToUTF8(S[j]);

    S.SaveToFile(FileName);
    S.Free;
    // SaveRoutesToFile(FileName, WGS, 0, 0, 5, #$9);
end;

procedure prepareGPX(var S:TStringList);
var I,j,k:LongInt;    S2:TStringList;
begin
  if S.Count > 15 then
     exit;
  S2 :=TStringList.Create;
  S2.Text := S.Text;
  S.Clear;

  for J := 0 To S2.Count-1 do
  begin
    S.Add('') ;
    for I := 1 To length(S2[J]) do
    begin

      S[S.Count-1] := S[S.Count-1] + S2[J][I];

      if (S2.Text[I] = '>') and (I < Length(S2[J])) then
      begin
        for k := I Downto I - 7 do
        begin
          if k > 1 then
          begin
             if S2.Text[k]='/' then
                S.Add('');
          end
           else
             break;
        end;

      end;
    end;
   // S[S.Count-1] := S[S.Count-1] + S2.Text[length(S2[J])-1];
  end;

  S2.Free;
end;

/// ---


procedure LoadKMLFile(FileName:String; doRoutes, doPoints, doArea,
                            doTrack, doAdd:Boolean);
  var S: TstringList;

  //// ????? ?????? ?????? ???????? ?????
  function FindTaggedData(var StartI, StartJ, EndI, EndJ: Integer;
                          /// ?????? ? ?????? ? ? ?? ?????? ?????
                          StartTag, EndTag: String): Boolean;
                          /// ??????????? ? ??????????? ???
  var FoundStart   :boolean;
      I, j, CI, CJ :integer;
  begin
     result := false;
     FoundStart := false;

     CI := StartI;
     CJ := StartJ;

     for I := CI to S.Count - 1 do
     begin

       If Not FoundStart Then
       Begin
         j := Pos(StartTag, Copy(S[I], CJ+1, Length(S[I]) - CJ));
        // showmessage(Copy(S[I], CJ+1, Length(S[I]) - CJ))   ;
         if j > 0 then
         begin
           FoundStart := True;
           StartI := I;
           StartJ := j + length(StartTag)+CJ;
           CJ := StartJ;
         end;
       End;

       If FoundStart Then
       Begin
         j := Pos(EndTag, Copy(S[I], CJ+1, Length(S[I]) - CJ));
         if j > 0 then
         begin
           EndI := I;
           EndJ := j+CJ;
           CJ := EndJ;
           result := true;
           exit;
         end;
       End;

       CJ := 0;
     end;

  end;

  function GetKind(var SI, SJ, EI, EJ: Integer):integer;   // ?????????? ???
  var I, J :Integer;
  const ST: array [1..3] of String = ('Point', 'LineString', 'Polygon');
  begin
      result := -1;
      for I := 1 to Length(ST) do
        if FindTaggedData(SI, SJ, EI, EJ, '<'+ST[I]+'>', '</'+ST[I]+'>') then
        begin
          result := I;
          exit;
        end;
  end;

  procedure GetObjData(SI, SJ, EI, EJ, Kind:integer);

    var I, j, _sI, _sJ, _eI, _eJ, SI2, EI2 : integer;
        Str, HgtMode :string; B, L, H, Hag :Double;  gotLook:boolean;

    procedure AssignSE;
    begin
       _SI := SI;  _SJ := SJ;   _EI := EI;    _EJ := EJ;
    end;

    procedure AssignSE2;
    begin
       _SI := SI2;  _SJ := 0;   _EI := EI2+1;    _EJ := 0;
    end;

  begin
      case Kind of
         1: if doPoints then
         begin
            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<coordinates>', '</coordinates>') then
            try
              Str := copy(S[_sI], _sJ, _eJ - _sJ);
              L := StrToFloat2(GetCols(Str, 0, 1, ',', false));
              B := StrToFloat2(GetCols(Str, 1, 1, ',', false));
              H := StrToFloat2(GetCols(Str, 2, 1, ',', false));
            except
              exit;
            end
            else exit;

            Hag := 0;
            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<description>', '</description>') then
            begin

              for I := _sI to _eI do
              begin
                if I = _sI then
                  Str := copy(S[I], _sJ, length(S[I]) - _sJ)
                else if I = _eI then
                  Str := copy(S[I], 1, _eJ)
                else
                  Str := S[I];

                j := Pos('Alt Rel:', Str);
                if j > 0 then
                begin
                  Str := copy(Str, j + 8, length(Str)- j - 8);
                  Hag := StrToFloat2(Str);
                  break;
                end;
              end;
            end;

            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<altitudeMode>', '</altitudeMode>') then
            begin
              HgtMode := copy(S[_sI], _sJ, _eJ - _sJ);
            end
            else HgtMode := 'absolute';

            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<name>', '</name>') then
            begin
              Str := copy(S[_sI], _sJ, _eJ - _sJ);
            end
            else Str := '*';


            if (HgtMode = 'clampToGround') or (HgtMode = 'relativeToGround') then
              AddMarker(Str, B, L, 0, H, Hag)    // AddMarker(Str, B, L, 0, 0, H)
            else
            if HgtMode = 'absolute' then
              AddMarker(Str, B, L, 0, H, Hag)  // AddMarker(Str, B, L, H, 0, Hag)
            else
              AddMarker(Str, B, L, 0, H, Hag);
            
         end;

         2: if doRoutes then
         begin
            j := 0;
            if RouteCount >= RouteMax -1 then
              exit
            else
              Inc(RouteCount);

            Route[RouteCount-1].Geo := true;
            SetLength(Route[RouteCount-1].GWPT, 0);

            GotLook := FALSE;
            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<LookAt>', '</LookAt>') then
            begin
              SI2 := _sI;
              EI2 := _eI;

              B := 0;
              AssignSE2;
              if FindTaggedData(_sI, _sJ, _eI, _eJ, '<latitude>', '</latitude>') then
                 B := StrToFloat2(copy(S[_sI], _sJ, _eJ - _sJ));

              L := 0;
              AssignSE2;
              if FindTaggedData(_sI, _sJ, _eI, _eJ, '<longitude>', '</longitude>') then
                 L := StrToFloat2(copy(S[_sI], _sJ, _eJ - _sJ));

              H := 0;
              AssignSE2;
              if FindTaggedData(_sI, _sJ, _eI, _eJ, '<latitude>', '</latitude>') then
                 H := StrToFloat2(copy(S[_sI], _sJ, _eJ - _sJ));

              Hag := 0;
              AssignSE2;
              if FindTaggedData(_sI, _sJ, _eI, _eJ, '<heading>', '</heading>') then
                 Hag := StrToFloat2(copy(S[_sI], _sJ, _eJ - _sJ));

              if (B <> 0) and (L <> 0) then
              begin
                 AddMarker('LookAt', B, L, 0, 0, Hag);
                 Markers[Length(Markers)-1].Add1 := H;
                 GotLook := True;
              end;
            end;

            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<coordinates>', '</coordinates>') then
              for I := _sI to _eI do
              begin
                if I = _sI then
                  Str := copy(S[I], _sJ, length(S[I]) - _sJ)
                else if I = _eI then
                  Str := copy(S[I], 1, _eJ)
                else
                  Str := S[I];
                try
                  L := StrToFloat2(GetCols(Str, 0, 1, ',', false));
                  B := StrToFloat2(GetCols(Str, 1, 1, ',', false));
                  H := StrToFloat2(GetCols(Str, 2, 1, ',', false));
                  if (B = 0) and (L = 0) then
                     continue;

                  SetLength(Route[RouteCount-1].GWPT, j+1);
                  SetLength(Route[RouteCount-1].ALT,  j+1);
                  Route[RouteCount-1].GWPT[j].x := B;
                  Route[RouteCount-1].GWPT[j].y := L;
                  Route[RouteCount-1].ALT[j] := H;
                  inc(j);
                except
                  continue;
                end;
              end
              else exit;

            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<name>', '</name>') then
            begin
              Str := copy(S[_sI], _sJ, _eJ - _sJ);
            end
            else  Str := '';
            CheckNewRouteName(Str);

            Route[RouteCount-1].Name := Str;

            if GotLook then
            begin
              Markers[Length(Markers)-1].MarkerName := Str;
              Markers[Length(Markers)-1].MarkerKind := 5;
            end;

            if j = 0 then
              dec(RouteCount);
         end;

         3: if doArea then
         begin
            j := 0;
            if FrameCount >= FrameMax -1 then
              exit
            else
              Inc(FrameCount);

            FrameGeo := true;
            FrameCount := 0;

            AssignSE;
            if FindTaggedData(_sI, _sJ, _eI, _eJ, '<coordinates>', '</coordinates>') then
              for I := _sI to _eI do
              begin
                if I = _sI then
                  Str := copy(S[I], _sJ, length(S[I]) - _sJ)
                else if I = _eI then
                  Str := copy(S[I], 1, _eJ)
                else
                  Str := S[I];
                try
                  if FrameCount >= FrameMax-2 then break;

                  L := StrToFloat2(GetCols(Str, 0, 1, ',', false));
                  B := StrToFloat2(GetCols(Str, 1, 1, ',', false));

                  if (B = 0) and (L = 0) then
                     continue;

                  FramePoints[FrameCount-1,2].x := B;
                  FramePoints[FrameCount-1,2].y := L;

                  inc(FrameCount);
                except
                  continue;
                end;
              end
              else exit;

            Frame := FrameCount > 1;
            if Frame then
            begin
             // inc(FrameCount);
              FramePoints[FrameCount -1, 2].x := FramePoints[0, 2].x;
              FramePoints[FrameCount -1, 2].y := FramePoints[0, 2].y;
            end;

         end;
      end;     
  end;

  /// ?? ????? ? ?????? - ?????? ? ?????? ? ? ?? + ??? ???????
  function GetPlacemarks(var StartI, StartJ, EndI, EndJ: Integer):integer;
  const ST = '<Placemark>';
        ET = '</Placemark>';
  var SI, SJ, EI, EJ, Kind: Integer;
  begin
     result := -1;
     SI := StartI;    SJ := StartJ;
     EI := EndI;      EJ := EndJ;
     if FindTaggedData(SI, SJ, EI, EJ, ST, ET) then
     begin
       StartI := SI;   StartJ := SJ;
       EndI := EI;     EndJ := EJ;

       Kind := GetKind(SI, SJ, EI, EJ);     // ?????????? ???
       if Kind > 0 then
       begin
          GetObjData(StartI, StartJ, EndI, EndJ, Kind); // ???????? ?????? ????????? ??? ????
          result := Kind;
       end;
     end
     else
       result := -1;
  end;

  var CurI, I1, I2, j1, j2, found :Integer;

begin
  S := TStringList.Create;
  S.LoadFromFile(FileName);
  
  if not doAdd then
  begin
    if doRoutes then ResetRoutes;
    if doPoints then  ResetMarkers;
    if doArea then
    begin
       FrameCount := 0;
       Frame := false;
    end;
  end;
  
  I1 := 0; J1 := 0; I2 := 0; J2 := 0;
  repeat
    I1 := I2; j1 := j2;
    I2 := S.Count -1; j2 := Length(S[S.Count -1])-1;
    found := GetPlacemarks(I1, J1, I2, J2);
  until found < 0;

  S.Free;
  RecomputeBaseObjects(WaitForZone);
end;

procedure LoadRoutesMission(FileName:String; doAdd:Boolean);
  procedure TestName(var name:string; j:integer);
  var I:integer;
  begin
    if j = 0 then
       exit;

    for I := 0 to j-1 do
       if Route[I].Name = name then
          name := name + '_';

  end;


  function getPar(str, par: string):string;
    var j, k, k1, k2 :Integer;
  begin
      j := Pos(par, str);
      k1 := -1;
      k2 := -1;
      if j <= 0 then
         exit;

      for k := j+1 to Length(str)-1 do
      begin
        if str[k]= '"' then
        begin
           if k1 = -1 then
             k1 := k
           else
           if k2 = -1 then
             k2 := k
           else
             break;
        end;
      end;
      if k2 = -1 then
         k2 :=  Length(str)-1;
      if k1 <> -1 then
         result := (copy(str,k1,k2-k1))
  end;


var I, Lmode, Pcount, oldRouteCount :Integer;  F : TStringList;
    bX, bY, X, Y, A, H,_x, _y, _a, _h :Double;

begin
   oldRouteCount := RouteCount;
   if DoAdd = false then
   begin
      RouteCount := 0;
      FrameCount := 0;
      Frame      := false;
      FrameGeo   := false;
      oldRouteCount := 0;
      SetLength(Markers, 0);
   end;

   F := TStringList.Create;
   F.LoadFromFile(FileName);
   F.Text := UTF8ToAnsi(F.Text);

   RouteCount := RouteCount +1;
   PCount := 0;
   Route[RouteCount-1].Name := 'Mission';
   SetLength(Route[RouteCount-1].GWPT, 1000);
   SetLength(Route[RouteCount-1].ALT, Length(Route[RouteCount-1].GWPT));

   I := 0;  LMode :=0;
   repeat
     if LMode = 0 then
     begin
       _x := 0; _y := 0; _H := 0; _A := 0;

       if Pos('<mwp',F[I])>0 then
         Lmode := 1;

       if Pos('<missionitem',F[I])>0 then
         Lmode := 2;
     end;

     case LMode of
        1:
        begin
          _x := StrToFloat2(getPar(F[I],'cx'));
          _y := StrToFloat2(getPar(F[I],'cy'));
          if _x <> 0 then bx := _x;
          if _y <> 0 then by := _y;

          if Pos('/>',F[I])>0 then
          begin
             Lmode := 0;
          end

        end;
        2:
        begin
          _x := StrToFloat2(getPar(F[I],'lat'));
          _y := StrToFloat2(getPar(F[I],'lon'));
          _a := StrToFloat2(getPar(F[I],'alt'));
          if _x <> 0 then x := _x;
          if _y <> 0 then y := _y;
          if _a <> 0 then a := _a;

          if Pos('/>',F[I])>0 then
          begin
            Lmode := 0;
            Route[RouteCount-1].GWPT[PCount].x := x;
            Route[RouteCount-1].GWPT[PCount].y := y;
            Route[RouteCount-1].ALT[PCount] := a;
            Inc(PCount);
          end;
        end;
     end;

     if PCount > Length(Route[RouteCount-1].GWPT) -2 then
     begin
        SetLength(Route[RouteCount-1].GWPT, Length(Route[RouteCount-1].GWPT) + 1000);
        SetLength(Route[RouteCount-1].ALT, Length(Route[RouteCount-1].GWPT));
     end;
        
     inc(I);
   until I >= F.Count;

   Route[RouteCount-1].Geo := True;
   SetLength(Route[RouteCount-1].GWPT, Pcount);
   SetLength(Route[RouteCount-1].WPT,  Pcount);
   SetLength(Route[RouteCount-1].ALT,  Pcount);
   if PCount = 0 then
     dec(RouteCount);
    
   ReComputeRoutes(WaitForZone);

   if (bx <> 0) and (by <> 0) then
   begin
     SetBaseBL(By, Bx);

     Center.x := Base[1].x;
     Center.y := Base[1].y;

     ShiftCenter.x := Center.x;
     ShiftCenter.y := Center.y;
   end;

   F.Destroy;
end;

{
  procedure LoadRoutes(FileName: String; DoAdd:Boolean; askS:string);

  procedure TestName(var name:string; j:integer);
  var I:integer;
  begin
    if j = 0 then
       exit;

    for I := 0 to j-1 do
       if Route[I].Name = name then
          name := name + '_';

  end;

 var
     F : TStringList;
     I, J, I1, I2, K, oldRouteCount : Integer;
     s1, s2, FrameFile : String ;
     found, isBegin, NewFrame: Boolean;
     _X,_Y,_Z : double;
begin
   F := TStringList.Create;

   oldRouteCount := RouteCount;

   if DoAdd = false then
   begin
      RouteCount := 0;
      FrameCount := 0;
      Frame      := false;
      FrameGeo   := false;
      oldRouteCount := 0;
   end;

   WGS := FindDatum('WGS84') ;

   if filename<>'' then
   try

     if (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.xls')or
        (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5))='.xlsx')  then
        ExcelToStringList(FileName, F)
     else
        F.LoadFromFile(FileName);

 }

procedure LoadGpxFile(FileName:String; doAdd:Boolean);
var i, j, k : integer;
    lat,lon,ele : real;
    S: TStringList;
    cs, s2, s3, nam: String;
begin
   S := TStringList.Create;
   S.LoadFromFile(Filename);

   I := 0;
   S.Text := UTF8ToAnsi(S.Text);
   prepareGPX(S);

   if not DoAdd then
   begin
     RouteCount := 0;
     SetLength(Markers,0);
   end;

   // 1. WayPoints
   repeat
     cs := AnsilowerCase(S[I]);

     j := Pos('<rte>', cs);
     k := Pos('<wpt', cs);

     if (j = 0)and(k = 0) then
     begin
       inc(i);
       continue;
     end;

     if (j<>0)and((j < k)or(k = 0)) then
     begin
       Inc(RouteCount);
       Route[RouteCount-1].Geo:=True;
       SetLength(Route[RouteCount-1].GWPT,0);
       SetLength(Route[RouteCount-1].WPT,0);

       cs := copy(cs, j + 5, length(cs) - j - 4 );
       // 1. Name
       repeat
            j := Pos('<name>', cs);
            k := Pos('</name>', cs);

            if j = 0 then
            begin
              inc(I);
              if I <= S.Count-1 then
              begin
                cs := AnsilowerCase(S[I]);
                s3 := S[I];
              end;
              continue;
            end;

            s2 := copy(s3, j+6, k-j-6);
            Route[RouteCount-1].Name := s2;

          until (I>= S.Count-1) or (j<>0);

       // 2. Pts
       repeat

          j := pos('<rtept', cs);
          if J <> 0 then
          begin
            cs := copy(cs, j + 6, length(cs) - j - 5 );

            j := Pos('lat', cs);
            k := Pos('lon', cs);
            if k < j then
            begin
              s2 := copy(cs, k+4, j-k-5 );
              lon := StrToFloat2(s2);
              k := Pos('>', cs);
              s2 := copy(cs, j+4, k-j );
              lat := StrToFloat2(s2);

              SetLength(Route[RouteCount-1].GWPT,Length(Route[RouteCount-1].GWPT)+1);
              Route[RouteCount-1].GWPT[Length(Route[RouteCount-1].GWPT)-1].x := lat;
              Route[RouteCount-1].GWPT[Length(Route[RouteCount-1].GWPT)-1].y := lon;

              Cs := S[I];
              Cs := copy(S[I], k+1, length(cs) - k);
            end
               else
               begin
                s2 := copy(cs, j+4, k-j-5 );
                lat := StrToFloat2(s2);
                j := Pos('>', cs);
                s2 := copy(cs, k+4, j-k-5 );
                lon := StrToFloat2(s2);

                SetLength(Route[RouteCount-1].GWPT,Length(Route[RouteCount-1].GWPT)+1);
                Route[RouteCount-1].GWPT[Length(Route[RouteCount-1].GWPT)-1].x := lat;
                Route[RouteCount-1].GWPT[Length(Route[RouteCount-1].GWPT)-1].y := lon;

                Cs := S[I];
                Cs := copy(S[I], j+1, length(cs) - j);
              end;


          end;



          inc(I);
          if I <= S.Count-1 then
            cs := AnsilowerCase(S[I]);

          if (pos('</rte>', cs)>0) then
              break;

       until (I > S.Count-1) or (pos('</rte>', cs)>0);

     end
      else
       if (k<>0)and((k < j)or(j = 0)) then
       begin
         /// getting lat-lon
         cs := copy(cs, k + 5, length(cs) - k - 4 );
         lat := 0;
         lon := 0;
         ele := 0;
         nam := '';

         j := Pos('lat', cs);
         k := Pos('lon', cs);
         if (K=0)and(j=0) then
         begin
            inc(i);
            continue;
         end;

         if k < j then
         begin
           s2 := copy(cs, k+4, j-k-5 );
           lon := StrToFloat2(s2);
           k := Pos('>', cs);
           s2 := copy(cs, j+4, k-j );
           lat := StrToFloat2(s2);

           Cs := S[I];
           Cs := copy(S[I], k+1, length(cs) - k);
         end
           else
           begin
             s2 := copy(cs, j+4, k-j-5 );
             lat := StrToFloat2(s2);
             j := Pos('>', cs);
             s2 := copy(cs, k+4, j-k-5 );
             lon := StrToFloat2(s2);

             Cs := S[I];
             Cs := copy(S[I], j+1, length(cs) - j);
           end;

          //// name, ele
          repeat
            cs := AnsilowerCase(S[I]);
            j := Pos('<ele>', cs);
            k := Pos('</ele>', cs);

            if j <> 0 then
            begin
              ele := StrToFloat2(copy(S[I], j+5, k-j-5));
            end;

            j := Pos('<name>', cs);
            k := Pos('</name>', cs);

            if j <> 0 then
            begin
              s3 := S[I];
              nam := copy(s3, j+6, k-j-6);
            end;

            inc(I);
            cs := AnsilowerCase(S[I]);
            if Pos('/wpt>', cs) > 0 then
            begin
              if (lat<>0)and(lon<>0) then
                 AddMarker(nam,lat,lon,0,ele,0);

              break;
            end;

          until (I > S.Count-1) or (Pos('</wpt>', S[I])>0);

       end;

     inc(I);
   until I>= S.Count-1;


   for I := 0 to RouteCount - 1 do
   if (AnsiLowerCase(Route[I].Name) = 'area borders')
      or (AnsiLowerCase(Route[I].Name) = 'area') then
   begin
     FrameCount := Length(Route[I].GWPT);
     for j := 0 to Length(Route[I].GWPT) - 1 do
     begin
       FramePoints[j,2].x := Route[I].GWPT[j].x;
       FramePoints[j,2].y := Route[I].GWPT[j].y;
     end;
     FrameGeo := True;
     Frame := true;
     DelRoute(I);
     break;
   end;

   RecomputeRoutes(WaitForZone);
   RecomputeMarkers(WaitForZone);

   MarkerLoops;

   S.Free;
end;

procedure SaveGpxFile(FileName:String; AskifExist:boolean); overload;
begin
  SaveGpxFile(FileName, AskifExist, true, true, true, true, false, false,
    true, 0, false, false);
end;

procedure SaveGpxFile(FileName:String;  StartI:integer; AskifExist:boolean); overload;
begin
  SaveGpxFile(FileName, AskifExist, true, true, true, true, false, false,
    true, StartI, false, false);
end;

procedure SaveGPXFile(FileName:String; AskifExist:boolean; doPickets, doCorners,
          doCenters, doRoutes, doKnots, doArea, AskArea: boolean;
          StartI:integer; DoEachFile, DoDir: boolean); overload;
var
    S, LoopsS :TStringList;
    s1, s2, s3, Fdir : string;
    found : boolean;
    I, J, k, collected: integer;
const
 hdr1 = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>';
 hdr2 = '<gpx xmlns="http://www.topografix.com/GPX/1/1" creator="RouteEditor" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">';

 xt  = '<extensions>';
 xte = '</extensions>';
 xt1 = '<gpxx:RouteExtension xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">';
 xt2 = '<gpxx:IsAutoNamed>false</gpxx:IsAutoNamed>';
 xt3 = '<gpxx:DisplayColor>Magenta</gpxx:DisplayColor>';
 xt4 = '</gpxx:RouteExtension>';

 xt5 = '<gpxx:RoutePointExtension xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">';
 xt6 = '<gpxx:Subclass>000000000000FFFFFFFF0000000002000000</gpxx:Subclass>';
 xt7 = '</gpxx:RoutePointExtension>';

 xt8 = '<gpxx:WaypointExtension xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">';
 xt9 = '<gpxx:DisplayMode>SymbolAndName</gpxx:DisplayMode>';
 xt10= '</gpxx:WaypointExtension>';

 xt11= '<gpxx:TrackExtension xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">';
 xt12= '<gpxx:DisplayColor>Green</gpxx:DisplayColor>';
 xt13= '</gpxx:TrackExtension>';
begin
     if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.gpx' then
        FileName := FileName + '.gpx';

     if AskifExist then
       if Fileexists(FileName) then
         if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
              exit;


     S := TStringList.Create;
     S.Add(hdr1);
     S.Add(hdr2);

     if Length(Markers) > 0 then
     for I := StartI to Length(Markers) - 1 do
     Begin
       if (doCorners or DoCenters or DoPickets) and
         not (doCorners and DoCenters and DoPickets) then
           if Markers[I].MarkerKind = 0 then
             continue;

       if doCenters = false then
           if Markers[I].MarkerKind = 1 then
             continue;
       if doCorners = false then
           if Markers[I].MarkerKind = 2 then
             continue;
       if doPickets = false then
           if Markers[I].MarkerKind = 3 then
             continue;


       S.Add('');
       S.Add('  <wpt lat="'
              + ChangeSeps(format('%.7f',[Markers[I].Gx]), '.') +
              '" lon="' + ChangeSeps(format('%.6f',[Markers[I].Gy]), '.') +'">');
       if  Markers[I].HGeo <> 0 then
         S.Add('    <ele>' + ChangeSeps(FormatFloat('0.00000', Markers[I].HGeo), '.') + '</ele>');
       S.Add('    <name>' + Markers[I].MarkerName + '</name>');
       S.Add('    <sym>Flag, Blue</sym>');
       S.Add('    '+xt);   S.Add('    '+xt8);   S.Add('      '+xt9);
       S.Add('    '+xt10);  S.Add('    '+xte);
       S.Add('  </wpt>');
     End;


     if AskArea then
     begin
       DoArea := false;
       if FrameCount > 0 then
          DoArea :=  MessageDlg(Inf[120], mtConfirmation, MbYesNo,0) = 6;
     end;

     if FrameCount > 0 then
      if DoArea then
      Begin
         S.Add('');
         S.Add('  <rte>');
         S.Add('    <name>Area Borders</name>');
         S.Add('    '+xt);     S.Add('     '+xt1);  S.Add('       '+xt2);
         S.Add('       '+xt3); S.Add('     '+xt4);  S.Add('    '+xte);

         for J := 0 to FrameCount - 1 do
         begin
            S.Add('    <rtept lat="'
              + ChangeSeps(format('%.7f',[FramePoints[j,2].x]), '.') +
              '" lon="' + ChangeSeps(format('%.6f',[FramePoints[j,2].y]), '.') +'">');
            S.Add('    <name>Area_'+IntToStr(J+1) + '</name>');
            S.Add('    <sym>Waypoint</sym>');
            S.Add('      '+xt);   S.Add('      '+xt5);   S.Add('        '+xt6);
            S.Add('      '+xt7);  S.Add('      '+xte);
            S.Add('    </rtept>');
         end; 
         S.Add('  </rte>');
      End;

     if DoRoutes then
     for I := 0 to RouteCount - 1 do
     Begin
       S.Add('');
       S.Add('  <rte>');
       S.Add('    <name>' + Route[I].Name + '</name>');

       S.Add('    '+xt);     S.Add('     '+xt1);  S.Add('       '+xt2);
       S.Add('       '+xt3); S.Add('     '+xt4);  S.Add('    '+xte);

       for J := 0 to Length(Route[i].GWPT) - 1 do
       begin
         S.Add('    <rtept lat="'
              + ChangeSeps(format('%.7f',[Route[i].GWPT[j].x]), '.') +
              '" lon="' + ChangeSeps(format('%.6f',[Route[i].GWPT[j].y]), '.') +'">');

         S.Add('    <name>' + Route[I].Name+'_'+IntToStr(J+1) + '</name>');
         S.Add('    <sym>Waypoint</sym>');
         S.Add('      '+xt);   S.Add('      '+xt5);   S.Add('        '+xt6);
         S.Add('      '+xt7);  S.Add('      '+xte);
         S.Add('    </rtept>');
       end;
       S.Add('  </rte>');
     End;

     if DoKnots then
     for I := StartI to Length(Markers)-4 do
     Begin
        s1 := AnsiLowerCase(Markers[I].MarkerName);
        s1 := Copy(s1, Length(s1)-2, 3);

        if s1 = '_k1' then
        begin
          s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                          Length(Markers[I].MarkerName)-3));

          found := true;
         { for j := 1 to 3 do
          if i+j <=  Length(Markers) - 1 then
          begin
            s1 := AnsiLowerCase(Markers[I+j].MarkerName);
            if not (s1 = s2 + '_k' + IntToStr(j+1)) then
            begin
               found := false;
               break;
            end;
          end
          else found := false; }

           collected := 0;
            s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));
            repeat
              s1 := AnsiLowerCase(Markers[I+collected].MarkerName);
              if s1 = s2 + '_k' + IntToStr(collected+1) then
                 inc(collected)
              else
                break;
            until I+collected > Length(Markers)-1;

          s2 := Copy(Markers[I].MarkerName, 1, Length(Markers[I].MarkerName)-3);



          if found then
          begin
            S.Add('');
            S.Add('  <rte>');
            S.Add('    <name>' + s2 + '</name>');

            S.Add('    '+xt);     S.Add('     '+xt1);  S.Add('       '+xt2);
            S.Add('       '+xt3); S.Add('     '+xt4);  S.Add('    '+xte);

            for J := 0 to collected do
            begin
              if J < collected then
                k := j
                 else
                   k := 0;

              S.Add('    <rtept lat="'
                  + ChangeSeps(format('%.7f',[Markers[I+k].Gx]), '.') +
                  '" lon="' + ChangeSeps(format('%.6f',[Markers[I+k].Gy]), '.') +'">');

              S.Add('    <name>' + Markers[I+k].MarkerName + '</name>');
              S.Add('    <sym>Waypoint</sym>');
              S.Add('      '+xt);   S.Add('      '+xt5);   S.Add('        '+xt6);
              S.Add('      '+xt7);  S.Add('      '+xte);
              S.Add('    </rtept>');
            end;
            S.Add('  </rte>');
          end;

        end;
     End;

     /// tracks
    { if length(MainTrack) > 1 then
     begin
       S.Add('  <trk>');
       S.Add('  <name>Track</name>');
       S.Add('      '+xt);   S.Add('      '+xt11);   S.Add('        '+xt12);
       S.Add('      '+xt13);  S.Add('      '+xte);
       S.Add('    <trkseg>');
       for I := 0 to length(MainTrack)- 1 do
       begin
         S.Add('    <rtkpt lat="'
              + ChangeSeps(format('%.7f',[MainTrack[I].B]), '.') +
              '" lon="' + ChangeSeps(format('%.6f',[Route[i].GWPT[j].y]), '.') +'">');
       end;
       S.Add('    </trkseg>');
       S.Add('  </trk>');
     end; }


     S.Add('</gpx>');

     for I := 0 to S.Count - 1 do
        S[I] := ANSIToUTF8(S[I]);
     //S.Text := UTF8Encode(S.Text);
     S.SaveToFile(FileName);
     //SaveRoutesToFile(FileName, WGS, 0, 0, #$9);


     if DoKnots and DoEachFile then
     Begin
       Fdir := ExtractFileDir(FileName);
       if Fdir <> '' then
         if Fdir[length(Fdir)-1]<>'\' then
            Fdir := Fdir + '\';

       if DoDir then
       begin
          Fdir := Fdir + Copy(ExtractFileName(FileName), 1,
                       Length(ExtractFileName(FileName))-4)+ '\';
          ForceDirectories(Fdir);
       end;

       // 1) ?????? ?????? ??????
       LoopsS := TStringList.Create;
       GetKnotMarkerList(LoopsS, StartI);

       // 2) ???????? ?? ??????
       for I := 0 to LoopsS.Count - 1 do
       begin
         S.Clear;
         S.Add(hdr1);
         S.Add(hdr2);
         k := -1;
         if checkL then
         begin
           s3 := AnsiLowerCase(LoopsS[I]);
           if s3[1] = 'l' then
              Delete(s3,1,1)
         end;

         for j := StartI to Length(Markers) - 1 do
         begin
           if (AnsiLowerCase(Markers[j].MarkerName) = AnsiLowerCase(LoopsS[I]))
              or ( Pos(AnsiLowerCase(LoopsS[I])+'_',
                     AnsiLowerCase(Markers[j].MarkerName)) {> 0} = 1 )
              or ( CheckL and ( Pos(s3 + '_',
                     AnsiLowerCase(Markers[j].MarkerName)) {> 0} = 1 ) ) {06.02.2022}
             then
             begin
                S.Add('');
                S.Add('  <wpt lat="'
                  + ChangeSeps(format('%.7f',[Markers[j].Gx]), '.') +
                  '" lon="' + ChangeSeps(format('%.6f',[Markers[j].Gy]), '.') +'">');

                S.Add('    <name>' + Markers[j].MarkerName + '</name>');
                S.Add('    <sym>Flag, Blue</sym>');
                S.Add('    '+xt);   S.Add('    '+xt8);   S.Add('      '+xt9);
                S.Add('    '+xt10);  S.Add('    '+xte);
                S.Add('  </wpt>');

                if k = -1 then
                try
                  s1 := AnsiLowerCase(Markers[j].MarkerName);
                  s1 := Copy(s1, Length(s1)-2, 3);
                  if s1 = '_k1' then
                     k := j;
                except
                end;

             end;
         end;

         if DoKnots then
         if k > -1 then
         begin
            s2 := AnsiLowerCase( Copy(Markers[k].MarkerName, 1,
                          Length(Markers[k].MarkerName)-3));
            found := true;

            collected := 0;
            
            repeat
              s1 := AnsiLowerCase(Markers[I+collected].MarkerName);
              if s1 = s2 + '_k' + IntToStr(collected+1) then
                 inc(collected)
              else
                break;
            until I+collected > Length(Markers)-1;

            found := collected > 3;
            {for j := 1 to 3 do
            if k+j <=  Length(Markers) - 1 then
            begin
              s1 := AnsiLowerCase(Markers[k+j].MarkerName);
              if not (s1 = s2 + '_k' + IntToStr(j+1)) then
              begin
                found := false;
                break;
              end;
            end
            else found := false; }

            s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));

            if found then
            begin
              s2 := Copy(Markers[k].MarkerName, 1, Length(Markers[k].MarkerName)-3);
              S.Add('');
              S.Add('  <rte>');
              S.Add('    <name>' + s2 + '</name>');
              S.Add('    '+xt);     S.Add('     '+xt1);  S.Add('       '+xt2);
              S.Add('       '+xt3); S.Add('     '+xt4);  S.Add('    '+xte);

              for J := 0 to collected-1 do
              begin

                S.Add('    <rtept lat="'
                  + ChangeSeps(format('%.7f',[Markers[j+k].Gx]), '.') +
                  '" lon="' + ChangeSeps(format('%.6f',[Markers[j+k].Gy]), '.') +'">');

                S.Add('    <name>' + Markers[j+k].MarkerName + '</name>');
                S.Add('    <sym>Waypoint</sym>');
                S.Add('      '+xt);   S.Add('      '+xt5);   S.Add('        '+xt6);
                S.Add('      '+xt7);  S.Add('      '+xte);
                S.Add('    </rtept>');

                if j = collected-1 then  {????????? ?????}
                begin
                  S.Add('    <rtept lat="'
                  + ChangeSeps(format('%.7f',[Markers[k].Gx]), '.') +
                  '" lon="' + ChangeSeps(format('%.6f',[Markers[k].Gy]), '.') +'">');

                  S.Add('    <name>' + Markers[k].MarkerName + '</name>');
                  S.Add('    <sym>Waypoint</sym>');
                  S.Add('      '+xt);   S.Add('      '+xt5);   S.Add('        '+xt6);
                  S.Add('      '+xt7);  S.Add('      '+xte);
                  S.Add('    </rtept>');
                end;
            end;
            S.Add('  </rte>');
          end;

         end;


         S.Add('</gpx>');
         for j := 0 to S.Count - 1 do
           S[j] := ANSIToUTF8(S[j]);

         S.SaveToFile(Fdir + CorrectName(LoopsS[I])+'.gpx');
       end;

       LoopsS.Free;
     End;


     S.Free;
end;


procedure SaveXYZFile(FileName:String; CS, StartI:integer;
             DoRound, DoExt, AskifExist:boolean);
var    csX, csY, csZ, csH :String;

  procedure BLToCS(B,L,H :double);
  var cX, cY, cZ: Double; I:Integer;
  begin
       csZ :='';
       csH :='';

       Geo1ForceToGeo2(B, L, H, WGS, CoordinateSystemList[CS].DatumN, B, L, H);

       DatumToCoordinateSystem(CS, B, L, H, cX, cY, cZ);
       if DoRound then
       begin
          csX := IntToStr(round(cX));
          csY := IntToStr(round(cY));
          csZ := IntToStr(round(cZ));
       end else
       case CoordinateSystemList[CS].ProjectionType of
          0:begin
             csX := DegToDMS(cX,true, 5, false);
             csY := DegToDMS(cY,false,5, false);
             csH  := Format('%.3f',[cZ]);
          end;
          1:begin
            csX := Format('%.3f',[cX]);
            csY := Format('%.3f',[cY]);
            csZ := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH  := Format('%.3f',[cZ]);
          end;
       end;

       for I := 1 to length(csx) - 1 do
         if csx[I] = ',' then    csx[I] := '.';
       for I := 1 to length(csy) - 1 do
         if csy[I] = ',' then    csy[I] := '.';
       for I := 1 to length(csH) - 1 do
         if csH[I] = ',' then    csH[I] := '.';
  end;

var i, j :integer;
    S :TSTringList;
    LoopsS :TStringList;
begin
   if Length(Markers) < StartI + 1 then
     exit;

   if (Length (FileName) < 4) or
     (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.xyz') then
      FileName := FileName + '.xyz';

   if AskifExist then
   if FileExists(FileName) then
   if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

   LoopsS := TStringList.Create;
   S := TStringList.Create;
   GetKnotMarkerList(LoopsS, StartI);

   for I := StartI to LoopsS.Count - 1 do
   begin
     S.Add(LoopsS[I]);
     if DoExt then
       S[S.Count - 1] := S[S.Count - 1] + '.prf';

     S[S.Count - 1] := S[S.Count - 1] + ' 1';
     for j := StartI to Length(Markers) - 1 do
       if Pos(AnsiLowerCase(LoopsS[I]) + '_',
              AnsiLowerCase(Markers[j].MarkerName)) > 0 then
       if Pos(AnsiLowerCase(LoopsS[I]) + '_k',
              AnsiLowerCase(Markers[j].MarkerName) ) = 0 then
       begin
           BLToCS(Markers[j].Gx, Markers[j].Gy,  Markers[j].H);
           S[S.Count - 1] := S[S.Count - 1] + ', ' + csX + ' ' + csY +' 0';
       end;
   end;

   S.SaveToFile(FileName);
   S.Free;
   LoopsS.Free;
end;

procedure SaveMXYZFile(FileName:String;
             CS, StartI:integer; DoRound, DoNames, DoExt, AskifExist:boolean);
var    csX, csY, csZ, csH :String;

  procedure BLToCS(B,L,H :double);
  var cX, cY, cZ: Double;  I :Integer;
  begin
       csZ :='';
       csH :='';

       Geo1ForceToGeo2(B, L, H, WGS, CoordinateSystemList[CS].DatumN, B, L, H);

       DatumToCoordinateSystem(CS, B, L, H, cX, cY, cZ);
       if DoRound then
       begin
          csX := IntToStr(round(cX));
          csY := IntToStr(round(cY));
          csZ := IntToStr(round(cZ));
       end else
       case CoordinateSystemList[CS].ProjectionType of
          0:begin
             csX := DegToDMS(cX,true, 5, false);
             csY := DegToDMS(cY,false,5, false);
             csH  := Format('%.3f',[cZ]);
          end;
          1:begin
            csX := Format('%.3f',[cX]);
            csY := Format('%.3f',[cY]);
            csZ := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH  := Format('%.3f',[cZ]);
          end;
       end;

       for I := 1 to length(csx) - 1 do
         if csx[I] = ',' then    csx[I] := '.';
       for I := 1 to length(csy) - 1 do
         if csy[I] = ',' then    csy[I] := '.';
       for I := 1 to length(csH) - 1 do
         if csH[I] = ',' then    csH[I] := '.';
  end;

var i, j, GenN, Step :integer;
    S :TSTringList;
    LoopsS :TStringList;
    A: Array of real;
    l1, l2: integer;
begin
   if Length(Markers) < StartI +1 then
     exit;
   if (Length (FileName) < 5) or
     (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5)) <> '.mxyz') then
      FileName := FileName + '.mxyz';

   if AskifExist then
   if FileExists(FileName) then
   if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

    // ssfsf
    LoopsS := TStringList.Create;
    S := TStringList.Create;
    GetKnotMarkerList(LoopsS, StartI);

    SetLength(A, LoopsS.Count);

    for Step := 1 to 3 do
      for I := StartI to LoopsS.Count - 1 do
      begin
        if DoNames then
          GenN := Trunc(StrToFloat2(LoopsS[I]))
        else
          GenN := I;

        case Step of
           1: begin
              for j := StartI to Length(Markers) - 1 do
                if Pos(AnsiLowerCase(LoopsS[I]) + '_',
                   AnsiLowerCase(Markers[j].MarkerName)) > 0 then
                if Pos(AnsiLowerCase(LoopsS[I]) + '_k',
                   AnsiLowerCase(Markers[j].MarkerName) ) = 0 then
                begin
                    S.Add(Markers[j].MarkerName); {LoopsS[I]}  {CorrectNum(Markers[j].MarkerName)}
                    if DoExt then
                      S[S.Count - 1] := S[S.Count - 1] + '.eds';
                    BLToCS(Markers[j].Gx, Markers[j].Gy,  Markers[j].H);
                    S[S.Count - 1] := S[S.Count - 1] + ' 1, ' + csX
                                         + ' ' + csY +' 0, ' + IntToStr(GenN);
                end;
           end;

           2: begin
             l1 := -1;   l2 := -1;
             for j := StartI to Length(Markers) - 1 do
                if Pos(AnsiLowerCase(LoopsS[I]) + '_k1',
                   AnsiLowerCase(Markers[j].MarkerName)) > 0 then
                begin
                  l1 := j;
                  break;
                end;

             for j := StartI to Length(Markers) - 1 do
                if Pos(AnsiLowerCase(LoopsS[I]) + '_k2',
                   AnsiLowerCase(Markers[j].MarkerName)) > 0 then
                begin
                  l2 := j;
                  break;
                end;

             if (l1 > 0) and (l2 > 0) then
               A[I] := (-pi/2 + arctan2(Markers[l2].x - Markers[l1].x,
                               Markers[l2].y - Markers[l1].y))*180/pi;
             if A[I] < 0 then
                A[I] := A[I] + 360;              
           end;


           3: begin
              for j := StartI to Length(Markers) - 1 do
                if AnsiLowerCase(Markers[j].MarkerName) =
                   AnsiLowerCase(LoopsS[I]) then
                begin
                    S.Add('generator '+intToStr(GenN));
                    BLToCS(Markers[j].Gx, Markers[j].Gy,  Markers[j].H);
                    S[S.Count - 1] := S[S.Count - 1] + ' ' + csX
                                         + ' ' + csY +' ';

                    case doRound of
                       false: begin
                            csH := Format('%.2f',[A[I]]);

                            for l1 := 1 to length(csH) - 1 do
                               if csH[l1] = ',' then    csH[l1] := '.';
                         end;
                       true: csH := IntToStr(round(A[I]));
                    end;

                    S[S.Count - 1] := S[S.Count - 1] + csH;
                end;

           end;
        end;  /// end of case

      end;
          {

     S[S.Count - 1] := S[S.Count - 1] + ' 1';
     for j := StartI to Length(Markers) - 1 do
       if Pos(AnsiLowerCase(LoopsS[I]) + '_',
              AnsiLowerCase(Markers[j].MarkerName)) > 0 then
       if Pos(AnsiLowerCase(LoopsS[I]) + '_k',
              AnsiLowerCase(Markers[j].MarkerName) ) = 0 then
       begin
           BLToCS(Markers[j].Gx, Markers[j].Gy,  Markers[j].H);
           S[S.Count - 1] := S[S.Count - 1] + ', ' + csX + ' ' + csY +' 0';
       end;
   end;       }

   S.SaveToFile(FileName);
   S.Free;
   LoopsS.Free;
end;


procedure SaveMarkers(FileName:String; AskifExist: Boolean);
var S :TStringList;
    I :integer;
    HasUdf: Boolean;
begin
   if Length(Markers) = 0 then
       Exit;

   if (Length (FileName) < 5) or
    (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5)) <> '.mark') then
      FileName := FileName + '.mark';

   if AskifExist then
   if FileExists(FileName) then
   if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

   S := TStringList.Create;

   HasUdf := MarkersUDFCount > 0;

   for I := 0 to Length(Markers) - 1 do
   Begin
       if POS('!#', markers[I].MarkerName)=1 then
         continue;
       
       S.Add(Markers[I].MarkerName + #$9 + FloatToSTr(Markers[I].Gx)
                             + #$9 + FloatToSTr(Markers[I].Gy)
                             + #$9 + FloatToSTr(Markers[I].H)
                             + #$9 + FloatToSTr(Markers[I].Hgeo)
                             + #$9 + IntToSTr(Markers[I].MarkerKind)
                             );
       if HasUdf then
         S[S.Count-1] := S[S.Count-1] + #$9 + FloatToSTr(Markers[I].Add1)
                                      + #$9 + FloatToSTr(Markers[I].Add2);
       if Markers[I].Alt <> 0 then
         S[S.Count-1] := S[S.Count-1] + #$9 + FloatToSTr(Markers[I].Alt);
   End;

  S.SaveToFile(FileName);
  S.Free;
end;

procedure SaveTXTKnotMarkers(FileName:String; CS, StartI:Integer;  Sep:String;
        dPickets, dCorners, dCenters, doHeader, doNumbers :Boolean;
        AskifExist:boolean; DoEachFile, DoDir: boolean);

var    csX, csY, csZ, csH :String;

  procedure BLToCS(B,L,H :double);
  var cX, cY, cZ: Double;
  begin
       csZ :='';
       csH :='';

       Geo1ForceToGeo2(B, L, H, WGS, CoordinateSystemList[CS].DatumN, B, L, H);

       DatumToCoordinateSystem(CS, B, L, H, cX, cY, cZ);

       case CoordinateSystemList[CS].ProjectionType of
          0:begin
             csX := DegToDMS(cX,true, 5, false);
             csY := DegToDMS(cY,false,5, false);
             csH  := Format('%.3f',[cZ]);
          end;
          1:begin
            csX := Format('%.3f',[cX]);
            csY := Format('%.3f',[cY]);
            csZ := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH  := Format('%.3f',[cZ]);
          end;
       end;
  end;

var i, j, N :integer;
    S, LoopsS :TSTringList;  st, Fdir, s3 :string;
begin
  if CS = -1 then
     CS := WGS;

  if Length(Markers) = 0 then
     Exit;

  if Copy(FileName, Length(FileName)-3,4) <> '.txt' then
     FileName := FileName + '.txt';

  if AskifExist then
     if Fileexists(FileName) then
     if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

  S := TStringList.Create;

  st := '';
  if DoHeader then
  begin
    case CoordinateSystemList[CS].ProjectionType of
      0: St := 'B_deg' + Sep + 'L_deg' + Sep + 'Name';
      1: St := 'X_m' + Sep + 'Y_m' + Sep  + 'Z_m' + 'Name';
      2..4: St := 'East_m' + Sep + 'North_m' + Sep + 'Name';
    end;

    if DoNumbers then
       St := St + Sep + 'No';

    S.Add(st);
  end;
  N := 0;
  for I := StartI to Length(Markers) - 1 do
  begin
         if POS('!#', markers[I].MarkerName)=1 then
            continue;

         if Markers[I].MarkerKind = 0 then
            continue;

         if dPickets = false then
           if Markers[I].MarkerKind = 3 then
             continue;

         if dCorners = false then
           if Markers[I].MarkerKind = 2 then
             continue;

         if dCenters = false then
           if Markers[I].MarkerKind = 1 then
             continue;

         BLToCS(Markers[I].Gx, Markers[I].Gy,  Markers[I].H);
         S.Add(csX + Sep + csY);
         if csZ <> '' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;

         S[S.Count-1] := S[S.Count-1] + Sep + Markers[I].MarkerName;

         if DoNumbers then
         begin
            inc(N);
            S[S.Count-1] := S[S.Count-1] + Sep + IntTostr(N);
         end;
  end;

  S.SaveToFile(FileName);


  if DoEachFile then
  Begin
       Fdir := ExtractFileDir(FileName);
       if Fdir <> '' then
         if Fdir[length(Fdir)-1]<>'\' then
            Fdir := Fdir + '\';

       if DoDir then
       begin
          Fdir := Fdir + Copy(ExtractFileName(FileName), 1,
                       Length(ExtractFileName(FileName))-4)+ '\';
          ForceDirectories(Fdir);
       end;

       // 1) ?????? ?????? ??????
       LoopsS := TStringList.Create;
       GetKnotMarkerList(LoopsS, StartI);
       // 2) ???????? ?? ??????
       for I := 0 to LoopsS.Count - 1 do
       begin
         S.Clear;
         N := 0;



           if checkL then
         begin
           s3 := AnsiLowerCase(LoopsS[I]);
           if s3[1] = 'l' then
              Delete(s3,1,1)
         end;

         for j := StartI to Length(Markers) - 1 do
         begin
           if (AnsiLowerCase(Markers[j].MarkerName) = AnsiLowerCase(LoopsS[I]))
              or ( Pos(AnsiLowerCase(LoopsS[I])+'_',
                     AnsiLowerCase(Markers[j].MarkerName)) {> 0} = 1 )
              or ( CheckL and ( Pos(s3 + '_',
                     AnsiLowerCase(Markers[j].MarkerName)) {> 0} = 1 ) ) {06.02.2022}
             then
             begin
                 BLToCS(Markers[j].Gx, Markers[j].Gy,  Markers[j].H);
                 S.Add(csX + Sep + csY);
                 if csZ <> '' then
                    S[S.Count-1] := S[S.Count-1] + Sep + csZ;

                 S[S.Count-1] := S[S.Count-1] + Sep + Markers[j].MarkerName;

                 if DoNumbers then
                 begin
                    inc(N);
                    S[S.Count-1] := S[S.Count-1] + Sep + IntTostr(N);
                 end;
             end;
         end;

         S.SaveToFile(Fdir + CorrectName(LoopsS[I])+'.txt');
       end;

       LoopsS.Free;
     End;

  S.Free;
end;

procedure SaveTXTMarkers(FileName:String; CS, Fmt:Integer;  Sep:String;
                  SaveH, SaveHGeo:Boolean; AskifExist:boolean);

var    csX, csY, csZ, csH :String;

  procedure BLToCS(B,L,H :double);
  var cX, cY, cZ: Double;
  begin
       csZ :='';
       csH :='';

       Geo1ForceToGeo2(B, L, H, WGS, CoordinateSystemList[CS].DatumN, B, L, H);

       DatumToCoordinateSystem(CS, B, L, H, cX, cY, cZ);

       case CoordinateSystemList[CS].ProjectionType of
          0:begin
             csX := DegToDMS(cX,true, Fmt, Fmt mod 2 = 0);
             csY := DegToDMS(cY,false,Fmt, Fmt mod 2 = 0);
             csH  := Format('%.3f',[cZ]);
          end;
          1:begin
            csX := Format('%.3f',[cX]);
            csY := Format('%.3f',[cY]);
            csZ := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH  := Format('%.3f',[cZ]);
          end;
       end;
  end;

var i, j :integer;
    S :TSTringList;
begin
  if CS = -1 then
     CS := WGS;

  if Length(Markers) = 0 then
     Exit;

  if Ansilowercase(Copy(FileName, Length(FileName)-3,4)) <> '.txt' then
     FileName := FileName + '.txt';

  if AskifExist then
     if Fileexists(FileName) then
     if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

  S := TStringList.Create;

  for I := 0 to Length(Markers) - 1 do
  begin
         if POS('!#', markers[I].MarkerName)=1 then
            continue;

         BLToCS(Markers[I].Gx, Markers[I].Gy,  Markers[I].H);
         S.Add(Markers[I].MarkerName + Sep + csX + Sep + csY );
         if csZ <> '' then
             S[S.Count-1] := S[S.Count-1] + Sep + csZ;
         if (csH <> '')and(SaveH) then
             S[S.Count-1] := S[S.Count-1] + Sep + csH;
         if (SaveHGeo) then
             S[S.Count-1] := S[S.Count-1] + Sep + Format('%.3f',[Markers[I].HGeo]);
  end;

  S.SaveToFile(FileName);
  S.Free;
end;


procedure RotateFrameOrder(Fwd:boolean);
var  i :integer;
begin
   case FWD of

     true: Begin
       for i := 0 to FrameCount -2 do
         FramePoints[i,2]:= FramePoints[i+1, 2];
       FramePoints[FrameCount-1, 2] := FramePoints[0, 2];
     End;

     false: Begin
       for i := FrameCount -1 downto 1 do
         FramePoints[i,2]:= FramePoints[i-1, 2];
       FramePoints[0, 2] := FramePoints[FrameCount-1, 2];
     End;

   end;

   RecomputeRoutes(WaitForZone);
   RefreshSelectionArrays;
end;

procedure ReverseFrame;
var P :TMy3DPoint;
    i :integer;
begin
   for i := 0 to (FrameCount-1) div 2 do
   Begin
      P := FramePoints[i,2];
      FramePoints[i,2]:= FramePoints[FrameCount-i-1, 2];
      FramePoints[FrameCount-i-1, 2] := P;
   End;
   RecomputeRoutes(WaitForZone);
   RefreshSelectionArrays;
end;




{
procedure SplitFrame(step, FirstDeg :Double; StartN:integer;  XShift :Double;
           ExtraEnd, DegIsDA, doAdd: boolean);
var i, j, n, Bani: integer;
    aPoints: Array of TMyPoint;
    BL : TLatLong;
    aMaxX, aMaxY, aMinY, aMinX, angle, angle0,  _x : Double;
    _y: array [1..2] of Double;

    oldRouteCount :Integer;
begin
 if FrameCount < 3 then
    exit;

  if step = 0 then
     exit;

 if FirstDeg<>0 then
    XShift :=0;

 if DegisDA then
     XShift :=0;

 SetLength(aPoints, FrameCount);

 angle0 := arctan2((FramePoints[1,1].X - FramePoints[0,1].X),
                   (FramePoints[1,1].Y - FramePoints[0,1].Y));

 angle := -angle0 + FirstDeg/180 * pi;

 if DegIsDa then
     angle := FirstDeg/180 * pi;

 if angle < 0 then
    angle := angle + 2*pi;

 if angle > 2*pi then
    angle := angle - 2*pi;

 for  i := 0 to Length(aPoints)-1 do
 Begin

   aPoints[i].X :=  FramePoints[i,1].X * cos(angle) +  FramePoints[i,1].Y * sin(angle);
   aPoints[i].Y := -FramePoints[i,1].X * sin(angle) +  FramePoints[i,1].Y * cos(angle);

   if i=0 then
    begin
      Aminx := aPoints[i].X;
      Aminy := aPoints[i].Y;
      Amaxx := aPoints[i].X;
      Amaxy := aPoints[i].Y;
    end
      else
      begin
        if aPoints[i].X < AminX then
          AminX := aPoints[i].X ;

        if aPoints[i].X > AmaxX then
          AmaxX := aPoints[i].X ;

        if aPoints[i].Y < Aminy then
          AminY := aPoints[i].Y ;

        if aPoints[i].Y > AmaxY then
          AmaxY := aPoints[i].Y ;
      end;
 End;
 oldRouteCount := 0;
 if doAdd then
    oldRouteCount := RouteCount;

 _x:= aMinX-step+0.1+XShift;

 n := OldRouteCount;
 BanI :=-1;
 Repeat
   _y[1] := 0;
   _y[2] := 0;

   if n > RouteMax-1 then
      n := RouteMax-1;

   for j:= 1 to 2 do
    for  i:= 0 to Length(aPoints)-2 do
       if ( (aPoints[i].X < aPoints[i+1].X) and (_x <= aPoints[i+1].X) and (_x >= aPoints[i].X) )
          or ((aPoints[i].X > aPoints[i+1].X) and (_x <= aPoints[i].X) and (_x >= aPoints[i+1].X) ) then
          Begin
             if j = 2 then
                if BanI = i then
                   continue;

             _y[j] := aPoints[i].Y + ((_x - aPoints[i].X)/(aPoints[i+1].X - aPoints[i].X))
                      * (aPoints[i+1].Y-aPoints[i].Y);
             if n>0 then
             case j of
               1: begin
                  Route[n-1].X1 :=   _X*cos(-angle) +  _y[j]*sin(-angle);
                  Route[n-1].Y1 := - _X*sin(-angle) +  _y[j]*cos(-angle);
               end;
               2: begin
                  Route[n-1].X2 :=   _X*cos(-angle) +  _y[j]*sin(-angle);
                  Route[n-1].Y2 := - _X*sin(-angle) +  _y[j]*cos(-angle);
               end;
             end;

             Route[n-1].Name := IntToStr(n+StartN);

             if j = 1 then
               BanI := i;
             break;
          End;

   _x := _x + step;
   inc(n);

 until _x >= AmaxX-0.1;

 RouteCount := n-1;

 if ExtraEnd then
 begin
   inc(RouteCount);
//   inc(n);

   _y[1] := -Route[n-2].X1 * sin(angle) + Route[n-2].Y1 * cos(angle) ;
   _y[2] := -Route[n-2].X2 * sin(angle) + Route[n-2].Y2 * cos(angle) ;

   Route[n-1].X1 :=  _X * cos(-angle) +  _y[1] * sin(-angle);
   Route[n-1].Y1 := -_X * sin(-angle) +  _y[1] * cos(-angle);

   Route[n-1].X2 :=   _X * cos(-angle) +  _y[2] * sin(-angle);
   Route[n-1].Y2 := - _X * sin(-angle) +  _y[2] * cos(-angle);

   Route[n-1].Name := IntToStr(n+StartN);
 end;

 if (FirstDeg = 0)and(XShift=0)and (not DegIsDA) then
 Begin

   // _x:= aMinX;

   Route[OldRouteCount].X1 := FramePoints[1,1].X ;
   Route[OldRouteCount].Y1 := FramePoints[1,1].Y ;

   Route[OldRouteCount].X2 := FramePoints[0,1].X ;
   Route[OldRouteCount].Y2 := FramePoints[0,1].Y ;

   SetLength(Route[OldRouteCount].GWPT,0);
   SetLength(Route[OldRouteCount].WPT,0);
 End;

 for I := OldRouteCount to RouteCount - 1 do
 Begin
   BL := MapToBL(Route[i].x1,Route[i].y1);
   Route[i].Gx1 := BL.lat;
   Route[i].Gy1 := BL.long;
   BL := MapToBL(Route[i].x2,Route[i].y2);
   Route[i].Gx2 := BL.lat;
   Route[i].Gy2 := BL.long;

   SetLength(Route[i].GWPT,2);
   Route[i].GWPT[0].x := Route[i].Gx1;
   Route[i].GWPT[0].y := Route[i].Gy1;
   Route[i].GWPT[1].x := Route[i].Gx2;
   Route[i].GWPT[1].y := Route[i].Gy2;

   Route[i].Fixed := false;
   Route[i].Status := 0;
 End;
 AddRoutes := False;      

End;         }

procedure SplitFrame(step, FirstDeg :Double; StartN:integer;  XShift :Double;
           ExtraEnd, DegIsDA, doAdd, doFixD: boolean);
const
    XsMax = 128;
var
    FPoints: Array[0..FrameMax] of TMyPoint;
    xmin, ymin, xmax, ymax :Double;
    Xs: Array[0..XsMax-1] of Double; XsCount:Integer;

  procedure FindMinMax;
  var I:Integer;
  begin
    for I := 0 to FrameCount - 1 do
    begin
      if I = 0 then
      begin
         xmin := FPoints[I].x; xmax := xmin;
         ymin := FPoints[I].y; ymax := ymin;
      end
      else
        begin
           if FPoints[I].x < xmin then
             xmin := FPoints[I].x;
           if FPoints[I].y < ymin then
             ymin := FPoints[I].y;
           if FPoints[I].x > xmax then
             xmax := FPoints[I].x;
           if FPoints[I].y > ymax then
             ymax := FPoints[I].y;
        end;
    end;
  end;

  procedure GetXs(Yi:Double);
  var I:Integer;
    Ximin, Ximax, Yimin, Yimax, c:Double;
  begin
    XsCount := 0;
    for I := 1 to FrameCount - 1 do
    Begin

      Ximin := FPoints[I-1].x;
      Yimin := FPoints[I-1].y;

      Ximax := FPoints[I].x;
      Yimax := FPoints[I].y;
      
      if Yimin > Yimax then
      begin
        c := Yimax;  Yimax := Yimin; Yimin := c;
        c := Ximax;  Ximax := Ximin; Ximin := c;
      end;

      if (Yi >= Yimin) and (Yi <= Yimax) then
      begin
        c := 0;
        if Yimax <> Yimin then
           c := (Yi - Yimin) / (Yimax - Yimin);

        Xs[XsCount] := Ximin + c*(Ximax - Ximin);
        inc(XsCount);

        if (Yi = Yimin) or (Yi = Yimax) then
        begin
           // ?????? ???, ??? ?????????? ????????
            Xs[XsCount] := Ximin + c*(Ximax - Ximin);
            inc(XsCount);
        end;

        if XsCount >= XsMax -1  then
           exit;
      end;

    End;
  end;

  procedure SortXs;
  var I, j, jmin :Integer;   Xc, Xjmin:Double;
  begin
     for I := 0 to XsCount - 1 do
     begin
       Xjmin := Xs[I];  jmin := I;
       for j := I to XsCount - 1 do
         if Xs[j] < Xjmin then
         begin
           Xjmin := Xs[j];
           jmin := j;
         end;
        if jmin = I then
          continue;

        xc :=  Xs[I];
        Xs[I] := Xs[jmin];
        Xs[jmin] := xc;
     end;
  end;

  procedure ReverseXs;
  var I :Integer;   _x :Double;
  begin
    for I := 0 to trunc((XsCount-1)/ 2) do
    begin
	     _x := Xs[I];
		   Xs[I] := Xs[XsCount-1 - I];
		   Xs[XsCount-1 -I] := _x;
    end;
  end;

  function FisClockWise:boolean;
  var I: Integer;
      sum, dx, dy :Double;
  begin
    sum := 0;

    for I := 0 to FrameCount - 1 do
    begin
      if I < FrameCount -1 then
      begin
        dx := FPoints[I+1].x - FPoints[I].x;
        dy := FPoints[I+1].y + FPoints[I].y;
      end
      else
        begin
          dx := FPoints[0].x - FPoints[I].x;
          dy := FPoints[0].y + FPoints[I].y;
        end;
      sum := sum + dx * dy;
    end;
    result := sum > 0;
  end;


  procedure ReverseF;
  var Tmp : TMyPoint;  I:Integer;
  begin
    for I := 0 to trunc((FrameCount-1)/ 2) do
    begin
	     Tmp := FPoints[I];
		   FPoints[I] := FPoints[FrameCount-1 - I];
		   FPoints[FrameCount-1 - I] := Tmp;
    end;
  end;

var i, j, k, XCount :integer;
    x0, y0, a0, startX, startY, endX, EndY, Yi, Xi, newX, newY :Double;
    angle, angle0 : Double;

    RowI :Integer;
    RW :boolean;
begin
 // 0) INIT
 if FrameCount < 3 then
    exit;
 if step = 0 then
     exit;

 if DegIsDa then
    FirstDeg := 270 - FirstDeg;
 while FirstDeg < 0 do
    FirstDeg := FirstDeg + 360;
 while FirstDeg > 360 do
    FirstDeg := FirstDeg - 360;


 if (FirstDeg <> 0) or (DegisDA) then
    XShift := 0;
 if (FirstDeg = 0) and (XShift = 0) then
    XShift := 0.00001;

 if DegIsDa then
   angle := FirstDeg/180 * pi
 else
 begin
   angle0 := arctan2((FramePoints[1,1].Y - FramePoints[0,1].Y),
                   (FramePoints[1,1].X - FramePoints[0,1].X));
   angle := -angle0 + FirstDeg/180 * pi;
 end;

 if angle < 0 then
   angle := angle + 2*pi;
 if angle > 2*pi then
   angle := angle - 2*pi;

 if not DoAdd then
    RouteCount := 0;

 for I := 0 to FrameCount - 1 do
  begin
    FPoints[I].x := FramePoints[I,1].x;
    FPoints[I].y := FramePoints[I,1].y;
  end;

  // 1) Shift
  FindMinMax;
  X0 := xmin;  Y0 := ymin;
  for I := 0 to FrameCount - 1 do
  begin
    FPoints[I].x := FPoints[I].x - X0;
    FPoints[I].y := FPoints[I].y - Y0;
  end;

  // 2) Rotate
  for I := 0 to FrameCount - 1 do
  begin
    Xi := FPoints[I].x;     Yi := FPoints[I].y;
    FPoints[I].x := Xi*Cos(angle) - Yi*Sin(angle) ;
    FPoints[I].y := Yi*Cos(angle) + Xi*Sin(angle);
  end;

  RW := not FisClockWise;

  // 3) FindNewMin
  FindMinMax;
  StartX := xMin;
  EndX   := xMax;
  StartY := yMin;
  EndY   := yMax;

  // 4) Lets go!
  if RW then
    Yi := StartY + XShift
  else
    Yi := EndY - XShift;

  RowI := 0;
  repeat
    // 4a) curentRow is Yi
    GetXs(Yi);  SortXs;
    Inc(RowI);

    if DoFixD then
      if RowI mod 2 = 0 then
       ReverseXs;

    k := 1;
    for I := 0 to XsCount div 2 -1 do
    begin
       if abs(Xs[i*2] - Xs[i*2+1]) < 0.01 then   /// ??????? ?????
       begin
          if i = XsCount div 2 -1 then
            if k = 1 then   /// ?? ?????? ?? ?????????
              dec(RowI);

          continue;
       end;

       

       if XsCount > 3 then
         AddRoute(IntTostr(RowI + StartN)+'_'+intToStr(k))
       else
         AddRoute(IntTostr(RowI + StartN));
       inc(k);

       with Route[RouteCount -1] do
       begin
         x1 :=  Xs[i*2] *Cos(angle) + Yi *Sin(angle) + X0;
         y1 := -Xs[i*2] *Sin(angle) + Yi *Cos(angle) + Y0;
         x2 :=  Xs[i*2+1] *Cos(angle) + Yi *Sin(angle) + X0;
         y2 := -Xs[i*2+1] *Sin(angle) + Yi *Cos(angle) + Y0;
         SetLength(WPT, 2);
         SetLength(GWPT, 2);
         WPT[0] := MyPoint(x1, y1);
         WPT[1] := MyPoint(x2, y2);
       end;
    end;

    if RW then
      Yi := Yi + Step
    else
      Yi := Yi - Step;

  until ((Yi < StartY)and(not RW)) or ( (Yi > EndY) and (RW));

  if ExtraEnd then
  Begin
    inc(RowI);

    if DoFixD then
      //if RowI mod 2 = 0 then
       ReverseXs;

    for I := 0 to XsCount div 2 -1 do
    begin
       if XsCount > 3 then
         AddRoute(IntTostr(RowI + StartN)+'_'+intToStr(I+1))
       else
         AddRoute(IntTostr(RowI + StartN));

       with Route[RouteCount -1] do
       begin
         x1 :=  Xs[i*2] *Cos(angle) + Yi *Sin(angle) + X0;
         y1 := -Xs[i*2] *Sin(angle) + Yi *Cos(angle) + Y0;
         x2 :=  Xs[i*2+1] *Cos(angle) + Yi *Sin(angle) + X0;
         y2 := -Xs[i*2+1] *Sin(angle) + Yi *Cos(angle) + Y0;
         SetLength(WPT, 2);
         SetLength(GWPT, 2);
         WPT[0] := MyPoint(x1, y1);
         WPT[1] := MyPoint(x2, y2);
       end;

    end;
  End;
  RoutesToGeo;
  RecomputeRoutes(false);
end;


procedure FrameLeadSide(Col:Cardinal);
var  P1, P2 :TMyPoint;
begin
  if FrameCount>3 then
  Begin
       P1 := MapToScreen(FramePoints[0,1].x, FramePoints[0,1].y);
       P2 := MapToScreen(FramePoints[1,1].x, FramePoints[1,1].y);

       FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 3, false, true, Col);
  End;
end;

procedure ExpandShortRoutes(MinL: real; N:integer);
var i, j, WPCount :integer;
    dx, dy : real;
    newl, l: real;
    I1, I2:Integer;
begin
  if N <=-1 then
  begin
    I1 := 0;
    I2 := RouteCount - 1;
  end
    else
    begin
       I1 := N;
       I2 := N;
    end;

  For I := I1 To I2 Do
  Begin
     if length(Route[i].WPT) > 1 then
     begin
        l := 0;
        WPCount := length(Route[i].WPT)-1;
        for J := 1 to WPCount do
          l := l + Sqrt(Sqr(Route[i].WPT[J].x - Route[i].WPT[J-1].x)
                        + Sqr(Route[i].WPT[J].y - Route[i].WPT[J-1].y));
        if l < MinL then
        begin
          
          newl := (MinL - l)/2;
         
          if l = 0 then
             continue;

          /// ???????? ??????

          l := Sqrt(Sqr(Route[i].WPT[1].x - Route[i].WPT[0].x)
                        + Sqr(Route[i].WPT[1].y - Route[i].WPT[0].y));

          dx := (Route[i].WPT[1].x - Route[i].WPT[0].x)/l;
          dy := (Route[i].WPT[1].y - Route[i].WPT[0].y)/l;

          Route[i].WPT[0].x := Route[i].WPT[0].x - dx*newl;
          Route[i].WPT[0].y := Route[i].WPT[0].y - dy*newl;

          /// ???????? ?????

          l := Sqrt(Sqr(Route[i].WPT[WPCount - 1].x - Route[i].WPT[WPCount].x)
                        + Sqr(Route[i].WPT[WPCount - 1].y - Route[i].WPT[WPCount].y));

          dx := (Route[i].WPT[WPCount - 1].x - Route[i].WPT[WPCount].x)/l;
          dy := (Route[i].WPT[WPCount - 1].y - Route[i].WPT[WPCount].y)/l;

          Route[i].WPT[WPCount].x := Route[i].WPT[WPCount].x - dx*newl;
          Route[i].WPT[WPCount].y := Route[i].WPT[WPCount].y - dy*newl;
        end;
     end;
  End;
  RoutesToGeo;
  RecomputeRoutes(WaitForZone);
end;

procedure DrawFrameLabels(FntColor, MenuColor:Cardinal; DrawAll:Boolean;
          Lstyle:integer);

  procedure LabelOut(P :TMyPoint; w: Integer; str : string);
  begin
    if str = '' then
       exit;

    if lstyle = 1 then
       AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w+1,trunc(P.y)+1{-trunc(dy)}),
                                        str ,cRGB2(255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255,
                                                   255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255));

    if lstyle = 2 then
        AsphCanvas.FillRect(Rect (trunc(P.X - w) -2,
                                  trunc(P.Y) - 2,
                                  trunc(P.X + w) +2,
                                  trunc(P.Y) + 14 ), cColor4(MenuColor) );

    AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y){-trunc(dy)}),
                                        str ,cColor2(FntColor));


  end;

const AMax = 256;

var i, j, w, dy :Integer;

    P :TMyPoint;

    canLabel: Boolean;
    A: array [1..AMax] of TMyPoint;
    Asize : array [1..AMax] of Integer;
    ACount : integer;
    col : TColor2;

    str: string;
begin
 if Framecount < 2 then
   exit;

 Acount :=0;

 for I := 0 to FrameCount - 2 do
 begin
    P := MapToScreen(FramePoints[i,1].x,FramePoints[i,1].y);

    if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
             (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;



    w := round(AsphFonts[Font0].TextWidth( intTostr(i+1))/2);


       canlabel := true;
       if not drawAll then
       for J := 1 to ACount do
          if (P.y > A[j].Y - 32)and(P.y < A[j].Y + 64) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;

       if not canlabel then
            continue;

       if Acount < AMax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;

       dy := 0;// 16;

       if CanLabel then
       Begin
        Col := cColor2(FntColor);
        AsphFonts[Font0].Scale := 1;
        if Length(SelectedFramePoints) > I then
         if SelectedFramePoints[I] then
         Begin
            Col[1] := $FFF0F000;
            Col[0] := $FFFFFFFF;

            AsphFonts[Font0].TextOut(Point2(trunc(P.x+1)-w,trunc(P.y+1)-trunc(dy)),
                                        intTostr(i+1),clBlack2);
         End;

         str := '['+IntToStr(I+1)+']';

         LabelOut(P, w, str);
        // AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
        //                                intTostr(i+1),col);


       End;

   End;

end;


procedure GetCuttingPoints(RouteN:Integer; InfCut :boolean);

var I, J, I0, I1, CutN :integer;
    Int: TIntercection;
begin

  if (CutPoints[1].x = CutPoints[2].x)and
         (CutPoints[1].y = CutPoints[2].y) then
            exit;

  SetLength(RouteCutPoints, 0);

  if RouteN >= 0 then
  begin
    I0 := RouteN;
    I1 := RouteN;
  end
   else
   Begin
     I0 := 0;
     I1 := RouteCount - 1;
   End;
  

  for I := I0 to I1 do
  begin
    CutN := 1;
    for J := 1 to length(Route[I].WPT) - 1 do
    begin
      Int := GetLinesIntercection(CutPoints[1].x, CutPoints[1].y,
                                  CutPoints[2].x, CutPoints[2].y,
                                  Route[I].WPT[J-1].x, Route[I].WPT[J-1].y,
                                  Route[I].WPT[J].x, Route[I].WPT[J].y);
      if Int.isExist then
         if (int.c2 > 0) then
           if (int.c2 < 1) or
              (J < length(Route[I].WPT) - 1) and (int.c2 = 1) then
                 if (infCut) or ( (InfCut = false) and (int.c1 > 0) and (int.c1 < 1) ) then
           Begin
              SetLength(RouteCutPoints, Length(RouteCutPoints)+1);
              RouteCutPoints[Length(RouteCutPoints)-1].x := Int.x;
              RouteCutPoints[Length(RouteCutPoints)-1].y := Int.y;
              RouteCutPoints[Length(RouteCutPoints)-1].RouteN := I;
              RouteCutPoints[Length(RouteCutPoints)-1].SegmentN := J;
              RouteCutPoints[Length(RouteCutPoints)-1].CutN := CutN;
              inc(CutN);
           End;

    end;


  end;

end;

procedure CutRoutes;
var I, J, OldCount, Seg:integer;
    TmpR1, TmpR2 :TRoute;
begin
  if (CutPoints[1].x = CutPoints[2].x)and
         (CutPoints[1].y = CutPoints[2].y) then
            exit;

  OldCount := RouteCount;

  J := RouteCount + Length(RouteCutPoints);
  if J < RouteMax then
      RouteCount := J
         else
           exit;

  For I := Length(RouteCutPoints) - 1 DownTo 0 Do
  Begin
     Seg := RouteCutPoints[I].SegmentN;

     TmpR1 := Route[RouteCutPoints[I].RouteN];
     TmpR2 := Route[RouteCutPoints[I].RouteN];
     TmpR2.Name := TmpR2.Name + '('+intToStr(RouteCutPoints[I].CutN+1)+')';

     SetLength(TmpR1.WPT, Seg + 1);
     TmpR1.WPT[Seg].x :=  RouteCutPoints[I].x;
     TmpR1.WPT[Seg].y :=  RouteCutPoints[I].y;

     for J := Seg - 1 to Length(TmpR2.WPT) - 1 do
       TmpR2.WPT[J - Seg + 1]:= TmpR2.WPT[J];

     TmpR2.WPT[0].x := RouteCutPoints[I].x;
     TmpR2.WPT[0].y := RouteCutPoints[I].y;

     J := Length(TmpR2.WPT) - RouteCutPoints[I].SegmentN + 1;
     SetLength(TmpR2.WPT, J);

     Route[RouteCutPoints[I].RouteN] := TmpR1;
     Route[OldCount + I] := TmpR2;
  End;

  RoutesToGeo;
  RecomputeRoutes(WaitForZone);

  for I := 0 to RouteCount - 1 do
    for J := 0 to RouteCount - 1 do
       if (I<>J) and (Route[I].Name = Route[J].Name) then
             Route[J].Name := Route[J].Name + '_';
end;

procedure CollapseRoutes(R1, R2: Integer);

  function GetL(P1, P2: TMyPoint): real;
  begin
    Result := Sqrt(Sqr(P2.x - p1.x)+Sqr(P2.y-p1.y));
  end;

var I, J,  I1, I2, StI : integer;
    P : array [1..4] of TMyPoint;
    Lmin :real;
begin
  if R1 > R2 then
  begin
    I := R2;    R2 := R1;    R1 := I;
  end;

  P[1] := Route[R1].WPT[0];
  P[2] := Route[R1].WPT[length(Route[R1].WPT)-1];
  P[3] := Route[R2].WPT[0];
  P[4] := Route[R2].WPT[length(Route[R2].WPT)-1];

  Lmin := GetL(P[1], P[3]);
  I1 := 1; I2 := 3;

  for I := 1 to 2 do
    for J := 3 to 4 do
        if GetL(P[I], P[J]) < Lmin then
        Begin
          I1 := I;
          I2 := J;
          Lmin := GetL(P[I], P[J]);
        End;

  if I1 = 1 then
    if not Route[R1].Fixed then
       RewerseRoute(R1);

  if I2 = 4 then
    if not Route[R2].Fixed then
       RewerseRoute(R2);

  RoutesToGeo;
  RecomputeRoutes(WaitForZone);

  StI := length(Route[R1].WPT);

  SetLength(Route[R1].WPT, length(Route[R1].WPT) + length(Route[R2].WPT));

  If (Route[R1].WPT[StI-1].x = Route[R2].WPT[0].x) and
     (Route[R1].WPT[StI-1].y = Route[R2].WPT[0].y) then
    begin
       Dec(StI);
       Setlength(Route[R1].WPT, length(Route[R1].WPT)-1);
    end;

  for I := StI to Length(Route[R1].WPT) - 1 do
      Route[R1].WPT[I] := Route[R2].WPT[I - StI];

  Route[R1].Name := Route[R1].Name + ' + ' +  Route[R2].Name;

  Dec(RouteCount);
  for I := R2 to RouteCount - 1 do
     Route[I] := Route[I+1];

  RoutesToGeo;
  RecomputeRoutes(WaitForZone);
end;

procedure DrawCuttingPlane(FntColor:Cardinal; Smooth: Boolean; InfCut :boolean);

   procedure DrawPts(x, y: Double; Col:Cardinal);
   begin
     If (x > 0) And (y > 0) And (X < DispSize.X) And (y < DispSize.y) Then
     Begin
       AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8, 8));
       AsphCanvas.TexMap(pRotate4c(Point2(x,y),Point2(10, 10), 0), cColor4(Col));
     End;
   end;

   procedure DrawPts2(x, y: Double);
   begin
     If (x > 0) And (y > 0) And (X < DispSize.X) And (y < DispSize.y) Then
     Begin
       AsphCanvas.UseImagePx(AsphImages.Image['ed_cur5.image'], pxBounds4(0, 0, 16, 16));
       AsphCanvas.TexMap(pRotate4c(Point2(x,y),Point2(12, 12), 0), clWhite4);
     End;
   end;

const CutCol: Cardinal = $FFFF0000;

var k, b : real;
    P1, P2 : TMyPoint;
    I : integer;
begin

  if CutMode >= 0 then
  begin
    P1 := MapToScreen(CutPoints[1].x,CutPoints[1].y);
    DrawPts(P1.x, P1.y, CutCol);
  end;

  if CutMode > 0 then
  Begin
     P2 := MapToScreen(CutPoints[2].x,CutPoints[2].y);
     DrawPts(P2.x, P2.y, CutCol);

     if (CutPoints[1].x = CutPoints[2].x)and
         (CutPoints[1].y = CutPoints[2].y) then
            exit;

     myLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, false, smooth, CutCol);


     if InfCut then
     Begin

        if (P1.y = P2.y) then
          MyLine(AsphCanvas, 0, P1.y, DispSize.X, P1.y, true, smooth, CutCol)
        else
        if (P1.x = P2.x) then
            MyLine(AsphCanvas, P1.x, 0, P1.x, DispSize.Y, true, smooth, CutCol)
         else
         begin

            k := ((P2.y - P1.y)/(P2.x - P1.x));

            b := - k*P1.x + P1.y;

            P1.x := 0;
            P1.y := b;

            P2.x := DispSize.x;
            P2.y := k*P2.x + b;

            MyLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, true, smooth, $FFFF0000);
         end;
     End;
  End;


  if CutMode >= 0 then
    for I := 0 to Length(RouteCutPoints) - 1 do
    if (I = SelectedRouteN) or (SelectedRouteN = -1) then
    begin
      P1 := MapToScreen(RouteCutPoints[I].x,RouteCutPoints[I].y);
      DrawPts2(P1.x, P1.y);
    end;


end;


procedure AddKnotPoints(RouteN: Integer; Step, Radius, Angle: Double;
   AddAngle:Boolean; NameKind:Byte; RNumber:Integer; ShiftL: Double;
      DoContinue:Boolean;
      PMethod:Integer; Lx, Ly, Lmax: Double;
      NameKind1, NameKind2, StepOut :Byte;
      DropToRoute, AllL :Boolean);
var
  I, SegN :Integer;
  CStep, SegL, SegA :Double;
  CurL, FullL       :Double;
  X1, Y1, X2, Y2    :Double;
  NewX, NewY, c     :Double;
  DopL :Double;

  procedure AddPoint(x, y :Double; N :Integer);
  var J: Integer;
  begin
    J := Length(KnotPoints);
    SetLength(KnotPoints, J+1);

    KnotPoints[J].Cx := x;
    KnotPoints[J].Cy := y;
    if AddAngle then
      KnotPoints[J].BoxAngle := SegA + Angle*pi/180
      else
        KnotPoints[J].BoxAngle :=  Angle*pi/180;

    KnotPoints[J].BoxSize := Radius;         KnotPoints[J].BoxSize2 := Radius;
    KnotPoints[J].NameKind := NameKind;
    case NameKind of
      0,2,3,4: KnotPoints[J].Name := Route[RouteN].Name;   {21-07-21}
      //2,3,4: KnotPoints[J].Name := '';
      1: begin
         KnotPoints[J].Name := 'Pr'+ FormatFloat('000', RNumber);
         KnotPoints[J].NameKind := 0;
      end;
    end;

    if AllL then
    begin
      KnotPoints[J].L := LCounter;
      Inc(LCounter);
    end
    else
      KnotPoints[J].L := N;

    KnotPoints[J].NameKind2 := NameKind2;
    KnotPoints[J].RouteAngle := SegA;
    KnotPoints[J].PMethod := PMethod;
    KnotPoints[J].Lx := Lx;
    KnotPoints[J].Ly := Ly;
    KnotPoints[J].Lmax := Lmax;
    KnotPoints[J].StepOut := StepOut;
    KnotPoints[J].DropToRoute := DropToRoute;
    KnotPoints[J].RouteN := RouteN;
    KnotPoints[J].Shp := 0;
    KnotPoints[J].ShStep := 0;
  end;

  procedure GetSegL;
  begin
     SegL := sqrt( Sqr(X2 - X1) + Sqr(Y2 - Y1));
  end;

  procedure NextSeg;
  var cont:boolean;
  begin
    cont := false;
    case DoContinue of
      false : inc(SegN);
      true  : if SegN < Length(Route[RouteN].WPT) - 1  then
                 inc(SegN)
                   else
                    cont := true;
    end;


    if SegN > Length(Route[RouteN].WPT) - 1  then
      SegL := -1
      else
        begin
           X1 := Route[RouteN].WPT[SegN-1].x;
           Y1 := Route[RouteN].WPT[SegN-1].y;
           X2 := Route[RouteN].WPT[SegN].x;
           Y2 := Route[RouteN].WPT[SegN].y;

           GetSegL;
           SegA := 0;

           if SegL > 0 then
             SegA := arcTan2(X2 - X1, Y2 - Y1);

           if cont then
           begin
             //DopL := DopL - (CurL-FullL);
             //if DopL < 0 then
               // exit;

             X1 := X2;
             Y1 := Y2;
           // X2 := 2*X2 - Route[RouteN].WPT[SegN-1].x;
           //  Y2 := 2*Y2 - Route[RouteN].WPT[SegN-1].y;

             X2 := X2 + DopL*(X2 - Route[RouteN].WPT[SegN-1].x)/SegL;
             Y2 := Y2 + DopL*(Y2 - Route[RouteN].WPT[SegN-1].y)/SegL;

              FullL := FullL + DopL;
              DopL := 0;
              cont := false;
              DoContinue := false;
              GetSegL;

           end;
        end;
  end;

  procedure GetFullL;
  var J :integer;
  begin
     FullL := 0;
     for J := 1 to Length(Route[RouteN].WPT) - 1 do
     begin
       FullL := FullL + sqrt(
                Sqr(Route[RouteN].WPT[J].x - Route[RouteN].WPT[J-1].x) +
                Sqr(Route[RouteN].WPT[J].y - Route[RouteN].WPT[J-1].y));
     end;
  end;

var AddedFirst :Boolean; N: Integer;
var StepI:Double;
begin
  AddedFirst := false;

  if Length(KnotPoints) >= MaxKnots then
     exit;

  if Length(Route[RouteN].WPT)<= 1 then
    exit;

  GetFullL;

  N := 0;

  CurL  := 0;   CStep := 0;    SegL  := 0;   SegN  := 0;  DopL := 0;

  if DoContinue then
    DopL := Step;
  repeat
     if not AddedFirst then
       StepI := ShiftL
     else
       StepI := Step;

     CurL  := CurL  + StepI;
     cStep := cStep + StepI;

     while (SegL <= cStep) or (SegL = 0) do
     begin
       cStep := cStep - SegL;

       NextSeg;

       if SegL < 0 then
          break;
     end;

     if SegL < 0 then
        break;

     c := cStep / SegL;
     NewX := X1 + c*(X2 - X1);
     NewY := Y1 + c*(Y2 - Y1);

     if not AddedFirst then
     begin
     (*   if ShiftL = 0 then
           AddPoint(Route[RouteN].X1, Route[RouteN].Y1, 0);
           //KnotPoints[Length(KnotPoints)-1].BoxSize := 0;    *)
        AddedFirst := true;
     end;

     inc(N);
     AddPoint(NewX, NewY, N);

     X1 := NewX;  Y1 := NewY;
     GetSegL;
     cStep := 0;

     if Length(KnotPoints) >= MaxKnots then
         break;

  until CurL > FullL+DopL;

end;

procedure DoKnots(RN: Integer; Step, Radius, Angle: Double;
   AddAngle:Boolean; NameKind:Byte; FromN:Integer; ShiftL: Double;
      DoContinue:Boolean;
      PMethod:Integer; StartA, dA, Lx, Ly, Lmax: Double;
      NameKind1, NameKind2, StepOut :Byte;
      DropToRoute :Boolean; AllL:Boolean; LFrom:Integer; Chess:Byte);
var I :Integer;
    ShiftL2, Delta :Double; PD:TRoutePosAndDist;
begin
  if Step = 0 then
     exit;

  SetLength(KnotPoints, KnotCount);
  LCounter := LFrom;

  if RN >= 0 then
     AddKnotPoints(RN, Step, Radius, Angle, AddAngle, NameKind, FromN, ShiftL,
      DoContinue, PMethod, Lx, Ly, Lmax, NameKind1, NameKind2, StepOut,
      DropToRoute, AllL)
  else
  if RN = -1 then
    for I := 0 to RouteCount - 1 do
    Begin

       ShiftL2 := ShiftL;

       if (I > 0) and (Chess > 0) then
       begin
         if chess = 2 then
         case I mod 2 of
           0: Delta := 0
           else
              Delta := Step/2;
         end;
         PD := PosAndDistToRoute(Route[0].WPT[0].x, Route[0].WPT[0].y, I);
         ShiftL2 := PD.DistToV0 - trunc( (PD.DistToV0 - Delta)/Step )*Step
                     + ShiftL+Delta;

         if ShiftL2 < ShiftL then
            ShiftL2 :=   ShiftL2 + Step;
       end;

       AddKnotPoints(I, Step, Radius, Angle, AddAngle, NameKind, FromN + I,
       ShiftL2, DoContinue, PMethod, Lx, Ly, Lmax, NameKind1, NameKind2, StepOut,
      DropToRoute, AllL);
    End;
end;

procedure DoAreaKnots(isChess: Byte; StepX, StepY, StepA, Radius, Angle: Double;
      AddAngle:Boolean; NameKind:Byte; FromN:Integer; ShiftL: Double;
      PMethod:Integer; StartA, dA, Lx, Ly, Lmax: Double;
      NameKind1, NameKind2, StepOut :Byte; StepOutX, StepOutY :Double;
      DropToRoute :Boolean; RNames:String; FromSouth:Boolean;
      AllL:Boolean; LFrom:Integer);

const
    XsMax = 8;
var
    FPoints: Array[0..FrameMax] of TMyPoint;
    xmin, ymin, xmax, ymax :Double;
    Xs: Array[0..XsMax-1] of Double; XsCount:Integer;

procedure FindMinMax;
var I:Integer;
begin
  for I := 0 to FrameCount - 1 do
  begin
    if I = 0 then
    begin
     xmin := FPoints[I].x; xmax := xmin;
     ymin := FPoints[I].y; ymax := ymin;
    end
    else
     begin
       if FPoints[I].x < xmin then
         xmin := FPoints[I].x;
       if FPoints[I].y < ymin then
         ymin := FPoints[I].y;
       if FPoints[I].x > xmax then
         xmax := FPoints[I].x;
       if FPoints[I].y > ymax then
         ymax := FPoints[I].y;
     end;
  end;
end;

  procedure GetXs(Yi:Double);
  var I:Integer;
    Ximin, Ximax, Yimin, Yimax, c:Double;
  begin
    XsCount := 0;
    for I := 1 to FrameCount - 1 do
    Begin
      {if I = 0 then
      begin
        Ximin := FPoints[FrameCount-1].x;
        Yimin := FPoints[FrameCount-1].y;
      end
      else
      begin
          Ximin := FPoints[I-1].x;
          Yimin := FPoints[I-1].y;
      end; }
      Ximin := FPoints[I-1].x;
      Yimin := FPoints[I-1].y;

      Ximax := FPoints[I].x;
      Yimax := FPoints[I].y;
      
      {if Ximin > Ximax then
      begin
        c := Ximax;  Ximax := Ximin; Ximin := c;
      end; }
      if Yimin > Yimax then
      begin
        c := Yimax;  Yimax := Yimin; Yimin := c;
        c := Ximax;  Ximax := Ximin; Ximin := c;
      end;

      if (Yi >= Yimin) and (Yi <= Yimax) then
      begin
        c := 0;
        if Yimax <> Yimin then
           c := (Yi - Yimin) / (Yimax - Yimin);

        Xs[XsCount] := Ximin + c*(Ximax - Ximin);
        inc(XsCount);

        if (Yi = Yimin) or (Yi = Yimax) then
        begin
           // ?????? ???, ??? ?????????? ????????
            Xs[XsCount] := Ximin + c*(Ximax - Ximin);
            inc(XsCount);
        end;

        if XsCount >= XsMax -1  then
           exit;
      end;

    End;
  end;

  procedure SortXs;
  var I, j, jmin :Integer;   Xc, Xjmin:Double;
  begin
     for I := 0 to XsCount - 1 do
     begin
       Xjmin := Xs[I];  jmin := I;
       for j := I to XsCount - 1 do
         if Xs[j] < Xjmin then
         begin
           Xjmin := Xs[j];
           jmin := j;
         end;
        if jmin = I then
          continue;

        xc :=  Xs[I];
        Xs[I] := Xs[jmin];
        Xs[jmin] := xc;
     end;
  end;

  procedure AddPoint(x, y :Double; Col, Row:Integer);
  var J: Integer;
  begin
    J := Length(KnotPoints);
    if J >= MaxKnots then
      exit;

    SetLength(KnotPoints, J+1);

    KnotPoints[J].Shp := 0;
    KnotPoints[J].ShStep := 0;

    KnotPoints[J].Cx := x;
    KnotPoints[J].Cy := y;
    if AddAngle then
      KnotPoints[J].BoxAngle := StepA+pi/2 + Angle*pi/180
      else
        KnotPoints[J].BoxAngle :=  Angle*pi/180;

    KnotPoints[J].BoxSize := Radius;   KnotPoints[J].BoxSize2 := Radius;
    KnotPoints[J].NameKind := NameKind;
    case NameKind of
      0,2,3,4: KnotPoints[J].Name := RNames+ FormatFloat('000', Row);    {21-07-21}
     // 2,3,4 : KnotPoints[J].Name := '';         
      1: begin
         KnotPoints[J].Name := 'Pr'+ FormatFloat('000', Row + FromN-1);
         KnotPoints[J].NameKind := 0;
      end;
    end;

    if AllL then
    begin
      KnotPoints[J].L := LCounter;
      Inc(LCounter);
    end
    else
      KnotPoints[J].L := Col;

    KnotPoints[J].NameKind2 := NameKind2;
    KnotPoints[J].RouteAngle := StepA+pi/2;
    KnotPoints[J].PMethod := PMethod;
    KnotPoints[J].Lx := Lx;
    KnotPoints[J].Ly := Ly;
    KnotPoints[J].Lmax := Lmax;
    KnotPoints[J].StepOut := StepOut;
    KnotPoints[J].DropToRoute := DropToRoute;
    KnotPoints[J].RouteN := -1;
  end;

var I, j, Xcount, RowI, ColI :Integer;
    x0, y0, a0, startX, startY, endX, EndY, Yi, Xi, newX, newY :Double;
    NewKnotsI :Integer;
    ChessI, inArea:Boolean;
    newName :String;
    P:TLatLong; /// ??????
begin

  if (StepX = 0) or (StepY = 0) then
     exit;

  SetLength(KnotPoints, KnotCount);
  NewKnotsI := KnotCount;
  LCounter := LFrom;
   
  if (StepX < minStep ) or (stepY < minStep) then
    exit;

  if FrameCount < 3 then
    exit;

  for I := 0 to FrameCount - 1 do
  begin
    FPoints[I].x := FramePoints[I,1].x;
    FPoints[I].y := FramePoints[I,1].y;
  end;

  // 1) Shift
  FindMinMax;
  x0 := xmin;  y0 := ymin;
  for I := 0 to FrameCount - 1 do
  begin
    FPoints[I].x := FPoints[I].x - x0;
    FPoints[I].y := FPoints[I].y - y0;
  end;

  // 2) Rotate
  for I := 0 to FrameCount - 1 do
  begin
    Xi := FPoints[I].x; Yi := FPoints[I].y;
    FPoints[I].x := Xi*Cos(StepA) - Yi*Sin(StepA) ;
    FPoints[I].y := Yi*Cos(StepA) + Xi*Sin(StepA);
  end;

  // StepOuts
  StepOutY := StepOutY - trunc(1+StepOutY/StepY)*StepY;
  StepOutX := StepOutX - trunc(1+StepOutX/StepX)*StepX;

  // 3) FindNewMin
  FindMinMax;
  StartX := xMin + StepOutX;
  EndX   := xMax + abs(StepOutX*2);
  StartY := yMin - abs(StepOutY*2);
  EndY   := yMax + StepOutY;
  if FromSouth then
  begin
    StartY := yMin + StepOutY;
    EndY   := yMax + abs(StepOutY*2);
  end;

  if isChess = 1 then
    EndX   := EndX + StepX;

  XCount := trunc((EndX - StartX)/StepX) + 1;

  // 4) Lets go!
  if FromSouth then
    Yi := StartY
  else
    Yi := EndY;

  chessI := False;
  RowI := 0;
  repeat
    // 4a) curentRow is Yi
    GetXs(Yi);  SortXs;
    Inc(RowI);  ColI := 0;
    for I := 0 to XCount do
    begin
      Xi := StartX + I*StepX;
      if ChessI then
        Xi := Xi - StepX/2;

      inArea := false;
      for j := 0 to XsCount - 2 do
        if (Xi >= Xs[j]) and (Xi <= Xs[j+1]) then
        begin
          inArea := not( (j+1) mod 2 = 0);
          break;
        end;

      if inArea then
      begin
        Inc(ColI);
        NewName := RNames + FormatFloat('000', RowI);
        NewX :=  Xi *Cos(StepA) + Yi *Sin(StepA)   + X0;
        NewY :=  -Xi *Sin(StepA) + Yi *Cos(StepA)  + Y0;
        AddPoint(Newx, Newy, ColI, RowI);
      end;
    end;

    if FromSouth then
      Yi := Yi + StepY
    else
      Yi := Yi - StepY;

    if isChess = 1 then
      ChessI := not ChessI;
  until ((Yi > endY) and (FromSouth)) or ((not FromSouth) and (Yi < StartY));



//  AddAreaKnotPoints(I, Step, Radius, Angle, AddAngle, NameKind, FromN + I,
//  ShiftL, DoContinue, PMethod, Lx, Ly, Lmax, NameKind1, NameKind2, StepOut,
//  DropToRoute);
end;


procedure AddOrt(RouteN: Integer; Do1:Boolean; StepOut, Step, Ls, Rs : Double;
      FromN:Integer; Name, NameSep:String);
var
  I, SegN :Integer;
  CStep, SegL, SegA :Double;
  CurL, FullL       :Double;
  X1, Y1, X2, Y2    :Double;
  NewX, NewY, c     :Double;

  procedure AddRt(x, y :Double; N :Integer);
  var J: Integer;
      L: TlatLong;
  begin
 	  AddRoute(Name + NameSep + IntToStr(N+FromN-1));
	  J := RouteCount -1;

	  SetLength(Route[J].WPT,2);
    SetLength(Route[J].GWPT,2);

    Route[J].x1 := x + sin(Sega - pi/2)*Ls;
    Route[J].y1 := y + cos(Sega - pi/2)*Ls;
    L := MapToBL(Route[J].x1, Route[J].y1);
	  Route[J].Gx1 := L.lat;
    Route[J].Gy1 := L.long;

	  Route[J].x2 := x + sin(Sega + pi/2)*Rs;
    Route[J].y2 := y + cos(Sega + pi/2)*Rs;
   	L := MapToBL(Route[J].x2, Route[J].y2);
	  Route[J].Gx2 := L.lat;
    Route[J].Gy2 := L.long;

    Route[J].WPT[0].x := Route[J].x1;      Route[J].WPT[0].y := Route[J].y1;
    Route[J].WPT[1].x := Route[J].x2;      Route[J].WPT[1].y := Route[J].y2;
    Route[J].GWPT[0].x := Route[J].Gx1;    Route[J].GWPT[0].y := Route[J].Gy1;
    Route[J].GWPT[1].x := Route[J].Gx2;    Route[J].GWPT[1].y := Route[J].Gy2;
  end;

  procedure GetSegL;
  begin
     SegL := sqrt( Sqr(X2 - X1) + Sqr(Y2 - Y1));
  end;

  procedure NextSeg;
  begin
   
    inc(SegN);

    if SegN > Length(Route[RouteN].WPT) - 1  then
      SegL := -1
      else
        begin
           X1 := Route[RouteN].WPT[SegN-1].x;
           Y1 := Route[RouteN].WPT[SegN-1].y;
           X2 := Route[RouteN].WPT[SegN].x;
           Y2 := Route[RouteN].WPT[SegN].y;

           GetSegL;
           SegA := 0;

           if SegL > 0 then
             SegA := arcTan2(X2 - X1, Y2 - Y1);
        end;
  end;

  procedure GetFullL;
  var J :integer;
  begin
     FullL := 0;
     for J := 1 to Length(Route[RouteN].WPT) - 1 do
     begin
       FullL := FullL + sqrt(
                Sqr(Route[RouteN].WPT[J].x - Route[RouteN].WPT[J-1].x) +
                Sqr(Route[RouteN].WPT[J].y - Route[RouteN].WPT[J-1].y));
     end;
  end;

var AddedFirst :Boolean; N: Integer;
var StepI:Double;
begin
  AddedFirst := false;

  if Length(Route[RouteN].WPT)<= 1 then
    exit;

  GetFullL;

  N := 0;
  CurL  := 0;   CStep := 0;    SegL  := 0;   SegN  := 0; 

  repeat
     if not AddedFirst then
     begin
       StepI := StepOut;
       AddedFirst := true;
     end
     else
       StepI := Step;

     CurL  := CurL  + StepI;
     cStep := cStep + StepI;

     while (SegL <= cStep) or (SegL = 0) do
     begin
       cStep := cStep - SegL;

       NextSeg;

       if SegL < 0 then
          break;
     end;

     if SegL < 0 then
        break;

     c := cStep / SegL;
     NewX := X1 + c*(X2 - X1);
     NewY := Y1 + c*(Y2 - Y1);

     inc(N);
     AddRt(NewX, NewY, N);


     X1 := NewX;  Y1 := NewY;
     GetSegL;
     cStep := 0;

     if Do1 then
       break;

  until CurL > FullL;

  RecomputeRoutes(False);
end;



procedure OrthoRoutes(RN: Integer; Do1:Boolean; StepOut, Step, Ls, Rs : Double;
      FromN:Integer; Name, NameSep:String);
var I :Integer;
begin
  RecomputeRoutes(False);
  if RN >= 0 then
     AddOrt(RN, Do1, StepOut, Step, Ls, Rs,
      FromN, Name, NameSep)
  else
  if RN = -1 then
    for I := 0 to RouteCount - 1 do
       AddOrt(I, Do1, StepOut, Step, Ls, Rs,
          FromN, Route[I].Name + NameSep + Name, NameSep);
end;

function SaveKnots(FileName:String; AskifExist:boolean):boolean;
var I, j, k:Integer;
    S:TStringList;
    prf : string;
    L:TLatLong; HasT: boolean;
begin
  result := false;
  HasT := false;
  KillNewKnots;
  if Length(KnotPoints) = 0 then exit;

  if  Length(FileName)< 4 then
    FileName := FileName +  '.rnk'
  else
  if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))<> '.rnk'  then
    FileName  := FileName +  '.rnk';

  if AskifExist then
  if FileExists(FileName) then
  if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;


  S:= TStringList.Create;
  for I := 0 to Length(KnotPoints) - 1 do
  begin
    L := MapToBL(KnotPoints[I].cx, KnotPoints[I].cy);

    j := 0;
    if KnotPoints[I].DropToRoute then
      j := 1;
    
    prf := KnotPoints[I].Name;
    if prf = '' then
       prf := '*#empty_string*#';

    S.Add(prf + #$9 + IntToStr(KnotPoints[I].NameKind) + #$9 +
          FloatToStr(L.lat) + #$9 + FloatToStr(L.long) + #$9 +
          FloatToStr(KnotPoints[I].BoxSize) + #$9 +
          FloatToStr(KnotPoints[I].BoxAngle)  + #$9 +

          IntToStr(KnotPoints[I].RouteN)  + #$9 +
          FloatToStr(KnotPoints[I].RouteAngle)  + #$9 +
          IntToStr(j) + #$9 +

          IntToStr(KnotPoints[I].Pmethod) + #$9 +
          IntToStr(KnotPoints[I].NameKind2) + #$9 +

          FloatToStr(KnotPoints[I].Lmax)  + #$9 +
          FloatToStr(KnotPoints[I].Lx)    + #$9 +
          FloatToStr(KnotPoints[I].Ly)    + #$9 +
          IntToStr(KnotPoints[I].StepOut) + #$9 +
          IntToStr(KnotPoints[I].L)  + #$9 +
          IntToStr(KnotPoints[I].Shp)  + #$9 +
          FloatToStr(KnotPoints[I].ShStep) + #$9 +
          FloatToStr(KnotPoints[I].BoxSize2)
          );

  end;

  for I := 0 to EdPktsCount(EdPicketsFileName,0) do
  begin
     for j := 0 to Length(KnotPoints) - 1 do
       if KnotPoints[j].PMethod = 4 then
       if KnotPoints[j].StepOut = I then
       Begin
         S.Add('\\');
         S.Add(IntToStr(I)+'#'+LoadEpPkts(EdPicketsFileName,I,0));
         for k := 0 to EdPicketsCount - 1 do
         begin
           S.Add(FloatTostr(EdPickets[k].x));
           S.Add(FloatTostr(EdPickets[k].y));
         end;
         HasT := true;
         break;
       End;
  end;

  if HasT then
    S.Add('\\');

  S.SaveToFile(FileName);
  result := true;
  S.Free;
end;


function EdPktsCount(FN: String; StartFrom: Integer):integer;
var S: TstringList;
    I, j :Integer;
    new :Boolean;
begin
  S := TstringList.Create;

  try
    S.LoadFromFile(FN);
    result := 0;
    I := StartFrom;
    new:= true;
    if S.Count > 0 then
    repeat
      if New then
      begin
        inc(result);
        inc(I);
        New := false;
      end;

      if S[I]= '\\' then
         New := true;

      inc(I);
    until I >= S.Count-3;

  except
  end;


  S.Destroy;
end;

function LoadEpPkts(FN: String; N, StartFrom: Integer):string;
var S: TstringList;
    I, j, I1 :Integer;
    new :Boolean;
begin
  S := TstringList.Create;
  result := '';
  try
    S.LoadFromFile(FN);

    if S.Count > 0 then
    BEGIN

    I := 0;  I1 := StartFrom;
    j := 0;
    EdPicketsCount := 0;
    new:= true;

    if N > 0 then
    for I := StartFrom to S.Count - 1 do
       if S[I]= '\\' then
       begin
         inc(j);
         if j = N then
         begin
           I1 := I+1;
           break;
         end;
       end;

    result := S[I1];
    I := I1+1;
    repeat
      if S[I]= '\\' then
         break;

      if EdPicketsCount < MaxPkt then
      begin
        inc(EdPicketsCount);
        EdPickets[EdPicketsCount-1].x := StrToFloat2(S[I]);
        EdPickets[EdPicketsCount-1].y := 0;
        if I+1 < S.Count-1 then
        EdPickets[EdPicketsCount-1].y := StrToFloat2(S[I+1]);
        I := I + 2;
      end
        else break;

    until (I>= S.Count-1) or (S[I]='\\');

    END;
  except
  end;
  S.Destroy;
end;

procedure SaveEdPkts(FN:String; N:Integer; Name:String);
var S: TstringList;
    I, j, I1, I2 :Integer;
    new :Boolean;
begin
  S := TstringList.Create;

  try
    S.LoadFromFile(FN);
    S.SaveToFile(Copy(FN,1, Length(FN)-4)+'_backup.loc');

    I := 0;  I1 := 0;
    j := 0;

    new:= true;

 if N <= EdPktsCount(FN, 0)-1 then
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
    until (I>= S.Count-1) or (S[I]='\\');

    for I := I2 Downto I1 do
      S.Delete(I);

 end else
   begin
     I1 := S.Count;
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
  S.SaveToFile(FN);
  S.Destroy;
end;

function ComparePkts(F1: String; N1, FromI1:Integer;
                     F2: String; N2, FromI2:Integer):boolean;
var
  EdPickets2 :Array [0..MaxPkt-1] of TMyPoint;
  EdPicketsCount2, I :Integer;
begin
  result := true;

  LoadEpPkts(F2, N2, FromI2);
  EdPicketsCount2 := EdPicketsCount;

  for I := 0 to EdPicketsCount2 - 1 do
  begin
    EdPickets2[I].x := EdPickets[I].x;
    EdPickets2[I].y := EdPickets[I].y;
  end;

  LoadEpPkts(F1, N1, FromI1);

  if EdPicketsCount2 <> EdPicketsCount then
  begin
    result := false;
    exit;
  end else

  for I := 0 to EdPicketsCount do
   if (Abs(EdPickets2[I].x - EdPickets[I].x) > 0.001) or
      (Abs(EdPickets2[I].y - EdPickets[I].y) > 0.001) then
      begin
        result := false;
        break;
      end;
end;

procedure LoadKnots(FileName:String; DoAdd:Boolean);
var I, j:Integer;  S:TStringList; XY: TMyPoint;

    ContainsT :boolean;  NewName :string;
    Ti, I2, OldN, NewN, NewTCount, OldTCount :Integer;
begin
  if fileexists(FileName) = false then
      exit;

  KillNewKnots;

  if DoAdd then
    j := Length(KnotPoints)
  else
    j := 0;

  ContainsT := false;
  S:= TStringList.Create;
  S.LoadFromFile(FileName);

  SetLength(KnotPoints, j + S.Count);

  for I := 0 to S.Count - 1 do
  try
    if S[I] = '' then
    begin
      SetLength(KnotPoints, Length(KnotPoints)-1);
      continue;
    end;

    if S[I] = '\\' then
    begin
      SetLength(KnotPoints, I+j);
      ContainsT := true;
      Ti := I+1;
      break;
    end;

    KnotPoints[I+j].Name     := GetCols(S[I], 0, 1, #$9, true);
    KnotPoints[I+j].NameKind := trunc(StrToFloat2(GetCols(S[I], 1, 1, #$9, true)));

    XY.x := StrToFloat2(GetCols(S[I], 2, 1, #$9, true));
    XY.y := StrToFloat2(GetCols(S[I], 3, 1, #$9, true));

    if WaitForZone then
      MyZone := UTMZonebyPoint(XY.x, XY.y);

    XY := BLToMap(XY.x, XY.y);

    KnotPoints[I+j].Cx := XY.x;   KnotPoints[I+j].Cy := XY.y;

    KnotPoints[I+j].BoxSize  := StrToFloat2(GetCols(S[I], 4, 1, #$9, true));
    KnotPoints[I+j].BoxAngle := StrToFloat2(GetCols(S[I], 5, 1, #$9, true));

    KnotPoints[I+j].RouteN := trunc(StrToFloat2(GetCols(S[I], 6, 1, #$9, true)));
    KnotPoints[I+j].RouteAngle := StrToFloat2(GetCols(S[I], 7, 1, #$9, true));
    KnotPoints[I+j].DropToRoute := 1 = StrToFloat2(GetCols(S[I], 8, 1, #$9, true));

    KnotPoints[I+j].Pmethod   := trunc(StrToFloat2(GetCols(S[I], 9, 1, #$9, true)));
    KnotPoints[I+j].NameKind2 := trunc(StrToFloat2(GetCols(S[I],10, 1, #$9, true)));

    KnotPoints[I+j].Lmax := StrToFloat2(GetCols(S[I], 11, 1, #$9, true));
    KnotPoints[I+j].Lx   := StrToFloat2(GetCols(S[I], 12, 1, #$9, true));
    KnotPoints[I+j].Ly   := StrToFloat2(GetCols(S[I], 13, 1, #$9, true));

    KnotPoints[I+j].StepOut := trunc(StrToFloat2(GetCols(S[I],14, 1, #$9, true)));
    KnotPoints[I+j].L       := trunc(StrToFloat2(GetCols(S[I],15, 1, #$9, true)));

    KnotPoints[I+j].Shp     := trunc(StrToFloat2(GetCols(S[I],16, 1, #$9, true)));
    KnotPoints[I+j].ShStep  :=  StrToFloat2(GetCols(S[I],17, 1, #$9, true));
    KnotPoints[I+j].BoxSize2  := StrToFloat2(GetCols(S[I], 18, 1, #$9, true));

    if KnotPoints[I+j].Name = '*#empty_string*#' then
       KnotPoints[I+j].Name := '';

  except
  end;
  KnotCount := Length(KnotPoints);


  if ContainsT then
  begin
    OldTCount := EdPktsCount(EdPicketsFileName, 0);
    NewTCount := EdPktsCount(FileName, Ti);

    for I := 0 to NewTCount-1 do
    begin
      NewName := LoadEpPkts(FileName, I, Ti);
      I2 := Pos('#', NewName);

      OldN := 0;
      if I2 > 0 then
      begin
        OldN := Trunc(StrToFLoat2(Copy(NewName, 0, I2)));
        NewName := Copy(NewName, I2+1, Length(NewName)-I2);
      end
       else continue;

      // defining newN
      NewN := OldTCount;
      for I2 := 0 to OldTCount - 1 do
        if ComparePkts(FileName, I, Ti, EdPicketsFileName, I2, 0)  then
        begin
          NewN := I2;
          break;
        end;

      if NewN = OldTCount then
      begin
        SaveEdPkts(EdPicketsFileName, NewN, NewName);
        Inc(OldTCount);
      end;

      // refresh loops with the template
      for I2 := j to Length(KnotPoints) - 1 do
        if KnotPoints[I2].PMethod = 4 then
          if KnotPoints[I2].StepOut = OldN then
             KnotPoints[I2].StepOut := NewN;

    end;

  end;

  S.Free;
end;

function FindRouteSeg(P:TMyPoint; I:Integer; var x0, y0:Double):Integer;

var J, i1, i2:integer;
    Lmin, L : real;
    PD: TPosAndDist;
begin

 Lmin := -1;          Result:= -2; {Found NOTHING}

 if (I < 0) or (I > RouteCount-1) then
  exit;
 
 try
  for J := 0 to length(Route[I].WPT) - 1 do
  Begin
      if J < length(Route[I].WPT) - 1 then
         PD := GetPosAndDist(Route[I].WPT[J].x,   Route[I].WPT[J].y,
                             Route[I].WPT[J+1].x, Route[I].WPT[J+1].y,
                             P.x, P.y);

      if ( ((Lmin=-1)or(PD.Dist < Lmin)) and (PD.Pos >= 0) and (PD.Pos <= 1) ) then
      begin                            {????? ?? ??????? + ???. ?????????}
         if J < length(Route[I].WPT) - 1 then
         begin /// Test for lines
           Lmin := PD.Dist;    Result := J;
           x0 := PD.x;         y0 := PD.y;
         end;
      end
        else
        begin
          /// Test for points
          L :=  Sqrt(sqr(Route[I].WPT[J].x-P.x)+sqr(Route[I].WPT[J].y-P.y));
          if ((L < Lmin)or(Lmin = -1)) then
          begin
             Lmin := L;  Result := J;
             x0 := Route[I].WPT[J].x; y0 := Route[I].WPT[J].y;
             if (J = length(Route[I].WPT) - 1) or (J = 0) then
             begin
                 x0 := PD.x; y0 := PD.y;
             end;

          end;
        end;
   End;
 except
 end;

end;

procedure KnotToRoute(Knot :TKnot);
var I, j, Seg, cnt, n :integer;
    PD:TPosAndDist;
    P:TMyPoint;  nm:string;
    Ang, CurL, SL, x0, y0: Double;
Begin
  with Knot do
  begin
    case NameKind of
      0,1: nm := Name + '_L' + FormatFloat('000', L);
      2: nm := 'L'+FormatFloat('000', L);
      3, 4: nm := FormatFloat('000', L);
    end;


    Seg := FindRouteSeg(PointXY(Knot.Cx, Knot.Cy), Knot.RouteN, P.x, P.y);
    if Seg = -2 then
    begin
      PktCount := 0;
      exit;
    end;

    cnt := trunc(Lmax / Lx);

    x0 := P.x;
    y0 := P.y;
    if Ly = 0 then
      PktCount := cnt*2 +1
    else
      PktCount := cnt+1;

    if Seg = -1 then
    begin
       Ang := arctan2(Route[Knot.RouteN].WPT[1].x -
                     Route[Knot.RouteN].WPT[0].x,
                     Route[Knot.RouteN].WPT[1].y -
                     Route[Knot.RouteN].WPT[0].y);

    end
      else
      if Seg = length(Route[Knot.RouteN].WPT) - 1 then
      begin
        Ang := arctan2(Route[Knot.RouteN].WPT[Seg].x -
                     Route[Knot.RouteN].WPT[Seg-1].x,
                     Route[Knot.RouteN].WPT[Seg].y -
                     Route[Knot.RouteN].WPT[Seg-1].y);
      end
        else
        begin
           Ang := arctan2(Route[Knot.RouteN].WPT[Seg+1].x -
                     Route[Knot.RouteN].WPT[Seg].x,
                     Route[Knot.RouteN].WPT[Seg+1].y -
                     Route[Knot.RouteN].WPT[Seg].y);
        end;

    RouteAngle := Ang;

    {??????? ?????}

    for I := 0 to cnt*2 do
    begin
       //Pkt[I].x := (I - cnt)*Lx * sin(RouteAngle);
       //Pkt[I].y := (I - cnt)*Lx * cos(RouteAngle);

       if Ly = 0 then
       begin
          Pkt[I].x := (I - cnt)*Lx * sin(RouteAngle);
          Pkt[I].y := (I - cnt)*Lx * cos(RouteAngle);
       end
       else
       begin
          Pkt[I].x := (I)*Lx * sin(RouteAngle);
          Pkt[I].y := (I)*Lx * cos(RouteAngle);
       end;

       FindRouteSeg(PointXY(x0 + Pkt[I].x, y0 + Pkt[I].y),
                    RouteN, P.x, P.y);

       Pkt[I].x := P.x - Cx;
       Pkt[I].y := P.y - Cy;

       case NameKind  of
          0..2: Pkt[I].Name := Nm + '_pkt'+FormatFloat('00', I+1);
          3: Pkt[I].Name := Nm + '_P'+FormatFloat('00', I+1);
          4: Pkt[I].Name := Nm + '_'+FormatFloat('00', I+1);
       end;

    end;


  end;

End;

procedure LoadCurrentLT(N:Integer);
var S: TstringList;
    I, j, I1 :Integer;
    new :Boolean;
begin
  if CurrentLT_N = N then
    exit;
  S := TstringList.Create;

  try
    S.LoadFromFile(MapDataDir+'Loops.loc');

    if S.Count > 0 then
    BEGIN

    I := 0;  I1 := 0;
    j := 0;
    CurrentLT_Count := 0;
    new:= true;

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

    I := I1+1;
    repeat
      if S[I]= '\\' then
         break;

      if CurrentLT_Count < MaxPkt then
      begin
        inc(CurrentLT_Count);
        CurrentLT[CurrentLT_Count-1].x := StrToFloat2(S[I]);
        CurrentLT[CurrentLT_Count-1].y := 0;
        if I+1 < S.Count-1 then
        CurrentLT[CurrentLT_Count-1].y := StrToFloat2(S[I+1]);
        I := I + 2;
      end
        else break;

    until (I>= S.Count-1) or (S[I]='\\');

    END;
  except
  end;

  S.Destroy;
end;

procedure GetKnotPickets(Knot :TKnot; TestOnly :Boolean);
var I, j, cnt, ci, cj, n, k, li :integer;
    A: Double;
    nm: string;
    P :TMyPoint;
begin

with Knot do
begin
  PktCount := 0;

  case NameKind of
      0,1: nm := Name + '_L' + FormatFloat('000', L);
      2: nm := 'L'+FormatFloat('000', L);
      3,4: nm := FormatFloat('000', L);
  end;

  case Pmethod of
    0: begin
      // 1) ??????, ??????? ???? ????? ?????

      if Lx = 0 then
          exit;

      cnt := trunc(Lmax / Lx);
      if cnt > MaxPkt / 2  -1 then
          exit;

      if Ly = 0 then
        PktCount := cnt*2+1
      else
         PktCount := cnt+1;
     // 2) ?????? ?? ??????????
      if (DropToRoute) and (RouteN < RouteCount) and (TestOnly = false) then
        KnotToRoute(Knot)
        else
          for I := 0 to cnt*2 do
          begin
            if Ly = 0 then
            begin
              Pkt[I].x := (I - cnt)*Lx * sin(RouteAngle);
              Pkt[I].y := (I - cnt)*Lx * cos(RouteAngle);
            end
            else
            begin
              Pkt[I].x := (I)*Lx * sin(RouteAngle);
              Pkt[I].y := (I)*Lx * cos(RouteAngle);
            end;
            ///Pkt[I].Name := Nm + '_pkt'+IntToStr(I+1);
             case NameKind  of
               0..2: Pkt[I].Name := Nm + '_pkt'+FormatFloat('00', I+1);
               3: Pkt[I].Name := Nm + '_P'+FormatFloat('00', I+1);
               4: Pkt[I].Name := Nm + '_'+FormatFloat('00', I+1);
             end;
          end;


    end;
    1: begin
      if (Lx = 0) or (Ly = 0) then
          exit;

      ci := trunc(Lmax / Lx);
      cj := trunc(Lmax / Ly);

      if (DropToRoute) then
         A := RouteAngle + pi/2
      else
         A := BoxAngle;


      cnt :=  (cI*2 +1) * (cj*2 +1);

      if cnt > MaxPkt -1 then
          exit;

      PktCount := cnt;
      for I := -ci to ci do
      for j := -cj to cj do
      begin
         n := (I+ci)*(2*cj+1)+(j+cj);
         Pkt[n].y := I*Lx *sin(pi/2 -A)
                   + j*Ly *sin(pi/2 -A + pi/2);
         Pkt[n].x := I*Lx *cos(pi/2 -A)
                   + j*Ly *cos(pi/2 -A + pi/2);


         case NameKind  of
           0..2:  Pkt[n].Name:= Nm + '_pkt';
           3: Pkt[n].Name := Nm + '_P';
           4: Pkt[n].Name := Nm + '_';
         end;

         case NameKind2 of
           0: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', n+1);
           1: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', I+ci+1)
                                         + FormatFloat('00',j+cj+1);
           2: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', I+ci+1) +'-'
                                         + FormatFloat('00',j+cj+1);
         end;

      end;

    end;
    2: begin
       if (Lx = 0) or (Ly = 0) then
          exit;

       ci := trunc(180/Ly);
       cj := trunc(Lmax / Lx);

       case DropToRoute of
         true:  A := RouteAngle + pi/2;
         false: A := BoxAngle;
       end;

       k := 0;

       cnt := (cI) * (cj*2) +1;

       if cnt > MaxPkt -1 then
          exit;

       PktCount := cnt ;
       for I := 0 to ci-1 do
       for j := -cj to cj do
       begin
         if I > 0 then
           if j = 0 then
           begin
             dec(k);
             continue;
           end;
         li := 0;
         if (I > 0)and(j > 0) then
           li := 1;

         n := (I)*(2*cj+1)+(j+cj +k);

         if n > cnt{MaxPkt-1} then
              showmessage(inttostr(n));

         Pkt[n].y := j*Lx *sin({pi/2}-A + I*Ly*pi/180);
         Pkt[n].x := j*Lx *cos({pi/2}-A + I*Ly*pi/180);

         case NameKind  of
           0..2:  Pkt[n].Name:= Nm + '_pkt';
           3: Pkt[n].Name := Nm + '_P';
           4: Pkt[n].Name := Nm + '_';
         end;
         {case NameKind2 of
           0: Pkt[n].Name := Pkt[n].Name +IntToStr(n+1);
           1: Pkt[n].Name := Pkt[n].Name + IntToStr(I+1) + IntToStr(j+cj+1-li);
           2: Pkt[n].Name := Pkt[n].Name + IntToStr(I+1) + '-' + IntToStr(j+cj+1-li);
         end;  }
         case NameKind2 of
           0: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', n+1);
           1: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', I+1)
                                         + FormatFloat('00',j +cj+1-li);
           2: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', I+1) +'-'
                                         + FormatFloat('00',j+cj+1-li);
         end;
      end;

    end;
    3: begin
       ci := trunc(Lmax / Lx);
       cnt := ci*2 + 1;

       if StepOut = 0 then
          exit;

       cj := trunc(ci / StepOut);
       li := trunc(Lmax / Ly) ;
       cnt := cnt + (cj*2+1)* li * 2;

       if cnt > MaxPkt -1 then
          exit;

       n:= -1;
       PktCount := cnt ;
       for I := -ci to ci do
       begin

         if i mod StepOut = 0 then
           k := li
         else
           k := 0;

         for j := -k to k do
         begin
           inc(n);

           Pkt[n].y := I*Lx *sin( - RouteAngle + pi/2)
                     + j*Ly *sin( - RouteAngle + pi);
           Pkt[n].x := I*Lx *cos( - RouteAngle + pi/2)
                     + j*Ly *cos( - RouteAngle + pi);


           case NameKind  of
             0..2:  Pkt[n].Name:= Nm + '_pkt';
             3: Pkt[n].Name := Nm + '_P';
             4: Pkt[n].Name := Nm + '_';
           end;
           {case NameKind2 of
              0: Pkt[n].Name := Pkt[n].Name +IntToStr(n+1);
              1: Pkt[n].Name := Pkt[n].Name +IntToStr(I+ci+1)+IntToStr(j+k+1);
              2: Pkt[n].Name := Pkt[n].Name +IntToStr(I+ci+1)+'-'+IntToStr(j+k+1);
           end; }
           case NameKind2 of
             0: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', n+1);
             1: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', I+ci+1)
                                         + FormatFloat('00',j+k+1);
             2: Pkt[n].Name := Pkt[n].Name + FormatFloat('00', I+ci+1) +'-'
                                         + FormatFloat('00',j+k+1);
           end;

         end;

       end;

      end;

      4: begin

        LoadCurrentLT(StepOut);

        if (DropToRoute) then
          A :=  RouteAngle + Ly*pi/180
        else
          A := BoxAngle + Ly*pi/180;

        PktCount := CurrentLT_Count;
        for I := 0 to CurrentLT_Count-1 do
        begin
         n := I ;
         Pkt[n].y := CurrentLT[I].x* Lx/100 *sin(pi/2-A)
                   + CurrentLT[I].y* Lx/100 *cos(pi/2-A);

         Pkt[n].x := CurrentLT[I].x* Lx/100 *cos(pi/2-A)
                   - CurrentLT[I].y* Lx/100 *sin(pi/2-A);

         //Pkt[n].Name := Nm + '_pkt'+IntToStr(n+1);
          case NameKind  of
           0..2:  Pkt[n].Name:= Nm + '_pkt'+FormatFloat('00',n+1);
           3: Pkt[n].Name := Nm + '_P'+FormatFloat('00',n+1);
           4: Pkt[n].Name := Nm + '_'+FormatFloat('00',n+1);
          end;
        end;

    end;
  end;

end;


end;

procedure KnotsToMarkers(doPickets, doCorners, doCenters :Boolean);
var I, j, CurI:Integer;
    BL :TLatLong;    str, str2 :string;
    x, y, Ang_max, a:Double;
begin
  CurI := Length(Markers);
  if DoCenters then
    SetLength(Markers, Length(Markers) + KnotCount);


  if DoCorners then
  begin
    j := 0;
    for I := 0 to KnotCount- 1 do
      case KnotPoints[I].Shp of
       1: begin
         Ang_max := (2*pi*KnotPoints[I].BoxSize) / KnotPoints[I].ShStep;
         if (Ang_max <= 1000) and (Ang_max >= 5) then
            j := j + trunc(Ang_Max)+1;
       end;
       else j := j+4
      end;

          

    SetLength(Markers, Length(Markers) + j);
  end;
    
  if DoPickets then
  begin
    j := 0;
    for I := 0 to KnotCount - 1 do
    begin
      GetKnotPickets(KnotPoints[I], false);
      j := j + PktCount;
    end;

    SetLength(Markers, Length(Markers) + j);
  end;

  for I := 0 to KnotCount - 1 do
  BEGIN

    // 1) Centers
    if DoCenters then
    begin
      case KnotPoints[I].NameKind of
       0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
       2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
       3,4 : str := FormatFloat('000', KnotPoints[I].L);
      end;

      Markers[CurI].MarkerName := str;
      Markers[CurI].MarkerKind := 1;
      BL := MapToBL(KnotPoints[I].cx, KnotPoints[I].cy);
      Markers[CurI].x := KnotPoints[I].cx;
      Markers[CurI].y := KnotPoints[I].cy;
      Markers[CurI].Gx := Bl.lat;
      Markers[CurI].Gy := Bl.long;
      inc(CurI);
    end;

    // 2) Pickets
    if DoPickets then
    begin
       GetKnotPickets(KnotPoints[I], false);
       for j := 0 to PktCount - 1 do
       begin
          Markers[CurI].MarkerName := Pkt[j].Name;
          Markers[CurI].MarkerKind := 3;
          BL := MapToBL(KnotPoints[I].cx + Pkt[j].x, KnotPoints[I].cy + Pkt[j].y);
          Markers[CurI].x := KnotPoints[I].cx + Pkt[j].x;
          Markers[CurI].y := KnotPoints[I].cy + Pkt[j].y;
          Markers[CurI].Gx := Bl.lat;
          Markers[CurI].Gy := Bl.long;
          inc(CurI);
       end;
    end;

  // 3) Corners
    if DoCorners then
    Begin
      if KnotPoints[I].Shp = 1 then
      begin

          Ang_max := (2*pi*KnotPoints[I].BoxSize) / KnotPoints[I].ShStep;
          if (Ang_max <= 1000) and (Ang_max >= 5) then
          for j := 0 to trunc(Ang_max) do
          begin

             case KnotPoints[I].NameKind of
                0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
                2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
                3,4 : str := FormatFloat('000', KnotPoints[I].L);
             end;
             str2 := str + '_K' + IntToStr(j+1);
             Markers[CurI].MarkerName := str2;

                x := KnotPoints[I].cx +
                     Sin(KnotPoints[I].BoxAngle + j*(2*pi/Ang_max))
                     *KnotPoints[I].BoxSize;
                y := KnotPoints[I].cy +
                     Cos(KnotPoints[I].BoxAngle + j*(2*pi/Ang_max))
                     *KnotPoints[I].BoxSize;
              {  x := KnotPoints[I].cx +
            Sin(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;      }

            { x := P.x + Sin(-KnotPoints[I].BoxAngle + j*pi/2 + pi/4 - fi)*Sqrt(2)
              *KnotPoints[I].BoxSize/2/scale;
          y := P.y + Cos(-KnotPoints[I].BoxAngle + j*pi/2 + pi/4 - fi)*Sqrt(2)
              *KnotPoints[I].BoxSize/2/scale;}
                BL := MapToBL(x, y);
                Markers[CurI].MarkerKind := 2;
                Markers[CurI].x := x;
                Markers[CurI].y := y;
                Markers[CurI].Gx := Bl.lat;
                Markers[CurI].Gy := Bl.long;
                inc(CurI);
          end;

      end else
      for j := 1 to 4 do
      begin
       case KnotPoints[I].NameKind of
          0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
          2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
          3,4 : str := FormatFloat('000', KnotPoints[I].L);
       end;
       str2 := str + '_K' + IntToStr(j);
       Markers[CurI].MarkerName := str2;

       if KnotPoints[I].Shp = 2 then
       begin
          a := j * pi/2;
          case j mod 2 = 0 of
            true:  a := a + arctan2(KnotPoints[I].BoxSize, KnotPoints[I].BoxSize2);
            false: a := a + arctan2(KnotPoints[I].BoxSize2, KnotPoints[I].BoxSize);
          end;

          x := KnotPoints[I].cx +
              Sin(KnotPoints[I].BoxAngle - a)
              *Sqrt( sqr(KnotPoints[I].BoxSize/2) + sqr(KnotPoints[I].BoxSize2/2));
          y := KnotPoints[I].cy +
              Cos(KnotPoints[I].BoxAngle - a)
              *Sqrt( sqr(KnotPoints[I].BoxSize/2) + sqr(KnotPoints[I].BoxSize2/2));
       end
         else
         begin
          x := KnotPoints[I].cx +
              Sin(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
              *KnotPoints[I].BoxSize/2;
          y := KnotPoints[I].cy +
              Cos(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
              *KnotPoints[I].BoxSize/2;
         end;

       BL := MapToBL(x, y);
       Markers[CurI].MarkerKind := 2;
       Markers[CurI].x := x;
       Markers[CurI].y := y;
       Markers[CurI].Gx := Bl.lat;
       Markers[CurI].Gy := Bl.long;
       inc(CurI);
      end;
    End;

  END;

end;

procedure KillNewKnots;
begin
  SetLength(KnotPoints, KnotCount);
end;

procedure RenumberKnots(RMethod: Byte; isAll: Boolean;
      AddL, StepL:Integer; DoSort:Boolean);

var KnotNums: Array of Integer;
    I :Integer;

  procedure SortByL;
  var i, j, k :integer;
  begin
    for I := 0 to Length(KnotNums) - 1  do
      for j := I+1 to Length(KnotNums) - 1 do
         if KnotPoints[KnotNums[I]].L > KnotPoints[KnotNums[j]].L  then
         begin
            k := KnotNums[I];
            KnotNums[I] := KnotNums[j];
            KnotNums[j] := k;
         end;
  end;

begin

  case isAll of
     false:
     begin
       SetLength(KnotNums, Length(SelectedKnots));
       for I  := 0 to Length(SelectedKnots) - 1 do
          KnotNums[I] := SelectedKnots[I];
     end;

     true:
     begin
       SetLength(KnotNums, KnotCount);
       for I  := 0 to KnotCount - 1 do
          KnotNums[I] := I;
     end;
  end;

  case RMethod of
     0: for I  := 0 to Length(KnotNums) - 1 do
       KnotPoints[KnotNums[I]].L :=  KnotPoints[KnotNums[I]].L + AddL;

     1:
     begin
       if DoSort then SortByL;
       for I  := 0 to Length(KnotNums) - 1 do
         KnotPoints[KnotNums[I]].L :=  AddL + StepL*I;
     end;
  end;

end;

procedure DrawRoutesEd(AsphCanvas: TAsphyreCanvas; EdMode: integer;
      ChoosedColor, RoutesColor, DoneColor, FrameColor, FntColor,
      MenuColor, HiddenColor :Cardinal; Smooth: Boolean;
      RouteN:integer; DrawAll:Boolean; Lstyle: Integer);
var   i, j   : Integer;
      L      : Double;
      P1, P2 :TMyPoint;
      Col : Cardinal;
begin

    if (RouteCount = 0) then
    if (FrameCount = 0)  then
        exit ;


    for i := 0 to RouteCount  -1 do
    begin
     Col := RoutesColor;

     case Route[I].Status of
       0,1: Col := RoutesColor;
       2,3: Col := DoneColor;
       else Col := HiddenColor;
     end;

     if (EdMode=24) or (EdMode = 28) or (EdMode = 29) or (EdMode = 41) then
       if not( (RouteN < 0) or (I = RouteN) ) then
           Col := Col - $D1000000;

      if Length(Route[i].WPT) = 1 then
      BEGIN
        P1 := MapToScreen(Route[i].x1,Route[i].y1);

        if I = RouteAsk then
        Begin
         AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'], pxBounds4(0, 0, 16 , 16 ));

         AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(24, 24), 0),
                               cColor4(ChoosedColor));
        End;

        AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'], pxBounds4(0, 0, 16 , 16 ));

        AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(16, 16), 0),
                               cColor4(Col));
      END
      ELSE
        if Length(Route[i].WPT) = 0 then
        BEGIN
          P1 := MapToScreen(Route[i].x1,Route[i].y1);
          P2 := MapToScreen(Route[i].x2,Route[i].y2);

          if I = RouteAsk then
             FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 3, false, Smooth, ChoosedColor);


          FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, Col);
        END
        ELSE
         for J := 1 to Length(Route[i].WPT)-1 do
         BEGIN
          if J = 1 then
              P1 := MapToScreen(Route[i].WPT[j-1].X, Route[i].WPT[j-1].Y);

          P2 := MapToScreen(Route[i].WPT[j].X, Route[i].WPT[j].Y);

          if abs(P1.x - P2.x) + abs(P1.y - P2.y) > MinPix then
            P1 := MapToScreen(Route[i].WPT[j-1].X, Route[i].WPT[j-1].Y);

          // P1 := MapToScreen(Route[i].WPT[j-1].X, Route[i].WPT[j-1].Y);
          // P2 := MapToScreen(Route[i].WPT[j].X, Route[i].WPT[j].Y);

           if I = RouteAsk then
              FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 3, false, Smooth, ChoosedColor);

                                                                         
           if (EdMode = 23)or (EdMode = 24)or (EdMode = 28) or (EdMode = 29)or (EdMode = 41) then
           begin
               if i < length(SelectedRoutePoints) then
                 if j < length(SelectedRoutePoints[I]) then
                Begin
                  if (SelectedRoutePoints[I][J-1]) and (SelectedRoutePoints[I][J]) then
                    FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 2, false, Smooth, ChoosedColor)
                    else
                    if (SelectedRoutePoints[I][J-1]) or (SelectedRoutePoints[I][J]) then
                    begin
                      FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, Col);
                      FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, true, Smooth, ChoosedColor  - $A1000000)
                    end
                      else
                       FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, Col)
                End

           end
            else
              FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, Col);
         END;

      if Route[I].Fixed then
         DrawRouteArrows(I, Col);
    end;

  //////////// FRAME

      if Frame then
         if FrameCount  > 1 then
         Begin
            for i := 0 to FrameCount  -2 do
            begin
               P1 := MapToScreen(FramePoints[i,1].x, FramePoints[i,1].y);
               P2 := MapToScreen(FramePoints[i+1,1].x, FramePoints[i+1,1].y);

              if (EdMode=21)or(EdMode=22)or(EdMode=25)or(EdMode=27) then
              Begin
                if Length(SelectedFramePoints) > I+1 then
                Begin
                  if (SelectedFramePoints[i] = true) and (SelectedFramePoints[i+1] = true) then
                    FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 2, false, Smooth, ChoosedColor)
                    else
                    if (SelectedFramePoints[i] = true) or (SelectedFramePoints[i+1] = true) then
                    begin
                      FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, FrameColor);
                      FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, true, Smooth, ChoosedColor  - $A1000000)
                    end
                      else
                       FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, FrameColor)
                End
                 Else
                    FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, FrameColor)
              End
                  else
                   FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth,
                          FrameColor - $A1000000);
            end;
                                                    
           if (EdMode=21)or(EdMode=22)or(EdMode=25)or(EdMode=27){ or (ClickMode = 29)} then
           for i := 0 to FrameCount  -1 do
           Begin
             P1 := MapToScreen(FramePoints[i,1].x, FramePoints[i,1].y);

              if Length(SelectedFramePoints) > I+1 then
                if SelectedFramePoints[i] = true then
                begin
                   AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8 , 8 ));
                   AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(8, 8), 0),
                               cColor4(ChoosedColor));

                   AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'], pxBounds4(0, 0, 32 , 32 ));
                   AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(16, 16), 0),
                               cColor4(ChoosedColor));
                end
                 else
                   Begin
                      AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8 , 8 ));

                      AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(8, 8), 0),
                               cColor4(FrameColor));
                   End;
           End;

      End;

  if (EdMode=23) or (EdMode=24) or (EdMode=26) or (EdMode=28) then
    for i := 0 to RouteCount  -1 do
      for j := 0 to Length(Route[i].WPT) - 1 do
      Begin
           case Route[I].Status of
             0,1: Col := RoutesColor;
             2,3: Col := DoneColor;
             else Col := HiddenColor;
           end;

           if (EdMode=24) or (EdMode = 28) then
             if not( (RouteN < 0) or (I = RouteN)) then
                   Col := Col - $A1000000  ;

         P1 := MapToScreen(Route[i].WPT[j].x,Route[i].WPT[j].y);
         AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8 , 8 ));

         AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(8, 8), 0),
                               cColor4(Col));

          if Length(SelectedRoutePoints) > I then
          if Length(SelectedRoutePoints[I]) > J then
          if SelectedRoutePoints[i][J] = true then
                begin
                   AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8 , 8 ));
                   AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(8, 8), 0),
                               cColor4(ChoosedColor));

                   AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'], pxBounds4(0, 0, 32 , 32 ));
                   AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(16, 16), 0),
                               cColor4(ChoosedColor));
                end

      End;

   if EdMode = 22 then
   begin
     if MultiSelectMode > 0 then
       DrawFrameSelectionPoints(CanvCursorBL0,CanvCursorBL)
        else
          DrawFrameSelectionPoints(CanvCursorBL);
   end;

   if EdMode = 24 then
   begin
     if MultiSelectMode > 0 then
       DrawRoutesSelectionPoints(CanvCursorBL0,CanvCursorBL,RouteN)
        else
          DrawRoutesSelectionPoints(CanvCursorBL, RouteN);
   end;

   if (EdMode=27)or(EdMode =28) then
   if RefPointsFound then
   Begin
      P1 := MapToScreen(PointToAdd.x, PointToAdd.y);
      P2 := MapToScreen(PointToAddRefPoints[1].x, PointToAddRefPoints[1].y);
      FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, true, Smooth, ChoosedColor  - $A1000000);

      if not( (PointToAddRefPoints[1].x = PointToAddRefPoints[2].x)
               and (PointToAddRefPoints[1].y = PointToAddRefPoints[2].y)) then
      begin
        P2 := MapToScreen(PointToAddRefPoints[2].x, PointToAddRefPoints[2].y);
        FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, true, Smooth, ChoosedColor  - $A1000000);
      end;
      
      AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8 , 8 ));
      AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(8, 8), 0),
                               cColor4(ChoosedColor));

      AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'], pxBounds4(0, 0, 32 , 32 ));
      AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(16, 16), 0),
                               cColor4(ChoosedColor));

   End;


  //// Labels
  ///
  ///
//  if Not ((EdMode=24) or (EdMode=28)) then
//     DrawLabels(FntColor, MenuColor, DrawAll, Lstyle);   sss

  if HasDropPoint then
     DrawSelectionDot(DropPoint.x, DropPoint.y);

end;

procedure RefreshSelectionArrays;
var i, j :integer;
begin
   Setlength(SelectedFramePoints, FrameCount);

   for I := 0 to FrameCount - 1 do
       SelectedFramePoints[I] := false;

   SelectedFramePointsCount := 0;

   Setlength(SelectedRoutePoints, RouteCount);
   for I := 0 to RouteCount - 1 do
   Begin
      Setlength(SelectedRoutePoints[I], Length(Route[I].WPT));
      for J := 0 to Length(Route[I].WPT) - 1 do
         SelectedRoutePoints[I][J] := false
   End;

   SelectedRoutePointsCount := 0;
   SelectedRoutesCount := 0;

   SelectedRouteN := -1;
   
   RefPointsFound := false;
end;

procedure DrawAllLabels(PointNumbers, FrameNumbers: boolean; FntColor,
    MenuColor, SelColor:Cardinal; DrawAll:Boolean; LStyle, PMode:Integer);

  procedure LabelOut(P :TMyPoint; w: Integer; str : string; Selected: Boolean);
  var Col:TColor4;
  begin
     case Selected of
        false : Col := cColor4(MenuColor);
        true: Col := cColor4(SelColor);
     end;

    if lstyle = 1 then
       AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w+1,trunc(P.y)+1{-trunc(dy)}),
                                        str ,cRGB2(255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255,
                                                   255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255));


    if lstyle = 2 then
        AsphCanvas.FillRect(Rect (trunc(P.X - w) -2,
                                  trunc(P.Y) -1,
                                  trunc(P.X + w) +2,
                                  trunc(P.Y) + 14 ), Col );

    AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y){-trunc(dy)}),
                                        str , cColor2(FntColor));

    if lstyle < 2 then
    if Selected then
    begin
      AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w-4,trunc(P.y){-trunc(dy)}),
                                        '[' , cColor2(SelColor));
      AsphFonts[Font0].TextOut(Point2(trunc(P.x)+w+2,trunc(P.y){-trunc(dy)}),
                                        ']' , cColor2(SelColor));
    end;
  end;

const
  AMax = 512;

var i, j, k, w, dy :Integer;

    P :TMyPoint;

    canLabel: Boolean;
    A: array [1..AMax] of TMyPoint;
    Asize : array [1..AMax] of Integer;
    ACount : integer;

    str : string;

    Sel:Boolean;
    PHgt : Double;
begin

 Acount :=0;
 //if (RouteCount = 0)and(FrameCount > 0) then
 if PMode < 30 then
 if FrameNumbers then
 for I := 0 to FrameCount - 2 do
 begin
   if PMode = 25 then
     if (I = FrameCount - 1) then
               continue;

    P := MapToScreen(FramePoints[i,1].x, FramePoints[i,1].y);
    P.y := P.y - 18;

    if not ( (P.x > - 16) and (P.x <  DispSize.X + 16) and
             (P.y > - 16) and (P.y <  DispSize.y + 16) ) then
                continue;

    w := round(AsphFonts[Font0].TextWidth(IntTostr(i+1)+'[]')/2);

    canlabel := true;
    if Not DrawAll then
    begin
      for J := 1 to ACount do
      if (P.y > A[j].Y - 8)and(P.y < A[j].Y + 24) then
       if (P.x+w > A[j].X - Asize[j]-5)and(P.x-w < A[j].X + Asize[j]+5) then
       begin
            canlabel := false;
            break;
       end;
    end;

    if not canlabel then
       continue;

    if Acount < AMax  then
       inc(Acount);



    A[Acount].X := P.x;
    A[Acount].Y := P.y;
    Asize[Acount] := w;

    dy := 0;// 16;

    str := '['+IntTostr(i+1)+']';

    Sel := false;
    if Length(SelectedFramePoints) > I then
       Sel := SelectedFramePoints[I];

    LabelOut(P, w, str, Sel);
    //   AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
    //                                    str ,cColor2(FntColor));


 end;

 if PMode < 30 then
 if not FrameNumbers then
 for I := 0 to RouteCount - 1 do
   for k := 0 to Length(Route[i].WPT)-1  do
   Begin
      { case k of
         1: P := MapToScreen(Route[i].x1,Route[i].y1);
         2: P := MapToScreen(Route[i].x2,Route[i].y2);
       end;}

       if PMode = 26 then
         if (I = RouteCount - 1) and (k  = Length(Route[i].WPT)-1) then
               continue;

       P := MapToScreen(Route[i].WPT[K].x,Route[i].WPT[K].y);
       P.y := P.y +4;

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       w := round(AsphFonts[Font0].TextWidth(Route[i].Name)/2);
       if PointNumbers then
          w := w +  round(AsphFonts[Font0].TextWidth(' ()'+intTostr(K+1))/2);


       canlabel := true;
       if not drawAll then
       begin
          for J := 1 to ACount do
          if (P.y > A[j].Y - 16)and(P.y < A[j].Y + 16) then                   {!!!!!!!!!!!19-03}
          if (P.x+w > A[j].X - Asize[j]-5)and(P.x-w < A[j].X + Asize[j]+5) then
          begin
            canlabel := false;
            break;
          end;
       end;

       if not canlabel then
            continue;

       if Acount<Amax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;
       str := Route[i].Name;
       dy := 0;// 16;

       Sel := false;

       if Length(SelectedRoutePoints) > 0 then
       if i < length(SelectedRoutePoints) then
         if k < length(SelectedRoutePoints[I]) then
              Sel := SelectedRoutePoints[I][k];

       if CanLabel then
       begin
        { case PointNumbers of
            true: AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
                                         Route[i].Name+' ('+intTostr(K+1)+')',cColor2(FntColor));

            false: AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
                                         Route[i].Name,cColor2(FntColor));
          end; }
          if PointNumbers then
               str := str + ' ('+intTostr(K+1)+')' ;
           LabelOut(P, w, str, Sel);
       end
          else
         continue;


       //// HGT

       P.y := P.y - 20;

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

      PHgt := GetRoutePointA(I, K);
      if PHgt = 0 then
         continue
      else
      begin
        if PHgt <= 10  then
          str :=  Format('%.3f',[PHgt])
        else
          str :=  Format('%.1f',[PHgt])
      end;

       w := round(AsphFonts[Font0].TextWidth(str)/2);

       canlabel := true;
       if not drawAll then
       begin
          for J := 1 to ACount-1 do
          if (P.y > A[j].Y - 16)and(P.y < A[j].Y + 16) then                   {!!!!!!!!!!!19-03}
          if (P.x+w > A[j].X - Asize[j]-5)and(P.x-w < A[j].X + Asize[j]+5) then
          begin
            canlabel := false;
            break;
          end;
       end;

       if not canlabel then
            continue;

       if Acount<Amax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;
       dy := 0;

       if CanLabel then
           LabelOut(P, w, str, Sel);

   End;

   for I := 0 to Length(Markers) - 1 do
     if (Markers[i].MarkerName<>'*') and (Pos('!#', Markers[I].MarkerName) <> 1) then
     Begin
       P := MapToScreen(Markers[i].x,Markers[i].y);
       P.y := P.y - 20;

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       w := round(AsphFonts[Font0].TextWidth(Markers[i].MarkerName)/2);

       canlabel := true;
       if not DrawAll then

       for J := 1 to ACount do
          if (P.y > A[j].Y - 32)and(P.y < A[j].Y + 32) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;

       if not canlabel then
            continue;

       if Acount < AMax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;

       Sel := false;
       if PMode = 31 then
         for j := 0 to Length(SelectedMarkers) - 1 do
           if I = SelectedMarkers[j] then
           begin
             Sel := true;
             break;
           end;


       if CanLabel then
         LabelOut(P,w, Markers[i].MarkerName, sel)
       else
         continue;


        //// HGT

       P.y := P.y + 28;

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

        PHgt := Markers[i].H;
        if PHgt = 0 then
           PHgt := Markers[i].HGeo;

        if PHgt = 0 then
          continue
        else
        begin
        if PHgt <= 10  then
          str := Format('%.3f',[PHgt])
        else
          str := Format('%.1f',[PHgt])
        end;

       w := round(AsphFonts[Font0].TextWidth(str)/2);

       canlabel := true;
       if not drawAll then
       begin
          for J := 1 to ACount-1 do
          if (P.y > A[j].Y - 16)and(P.y < A[j].Y + 16) then                   {!!!!!!!!!!!19-03}
          if (P.x+w > A[j].X - Asize[j]-5)and(P.x-w < A[j].X + Asize[j]+5) then
          begin
            canlabel := false;
            break;
          end;
       end;

       if not canlabel then
            continue;

       if Acount<Amax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;
       dy := 0;

       if CanLabel then
           LabelOut(P, w, str, Sel);
     End;


end;

procedure RoutesToGeo;
var i, j  :integer;
    L : TLatLong;
Begin
     if RouteCount = 0 then
        exit;

     for I := 0 to RouteCount - 1 do
     Begin

        SetLength(Route[I].GWPT, Length(Route[I].WPT));

        for j := 0 to Length(Route[I].WPT)- 1 do
        Begin
          L := MapToBL(Route[I].WPT[j].x,Route[I].WPT[j].y);
          Route[I].GWPT[j].x := L.Lat;
          Route[I].GWPT[j].y := L.Long;
        End;

        Route[i].Gx1 := Route[I].GWPT[0].x;
        Route[i].Gy1 := Route[I].GWPT[0].y;

        Route[i].Gx2 := Route[I].GWPT[Length(Route[I].WPT)- 1].x;
        Route[i].Gy2 := Route[I].GWPT[Length(Route[I].WPT)- 1].y;

        Route[i].Geo := true;
      End;
End;

procedure CreateFramePoint(B, L: Double);
begin
  if FrameCount >= FrameMax-1 then
   exit;

  FrameGeo := True;
  WaitForZone := False;

  if FrameCount < 1 then
     FrameCount := 1;

  FramePoints[FrameCount-1,2].x := B;
  FramePoints[FrameCount-1,2].y := L;
  Inc(FrameCount);
  RecomputeRoutes(WaitForZone);

  FramePoints[FrameCount-1,2].x := B;
  FramePoints[FrameCount-1,2].y := L;
  RecomputeRoutes(WaitForZone);

  RecomputeRoutes(WaitForZone);
  RefreshSelectionArrays;
end;

procedure DeleteFramePoint(Num:integer);
  var I:integer;
begin
   if Num = FrameCount-1 then
     Num := 0;

  if Num = 0 then
  if FrameCount > 1 then
  Begin
      FramePoints[FrameCount-1,1]:=  FramePoints[1,1];
      FramePoints[FrameCount-1,2]:=  FramePoints[1,2];
  End;

  for I := Num To FrameCount - 1 do
  begin
    FramePoints[I,1]:=  FramePoints[I+1,1];
    FramePoints[I,2]:=  FramePoints[I+1,2];
  end;

  Dec(FrameCount);
  if FrameCount = 1 then
     FrameCount := 0;
end;

procedure ShiftSelectedFramePoints(N, E : real);
  var I:integer;
begin
  for I := FrameCount-1 downto 1 do
    if length(SelectedFramePoints) > I then
       if SelectedFramePoints[I] then
       Begin
         FramePoints[I,1].x := FramePoints[I,1].x + E;
         FramePoints[I,1].y := FramePoints[I,1].y + N;
         if I = 0 then
         begin
           FramePoints[length(SelectedFramePoints)-1,1].x := FramePoints[I,1].x;
           FramePoints[length(SelectedFramePoints)-1,1].y := FramePoints[I,1].y;
         end;
         if I = length(SelectedFramePoints)-1 then
         begin
           FramePoints[0,1].x := FramePoints[I,1].x;
           FramePoints[0,1].y := FramePoints[I,1].y;
         end;
       End;

  FrameToGeo;
end;

procedure DeleteSelectedFramePoints;
  var I:integer;
begin
  for I := FrameCount-1 downto 1 do
    if length(SelectedFramePoints) > I then
       if SelectedFramePoints[I] then
           DeleteFramePoint(I);
end;

procedure AddPointToFrame;
var I:Integer;
begin
  if FrameCount >= FrameMax-1 then
    exit;

  try
     if (RefPointsFound = false) or (PointToAddNum < 0) or
        (PointToAddNum > FrameCount) then
     begin
        FramePoints[FrameCount,1].x := PointToAdd.x;
        FramePoints[FrameCount,1].y := PointToAdd.y;
     end
       else
       begin
           for I := FrameCount-1 downto PointToAddNum  do
           begin
              FramePoints[I+1,1]:=  FramePoints[I,1];
           end;
           FramePoints[PointToAddNum+1,1].x:= PointToAdd.x;
           FramePoints[PointToAddNum+1,1].y:= PointToAdd.y;
       end;

  finally
     inc(FrameCount);
     FrameToGeo;
     RecomputeRoutes(WaitForZone);
     RefreshSelectionArrays;
  end;


end;

procedure MergeRoutesArr(A: array of Integer; DoRad, DoLoop :Boolean;
                Rad :Double; Step, RadStep, NewH : Integer; RName :String);

var BackStep :boolean;
    ReadyPoints : Array of Boolean;


 { procedure DubinsPTS(Rad, Step : Double;
      ShiftL: Double; DoContinue:Boolean);
  var TmpRoute:TRoute;
     I:Integer;
  begin
    //TmpRoute := MyRoute;
    Dubins(xi, yi, -ai + pi/2, xj, yj, -aj + pi/2, Rad);
    //SetLength(MyRoute.WPT, TPCount);
    for I := 0 to TPCount- 1 do
    begin
      MyRoute.WPT[I].x := TurnPoints[I].x;
      MyRoute.WPT[I].y := TurnPoints[I].y;
    end;

    RouteGPS(Step, ShiftL, false);
    MyRoute := TmpRoute;
  end;  }

  function NextRoute(CurrentRoute, RCount, Step:Integer; RoundFly: boolean):integer;
  var i, j, k : integer;
      Done : boolean;
  begin
   NextRoute := -1;
   I := CurrentRoute;
   Done := false;
   ReadyPoints[I] := true;
   if (RoundFly) then
   BEGIN

    for k := 0 to 1 do
    Begin

      if BackStep = false then
      Begin
        if I+step <= RCount-1 then
        begin
          If  ReadyPoints[(I+step)] = false then
          Begin
            NextRoute := I+step;
            Done := true;
            BackStep := true;
            break;
          End
      end
     End else
      if I-step+1 >= 0 then
      begin
        If  ReadyPoints[(I+1-step)] = false   then
          Begin
            NextRoute := I+1-step;
            Done := true;
            BackStep := false;
            break;
          End
       end;

       if not Done then
         BackStep := not BackStep;

     End;

     END;

     if not(RoundFly) or (Done= false) then
     BEGIN
       for step := step Downto 1 do
       Begin
         if I+step <= RCount - 1 then
         if ReadyPoints[(I+step)] = false then
         Begin
            NextRoute := I+step;
            Done := true;
            break
         End;

         if I-step >= 0  then
         if ReadyPoints[(I-step)] = false then
         Begin
            NextRoute := I-step;
            Done := true;
            break
         End;
       End;

       if Done = false then
         for j := 0 to RCount-1 do
         begin
           if I+j <= RCount-1 then
           If  ReadyPoints[(I+j)] = false then
           Begin
             NextRoute := I+j;
             Done := true;
             break
           End;

         if I-j >= 0  then
           If ReadyPoints[(I-j)] = false  then
           Begin
             NextRoute := I-j;
             Done := true;
             break
           End;
        end;

     END;

  end;



var Rewerse :boolean;
    XY   : Array of TMyPoint;
    ALT  : Array of Double;
    PtsCount :Integer;

const
  MaxPTS = 1000000;

  procedure AddRT(I: Integer; DoRew:Boolean);
  var N, j, k :Integer;
  begin
    N :=  Length(Route[A[I]].WPT);
    if PtsCount + N > MaxPts then
       exit;

    for j := 0 to N-1 do
    begin
        if DoRew = false then
          k := j
        else
          k := N-1 - j;

        XY[j+ PtsCount] := Route[A[I]].WPT[k];
        if k < Length(Route[A[I]].ALT) then
          ALT[j +PtsCount] := Route[A[I]].ALT[k]
        else
          ALT[j +PtsCount] := 0;
    end;

    PtsCount := PtsCount + N;
  end;

  procedure AddArc(x1, y1, a1, x2, y2,  a2: Double);
  var N, j:Integer;
  begin

    if Dubins(x1, y1, a1, x2, y2, a2, Rad, RadStep*pi/180) then
    begin
       N :=  TPCount-4;
       if PtsCount + N > MaxPts then
         exit;

       for j := 0 to N-1 do
       begin
          XY [j + PtsCount] := MyPoint(TurnPoints[j+2].x, TurnPoints[j+2].y);
          ALT[j + PtsCount] := NewH;
       end;
       PtsCount := PtsCount + N;
    end;
  end;



var i,  j, n, Bani, RouteN, NextN, Ready: integer;
    ai, aj :Double;
begin

  if Length(A) = 0 then
      exit;

  SetLength(ReadyPoints, Length(A));
  for i:= 0 to Length(A) - 1 do
     ReadyPoints[i] := false;

  SetLength(XY,  MaxPTS -1);
  SetLength(ALT, MaxPTS -1);
  PtsCount := 0;

  RouteN := 0;
  Rewerse := false;

  Ready := 0;
  while Ready < length(A) do
  begin
     AddRt(RouteN, Rewerse);
     RouteN := NextRoute(RouteN, length(A), Step,  DoLoop);
     if RouteN = -1 then
       break;

     Rewerse := sqrt(sqr(XY[PtsCount-1].x - Route[A[RouteN]].x1) +
                     sqr(XY[PtsCount-1].y - Route[A[RouteN]].y1) )   >
                sqrt(sqr(XY[PtsCount-1].x - Route[A[RouteN]].x2) +
                     sqr(XY[PtsCount-1].y - Route[A[RouteN]].y2) );

     if Route[A[RouteN]].fixed then
       Rewerse := false;

     If DoRad Then
     Begin
        n := PtsCount-1;
        if n = 0 then
           ai := 0
        else
           ai := arctan2( XY[n].x -  XY[n-1].x, XY[n].y - XY[n-1].y);

        n := Length( Route[A[RouteN]].WPT )-1;
        case rewerse of
          true:
          begin
             if n = 0 then
                aj := ai
             else
                aj := arctan2( Route[A[RouteN]].WPT[n-1].x -  Route[A[RouteN]].WPT[n].x,
                     Route[A[RouteN]].WPT[n-1].y -  Route[A[RouteN]].WPT[n].y);
             AddArc( XY[PtsCount-1].x,  XY[PtsCount-1].y, -ai + pi/2,
                      Route[A[RouteN]].x2, Route[A[RouteN]].y2, -aj + pi/2)
          end;
          false:
          begin
             if n = 0 then
                aj := ai
             else
                aj := arctan2( Route[A[RouteN]].WPT[1].x -  Route[A[RouteN]].WPT[0].x,
                     Route[A[RouteN]].WPT[1].y -  Route[A[RouteN]].WPT[0].y);
             AddArc( XY[PtsCount-1].x,  XY[PtsCount-1].y, -ai + pi/2,
                      Route[A[RouteN]].x1, Route[A[RouteN]].y1, -aj + pi/2)
          end;
        end;
     End;

     Inc(Ready);
  end;

  
  AddRoute(RName);
  SetLength(Route[RouteCount-1].WPT, PtsCount);
  for I := 0 to PtsCount - 1 do
     Route[RouteCount-1].WPT[I] := XY[I];

  SetLength(Route[RouteCount-1].ALT, PtsCount);
  for I := 0 to PtsCount - 1 do
     Route[RouteCount-1].ALT[I] := ALT[I];
end;

procedure AddRoute(RName:String);
begin
 RoutesToGeo;

 CheckNewRouteName(RName);

 if RouteCount < RouteMax-1 then
    inc(RouteCount);

 SetLength(Route[RouteCount-1].WPT,1);
 SetLength(Route[RouteCount-1].GWPT,1);

 Route[RouteCount-1].Name := Rname;
 Route[RouteCount-1].Status := 0;
 Route[RouteCount-1].Fixed := False;

 Route[RouteCount-1].WPT[0].x := 0;
 Route[RouteCount-1].WPT[0].y := 0;
 Route[RouteCount-1].GWPT[0].x := 0;
 Route[RouteCount-1].GWPT[0].y := 0;

 Route[RouteCount-1].x1 := 0;
 Route[RouteCount-1].y1 := 0;
 Route[RouteCount-1].x2 := 0;
 Route[RouteCount-1].y2 := 0;
end;

procedure AddPointToRoute(RouteN: integer);
var I:Integer;
begin

  if (RouteN >= RouteMax-1)or(RouteN < 0) then
     exit;

  if (PointToAddNum < -1) then
     exit;

    WaitForZone := False;

  try
     if (RefPointsFound = false) or (PointToAddNum < -1) or
        (PointToAddNum >= Length(Route[RouteN].WPT)-1) then
     begin
        setLength(Route[RouteN].WPT,Length(Route[RouteN].WPT)+1) ;
        Route[RouteN].WPT[Length(Route[RouteN].WPT)-1].x := PointToAdd.x;
        Route[RouteN].WPT[Length(Route[RouteN].WPT)-1].y := PointToAdd.y;
     end
       else
       begin
           SetLength(Route[RouteN].WPT,Length(Route[RouteN].WPT)+1);
           for I := Length(Route[RouteN].WPT)-2 downto PointToAddNum  do
           if i> -1 then
              Route[RouteN].WPT[I+1] :=  Route[RouteN].WPT[I];
           Route[RouteN].WPT[PointToAddNum + 1].x:= PointToAdd.x;
           Route[RouteN].WPT[PointToAddNum + 1].y:= PointToAdd.y;
       end;

  finally
     SetLength(Route[RouteN].GWPT,Length(Route[RouteN].WPT));
     RoutesToGeo;
     RecomputeRoutes(WaitForZone);
     RefreshSelectionArrays;
  end;

end;

procedure DeleteRoutePoint(RouteN, N: integer);
var I:Integer;
begin
  if (RouteN >= RouteMax-1)or(RouteN < 0) then
     exit;

  if (N > Length(Route[RouteN].WPT)-1 ) then
      exit;

  try

    for I := N to Length(Route[RouteN].WPT)-2  do
       Route[RouteN].WPT[I] :=  Route[RouteN].WPT[I+1];

  finally
     SetLength(Route[RouteN].WPT,Length(Route[RouteN].WPT)-1);
     SetLength(Route[RouteN].GWPT,Length(Route[RouteN].WPT));

     if Length(Route[RouteN].WPT) = 0 then
        DelRoute(RouteN);

     RoutesToGeo;
     RecomputeRoutes(WaitForZone);
    // RefreshSelectionArrays;
  end;

end;

procedure ReplaceRoute(N1, N2: integer);
var R:TRoute;
begin
  if not ((N1>-1) and (N2>-1) and (N1 < RouteCount) and (N2 < RouteCount)) then
     exit;

  if N1 = N2 then
     exit;

  R := Route[N2];
  Route[N2] := Route[N1];
  Route[N1] := R;

end;

procedure RewerseRoute(RouteN: integer);
var I  : integer;
    WP : TMyPoint;
begin
   if (RouteN < 0) or (RouteN > RouteCount-1) then
     exit;

   for I := 0 to trunc((Length(Route[RouteN].WPT) - 1)/2) do
   Begin
      WP := Route[RouteN].WPT[Length(Route[RouteN].WPT) - 1 - I];
      Route[RouteN].WPT[Length(Route[RouteN].WPT) - 1 - I] := Route[RouteN].WPT[I];
      Route[RouteN].WPT[I] := WP;

   //   WP := Route[RouteN].WPT[Length(Route[RouteN].GWPT) - 1 - I];
   //   Route[RouteN].GWPT[Length(Route[RouteN].WPT) - 1 - I] := Route[RouteN].GWPT[I];
   //   Route[RouteN].GWPT[I] := WP;
   End;

        
end;

procedure DelRoute(RouteN: integer);
var I:Integer;
begin

  if (RouteN >= RouteMax-1)or(RouteN < 0) then
     exit;

  try

    for I := RouteN  to RouteCount-2  do
       Route[I]:=  Route[I+1];

  finally
     Dec(RouteCount);
     RecomputeRoutes(WaitForZone);
    // RefreshSelectionArrays;
  end;

end;

procedure DeleteSelectedRoutePoints;
Var i, j : integer;
begin
  for I := RouteCount-1 DownTo 0 do
    for J := Length(Route[I].WPT)-1 DownTo 0 do
    try
      if i < length(SelectedRoutePoints) then
         if j < length(SelectedRoutePoints[I]) then
              if SelectedRoutePoints[I][J] then
                  DeleteRoutePoint(I, J);
    except

    end;

  RefreshSelectionArrays;
end;

procedure ShiftSelectedKnot(N, E : real);
var   I :Integer;
begin
  for I := 0 to Length(SelectedKnots) - 1 do
    try
       KnotPoints[SelectedKnots[I]].Cx := KnotPoints[SelectedKnots[I]].Cx + E;
       KnotPoints[SelectedKnots[I]].Cy := KnotPoints[SelectedKnots[I]].Cy + N;
    except
    end;
end;

procedure ShiftSelectedMarker(N, E : real);
var L :TLatLong;
    I :Integer;
begin
  for I := 0 to Length(SelectedMarkers) - 1 do
    try
       Markers[SelectedMarkers[I]].x := Markers[SelectedMarkers[I]].x + E;
       Markers[SelectedMarkers[I]].y := Markers[SelectedMarkers[I]].y + N;

       L := MapToBL(Markers[SelectedMarkers[I]].x ,Markers[SelectedMarkers[I]].y);
       Markers[SelectedMarkers[I]].Gx := L.lat;
       Markers[SelectedMarkers[I]].Gy := L.long;
    except
    end;
end;

procedure ShiftSelectedRoutePoints(N, E : real);
  var i, j : integer;
begin

  for I := RouteCount-1 DownTo 0 do
    for J := Length(Route[I].WPT)-1 DownTo 0 do
    try
      if i < length(SelectedRoutePoints) then
         if j < length(SelectedRoutePoints[I]) then
              if SelectedRoutePoints[I][J] then
               begin
                  Route[I].WPT[J].x := Route[I].WPT[J].x + E;
                  Route[I].WPT[J].y := Route[I].WPT[J].y + N;
               end;

    except

    end;

    RoutesToGeo;


{  for I := FrameCount-1 downto 1 do
    if length(SelectedFramePoints) > I then
       if SelectedFramePoints[I] then
       Begin
         FramePoints[I,1].x := FramePoints[I,1].x + E;
         FramePoints[I,1].y := FramePoints[I,1].y + N;
         if I = 0 then
         begin
           FramePoints[length(SelectedFramePoints)-1,1].x := FramePoints[I,1].x;
           FramePoints[length(SelectedFramePoints)-1,1].y := FramePoints[I,1].y;
         end;
         if I = length(SelectedFramePoints)-1 then
         begin
           FramePoints[0,1].x := FramePoints[I,1].x;
           FramePoints[0,1].y := FramePoints[I,1].y;
         end;
       End;

  FrameToGeo;   }

end;

procedure MarksFromRoute(R:TRoute; SpecialName, Sep:String; Shifted:boolean);
  function WithZeros(const Number, Length: Integer):string;
  begin
     Result := SysUtils.Format('%.*d', [Length, Number]);
  end;

var I, J, sI:Integer;
    S: String;
begin
 S := IntToStr(Length(R.GWPT));
 J := Length(S);

 if Shifted then
   sI := SpecialI;
 for I := 0 to Length(R.GWPT) - 1 do
 begin
    if SpecialName <> '' then
      S := SpecialName + Sep +WithZeros(I+1+sI, J)
    else
      S := R.Name + Sep + WithZeros(I+1+sI, J);
    AddMarker(S, R.GWPT[I].x, R.GWPT[I].y)
 end;

end;

procedure RouteFromMarkers(RName:String);
var I: Integer;
Begin

   if  Length(Markers) > 1 then
   begin
      AddRoute(RName);
      Route[RouteCount-1].Geo  := false;
      Route[RouteCount-1].Status := 0;

      SetLength(Route[RouteCount-1].WPT,  Length(Markers));
      SetLength(Route[RouteCount-1].GWPT, Length(Markers));

      for I := 0 to Length(Markers) - 1 do
      Begin

           Route[RouteCount-1].GWPT[i].x := Markers[I].Gx;
           Route[RouteCount-1].GWPT[i].y := Markers[I].Gy;

           Route[RouteCount-1].WPT[i].x := Markers[I].x;
           Route[RouteCount-1].WPT[i].y := Markers[I].y;

           if I = 0 then
           begin
             Route[RouteCount-1].x1  := Markers[I].x;
             Route[RouteCount-1].y1  := Markers[I].y;
             Route[RouteCount-1].Gx1 := Markers[I].Gx;
             Route[RouteCount-1].Gy1 := Markers[I].Gy;
           end;

           if I = Length(Markers) - 1  then
           begin
             Route[RouteCount-1].x2  := Markers[I].x;
             Route[RouteCount-1].y2  := Markers[I].y;
             Route[RouteCount-1].Gx2 := Markers[I].Gx;
             Route[RouteCount-1].Gy2 := Markers[I].Gy;
           end;

      End;
   end;
   RoutesToGeo;
   RecomputeRoutes(False);
End;

function RouteStepBreak(RouteN: Integer; Step: Double; AddM :Boolean;
                MnameKind:Byte; Mfrom, Mstep :Double; MSep:string; DoEnd:boolean ):TRoute;  overload;
var
  I, SegN, MarkN :Integer;
                 
  CStep, SegL    :Double;
  CurL, FullL    :Double;

  X1, Y1, X2, Y2 :Double;
  NewX, NewY, c  :Double;

  procedure AddPoint(x, y :Double; FP, NeedM:boolean);
  var J: Integer; BL: TLatLong;  Ms:string; subst: Double;
  begin
    J := Length(Result.WPT);
    SetLength(Result.WPT, J+1);

    Result.WPT[J].x := x;
    Result.WPT[J].y := y;

    if AddM and NeedM then
    begin
      BL := MapToBL(Result.WPT[J].x,  Result.WPT[J].y);

    
      case MnameKind of
        0: Ms := Result.Name + Msep;
        1: Ms := Msep;
        2: Ms := Result.Name;
      end;
      if not FP then
      begin
         if MNameKind < 2 then
            Ms := Ms + FloatToStr(MFrom + Mstep *(MarkN));
         AddMarker(Ms, BL.lat, BL.long)
      end
      else
        if DoEnd then
        begin
           subst := 0;
           if step <> 0 then
             subst := (Step - (CurL - FullL)) / Step;
           if MNameKind < 2 then
           begin
             if (Mstep = trunc(MStep)) and (MStep >= 10) then
                Ms := Ms + IntToStr(Round(MFrom + Mstep * (MarkN - 1 + subst)))
             else
             Ms := Ms + FormatFloat('0.000',MFrom + Mstep * (MarkN - 1 + subst));
           end;
           AddMarker(Ms, BL.lat, BL.long);
        end;
      Inc(MarkN);
    end;
  end;

  procedure GetSegL;
  begin
     SegL := sqrt( Sqr(X2 - X1) + Sqr(Y2 - Y1));
  end;

  procedure NextSeg;
  begin
    inc(SegN);
    if SegN > Length(Route[RouteN].WPT) - 1  then
      SegL := -1
      else
        begin
           X1 := Route[RouteN].WPT[SegN-1].x;
           Y1 := Route[RouteN].WPT[SegN-1].y;
           X2 := Route[RouteN].WPT[SegN].x;
           Y2 := Route[RouteN].WPT[SegN].y;

           GetSegL;
           AddPoint (X1, Y1, false, SegN = 1);
        end;
  end;

  procedure GetFullL;
  var J :integer;
  begin
     FullL := 0;
     for J := 1 to Length(Route[RouteN].WPT) - 1 do
     begin
       FullL := FullL + sqrt(
                Sqr(Route[RouteN].WPT[J].x - Route[RouteN].WPT[J-1].x) +
                Sqr(Route[RouteN].WPT[J].y - Route[RouteN].WPT[J-1].y));
     end;
  end;

  procedure InitRoute;
  begin
    Result.Name := Route[RouteN].Name;
    Result.Geo  := False;
    SetLength(Result.WPT, 0);
    SetLength(Result.GWPT, 0);
    Result.Status :=  Route[RouteN].Status;
    Result.Fixed  :=  Route[RouteN].Fixed;
  end;

  procedure FinalizeRoute;
  var J: integer;
  begin
    //// ???????? ?????
    J := Length(Route[RouteN].WPT) -1;
    AddPoint(Route[RouteN].WPT[J].x, Route[RouteN].WPT[J].y, true, true);

    //// ?????????? ??? ?????????
    J := Length(Result.WPT) -1;
    SetLength(Result.WPT, Length(Result.WPT));
    Result.x1 := Result.WPT[0].x;
    Result.y1 := Result.WPT[0].y;
    Result.x2 := Result.WPT[J].x;
    Result.y2 := Result.WPT[J].y;

    Result.Status := 0;
  end;
begin

  if Length(Route[RouteN].WPT)<= 1 then
  begin
    Result := Route[RouteN];
    Exit;
  end
    else
    InitRoute;

  GetFullL;
  MarkN := 0;
  CurL  := 0;
  CStep := 0;
  SegL  := 0;
  SegN  := 0;

  repeat
     CurL  := CurL  + Step;
     cStep := cStep + Step;

     while (SegL <= cStep) or (SegL = 0) do
     begin
       cStep := cStep - SegL;
       NextSeg;

       if SegL < 0 then
          break;

     end;

     if SegL < 0 then
        break;

     c := cStep / SegL;
     NewX := X1 + c*(X2 - X1);
     NewY := Y1 + c*(Y2 - Y1);

     if c <> 0  then
       AddPoint(NewX, NewY, false, true);

     X1 := NewX; Y1 := NewY;
     GetSegL;
     cStep := 0;

  until CurL > FullL;

  FinalizeRoute;
end;

function RouteStepBreak(RouteN: Integer; Step: Double):TRoute;  overload;
begin
  Result := RouteStepBreak(RouteN, Step, false, 0, 0, 0, '', false);
end;

procedure DrawSelectionDot(x, y: Double);
var
    P3: TMyPoint;
begin
      P3 := MapToScreen(x, y);

      AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'],
                                        pxBounds4(0, 0, 32, 32));

      AsphCanvas.TexMap(pRotate4c(Point2(P3.X, P3.Y),
                        Point2(32, 32), 0),
                        cRGB4(255,255,255,155) );

end;

procedure DrawFrameSelectionPoints(P1, P2 :TMyPoint);
var I:Integer;
    TmpXY : Double;
    P3: TMyPoint;
begin
   if P1.X > P2.X then
   begin
     TmpXY := P2.X;
     P2.X := P1.x; P1.x := TmpXY;
   end;
   if P1.Y > P2.Y then
   begin
     TmpXY := P2.Y;
     P2.Y := P1.Y; P1.Y := TmpXY;
   end;

  P1.x :=  P1.x - MouseSenseZone;//*Scale;
  P1.y :=  P1.y - MouseSenseZone;//*Scale;
  P2.x :=  P2.x + MouseSenseZone;//*Scale;
  P2.y :=  P2.y + MouseSenseZone;//*Scale;

   for I := 0 to FrameCount - 1 do
   Begin
      P3 := MapToScreen(FramePoints[I,1].x, FramePoints[I,1].y);
      if (P3.x > P1.X)and (P3.x < P2.X) then
        if (P3.y > P1.y)and (P3.y < P2.y) then
        begin

           if i < length(SelectedFramePoints) then
              if SelectedFramePoints[I] = true then
                if (not ShiftMode) and (SubCursor < 1) then
                   SubCursor := -3;


           AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'],
                                        pxBounds4(0, 0, 32, 32));

           AsphCanvas.TexMap(pRotate4c(Point2(P3.X, P3.Y),
                        Point2(32, 32), 0),
                        cRGB4(255,255,255,155) );
        end;
   End;
end;

procedure DrawFrameSelectionPoints(L1, L2 :TLatLong);
var P1, P2 :TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  P2 := BLToScreen(L2.lat, L2.long);
  DrawFrameSelectionPoints(P1,P2);
end;

procedure DrawFrameSelectionPoints(L1:TLatLong);
var P1 :TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  DrawFrameSelectionPoints(P1,P1);
end;

procedure DrawRoutesSelectionPoints(P1, P2 :TMyPoint; RouteN:Integer);
var I, J, I1, I2:Integer;
    TmpXY : Double;
    P3: TMyPoint;
begin

   if RouteCount = 0 then
     exit;

   if P1.X > P2.X then
   begin
     TmpXY := P2.X;
     P2.X := P1.x; P1.x := TmpXY;
   end;
   if P1.Y > P2.Y then
   begin
     TmpXY := P2.Y;
     P2.Y := P1.Y; P1.Y := TmpXY;
   end;

  P1.x :=  P1.x - MouseSenseZone;//*Scale;
  P1.y :=  P1.y - MouseSenseZone;//*Scale;
  P2.x :=  P2.x + MouseSenseZone;//*Scale;
  P2.y :=  P2.y + MouseSenseZone;//*Scale;

  i1 := 0;
  i2 := RouteCount-1 ;
  if RouteN >= 0 then
  Begin
     if RouteN > RouteCount then
        exit
          else
          begin
             i1 := RouteN;
             i2 := RouteN;
          end;
  End;

  AlreadySelected := false;

  for I := i1 to i2 do
    for J := 0 to Length(Route[I].WPT) do
    try
      if i < length(SelectedRoutePoints) then
              if j < length(SelectedRoutePoints[I]) then
              begin
                 P3 := MapToScreen(Route[I].WPT[J].x, Route[I].WPT[J].y);

                if (P3.x > P1.X) and (P3.x < P2.X) then
                if (P3.y > P1.y) and (P3.y < P2.y) then
                Begin
                           AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'],
                                        pxBounds4(0, 0, 32, 32));

                           AsphCanvas.TexMap(pRotate4c(Point2(P3.X, P3.Y),
                                              Point2(32, 32), 0),
                                              cRGB4(255,255,255,155) );


                        if i < length(SelectedRoutePoints) then
                           if j < length(SelectedRoutePoints[I]) then
                                   if (SelectedRoutePoints[I][J]) then
                                     AlreadySelected  := True;
                End;
              end;

   except

   end;


  if AlreadySelected then
     SubCursor := -5;
end;

procedure DrawRoutesSelectionPoints(L1, L2 :TLatLong; RouteN:Integer);
var P1, P2 :TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  P2 := BLToScreen(L2.lat, L2.long);
  DrawRoutesSelectionPoints(P1,P2, RouteN);
end;

procedure DrawRoutesSelectionPoints(L1:TLatLong; RouteN:Integer);
var P1 :TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  DrawRoutesSelectionPoints(P1,P1, RouteN);
end;

procedure DrawChoosedMarker(Color: Cardinal; DoLoops:Boolean);
var P: TMyPoint;
    csize: Integer;
    I:Integer;
    nm:String;
begin
  if i = -1 then
      exit;
  for I := 0 to Length(SelectedMarkers) - 1 do
  try
     P := MapToScreen(Markers[SelectedMarkers[i]].x,
             Markers[SelectedMarkers[i]].y);

     csize := 16;
     if BigIcons then
        csize := 32;
     nm := 'marker2';

     if DoLoops then
     Begin
        if Markers[SelectedMarkers[i]].MarkerKind = 2 then
          csize := round(csize *0.5);
        if Markers[SelectedMarkers[i]].MarkerKind = 3 then
          csize := round(csize *0.75);
        if Markers[SelectedMarkers[i]].MarkerKind > 1 then
          nm := 'marker1';
     End;

     if (P.x > - csize) and (P.x < DispSize.X + csize) then
     if (P.y > - csize) and (P.y < DispSize.y + csize) then
         begin
            if BigIcons then
                AsphCanvas.UseImagePx(AsphImages.Image[nm+'_big.image'],
                                        pxBounds4(0, 0, 32, 32))
                else
                   AsphCanvas.UseImagePx(AsphImages.Image[nm+'.image'],
                                        pxBounds4(0, 0, 16, 16));


             AsphCanvas.TexMap(pRotate4c(Point2(P.x, P.y),Point2(csize, csize), 0),
                    cColor4(Color));
         end;



  except
  end;
end;

procedure DrawMarkersToChoose(BL1, BL2:TLatLong);
var minx, miny, maxx, maxy :Double;
procedure CheckMinMax;
 var D:Double;
 Begin
   if minX > maxX then
   begin
     D := maxX;
     maxX := minX;
     minX := D;
   end;
   if minY > maxY then
   begin
     D := maxY;
     maxY := minY;
     minY := D;
   end;
 End;

var I, j : Integer;
    P : TMyPoint;
begin
  P := BLToScreen(BL1.lat, BL1.long);
  minx := P.x; miny := P.y;
  P := BLToScreen(BL2.lat, BL2.long);
  maxx := P.x; maxy := P.y;

  j := 0;

  if maxx = minx then
     j := trunc(MouseSenseZone{*Scale}/2);

  CheckMinMax;
                                            
  for I := 0 to Length(Markers) - 1 do
  begin
     P := MapToScreen( Markers[i].x, Markers[i].y);
    // P.x := Markers[i].x;  P.y := Markers[i].y;
    if (P.x > minX - j) and (P.x < maxX + j) then
    if (P.y > minY - j) and (P.y < maxY + j) then
    begin
      P := MapToScreen(Markers[i].x, Markers[i].y);
      AsphCanvas.UseImagePx(AsphImages.Image['ed_cur1.image'],
                                        pxBounds4(0, 0, 32, 32));

      AsphCanvas.TexMap(pRotate4c(Point2(P.X, P.Y),
                        Point2(32, 32), 0),
                        cRGB4(255,255,255,155) );
    end;
  end;
end;

(*
procedure DrawAllLabels(PointNumbers, FrameNumbers: boolean; FntColor,
    MenuColor, SelColor:Cardinal; DrawAll:Boolean; LStyle, PMode:Integer);

  procedure LabelOut(P :TMyPoint; w: Integer; str : string; Selected: Boolean);
  var Col:TColor4;
  begin
     case Selected of
        false : Col := cColor4(MenuColor);
        true: Col := cColor4(SelColor);
     end;

    if lstyle = 1 then
       AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w+1,trunc(P.y)+1{-trunc(dy)}),
                                        str ,cRGB2(255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255,
                                                   255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255));


    if lstyle = 2 then
        AsphCanvas.FillRect(Rect (trunc(P.X - w) -2,
                                  trunc(P.Y) -1,
                                  trunc(P.X + w) +2,
                                  trunc(P.Y) + 14 ), Col );

    AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y){-trunc(dy)}),
                                        str , cColor2(FntColor));

    if lstyle < 2 then
    if Selected then
    begin
      AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w-4,trunc(P.y){-trunc(dy)}),
                                        '[' , cColor2(SelColor));
      AsphFonts[Font0].TextOut(Point2(trunc(P.x)+w+2,trunc(P.y){-trunc(dy)}),
                                        ']' , cColor2(SelColor));
    end;
  end;

const
  AMax = 256;

var i, j, k, w, dy :Integer;

    P :TMyPoint;

    canLabel: Boolean;
    A: array [1..AMax] of TMyPoint;
    Asize : array [1..AMax] of Integer;
    ACount : integer;

    str : string;

    Sel:Boolean;
begin

 Acount :=0;
 //if (RouteCount = 0)and(FrameCount > 0) then

 if PMode = 30 then
 for I := 0 to Length(KnotPoints) - 1 do
     Begin
       P := MapToScreen(KnotPoints[i].cx, KnotPoints[i].cy);
       P.y := P.y - 18;

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       str := KnotPoints[i].Name;

       w := round(AsphFonts[Font0].TextWidth(str)/2);

       canlabel := true;
       if not DrawAll then

       for J := 1 to ACount do
          if (P.y > A[j].Y - 32)and(P.y < A[j].Y + 32) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;

       if not canlabel then
            continue;

       if Acount < AMax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;

       Sel := false;

       if CanLabel then
         LabelOut(P,w, str, sel)
     End;

 if FrameNumbers then
 for I := 0 to FrameCount - 2 do
 begin
   if PMode = 25 then
     if (I = FrameCount - 1) then
               continue;

    P := MapToScreen(FramePoints[i,1].x, FramePoints[i,1].y);
    P.y := P.y - 18;

    if not ( (P.x > - 16) and (P.x <  DispSize.X + 16) and
             (P.y > - 16) and (P.y <  DispSize.y + 16) ) then
                continue;

    w := round(AsphFonts[Font0].TextWidth(IntTostr(i+1)+'[]')/2);

    canlabel := true;
    if Not DrawAll then
    begin
      for J := 1 to ACount do
      if (P.y > A[j].Y - 8)and(P.y < A[j].Y + 24) then
       if (P.x+w > A[j].X - Asize[j]-5)and(P.x-w < A[j].X + Asize[j]+5) then
       begin
            canlabel := false;
            break;
       end;
    end;

    if not canlabel then
       continue;

    if Acount < AMax  then
       inc(Acount);



    A[Acount].X := P.x;
    A[Acount].Y := P.y;
    Asize[Acount] := w;

    dy := 0;// 16;

    str := '['+IntTostr(i+1)+']';

    Sel := false;
    if Length(SelectedFramePoints) > I then
       Sel := SelectedFramePoints[I];

    LabelOut(P, w, str, Sel);
    //   AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
    //                                    str ,cColor2(FntColor));


 end;

 if not FrameNumbers then
 for I := 0 to RouteCount - 1 do
   for k := 0 to Length(Route[i].WPT)-1  do
   Begin
      { case k of
         1: P := MapToScreen(Route[i].x1,Route[i].y1);
         2: P := MapToScreen(Route[i].x2,Route[i].y2);
       end;}

       if PMode = 26 then
         if (I = RouteCount - 1) and (k  = Length(Route[i].WPT)-1) then
               continue;

       P := MapToScreen(Route[i].WPT[K].x,Route[i].WPT[K].y);


       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       w := round(AsphFonts[Font0].TextWidth(Route[i].Name)/2);
       if PointNumbers then
          w := w +  round(AsphFonts[Font0].TextWidth(' ()'+intTostr(K+1))/2);


       canlabel := true;
       if not drawAll then
       begin
          for J := 1 to ACount do
          if (P.y > A[j].Y - 12)and(P.y < A[j].Y + 12) then                   {!!!!!!!!!!!19-03}
          if (P.x+w > A[j].X - Asize[j]-5)and(P.x-w < A[j].X + Asize[j]+5) then
          begin
            canlabel := false;
            break;
          end;
       end;

       if not canlabel then
            continue;

       if Acount<100 then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;
       str := Route[i].Name;
       dy := 0;// 16;

       Sel := false;

       if Length(SelectedRoutePoints) > 0 then
       if i < length(SelectedRoutePoints) then
         if k < length(SelectedRoutePoints[I]) then
              Sel := SelectedRoutePoints[I][k];

       if CanLabel then
       begin
        { case PointNumbers of
            true: AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
                                         Route[i].Name+' ('+intTostr(K+1)+')',cColor2(FntColor));

            false: AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
                                         Route[i].Name,cColor2(FntColor));
          end; }
          if PointNumbers then
               str := str + ' ('+intTostr(K+1)+')' ;
           LabelOut(P, w, str, Sel);
       end;
   End;

   for I := 0 to Length(Markers) - 1 do
     if (Markers[i].MarkerName<>'*') and (Pos('!#', Markers[I].MarkerName) <> 1) then
     Begin
       P := MapToScreen(Markers[i].x,Markers[i].y);
       P.y := P.y - 18;

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       w := round(AsphFonts[Font0].TextWidth(Markers[i].MarkerName)/2);

       canlabel := true;
       if not DrawAll then

       for J := 1 to ACount do
          if (P.y > A[j].Y - 32)and(P.y < A[j].Y + 32) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;

       if not canlabel then
            continue;

       if Acount < AMax then
         inc(Acount);

       A[Acount].X := P.x;
       A[Acount].Y := P.y;
       Asize[Acount] := w;

       Sel := false;

       if CanLabel then
         LabelOut(P,w, Markers[i].MarkerName, sel)
     End;


end;     *)



procedure DrawKnots(Col, NewCol, ChoosedCol, MenuColor, FntColor: Cardinal; LStyle :byte;
   Smooth:Boolean; BL1, BL2 :TLatLong; AllLabels, NewPickets:Boolean);
const
  AMax = 256;

var
    A: array [1..AMax] of TMyPoint;
    Asize : array [1..AMax] of Integer;
    ACount, sz : integer;
    minx, miny, maxx, maxy :Double;  Choosing:Boolean;

  procedure LabelOut(x, y :Double ; w: Integer; str : string; Selected: Boolean);
  var Col:TColor4;
  begin
     case Selected of
        false : Col := cColor4(MenuColor);
        true: Col := cColor4(ChoosedCol);
     end;

    if lstyle = 1 then
       AsphFonts[Font0].TextOut(Point2(trunc(x)-w+1,trunc(y)+1{-trunc(dy)}),
                                        str ,cRGB2(255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255,
                                                   255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255));


    if lstyle = 2 then
        AsphCanvas.FillRect(Rect (trunc(X - w) -2,
                                  trunc(Y) -1,
                                  trunc(X + w) +2,
                                  trunc(Y) + 14 ), Col );

    AsphFonts[Font0].TextOut(Point2(trunc(x)-w,trunc(y){-trunc(dy)}),
                                        str , cColor2(FntColor));

    if lstyle < 2 then
    if Selected then
    begin
      AsphFonts[Font0].TextOut(Point2(trunc(x)-w-4,trunc(y){-trunc(dy)}),
                                        '[' , cColor2(ChoosedCol));
      AsphFonts[Font0].TextOut(Point2(trunc(x)+w+2,trunc(y){-trunc(dy)}),
                                        ']' , cColor2(ChoosedCol));
    end;
  end;

  procedure LabelPoint(str: string; x,y :Double; Sel:Boolean);
  var canlabel: boolean;
      w, j : integer;
  begin

     if not ( (x > - 16)and(x <  DispSize.X + 16) and
       (y > - 16)and(y <  DispSize.y + 16) ) then
        exit;

     w := round(AsphFonts[Font0].TextWidth(str)/2);

     canlabel := true;
     if not AllLabels then
     begin
      for J := 1 to ACount do
       if (y > A[j].Y - 32)and(y < A[j].Y + 32) then
       if (x+w > A[j].X - Asize[j])and(x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;
     end;

     if not canlabel then
       exit;

     if Acount < AMax then
         inc(Acount);

     A[Acount].X := x;
     A[Acount].Y := y;
     Asize[Acount] := w+5;

     if CanLabel then
       LabelOut(x, y, w, str, sel)
  end;

  procedure CheckMinMax;
  var D:Double;
  Begin
   if minX > maxX then
   begin
     D := maxX;
     maxX := minX;
     minX := D;
   end;
   if minY > maxY then
   begin
     D := maxY;
     maxY := minY;
     minY := D;
   end;
   if (maxx = minx) and (maxy = miny) then
   Begin
      Choosing := true;
      maxx := maxx + sz;   maxy := maxy + sz;
      minx := minx - sz;   miny := miny - sz;
   End;

  End;

  function PreSel(I:integer; x, y:Double):boolean;
  var P1, P2:TMyPoint;
      j :integer;  Catch :Boolean;
  begin
    result := false;
    if I >= KnotCount then
       exit;
                                 // xvcxz
    j := Trunc({2*}KnotPoints[i].BoxSize/scale);
    P1.x := x - j;  P1.y := y - j;
    P2.x := x + j;  P2.y := y + j;

    if (P2.x > minX) and (P1.x < maxX) then
    if (P2.y > minY) and (P1.y < maxY) then
    begin

       if Choosing then
       BEGIN
          case KnotPoints[i].Shp of
             1: begin
                result := (sqrt(sqr(x - (minX + maxX)/2)+sqr(y - (minY + maxY)/2)) < j);
             end;
             else
             begin
                P1.x := x -(minX + maxX)/2;
                P1.y := y -(minY + maxY)/2;

                P2.x := P1.x*Cos(-KnotPoints[i].BoxAngle-fi)-P1.y*Sin(-KnotPoints[i].BoxAngle-fi);
                P2.y := P1.x*Sin(-KnotPoints[i].BoxAngle-fi)+P1.y*Cos(-KnotPoints[i].BoxAngle-fi);

                P1 := P2;
                P1.x := P2.x - abs(maxX-minX)/2;   P1.y := P2.y - abs(maxY-minY)/2;
                P2.x := P2.x + abs(maxX-minX)/2;   P2.y := P2.y + abs(maxY-minY)/2;

                result := (P2.x > - KnotPoints[i].BoxSize/scale/2) and (P1.x < KnotPoints[i].BoxSize/scale/2)
                  and (P2.y > - KnotPoints[i].BoxSize/scale/2) and (P1.y < KnotPoints[i].BoxSize/scale/2);
              end
          end
       END
       ELSE
          result := true
    end


    
  end;

var P: TMyPoint;
    csize, I, j : Integer;
    x, y, x2, y2, Ang_max, ang: Double;
    Color: Cardinal;
    Sel :boolean;
    str, str2 :string;
begin
  Choosing := false;
  P := BLToScreen(BL1.lat, BL1.long);
  minx := P.x; miny := P.y;
  P := BLToScreen(BL2.lat, BL2.long);
  maxx := P.x; maxy := P.y;
  sz := 0;
  if maxx = minx then
     sz := trunc(MouseSenseZone/2);
  CheckMinMax;

  for I := 0 to Length(KnotPoints) - 1 do
  try
     Sel := false;
     if I < KnotCount then
     begin
       Color := Col;
       Sel := false;
       for j := 0 to Length(SelectedKnots) - 1 do
          if SelectedKnots[j] = I then
             Sel := true;
       if Sel then Color := ChoosedCol;
     end
         else
           Color := NewCol - $0F000000 {- $AA000000};

     P := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
     csize := 12;
     if (not Sel) or ((Sel) and (KnotPoints[i].PMethod = 0)) then
     if (P.x > - csize) and (P.x < DispSize.X + csize) then
     if (P.y > - csize) and (P.y < DispSize.y + csize) then
         begin
             AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'],
                                        pxBounds4(0, 0, 16, 16));
             AsphCanvas.TexMap(pRotate4c(Point2(P.x, P.y),Point2(csize, csize), 0),
                    cColor4(Color));
         end;

     csize := 8;

     case KnotPoints[I].Shp of
        1: if (KnotPoints[I].BoxSize > 0) and (KnotPoints[I].ShStep > 0) then
        BEGIN
          Ang_max := (2*pi*KnotPoints[I].BoxSize) / KnotPoints[I].ShStep;

          if (Ang_max > 1000) or (Ang_max < 5) then
          begin
                x := P.x;
                y := P.y + KnotPoints[I].BoxSize/scale;

             for j := 0 to 16 do
             begin
               x2 := P.x + Sin(j*pi/8)*KnotPoints[I].BoxSize/scale;
               y2 := P.y + Cos(j*pi/8)*KnotPoints[I].BoxSize/scale;
               FatLine(AsphCanvas, x, y, x2, y2, 0, true, Smooth, Color);
               x := x2;
               y := y2;
             end;

          end
          else
          for j := 0 to trunc(Ang_max) do
          Begin
            x := P.x + Sin(-KnotPoints[I].BoxAngle + pi - j*(2*pi/Ang_max) - fi)
              *KnotPoints[I].BoxSize/scale;
            y := P.y + Cos(-KnotPoints[I].BoxAngle + pi - j*(2*pi/Ang_max) - fi)
              *KnotPoints[I].BoxSize/scale;
           if j < trunc(Ang_max) then
           begin
             x2 := P.x + Sin(-KnotPoints[I].BoxAngle + pi - (j+1)*(2*pi/Ang_max) - fi)
              *KnotPoints[I].BoxSize/scale;
             y2 := P.y + Cos(-KnotPoints[I].BoxAngle + pi - (j+1)*(2*pi/Ang_max) - fi)
              *KnotPoints[I].BoxSize/scale;
           end
           else
             begin
                 x2 := P.x + Sin(-KnotPoints[I].BoxAngle + pi - fi)
                     *KnotPoints[I].BoxSize/scale;
                 y2 := P.y + Cos(-KnotPoints[I].BoxAngle + pi - fi)
                     *KnotPoints[I].BoxSize/scale;
             end;
           if (x > - csize) and (x < DispSize.X + csize) then
           if (y > - csize) and (y < DispSize.y + csize) then
           begin
              AsphCanvas.UseImagePx(AsphImages.Image['dot.image'],
                                        pxBounds4(0, 0, 8, 8));
              AsphCanvas.TexMap(pRotate4c(Point2(x, y),Point2(csize, csize), 0),
                     cColor4(Color));
           end;
           sz := 0;
           if PreSel(I, P.x, P.y) then
             sz := 1;

           if Sel then
             FatLine(AsphCanvas, x, y, x2, y2, 1 + sz, false, Smooth, Color)
           else
             FatLine(AsphCanvas, x, y, x2, y2, sz, I > KnotCount, Smooth, Color)
          End;
        END;
        
       ELSE begin
        if KnotPoints[I].BoxSize > 0 then
        for j := 1 to 4 do
        begin
          if KnotPoints[I].Shp = 0 then
          begin
              x := P.x + Sin(-KnotPoints[I].BoxAngle + j*pi/2 + pi/4 - fi)*Sqrt(2)
                 *KnotPoints[I].BoxSize/2/scale;
              y := P.y + Cos(-KnotPoints[I].BoxAngle + j*pi/2 + pi/4 - fi)*Sqrt(2)
                 *KnotPoints[I].BoxSize/2/scale;
              x2 := P.x + Sin(-KnotPoints[I].BoxAngle+(j+1)*pi/2 + pi/4 - fi)*Sqrt(2)
                  *KnotPoints[I].BoxSize/2/scale;
              y2 := P.y + Cos(-KnotPoints[I].BoxAngle+(j+1)*pi/2 + pi/4 - fi)*Sqrt(2)
                  *KnotPoints[I].BoxSize/2/scale;
          end
           else
             begin
               ang := j * pi/2;
               case j mod 2 = 0 of
                  true:  ang := ang + arctan2(KnotPoints[I].BoxSize, KnotPoints[I].BoxSize2);
                  false: ang := ang + arctan2(KnotPoints[I].BoxSize2, KnotPoints[I].BoxSize);
               end;
                x := P.x + Sin(-KnotPoints[I].BoxAngle + ang - fi)
                    *Sqrt( sqr(KnotPoints[I].BoxSize/2) + sqr(KnotPoints[I].BoxSize2/2))
                    /scale;
                y := P.y + Cos(-KnotPoints[I].BoxAngle + ang - fi)
                    *Sqrt( sqr(KnotPoints[I].BoxSize/2) + sqr(KnotPoints[I].BoxSize2/2))
                    /scale;

               ang := (j+1) * pi/2;
               case (j+1) mod 2 = 0 of
                  true:  ang := ang + arctan2(KnotPoints[I].BoxSize, KnotPoints[I].BoxSize2);
                  false: ang := ang + arctan2(KnotPoints[I].BoxSize2, KnotPoints[I].BoxSize);
               end;
                x2 := P.x + Sin(-KnotPoints[I].BoxAngle + ang - fi)
                    *Sqrt( sqr(KnotPoints[I].BoxSize/2) + sqr(KnotPoints[I].BoxSize2/2))
                    /scale;
                y2 := P.y + Cos(-KnotPoints[I].BoxAngle + ang - fi)
                    *Sqrt( sqr(KnotPoints[I].BoxSize/2) + sqr(KnotPoints[I].BoxSize2/2))
                    /scale;

             end;

          if (x > - csize) and (x < DispSize.X + csize) then
          if (y > - csize) and (y < DispSize.y + csize) then
          begin
             AsphCanvas.UseImagePx(AsphImages.Image['dot.image'],
                                        pxBounds4(0, 0, 8, 8));
             AsphCanvas.TexMap(pRotate4c(Point2(x, y),Point2(csize, csize), 0),
                    cColor4(Color));
          end;
          sz := 0;
          if PreSel(I, P.x, P.y) then
            sz := 1;

          if Sel then
            FatLine(AsphCanvas, x, y, x2, y2, 1 + sz, false, Smooth, Color)
          else
            FatLine(AsphCanvas, x, y, x2, y2, sz, I > KnotCount, Smooth, Color)
        end;


     end;
     end;


  except
  end;

  if NewPickets then
  for I := KnotCount to Length(KnotPoints) - 1 do
  Begin
     Color := NewCol;
     GetKnotPickets(KnotPoints[I], false);
     csize := 6;

     for j := 0 to PktCount - 1 do
     begin
       P := MapToScreen(KnotPoints[i].Cx + Pkt[j].X,
                KnotPoints[i].Cy + Pkt[j].y);

       if ( P.x > - csize) and ( P.x < DispSize.X + csize) then
       if ( P.y > - csize) and ( P.y < DispSize.y + csize) then
       begin
           AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'],
                                  pxBounds4(0, 0, 16, 16));
           AsphCanvas.TexMap(pRotate4c(Point2(P.x, P.y),Point2(csize, csize), 0),
                 cColor4(Color));
       end;
     end;
  End;


  Acount :=0;
  for I := 0 to Length(KnotPoints) - 1 do
  begin
   Sel := false;
    for j := 0 to Length(SelectedKnots) - 1 do
      if SelectedKnots[j] = I then
         Sel := true;


    P := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
    p.y := P.y - 18;
    case KnotPoints[I].NameKind of
      0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
      2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
      3,4 : str := FormatFloat('000', KnotPoints[I].L);
    end;


    if Sel = false then
    begin

      // LabelPoint(str, P.x, P.y, Sel);

    end
    else
      begin
         {case KnotPoints[I].NameKind  of
            str2 := str + '_Pkt' + FormatFloat('000', 0);
            str2 := str + '_K' + FormatFloat('000', 0);
         end;

          str2 := str + '_Pkt' + FormatFloat('000', 0);
          LabelPoint(str2, P.x, P.y, Sel);  }

          Color := ChoosedCol;
          GetKnotPickets(KnotPoints[I], false);

          if (KnotPoints[I].PMethod = 0) and (KnotPoints[I].DropToRoute) then
            if PktCount > 0 then
            begin
               if KnotPoints[I].Ly = 0 then
                  j := PktCount div 2
               else
                  j := 0;

               P := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
               x := P.x; y:= P.y;
               P := MapToScreen(KnotPoints[i].Cx + Pkt[j].X,
                    KnotPoints[i].Cy+ Pkt[j].y);
               x2 := P.x;    y2:= P.y;

               if abs(x - x2) + abs(y - y2) > 0 then
                 MyLine(AsphCanvas, x, y, x2, y2, true, Smooth, Color)
            end;


          if length(SelectedKnots) = 1 then
            csize := 12
          else
            csize := 8;

          for j := 0 to PktCount - 1 do
          begin
             P := MapToScreen(KnotPoints[i].Cx + Pkt[j].X,
                   KnotPoints[i].Cy+ Pkt[j].y);
             if ( P.x > - csize) and ( P.x < DispSize.X + csize) then
             if ( P.y > - csize) and ( P.y < DispSize.y + csize) then
             begin
                 AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'],
                                        pxBounds4(0, 0, 16, 16));
                 AsphCanvas.TexMap(pRotate4c(Point2(P.x, P.y),Point2(csize, csize), 0),
                    cColor4(Color));
             end;
          end;

          if length(SelectedKnots) = 1 then
          for j := 0 to PktCount - 1 do
          begin
             P := MapToScreen(KnotPoints[i].Cx + Pkt[j].X,
                   KnotPoints[i].Cy+ Pkt[j].y);

             if ( P.x > - csize) and ( P.x < DispSize.X + csize) then
             if ( P.y > - csize) and ( P.y < DispSize.y + csize) then
             begin
                str2 := Pkt[j].Name;
                LabelPoint(str2, P.x, P.y-18, Sel);
             end;
          end;


          P := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
          if length(SelectedKnots) = 1 then
          case KnotPoints[i].Shp of
            1: begin
               Ang_max := (2*pi*KnotPoints[I].BoxSize) / KnotPoints[I].ShStep;
               if (Ang_max <= 1000) and (Ang_max >= 5) then
               for j := 0 to trunc(Ang_max) do
               begin
                x := P.x + Sin(-KnotPoints[I].BoxAngle + pi -  j*(2*pi/Ang_max) - fi)
                  *KnotPoints[I].BoxSize/scale;
                y := P.y + Cos(-KnotPoints[I].BoxAngle + pi -  j*(2*pi/Ang_max) - fi)
                  *KnotPoints[I].BoxSize/scale;
                str2 := str + '_K' + IntToStr(j+1);
                LabelPoint(str2, x, y-18, Sel);
               end;
            end;
            else begin
               for j := 1 to 4 do
               begin
                x := P.x + Sin(-KnotPoints[I].BoxAngle - j*pi/2 - pi/4 - fi)*Sqrt(2)
                 *KnotPoints[I].BoxSize/2/scale;
                y := P.y + Cos(-KnotPoints[I].BoxAngle - j*pi/2 - pi/4 - fi)*Sqrt(2)
                 *KnotPoints[I].BoxSize/2/scale;
                str2 := str + '_K' + IntToStr(j);
                LabelPoint(str2, x, y-18, Sel);
               end;


            end;

          end;

         


         // if length(SelectedKnots) > 1 then
         //    LabelPoint(str, P.x, P.y, Sel);
      end;

  end;

 { for I := 0 to Length(SelectedKnots) - 1 do
    if (SelectedKnots[I] >= 0) and (SelectedKnots[I] < Length(KnotPoints)) then
    begin

       P := MapToScreen(KnotPoints[SelectedKnots[I]].Cx,
                        KnotPoints[SelectedKnots[I]].Cy);
       p.y := P.y - 18;
       case KnotPoints[SelectedKnots[I]].NameKind of
         0, 1: str := KnotPoints[SelectedKnots[I]].Name + '_L'
                      + FormatFloat('000', KnotPoints[SelectedKnots[I]].L);
         2 : str := 'L' +FormatFloat('000', KnotPoints[SelectedKnots[I]].L);
         3, 4 : str := FormatFloat('000', KnotPoints[SelectedKnots[I]].L);
       end;

    end;   }

  for I := 0 to Length(KnotPoints) - 1 do
  begin
   Sel := false;
    for j := 0 to Length(SelectedKnots) - 1 do
      if SelectedKnots[j] = I then
         Sel := true;

    P := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
    p.y := P.y - 18;
    case KnotPoints[I].NameKind of
      0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
      2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
      3,4 : str := FormatFloat('000', KnotPoints[I].L);
    end;

    LabelPoint(str, P.x, P.y, Sel);
  end;

end;

procedure SelectFramePoints(P1, P2 :TMyPoint;  DelMode: boolean);
var I:Integer;
    TmpXY : Double; P :TMyPoint;
begin
   if FrameCount < 1 then
      exit;

   if P1.X > P2.X then
   begin
     TmpXY := P2.X;
     P2.X := P1.x; P1.x := TmpXY;
   end;
   if P1.Y > P2.Y then
   begin
     TmpXY := P2.Y;
     P2.Y := P1.Y; P1.Y := TmpXY;
   end;

  P1.x :=  P1.x - MouseSenseZone;//*Scale;
  P1.y :=  P1.y - MouseSenseZone;//*Scale;
  P2.x :=  P2.x + MouseSenseZone;//*Scale;
  P2.y :=  P2.y + MouseSenseZone;//*Scale;

   for I := 0 to FrameCount - 1 do
   begin
      P := MapToScreen(FramePoints[I,1].x, FramePoints[I,1].y);
      if (P.x > P1.X)and (P.x < P2.X) then
        if (P.y > P1.y)and (P.y < P2.y) then
          if Length(SelectedFramePoints) > I then
             SelectedFramePoints[I] := not DelMode;
   end;

   SelectedFramePointsCount := 0;
   for I := 0 to length(SelectedFramePoints) - 1 do
     if SelectedFramePoints[I] then
       inc(SelectedFramePointsCount);

   if (SelectedFramePoints[0])and(SelectedFramePoints[length(SelectedFramePoints) - 1]) then     /// 1st + last
       dec(SelectedFramePointsCount);
              
end;

procedure SelectFramePoints(L1, L2 :TLatLong;  DelMode: boolean);
var P1, P2 :TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  P2 := BLToScreen(L2.lat, L2.long);
  SelectFramePoints(P1,P2,DelMode);
end;

procedure SelectFramePoints(L1: TLatLong; DelMode: boolean);
var P1:TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  SelectFramePoints(P1,P1, DelMode);
end;

function SelectFrameSide(x, y: real):integer;
var I:integer;
    P1, P2: TMyPoint;
    PD: TPosAndDist;
    MinDist: integer;
begin
   Result := -1;
   MinDist := 10;
   for I := 1 to FrameCount - 1 do
   Begin
      P1 := MapToScreen(FramePoints[I-1,1].x,FramePoints[I-1,1].y);
      P2 := MapToScreen(FramePoints[I,1].x,FramePoints[I,1].y);

      PD:= GetPosAndDist(P1.x, P1.y, P2.x, P2.y, x, y);
      if (PD.Pos >=0) and (PD.Pos <=1) then
         if PD.Dist < MinDist then
         Begin
            MinDist := trunc(PD.Dist);
            Result := i;
         End;
   End;
end;

function SelectFrameSide(P :TMyPoint):integer;
begin
   Result := SelectFrameSide(P.x, P.y);
end;


procedure SelectRoutesPoints(P1, P2 :TMyPoint;  DelMode: boolean; RouteN: Integer);
var I, J, i1, i2, n :Integer;
    TmpXY : Double;  P :TMyPoint;
begin
   if RouteCount < 1 then
      exit;

   if P1.X > P2.X then
   begin
     TmpXY := P2.X;
     P2.X := P1.x; P1.x := TmpXY;
   end;
   if P1.Y > P2.Y then
   begin
     TmpXY := P2.Y;
     P2.Y := P1.Y; P1.Y := TmpXY;
   end;

  P1.x :=  P1.x - MouseSenseZone{*Scale};
  P1.y :=  P1.y - MouseSenseZone{*Scale};
  P2.x :=  P2.x + MouseSenseZone{*Scale};
  P2.y :=  P2.y + MouseSenseZone{*Scale};

  i1 := 0;
  i2 := RouteCount-1 ;
  if RouteN >= 0 then
  Begin
     if RouteN > RouteCount then
        exit
          else
          begin
             i1 := RouteN;
             i2 := RouteN;
          end;
  End;

  AlreadySelected := false;

  for I := i1 to i2 do
    for J := 0 to Length(Route[I].WPT) do
    try
      if i < length(SelectedRoutePoints) then
              if j < length(SelectedRoutePoints[I]) then
              begin
                P := MapToScreen(Route[I].WPT[J].x, Route[I].WPT[J].y);   {06-02-2022}
                if (P.x > P1.X) and (P.x < P2.X) then
                if (P.y > P1.y)and (P.y < P2.y) then
                    SelectedRoutePoints[I][J] := not DelMode;
              end;

    except

    end;

   n := -1;

   SelectedRoutePointsCount := 0;
   SelectedRoutesCount := 0;
   SelectedRouteN := -1;

   for I := i1 to i2 do
    for J := 0 to Length(Route[I].WPT)-1 do
      if SelectedRoutePoints[I][J] then
      Begin
         inc(SelectedRoutePointsCount);

         if I<>n then
         begin
            n := I;
            Inc(SelectedRoutesCount);
            if SelectedRoutesCount = 1 then
              SelectedRouteN := I;
         end;
      End;

end;

procedure SelectRoutesPoints(L1, L2 :TLatLong;  DelMode: boolean; RouteN:integer);
var P1, P2 :TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  P2 := BLToScreen(L2.lat, L2.long);
  SelectRoutesPoints(P1, P2, DelMode, RouteN);
end;

procedure SelectRoutesPoints(L1: TLatLong; DelMode: boolean; RouteN:integer);
var P1:TMyPoint;
begin
  P1 := BLToScreen(L1.lat, L1.long);
  SelectRoutesPoints(P1, P1, DelMode, RouteN);
end;


procedure SelectRoutes(P1, P2 :TMyPoint;  DelMode: boolean);
var I, J, n, Rx, Ry, Rxmax, Rymax  :Integer;
    TmpXY, iX, iY : Double;
    RL : Array of Integer;
    added: boolean;
    

    procedure TestAndAdd(x, y : real; RouteN: Integer);
    var P: TMyPoint;
    begin
        P:= MapToScreen(x,y);
          if (RouteUnderMouse(P.x, P.y, RouteN, MouseSenseZone div 2)) then
          begin
            Setlength(RL, Length(RL)+1);
            RL[Length(RL)-1] := RouteN;
            added := true;
          end;
    end;

begin
   if RouteCount < 1 then
      exit;

   if P1.X > P2.X then
   begin
     TmpXY := P2.X;
     P2.X := P1.x; P1.x := TmpXY;
   end;
   if P1.Y > P2.Y then
   begin
     TmpXY := P2.Y;
     P2.Y := P1.Y; P1.Y := TmpXY;
   end;

  Rxmax := trunc( (P2.X - P1.X) / (MouseSenseZone*Scale));
  Rymax := trunc( (P2.Y - P1.Y) / (MouseSenseZone*Scale));

  SetLength(RL,0);
  for I := 0 to RouteCount - 1 do
  try
    added := false;
    ix := P1.x;
    iy := P1.y;

    for RX := 0 to RXmax Do
    Begin
      for RY := 0 to RYmax Do
       Begin
          ix := P1.x + Rx*MouseSenseZone*Scale;
          if Rx = Rxmax then
             ix := P2.x;

          iy := P1.y + RY*MouseSenseZone*Scale;
          if RY = RYmax then
             iy := P2.y;

          TestAndAdd(ix, iy, I);

          if added then
             break;
       End;

       if added then
          break;
    End;

    { repeat
       repeat
          TestAndAdd(ix, iy, I);

          iy := iy + MouseSenseZone*Scale*2;

          if added then
             break;

          if iy >= p2.y  then
              TestAndAdd(ix, p2.y, I);

       until (iy >= p2.y) or (added) ;

       ix := ix + MouseSenseZone*Scale*2;

       if added then
         break;

       if ix >= p2.y  then
          TestAndAdd(p2.x, iy, I);
       iy := P1.y;
       
    until (ix >= p2.x) or (added) ;  }

  except
  end;


  for I := 0 to length(RL) - 1 do
  try

    for J := 0 to Length(Route[RL[I]].WPT)-1 do
         SelectedRoutePoints[RL[I]][J] := not DelMode;

  except
  end;

 { AlreadySelected := false;

  for I := i1 to i2 do
    for J := 0 to Length(Route[I].WPT) do
    try
      if i < length(SelectedRoutePoints) then
              if j < length(SelectedRoutePoints[I]) then
                if (Route[I].WPT[J].x > P1.X) and (Route[I].WPT[J].x < P2.X) then
                if (Route[I].WPT[J].y > P1.y)and (Route[I].WPT[J].y < P2.y) then
                    SelectedRoutePoints[I][J] := not DelMode;

    except

    end;

   n := -1;

   SelectedRoutePointsCount := 0;
   SelectedRoutesCount := 0;
   SelectedRouteN := -1;

   for I := i1 to i2 do
    for J := 0 to Length(Route[I].WPT)-1 do
      if SelectedRoutePoints[I][J] then
      Begin
         inc(SelectedRoutePointsCount);

         if I<>n then
         begin
            n := I;
            Inc(SelectedRoutesCount);
            if SelectedRoutesCount = 1 then
              SelectedRouteN := I;
         end;
      End; }

    for I := 0 to RouteCount-1 do
    for J := 0 to Length(Route[I].WPT)-1 do
      if SelectedRoutePoints[I][J] then
      Begin
         inc(SelectedRoutePointsCount);

         if I<>n then
         begin
            n := I;
            Inc(SelectedRoutesCount);
            if SelectedRoutesCount = 1 then
              SelectedRouteN := I;
         end;
      End;
end;

procedure SelectRoutes(L1, L2 :TLatLong;  DelMode: boolean);
var P1, P2 :TMyPoint;
begin
  P1 := BLToMap(L1.lat, L1.long);
  P2 := BLToMap(L2.lat, L2.long);
  SelectRoutes(P1,P2,DelMode);
end;

procedure SelectRoutes(L1: TLatLong; DelMode: boolean);
var P1:TMyPoint;
begin
  P1 := BLToMap(L1.lat, L1.long);
  SelectRoutes(P1,P1, DelMode);
end;

procedure FrameToGeo;
var i :integer;
    L : TLatLong;
Begin
 for I := 0 to FrameCount - 1 do
   begin
      L := MapToBL(FramePoints[i,1].x,FramePoints[i,1].y);
      FramePoints[i,2].x := L.lat;
      FramePoints[i,2].y := L.Long;
      FrameGeo := True;
   end;

  // RecomputeRoutes;
End;

procedure MarkersToGeo;
var i :integer;
    L : TLatLong;
Begin
 for I := 0 to Length(Markers) - 1 do
   begin
      L := MapToBL(Markers[i].x, Markers[i].y);
      Markers[i].Gx := L.lat;
      Markers[i].Gy := L.Long;
   end;
End;

procedure AnalyseUDF(FN:String; uCS, uDatum: integer; isDatum,
        skipH, ROrder: boolean;  var X, Y, H, B, L, RMSp, RMSh :Double);

  procedure GetBL(x, y, z: Double; var B, L, H : Double);
  begin
       WGS := FindDatum('WGS84') ;

       if isDatum = false then
       begin /// RouteCS - C?
            if  CoordinateSystemList[uCS].ProjectionType <=1 then
                CoordinateSystemToDatum(uCS, x, y, z, B, L, H)
                else
                   CoordinateSystemToDatum(uCS, y, x, z, B, L, H);
            if CoordinateSystemList[uCS].DatumN <> WGS then
              Geo1ForceToGeo2(B, L, H,  CoordinateSystemList[uCS].DatumN,
                              WGS, B, L, H);
       end
          else
            begin
              /// RouteCS - ??? ????????
              case uCS of
                 0: begin
                     B := x;  L := y;
                     if uDatum <> WGS then
                       Geo1ForceToGeo2( x, y, z, uDatum, WGS, B, L, H);
                    end;
                 1: begin
                     ECEFToGeo(uDatum, x, y, z, B, L, H);
                     if uDatum <> WGS then
                       Geo1ForceToGeo2( B, L, z, uDatum, WGS, B, L, H);
                    end;
                 2: begin
                     GaussKrugerToGeo(uDatum, y, x, B, L);
                     if uDatum <> WGS then
                        Geo1ForceToGeo2( B, L, z, uDatum, WGS, B, L, H);
                    end;
                 3,4: begin
                     UTMToGeo(uDatum, y, x, RoutesCS = 4, B, L);
                     if uDatum <> WGS then
                        Geo1ForceToGeo2( B, L, z, uDatum, WGS, B, L, H);
                   end;
                 end;

              end;
  end;


var UDF :TUDF;
    I :Integer;
    ax, ay, ah, Hi :Double;
    P: TMyPoint;   Ll: TLatLong;
begin
  OpenUdfFile(FN, Udf);

  X := 0; Y:= 0; H := 0; B := 0; L := 0; RMSp := 0; RMSh := 0;

  if UDF.DataCount = 0 then
     exit;

  aX := 0; aY:= 0; aH := 0;

  for I := 0 to Udf.DataCount - 1 do
  begin
    if not ROrder then
       GetBL(Udf.Data[I].y, Udf.Data[I].x, Udf.Data[I].z, B, L, Hi)
    else
       GetBL(Udf.Data[I].x, Udf.Data[I].y, Udf.Data[I].z, B, L, Hi);

    if SkipH then
       Hi := Udf.Data[I].z;

    if WaitForZone then
      MyZone := UTMZonebyPoint(B, L);

    P := BLToMap(B, L);

    x := x + Udf.Data[I].x;
    y := y + Udf.Data[I].y;
    h := h + {Udf.Data[I].Z} Hi;

    ax := ax + P.x;
    ay := ay + P.y;
    ah := ah + hi;
  end;

  X := x / UDF.DataCount;
  Y := y / UDF.DataCount;
  H := h / UDF.DataCount;

  if not ROrder then
  begin
    P.X := X;
    X := Y;
    Y := P.X;
  end;

  aX := ax / UDF.DataCount;
  aY := ay / UDF.DataCount;
  aH := ah / UDF.DataCount;

  Ll := MapToBL(aX, aY);
  B := Ll.lat; L := Ll.long;

  if UDF.DataCount < 2 then
     exit;

  for I := 0 to Udf.DataCount - 1 do
  begin
    if not ROrder then
       GetBL(Udf.Data[I].y, Udf.Data[I].x, Udf.Data[I].z, B, L, H)
    else
       GetBL(Udf.Data[I].x, Udf.Data[I].y, Udf.Data[I].z, B, L, H);
    if SkipH then
       H := Udf.Data[I].Z;
    P := BLToMap(B, L);

    RMSp := RMSp + sqr(sqrt(sqr(ax - p.x)+sqr(ay - p.y)));
    RMSh := RMSh + sqr(h - aH);
  end;

  RMSp := sqrt(RMSp/(Udf.DataCount-1));
  RMSh := sqrt(RMSh/(Udf.DataCount-1));

  Ll := MapToBL(aX, aY);
  B := Ll.lat; L := Ll.long;
end;


procedure UDFToMarker(FN:String; uCS, uDatum: integer; isDatum,
     skipH, ROrder: boolean);
var I : Integer;
    x, y, h, b, l, rmsp, rmsh :Double;
    s:String;
begin
  AnalyseUDF(FN, uCS, uDatum, isDatum, skipH, ROrder,
      X, Y, H, B, L, RMSp, RMSh);

  s := ExtractFileName(FN);
  s := copy(s, 1, length(s)-4);
  AddMarker(s, B, L, H, H, 0);
  Markers[Length(Markers)-1].MarkerKind := 10;
  Markers[Length(Markers)-1].Add1 := RMSp;
  Markers[Length(Markers)-1].Add2 := RMSh;
  Markers[Length(Markers)-1].H    := H;

  Markers[Length(Markers)-1].HGeo := 0;
  if SkipH then
  Begin
     Markers[Length(Markers)-1].HGeo := H;
     if H = 0 then
       Markers[Length(Markers)-1].HGeo := 0.0001; {?????????? ??????}
  End;
end;

function GetMarkerKnotCenter(Mname :string; var x, y : Double) :boolean;
var I, j: integer;
    found: boolean;
begin
  x := 0; y := 0;
  for j := 1 to 4 do
  begin

    for I := 0 to Length(Markers) - 1 do
    begin
      found := false;
    //  showmessage(AnsilowerCase(Mname)+'_k'+IntTostr(j));
      if AnsilowerCase(Mname)+'_k'+IntTostr(j) =
         AnsilowerCase(Markers[I].MarkerName)
       then
       begin
         found := true;
         x := x + Markers[I].x / 4;
         y := y + Markers[I].y / 4;
         break;
       end;
    end;

    if not found then
       break;
  end;

  if not found then
  begin
    x := 0;
    y := 0;
  end;

  result := found;

end;

procedure FindPointsForFrame(P: TMyPoint);
var I:integer;
    Lmin, L : real;
    PD: TPosAndDist;
begin

 RefPointsFound := false;
 try
   Lmin := -1;
   for I := 0 to FrameCount - 2 do
   Begin
      PD := GetPosAndDist(FramePoints[I,1].x, FramePoints[I,1].y,
                          FramePoints[I+1,1].x, FramePoints[I+1,1].y,
                          PointToAdd.x, PointToAdd.y);

      if ( ((Lmin=-1)or(PD.Dist < Lmin)) and (PD.Pos >= 0) and (PD.Pos <= 1) ) then
      begin
         /// Test for lines
         Lmin := PD.Dist;
         RefPointsFound := true;
         PointToAddNum := I;
         PointToAddRefPoints[1].x := FramePoints[I,1].x;
         PointToAddRefPoints[1].y := FramePoints[I,1].y;
         PointToAddRefPoints[2].x := FramePoints[I+1,1].x;
         PointToAddRefPoints[2].y := FramePoints[I+1,1].y;
      end
        else
        begin
      /// Test for points
         L :=  Sqrt(sqr(FramePoints[I,1].x-PointToAdd.x)+sqr(FramePoints[I,1].y-PointToAdd.y));
         if (L < Lmin)or(Lmin = -1) then
         begin
           Lmin := L;
           PointToAddNum := I;
           RefPointsFound := true;
           PointToAddRefPoints[1].x := FramePoints[I,1].x;
           PointToAddRefPoints[1].y := FramePoints[I,1].y;
           PointToAddRefPoints[2].x := FramePoints[I+1,1].x;
           PointToAddRefPoints[2].y := FramePoints[I+1,1].y;
         end;
        end;
   End;
 except
   //RefPointsFound := false;
 end;
end;

procedure FindPointsForFrame(L: TLatLong);
var P:TMyPoint;
begin
  P := BLToMap(L.lat, L.long);
  FindPointsForFrame(P);
end;

function DropPointToFrame(P: TMyPoint):TMyPoint;
var  PD: TPosAndDist;
     I: Integer;
begin
   Result := P;

   I:= PointToAddNum;

   if (RefPointsFound = False) or (I < 0) or ( I >= FrameCount) then
     exit;

   PD := GetPosAndDist(FramePoints[I,1].x, FramePoints[I,1].y,
                          FramePoints[I+1,1].x, FramePoints[I+1,1].y,
                          P.x, P.y);

   if (PD.Pos >= 0)and(PD.Pos <= 1) then
   Begin
     Result.x := PD.x;
     Result.y := PD.y;
   End;

end;

function DropPointToRoute(P: TMyPoint):TMyPoint;
var  PD: TPosAndDist;
     I, J, Jo: Integer;
begin
   Result := P;

   I:= PointToAddRouteNum;
   J:= PointToAddNum;

   if (I > RouteCount-1) or (I<0) then
     exit;

   Jo := J;

   if J = -1 then
      J := 0;

   if J = length(Route[I].WPT)-1 then
      J := length(Route[I].WPT)-2;


   if (RefPointsFound = False) or (J < 0) or ( J >= length(Route[I].WPT)-1) then
     exit;

   PD := GetPosAndDist(Route[I].WPT[J].x, Route[I].WPT[J].y,
                          Route[I].WPT[J+1].x, Route[I].WPT[J+1].y,
                          PointToAdd.x, PointToAdd.y);

   if ((PD.Pos >= 0)and(PD.Pos <= 1)) or
      ((Jo = -1)or(Jo = length(Route[I].WPT)-1)) then
   Begin
     Result.x := PD.x;
     Result.y := PD.y;
   End;

   HasDropPoint := true;
   DropPoint := Result;
end;

function DropPointToRoute(L: TLatLong):TMyPoint;
var P:TMyPoint;
begin
  P := BLToMap(L.lat, L.long);
  Result := DropPointToRoute(P);
end;

function DropPointToFrame(L: TLatLong):TMyPoint;
var P:TMyPoint;
begin
  P := BLToMap(L.lat, L.long);
  Result := DropPointToFrame(P);
end;

function DropPointToPoint(P: TMyPoint; Sens, EdMode: Integer):TMyPoint;
var  MinD: real;
     I, J: Integer;
begin
   Result := P;
   HasDropPoint := False;
   
   for I := 0 to FrameCount - 1 do
   Begin
      if (Abs(P.x-FramePoints[I,1].x) <= Sens*Scale) and
         (Abs(P.y-FramePoints[I,1].y) <= Sens*Scale) then
         if not ( (EdMode = 25) and (I =  FrameCount - 1) ) then
         if not (EdMode = 27) then
         if not ( (EdMode = 22) and (SelectedFramePoints[I])) then
         Begin
            Result.x := FramePoints[I,1].x;
            Result.y := FramePoints[I,1].y;

            HasDropPoint := True;
            DropPoint := Result;

            exit;
         End;
   End;

   for I := 0 to RouteCount - 1 do
   Begin
     for J := 0 to length(Route[I].WPT) - 1 do
        if (Abs(P.x-Route[I].WPT[J].x) <= Sens*Scale) and
           (Abs(P.y-Route[I].WPT[J].y) <= Sens*Scale) then
         if not ((EdMode = 26) and
                ((J = length(Route[I].WPT) - 1) and (I = RouteCount - 1))) then
         if not ((EdMode = 28) and
                ((I = PointToAddRouteNum))) then
         if not ( (EdMode = 24) and (SelectedRoutePoints[I][J])) then       
         Begin
            Result.x := Route[I].WPT[J].x;
            Result.y := Route[I].WPT[J].y;
           
            HasDropPoint := True;
            DropPoint := Result;

            exit;
         End;

   End;

   for I := 0 to Length(Markers) - 1 do
   Begin
      if (Abs(P.x-Markers[I].x) <= Sens*Scale) and
         (Abs(P.y-Markers[I].y) <= Sens*Scale) then
         Begin
            Result.x := Markers[I].x;
            Result.y := Markers[I].y;
           
            HasDropPoint := True;
            DropPoint := Result;

            exit;
         End;
   End;

  
end;

function DropPointToLoop(P: TMyPoint; Sens, EdMode: Integer):TMyPoint;
var  MinD: real;
     I, J: Integer;  P2: TMyPoint;
begin
   Result := P;
   HasDropPoint := False;

   //P2 := MapToScreen(P.x, P.y);

   for I := 0 to KnotCount - 1 do
   Begin
      if (Abs(P.x-KnotPoints[I].cx) <= Sens*Scale) and
         (Abs(P.y-KnotPoints[I].cy) <= Sens*Scale) then
         Begin
            Result.x := KnotPoints[I].cx;
            Result.y := KnotPoints[I].cy;

            HasDropPoint := True;
            DropPoint := Result;

            exit;
         End;
   End;

   if not HasDropPoint  then
   for I := 0 to KnotCount - 1 do
   for j := 0 to 3 do
   Begin
      P2.x := KnotPoints[I].cx +
            Sin(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;
      P2.y := KnotPoints[I].cy +
            Cos(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;

      if (Abs(P.x-P2.x) <= Sens*Scale) and
         (Abs(P.y-P2.y) <= Sens*Scale) then
         Begin
            Result.x := P2.x;
            Result.y := P2.y;

            HasDropPoint := True;
            DropPoint := Result;

            exit;
         End;
   End;

   if Length(SelectedKnots) > 0 then
   if not HasDropPoint  then
     for I := 0 to Length(SelectedKnots)-1 do
     Begin
       GetKnotPickets(KnotPoints[SelectedKnots[I]], false);
       for j := 0 to PktCount-1 do
       begin
          P2.x := KnotPoints[SelectedKnots[I]].cx + Pkt[j].x;
          P2.y := KnotPoints[SelectedKnots[I]].cy + Pkt[j].y;
          if (Abs(P.x-P2.x) <= Sens*Scale) and
             (Abs(P.y-P2.y) <= Sens*Scale) then
          Begin
            Result.x := P2.x;
            Result.y := P2.y;

            HasDropPoint := True;
            DropPoint := Result;

            exit;
          End;
       end;
     End;

end;

function DropPointToPoint(L: TLatLong; Sens, EdMode: Integer):TMyPoint;
var P:TMyPoint;
begin
  P := BLToMap(L.lat, L.long);
  Result := DropPointToPoint(P, Sens, EdMode);
end;

function FrameUnderMouse(sens :integer): boolean;
var I: Integer;
    PD: TPosAndDist;
    P1, P2 : TMyPoint;
Begin
   Result := false;
   AlreadySelected := false;

   for I := 1 to FrameCount - 1 do
   Begin
     P1 := MapToScreen(FramePoints[i-1,1].x,FramePoints[i-1,1].y);
     P2 := MapToScreen(FramePoints[i,1].x,FramePoints[i,1].y);

     PD := GetPosAndDist(P1.X, P1.Y, P2.X, P2.Y, CanvCursor.x, CanvCursor.y) ;

     Result := (PD.Dist <= Sens) and (PD.Pos > 0) and (PD.Pos <= 1);

     if SelectedFramePoints[I] then
       AlreadySelected := True;


     if Result then
        break;
   End;
End;

function MarkersUnderMouse(sens :integer): boolean;
var I, j: Integer;
    P : TMyPoint;
Begin
   Result := false;
   AlreadySelected := false;

   for j := 0 to Length(SelectedMarkers) - 1 do  {???????? ?????? ??????????}
   Begin
     I := SelectedMarkers[j];
     P := MapToScreen(Markers[i].x, Markers[i].y);
     Result := (abs(P.x-CanvCursor.x) <= Sens) and (abs(P.y - CanvCursor.y) <= Sens);
     AlreadySelected := True;

     if Result then
        break;
   End;
End;

function KnotsUnderMouse(sens :integer): boolean;
var I, j: Integer;
    P : TMyPoint;
Begin
   Result := false;
   AlreadySelected := false;

   for j := 0 to Length(SelectedKnots) - 1 do  {???????? ?????? ??????????}
   Begin
     I := SelectedKnots[j];
     P := MapToScreen(KnotPoints[i].Cx, KnotPoints[i].Cy);
     Result := (abs(P.x-CanvCursor.x) <= Sens) and (abs(P.y - CanvCursor.y) <= Sens);
     AlreadySelected := True;

     if Result then
        break;
   End;
End;

function RouteUnderMouse(Mx, My: Double; RouteN, sens :integer): boolean;

function NotLine(P1, P2: TMyPoint):boolean;
begin
    Result := (P1.x = P2.x) and (P1.y = P2.y);
end;

 var I: Integer;
    PD: TPosAndDist;
    P1, P2 : TMyPoint;
Begin
   Result := false;

   if RouteN > RouteCount-1 then
      exit;

   if length(Route[RouteN].WPT) = 0 then
      exit;

   if length(Route[RouteN].WPT) = 1 then
   begin
     P1 := MapToScreen(Route[RouteN].WPT[0].x,Route[RouteN].WPT[0].y);
     I := Trunc(abs(P1.x - Mx)+abs(P1.y - My));
     Result := I <= Sens*2;
   end
     else
   for I := 1 to Length(Route[RouteN].WPT)-1 do
   try
     P1 := MapToScreen(Route[RouteN].WPT[I-1].x, Route[RouteN].WPT[I-1].y);
     P2 := MapToScreen(Route[RouteN].WPT[I].x, Route[RouteN].WPT[I].y);

     Result := false;
     if notLine(P1, P2) then
     begin
        Result := Trunc(abs(P1.x - Mx)+abs(P1.y - My)) <= Sens*2;
     end
      else
      begin
        PD := GetPosAndDist(P1.X, P1.Y, P2.X, P2.Y, mx, my) ;
        Result := (PD.Dist <= Sens) and (PD.Pos > 0) and (PD.Pos <= 1);
      end;

     if Result then
        break;
   except
     //showmessage(intToStr(RouteN));
     Result := false;
   end;
End;

function RouteUnderMouse(RouteN, sens :integer): boolean;
Begin
   Result := RouteUnderMouse(CanvCursor.x,CanvCursor.y, RouteN, sens);
End;

function RoutePointUnderMouse(RouteN, PointN, sens :integer): boolean;
var I: Integer;
    PD: TPosAndDist;
    P : TMyPoint;
Begin
   Result := false;

   if RouteN > RouteCount-1 then
      exit;

   if PointN > Length(Route[RouteN].WPT)-1 then
      exit;

   P := MapToScreen(Route[RouteN].WPT[PointN].x,Route[RouteN].WPT[PointN].y);

   Result := (abs(P.x-CanvCursor.X) <= Sens) and (abs(P.y-CanvCursor.y) <= Sens);

End;

function CuttingPointUnderMouse(sens :integer): byte;
var I: Integer;
    PD: TPosAndDist;
    P : TMyPoint;
Begin
   Result := 0;

   for I := 1 to 2 do
   begin
     P := MapToScreen(CutPoints[I].x, CutPoints[I].y);
     if (abs(P.x-CanvCursor.X) <= Sens) and (abs(P.y-CanvCursor.y) <= Sens) then
        Result := I;
   end;

End;

procedure FindPointsForRoutes(P: TMyPoint; RouteN: Integer);
var I, J, i1, i2:integer;
    Lmin, L : real;
    PD: TPosAndDist;
begin

 PointToAddRouteNum := -1;

 RefPointsFound := false;
 try

    i1 := 0;
    i2 := RouteCount-1 ;
    if RouteN >= 0 then
    Begin
     if RouteN > RouteCount then
        exit
          else
          begin
             i1 := RouteN;
             i2 := RouteN;
          end;
    End;


   Lmin := -1;
   for I := I1 to I2 do
   for J := 0 to length(Route[I].WPT) - 1 do
   Begin
      if (Route[I].Status > 3) and (I1<>I2) then
          continue;

      if J < length(Route[I].WPT) - 1 then
      PD := GetPosAndDist(Route[I].WPT[J].x, Route[I].WPT[J].y,
                          Route[I].WPT[J+1].x, Route[I].WPT[J+1].y,
                          PointToAdd.x, PointToAdd.y);

      if ( ((Lmin=-1)or(PD.Dist < Lmin)) and (PD.Pos >= 0) and (PD.Pos <= 1) ) then
      begin
         if J < length(Route[I].WPT) - 1 then
         begin
         /// Test for lines
           Lmin := PD.Dist;
           RefPointsFound := true;
           PointToAddNum := J;
           PointToAddRouteNum:= I;
           PointToAddRefPoints[1].x := Route[I].WPT[J].x;
           PointToAddRefPoints[1].y := Route[I].WPT[J].y;
           PointToAddRefPoints[2].x := Route[I].WPT[J+1].x;
           PointToAddRefPoints[2].y := Route[I].WPT[J+1].y;
         end;
      end
        else
        begin
      /// Test for points
         L :=  Sqrt(sqr(Route[I].WPT[J].x-PointToAdd.x)+sqr(Route[I].WPT[J].y-PointToAdd.y));
         if ((L < Lmin)or(Lmin = -1)) then
         begin
           Lmin := L;
           PointToAddNum := J;
           PointToAddRouteNum:= I;
           RefPointsFound := true;
           PointToAddRefPoints[1].x := Route[I].WPT[J].x;
           PointToAddRefPoints[1].y := Route[I].WPT[J].y;
           if J = 0 then
           begin
             PointToAddRefPoints[2].x := Route[I].WPT[J].x;
             PointToAddRefPoints[2].y := Route[I].WPT[J].y;
             PointToAddNum:= -1;
           end
           else
           if J = length(Route[I].WPT) - 1 then
           begin
             PointToAddRefPoints[1].x := Route[I].WPT[J].x;
             PointToAddRefPoints[1].y := Route[I].WPT[j].y;
             PointToAddRefPoints[2].x := Route[I].WPT[J].x;
             PointToAddRefPoints[2].y := Route[I].WPT[j].y;
             PointToAddNum:= length(Route[I].WPT) -1;
           end
            else
            begin
              PointToAddRefPoints[2].x := Route[I].WPT[J+1].x;
              PointToAddRefPoints[2].y := Route[I].WPT[J+1].y;
            end;
         end;
        end;
   End;
 except
   //RefPointsFound := false;
 end;
end;

procedure FindPointsForRoutes(L: TLatLong; RouteN: Integer);
var P:TMyPoint;
begin
  P := BLToMap(L.lat, L.long);
  FindPointsForRoutes(P, RouteN);
end;

function PosAndDistToRoute(x,y: Double; RouteN:Integer):TRoutePosAndDist;

 function RPD(_PD:TPosAndDist):TRoutePosAndDist;
 var I:Integer;
 begin
   Result.Pos  := _PD.Pos;
   Result.Dist := _PD.Dist;
   Result.X    := _PD.X;
   Result.Y    := _PD.Y;
   Result.DistToV0 := _PD.DistTo0;
   Result.DistTo0 := _PD.DistTo0;
 end;

var PD, PDI :TPosAndDist;
    minD, PosToB, PosToE, PastSegs :real;
    I :Integer;
Begin
  Result.Dist := -1;
  Result.Seg  := -1;

  if (RouteN <0)or (RouteN > RouteCount-1) then
    exit;
  
  if Length(Route[RouteN].WPT)<1 then
    exit;

TRY

  if Length(Route[RouteN].WPT) = 1 then
  begin
    PD.Dist := sqrt(sqr(x-Route[RouteN].WPT[0].x)+ sqr(y-Route[RouteN].WPT[0].y));
    PD.DistTo0 := PD.Dist;
    PD.Pos := 0;
    PD.x := Route[RouteN].WPT[0].x;
    PD.y := Route[RouteN].WPT[0].y;
    Result.seg := 0;
    Result:= RPD(PD);
  end;

  if Length(Route[RouteN].WPT)> 1 then
  begin
    for i := 1 to Length(Route[RouteN].WPT) - 1 do
    begin
      /// STEP 1 - NEAREST LINE

      PDi := GetPosAndDist(Route[RouteN].WPT[I-1].x, Route[RouteN].WPT[I-1].y,
                           Route[RouteN].WPT[I].x, Route[RouteN].WPT[I].y,
                           x,y);

      if I = 1 then
      Begin
         PD := PDi;
         if (PDi.Pos>=0)and(PDi.Pos<=1) then
           MinD     := PDi.Dist
         else
           MinD :=-1;

         PosToB   := PDI.Pos;
      End;

      if I = Length(Route[RouteN].WPT) - 1 then
      begin
        PosToE := PDI.Pos;
      end;


      if ( ((PDi.Dist <= MinD)or(MinD=-1)) and (PDi.Pos>=0)and(PDi.Pos<=1))
          or (Length(Route[RouteN].WPT) = 2) then
      Begin
          PD := PDi;
          MinD := PDi.Dist;
          Result.Seg  := I-1;
          Result := RPD(PD);
      End;

    end;

    if (PD.Pos>=0)and(PD.Pos<=1) then
    begin
      Result := RPD(PD);
      //Result.DistToSeg0 := Result.DistTo0;
      //for I := 0 to Result.seg - 1 do
        
    end
        else
        if Length(Route[RouteN].WPT)> 2 then
        begin
          /// STEP 2 - NEAREST POINT IN CASE OF NO LINES!
          for i := 0 to Length(Route[RouteN].WPT) - 1 do
          Begin

            PDi.Dist := sqrt(sqr(x-Route[RouteN].WPT[i].x)+ sqr(y-Route[RouteN].WPT[i].y));
            PDi.DistTo0 := PDi.Dist;
            PDi.Pos := 0;
            PDi.x := Route[RouteN].WPT[i].x;
            PDi.y := Route[RouteN].WPT[i].y;

            if I = 0 then
            Begin
               PD := PDi;
               Result := RPD(PDi);
               Result.Seg  := 0;
               Result.Pos  := PosToB;
            End
               else
                 if PDi.Dist < PD.Dist then
                 Begin
                    PD := PDi;
                    Result := RPD(PDi);
                    Result.Seg  := I;
                    if I = Length(Route[RouteN].WPT) - 1 then
                       Result.Pos  := PosToE;
                 End;
           
          End;
          //Result := RPD(PD);
        end;
  end;     

  if Length(Route[RouteN].WPT) > 2 then
  Begin
    /// ??? ????
    Result.Pos := 1/Length(Route[RouteN].WPT)*(Result.seg+ Result.Pos);

  End;

  if Result.Seg > 0 then
  for I := 1 to Result.Seg do
  Result.DistToV0 := Result.DistToV0 +
      sqrt(sqr(Route[RouteN].WPT[I-1].x - Route[RouteN].WPT[I].x) +
           sqr(Route[RouteN].WPT[I-1].y - Route[RouteN].WPT[I].y) );

EXCEPT
  Result.Dist := -1;
END;

End;

procedure DrawSubCursor(ObjColor, DopObjColor, ChoosedColor: cardinal; Ticks: real);
var Col:TColor4;
    C: array [1..2] of TMyPoint;
begin
//  SubCursor := 2;
  if SubCursor< -1 then
  Begin
    AsphCanvas.UseImagePx(AsphImages.Image['ed_cur0.image'],
                                        pxBounds4(0, 0, 32, 32));
  case SubCursor of

      -7:  AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        cRGB4(255,0,
                        0, 180));

      -6:  AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        cRGB4(255,0,
                        0,100));

      -5:  AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        cRGB4(GetBValue(ObjColor),GetGValue(ObjColor),
                        GetRValue(ObjColor),100));

      -4:  AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        cRGB4(GetBValue(ObjColor),GetGValue(ObjColor),
                        GetRValue(ObjColor),180));


      -3:  AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        cRGB4(GetBValue(DopObjColor),GetGValue(DopObjColor),
                        GetRValue(DopObjColor),100));

      -2:  AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        cRGB4(GetBValue(DopObjColor),GetGValue(DopObjColor),
                        GetRValue(DopObjColor),180));
    End
  end
   Else
  if SubCursor > 0 then
  Begin
      AsphCanvas.UseImagePx(AsphImages.Image['ed_cur2.image'],
                                        pxBounds4(0, 0, 32, 32));

      AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), Ticks/31.415),
                        clWhite4);
  End
   Else
      if SubCursor = 0 then
      Begin
         AsphCanvas.UseImagePx(AsphImages.Image['ed_cur0.image'],
                                        pxBounds4(0, 0, 32, 32));

         AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.X, CanvCursor.Y),
                        Point2(32, 32), 0),
                        clWhite4);
      End;

  if SubCursor > 1 then
  Begin
      AsphCanvas.UseImagePx(AsphImages.Image['ed_cur'+intToStr(SubCursor+1)+'.image'],
                                        pxBounds4(0, 0, 16, 16));

      AsphCanvas.TexMap(pRotate4c(Point2(CanvCursor.x+12, CanvCursor.y+12),Point2(16, 16), 0),
                    clwhite4);
  End;

  if MultiSelectMode > 0 then
  Begin
     case MultiSelectMode of
       1, 2:  Col :=  cRGB4(0,255,0,100) ;
       3 :  Col :=  cRGB4(255,0,0,100);
     end;

     C[1] := BLToScreen(CanvCursorBL.lat, CanvCursorBL.long);
     C[2] := BLToScreen(CanvCursorBL0.lat,CanvCursorBL0.long);

     AsphCanvas.FillRect(Rect (trunc(C[1].x), trunc(C[1].y), trunc(C[2].x), trunc(C[2].y) ), Col );
  End;

end;

const minL = 10;
procedure DrawRuler(CurXY:TMyPoint; RColor, TxColor, MnColor: cardinal;
                      Ticks:real; Smooth, DrawAll, HideRuler, DrawAngle, isAzmt, DrawCur:Boolean);
var I, J :Integer;
    P1, P2, P0: TMyPoint;
    d : Double;
    rullabels:array [1..1000] of TPoint;
    rullabelsW:array [1..1000] of integer;
    w : integer;
    canlabel: boolean;
    ang0, ang1: Double;  s:String;
begin
  for I := 1 to RulCount - 1 do
  begin
    P1 := MapToScreen(RulPoints[I-1].x, RulPoints[I-1].y);
    P2 := MapToScreen(RulPoints[I].x, RulPoints[I].y);

    if not (HideRuler) then
    begin
      AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'], pxBounds4(0, 0, 16 , 16 ));

      AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(16, 16), 0),
                               cColor4(RColor));

      CutLineByFrame(P1.x, P1.y, P2.x, P2.y);
      FatLine(AsphCanvas, P1.x, P1.y , P2.x, P2.y, 1, true, Smooth, RColor);


      if (abs(P1.x-P2.x) > minL) or (abs(P1.y-P2.y) > minL) then
      begin
         //  a := arctan2(P2.y - P1.y, P2.x - P1.x);
         rullabels[I].X := trunc((P1.x+P2.x)/2 );// + 10*cos(a+pi/2));
         rullabels[I].Y := trunc((P1.y+P2.y)/2 );//+ 10*sin(a+pi/2));

         if RulLengths[I] < 10000 then
          s := Format('%.2n',[RulLengths[I]])+inf[40]
            else 
             s := Format('%.2n',[RulLengths[I]/1000])+inf[41];
             
         rullabelsW[I]:= round(AsphFonts[Font0].TextWidth(s));
      end
       else
        rullabelsW[I]:=  -1;
    end
      else
        rullabelsW[I]:=  -1;
  end;
                            
  for I := RulCount-1 Downto  1 do
  begin
      canlabel := true;
      
      if rullabelsW[I] = -1 then
         continue;
         
      if canlabel then
      for J :=  RulCount-1 downTo I+1 Do
      begin
         if rullabelsW[J] <> -1 then
         if not drawAll then
          if (rullabels[I].y > rullabels[j].Y - 32)and(rullabels[I].y < rullabels[j].Y + 64) then
          if     (rullabels[I].x + rullabelsW[I] > rullabels[j].X - rullabelsW[j])
              and(rullabels[I].x - rullabelsW[I] < rullabels[j].X + rullabelsW[j]) then
          begin
            canlabel := false;
            rullabelsW[I] := -1;
            break;
          end;
      end;  

      if canlabel then
      begin

        if RulLengths[I] < 10000 then 
        s := Format('%.2n',[RulLengths[I]])+inf[40]
          else 
             s := Format('%.2n',[RulLengths[I]/1000])+inf[41];

        AsphCanvas.FillRect(Rect (rullabels[I].X - trunc (rullabelsw[I]/2)-2,
                                  rullabels[I].Y - 2,
                                  rullabels[I].X + trunc (rullabelsw[I]/2)+2,
                                  rullabels[I].Y + 14 ), MnColor );
        AsphFonts[Font0].TextOut(Point2( rullabels[I].X - trunc (rullabelsw[I]/2), rullabels[I].Y),
                               s, cColor2(TxColor));
      end;

  end;

  P1 := MapToScreen(PointToAdd.x, PointToAdd.y);
  P2 := MapToScreen(RulPoints[RulCount-1].x, RulPoints[RulCount-1].y);
  if not (HideRuler) then
  begin
    if RulCount > 0 then
    Begin
      AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'], pxBounds4(0, 0, 16 , 16 ));

      AsphCanvas.TexMap(pRotate4c(Point2(P2.x, P2.y),Point2(16, 16), 0),
                               cColor4(RColor));

      FatLine(AsphCanvas, P2.x, P2.y, P1.x, P1.y, 1, true, Smooth, RColor);
    End;

    AsphCanvas.UseImagePx(AsphImages.Image['marker1.image'], pxBounds4(0, 0, 16 , 16 ));
    AsphCanvas.TexMap(pRotate4c(Point2(P1.x, P1.y),Point2(16, 16), 0),
                               cColor4(RColor));


    AsphCanvas.UseImagePx(AsphImages.Image['ed_cur2.image'],
                                        pxBounds4(0, 0, 32, 32));

    AsphCanvas.TexMap(pRotate4c(Point2(P1.X, P1.Y),
                        Point2(32, 32), Ticks/31.415),
                        clWhite4);
  end;

  if DrawAngle then
  if RulCount > 0 then
  begin
    P1 := MapToScreen(PointToAdd.x, PointToAdd.y);
    P2 := MapToScreen(RulPoints[RulCount-1].x, RulPoints[RulCount-1].y);

    if isAzmt then
      Ang0 := RulDA - RulAzmt
        else
          Ang0 := 0;

    if Ang0 > pi then
       Ang0 := Ang0 - 2*pi;
    if Ang0 < -2*pi then
       Ang0 := Ang0 + 2*pi;
       
    Ang1 := RulDA; 
    FixAngle(Ang1);


    Ang0 := Ang0 + Fi;
    Ang1 := Ang1 + Fi;

  //  CutLineByFrame(P1.x, P1.y, P2.x, P2.y);

    FatLine(AsphCanvas, P2.x, P2.y,
            P2.x + 100*Sin(pi - Ang1), P2.y + 100*cos(pi - Ang1),
            0, false, Smooth, RColor);

    FatLine(AsphCanvas, P2.x, P2.y ,
            P2.x + 100*Sin(pi - Ang0), P2.y + 100*Cos(pi - Ang0),
            0, false, Smooth, RColor);

    if isAzmt then
      AsphCanvas.UseImagePx(AsphImages.Image['star.image'], pxBounds4(0, 0, 16 , 16 ))
        else
          AsphCanvas.UseImagePx(AsphImages.Image['gal.image'], pxBounds4(0, 0, 16 , 16 ));
          
      AsphCanvas.TexMap(pRotate4c(Point2(P2.x + 100*Sin(pi - Ang0), P2.y + 100*cos(pi - Ang0)),
                                Point2(16, 16), (fi)),
                                cColor4(RColor));
 

    /// My arc

    P0.x := P2.x; 
    P0.y := P2.y;

    if Ang0 < Ang1 + 2*pi then
       Ang0 := Ang0 + 2*pi;
    if Ang0 > Ang1 then
       Ang0 := Ang0 - 2*pi;
       
    J := 1 + trunc((Ang1-Ang0)*4);
    for I := 1 to J do
    begin
      P1.x := P0.x + 20*Sin(pi - Ang0 - (I-1)*(Ang1-Ang0)/J);
      P1.y := P0.y + 20*Cos(pi - Ang0 - (I-1)*(Ang1-Ang0)/J);
      P2.x := P0.x + 20*Sin(pi - Ang0 - (I)*(Ang1-Ang0)/J);
      P2.y := P0.y + 20*Cos(pi - Ang0 - (I)*(Ang1-Ang0)/J);
      FatLine(AsphCanvas, P2.x, P2.y, P1.x, P1.y, 1, false, Smooth, RColor);
    end;

    case isAzmt of
       true :  S := IntToStr(round(RulAzmt*180/pi)); 
       false : S := IntToStr(round(RulDa*180/pi));
    end;
    
    
    w := round(AsphFonts[Font0].TextWidth(S));
    if J <= 4 then
    begin
       P1.x := P0.x - 8 - w;
       P1.y := P0.y - 40;
    end    
      else        
      begin
         P1.x := P0.x + 32*Sin(pi - Ang0 - (Ang1-Ang0)/2);
         P1.y := P0.y - 5 + 32*Cos(pi - Ang0 - (Ang1-Ang0)/2);
      end;
    
    AsphFonts[Font0].TextOut(Point2(trunc(P1.x), trunc(P1.y)),
                                    S, cColor2(txColor));
    AsphCanvas.Circle(Point2(trunc(P1.x)+w+3, trunc(P1.y)+4),2,6, (txColor));                                
    //AsphFonts[Font0].TextOut(Point2(trunc(P1.x)+w+2, trunc(P1.y)-3),
    //                                '?', cColor2(TxColor));                                 
  end;


  if DrawCur then
  if RulCount > 0 then
  begin
    P1 := MapToScreen(PointToAdd.x, PointToAdd.y);
    P2 := MapToScreen(RulPoints[RulCount-1].x, RulPoints[RulCount-1].y);

     d := Scale*sqrt(sqr(P2.x - P1.x) + sqr(P2.y - P1.y));
     if d < 10000 then 
        s := '+'+Format('%.2n',[d])+inf[40]
          else 
             s := '+'+Format('%.2n',[d/1000])+inf[41];
     w := round(AsphFonts[Font0].TextWidth(s));

     AsphCanvas.FillRect(Rect (trunc(P1.X + 8) -2,      trunc(P1.Y -20) - 2,
                               trunc(P1.X + 8) + w + 2, trunc(P1.Y -20) + 14), MnColor);
     
     AsphFonts[Font0].TextOut(Point2( trunc(P1.X)+8, trunc(P1.Y)-20),
                               s, cColor2(TxColor));                        
   end;




end;

procedure AddRulerPoint(X, Y : Double);
begin
  if RulCount < 1000 then
  begin
    inc(RulCount);
    RulPoints[RulCount-1].x := X;
    RulPoints[RulCount-1].y := Y;
  end;
  RecomputeRuler(7);
end;

procedure ResetRuler;
begin
  RulCount := 0;
end;

procedure RulCurrent(X, Y :Double);
var A1, A2, L :Double;
    N :Integer;
    BL:TLatLong;
begin
   N := RulCount -1;
   RulCurrL := 0;
   RulAzmt  := 0;
   RulDA    := 0;

   if N = -1 then
       exit;

   RulCurrL := sqrt(sqr(RulPoints[N].x - x) + sqr(RulPoints[N].y - y));

   RulDA := Arctan2(x - RulPoints[N].x, y - RulPoints[N].y);
   BL := MapToBL(x,y);
   RulAzmt := DirAngleToAzimuth(RulDA, BL.Lat, BL.Long, MyZone, True);
   FixAngle(RulDA);
   FixAngle(RulAzmt);
end;

procedure RecomputeRuler(Mode :Integer);
var I:Integer;
    L: Double;
    LL1, LL2 :TLatLong;
begin

   RulFullLength := 0;
   RulLengths[0] := 0;
   RulFullElLength := 0;
   RulElLengths[0] := 0;

   case Mode of

      25: /// Frame
      begin
        RulCount := FrameCount-1;
        for I := 0 to FrameCount - 2 do
        begin
          RulPoints[I].x := FramePoints[I,1].x;
          RulPoints[I].y := FramePoints[I,1].y;
        end;
      end;

     26: /// Frame
      begin
        RulCount := Length(Route[RouteCount-1].WPT)-1;

        for I := 0 to Length(Route[RouteCount-1].WPT) - 2 do
        begin
          RulPoints[I].x := Route[RouteCount-1].WPT[I].x;
          RulPoints[I].y := Route[RouteCount-1].WPT[I].y;
        end;
      end;
   end;

   for I := 1 to RulCount - 1 do
      begin
          L := sqrt(sqr(RulPoints[I-1].x - RulPoints[I].x) + sqr(RulPoints[I-1].y - RulPoints[I].y));
          RulLengths[I] := L;
          RulFullLength := RulFullLength + L;

          RulElLengths[I] := L;
          if L = 0 then
             continue;

          LL1 := MapToBL(RulPoints[I-1].x, RulPoints[I-1].y);
          LL2 := MapToBL(RulPoints[I].x, RulPoints[I].y);
          L :=  Vincenty(LL1.lat, LL1.long, LL2.lat, LL2.long);
          RulElLengths[I] := L;
          RulFullElLength := RulFullElLength + L;
      end;

end;

procedure CopyRoute(CopyRouteN, CopyCount: Integer; CopyShift, ShiftAngle :Double;
            CopyName :String; AddN : Boolean; NStart, NStep: Integer);

var i, j   :Integer;
    dX, dY :Double;
begin
  if CopyCount = 0 then
     exit;

  for I := 0 to CopyCount-1 do
  begin
    if RouteCount >= RouteMax then
       exit;

    inc(RouteCount);
    Route[RouteCount-1].Geo := False;
    SetLength(Route[RouteCount-1].WPT,  Length(Route[CopyRouteN].WPT));
    SetLength(Route[RouteCount-1].GWPT, Length(Route[CopyRouteN].GWPT));

    dY := Cos(ShiftAngle*PI/180);
    dX := Sin(ShiftAngle*PI/180);

    for J := 0 to Length(Route[RouteCount-1].WPT)-1 do
    begin
       Route[RouteCount-1].WPT[J].x := Route[CopyRouteN].WPT[J].x + dX*CopyShift*(I+1);
       Route[RouteCount-1].WPT[J].y := Route[CopyRouteN].WPT[J].y + dY*CopyShift*(I+1);
    end;

    Route[RouteCount-1].Name := CopyName;
    if AddN then
    Begin
       Route[RouteCount-1].Name := CopyName + IntToStr(NStart + I*NStep);
    End;

    Route[RouteCount-1].x1 := Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)].x;
    Route[RouteCount-1].y1 := Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)].y;
    Route[RouteCount-1].x2 := Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)].x;
    Route[RouteCount-1].y2 := Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)].y;
  end;

  RoutesToGeo;
  RecomputeRoutes(False);
end;

procedure MadeDevStar(DCenter :TMyPoint; DRad : Double; RNumber:Integer;
            DName:String; Gap:Integer; DoFD:Boolean; Az:Double);
var a, ra, da, xx1, yy1, xx2, yy2, gapL, amax : Double;
    I, j, I1:Integer;
Begin
  case RNumber of
     2: da := 90;
     4: da := 45;
     8: da := 22.5;
  end;

  amax := 180;
  if DoFD then
    amax := 360;

  a := 0;
  I := 0;

  gapL := Gap * Drad / 100;

  I1 := RouteCount;

  if RNumber = 0 then
  begin
      for I := 1 to 4 do
      Begin
        inc(RouteCount);
        Route[RouteCount-1].Geo := False;
        SetLength(Route[RouteCount-1].WPT,  2);
        SetLength(Route[RouteCount-1].GWPT, 2);
        Route[RouteCount-1].Name := DName + IntToStr(I);
        Route[RouteCount-1].Fixed := false;
        Route[RouteCount-1].Status := 0;

        xx1 := DCenter.x - DRad;
        xx2 := DCenter.x + DRad;
        yy1 := DCenter.y - DRad;
        yy2 := DCenter.y + DRad;

        case I of
          1: begin
              Route[RouteCount-1].WPT[0].x := xx1 + gapl;
              Route[RouteCount-1].WPT[1].x := xx2 - gapl;
              Route[RouteCount-1].WPT[0].y := yy1;
              Route[RouteCount-1].WPT[1].y := yy1;
          end;
          2: begin
              Route[RouteCount-1].WPT[0].x := xx2;
              Route[RouteCount-1].WPT[1].x := xx2;
              Route[RouteCount-1].WPT[0].y := yy1 + gapl;
              Route[RouteCount-1].WPT[1].y := yy2 - gapl;
          end;
          3: begin
              Route[RouteCount-1].WPT[0].x := xx2 - gapl;
              Route[RouteCount-1].WPT[1].x := xx1 + gapl;
              Route[RouteCount-1].WPT[0].y := yy2;
              Route[RouteCount-1].WPT[1].y := yy2;
          end;
          4: begin
              Route[RouteCount-1].WPT[0].x := xx1;
              Route[RouteCount-1].WPT[1].x := xx1;
              Route[RouteCount-1].WPT[0].y := yy2 - gapl;
              Route[RouteCount-1].WPT[1].y := yy1 + gapl;
          end;

        end;

      End;

  end
    else
  repeat
    if RouteCount >= RouteMax then
       exit;

    inc(RouteCount);
    Route[RouteCount-1].Geo := False;
    SetLength(Route[RouteCount-1].WPT,  2);
    SetLength(Route[RouteCount-1].GWPT, 2);

    ra := a*PI/180;

    Route[RouteCount-1].WPT[0].x := DCenter.x + Sin(ra)*DRad;
    Route[RouteCount-1].WPT[1].x := DCenter.x + Sin(ra+pi)*DRad;
    Route[RouteCount-1].WPT[0].y := DCenter.y + Cos(ra)*DRad;
    Route[RouteCount-1].WPT[1].y := DCenter.y + Cos(ra+pi)*DRad;


    Route[RouteCount-1].x1 := Route[RouteCount-1].WPT[0].x;
    Route[RouteCount-1].y1 := Route[RouteCount-1].WPT[0].y;
    Route[RouteCount-1].x2 := Route[RouteCount-1].WPT[1].x;
    Route[RouteCount-1].y2 := Route[RouteCount-1].WPT[1].y;

    Inc(I);
    Route[RouteCount-1].Name := DName + IntToStr(I);
    Route[RouteCount-1].Fixed := false;
    Route[RouteCount-1].Status := 0;
    
    if DoFD then
    begin
       if (I mod 2 = 0) then
         RewerseRoute(RouteCount-1);
       Route[RouteCount-1].Fixed := true;
    end;

    a := a + da;
  until a>= amax;


  if Az <> 0 then
  for I := I1 to RouteCount-1 do
  begin
    xx1 := -DCenter.x + Route[I].WPT[0].x;
    xx2 := -DCenter.x + Route[I].WPT[Length(Route[I].WPT)-1].x;
    yy1 := -DCenter.y + Route[I].WPT[0].y;
    yy2 := -DCenter.y + Route[I].WPT[Length(Route[I].WPT)-1].y;

    ra := sqrt(sqr(xx1)+sqr(yy1));
    a := arctan2(yy1, xx1);
    Route[I].WPT[0].x := DCenter.x + cos(a - az*pi/180)*ra;
    Route[I].WPT[0].y := DCenter.y + sin(a - az*pi/180)*ra;

    ra := sqrt(sqr(xx2)+sqr(yy2));
    a := arctan2(yy2, xx2);
    Route[I].WPT[Length(Route[I].WPT)-1].x := DCenter.x + cos(a - az*pi/180)*ra;
    Route[I].WPT[Length(Route[I].WPT)-1].y := DCenter.y + sin(a - az*pi/180)*ra;

    Route[I].x1 := Route[I].WPT[0].x;
    Route[I].y1 := Route[I].WPT[0].y;
    Route[I].x2 := Route[I].WPT[Length(Route[I].WPT)-1].x;
    Route[I].y2 := Route[I].WPT[Length(Route[I].WPT)-1].y;
  end;

  RoutesToGeo;
  RecomputeRoutes(False);
End;


end.
