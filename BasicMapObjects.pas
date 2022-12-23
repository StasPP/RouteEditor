unit BasicMapObjects;

interface

uses MapFunctions, GeoFunctions, TabFunctions, Vectors2, RTypes, Windows, Math,
     AbstractCanvas, AbstractDevices, AsphyreImages, AsphyreTypes, AsphyreDb,
     Classes, FLoader, SysUtils, GeoClasses, GeoString, Dialogs, DrawFunctions,
     PointClasses;

type

  TMarker = Record
      MarkerName : String;
      x,y        : Double;
      Gx,Gy      : Double;
      H, HGeo, Alt : Double;
      MarkerKind : Byte;
      Add1, Add2 : Double;   /// �������������� ������
  end;

  TMap = Record
      imgN : integer;
      imgName : String;
      x,y : array [1..4] of Double;
      Gx,Gy : array [1..4] of Double;
  end;

  TRoute = record
    Name :String;
    Geo  :Boolean;

    /// ������ � �����
    x1, x2 :double;
    y1, y2 :double;

    /// �������������
    WPT    :array of TMyPoint;
    GWPT   :array of TMyPoint;
    ALT    :array of Real;

    /// Lat-Long
    Gx1, Gx2 :double;
    Gy1, Gy2 :double;
    Gz1, Gz2 :double;

    Status   :integer;
    Fixed    :Boolean;
  end;

  procedure SetBaseBL(B, L: Double);

  procedure ResetRoutes;
  procedure ResetMarkers;
  procedure ResetMaps(AsphMapImages:TAsphyreImages);
  procedure ResetSettings;

  procedure LoadMaps(FileName: String; TmpDir:String;
          AsphMapImages:TAsphyreImages); overload;
  procedure LoadMaps(FileName: String; TmpDir:String;
          AsphMapImages:TAsphyreImages; n, count: integer); overload;
  procedure LoadMaps(MapList: array of String; TmpDir:String;
          AsphMapImages:TAsphyreImages); overload;

  procedure LoadMarkers(FileName:String);
  procedure LoadMarkersEx(FileName:String);

  //--

  procedure MarkerLoops;
  function  MarkersAreLoops:boolean;
  function  MarkersUDFCount:integer;

  procedure CheckNewRouteName(var RName :String);


  function  GetRoutePointA (N, I :Integer):Double;
  procedure SetRoutePointA (N, I :Integer; A:Double);
  
  procedure LoadRoutes(FileName: String; DoAdd:Boolean; askS:string);
  procedure LoadFrame(FileName:String);
  function  LoadRoutesFromRTS(FileName: String; DoAdd:Boolean; askS:string):integer;
  procedure LoadBlnRoutes(FileName: String; DoAdd:Boolean; dKind, dOrder:Byte;
      BlnCS:Integer);


  function FindRouteByName(s:string):integer;

  procedure RecomputeBaseObjects(WFZ:Boolean);

  procedure ReComputeBase(WFZ:Boolean);
  procedure ReComputeRoutes(WFZ:Boolean); overload;
  procedure ReComputeRoutes(WFZ:Boolean; FromI:Integer); overload;
  procedure FilterRoutePoints(FromI:Integer);

  procedure ReComputeMarkers(WFZ: Boolean);
  procedure ReComputeMaps(WFZ:Boolean);

  function FrameArea     :real;
  function FramePerimeter:real;
  function RoutesAllSize :real;
  function RoutesMeanSize:real;
  function GalsCount     :integer;

  function RouteLenght(N :Integer):Double;

  function  BasicObjectsMeanBL      :Tlatlong;
  function  BasicObjectsMeanUTMZone :integer;
  function  UTMZonebyPoint(B, L:Double):integer;
  procedure BasicObjectsScale;

  procedure DrawMaps(AsphCanvas: TAsphyreCanvas; AsphMapImages: TAsphyreImages;
      Delta: Double);
  procedure DrawBase(AsphCanvas: TAsphyreCanvas; AsphImages: TAsphyreImages;
      Color:Cardinal);
  procedure DrawRoutes(AsphCanvas: TAsphyreCanvas;
      ChoosedColor, RoutesColor, DoneColor, FrameColor, FntColor, MenuColor,
      HiddenColor:Cardinal;
      Smooth, DrawAllLabels: Boolean; LStyle :Integer; DoLabels:Boolean);
  procedure DrawRouteArrows(N:Integer;  Col:Cardinal);
  procedure DrawMarkers(AsphCanvas: TAsphyreCanvas; AsphImages: TAsphyreImages;
      Color, FntColor, MenuColor, LineColor, DopColor :Cardinal; DrawSpecial: boolean;
      LStyle :Integer; DoLabels, DoLoops, Smooth:Boolean);

  /// Additional
  procedure DrawLines(AsphCanvas: TAsphyreCanvas; Color:Cardinal; Smooth: Boolean);
  procedure DrawLabels(FntColor, MenuColor:Cardinal;
       DrawAll:Boolean; LStyle:Integer);

  procedure AddMarker(mName: String; mB, mL : Double);   overload;
  procedure AddMarker(mName: String; mB, mL, H, HGeo, Alt : Double);   overload;
  procedure DelAngMarkers;
  procedure DelMarker(DelI: integer);
  procedure EditMarker(I: integer; Mname: string; mB, mL: Double);

const
   FrameMax = 256;
   RouteMax = 100000;
   MinPix = 5;
var
 //// Objects
  Base     :array [1..2] of TMyPoint;
  BigIcons: Boolean;

  /// Routes
  Route           :array [0..RouteMax] of TRoute;
  isRoutesDatum   :Boolean = false;
  RouteCount      :integer = 0;
  RouteAsk        :integer = -1;
  RoutesDatum, RoutesCS : integer;
  RoutesXTab, RoutesYTab, RoutesZTab, RoutesNameTab, RoutesTabStart,
  RoutesX2Tab, RoutesY2Tab, RoutesZ2Tab, RoutesBEKind :Integer;
  RoutesH : Byte;
  RoutesRSpacer : Char;

  /// Routes Frame
  Frame         :Boolean = false;
  FrameCount    :integer = 0;
  FrameGeo      :Boolean = true;
  FramePoints   : array [0..FrameMax,1..2] of TMy3DPoint;

  /// RasterMaps
  MapList  :array of TMap;
  MinMap   :real = 1;
  MaxMap   :real = 3000;
  MapAlpha :integer = 205;
  MapChoosed  :integer = -1;
  MapAnim  :Double = 0.0;
  MapAsdbList :array of String;

  /// AddRoutes
  AddRoutes :Boolean = False;

  ///Markers
  Markers  :array of TMarker;

implementation


procedure SetBaseBL(B, L: Double);
begin
  Base[2].x := B;
  Base[2].y := L;

  RecomputeBase(WaitForZone);

  if WaitForCenter then
  begin
     Center.x  := Base[1].x;
     Center.y  := Base[1].y;
     ShiftCenter := Center;
  end;
end;

procedure ResetMaps(AsphMapImages:TAsphyreImages);
begin
   AsphMapImages.RemoveAll();
   SetLength(MapList,0);
   SetLength(MapAsdbList,0);
end;

procedure ResetMarkers;
begin
   SetLength(Markers,0);
end;

procedure ResetRoutes;
begin
  RouteCount := 0;
  FrameCount := 0;
end;

procedure ResetSettings;
begin
  WaitForZone := true;
  WaitForCenter := true;
  Center.X := 0;
  Center.Y := 0;
  ShiftCenter := Center;
end;

procedure LoadMaps(FileName: String; TmpDir:String; AsphMapImages:TAsphyreImages);

  function GetW(M:TMap):double;
  begin
    Result := abs(M.x[4] - M.x[1])+abs(M.y[4]-M.y[1]);
  end;

  procedure SortMaps(var A:Array of TMap);
  var i,j: Integer;
      x: TMap;
  begin
    if length(A)<2 then
       exit;

    for I := 1 to length(A)- 2 do
     for j := 1 to length(A) - 2 do
      if GetW(a[j]) < GetW(a[j+1]) then
        begin
          x := a[j+1];
          a[j+1] := a[j];
          a[j] := x;
        end;
  end;


var
 MapAsdb :TASDB;
 i, j, N, k :integer;
 S :TStringList;
 Stream :TFileStream;
 ImgName, CurImgName :String;
 xx, yy  :Double;
 AddToML :Boolean;
 _MapList :array of TMap;
//AllMem, DoneMem : integer;   ������� ����������� ������ ��������
begin
 if TmpDir[length(TmpDir)]<>'\' then
    TmpDir := TmpDir+'\';

 WaitForZone := WaitForZone and (RouteCount=0) and (Length(MapList)=0) and (Length(Markers)=0);

 FLoadGPS.Show;
 FLoadGPS.MapLoad.Visible := true;
 FLoadGPS.Label1.Hide;
 FLoadGPS.Label2.Hide;
 FLoadGPS.Repaint;
 FloadGPS.ProgressBar1.Position := 0;

 MapASDb:= TASDb.Create();
 MapASDb.FileName:= FileName;
 MapASDb.OpenMode:= opReadOnly;

 MapAsdb.Update;

 AddToML := true;
 for I := 0 to Length(MapAsdbList)-1 do
    if FileName = MapAsdbList[I] then
    begin
       AddToML := false;
       break;
    end;

 if AddToML then
 Begin
    SetLength(MapAsdbList,Length(MapAsdbList)+1);
    MapAsdbList[Length(MapAsdbList)-1] := FileName;
 End;

 if not DirectoryExists(TmpDir) then
   ForceDirectories(TmpDir);

 S := TStringList.Create;
 S.SaveToFile(TmpDir+'stream.tmp');

 for I := 0 to MapASDb.RecordCount-1 do
   if MapASDb.RecordType[i] = recFile then
   Begin
     Stream := TFileStream.Create(TmpDir+'stream.tmp',1);
     MapASDb.ReadStream(MapASDb.RecordKey[i] ,Stream);

     Stream.Destroy;
     S.Clear;
     S.LoadFromFile(TmpDir+'\stream.tmp');

     ImgName := MapASDb.RecordKey[i];
     ImgName := Copy(ImgName,1,length(ImgName)-4);

     for J := 0 to S.Count - 1 do
     begin
          FloadGPS.ProgressBar1.Position := Trunc(100*i/(MapASDb.RecordCount-1));
          FloadGPS.Repaint;

          CurImgName := ImgName+'_'+GetCols(S[j],0,1,0, true)+'_'+GetCols(S[j],1,1,0, true);
          N := AsphMapImages.AddFromASDb(CurImgName+'_t', MapASDb, CurImgName+'_t', true);
          N := AsphMapImages.AddFromASDb(CurImgName+'_s', MapASDb, CurImgName+'_s', true);
          N := AsphMapImages.AddFromASDb(CurImgName, MapASDb, CurImgName, true);

          if N > -1 then
          Begin

            SetLength(_MapList,Length(_MapList)+1);
            _MapList[Length(_MapList)-1].imgName := CurImgName;
            _MapList[Length(_MapList)-1].imgN := N;

            for k := 1 to 4 do
            Begin
              _MapList[Length(_MapList)-1].Gx[k] := StrToFloat(GetCols(S[j],k*2,1,0, true));
              _MapList[Length(_MapList)-1].Gy[k] := StrToFloat(GetCols(S[j],k*2+1,1,0, true));

              if UTM then
                 GeoToUTM(WGS,_MapList[Length(_MapList)-1].Gx[k],
                          _MapList[Length(_MapList)-1].Gy[k],
                          South, yy,xx, Myzone, WaitForZone)
               else
                   WGSToSK(_MapList[Length(_MapList)-1].Gx[k],
                           _MapList[Length(_MapList)-1].Gy[k],
                           0, xx,yy, MyZone, WaitForZone);

              _MapList[Length(_MapList)-1].x[k] := xx;
              _MapList[Length(_MapList)-1].y[k] := yy;

              if Waitforzone then
                 WaitForZone := false;
            End;  /// k cycle

               if WaitForCenter then
               Begin
                   Center.x := _MapList[Length(_MapList)-1].x[1];
                   Center.y := _MapList[Length(_MapList)-1].y[1];
                   ShiftCenter := Center;
                   WaitForCenter := false;
               End;

          End;  /// N>-1

     end;

   End;

   SortMaps(_Maplist);

   for I := 0 to Length(_Maplist)-1 do
   Begin
      SetLength(Maplist, Length(Maplist)+1);
      MapList[Length(MapList)-1] := _MapList[I];
   End;

   FLoadGPS.LCount.Visible  := false;
   FLoadGPS.Close;
   S.Destroy;
   MapAsdb.Free;

end;

procedure LoadMaps(MapList: array of String; TmpDir:String;
    AsphMapImages:TAsphyreImages);
var I:integer;
begin
  for I:= 0 to Length(MapList)-1 do
      LoadMaps(Maplist[i], TmpDir, AsphMapImages, I+1, Length(MapList));
  RecomputeMaps(False);
end;

procedure LoadMaps(FileName: String; TmpDir:String;
    AsphMapImages:TAsphyreImages; n, count: integer);
begin
  FLoadGPS.LCount.Visible  := true;
  FLoadGPS.LCount.Caption  := IntToStr(n) + ' / ' + IntToStr(Count);
  LoadMaps(FileName, TmpDir, AsphMapImages);
end;

function FindRouteByName(s:string):integer;
var I: integer;
begin
 result := -1;
 for I := 0 to RouteCount - 1 do
   if AnsiLowerCase(s) = AnsiLowerCase(Route[I].Name) then
   begin
     result := I;
     break;
   end;
   

end;

procedure RecomputeBaseObjects(WFZ:Boolean);
begin

  RecomputeRoutes(WFZ);
  WFZ := WaitForZone;
  FilterRoutePoints(0);
  RecomputeMaps(WFZ);
  WFZ := WaitForZone;
  RecomputeMarkers(WFZ);
  WFZ := WaitForZone;
  RecomputeBase(WFZ);

end;

procedure LoadFrame(FileName: String);
 var
     F : TStringList;
     I, J, I1, I2 : Integer;
     s1, s2, FrameFile : String ;
     found, isBegin : Boolean;
     _X,_Y,_Z : double;
begin

   F := TStringList.Create;
   RouteCount := 0;
   FrameCount := 0;
   WGS := FindDatum('WGS84') ;
   
   try
   if Fileexists(Filename) then
     begin
         Frame := true;
         FrameFile := Filename;

         if (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.xls')or
            (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5))='.xlsx')  then
              ExcelToStringList(FileName, F)
          else
              F.LoadFromFile(FileName);

         Frame := True;
         FrameGeo := (RoutesDatum = WGS) and (isRoutesDatum) and (RoutesCS = 0);

         j := 2;

         for I := RoutesTabStart-1 to F.Count - 1 do
         Begin
              if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I],RoutesXTab,1, RoutesRSpacer, true),true);
                 _Y := StrToLatLon(GetCols(F[I],RoutesYTab,1, RoutesRSpacer, true),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I],RoutesXTab,1, RoutesRSpacer, true));
                  _Y := StrToFloat2(GetCols(F[I],RoutesYTab,1, RoutesRSpacer, true));
                end;


             FramePoints[FrameCount, j].x := _X;// StrToFloat(GetCols(F[I],1,1, LoadRData.RSpacer.itemIndex));
             FramePoints[FrameCount, j].y := _Y;//StrToFloat(GetCols(F[I],2,1, LoadRData.RSpacer.itemIndex));
             if RoutesZTab<>-1 then
                FramePoints[FrameCount, j].z := StrToFloat2(GetCols(F[I],RoutesZTab,1, RoutesRSpacer, true))
                  else
                    FramePoints[FrameCount, j].z := 0;

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
                     GaussKrugerToGeo(RoutesDatum, FramePoints[J, 2].y, FramePoints[J, 2].x,
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

     ReComputeRoutes(WaitForZone);

 except
   MessageDlg('Unable to load routes',mtError, [mbOk],0);
 end;

 F.Free;

end;


procedure LoadMarkers(FileName: String);
 var
     F :TStringList;
     i :integer;
     mB, mL, mH, mHgeo, mA :Double;
     mName  :String;
begin
  F := TStringList.Create;

  if filename<>'' then
  begin
     F.LoadFromFile(FileName);
     for I := 0 to F.Count - 1 do
     try
        if F[I]='' then
           continue;

        mName := GetCols(F[i],0,1,1, true);
        mB    := StrToLatLon(GetCols(F[i],1,1,1, true),true);
        mL    := StrToLatLon(GetCols(F[i],2,1,1, true),false);

        mH    := StrToFloat2(GetCols(F[i],3,1,1, true));
        mHGeo := StrToFloat2(GetCols(F[i],4,1,1, true));
        //mA    := StrToFloat2(GetCols(F[i],5,1,1, true));

        SetLength(Markers, Length(Markers)+1);
        Markers[Length(Markers)-1].Gx := mB;
        Markers[Length(Markers)-1].Gy := mL;
        Markers[Length(Markers)-1].MarkerName := mName;

        Markers[Length(Markers)-1].H := mH;
        Markers[Length(Markers)-1].HGeo := mHGeo;
        //Markers[Length(Markers)-1].Alt := mA;
        Markers[Length(Markers)-1].MarkerKind := 0;
        Markers[Length(Markers)-1].Add1 := 0;
        Markers[Length(Markers)-1].Add2 := 0;

        if GetColCount(F[i],1) >= 5 then
        try
          Markers[Length(Markers)-1].MarkerKind :=
                StrToInt(GetCols(F[i],5,1,1, true));

          if GetColCount(F[i],1) >= 7 then
          begin
            if Markers[Length(Markers)-1].MarkerKind = 10 then
            begin
               Markers[Length(Markers)-1].Add1 := StrToFloat2(GetCols(F[i],6,1,1, true));
               Markers[Length(Markers)-1].Add2 := StrToFloat2(GetCols(F[i],7,1,1, true));
            end;
            if GetColCount(F[i],1) >= 8 then
              Markers[Length(Markers)-1].Alt :=
                  StrToInt(GetCols(F[i],8,1,1, true));
          end
            else
              if GetColCount(F[i],1) >= 6 then
              Markers[Length(Markers)-1].Alt :=
                StrToInt(GetCols(F[i],6,1,1, true));

        except
          Markers[Length(Markers)-1].MarkerKind := 0;
        end;

     except
       continue;
     end;
  end;

  RecomputeMarkers(WaitForZone);

  if not MarkersAreLoops then
    MarkerLoops;

  F.Free
end;

procedure LoadMarkersEx(FileName: String);

  procedure GetBL(x, y, z: Double; var B, L, H : Double);
  begin
       WGS := FindDatum('WGS84') ;

       if isRoutesDatum = false then
       begin
            /// RouteCS - C�

            if  CoordinateSystemList[RoutesCS].ProjectionType <=1 then
                CoordinateSystemToDatum(RoutesCS, x, y, z, B, L, H)
                else
                   CoordinateSystemToDatum(RoutesCS, y, x, z, B, L, H);

           if CoordinateSystemList[RoutesCS].DatumN <> WGS then
              Geo1ForceToGeo2(B, L, H,  CoordinateSystemList[RoutesCS].DatumN,
                              WGS, B, L, H);
       end
          else
            begin
              /// RouteCS - ��� ��������
              case RoutesCS of
                 0: begin
                   B := x;
                   L := y;

                   if RoutesDatum <> WGS then
                     Geo1ForceToGeo2( x, y, z, RoutesDatum, WGS, B, L, H);
                 end;

                 1:   begin
                   // XYZ
                   ECEFToGeo(RoutesDatum, x, y, z, B, L, H);

                   if RoutesDatum <> WGS then
                     Geo1ForceToGeo2( B, L, z, RoutesDatum, WGS, B, L, H);

                 end;
                 2:  begin
                   // GK
                   GaussKrugerToGeo(RoutesDatum, y, x, B, L);

                  if RoutesDatum <> WGS then
                       Geo1ForceToGeo2( B, L, z, RoutesDatum, WGS, B, L, H);

                 end;
                 3,4:  begin
                   // UTM
                   UTMToGeo(RoutesDatum, y, x, RoutesCS = 4, B, L);

                   if RoutesDatum <> WGS then
                       Geo1ForceToGeo2( B, L, z, RoutesDatum, WGS, B, L, H);

                   End;

                 end;
              end;

  end;

 var
     F :TStringList;
     i :integer;
     _X,_Y,_Z : double;

     mB, mL, mH :Double;
     mName  :String;
begin
  F := TStringList.Create;
  WGS := FindDatum('WGS84') ;

  if filename<>'' then
  begin
    if (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.xls')or
       (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5))='.xlsx')  then
         ExcelToStringList(FileName, F)
          else
              F.LoadFromFile(FileName);

     for I :=  RoutesTabStart-1  to F.Count - 1 do
     try
       if F[I]='' then
           continue;

        mName := GetCols(F[i],RoutesNameTab,1,RoutesRSpacer, true);
        if ((isRoutesDatum)and(RoutesCS=0))
           or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
           begin
              _X := StrToLatLon(GetCols(F[i],RoutesXTab,1,RoutesRSpacer, true),true);
              _Y := StrToLatLon(GetCols(F[i],RoutesYTab,1,RoutesRSpacer, true),false);
           end
            else
             begin
                _X := StrToFloat2(GetCols(F[i],RoutesXTab,1,RoutesRSpacer, true));
                _Y := StrToFloat2(GetCols(F[i],RoutesYTab,1,RoutesRSpacer, true));
             end;

        _Z := 0;
        if RoutesZTab >= 0 then
                 _Z := StrToFloat2(GetCols(F[i],RoutesZTab,1,RoutesRSpacer, true));

        if ((_x = 0)and(_y = 0)) then
          continue;

        GetBL(_x, _y, _z, mB, mL, mH);

        SetLength(Markers, Length(Markers)+1);
        Markers[Length(Markers)-1].Gx := mB;
        Markers[Length(Markers)-1].Gy := mL;
        Markers[Length(Markers)-1].MarkerName := mName;
        Markers[Length(Markers)-1].Add1 := 0;
        Markers[Length(Markers)-1].Add2 := 0;
        Markers[Length(Markers)-1].MarkerKind := 0;

        case RoutesH of
          2: Markers[Length(Markers)-1].H := mH;
          1: Markers[Length(Markers)-1].HGeo := _Z;
        end;

     except
       continue;
     end;
  end;

  RecomputeMarkers(WaitForZone);
  MarkerLoops;
  RecomputeMaps(WaitForZone);
  F.Free
end;

var LoopNameList:Array of string;

procedure MarkerLoops;
var I, j, k :Integer;
    s, s2: string;
    needAdd:boolean;
begin
   SetLength(LoopNameList, 0);
   // 1) Find corners
   for I := 0 to Length(Markers) - 1 do
   begin
     if Markers[I].MarkerKind <> 0 then
         continue;

     s := AnsiLowerCase(Markers[I].MarkerName);
     s := Copy(s, Length(s)-2, 3);
     k := 0;
     if s = '_k1' then
     begin
       s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));

       SetLength(LoopNameList, Length(LoopNameList)+1);
       LoopNameList[Length(LoopNameList)-1] := s2;
       Markers[I].MarkerKind := 2;

       {for j := 1 to 3 do
         if i+j <=  Length(Markers) - 1 then
         begin
           s := AnsiLowerCase(Markers[I+j].MarkerName);
           if s = s2 + '_k' + IntToStr(j+1) then
              Markers[I+j].MarkerKind := 2;
         end;  }

       k := 0;
       repeat
           s := AnsiLowerCase(Markers[I+k].MarkerName);
           if s = s2 + '_k' + IntToStr(k+1) then
           begin
             inc(k);
             Markers[I+k].MarkerKind := 2;
           end
           else
             break;
       until I+k > Length(Markers)-1;

     end;
   end;

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

       if s2 = '' then
          continue;

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

   // 3) Find Centers
   for I := 0 to Length(Markers) - 1 do
   begin
     if Markers[I].MarkerKind <> 0 then
         continue;
     s := AnsiLowerCase(Markers[I].MarkerName);
     for j := 0 to  Length(LoopNameList)- 1 do
       if s = LoopNameList[j]  then
          Markers[I].MarkerKind := 1;
   end;

end;


procedure LoadBlnRoutes(FileName: String; DoAdd:Boolean; dKind, dOrder:Byte;
    BlnCS:Integer);

  procedure GetBL(x, y, z: Double; var B, L, H : Double);
  begin
       WGS := FindDatum('WGS84') ;

       if  CoordinateSystemList[BlnCS].ProjectionType <=1 then
          CoordinateSystemToDatum(BlnCS, x, y, z, B, L, H)
       else
          CoordinateSystemToDatum(BlnCS, y, x, z, B, L, H);

       if CoordinateSystemList[BlnCS].DatumN <> WGS then
         Geo1ForceToGeo2(B, L, H,  CoordinateSystemList[BlnCS].DatumN,
                         WGS, B, L, H);
  end;

 var
     F :TStringList;
     i, n :integer;
     _X,_Y,_Z : double;

     mB, mL, mH :Double;

     OldRouteCount :Integer;

     IsFrame : Boolean; PtCount:Integer;
     P: TMyPoint;
     s :string;
begin

  if Fileexists(FileName) = false then
    Exit;

  OldRouteCount := RouteCount;

  if DoAdd = false then
  begin
      if dKind <> 0 then
      begin
        RouteCount := 0;
        oldRouteCount := 0;
      end;
  end;

  isFrame := dKind <> 1;
  if isFrame then
  begin
    FrameCount := 0;
    Frame      := true;
    FrameGeo   := true;
  end;

  F := TStringList.Create;
  WGS := FindDatum('WGS84');

  F.LoadFromFile(FileName);
  PtCount := 0;
  For I := 0 To F.Count - 1 Do
  Begin
    dec(PtCount);
    if PtCount >= 0 then
    begin
      //
      _X := StrToFloat2(GetCols(F[i],0,1,',', false));
      _Y := StrToFloat2(GetCols(F[i],1,1,',', false));
      _Z := StrToFloat2(GetCols(F[i],2,1,',', false));

      case dOrder of
        0: GetBL(_x, _y, _z, mB, mL, mH);
        1: GetBL(_y, _x, _z, mB, mL, mH);
      end;

      if isFrame then
      begin
        if FrameCount < FrameMax then
          inc(FrameCount);
        FramePoints[FrameCount-1, 2].x := mB;
        FramePoints[FrameCount-1, 2].y := mL;
        FrameGeo := True;
      end
      else
        begin
          n := Length(Route[RouteCount-1].WPT);
          SetLength(Route[RouteCount-1].WPT, n+1);
          SetLength(Route[RouteCount-1].GWPT,n+1);

          Route[RouteCount-1].GWPT[n].x := mB;
          Route[RouteCount-1].GWPT[n].y := mL;
        end;

    end
    else
       begin
         PtCount := Trunc(StrToFloat2(GetCols(F[i],0,1,',', false)));
         if isFrame then
         begin
           if FrameCount > 0 then
             isFrame := false;
         end
          else
          begin
            if dKind = 0 then
              break;
            s := GetCols(F[i], 1, 1, ',', false);

            if s <> '' then
              s := GetCols(F[i], 1, 1, '"', false)
            else
              s := 'Pr';

            CheckNewRouteName(s);
            if RouteCount < RouteMax then
               inc(RouteCount)
            else
              break;

            Route[RouteCount-1].Name := s;
            SetLength(Route[RouteCount-1].WPT,0);
            SetLength(Route[RouteCount-1].GWPT,0);
            Route[RouteCount-1].Status := 0;
            Route[RouteCount-1].Fixed := false;
          end;

       end;

  End;

  {

     for I :=  RoutesTabStart-1  to F.Count - 1 do
     try
       if F[I]='' then
           continue;

        mName := GetCols(F[i],RoutesNameTab,1,RoutesRSpacer, true);
        if ((isRoutesDatum)and(RoutesCS=0))
           or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
           begin
              _X := StrToLatLon(GetCols(F[i],RoutesXTab,1,RoutesRSpacer, true),true);
              _Y := StrToLatLon(GetCols(F[i],RoutesYTab,1,RoutesRSpacer, true),false);
           end
            else
             begin
                _X := StrToFloat2(GetCols(F[i],RoutesXTab,1,RoutesRSpacer, true));
                _Y := StrToFloat2(GetCols(F[i],RoutesYTab,1,RoutesRSpacer, true));
             end;

        if RoutesZTab>=0 then
                 _Z := StrToFloat2(GetCols(F[i],RoutesZTab,1,RoutesRSpacer, true),false);

        if ((_x = 0)and(_y = 0)) then
          continue;

        GetBL(_x, _y, _z, mB, mL, mH);

        SetLength(Markers, Length(Markers)+1);
        Markers[Length(Markers)-1].Gx := mB;
        Markers[Length(Markers)-1].Gy := mL;
        Markers[Length(Markers)-1].MarkerName := mName;

     except
       continue;
     end;
  end;    }
  RecomputeRoutes(WaitForZone);
  RecomputeMarkers(WaitForZone);
  RecomputeMaps(WaitForZone);
  F.Free
end;


function GetRoutePointA (N, I :Integer):Double;
begin
  result := 0;
  if (I <0) or (N< 0) then
     exit;
  if N < RouteCount then
    if I < Length(Route[N].ALT) then
        result := Route[N].ALT[I];
end;

procedure SetRoutePointA (N, I :Integer; A:Double);
var k, L :Integer;
begin

  if (I <0) or (N< 0) or  (N >= RouteCount) then
     exit;

  /// ��������, ���� �����

   k := Length(Route[N].ALT);
   if k < Length(Route[N].WPT)-1 then
   begin
      SetLength(Route[N].ALT,  Length(Route[N].WPT));

      for L := k to Length(Route[N].ALT)-1 do
        Route[N].ALT[L] := 0;
   end;

   if I < Length(Route[N].ALT) then
       Route[N].ALT[I] := A;
end;

procedure CheckNewRouteName(var RName:String);
var I, J, K, Nmax : Integer;
begin
  if RName ='' then
     RName := 'Pr';

  for I := 0 to RouteCount - 1 do
     if Route[I].Name = RName then
     Begin
        Nmax := 0;
        for J := 0 to RouteCount - 1 do
        begin
          if Length(Route[J].Name) >= Length(RName)+1 then
           if Copy(Route[J].Name,1,Length(RName)+1) = RName+'_' then
           try
             K := trunc(StrToFloat2(
                  Copy(Route[J].Name,
                       Length(RName)+1,
                       Length(Route[J].Name)-Length(RName))));
             if K > Nmax then
                Nmax := K;
           except
           end;
        end;
        RName := RName+'_' + IntToStr(Nmax+1);
     End;
end;

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

     J :=0;
     for I := RoutesTabStart-1 to F.Count - 1 do
     if F[i]<>'' then
     begin

    {    if Settings.ReverseRoutes.Checked then
           i2 := (F.Count - 1) - (i - (RoutesTabStart-1))
          else     }
             i2 := i;

        isBegin := false;
        case RoutesBEKind of
           0: begin
                s1 := GetCols(F[I2],RoutesNameTab,1, RoutesRSpacer, true);
                TestName(s1, OldRouteCount);
                J := I;
                RouteCount := J+1;
              end;
           1: begin
                 s1 := GetCols(F[I2],RoutesNameTab,1, RoutesRSpacer, true);
                 TestName(s1, OldRouteCount);
                 J := Trunc(I/2);
                 RouteCount := J+1;
                 if I mod 2 = 0 then
                   isBegin := true;
              end;
           2: BEGIN
                s1 := GetCols(F[I2],RoutesNameTab,1, RoutesRSpacer, true);
                
                s2 := Copy(s1,length(s1),1);
                if (s2<>'a')and(s2<>'A')and(s2<>'b')and(s2<>'B') then
                   continue;

                isBegin := (s2='a') or (s2='A');
                s1 := Copy(s1,1,length(s1)-1);

                TestName(s1, OldRouteCount);

                if RouteCount=0 then
                begin
                  J :=0;
                  RouteCount:=1;

                end else
                  begin    /// ��� �� �����
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

              3: BEGIN
                s1 := GetCols(F[I2],RoutesNameTab,1, RoutesRSpacer, true);
                isBegin := true;
                
                if RouteCount=0 then
                begin
                  J :=0;
                  RouteCount:=1;

                end else
                  begin    /// ��� �� �����
                    found := false;
                    for J := OldRouteCount to RouteCount-1 do
                      if Route[J].Name = s1 then
                      begin
                        found := true;
                        isBegin := false;
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

        if RoutesBEKind <> 3 then               /// 27-09-18
           SetLength(Route[J].GWPT,0);

        Route[J].Status := 0;
        Route[J].Fixed := false;
        Route[J].Geo := (RoutesDatum = WGS) and (isRoutesDatum) and (RoutesCS = 0); //Settings.SK.ItemIndex=0;

        if RoutesBEKind = 0 then
        begin

            // ������ � �����
            if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false) and (CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesXTab,1, RoutesRSpacer, true),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesYTab,1, RoutesRSpacer, true),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesXTab,1, RoutesRSpacer, true));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesYTab,1, RoutesRSpacer, true));
                end;

            Route[J].Gx1 := _X;
            Route[J].Gy1 := _Y;
            if RoutesZTab<>-1 then
               Route[J].Gz1 := StrToFloat(GetCols(F[I2],RoutesZTab,1, RoutesRSpacer, true))
                  else
                    Route[J].Gz1 := 0;

            if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                  _X := StrToLatLon(GetCols(F[I2],RoutesX2Tab,1, RoutesRSpacer, true),true);
                  _Y := StrToLatLon(GetCols(F[I2],RoutesY2Tab,1, RoutesRSpacer, true),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesX2Tab,1, RoutesRSpacer, true));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesY2Tab,1, RoutesRSpacer, true));
                end;

            Route[J].Gx2 := _X;
            Route[J].Gy2 := _Y;
            if RoutesZTab<>-1 then
              Route[J].Gz2 := StrToFloat2(GetCols(F[I2],RoutesZ2Tab,1, RoutesRSpacer, true))
                 else
                    Route[J].Gz2 := 0;

        end
          else
            if isBegin then
            begin
                // ������

               if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesXTab,1, RoutesRSpacer, true),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesYTab,1, RoutesRSpacer, true),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesXTab,1, RoutesRSpacer, true));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesYTab,1, RoutesRSpacer, true));
                end;

                Route[J].Gx1 := _X;
                Route[J].Gy1 := _Y;
                if RoutesZTab<>-1 then
                   Route[J].Gz1 := StrToFloat2(GetCols(F[I2],RoutesZTab,1, RoutesRSpacer, true))
                     else
                       Route[J].Gz1 := 0;

                if RoutesBEKind = 3 then     //// 27-09-18
                begin
                    SetLength(Route[J].GWPT, 1);
                    Route[J].GWPT[0].x := _X;
                    Route[J].GWPT[0].y := _Y;
                end;       

                Route[J].Gx2 := Route[J].Gx1;   ///// ADDED 21.06
                Route[J].Gy2 := Route[J].Gy1;
                Route[J].Gz2 := Route[J].Gz1;       
            end
              else
              begin
                // �����
                if ((isRoutesDatum)and(RoutesCS=0))
                or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
                begin
                 _X := StrToLatLon(GetCols(F[I2],RoutesXTab,1, RoutesRSpacer, true),true);
                 _Y := StrToLatLon(GetCols(F[I2],RoutesYTab,1, RoutesRSpacer, true),false);
                end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I2],RoutesXTab,1, RoutesRSpacer, true));
                  _Y := StrToFloat2(GetCols(F[I2],RoutesYTab,1, RoutesRSpacer, true));
                end;

                if RoutesBEKind = 3 then        //// 27-09-18
                begin
                   SetLength(Route[J].GWPT, Length(Route[J].GWPT)+1);
                   Route[J].GWPT[Length(Route[J].GWPT)-1].x := _X;
                   Route[J].GWPT[Length(Route[J].GWPT)-1].y := _Y;
                end;
                Route[J].Gx2 := _X;
                Route[J].Gy2 := _Y;
                if RoutesZTab<>-1 then
                  Route[J].Gz2 := StrToFloat2(GetCols(F[I2],RoutesZTab,1, RoutesRSpacer, true))
                    else
                      Route[J].Gz2 := 0;

              end;

     end;

     for J := 0 to RouteCount-1 do
      if not Route[J].Geo then
      Begin
         Route[J].Geo := True;
         // ������� � WGS

          if isRoutesDatum = false then
          begin
            /// RouteCS - C�

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

            if RoutesBEKind = 3 then        //// 27-09-18
            begin
              for K := 0 to Length(Route[J].GWPT) - 1 do
              begin
                if  CoordinateSystemList[RoutesCS].ProjectionType <=1 then
                CoordinateSystemToDatum(RoutesCS,
                                    Route[J].GWPT[K].X, Route[J].GWPT[K].Y, 0,
                                    Route[J].GWPT[K].X, Route[J].GWPT[K].Y, _Z)
                else
                   CoordinateSystemToDatum(RoutesCS,
                                    Route[J].GWPT[K].Y, Route[J].GWPT[K].X, 0,
                                    Route[J].GWPT[K].X, Route[J].GWPT[K].Y, _Z);


                Geo1ForceToGeo2(Route[J].GWPT[K].X, Route[J].GWPT[K].Y, 0,
                            CoordinateSystemList[RoutesCS].DatumN, WGS,
                            Route[J].GWPT[K].X, Route[J].GWPT[K].Y, _Z);

              end;

            end;

          end
            else
            begin
              /// RouteCS - ��� ��������
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

                   if RoutesBEKind = 3 then        //// 27-09-18
                   begin
                       for K := 0 to Length(Route[J].GWPT) - 1 do
                         if RoutesDatum <> WGS then
                           Geo1ForceToGeo2(Route[J].GWPT[K].X, Route[J].GWPT[K].Y, 0, RoutesDatum,
                                   WGS, Route[J].GWPT[K].X, Route[J].GWPT[K].Y, _Z);

                   end;

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


                   if RoutesBEKind = 3 then        //// 27-09-18
                   begin
                     //// NOT SUPPORTED

                   end;
                 end;
                 2:  begin
                   // GK
                   GaussKrugerToGeo(RoutesDatum, Route[J].Gy1, Route[J].Gx1,
                                    Route[J].Gx1, Route[J].Gy1 );
                   GaussKrugerToGeo(RoutesDatum, Route[J].Gy2, Route[J].Gx2,
                                    Route[J].Gx2, Route[J].Gy2 );

                   if RoutesDatum <> WGS then
                   Begin
                     Geo1ForceToGeo2(Route[J].Gx1,Route[J].Gy1,0, RoutesDatum,
                                   WGS, Route[J].Gx1, Route[J].Gy1, Route[J].Gz1);
                     Geo1ForceToGeo2(Route[J].Gx2,Route[J].Gy2,0, RoutesDatum,
                                   WGS, Route[J].Gx2, Route[J].Gy2, Route[J].Gz2);
                   End;

                   if RoutesBEKind = 3 then        //// 27-09-18
                   begin
                      for K := 0 to Length(Route[J].GWPT) - 1 do
                      begin
                          GaussKrugerToGeo(RoutesDatum, Route[J].GWPT[K].Y, Route[J].GWPT[K].X,
                                                Route[J].GWPT[K].X, Route[J].GWPT[K].Y );

                          if RoutesDatum <> WGS then
                             Geo1ForceToGeo2(Route[J].GWPT[K].X, Route[J].GWPT[K].Y, 0, RoutesDatum,
                                        WGS, Route[J].GWPT[K].X, Route[J].GWPT[K].Y, _Z);

                      end;
                   end;

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

                   if RoutesBEKind = 3 then        //// 27-09-18
                   begin
                      for K := 0 to Length(Route[J].GWPT) - 1 do
                      begin
                          UTMToGeo(RoutesDatum, Route[J].GWPT[K].X, Route[J].GWPT[K].Y, RoutesCS = 4,
                                    Route[J].GWPT[K].X, Route[J].GWPT[K].Y);

                          if RoutesDatum <> WGS then
                             Geo1ForceToGeo2(Route[J].GWPT[K].X, Route[J].GWPT[K].Y, 0, RoutesDatum,
                                        WGS, Route[J].GWPT[K].X, Route[J].GWPT[K].Y, _Z);

                      end;

                   end;

                 end;
              end;
            end;
      End;
    // FrameFile :='';

     I := Length(FileName);
     repeat
        Dec(I)
     until (Filename[I]='.')or(I<=1);

     Insert ('_f', Filename, I{Length(filename)-3});
     NewFrame := Fileexists(Filename);

     if (NewFrame)and( FrameCount > 0) then
        NewFrame := MessageDLG(AskS, MtConfirmation, mbYesNo, 0) = 6;

     if NewFrame then
     begin
         Frame := true;
         FrameFile := Filename;

         FrameCount := 0;
         FrameGeo   := false;

         if (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.xls')or
            (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5))='.xlsx')  then
             ExcelToStringList(FileName, F)
         else
             F.LoadFromFile(FileName);
    
         Frame := True;
         FrameGeo := (RoutesDatum = WGS) and (isRoutesDatum) and (RoutesCS = 0);


         j := 2;

         for I := 0 to F.Count - 1 do
         Begin
              if ((isRoutesDatum)and(RoutesCS=0))
               or((isRoutesDatum = false)and(CoordinateSystemList[RoutesCS].ProjectionType=0)) then
               begin
                 _X := StrToLatLon(GetCols(F[I],1,1, RoutesRSpacer, true),true);
                 _Y := StrToLatLon(GetCols(F[I],2,1, RoutesRSpacer, true),false);
               end
                else
                begin
                  _X := StrToFloat2(GetCols(F[I],1,1, RoutesRSpacer, true));
                  _Y := StrToFloat2(GetCols(F[I],2,1, RoutesRSpacer, true));
                end;


             FramePoints[I, j].x := _X;// StrToFloat(GetCols(F[I],1,1, LoadRData.RSpacer.itemIndex));
             FramePoints[I, j].y := _Y;//StrToFloat(GetCols(F[I],2,1, LoadRData.RSpacer.itemIndex));
             if RoutesZTab<>-1 then
                FramePoints[I, j].z := StrToFloat2(GetCols(F[I],3,1, RoutesRSpacer, true))
                  else
                    FramePoints[I, j].z := 0;

             inc(FrameCount);
         End;

         if FrameCount>1  then
         begin
            inc(FrameCount);
            FramePoints[FrameCount-1, j].x := FramePoints[0, j].x;
            FramePoints[FrameCount-1, j].y := FramePoints[0, j].y;
            FramePoints[FrameCount-1, j].z := FramePoints[0, j].z;
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
                     GaussKrugerToGeo(RoutesDatum, FramePoints[J, 2].y, FramePoints[J, 2].x,
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
              /// RouteCS - ��� ��������

            end;
                  }
     ///---

     ReComputeRoutes(WaitForZone, OldRouteCount);
     AddRoutes := False;
//     SetCurrentRoute(0);
 except
   MessageDlg('Unable to load routes',mtError, [mbOk],0);
 end;
  RecomputeBaseObjects(WaitForZone);
 F.Free;
end;

function LoadRoutesFromRTS(FileName: String; DoAdd:Boolean; askS:string):integer;

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
     F       :TStringList;
     I, J, K :Integer;
     s1  :String;
     isFrame  :Boolean;
     stat, fix :integer;
     askFrame, OldFrame :Boolean;
     oldRouteCount :Integer;
     B, L, A    :Double;
begin
   F := TStringList.Create;

   askFrame      := false;
   oldRouteCount := RouteCount;
   OldFrame      := false;

   if DoAdd = false then
   begin
      RouteCount := 0;
      FrameCount := 0;
      Frame      := false;
      FrameGeo   := true;
      oldRouteCount := 0;
   end;

   isFrame := false;
   Result  := -1; //// ����� ������, ��� ���������� ����

   if filename<>'' then
   try
     F.LoadFromFile(FileName);

     for I := 0 to F.Count - 1 do
     begin
       if F[I] = '//Routes' then
          continue;

       if F[I] = '//Frame' then
       Begin
          isFrame := true;
          continue;
       End;

       if F[I] = '//Track' then
       Begin
          Result := I+1;
          break;
       End;

       if not isFrame then
       Begin
         // �������� ���
         s1 := GetCols(F[I], 0, 1, 1, true);
         stat :=  trunc(StrToFloat2(GetCols(F[I], 3, 1, 1, true)));
         fix :=  trunc(StrToFloat2(GetCols(F[I], 6, 1, 1, true)));
         A  :=  StrToFloat2(GetCols(F[I], 7, 1, 1, true));
         TestName(s1, oldRouteCount);


         // ��� �� �����
         J  := -1;
         for K := oldRouteCount to RouteCount - 1 do
           if Route[K].Name = s1 then
           begin
             J := K;
             Break;
           end;

         //�������� �����
         if J = -1 then
         Begin
           if RouteCount < RouteMax -1 then
           Begin
              inc(RouteCount);
              J := RouteCount - 1;
              Route[J].Geo := True;
              Route[J].Name := s1;
              SetLength(Route[J].GWPT,0);
              SetLength(Route[J].ALT,0);
              Route[J].Status := stat;
              Route[J].fixed := fix > 0;
           End
              else
              Begin
                 MessageDlg('RouteLimit is over. Unable to load more',mtError, [mbOk],0);
                 break;
              End;
         End;

         // ���������� �����

         SetLength(Route[J].GWPT, Length(Route[J].GWPT)+1);
         SetLength(Route[J].ALT, Length(Route[J].GWPT)+1);
         B := StrToFloat2(GetCols(F[I], 1, 1, 1, true));
         L := StrToFloat2(GetCols(F[I], 2, 1, 1, true));

         Route[J].GWPT[Length(Route[J].GWPT)-1].x := B;    /// �������������
         Route[J].GWPT[Length(Route[J].GWPT)-1].y := L;

         Route[J].ALT[Length(Route[J].GWPT)-1] := A;
         
         if Length(Route[J].GWPT) <= 1 then
         Begin
            Route[J].Gx1 := B;     /// ������
            Route[J].Gy1 := L;
            Route[J].Gx2 := B;     /// �����
            Route[J].Gy2 := L;
         End
          else
          Begin
            Route[J].Gx2 := B;     /// �����
            Route[J].Gy2 := L;
          End;

       End
         else
           Begin

               if DoAdd then
               begin
                 if FrameCount > 0 then
                 if askFrame = false then
                 begin
                   if  MessageDLG(AskS, MtConfirmation, mbYesNo, 0) = 6 then
                   begin
                     FrameCount := 0;
                     FrameGeo   := true;
                     OldFrame   := false;
                   end
                     else
                       OldFrame := true;
                 end;
                 askFrame := true;
               end;

              if OldFrame then
                 continue;

              if FrameCount < FrameMax -1 then
                 inc(FrameCount);

              B := StrToFloat2(GetCols(F[I], 1, 1, 1, true));
              L := StrToFloat2(GetCols(F[I], 2, 1, 1, true));

              FramePoints[FrameCount -1, 2].x := B;
              FramePoints[FrameCount -1, 2].y := L;
           End;

     end;


   except
       MessageDlg('Unable to load routes',mtError, [mbOk],0);
   end;

 if FrameCount > 0 then
 Begin
   FrameGeo := True;
   Frame    := True;

   inc(FrameCount);
   FramePoints[FrameCount -1, 2].x := FramePoints[0, 2].x;
   FramePoints[FrameCount -1, 2].y := FramePoints[0, 2].y;
 End;

 ReComputeRoutes(WaitForZone, OldRouteCount);
 AddRoutes := False;
 //SetCurrentRoute(0);
 F.Free;
end;


procedure ReComputeBase(WFZ: Boolean);
var X, Y : Double;
begin
   WaitForZone := WFZ;


   if UTM then
      GeoToUTM(WGS,Base[2].x,Base[2].y, South, y, x, Myzone, WaitForZone)
        else
          WGSToSK(Base[2].x,Base[2].y,0, x, y, MyZone, WaitForZone);
   Base[1].x := x;
   Base[1].y := y;


   if WFZ then
   Begin
     RecomputeRoutes(False);
   End;

end;

procedure ReComputeMarkers(WFZ: Boolean);
var X, Y : Double;
    i    : integer;
begin
   if Length(Markers) = 0 then
      exit;

   WaitForZone := WFZ;

   For I := 0 to Length(Markers)-1 Do
   Begin
      if UTM then
        GeoToUTM(WGS, Markers[i].gx, Markers[i].gy, South, y, x, Myzone, WaitForZone)
        else
          WGSToSK(Markers[i].gx, Markers[i].gy, 0, x, y, MyZone, WaitForZone);

     Markers[i].x := x;
     Markers[i].y := y;

     WaitForZone := false;

     if Markers[i].MarkerName = '' then
          Markers[i].MarkerName := '*';
   End;

   if WFZ then
   Begin
     RecomputeRoutes(False);
   End;

   if WaitForCenter then
   Begin
      Center.x := Markers[Length(Markers)-1].x;
      Center.y := Markers[Length(Markers)-1].y;
      ShiftCenter := Center;
      WaitForCenter := False;
   End;
end;

procedure ReComputeMaps(WFZ: Boolean);
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

procedure ReComputeRoutes(WFZ: Boolean);
begin
   ReComputeRoutes(WFZ, 0);
end;

procedure FilterRoutePoints(FromI:Integer);
var i, j, k, newSize  :integer;
    xx,yy :Double;
Begin

   if (RouteCount = 0) and (FrameCount = 0) then
     exit;

  for I := FromI to RouteCount - 1 do
  begin
     newSize := Length(Route[I].WPT);
     for J := newSize - 1 DownTo 1 do
     Begin
       if (abs(Route[I].WPT[j].x-Route[I].WPT[j-1].x) < 1E-3) and
          (abs(Route[I].WPT[j].y-Route[I].WPT[j-1].y) < 1E-3) then
          begin
            for k := J to newsize - 2 do
            begin
               Route[I].WPT[k].x  := Route[I].WPT[k+1].x;
               Route[I].WPT[k].y  := Route[I].WPT[k+1].y;
               Route[I].GWPT[k].x := Route[I].GWPT[k+1].x;
               Route[I].GWPT[k].y := Route[I].GWPT[k+1].y;
            end;
            dec(newSize);
          end;

     End;
     SetLength(Route[I].WPT,  newSize);
     SetLength(Route[I].GWPT, newSize);

  end;
End;

procedure ReComputeRoutes(WFZ: Boolean; FromI:Integer);
var i, j  :integer;
    xx,yy :Double;
    Str   :String;
begin

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

  if (RouteCount = 0) and (FrameCount = 0) then
     exit;

  for I := FromI to RouteCount - 1 do
  begin
     if i = 0 then
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
     LoadedRoutesList.StringGrid1.Cells[5,I+1] := Str;  }
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
      End;

      if length(Route[i].GWPT)=0 then        ///// ADDED 21.06
      Begin                                   //// Modified 22.03
        if (Route[i].Gx2 = Route[i].Gx1) and
           (Route[i].Gy2 = Route[i].Gy1) then
        Begin
          SetLength(Route[i].GWPT,1);
          Route[i].GWPT[0].x := Route[i].Gx1;
          Route[i].GWPT[0].y := Route[i].Gy1;
        End
        else
          Begin
            SetLength(Route[i].GWPT,2);
            Route[i].GWPT[0].x := Route[i].Gx1;
            Route[i].GWPT[0].y := Route[i].Gy1;
            Route[i].GWPT[1].x := Route[i].Gx2;
            Route[i].GWPT[1].y := Route[i].Gy2;
          End
      End;


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


        SetLength(Route[I].WPT, Length(Route[I].GWPT));
        for J := 0 to Length(Route[I].GWPT) - 1 do
        Begin
            if UTM then
            GeoToUTM(WGS,Route[i].GWPT[J].x, Route[i].GWPT[J].y,
                     South, Route[i].WPT[J].y, Route[i].WPT[J].x, Myzone, WaitForZone)
             else
                WGSToSK(Route[i].GWPT[J].x, Route[i].GWPT[J].y, 0,
                        Route[i].WPT[J].x, Route[i].WPT[J].y, MyZone, WaitForZone);
        End;


        if WaitForCenter then
        Begin
          Center.X := xx;
          Center.y := yy;
          ShiftCenter := Center;
          WaitForCenter := false;
        End;

      End;

  end;

  if (Frame)and(FrameCount>0) then
  Begin

   if FrameGeo = false then
   for I := 0 to FrameCount - 1 do
   begin
     if i=0 then
      WaitForZone := WFZ
       else
           WaitForZone := false;

     if UTM then /// UTM
          UTMToGeo(WGS,FramePoints[i,1].x, FramePoints[i,1].y, South, xx, yy)
            else
              SKToWGS(FramePoints[i,1].y, FramePoints[i,1].x, 0, xx, yy);
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

     if not WaitForZone then
     begin
       if i=0 then
        WaitForZone := WFZ
         else
           WaitForZone := false;
     end;

      if WaitForCenter then
        Begin
          Center.X := xx;
          Center.Y := yy;
          ShiftCenter := Center;
          WaitForCenter := false;
        End;

   end;
  End;
 
   if (WFZ) then
   Begin
     WaitForZone := False;
     RecomputeRoutes(False);
   End;

  
end;

procedure DrawBase(AsphCanvas: TAsphyreCanvas; AsphImages: TAsphyreImages;
      Color:Cardinal);
var
    B : TMyPoint;
    csize: integer;
begin

     B := MapToScreen(Base[1].x,Base[1].y);

     csize := 32;
     if BigIcons then
        csize := 64;


     if (B.x > - csize) and (B.x < DispSize.X + csize) then
     if (B.y > - csize) and (B.y < DispSize.y + csize) then
         begin
            if BigIcons then
                AsphCanvas.UseImagePx(AsphImages.Image['flag_big.image'],
                                        pxBounds4(0, 0, 64, 64))
                else
                   AsphCanvas.UseImagePx(AsphImages.Image['flag.image'],
                                        pxBounds4(0, 0, 32, 32));

             AsphCanvas.TexMap(pRotate4c(Point2(B.x, B.y),Point2(csize, csize), 0),
                    cColor4(Color));
         end;
end;


procedure DrawLines(AsphCanvas: TAsphyreCanvas; Color:Cardinal; Smooth: Boolean);
  var
     i, j, lcount, lstep, jump : Integer;
     MyLines : array [1..2] of TMyPoint;

  const
     Dash = false;
begin

    if Mashtab < MaxMashtab-2 then
      lstep := TMashtab[Mashtab+1]
        else
          lstep := TMashtab[Mashtab];

    if (DispSize.X) > DispSize.Y then
          lcount := trunc(DispSize.X /2 * Scale / lstep)+1
            else
              lcount := trunc(DispSize.Y /2 * Scale / lstep)+1;

    if lcount > 1000 then
      exit;

    jump := 0;
    case lcount of
      501..1000 : jump := 50;
      251..500 : jump := 25;
      101..250 : jump := 10;
      51..100 : jump := 5;
      25..50 : jump := 2;
    end;


    for J := -lcount to lcount do
    Begin
         if jump <> 0 then
           if J mod jump <> 0 then
              continue;

         Mylines[1].X := Trunc(Center.x /lstep)*lstep;
         Mylines[1].Y := Trunc(Center.y /lstep)*lstep + J*lstep;

         Mylines[2].X := Mylines[1].X + (DispSize.X) *Scale;
         Mylines[2].Y := Mylines[1].Y;
         Mylines[1].X := Mylines[1].X - (DispSize.X) *Scale;

         Mylines[1] := MapToScreen(MyLines[1].X, MyLines[1].Y);
         Mylines[2] := MapToScreen(MyLines[2].X, MyLines[2].Y);

         MyLine(AsphCanvas, MyLines[1].X, MyLines[1].Y, MyLines[2].X, MyLines[2].Y,
                Dash, Smooth, Color);
    end;

    for I := -lcount to lcount do
    begin
         if jump <> 0 then
           if I mod jump <> 0 then
             continue;

         Mylines[1].X := Trunc(Center.x /lstep)*lstep + I*lstep;
         Mylines[1].Y := Trunc(Center.y /lstep)*lstep;

         Mylines[2].X := Mylines[1].X;
         Mylines[2].Y := Mylines[1].Y + (DispSize.X) * Scale;
         Mylines[1].Y := Mylines[1].Y - (DispSize.X) * Scale;

         Mylines[1] := MapToScreen(MyLines[1].X, MyLines[1].Y);
         Mylines[2] := MapToScreen(MyLines[2].X, MyLines[2].Y);

         MyLine(AsphCanvas, MyLines[1].X, MyLines[1].Y, MyLines[2].X, MyLines[2].Y,
              Dash, Smooth, Color);
    End;

end;

procedure DrawMaps(AsphCanvas: TAsphyreCanvas; AsphMapImages: TAsphyreImages;
    Delta:Double);
var  i, j, ImgN, reImgN : Integer;
     _C, _D : array [1..4] of TMyPoint;
     L, xmin, ymin, xmax, ymax : double ;
     Col : TColor4;
     NeedReDraw: boolean;
begin

    NeedReDraw:=false;

    for I := 0 to Length(MapList) - 1 do
    Begin
       for j := 1 to 4 do
       Begin
          _C[j] := MapToScreen(MapList[i].x[j],MapList[i].y[j]);
       End;

       try
          L := sqrt(sqr(_C[4].x - _C[1].x) + sqr(_C[4].y - _C[1].y));
       except
         continue;
       end;

       if (L < 5 * MinMap) then
         continue;

       if (L > 5 * MaxMap) then
         continue;


       xmin := _C[1].x;
       ymin := _C[1].y;
       xmax := _C[1].x;
       ymax := _C[1].y;
       for j := 2 to 4 do
       begin
         if _C[j].x < xmin then
           xmin := _C[j].x;
         if _C[j].y < ymin then
           ymin := _C[j].y;

         if _C[j].x > xmax then
           xmax := _C[j].x;
         if _C[j].y > ymax then
           ymax := _C[j].y;
       end;

       if (xmax<0)and(xmin<0) or (xmax > DispSize.X)and(xmin > DispSize.X) then
           continue;

       if (ymax<0)and(ymin<0) or (ymax > DispSize.Y)and(ymin > DispSize.Y) then
           continue;


       if L < 45 then
           ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName+'_t'] )
           else
           if l < 200 then
              ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName+'_s'] )
               else
                 ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName] );


       if ImgN = -1 then
          ImgN := AsphMapImages.IndexOf( AsphMapImages.Image[MapList[i].imgName] );

       AsphCanvas.UseImagePx(AsphMapImages.Items[ImgN], pxBounds4(0, 0,
                  AsphMapImages.Items[ImgN].PatternSize.x, AsphMapImages.Items[ImgN].PatternSize.y ));

       if MapAlpha=255 then
         Col := ClWhite4
          else
            Col := cRGB4(255,255,255,MapAlpha);

        if i = MapChoosed then
        Begin
          MapAnim := MapAnim + Delta*0.1;
          if MapAnim > 30*pi then
             MapAnim := MapAnim-30*pi;

          J := 155 + Trunc(100*Sin(MapAnim));
          Col := cRGB4(55,j,55,255);

          reImgn := ImgN;
          needReDraw := true;
          _D := _C;
        End;

        AsphCanvas.TexMap(Point4( _C[1].x, _C[1].y,  _C[2].x, _C[2].y,
                             _C[3].x, _C[3].y,  _C[4].x, _C[4].y), Col)
   End;

   if NeedRedraw then
   Begin
        J := 155 + Trunc(100*Sin(MapAnim));
        Col := cRGB4(55,j,55,155);

        AsphCanvas.UseImagePx(AsphMapImages.Items[reImgN], pxBounds4(0, 0,
                  AsphMapImages.Items[reImgN].PatternSize.x, AsphMapImages.Items[reImgN].PatternSize.y ));

        AsphCanvas.TexMap(Point4( _D[1].x, _D[1].y,  _D[2].x, _D[2].y,
                             _D[3].x, _D[3].y,  _D[4].x, _D[4].y), Col)

   End;

end;

procedure DrawRouteArrows(N:Integer;  Col:Cardinal);
 var i,j : integer;
     L, Ang : Double;
     P1, P2 : TMyPoint;
     needpt, onscreen : boolean;
 const
   MinL = 50;
   MinLineL = 250;
begin
    if Length(Route[N].WPT) <= 1 then
      exit;


    for J := 1 to Length(Route[N].WPT)-1 do
    BEGIN
      P1 := MapToScreen(Route[N].WPT[j-1].X, Route[N].WPT[j-1].Y);
      P2 := MapToScreen(Route[N].WPT[j].X, Route[N].WPT[j].Y);


      Ang := arctan2(Route[N].WPT[j].X - Route[N].WPT[j-1].X,
                     Route[N].WPT[j].Y - Route[N].WPT[j-1].Y);

      OnScreen :=  (not( (P1.x < 0) and (P2.x < 0) ))  and
                   (not( (P1.x > DispSize.X) and (P2.x > DispSize.X))) and
                   (not( (P1.y < 0) and (P2.y < 0))) and
                   (not( (P1.y > DispSize.y) and (P2.y > DispSize.y))) and
                   (not( (abs(P1.y-P2.y) < 1) and (abs(P1.x-P2.x) < 1) ));

      L := abs(P1.y-P2.y) + abs(P1.x-P2.x);
      needpt := L > MinL;

      if needpt or ((J = 1) and (OnScreen)) then
      begin
         AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
         AsphCanvas.TexMap(pRotate4c(Point2(P1.x,P1.y),Point2(14, 14), Ang+fi),cColor4(Col));
      end;

      if (J = Length(Route[N].WPT)-1) and (OnScreen)  then
      begin
         AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
         AsphCanvas.TexMap(pRotate4c(Point2(P2.x,P2.y),Point2(14, 14), Ang+fi),cColor4(Col));
      end;

      if (L > MinLineL) and OnScreen then
      begin
        CutLineByFrame(P1.x, P1.y, P2.x, P2.y);
        if abs(P1.y-P2.y) + abs(P1.x-P2.x) > MinL then
        begin
           AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
           AsphCanvas.TexMap(pRotate4c(Point2((P2.x + P1.x)/2,(P1.y + P2.y)/2),Point2(14, 14), Ang+fi),cColor4(Col));
        end;
      end;

    END;
end;

procedure DrawRoutes(AsphCanvas: TAsphyreCanvas;
      ChoosedColor, RoutesColor, DoneColor, FrameColor, FntColor, MenuColor,
      HiddenColor :Cardinal;
      Smooth, DrawAllLabels: Boolean; LStyle :Integer; DoLabels:Boolean);

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
      case Route[I].Status of
         0,1: Col := RoutesColor;
         2,3: Col := DoneColor;
         else Col := HiddenColor - $D1000000;
      end;


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
        if Length(Route[i].WPT) < 3 then
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

           if I = RouteAsk then
             FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 3, false, Smooth, ChoosedColor);

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

               FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, FrameColor);
            end;
       End;

  //// Labels
  if Length(Markers) = 0 then
    if DoLabels then
      DrawLabels(FntColor, MenuColor, DrawAllLabels, LStyle);
end;

function MarkersAreLoops:boolean;
var I, j:Integer;
    b:array[1..4] of Boolean;
begin
  result := false;

  for j := 1 to 4 do
  begin
     b[j] := false;

     for I := 0 to Length(Markers)- 1 do
     BEGIN

       if (Markers[I].MarkerKind > 0) and (Markers[I].MarkerKind < 10) then
       begin
         result := true;
         exit;
       end;

       if length(Markers[I].MarkerName) > 4 then
        if AnsiLowerCase(Copy(Markers[I].MarkerName, length(Markers[I].MarkerName)-2, 3))
             = '_k'+inttostr(j) then
          begin
              b[j] := true;
              break;
          end;
     END;
  end;

  result := b[1] and b[2] and b[3] and b[4];

end;

function  MarkersUDFCount:integer;
var I:Integer;
begin
  result := 0;
  for I := 0 to Length(Markers)- 1 do
    if Markers[i].MarkerKind = 10 then
      inc(result);    
end;

procedure DrawMarkerLoops(AsphCanvas: TAsphyreCanvas; Color:Cardinal;
      Smooth:Boolean);
var
    P1, P2 : TMyPoint;
    I, j, I1, I2, shifted, collected : integer;
    s, s2 :string;
    isOk :Boolean;
begin

   For  I := 0 To Length(Markers) - 1 Do
   Begin

     s := AnsiLowerCase(Markers[I].MarkerName);
     s := Copy(s, Length(s)-2, 3);
     isOk := True;
     if s = '_k1' then
     begin
       collected := 0;
       s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));
       repeat
           s := AnsiLowerCase(Markers[I+collected].MarkerName);
           if s = s2 + '_k' + IntToStr(collected+1) then
             inc(collected)
           else
             break;
       until I+collected > Length(Markers)-1;

       if collected >3 then
       begin
         for j := 0 to collected-1 do
         begin
            I1 := I + j;
            if j < collected-1 then
              I2 := I + j + 1
            else
              I2 := I;

            P1 := MapToScreen(Markers[i1].x, Markers[i1].y);
            P2 := MapToScreen(Markers[i2].x, Markers[i2].y);
            FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 0, false, Smooth, Color);
         end;
       end
       else
       if collected <= 3 then
       begin
       /////////////////------------

       shifted := 0;
       s2 := AnsiLowerCase( Copy(Markers[I].MarkerName, 1,
                            Length(Markers[I].MarkerName)-3));
       for j := 1 to 3 do
         if i+j <=  Length(Markers) - 1 then
         begin

           s := AnsiLowerCase(Markers[I+j].MarkerName);
           if s = s2 + '_k' + IntToStr(j+1) then
             isOk := true
           else
              if i > 3 then
              begin
                s := AnsiLowerCase(Markers[I+j-4].MarkerName);
                if s = s2 + '_k' + IntToStr(j+1) then
                begin
                  if shifted = 0 then
                     shifted := 4-j;
                  isOk := true
                end
                else
                  begin
                    isOk := false;
                    break;
                  end;
              end
             else
           begin
              isOk := false;
              break;
           end;

         end
          else


          if i > 3 then
              begin
                s := AnsiLowerCase(Markers[I+j-4].MarkerName);
                if s = s2 + '_k' + IntToStr(j+1) then
                begin
                  if shifted = 0 then
                     shifted := 4-j;
                  isOk := true
                end
                else
                 begin
                    isOk := false;
                    break;
                  end;
              end
             else
          begin
            isOk := false;
            break;
          end;

         if isOk then
         for j := 0 to 3 do
         begin
            I1 := I + j -shifted;
            if j < 3 then
              I2 := I + j +1 -shifted
            else
              I2 := I -shifted;
            P1 := MapToScreen(Markers[i1].x, Markers[i1].y);
            P2 := MapToScreen(Markers[i2].x, Markers[i2].y);
            FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 0, false, Smooth, Color);
         end;
     end;
     /////////////////------------
     end;
   End;
end;

procedure DrawMarkers(AsphCanvas: TAsphyreCanvas; AsphImages: TAsphyreImages;
      Color, FntColor, MenuColor, LineColor, DopColor :Cardinal; DrawSpecial: boolean;
      Lstyle : Integer; DoLabels, DoLoops, Smooth:Boolean);
var
    P : TMyPoint;
    csize ,i : integer;
    ang:real;
    nm:string;
begin

   For I := 0 to Length(Markers) - 1 Do
   Begin
     P := MapToScreen(Markers[i].x, Markers[i].y);

     csize := 16;
     if BigIcons then
        csize := 32;

     nm := 'marker2';

     if Markers[i].MarkerKind = 5 then
     begin
        nm := 'arrow1';
        csize := round(csize * 1.5)
     end;

     if DoLoops then
     Begin
        if Markers[i].MarkerKind = 2 then
          csize := round(csize *0.5);
        if (Markers[i].MarkerKind = 3)
          or (Markers[i].MarkerKind = 10) then
          csize := round(csize *0.75);
        if (Markers[i].MarkerKind > 1) and (Markers[i].MarkerKind <> 5) then
          nm := 'marker1';

     End;


     if (P.x > - csize) and (P.x < DispSize.X + csize) then
     if (P.y > - csize) and (P.y < DispSize.y + csize) then
         begin
            if (BigIcons) and (Markers[i].MarkerKind <> 5) then
                AsphCanvas.UseImagePx(AsphImages.Image[nm+'_big.image'],
                                        pxBounds4(0, 0, 32, 32))
            else
            if (Markers[i].MarkerKind <> 5) then
                   AsphCanvas.UseImagePx(AsphImages.Image[nm+'.image'],
                                        pxBounds4(0, 0, 16, 16))
            else
               AsphCanvas.UseImagePx(AsphImages.Image[nm+'.image'],
                                        pxBounds4(0, 0, 32, 32));
             ang := 0;
             if Markers[i].MarkerKind = 5 then
               Ang := Markers[I].Alt*pi/180;

             if Pos('!#', Markers[I].MarkerName) = 1 then
             begin
                if not DrawSpecial then
                  continue;
                AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'],
                                        pxBounds4(0, 0, 32, 32));
                Csize := Csize*2;
                Ang := StrToFloat2(Markers[I].MarkerName)*pi/180 + fi;

                if Ang > 5 then
                Begin
                   AsphCanvas.UseImagePx(AsphImages.Image['dot.image'],
                                        pxBounds4(0, 0, 8, 8));
                   Csize := 8;
                End;
             end;

             if (Markers[i].MarkerKind = 10) and (DoLoops) then
               AsphCanvas.TexMap(pRotate4c(Point2(P.x, P.y),Point2(csize, csize), ang),
                    cColor4(DopColor))
             else
             AsphCanvas.TexMap(pRotate4c(Point2(P.x, P.y),Point2(csize, csize), ang),
                    cColor4(Color));
         end;
   End;

  if DoLoops then
    DrawMarkerLoops(AsphCanvas, LineColor, Smooth);

  if DoLabels then
     DrawLabels(FntColor, MenuColor, DrawSpecial, Lstyle);
end;

procedure DrawLabels(FntColor, MenuColor:Cardinal; DrawAll:Boolean;
    LStyle:Integer);

 procedure LabelOut(P :TMyPoint; w, dy: Integer; str : string);
 begin

    if lstyle = 1 then
       AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w+1,trunc(P.y)+1 - dy),
                                        str ,cRGB2(255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255,
                                                   255-GetRValue(FntColor),
                                                   255-GetGValue(FntColor),
                                                   255-GetBValue(FntColor), 255));


    if lstyle = 2 then
        AsphCanvas.FillRect(Rect (trunc(P.X - w) -2,
                                  trunc(P.Y) - 1 - dy,
                                  trunc(P.X + w) +2,
                                  trunc(P.Y) + 14 -dy), cColor4(MenuColor) );

    AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y) - dy),
                                        str ,cColor2(FntColor));


  end;
const AMAx = 512;

var i, j, w, dy :Integer;
    P :TMyPoint;
    canLabel: Boolean;
    A: array [1..AMax] of TMyPoint;
    Asize : array [1..AMax] of Integer;
    ACount : integer;

    str:string; PHgt:Double;
begin

   Acount :=0;

   for I := 0 to RouteCount - 1 do
     If Length(Route[I].WPT) = 1 Then
     Begin
       P := MapToScreen(Route[i].x1,Route[i].y1);

       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       w := round(AsphFonts[Font0].TextWidth(Route[i].Name)/2);

       canlabel := true;
       for J := 1 to ACount+1 do
          if (P.y - dy> A[j].Y - 32)and(P.y - dy < A[j].Y + 32) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;

       if not canlabel then
            continue;

       if Acount < AMAx then
         inc(Acount);

       dy := 18;

       A[Acount].X := P.x;
       A[Acount].Y := P.y -dy ;
       Asize[Acount] := w;

      

       if CanLabel then
          AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
                                       Route[i].Name, cColor2(FntColor));

     End;


     for I := 0 to Length(Markers) - 1 do
     if (Markers[i].MarkerName<>'*') and (Pos('!#', Markers[I].MarkerName) <> 1) then
     Begin
       P := MapToScreen(Markers[i].x,Markers[i].y);
       
       if not ( (P.x > - 16)and(P.x <  DispSize.X + 16) and
                (P.y > - 16)and(P.y <  DispSize.y + 16) ) then
                continue;

       w := round(AsphFonts[Font0].TextWidth(Markers[i].MarkerName)/2);

       canlabel := true;
       if not DrawAll then
       
       for J := 1 to ACount do
          if (P.y -dy > A[j].Y - 32)and(P.y -dy  < A[j].Y + 32) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
          begin
            canlabel := false;
            break;
          end;

       if not canlabel then
            continue;

       if Acount < AMax then
         inc(Acount);

       dy := 20;

       A[Acount].X := P.x;
       A[Acount].Y := P.y -dy;
       Asize[Acount] := w;

       

       if CanLabel then
         LabelOut(P,w, dy, Markers[i].MarkerName)
       else
         continue;



        // HGT

       dy := dy - 28;

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
          if (P.y -dy  > A[j].Y - 32)and(P.y  -dy < A[j].Y + 32) then
          if (P.x+w > A[j].X - Asize[j])and(P.x-w < A[j].X + Asize[j]) then
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
       A[Acount].Y := P.y -dy ;
       Asize[Acount] := w;

       if CanLabel then
         LabelOut(P,w, dy, str);

       //   AsphFonts[Font0].TextOut(Point2(trunc(P.x)-w,trunc(P.y)-trunc(dy)),
       //                                Markers[i].MarkerName, cColor2(FntColor));
     End;

end;

procedure AddMarker(Mname: string; mB, mL: Double);  overload;
begin
  AddMarker(Mname, mB, mL, 0, 0, 0);
end;

procedure AddMarker(Mname: string; mB, mL, H, HGeo, Alt: Double);  overload;
begin
//  Length(Markers)<1000 then
  SetLength(Markers, Length(Markers)+1);
  Markers[Length(Markers)-1].Gx := mB;
  Markers[Length(Markers)-1].Gy := mL;
  Markers[Length(Markers)-1].MarkerName := mName;

  Markers[Length(Markers)-1].H := H;
  Markers[Length(Markers)-1].HGeo := HGeo;
  Markers[Length(Markers)-1].Alt := Alt;
  
  Markers[Length(Markers)-1].MarkerKind := 0;
  Markers[Length(Markers)-1].Add1 := 0;
  Markers[Length(Markers)-1].Add2 := 0;
  RecomputeMarkers(WaitForZone);
end;

procedure DelAngMarkers;
var I:Integer;
begin
  if Length(Markers) > 0 then
  begin
     for I :=Length(Markers) - 1 downto 0 do
       if Pos('!#', Markers[I].MarkerName) = 1 then
         DelMarker(I);
  end;

end;

procedure DelMarker(DelI: integer);
var I:Integer;
begin
  if Length(Markers) > 0 then
  begin
     for I := DelI to Length(Markers) - 2 do
       Markers[I] := Markers[I+1];

     SetLength(Markers, Length(Markers)-1);
  end;
end;

procedure EditMarker(I: integer; Mname: string; mB, mL: Double);
begin
  with  Markers[I] do
  begin
     Gx := mB;
     Gy := mL;
  end;

  RecomputeMarkers(WaitForZone);
end;

function FramePerimeter :real;
var i:integer;
begin
   Result := 0;

   if FrameCount < 2 then
      exit;

   for I := 0 to FrameCount - 2 do
      Result :=  Result + Sqrt(Sqr(FramePoints[I+1,1].y - FramePoints[I,1].y) +
                               Sqr(FramePoints[I+1,1].x - FramePoints[I,1].x));

end;

function FrameArea     :real;
var i:integer;
    ymin : double;
begin
   Result := 0;

   if FrameCount < 2 then
      exit;

   ymin := FramePoints[0,1].y;
   for I := 1 to FrameCount - 1 do
     if FramePoints[I,1].y < ymin then
        ymin := FramePoints[I,1].y;

   for I := 0 to FrameCount - 2 do
      Result :=  Result + ( (FramePoints[I+1,1].y + FramePoints[I,1].y - 2*ymin)*
                            (FramePoints[I+1,1].x - FramePoints[I,1].x)/2  );

   if Result < 0 then
      Result := - Result;                        
end;

function RoutesAllSize :real;
var I, J :integer;
begin
    Result := 0;

    if RouteCount = 0 then
       exit;

    for I := 0 to RouteCount - 1 do
      For J := 1 to Length(Route[I].WPT)-1 do
        Result := Result + Sqrt(  Sqr(Route[I].WPT[J-1].x - Route[I].WPT[J].x) +
                                  Sqr(Route[I].WPT[J-1].y - Route[I].WPT[J].y));
end;

function GalsCount:integer;
var I, J :integer;
begin
    Result := 0;

    if RouteCount = 0 then
       exit;

    for I := 0 to RouteCount - 1 do
      For J := 1 to Length(Route[I].WPT)-1 do
        inc(Result);
end;

function RouteLenght(N :Integer):Double;
var J :integer;
begin
     result:= 0;
     if (N < 0) or (N >= RouteCount) then
        exit;

     for J := 1 to Length(Route[N].WPT) - 1 do
     begin
       result := result + sqrt(
                Sqr(Route[N].WPT[J].x - Route[N].WPT[J-1].x) +
                Sqr(Route[N].WPT[J].y - Route[N].WPT[J-1].y));
     end;
end;

function RoutesMeanSize:real;
var I, J :integer;
begin
    Result := 0;

    if RouteCount = 0 then
       exit;

    for I := 0 to RouteCount - 1 do
      For J := 1 to Length(Route[I].WPT)-1 do
        Result := Result + Sqrt(  Sqr(Route[I].WPT[J-1].x - Route[I].WPT[J].x) +
                                  Sqr(Route[I].WPT[J-1].y - Route[I].WPT[J].y));

    Result := Result/RouteCount;
end;

var BasicMapObjects_Cmin, BasicMapObjects_Cmax: TLatLong;

procedure BasicObjectsScale;
  var xmax, ymax, xmin, ymin: real;
  P, P2 :TMyPoint;
  I, J: Integer;
begin

  if BasicObjectsMeanBL.long = - 360 then
      exit;

  P := BLToMap(BasicMapObjects_Cmin);
  P2 := BLToMap(BasicMapObjects_Cmax);

  if P.x > P2.x then
  begin
    xmin := P2.x;
    xmax := P.x;
  end
   else
   begin
      xmin := P.x;
      xmax := P2.x;
   end;

  if P.y > P2.y then
  begin
    ymin := P2.y;
    ymax := P.y;
  end
   else
   begin
      ymin := P.y;
      ymax := P2.y;
   end;

  I := 0;
  repeat
     inc(i);
     if abs(xmin-xmax) > abs(ymin-ymax) then
       J := trunc( abs(xmin-xmax) /TMashtab[I])
         else
          J := trunc( abs(ymin-ymax) /TMashtab[I]);
  until (I >= MaxMashtab-1) or (J <= DisplaySize.y div 100);
  Mashtab := I;

end;

function BasicObjectsMeanBL    :Tlatlong;
var i, J:integer;
    Cmin, Cmax, Cmean, C : TLatLong;

    procedure InitC;
    begin
      Cmin.lat := C.lat;
      Cmin.long:= C.long;
      Cmax.lat := C.lat;
      Cmax.long:= C.long;
    end;

    procedure CompareC;
    begin
     if C.lat < Cmin.lat then
        Cmin.lat  := C.lat;

     if C.long < Cmin.long then
        Cmin.long := C.long;

     if C.lat > Cmax.lat then
        Cmax.lat  := C.lat;

     if C.long > Cmax.long then
        Cmax.long := C.long;
    end;
begin
  Result.lat  := 0;
  Result.long := -360;


  if RouteCount >0  then
  begin
    C.lat  := Route[0].Gx1;
    C.long := Route[0].Gy1;
    InitC;
  end
    else
     if FrameCount >0  then
     begin
        C.lat  := FramePoints[0,2].x;
        C.long := FramePoints[0,2].y;
        InitC;
     end
       else
       if length(Markers) >0  then
       begin
          C.lat  := Markers[0].Gx;
          C.long := Markers[0].Gy;
          InitC;
       end
         else
         if length(MapList) >0  then
         begin
            C.lat  := MapList[0].Gx[1];
            C.long := MapList[0].Gy[1];
            InitC;
         end
           else
             exit;


  /// ��� �� ���������
  for I := 0 to RouteCount - 1 do
      For J := 1 to Length(Route[I].GWPT)-1 do
      begin
         C.lat  := Route[I].GWPT[j].x;
         C.long := Route[I].GWPT[j].y;
         CompareC;
      end;

  /// ��� �� �����
  for I := 0 to  FrameCount - 1 do
  begin
     C.lat  := FramePoints[i,2].x;
     C.long := FramePoints[i,2].y;
     CompareC;
  end;

   /// ��� �� ��������
  for I := 0 to  Length(Markers)- 1 do
  begin
     C.lat  := Markers[i].Gx;
     C.long := Markers[i].Gy;
     CompareC;
  end;

    /// ��� �� ����������
  for I := 0 to Length(MAPList) - 1 do
   for j := 1 to 4 do
  begin
     C.lat  := MapList[i].Gx[j];
     C.long := MapList[i].Gy[j];
     CompareC;
  end;

  BasicMapObjects_Cmin := Cmin;
  BasicMapObjects_Cmax := Cmax;

  /// Compute mean B, L        ! (�� �����, ������ ����� �� �������)
  Cmean.lat  := (Cmin.lat  + Cmax.lat ) /2;
  Cmean.long := (Cmin.long + Cmax.long) /2;

  Result := Cmean;
end;

function BasicObjectsMeanUTMZone:integer;
var Cmean : TLatLong;
begin
   Result := -1;

   Cmean := BasicObjectsMeanBL;

   if (Cmean.Lat = 0) and (Cmean.Long = -360) then
      exit;

   Result :=  UTMZonebyPoint(Cmean.Lat, Cmean.Long);
end;

function UTMZonebyPoint(B, L:Double):Integer;
const
   Linit = 180;
   ZoneW = 6;
begin
  /// LOL GetZone
  Result := trunc((L + Linit + ZoneW)/ZoneW);
end;

end.
