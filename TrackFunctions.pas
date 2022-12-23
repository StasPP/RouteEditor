unit TrackFunctions;

interface

uses Classes, TabFunctions, MapFunctions, BasicMapObjects, GeoString, SysUtils,
     GeoClasses, GeoFunctions, GeoFiles, DrawFunctions, Vectors2, DateUtils,
     AbstractCanvas, AbstractDevices, AsphyreImages, AsphyreTypes, AsphyreDb,
     Floader, Dialogs, GeoTime, Math, AsphyreFonts, RTypes, LangLoader, Windows,
     Graphics, MapEditor, UDF_reader, PointClasses;

type

  TCSMark = record
    R, G, B : byte;
    Mark : double;
  end;

  TTrackColorScheme = record
    isOn, isSmooth, isRound : Boolean;
    Kind : Byte;  // 0 - altitude, 1 - H, 2 - Hgeo, 3 - Speed, 4 - NSat 
    CSMarks : Array [0..1023] of TCSMark;
    CSMarkCount :Integer;
    Min, Max :Double;
  end;

  TTrackPoint = record
     _x, _y, _z : Double;  /// �������� ����������
     CS: integer;          /// ID �������� ������� ���������

     B, L, H, HGeo : Double;     /// ���������� WGS
     x, y, z : Double;           /// ���������� � ������� �� ���������

     _T : String;          /// ����� �������
     T : TDateTime;        /// ����� TDateTime

     //// �������������
     Speed, Azimuth, PDOP: Real;  SatN: Integer; 
     Comment : String;
     Altitude, AltR, AltL :Real; // ����������, ���

     RouteN :integer;              // � �������� (��� �������)
     RouteName :string;
     RouteDist :Double;
     RouteProgress :Integer;
     Visible :Boolean;            // ��������� �� �� �����
  end;

  TReductionSettings = record
     U, V, W    :real;    // ��������� ��������
  end;

  TReductionPoint = record
     dX, dY, dZ :Real;  // ��������
  end;

  TTrackStat = record
    TrackL: Double;
    AvgH, AvgHGeo, AvgSpd, AvgFSpd, AvgRSpd : Double;
    MinT, MaxT :TDateTime;
    EpCount, SlipCount :integer;
    EpOnRoutes, PrOnRoutes :integer;
  end;

  TAngle = record
     T : TDateTime;
     N : integer;
     Pitch, Roll, Yaw : Real;  // ����
     isAzimuth : boolean;
  end;

  TRinMarker = record
    T1, T2 : TDateTime;
    AntH   : real;
    MarkerName :String;
  end;

  TTrack      = array of TTrackPoint;
  TRedTrack   = array of TReductionPoint;
  TAngles     = array of TAngle;
  TRinMarkers = array of TRinMarker;

var
  MainTrack :TTrack;
  ReductedMainTrack :TTrack;
  Reduction :TReductionSettings;
  RedTrack  :TRedTrack;
  RedAngles :TAngles;
  RinMarkers:TRinMarkers;
  MainTrackCS, MainTrackDatum :integer;

  ChoosedTrackPoint: integer = -1; ViewTrackPoint: integer = -1;
  TrackHasComments :Boolean = false;

const mindT = 0.00000001;

procedure LoadTrackFromNmea(var Track :TTrack; FileName:String; isAdd:Boolean);

procedure LoadTrackFromFile(var Track :TTrack; FileName:String; isAdd:Boolean;
              Spc :char; StartI, Dat, SK, TTab, Xtab, Ytab, Ztab,
              Htab, HGeoTab, SpeedTab, AzmtTab, PDopTAb, DateTab,
              CommentTab, AltTab, Alt2Tab, SatNtab, RouteTab,
              RDistTab, RProgressTab: integer; DateF, TimeF :String;
              isUTC, isMinTab, isSecTab: boolean; ManualDate:TDateTime;
              CompoundDT:Byte; ErrStr:string);

procedure LoadTrackFromRTT(var Track :TTrack; FileName:String; isAdd:Boolean; StartI:integer; ErrStr:String);
procedure LoadTrackFromRTA(var Track :TTrack; FileName:String; isAdd:Boolean; ErrStr:String);

procedure LoadTrackFromUDF(FN:String; var Track: TTrack; uCS, uDatum: integer;
   isDatum, skipH, ROrder: boolean);

procedure LoadGpxTrack(FileName:String; var Track :TTrack; DoAdd:Boolean);

procedure TrackFastFilter(var Track :TTrack; BPM:String);

procedure SaveRTTFile( var Track :TTrack; FileName:String; FullFormat:Boolean);
procedure SaveRTTFileForAnalysis( var Track :TTrack; FileName:String;
        CSN:Integer; FullFormat:Boolean);

function GetTrackStat(Track: TTrack):TTrackStat;

procedure MakeMNKRoute(Track :TTrack; T1, T2 :TDateTime; RMethod:integer;
                       MinL: Double; DoMinL, DoReset:Boolean; RName:String;
                       NewStep:Double);

procedure MakeStops(Track:TTrack; T1, T2 :TDateTime; RMethod:integer;
                    MaxL, MinN, MinT :real; DelOld:Boolean);

procedure MakeRINStops(Track:TTrack; T1, T2 :TDateTime;
            DoFilter, DelOld, AddAntH, AddPts:Boolean; FCount: integer);

procedure AttachToRoute(var Track :TTrack; T1, T2 :TDateTime; RNum, RMethod :integer;
                       MaxD :Double; DoFilter, DoReset:Boolean);

procedure LoadAnglesFromNMEA(FileName:String);

procedure MeanAverageFilter(MaskSize:integer);

procedure CutAnglesbyTime(MinT: real);

procedure CutAnglesbyDist(MinDist: real; Track: TTrack);

procedure LoadAnglesFromFile(FileName:String; Spc :char; StartI,  TTab,
              YawTab, Pitchtab, Rolltab, DateTab, YawKind : integer; MagAng: real;
               DateF, TimeF :String; isUTC, isDegs : boolean);


procedure DrawTrackInfo(Track: TTrack; AsphCanvas: TAsphyreCanvas;
              AsphImages: TAsphyreImages; AshpFonts: TAsphyreFonts;
              TrackColor, MenuColor, InfColor, RedColor, FntColor,
              InactiveTrack, RouteColor:Cardinal; X, Y : Real;
              RouteNum, Mselect:Integer; DoSmooth:Boolean);


procedure SelectedPointsToRoute(Track:TTrack; N1, N2, Rn:integer); overload;
procedure SelectedPointsToRoute(Track:TTrack; Rn:integer);         overload;

procedure FocusOnTrack(Track:TTrack);
procedure TestColSchm;

procedure ComputeAnglesFromTrack(Track:TTrack; Method, FilterN: Byte;
          FilterSize: real; MaskSize: Integer; SearchTurnPoints: boolean);

function ComputeReductions(Track:TTrack; var RTrack: TRedTrack; RA:TAngles;
              RSet:TReductionSettings; Rmethod:integer): integer;

procedure ComputeReductedTrack(var RdTrack:TTrack; Track:TTrack; RTrack: TRedTrack);

procedure DelTrackPoints(var Track :TTrack;I1,I2:Integer);

procedure ReComputeTrack(var Track :TTrack; WFZ: Boolean);

procedure SaveGpxFileWithTrack(FileName:String; AskifExist:boolean);

procedure DrawTrack(Track: TTrack; AsphCanvas: TAsphyreCanvas; AsphImages: TAsphyreImages;
      TrackColor, RedTrackColor, InactiveTrack :Cardinal; DrawPoints :Boolean; DrawCracks :Boolean;
      OptimizeStep :Integer; Smooth: Boolean; RouteNum:Integer);

function TrackMeanBL(Track:TTrack):TLatLong;
function TrackMeanUTMZone(Track:TTrack):Integer;

procedure GetRouteDist(Track:TTrack; TrackI:Integer);

function RouteSpecialStepBreak(RouteN: Integer; Step: Double):TRoute;

procedure ReduceTrackPoints(var Track: TTrack; RMethod : Byte; C1, C2 :Double);

procedure AddRoutePointsToTrack(Track: TTrack; R:TRoute; sT:TDateTime);

function RouteToTrack(R :TRoute; T:TTrack; RMethod :Byte; InBorders:Boolean; Name:String):TRoute;

function SearchRinEvents(FileName:String):String;

var
   TrackColorSch    :TTrackColorScheme;
   TrackCols        :Integer = -2;
   TrackArrowsEnabled :Boolean = False;
   
implementation

var _Date0           :TDateTime;
    MeanLineCount    :integer = 0;
    AskedEr, PassEr  :Boolean;
    

//// FOR   LOADINGz  ---------------------------------------------

 procedure ClearTrackPoint(var Track:TTrack; K:integer);
  begin
     Track[k].T := EncodeDate(1980,1,1);

     Track[k]._T := '';

     Track[k]._x := 0;
     Track[k]._y := 0;
     Track[k]._z := 0;

     Track[k].x := 0;
     Track[k].y := 0;
     Track[k].z := 0;

     Track[k].B := 0;
     Track[k].L := 0;
     Track[k].H := 0;
     Track[k].HGeo := 0;

     Track[k].Comment := '';
     Track[k].PDop := 0;
     Track[k].Azimuth := 0;
     Track[k].Speed := 0;
     Track[k].SatN := 0;

     Track[k].RouteN := -1;
     Track[k].RouteName := '---';
     Track[k].RouteDist := 0;
     Track[k].RouteProgress := 0;
     Track[k].AltR := 0;
     Track[k].AltL := 0;
     Track[k].Altitude := 0;
  end;

  procedure ClearAngles(var Track:TAngles; K:integer);
  begin
     Track[k].T := EncodeDate(1980,1,1);

     Track[k].N := -1;

     Track[k].Yaw   := 0;
     Track[k].Pitch := 0;
     Track[k].Roll  := 0;
     Track[k].isAzimuth := false;
  end;

  function PrepareAngle(A1, A2: real):real;
  begin
    Result := A1;
    if A2 > A1 then
      if A2 - A1 > pi then
        while A2 - A1 > pi do
          A1 := A1 + 2*pi;

    if A1 > A2 then
      if A1 - A2 > pi then
        while A1 - A2 > pi do
          A1 := A1 - 2*pi;

    Result := A1;
  end;
  
////// --------------------------------------------------

procedure LoadTrackFromNmea(var Track :TTrack; FileName:String; isAdd:Boolean);

  Function LatLongFromNMEA(SLatLong, SSign:String; isLat: Boolean): Double;
  begin

    case isLat of
      true:
        Begin
          Insert(' ',SLatLong,3);
          Result := StrToLatLon(SLatLong, true);
          if AnsiUpperCase(SSign) = 'S' then
             Result := - Result;
        End;

      false:
        Begin
          Insert(' ',SLatLong,4);
          Result := StrToLatLon(SLatLong, false);
          if AnsiUpperCase(SSign) = 'W' then
             Result := - Result;
        End;
    end;

  end;

  Function TimeFromNMEA(SDate, STime:String): TDateTime;
  var  _Year, _Day, _Month, _Hour, _Min, _Sec, _mSec : Integer;
  begin
    _Day   := StrToInt(Copy(SDate,1,2));
    _Month := StrToInt(Copy(SDate,3,2));
    _Year  := StrToInt(Copy(SDate,5,2));

    _Hour  := StrToInt(Copy(STime,1,2));
    _Min   := StrToInt(Copy(STime,3,2));
    _Sec   := StrToInt(Copy(STime,5,2));

    _mSec  := trunc( (StrToFloat2(STime)-trunc(StrToFloat2(STime)))*1000 );

    if _Year < 70 then
       _Year := _Year + 2000
         else
         if _Year < 1900 then
            _Year := _Year + 1900;

    Result := EncodeDateTime(_Year, _Month, _Day, _Hour, _Min, _Sec, _mSec);
  end;

  var I, J, Progress :integer;
      T :TDateTime;
      S :TStringList;

      Tab0 :Integer;
      str, str2, sdate :String;

      DT:TFormatSettings;

      lasterr :boolean;
begin
   if FileExists(FileName) = false then
     exit;

   if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.gpx' then
   begin
     loadGPXTrack(FileName, Track, isAdd);
     exit;
   end;

   if not isAdd then
     TrackHasComments := false;

   if not isAdd then
      AskedEr:= false;

   S := TStringList.Create;
   S.LoadFromFile(FileName);

   if not isAdd then
      SetLength(Track, 0);

   FLoadGPS.Show;
   FLoadGPS.MapLoad.Visible := false;
   FLoadGPS.Label2.Hide;
   FLoadGPS.Label1.Hide;
   FLoadGPS.LCount.Caption := '';
   FLoadGPS.Label3.Show;
   FLoadGPS.Repaint;
   FloadGPS.ProgressBar1.Position := 0;

   MainTrackCS := 0;
   MainTrackDatum := WGS;

   SDate := '';

   InitDTFormat(DT);

   /// NMEA0183
   for I := 0 to S.Count - 1 do
   begin
     Progress := round(I*100/(S.Count-1));
     if FloadGPS.ProgressBar1.Position - Progress <> 0 then
        FloadGPS.ProgressBar1.Position := Progress;

     J := Pos ('RMC', S[I]);
     if J > 0 then
     try
       lastErr := false;
       Str2  := GetCols(S[I], Tab0 + 2, 1, ',', False);
       if Str2 = 'V' then
       begin
         if not AskedEr then
         begin
           PassEr := MessageDlg(inf[160], mtWarning, mbYesNo, 0) = 6;
           AskedEr := true;
         end;

         lastErr := true;

         if PassEr then
           Continue;
       end;


       Tab0  := GetColN(S[I],',',J);
       Str   := GetCols(S[I], Tab0 + 1, 1, ',', False); /// TIME
       Str2  := GetCols(S[I], Tab0 + 9, 1, ',', False); /// DATE
       SDate := Str2;
       T     := UTCToGPS(TimeFromNmea(Str2, Str));

       J := Length(Track) - 1;                        //// OLD or NEW Point
       if (J = -1) then
       begin
         SetLength(Track, Length(Track)+1);
         ClearTrackPoint(Track, Length(Track)-1);
       end
         else
           if (Track[J].T) <> T then
           begin
               SetLength(Track, Length(Track)+1);
               ClearTrackPoint(Track, Length(Track)-1);
           end;

       J := Length(Track) - 1;
       Track[J].T  := T;
       Track[J]._T := DateTimeToStr2(Track[J].T, DT);

       Str :=  GetCols(S[I], Tab0 + 3, 1, ',', False); /// Lat
       Str2 := GetCols(S[I], Tab0 + 4, 1, ',', False);
       Track[J].B  := LatLongFromNmea(Str, Str2, True);

       Str :=  GetCols(S[I], Tab0 + 5, 1, ',', False); /// Long
       Str2 := GetCols(S[I], Tab0 + 6, 1, ',', False);
       Track[J].L  := LatLongFromNmea(Str, Str2, False);

       Track[J].RouteN := -1;

       if lastErr then
       begin
         Track[J].Comment := inf[172];
         TrackHasComments := true;
         lastErr := true;
       end;

       if (abs(Track[J].B)>90) or (Track[J].L<-180) or (Track[J].L>180)
          or ((Track[J].B = 0)and (Track[J].L = 0)) then
       begin
          if Length(Track)>0 then
          
          SetLength(Track, Length(Track)-1);
          continue;
       end;

       Str := GetCols(S[I], Tab0 + 8, 1, ',', False);
       Track[J].Azimuth := StrToFloat2(Str)*pi/180;

       Str := GetCols(S[I], Tab0 + 7, 1, ',', False);
       Track[J].Speed := StrToFloat2(Str)*1.852;

       Track[J]._x :=  Track[J].B;
       Track[J]._y :=  Track[J].L;
       Track[J]._z :=  Track[J].H;

       continue;
     except
      // showmessage('!');
     end;

     J := Pos ('GGA', S[I]);
     if J > 0 then
     try
       if SDate = '' then
          continue;

      if PassEr and lastErr then
           Continue;

       Tab0 := GetColN(S[I],',',J);
       Str :=  GetCols(S[I], Tab0 + 1, 1, ',', False); /// TIME
       T := UTCToGPS(TimeFromNmea(SDate, Str));

       J := Length(Track) - 1;                        //// OLD or NEW Point
       if (J = -1) then
       begin
         SetLength(Track, Length(Track)+1);
         ClearTrackPoint(Track, Length(Track)-1);
       end
         else
           if (Track[J].T) <> T then
           begin
               SetLength(Track, Length(Track)+1);
               ClearTrackPoint(Track, Length(Track)-1);
           end;

        J := Length(Track) - 1;
        Track[J].T  := T;
        Track[J]._T := DateTimeToStr2(Track[J].T, DT);

        Str :=  GetCols(S[I], Tab0 + 2, 1, ',', False); /// Lat
        Str2 := GetCols(S[I], Tab0 + 3, 1, ',', False);
        Track[J].B  := LatLongFromNmea(Str, Str2, True);

        Str :=  GetCols(S[I], Tab0 + 4, 1, ',', False); /// Long
        Str2 := GetCols(S[I], Tab0 + 5, 1, ',', False);
        Track[J].L  := LatLongFromNmea(Str, Str2, False);

        if (abs(Track[J].B)>90) or (Track[J].L<-180) or (Track[J].L>180)
         or ((Track[J].B = 0)and (Track[J].L = 0))then
        begin
          SetLength(Track, Length(Track)-1);
          continue;
        end;

        Str := GetCols(S[I], Tab0 + 7, 1, ',', False);   /// Satellites N
        Track[J].SatN  := Trunc(StrToFloat2(Str));
        Str := GetCols(S[I], Tab0 + 8, 1, ',', False);  //// PDOP
        Track[J].PDOP  := StrToFloat2(Str);

        Str :=   GetCols(S[I], Tab0 + 9, 1, ',', False);        /// HGT above mean sea level
        Str2 :=  GetCols(S[I], Tab0 + 11, 1, ',', False);       /// Geoid undulation
        Track[J].HGeo := StrToFloat2(Str);
        Track[J].H    := Track[J].HGeo + StrToFloat2(Str2);

        Track[J]._x :=  Track[J].B;
        Track[J]._y :=  Track[J].L;
        Track[J]._z :=  Track[J].H;
     except
       /// showmessage('!!');
     end;   
   end;

   if length(Track) >0 then
      _Date0 := Trunc(Track[0].T);

   FLoadGPS.Close;

   ReComputeTrack(Track, WaitForZOne);
   S.Free;
end;

procedure MeanAverageFilter(MaskSize:integer);
   var I, J, K : integer;
       A, B, C, oldA, A0, B0, C0 : real;
       TempAngles: TAngles;
  begin
    if MaskSize > 1 then  //// ���������� �������
    begin
      SetLength(TempAngles, Length(RedAngles));
      for I := 0 to Length(RedAngles) - 1 do
       TempAngles[I] := RedAngles[I];

      if MaskSize*2 < length(RedAngles)-1 then
      Begin
        SetLength(RedAngles, 0);
        for I := 0 to length(TempAngles)-1 - trunc(MaskSize)-1 do
        begin
          J := I + Round(Masksize*0.5);  /// �������, � ��������
                                             ///���������� ������������� ��������
          A := 0; B := 0; C := 0;

          for K := 0 to trunc(MaskSize)-1 do
          begin
             if K = 0 then
             Begin
                A := A + TempAngles[I+K].Yaw;
                B := B + TempAngles[I+K].Pitch;
                C := C + TempAngles[I+K].Roll;
                A0 := A; B0 := B; C0 := C;
             End
              Else
              Begin
                A := A + PrepareAngle(TempAngles[I+K].Yaw, A0);
                B := B + PrepareAngle(TempAngles[I+K].Pitch, B0);
                C := C + PrepareAngle(TempAngles[I+K].Roll, C0);
              End;
          end;

          A := A / Masksize;
          B := B / Masksize;
          C := C / Masksize;

          SetLength(RedAngles, Length(RedAngles) +1);

          RedAngles[Length(RedAngles) -1].T := TempAngles[J].T;
          RedAngles[Length(RedAngles) -1].N := TempAngles[J].N;
          RedAngles[Length(RedAngles) -1].Yaw   := A;
          RedAngles[Length(RedAngles) -1].Pitch := B;
          RedAngles[Length(RedAngles) -1].Roll  := C;
      end;
    End;
  end;

end;


procedure ComputeAnglesFromTrack(Track:TTrack; Method, FilterN: Byte;
                        FilterSize: real; MaskSize:integer; SearchTurnPoints: boolean);


  function GetNext(I :integer):integer;
  var J:integer;
  begin
     Result := I+1;
     case FilterN of
        0: Result := I+1; //// No Filter
        1: ////// LegLenght
        begin
          for J := I+1 to Length(Track) - 1 do
              if (sqrt(sqr(Track[J].x - Track[I].x)+sqr(Track[J].y - Track[I].y))
                 >= FilterSize)  or (J = Length(Track) - 1)  then
                 begin
                   result := J;
                   break;
                 end;
        end;
        2: ////// Time
        begin
          for J := I+1 to Length(Track) - 1 do
          if (abs(Track[J].T - Track[I].T) >= FilterSize/86400 )
             or (J = Length(Track) - 1) then
                 begin
                   result := J;
                   break;
                 end;
        end;
     end;
  end;

  var OldA : real;

  procedure ComputeAngles(I, J, N: integer);
  var A, B, C : real;
  begin
      case Method of
        0,1: /// ����������  - ������ ������������ ����
           Begin
              A := arcTan2(Track[J].X-Track[I].X, Track[J].Y-Track[I].Y);
              if A < 0 then
                 A := A + 2* pi;

              if (Track[J].x - Track[I].x)=0 then
                 if (Track[J].y - Track[I].y)=0 then
                    A := oldA;

              oldA := A;
              B := 0;
              C := 0;
           End;

         10: /// ����������  - ������������ ���� �� GPS
            Begin
               A := AzimuthToDirAngle(Track[J].Azimuth, Track[J].B, Track[J].L, Myzone, UTM);
               B := 0;
               C := 0;
            End;

         {1: /// ����������  - �� �����
            Begin

                 ///// ��� ����� 2

            End;     }

         2: /// ������� - ���
            Begin
                  //// ��������!
                  ///
                  ///  ��������� ������ � �������� !!!!
            End;
     end;

     

     if N =-1 then
     begin
       SetLength(RedAngles, Length(RedAngles) +1);
       N:= Length(RedAngles) -1
     end;

     RedAngles[N].T := Track[J].T;
     RedAngles[N].N := J;
     RedAngles[N].Yaw   := A;
     RedAngles[N].Pitch := B;
     RedAngles[N].Roll  := C;

  end;

  procedure AddTurnPoints(turnangle:real);
  var i,j,NewN : integer;
      da  : real;
  begin
    for I := Length(RedAngles)-1 Downto 1 do
    begin
       if RedAngles[I].N - RedAngles[I-1].N < 3 then
          continue;

       da := RedAngles[I].Yaw - PrepareAngle(RedAngles[I-1].Yaw,RedAngles[I].Yaw);
       if (abs(da) > turnangle) then
       begin
           OldA := RedAngles[I-1].Yaw;

           SetLength(RedAngles, Length(RedAngles) +1);
           for J :=  Length(RedAngles)-1 downto I do
              RedAngles[J] := RedAngles[J-1];

           //SetLength(RedAngles, Length(RedAngles) +1);
           /// I ���������� � I+1 !!!
           NewN := round(0.5*(RedAngles[I+1].N+RedAngles[I-1].N));
           ComputeAngles( NewN , RedAngles[I+1].N, I);

           RedAngles[I].T := Track[NewN].T;
           RedAngles[I].N := NewN;
          { RedAngles[I].N := RedAngles[Length(RedAngles)-1].N;
           RedAngles[I].Pitch := RedAngles[Length(RedAngles)-1].Pitch;
           RedAngles[I].Roll := RedAngles[Length(RedAngles)-1].Roll;
           RedAngles[I].Yaw := RedAngles[Length(RedAngles)-1].Yaw;
           RedAngles[I].isAzimuth := RedAngles[Length(RedAngles)-1].isAzimuth; 
           SetLength(RedAngles, Length(RedAngles) -1);                          }
       end;
       
    end;
  end;


var I, J: Integer;
begin

///////// 1. GET ANGLES

  SetLength(RedAngles, 0);
  j := 0;
  oldA := 0;
  repeat
     i := j;
     j := GetNext(I);      /// ������� ���������

     if (I=J) or (J> Length(Track)-1) then
        break;

     ComputeAngles(I, J, -1);    /// ������ ����


  until (I=J) or (J >= Length(Track)-1);

  if filterN =1 then            /// �������� ������������� ��� �����������
  if SearchTurnPoints then
    for I := 1 to 4 do
      AddTurnPoints(pi/3);   //1,0472

//////////////// ----------------- 2. POSTFILTER
   MeanAverageFilter(MaskSize);

  /// ShowMessage(intToStr(length(RedAngles)))
end;

function TaleMethodReductions(Track:TTrack; var RTrack: TRedTrack; RA:TAngles;
              RSet:TReductionSettings; Rmethod:integer): integer;

var Yaws:array of Double;

   procedure InitRTrack;
   var I:Integer;
   begin
     SetLength(RTrack, Length(Track));
     SetLength(Yaws, Length(Track));
     for I := 0 to Length(RTrack) - 1 do
     begin
       RTrack[I].dX := 0;
       RTrack[I].dY := 0;
       RTrack[I].dZ := 0;
       Yaws[I] := 0;
     end;
   end;

   procedure DeltaTaleMethod (var P: TReductionPoint; I:integer);
   var px, py, dist, k, l : double;
     n, j :integer;
   begin

     N := I;
     dist := 0;

     if RSet.U = 0 then
     begin
       PX :=  Track[I].x;
       PY :=  Track[I].y;
     end
        else
        begin
          if RSet.U > 0 then
             j := 1
             else
               j := -1;

          while dist <= abs(RSet.U) do
          begin
             if (N<>0)and(N<>length(Track)-1) then
             N := N + j
               else
                 break;

             dist := dist + sqrt(sqr(Track[N].x - Track[N-j].x)+
                                      sqr(Track[N].y - Track[N-j].y));

          end;


          if dist = abs(RSet.U) then
          begin
             PX :=  Track[N].x;
             PY :=  Track[N].y;
          end
            else
            if dist < abs(RSet.U) then
            begin
              /// Xtrapolation
              case RSet.U > 0 of
                   true:  k := dist - abs(RSet.U);
                   false: k := -(dist - abs(RSet.U));
              end;
                 l := sqrt(sqr(Track[N].x - Track[N-j].x)+
                           sqr(Track[N].y - Track[N-j].y));


                 PX := Track[N].x - (Track[N].x - Track[N-j].x)*k/l;
                 PY := Track[N].y - (Track[N].y - Track[N-j].y)*k/l;
              end
                else
                  if dist > abs(RSet.U) then
                  begin
                   /// Interpolation

                   l := sqrt(sqr(Track[N].x - Track[N-j].x)+
                           sqr(Track[N].y - Track[N-j].y));

                   case RSet.U > 0 of
                     true:  k := dist - abs(RSet.U);
                     false: k := -(dist - abs(RSet.U));
                   end;

                   PX := Track[N-j].x + (Track[N].x - Track[N-j].x)*k/l;
                   PY := Track[N-j].y + (Track[N].y - Track[N-j].y)*k/l;

                  //PX := Track[N].x ; PY := Track[N-j].y ;

                  end;

             end;

          P.dY := (Py - Track[I].y)  + RSet.V*Sin(yaws[N]);        /// U = dN; V = dE
          P.dX := (Px - Track[I].x)  - RSet.V*Cos(yaws[N]);
          P.dZ := RSet.W;

   end;


var I, J, I1, I2, Cnt :integer;
    pitch, roll, heading, C, B, L : real;
    NoNs : boolean;
    T1, T2 : TDateTime;
begin
   Result := 0;
   Cnt := 0;
   DelAngMarkers;

  if Length(Track) = 0 then
     exit;

  InitRTrack;

  if Length(RA) = 0 then
    exit;

  if RA[0].N > Length(Track) - 1 then
    exit;

   NoNs := false;



   for I := 1 to Length(RA) - 1 do     //// Search By Ns
   begin
    I1 := RA[I-1].N;
    I2 := RA[I].N;

    if I1=-1 then
    begin
      NoNs := True;
      Cnt  := 0;
      break;
    end;

    if I1 = I2 then
       continue;

    Yaws[I1]:= RA[I-1].Yaw;
    Yaws[I2]:= RA[I].Yaw;

    //GetDeltas(RTrack[I1], RA[I-1].Pitch, RA[I-1].Roll, RA[I-1].Yaw);
    //GetDeltas(RTrack[I2], RA[I].Pitch, RA[I].Roll, RA[I].Yaw);

    if I2 - I1 <= 1 then
       continue;

    /// Interpolated epochs between I1 and I2
    for J := I1+1 to I2 do
    begin

      if Track[I1].T <> Track[I2].T then   // a. by time
        C := (Track[J].T - Track[I1].T)/(Track[I2].T - Track[I1].T)
        else                               // b. by Number
          C := (J-I1)/(I2-I1);

      B := Track[I1].B;
      L := Track[I1].L;
      if  (RA[I-1].isAzimuth)or(RA[I].isAzimuth) then
      begin
         B := Track[I1].B + C* (Track[I2].B - Track[I1].B);
         L := Track[I1].L + C* (Track[I2].L - Track[I1].L);
      end;

      if  RA[I-1].isAzimuth then
          RA[I-1].Yaw := AzimuthToDirAngle(RA[I-1].Yaw, B, L, MyZone, UTM);

      if  RA[I].isAzimuth then
          RA[I].Yaw := AzimuthToDirAngle(RA[I].Yaw, B, L, MyZone, UTM);

      RA[I-1].isAzimuth := false;
      RA[I].isAzimuth   := false;

      if (C=0)or(c=1) then
         AddMarker('!#'+inttostr(round(RA[I].Yaw*180/pi)) ,B, L);

      Yaws[J] := RA[I-1].Yaw + C*(PrepareAngle(RA[I].Yaw, RA[I-1].Yaw)- RA[I-1].Yaw);

      //GetDeltas(RTrack[J], RA[I-1].Pitch + C*(PrepareAngle(RA[I].Pitch, RA[I-1].Pitch) - RA[I-1].Pitch),
      //                     RA[I-1].Roll  + C*(PrepareAngle(RA[I].Roll, RA[I-1].Roll)  - RA[I-1].Roll),
      //                     RA[I-1].Yaw   + C*(PrepareAngle(RA[I].Yaw, RA[I-1].Yaw)   - RA[I-1].Yaw));
    end;

   end;

   I1 := 1;
   if NoNs then
   for I := 0 to Length(Track) - 1 do     //// Search By T
   begin

    for J := I1 to Length(RA) - 1 do
    begin
        /// ������ I1 � I2 � ����� RA � ��������������� ����� ����!
        if (Track[i].T > RA[J-1].T) and (Track[i].T <= RA[J].T)  then
        begin
          T1 := RA[J-1].T; T2 := RA[J].T;

          if T1 = T2 then
             continue;

          C := (Track[i].T - T1)/(T2 - T1);

          if  (RA[j-1].isAzimuth) or (RA[j].isAzimuth) then
          begin
            B := Track[i].B;
            L := Track[i].L;
          end;

          if  RA[j-1].isAzimuth then
              RA[j-1].Yaw := AzimuthToDirAngle(RA[j-1].Yaw, B, L, MyZone, UTM);

          if  RA[j].isAzimuth then
              RA[j].Yaw := AzimuthToDirAngle(RA[j].Yaw, B, L, MyZone, UTM);

           RA[j-1].isAzimuth := false;
           RA[j].isAzimuth   := false;

           Yaws[J] := RA[j-1].Yaw   + C*(PrepareAngle(RA[j].Yaw, RA[j-1].Yaw));

          //GetDeltas(RTrack[I], RA[J-1].Pitch + C*(PrepareAngle(RA[J].Pitch,RA[J-1].Pitch) - RA[J-1].Pitch),
          //                 RA[J-1].Roll  + C*(PrepareAngle(RA[J].Roll, RA[J-1].Roll)  - RA[J-1].Roll),
          //                 RA[J-1].Yaw   + C*(PrepareAngle(RA[J].Yaw, RA[J-1].Yaw)    - RA[J-1].Yaw));


          I1 := J-1;
          break;
        end
          else
            if (Track[i].T > RA[J].T) then
            begin
            //   showmessage('skip');
               continue;
            end;
    end;
  end;

  for i := 0 to Length(Track) - 1 do
    DeltaTaleMethod (RTrack[I],I);

  RecomputeMarkers(False);
  Result := Cnt;
end;


function ComputeReductions(Track:TTrack; var RTrack: TRedTrack; RA:TAngles;
              RSet:TReductionSettings; Rmethod:integer): integer;
 var Cnt: integer;

 procedure InitRTrack;
 var I:Integer;
 begin
    SetLength(RTrack, Length(Track));
    for I := 0 to Length(RTrack) - 1 do
    begin
       RTrack[I].dX := 0;
       RTrack[I].dY := 0;
       RTrack[I].dZ := 0;
    end;
 end;


   procedure GetDeltas(var P: TReductionPoint; pitch, roll, yaw: real);

   var a,b,c : array [1..3] of Double;
   begin
    if (pitch = 0) and (roll = 0) then  //// ���������� �������
    begin

          P.dY := RSet.U*Cos(yaw) + RSet.V*Sin(yaw);        /// U = dN; V = dE
          P.dX := RSet.U*Sin(yaw) - RSet.V*Cos(yaw);
          P.dZ := RSet.W;

    end
     else
     begin   ///////// ������� �������

     //// ��������������!

      a[1] := cos(Yaw)*cos(Pitch);
      a[2] := cos(Yaw)*sin(Pitch)*sin(Roll) - sin(Yaw)*cos(Roll);
      a[3] := cos(Yaw)*sin(Pitch)*cos(Roll) + sin(Yaw)*sin(Roll);

      b[1] := sin(Yaw)*cos(Pitch);
      b[2] := sin(Yaw)*sin(Pitch)*sin(Roll) + cos(Yaw)*cos(Roll);
      b[3] := sin(Yaw)*sin(Pitch)*cos(Roll) - cos(Yaw)*sin(Roll);

      c[1] := -sin(Pitch);
      c[2] := cos(Pitch)*sin(Roll);
      c[3] := cos(Pitch)*cos(Roll);

      P.dY := RSet.U*a[1] + RSet.V*a[2] + Rset.W*a[3];        /// U = dN; V = dE
      P.dX := RSet.U*b[1] + RSet.V*b[2] + Rset.W*b[3];
      P.dZ := RSet.U*c[1] + RSet.V*c[2] + Rset.W*c[3];

     end;
    inc(Cnt);
 end;


var I, J, I1, I2 :integer;
    pitch, roll, heading, C, B, L : real;
    NoNs : boolean;
    T1, T2 : TDateTime;
begin
   Result := 0;
   Cnt := 0;
   DelAngMarkers;

  if Length(Track) = 0 then
     exit;

  InitRTrack;

  if Length(RA) = 0 then
    exit;

  if RA[0].N > Length(Track) - 1 then
    exit;

   NoNs := false;

   for I := 1 to Length(RA) - 1 do     //// Search By Ns
   begin
    I1 := RA[I-1].N;
    I2 := RA[I].N;

    if I1=-1 then
    begin
      NoNs := True;
      Cnt  := 0;
      break;
    end;

    if I1 = I2 then
       continue;

    /// Points of I1 & I2 epochs
    GetDeltas(RTrack[I1], RA[I-1].Pitch, RA[I-1].Roll, RA[I-1].Yaw);
    GetDeltas(RTrack[I2], RA[I].Pitch, RA[I].Roll, RA[I].Yaw);

    if I2 - I1 <= 1 then  /// if no slips
       continue;

    /// Interpolated epochs between I1 and I2
    for J := I1+1 to I2 do
    begin

      if Track[I1].T <> Track[I2].T then   // a. by time
        C := (Track[J].T - Track[I1].T)/(Track[I2].T - Track[I1].T)
        else                               // b. by Number
          C := (J-I1)/(I2-I1);

      B := Track[I1].B;
      L := Track[I1].L;
      if  (RA[I-1].isAzimuth)or(RA[I].isAzimuth) then
      begin
         B := Track[I1].B + C* (Track[I2].B - Track[I1].B);
         L := Track[I1].L + C* (Track[I2].L - Track[I1].L);
      end;

      if  RA[I-1].isAzimuth then
          RA[I-1].Yaw := AzimuthToDirAngle(RA[I-1].Yaw, B, L, MyZone, UTM);

      if  RA[I].isAzimuth then
          RA[I].Yaw := AzimuthToDirAngle(RA[I].Yaw, B, L, MyZone, UTM);

      RA[I-1].isAzimuth := false;
      RA[I].isAzimuth   := false;

      if (C=0)or(c=1) then
         AddMarker('!#'+inttostr(round(RA[I].Yaw*180/pi)) ,B, L);

      GetDeltas(RTrack[J], RA[I-1].Pitch + C*(PrepareAngle(RA[I].Pitch, RA[I-1].Pitch) - RA[I-1].Pitch),
                           RA[I-1].Roll  + C*(PrepareAngle(RA[I].Roll, RA[I-1].Roll)  - RA[I-1].Roll),
                           RA[I-1].Yaw   + C*(PrepareAngle(RA[I].Yaw, RA[I-1].Yaw)   - RA[I-1].Yaw));
    end;

   end;

   I1 := 1;
   if NoNs then
   for I := 0 to Length(Track) - 1 do     //// Search By T
   begin

    for J := I1 to Length(RA) - 1 do
    begin
        /// ������ I1 � I2 � ����� RA � ��������������� ����� ����!
        if (Track[i].T > RA[J-1].T) and (Track[i].T <= RA[J].T)  then
        begin
          T1 := RA[J-1].T; T2 :=  RA[J].T;

          if T1 = T2 then
             continue;

          C := (Track[i].T - T1)/(T2 - T1);

          if  (RA[j-1].isAzimuth) or (RA[j].isAzimuth) then
          begin
            B := Track[i].B;
            L := Track[i].L;
          end;

          if  RA[j-1].isAzimuth then
              RA[j-1].Yaw := AzimuthToDirAngle(RA[j-1].Yaw, B, L, MyZone, UTM);

          if  RA[j].isAzimuth then
              RA[j].Yaw := AzimuthToDirAngle(RA[j].Yaw, B, L, MyZone, UTM);

           RA[j-1].isAzimuth := false;
           RA[j].isAzimuth   := false;

          GetDeltas(RTrack[I], RA[J-1].Pitch + C*(PrepareAngle(RA[J].Pitch,RA[J-1].Pitch) - RA[J-1].Pitch),
                           RA[J-1].Roll  + C*(PrepareAngle(RA[J].Roll, RA[J-1].Roll)  - RA[J-1].Roll),
                           RA[J-1].Yaw   + C*(PrepareAngle(RA[J].Yaw, RA[J-1].Yaw)    - RA[J-1].Yaw));


         {  GetDeltas(RTrack[I], RA[J-1].Pitch + C*(RA[J].Pitch - RA[J-1].Pitch),
                           RA[J-1].Roll  + C*(RA[J].Roll  - RA[J-1].Roll),
                           RA[J-1].Yaw   + C*(RA[J].Yaw   - RA[J-1].Yaw)); }

          I1 := J-1;
          break;
        end
          else
            if (Track[i].T > RA[J].T) then
            begin
            //   showmessage('skip');
               continue;
            end;
    end;
  end;



  RecomputeMarkers(False);
  Result := Cnt;

  if RMethod = 1 then
    TaleMethodReductions(Track, RTrack, RA, RSet, Rmethod);
 end;

procedure ComputeReductedTrack(var RdTrack:TTrack; Track:TTrack; RTrack: TRedTrack);

    procedure GetXY(Dat, Sk: integer; B, L, H : Double; var x, y, z: Double);
    var Zone : integer; Azone: boolean;
    begin
       WGS := FindDatum('WGS84');
       Zone := 0;
       AZone := True;

       if Dat = -1 then
       begin
            /// SK - C�
           if CoordinateSystemList[SK].DatumN <> WGS then
              Geo1ForceToGeo2(B, L, H, WGS, CoordinateSystemList[SK].DatumN,
                              B, L, H);

           if  CoordinateSystemList[SK].ProjectionType <=1 then
                DatumToCoordinateSystem(SK, B, L, H, x, y, z)
                else
                   DatumToCoordinateSystem(SK, B, L, H, y, x, z);

       end
          else
            begin
              /// SK - ��� ��������
              case SK of
                 0: begin
                   

                   if Dat <> WGS then
                     Geo1ForceToGeo2(B, L, H, WGS, Dat, B, L, H);

                   x := B;
                   y := L;
                   z := H;
                 end;

                 1:   begin
                   // XYZ
                    if Dat <> WGS then
                       Geo1ForceToGeo2( B, L, H, Dat, WGS, B, L, H);

                    GeoToECEF(Dat,B, L, H, x, y, z);

                    

                 end;
                 2:  begin
                   // GK
                   if Dat <> WGS then
                       Geo1ForceToGeo2( B, L, H, WGS, Dat, B, L, z);

                   GeoToGaussKruger(Dat, B, L, y, x, Zone, Azone);

                 end;
                 3,4:  begin
                   // UTM

                   if Dat <> WGS then
                       Geo1ForceToGeo2( B, L, H, WGS, Dat, B, L, z);

                   GeoToUTM(Dat, B, L, SK = 4, y, x, Zone, Azone);
                 end;

              end;
            end;
   end;

   procedure CopyTrack(var Track1: TTrack; Track2:TTrack);
   var i:integer;
   begin
      SetLength(Track1, Length(Track2));
      for I := 0 to Length(Track2)-1 do
      begin
        Track1 [I] := Track2[I];
      end;
   end;

var I:integer;
    L :TLatLong;
begin
  if Length(Track) <> Length(RTrack) then
     exit;

  
   CopyTrack(RdTrack, Track);

  for I := 0 to Length(Track) - 1 do
  begin
    RdTrack[I].x := RdTrack[I].x  + RTrack[I].dX;
    RdTrack[I].y := RdTrack[I].y  + RTrack[I].dY;
    RdTrack[I].H := RdTrack[I].H  + RTrack[I].dz;
    RdTrack[I].Hgeo := RdTrack[I].Hgeo + RTrack[I].dz;

    L := MapToBL(RdTrack[I].x, RdTrack[I].y);
    RdTrack[I].B := L.lat;
    RdTrack[I].L := L.long;

    GetXY(MainTrackDatum,MainTrackCS, RdTrack[I].B, RdTrack[I].L, RdTrack[I].H,
           RdTrack[I]._x, RdTrack[I]._y, RdTrack[I]._z);

    if (MainTrackDatum = -1) then  ////// IF ECEF - CONTINUE CYCLE
        if CoordinateSystemList[MainTrackCS].ProjectionType = 1 then
           continue
             else
               if (MainTrackCS = 1) then
                 continue;

    if Track[I].HGeo <> 0 then      ////// IF HAVE HGEO - h := hgeo))
       RdTrack[I]._z := RdTrack[I].HGeo;
    
  end;

end;

procedure SaveGpxFileWithTrack(FileName:String; AskifExist:boolean);
var
    S :TStringList;
    I, J: integer;
    _Hour, _min, _sec, _msec, _Day, _Month, _Year: Word;
    SDate, stime:string;
const
 hdr1 ='<?xml version="1.0" encoding="UTF-8" standalone="no" ?>';
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
     for I := 0 to Length(Markers) - 1 do
     Begin
       S.Add('');
       S.Add('  <wpt lat="'
              + ChangeSeps(format('%.7f',[Markers[I].Gx]), '.') +
              '" lon="' + ChangeSeps(format('%.6f',[Markers[I].Gy]), '.') +'">');

       S.Add('    <name>' + Markers[I].MarkerName + '</name>');
       S.Add('    <sym>Flag, Blue</sym>');
       S.Add('    '+xt);   S.Add('    '+xt8);   S.Add('      '+xt9);
       S.Add('    '+xt10);  S.Add('    '+xte);
       S.Add('  </wpt>');
     End;

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


     /// tracks
     if length(MainTrack) > 1 then
     begin
       S.Add('  <trk>');
       S.Add('    <name>Track</name>');
       S.Add('    '+xt);      S.Add('      '+xt11);   S.Add('        '+xt12);
       S.Add('      '+xt13);  S.Add('    '+xte);
       S.Add('    <trkseg>');
       for I := 0 to length(MainTrack)- 1 do
       begin
         S.Add('      <trkpt lat="'
              + ChangeSeps(format('%.12f',[MainTrack[I].B]), '.') +
              '" lon="' + ChangeSeps(format('%.12f',[MainTrack[I].L]), '.') +'">');

         S.Add('        <ele>' + ChangeSeps(format('%.7f',[MainTrack[I].HGeo]), '.') + '</ele>');
         try
           DecodeDateTime(MainTrack[I].T,_Year,_Month, _Day, _Hour, _Min, _Sec, _Msec);

           SDate := Inttostr(_Year)+'-';            //// ���������� ������1111

           if _Month<10 then
             SDate := SDate +'0'+ Inttostr(_Month)+'-'
              else
              SDate :=  SDate + Inttostr(_Month)+'-';
           if _Day<10 then
             SDate := SDate +'0'+ Inttostr(_Day)
              else
              SDate :=  SDate + Inttostr(_Day);

            if _Hour <10 then
             STime := '0'+ Inttostr(_Hour)+':'
              else
                STime := Inttostr(_Hour)+':';

            if _Min <10 then
             STime := STime + '0'+ Inttostr(_Min)+':'
              else
                STime  := STime  +  Inttostr(_Min)+':';

            if _Sec<10 then
             STime := STime +'0'+ Inttostr(_Sec)
              else
              STime :=  STime + Inttostr(_Sec);


            S.Add('        <time>'+ SDate + 'T'+ STime +'Z</time>');
         except
         end;
         S.Add('    </trkpt>');
       end;

       S.Add('    </trkseg>');
       S.Add('  </trk>');
     end;


     S.Add('</gpx>');

     for I := 0 to S.Count - 1 do
        S[I] := ANSIToUTF8(S[I]);
     //S.Text := UTF8Encode(S.Text);
     S.SaveToFile(FileName);
     S.Free;
     //SaveRoutesToFile(FileName, WGS, 0, 0, #$9);
end;

procedure DelTrackPoints(var Track :TTrack; I1,I2:Integer);

  procedure DelTrackPoint(I:integer);
  var j:integer;
  begin

    for J := I to Length(Track)-2 do
       Track[J] :=  Track[J+1];

    SetLength(Track, Length(Track)-1)
  end;

var I:Integer;
begin
  if I2 < I1 then
  begin
     I  := I1;
     I1 := I2;
     I2 := I;
  end;

  For I := I2 DownTo I1 Do
      DelTrackPoint(I);
end;

procedure ReComputeTrack(var Track :TTrack; WFZ: Boolean);
var X, Y : Double;
    i    : integer;
    dT, A1 : Double;
begin
   if Length(Track) = 0 then
      exit;

   WaitForZone := WFZ;

   For I := 0 to Length(Track)-1 Do
   Begin
     // if (Track[i].B = 0) and (Track[i].L=0) then       // DEBUG
     //   showmessage('omg');

      if UTM then
        GeoToUTM(WGS, Track[i].B, Track[i].L, South, y, x, Myzone, WaitForZone)
        else
          WGSToSK(Track[i].B, Track[i].L, 0, x, y, MyZone, WaitForZone);

     Track[i].x := x;
     Track[i].y := y;

   //  if (Track[i].x < 0) or (Track[i].y < 0) then      // DEBUG
   //      showmessage(inttostr(i)+ ' '+ Track[i]._T);


     WaitForZone := false;

     if I > 0 then
     Begin

       if Track[I].Speed = 0 then
       begin
          dT := DaySpan(Track[I].T,Track[I-1].T)*24;///1440;
          if dT <> 0 then
          begin
            Track[I].Speed := Sqrt(Sqr(Track[I].X-Track[I-1].X)
                                 + Sqr(Track[I].Y-Track[I-1].Y))*0.001 /dT  /// KMpH
          end;
       end;

       if Track[I].Azimuth = 0 then
       begin
            A1 := arcTan2(Track[I].X-Track[I-1].X, Track[I].Y-Track[I-1].Y);
            if A1 < 0 then
               A1 := A1 + 2* pi;
            /// A1 - ������������ ����. �������� � ������.
            Track[I].Azimuth := DirAngleToAzimuth(A1, Track[I].B, Track[I].L,
                                                  MyZone, UTM);
       end;

       if Track[I].RouteN<>-1 then
          GetRouteDist(Track, I);
     End;

   End;

   if WaitForCenter then
   Begin
      Center.x := Track[0].x;
      Center.y := Track[0].y;
      ShiftCenter := Center;
      WaitForCenter := False;
   End;

   if Track = MainTrack then
      if length(ReductedMainTrack) > 0 then
         ReComputeTrack(ReductedMainTrack, WFZ);

end;

procedure LoadTrackFromFile(var Track :TTrack; FileName:String; isAdd:Boolean;
              Spc : char; StartI,
              Dat, SK, TTab, Xtab, Ytab, Ztab, Htab, HGeoTab, SpeedTab, AzmtTab,
              PDopTAb, DateTab, CommentTab, AltTab, Alt2Tab, SatNtab, RouteTab,
              RDistTab, RProgressTab: integer; DateF, TimeF :String;
              isUTC, isMinTab, isSecTab: boolean; ManualDate:TDateTime;
              CompoundDT:Byte; ErrStr:string);

 var FormatSettings: TFormatSettings; AddZZZ:Boolean;
     ErrAsked: Boolean; ErrBreak:Boolean;

    function TimeFromString(s: string):TDateTime;
   // var FormatSettings: TFormatSettings;
    var I, j :integer;
    begin
     I := Pos('.', S);
     if  I <> 0 then
       s[I] :=  FormatSettings.DecimalSeparator;

     I := Pos(',', S);
     if  I <> 0 then
       s[I] :=  FormatSettings.DecimalSeparator;

       if TimeF[3] = FormatSettings.TimeSeparator then
       if s[3]<> TimeF[3] then
       begin
          s := '0' + s;
       end;

     if AddZZZ then
     Begin
       if Length(TimeF) < Length(S) then
         S := Copy(S,1,Length({FormatSettings.ShortTimeFormat)}TimeF));

       j :=   Length(TimeF) - Length(S);
       for I := 1 to j do
       begin
         if (I=0)and(j=4) then
            s := s + FormatSettings.DecimalSeparator
         else
            s := s + '0';
       end;

     End;


     try
       Result := StrToDateTime(S, FormatSettings);
     except
       if not ErrAsked then
       begin
         ErrAsked := true;
         if MessageDlg(ErrStr, MtConfirmation, mbYesNo, 0) <> 6 then
            ErrBreak := true;
       end;
     end;

    end;

    function DateTimeFromString(s:string):TDateTime;
    var j, I:byte;
    begin
     

     if AddZZZ then
     Begin

       if Length(FormatSettings.ShortDateFormat) < Length(S) then
         S := Copy(S,1,Length(FormatSettings.ShortDateFormat));

       j := Length(FormatSettings.ShortDateFormat) - Length(S);
       for I := 1 to j do
       begin
         if (I=0) and (j=4) then
            s := s +  FormatSettings.DecimalSeparator
         else
            s := s + '0';
       end;


     End;

     try
       Result := StrToDateTime(S, FormatSettings);
     except
       if not ErrAsked then
       begin
         ErrAsked := true;
         if MessageDlg(ErrStr, MtConfirmation, mbYesNo, 0) <> 6 then
            ErrBreak := true;
       end;
     end;

    end;

    procedure GetBL(x, y, z: Double; var B, L, H : Double);
    begin
       WGS := FindDatum('WGS84');

       if Dat = -1 then
       begin
            /// SK - C�

           if  CoordinateSystemList[SK].ProjectionType <=1 then
                CoordinateSystemToDatum(SK, x, y, z, B, L, H)
                else
                   CoordinateSystemToDatum(SK, y, x, z, B, L, H);

           if CoordinateSystemList[SK].DatumN <> WGS then
              Geo1ForceToGeo2(B, L, H,  CoordinateSystemList[SK].DatumN,
                              WGS, B, L, H);
       end
          else
            begin
              /// SK - ��� ��������
              case SK of
                 0: begin
                   B := x;
                   L := y;
                   H := z;
                   
                   if Dat <> WGS then
                     Geo1ForceToGeo2( x, y, z, Dat, WGS, B, L, H);
                 end;

                 1:   begin
                   // XYZ
                    ECEFToGeo(Dat, x, y, z, B, L, H);

                    if Dat <> WGS then
                       Geo1ForceToGeo2( B, L, z, Dat, WGS, B, L, H);

                 end;
                 2:  begin
                   // GK
                   GaussKrugerToGeo(Dat, y, x, B, L);

                   if Dat <> WGS then
                       Geo1ForceToGeo2( B, L, z, Dat, WGS, B, L, H);

                 end;
                 3,4:  begin
                   // UTM
                   UTMToGeo(Dat, y, x, SK = 4, B, L);

                   if Dat <> WGS then
                       Geo1ForceToGeo2( B, L, z, Dat, WGS, B, L, H);

                 end;

              end;
            end;
   end;

  var i, j, k, ctab, Progress : integer;
      S: TStringList;
      st : string;
      DT : TFormatSettings;
      T0 :TDateTime;
begin
  S := TSTringList.Create;

   if (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.xls')or
            (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5))='.xlsx')  then
              ExcelToStringList(FileName, S)
          else
              S.LoadFromFile(FileName);
 /// S.LoadFromFile(FileName);

  if not isAdd then
  begin
    SetLength(Track, 0);
    TrackHasComments := false;
  end;

  if isAdd then
  begin
    if Length(Track) > 0 then
        T0 := Trunc(Track[Length(Track)-1].T);
  end
    else
       T0 := Trunc(ManualDate);

  _Date0 := T0;

  ErrAsked := false; ErrBreak := false;

  FLoadGPS.Show;
  FLoadGPS.MapLoad.Visible := false;
  FLoadGPS.Label2.Hide;
  FLoadGPS.Label1.Hide;
  FLoadGPS.LCount.Caption := '';
  FLoadGPS.Label3.Show;
  FLoadGPS.Repaint;
  FloadGPS.ProgressBar1.Position := 0;

  InitDTFormat(DT);
  FormatSettings.DecimalSeparator := DecimalSeparator;
  if DateTab= -2 then
  begin
     FormatSettings.ShortDateFormat := TimeF;
     FormatSettings.LongTimeFormat  := FormatSettings.ShortDateFormat;
     FormatSettings.TimeSeparator := GetSep(TimeF)[1];

     if Pos(',', TimeF) > 1 then
      FormatSettings.DecimalSeparator := ','
         else
           FormatSettings.DecimalSeparator := '.';
  end
  else
  begin
     FormatSettings.ShortDateFormat := DateF + ' ' + TimeF;
     FormatSettings.LongTimeFormat  := FormatSettings.ShortDateFormat;
     FormatSettings.DateSeparator := GetSep(DateF)[1];
     FormatSettings.TimeSeparator := GetSep(TimeF)[1];
     if Pos(',', TimeF) > 1 then
        FormatSettings.DecimalSeparator := ','
     else
        FormatSettings.DecimalSeparator := '.';
  end;

  if Pos('z', TimeF) > 0 then
     AddZZZ := true;


  MainTrackCS := SK;
  MainTrackDatum := Dat;

  ctab := 1;
  if isSecTab then
    ctab := 3
     else
      if isMinTab then
         ctab := 2;

  k := length(Track) - 1;
  for I := StartI to S.Count - 1 do
  try
     if ErrBreak then
     begin
       if Length(Track)>0 then
         SetLength(Track, Length(Track)-1);
       Break;
     end;
         

     if S[I]='' then
        continue;

     inc(k);
     SetLength(Track, k+1);

     ClearTrackPoint(Track, k);

     Progress := round(I*100/(S.Count-1));
     if FloadGPS.ProgressBar1.Position - Progress <> 0 then
        FloadGPS.ProgressBar1.Position := Progress;

     st := GetCols(S[I], Ttab, 1, Spc, False);

     IF TimeF<>'' THEN
     BEGIN
       case DateTab of
         -1: begin
              Track[k].T := DateTimeFromString(st);
           end;
         -2: begin
              Track[k].T := T0 + TimeFromString(st);
              if K > 0 then
                if  Track[k].T < Track[k-1].T   then   //// ����� �����
                begin
                  T0 := T0+1;
                  Track[k].T := Track[k].T +1;
                end;
           end;
        else
          begin
              st :=  GetCols(S[I],DateTab,1,Spc,False) + ' ' +  st;
              Track[k].T := DateTimeFromString(st);
           end;
        end;
     END
      ELSE
      BEGIN
     // wdewa
         case CompoundDT of
           0, 2: //// Week.seconds
           begin
              st := GetCols(st,GetColCount(st,' '),1,' ',false);
              Track[k].T :=  TimeFromWeekSec(StrToFloat2(st))
           end;
           1: ///  DOY
              Track[k].T :=  TimeFromDOY(StrToInt(DateF), StrToFloat2(st));
           3: /// SOW
              Track[k].T :=  TOWToDateTime(StrToFloat2(st),StrToInt(DateF));
         end;
      END;

      if isUTC then
        Track[k].T := UTCToGPS(Track[k].T);

      Track[k]._T := DateTimeToStr2(Track[k].T, DT);

      Track[k]._z := 0;

      if HTab >= 0 then
         Track[k].H := StrToFloat2(GetCols(S[I], Htab, 1, Spc, True));

      if HGeoTab >= 0 then
         Track[k].HGeo := StrToFloat2(GetCols(S[I], HGeotab, 1, Spc, True));

      if (HTab < 0) and (HGeoTab >= 0) then
         Track[k].H := Track[k].HGeo;

      if Dat = -1 then
         J := CoordinateSystemList[SK].ProjectionType
          else
             J := SK;

      case J of
           0:   /// BL
           begin
             Track[k]._x := StrToLatLon(GetCols(S[I], Xtab, ctab, Spc, True), True);
             Track[k]._y := StrToLatLon(GetCols(S[I], Ytab, ctab, Spc, True), False);
             Track[k]._z := Track[k].H;
           end;

           1:   /// ECEF
           begin
             Track[k]._x := StrToFloat2(GetCols(S[I], Xtab, 1, Spc, True));
             Track[k]._y := StrToFloat2(GetCols(S[I], Ytab, 1, Spc, True));
             Track[k]._z := StrToFloat2(GetCols(S[I], Ztab, 1, Spc, True));
           end;

           2,3,4: /// G-k, Mercator
           begin
             Track[k]._x := StrToFloat2(GetCols(S[I], Xtab, 1, Spc, True));
             Track[k]._y := StrToFloat2(GetCols(S[I], Ytab, 1, Spc, True));
             Track[k]._z := Track[k].H;
           end;
      end;

      GetBL(Track[k]._x, Track[k]._y, Track[k]._z,
            Track[k].B, Track[k].L, Track[k].H);

      if (abs(Track[k].B)>90) or (Track[k].L<-180) or (Track[k].L>180)
         or ((Track[k]._x=0)and(Track[k]._y=0)) then
       begin
          SetLength(Track, Length(Track)-1);
          dec(k);
          continue;
       end;

     if PDOPTab >= 0 then
         Track[k].PDOP := StrToFloat2(GetCols(S[I], PDopTab, 1, Spc, True));

     if CommentTab >= 0 then
     Begin
         Track[k].Comment := GetCols(S[I], CommentTab, 1, Spc, True);
         if Track[k].Comment = '#Comments' then
         Begin
           AddMarker(GetCols(S[I], CommentTab+1, 1, Spc, True), Track[k].B, Track[k].L);

           SetLength(Track, Length(Track)-1);
           dec(k);
         End
         Else if Track[k].Comment <> '' then
            TrackHasComments := true;
     End;


     if SpeedTab >= 0 then
         Track[k].Speed:= StrToFloat2(GetCols(S[I], SpeedTab, 1, Spc, True));

     if AzmtTab >= 0 then
         Track[k].Azimuth := StrToFloat2(GetCols(S[I], AzmtTab, 1, Spc, True));

     if SatNTab >= 0 then
         Track[k].SatN := trunc(StrToFloat2(GetCols(S[I], SatNTab, 1, Spc, True)));

     if AltTab >= 0 then
         Track[k].Altitude := StrToFloat2(GetCols(S[I], AltTab, 1, Spc, True));

     if Alt2Tab >= 0 then
     begin
         Track[k].AltR := Track[k].Altitude;
         Track[k].AltL := StrToFloat2(GetCols(S[I], Alt2Tab, 1, Spc, True));
     end;

     if RDistTab >= 0 then
         Track[k].RouteDist := StrToFloat2(GetCols(S[I], RDistTab, 1, Spc, True));

     if RProgressTab >= 0 then
         Track[k].RouteProgress := round(StrToFloat2(GetCols(S[I], RProgressTab, 1, Spc, True)));

     // if  Track[k].RouteProgress > 0 then
      //  ShowMessage(GetCols(S[I], RProgressTab, 1, Spc, True));

     Track[k].RouteN := -1;
     if RouteTab >= 0 then
     begin
         Track[k].RouteName := GetCols(S[I], RouteTab, 1, Spc, True);
         if (Track[k].RouteName<>'')and(Track[k].RouteName<>'---') then
         begin
           Track[k].RouteN := FindRouteByName(Track[k].RouteName);
         end
          else
          begin
             Track[k].RouteName := '---' ;
             Track[k].RouteDist := 0;
             Track[k].RouteProgress := 0;
          end;
     end;
  except
  end;

  FloadGPS.Close;
  ReComputeTrack(Track, WaitForZOne);
  S.Free;
end;


procedure TrackFastFilter(var Track :TTrack; BPM:String);
  var I:Integer;
      HasBad :Boolean;
  const BadC = 1000;

begin
   if Length(Track) < 0 then
     exit;

   // ������� ��������
     HasBad := false;
     for I := Length(Track) - 1 downto 1 do
     if abs(Track[I].x - Track[I-1].x)+
        abs(Track[I].y - Track[I-1].y)  > BadC then
       begin
         HasBad := true;
         break;
       end;

   if HasBad then
      HasBad := MessageDlg(BPM, MtConfirmation, MbYesNo,0) = 6;

   if not HasBad then
       exit;

   // ����������
   for I := Length(Track) - 1 downto 1 do
     if abs(Track[I].x - Track[I-1].x)+
        abs(Track[I].y - Track[I-1].y)  > BadC then
       begin
         DelTrackPoints(Track, I, I);
       end;

   if Length(Track) > 1 then
   if abs(Track[0].x - Track[1].x)+
        abs(Track[0].y - Track[1].y)  > BadC then
          DelTrackPoints(Track, 0, 0);
end;

function NewRNFormat(FileName:String; StartI:Integer):Boolean;
  var S:TStringList;
  begin
     S:=TStringList.Create;
     S.LoadFromFile(FileName);
     try
       result := GetCols(S[StartI+1], 16, 1, 1, false) = '_';
     except
     end;
     S.Free;
  end;

procedure LoadTrackFromRTT(var Track :TTrack; FileName:String; isAdd:Boolean;
           StartI:integer; ErrStr:String);
  
begin
    /// NEW
    ///
    if NewRNFormat(FileName, StartI) then
    LoadTrackFromFile(Track, FileName, isAdd, #$9, StartI,
                      WGS, 0, 0, 1, 2, -1, 9,
                      3, 17, -1, 15, 13, 18,
                      10, 11, 14, 5, 6, 12,
                      'DD.MM.YYYY', 'hh:mm:ss.zzz',
                      false, false, false, Now, 0, ErrStr)
    else                  
    /// OLD
    LoadTrackFromFile(Track, FileName, isAdd, #$9, StartI,
                      WGS, 0, 0, 1, 2, -1, 9,
                      3, -1, -1, -1, 13, 14,
                      10, 11, -1, 5, 6, 12,
                      'DD.MM.YYYY', 'hh:mm:ss.zzz',
                      false, false, false, Now, 0, ErrStr);

    {LoadTrackFromFile(var Track :TTrack; FileName:String; isAdd:Boolean; Spc : char; StartI,
              Dat, SK, TTab, Xtab, Ytab, Ztab, Htab,
              HGeoTab, SpeedTab, AzmtTab, PDopTAb, DateTab, CommentTab,
              AltTab, Alt2Tab, SatNtab, RouteTab, RouteDistTab, RouteProgTab: integer;
              DateF, TimeF :String; isUTC: boolean);}
end;

procedure LoadTrackFromRTA(var Track :TTrack; FileName:String; isAdd:Boolean;
          ErrStr:String);
var StartI :Integer;
begin
    StartI := LoadRoutesFromRTS(FileName, isAdd, inf[102])+1;
    if NewRNFormat(FileName, StartI) then
       LoadTrackFromFile(Track, FileName, isAdd, #$9,
                      StartI,
                      WGS, 0, 0, 1, 2, -1, 9,
                      3, 17, -1, 15, 13, 18,
                      10, 11, 14, 5, 6, 12,
                      'DD.MM.YYYY', 'hh:mm:ss.zzz',
                      false, false, false, NOW, 0, ErrStr)
    else
       LoadTrackFromFile(Track, FileName, isAdd, #$9, StartI,
                      WGS, 0, 0, 1, 2, -1, 9,
                      3, -1, -1, -1, 13, -1,
                      10, 11, -1, 5, 6, 12,
                      'DD.MM.YYYY', 'hh:mm:ss.zzz',
                      false, false, false, NOW, 0, ErrStr);

end;

procedure LoadTrackFromUDF(FN:String; var Track: TTrack; uCS, uDatum: integer;
   isDatum, skipH, ROrder: boolean);

  procedure GetBL(x, y, z: Double; var B, L, H : Double);
  begin
       WGS := FindDatum('WGS84') ;

       if isDatum = false then
       begin /// RouteCS - C�
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
              /// RouteCS - ��� ��������
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
    I, j :Integer;
    P: TMyPoint;
    B, L, H, dT :Double;
    DTi: TFormatSettings;
begin
  OpenUdfFile(FN, Udf);

  if UDF.DataCount = 0 then
     exit;       

  j := Length(Track);
  SetLength(Track, j + Udf.DataCount);

  for I := 0 to Udf.DataCount - 1 do
  begin
    if not ROrder then
       GetBL(Udf.Data[I].y, Udf.Data[I].x, Udf.Data[I].z, B, L, H)
    else
       GetBL(Udf.Data[I].x, Udf.Data[I].y, Udf.Data[I].z, B, L, H);
    if SkipH then
       H := Udf.Data[I].z;

    if WaitForZone then
      MyZone := UTMZonebyPoint(B, L);

    P := BLToMap(B, L);

    Track[j + I].T := Udf.Data[I].DateTime;
    InitDTFormat(DTi);
    Track[j + I]._T := DateTimeToStr2(Udf.Data[I].DateTime, DTi);     

    Track[j + I].B := B;
    Track[j + I].L := L;
    Track[j + I].H := H;
    if SkipH then
    begin
        Track[j + I].HGeo := H;
        Track[j + I].H := 0;
    end;

    Track[j + I].x := P.x;
    Track[j + I].y := P.y;
    Track[j + I].z := H;

    Track[j + I].RouteN := -1;
    Track[j + I].RouteName := '---';

    if I > 0 then
    begin
       dT := DaySpan(Track[j +I].T,Track[j +I-1].T)*24;
       if dT <> 0 then
       begin
         Track[j +I].Speed := Sqrt(Sqr(Track[j +I].X-Track[j +I-1].X)
                         + Sqr(Track[j +I].Y-Track[j +I-1].Y))*0.001 /dT  /// KMpH
       end;
    end
    else
      Track[j + I].Speed := 0;
  end;

end;

procedure prepareGPX(var S:TStringList);
var I,j,k,txp, progress:LongInt;    S2:TStringList;
begin
  if S.Count > 15 then
     exit;

  S2 :=TStringList.Create;
  S2.Text := S.Text;
  S.Clear;
  txp := 0;

  for J := 0 To S2.Count-1 do
  begin
    S.Add('') ;

    for I := 1 To length(S2[J]) do
    begin
     txp := txp+1;
     Progress := round(txp*100/length(S2.Text));
     if FloadGPS.ProgressBar1.Position - Progress <> 0 then
        FloadGPS.ProgressBar1.Position := Progress;

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

procedure LoadGpxTrack(FileName:String; var Track:TTrack; DoAdd:Boolean);

 Function TimeFromGPX(Sd:String): TDateTime;
  var  _Year, _Day, _Month, _Hour, _Min, _Sec, _mSec : Integer;
  begin
    _Day   := StrToInt(Copy(SD,9,2));
    _Month := StrToInt(Copy(SD,6,2));
    _Year  := StrToInt(Copy(SD,1,4));

    _Hour  := StrToInt(Copy(SD,12,2));
    _Min   := StrToInt(Copy(SD,15,2));
    _Sec   := StrToInt(Copy(SD,18,2));

    _mSec  := 0;

    Result := EncodeDateTime(_Year, _Month, _Day, _Hour, _Min, _Sec, _mSec);
  end;


var i, j, k, Progress : integer;
    lat,lon,h : real;
    S: TStringList;
    cs, s2: String;
begin
   S := TStringList.Create;
   S.LoadFromFile(Filename);

   TrackHasComments := false;

   FLoadGPS.Show;
   FLoadGPS.MapLoad.Visible := false;
   FLoadGPS.Label2.Hide;
   FLoadGPS.Label1.Hide;
   FLoadGPS.LCount.Caption := '';
   FLoadGPS.Label3.Show;
   FLoadGPS.Repaint;
   FloadGPS.ProgressBar1.Position := 0;

   I := 0;
   S.Text := UTF8ToAnsi(S.Text);
   prepareGPX(S);

   //RouteCount := 0;
   //SetLength(Markers,0);
   if not DoAdd then
   begin
     RouteCount := 0;
     SetLength(Markers,0);
   end;


   // 1. WayPoints
   repeat
     cs := AnsilowerCase(S[I]);

     Progress := round(I*100/(S.Count-2));
     if FloadGPS.ProgressBar1.Position - Progress <> 0 then
     Begin
        FloadGPS.ProgressBar1.Position := Progress;
        // FloadGPS.Caption := IntTostr(I);
        //FloadGPS.ProgressBar1.Repaint
     End;

     k := Pos('<trkpt', cs);
     if k = 0 then
        k := Pos('<wpt', cs);

     try
     if (k = 0) then
     begin
       inc(i);
       continue;
     end;


     if (k<>0) then
     begin
         /// getting lat-lon
         cs := copy(cs, k + 5, length(cs) - k - 4 );
         lat := 0;
         lon := 0;

         j := Pos('lat', cs);
         k := Pos('lon', cs);
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

           if (Lat<>0)and(lon<>0) then
           Begin
              SetLength(Track, Length(Track)+1);
              Track[Length(Track)-1].B := Lat;
              Track[Length(Track)-1].L := Lon;
              Track[Length(Track)-1].CS := WGS;
              Track[Length(Track)-1]._X := Lat;
              Track[Length(Track)-1]._Y := Lon;
              Track[Length(Track)-1].RouteN := -1;
              Track[Length(Track)-1].RouteName := '---';
              Track[Length(Track)-1].RouteDist := 0;
              Track[Length(Track)-1].RouteProgress := 0;
           End;

          
          repeat
            j := Pos('<ele>', cs);
            k := Pos('</ele>', cs);

            if j<>0 then
              if (Lat<>0)and(lon<>0) then
              Begin
                 s2 := copy(cs, j+5, k-j-5);
                 Track[Length(Track)-1].HGeo := StrToFloat2(s2);
              End;

            j := Pos('<ele>', cs);
            k := Pos('</ele>', cs);

            if j<>0 then
              if (Lat<>0)and(lon<>0) then
              Begin
                 s2 := copy(cs, j+6, k-j-6);
              End;

            j := Pos('<time>', cs);
            k := Pos('</time>', cs);

            if j<>0 then
              if (Lat<>0)and(lon<>0) then
              Begin
                 s2 := copy(cs, j+6, k-j-6);
                 Track[Length(Track)-1].T := TimeFromGPX(s2);
                 Track[Length(Track)-1]._T := DateTimeToStr(Track[Length(Track)-1].T);
              End;


            inc(I);
            if I <= S.Count-1 then
                cs := AnsilowerCase(S[I]);

          until (I > S.Count-2) or (Pos('</trkpt>',S[I])>0) or (Pos('</wpt>',S[I])>0);

       end;

     except
     end;
     inc(I);
   until I>= S.Count-1;
   
   FloadGPS.Close;
   ReComputeTrack(Track, WaitForZOne);
   S.Free;

   {if DoAdd then
      SortTrack(Track);}

end;

procedure SaveRTTFile( var Track :TTrack; FileName:String; FullFormat:Boolean);
var I: Integer;
    S: TSTringList;
    str, rn: String;
    r : real;
begin

  r := 0;
  S:= TSTringList.Create;

  if FullFormat then
  Begin
    AddRTSInfo(S);
    S.Add('//Track')
  End;

  for I := 0 to Length(MainTrack) - 1 do
  begin
    if I>0 then
       r := r + sqrt(sqr(MainTrack[I].x- MainTrack[I-1].x)
                    +sqr(MainTrack[I].y- MainTrack[I-1].y));


    if (MainTrack[I].RouteN = -1) and (MainTrack[I].RouteName = '') then
       rn := '---'
        else
          rn :=  MainTrack[I].RouteName;
          
     with MainTrack[I] do
       str := FormatDateTime('hh:mm:ss.zzz', T) + #$9 +
            format('%.10f',[B]) + #$9 + format('%.10f',[L]) + #$9 +
            format('%.2f',[HGeo]) + #$9 + format('%.n',[R]) + #$9 +
            rn + #$9 + format('%.1f',[RouteDist]) + #$9 +
            format('%.n',[x]) + #$9 + format('%.n',[y]) + #$9 +
            format('%.2f',[H]) + #$9 + format('%.3f',[AltR]) + #$9 +
            format('%.3f',[AltL]) + #$9 + IntToStr(RouteProgress) + #$9 +
            FormatDateTime('DD.MM.YYYY', T) + #$9 +
            IntToStr(SatN)+ #$9 +  format('%.2f',[PDOP])+ #$9 + '_' + #$9 +
            format('%.2f',[Speed]) + Comment;


            

     S.Add(str);
  end;
  S.SaveToFile(FileName);
  S.Free;
end;

procedure SaveRTTFileForAnalysis( var Track :TTrack; FileName:String;
        CSN:Integer; FullFormat:Boolean);
var zone: Integer;
    az :boolean;

  function getCS42(B, L, H :Double):string;
  var SK42 :integer;
      B2, L2, H2, x, y :Double;
  begin
     if CSN < 0 then
     begin
       SK42 := FindDatum('SK42');
       Geo1ToGeo2(B, L, H, WGS, SK42, B2, L2, H2);
       GeoToGaussKruger(SK42, B2, L2, x, y, zone, az);
       az := false;
     end else
     if CoordinateSystemList[CSN].ProjectionType > 1 then
     begin
        Geo1ForceToGeo2(B, L, 0, WGS,
                        CoordinateSystemList[CSN].DatumN, B2, L2, H2);

        DatumToCoordinateSystem(CSN, B2, L2, H2, x, y, h2);
     end
     else
     begin
       SK42 := FindDatum('SK42');
       Geo1ToGeo2(B, L, H, WGS, SK42, B2, L2, H2);
       GeoToGaussKruger(SK42, B2, L2, x, y, zone, az);
       az := false;
     end;
     result := format('%.n',[x]) + #$9 + format('%.n',[y]);
  end;


var I : Integer;
    S: TSTringList;
    str, rn: String;
    r : real;
begin
  az := true;

  r := 0;
  S:= TSTringList.Create;

  if FullFormat then
  Begin
    AddRTSInfo(S);
    S.Add('//Track')
  End;

  for I := 0 to Length(MainTrack) - 1 do
  begin
    if I>0 then
       r := r + sqrt(sqr(MainTrack[I].x- MainTrack[I-1].x)
                    +sqr(MainTrack[I].y- MainTrack[I-1].y));


    if (MainTrack[I].RouteN = -1) and (MainTrack[I].RouteName = '') then
       rn := '---'
        else
          rn :=  MainTrack[I].RouteName;

     with MainTrack[I] do
       str := FormatDateTime('hh:mm:ss.zzz', T) + #$9 +
            format('%.10f',[B]) + #$9 + format('%.10f',[L]) + #$9 +
            format('%.2f',[HGeo]) + #$9 + format('%.n',[R]) + #$9 +
            rn + #$9 + format('%.1f',[RouteDist]) + #$9 + getCS42(B, L, H) + #$9 +
            format('%.2f',[H]) + #$9 + format('%.3f',[AltR]) + #$9 +
            format('%.3f',[AltL]) + #$9 + IntToStr(RouteProgress) + #$9 +
            FormatDateTime('DD.MM.YYYY', T)+ #$9 +
            IntToStr(SatN)+ #$9 +  format('%.2f',[PDOP])+ #$9 + '_' + #$9 +
            format('%.2f',[Speed]) + Comment;

     S.Add(str);
  end;
  S.SaveToFile(FileName);
  S.Free;
end;

procedure CutAnglesbyTime(MinT: real);
  function GetNext(I :integer):integer;
  var J:integer;
  begin
     Result := I+1;

     for J := I+1 to Length(RedAngles) - 1 do
         if (abs(RedAngles[J].T - RedAngles[I].T) >= MinT/86400 )
             or (J = Length(RedAngles) - 1) then
                 begin
                   result := J;
                   break;
                 end;

  end;

var i, j: integer;
   _RedAngles: TAngles;
begin

  if length(RedAngles)< 2 then
     exit;

  SetLength(_RedAngles, 1);
  _RedAngles[0] := RedAngles[0];

  j := 0;
  repeat
    i := j;
    j := GetNext(I);

    if (I=J) or (J> Length(RedAngles)-1) then
        break;

    SetLength(_RedAngles, Length(_RedAngles)+1);
    _RedAngles[Length(_RedAngles)-1] := RedAngles[J];

  until (I=J) or (J >= Length(RedAngles)-1);


  SetLength(RedAngles, Length(_RedAngles));
  for I := 0 to Length(_RedAngles) - 1 do
  begin
     RedAngles[I] := _RedAngles[I];
  end;
end;

procedure CutAnglesbyDist(MinDist: real; Track: TTrack);

var I0: integer;

  function GetXYfromTrack(T: TDateTime; var X, Y : real): boolean;
  var I :integer; C: real;
  begin
    Result := false;
    for I := I0 to length(Track) - 1 do
      if (T > Track[i-1].T) and (T <= Track[I].T) then
      begin
        Result := True;
        if I > 1 then
          I0 := I-1;
        C := (T - Track[i-1].T) / (Track[I].T -  Track[i-1].T);

        X := Track[I-1].x + c*(Track[I].x - Track[I-1].x);
        Y := Track[I-1].y + c*(Track[I].y - Track[I-1].y);
        break;
      end
        else
          if (T < Track[I-1].T) then
             break;
  end;

  function GetNext(I :integer):integer;
  var J:integer;
     x1,y1, x2,y2 :real;
  begin
    Result := I+1;

    if GetXYfromTrack(RedAngles[I].T, x1, y1) then
     for J := I+1 to Length(RedAngles) - 1 do
     begin

       if not GetXYfromTrack(RedAngles[J].T, x2, y2) then
          continue;

       if (sqrt(sqr(x1 - x2) + sqr(y1 - y2)) >= MinDist)
             or (J = Length(RedAngles) - 1) then
                 begin
                   result := J;
                   break;
                 end;
     end;

  end;
var i, j :integer;
    B1, B2, L1, L2: real;
   _RedAngles: TAngles;
begin

  if length(RedAngles)< 2 then
     exit;

  I0 := 1;

  SetLength(_RedAngles, 1);
  _RedAngles[0] := RedAngles[0];

  j := 0;
  repeat
    i := j;
    j := GetNext(I);

    if (I=J) or (J> Length(RedAngles)-1) then
        break;

    SetLength(_RedAngles, Length(_RedAngles)+1);
    _RedAngles[Length(_RedAngles)-1] := RedAngles[J];

  until (I=J) or (J >= Length(RedAngles)-1);


  SetLength(RedAngles, Length(_RedAngles));
  for I := 0 to Length(_RedAngles) - 1 do
  begin
     RedAngles[I] := _RedAngles[I];
  end;

end;

procedure LoadAnglesFromFile(FileName:String; Spc :char; StartI,  TTab,
              YawTab, Pitchtab, Rolltab, DateTab, YawKind : integer; MagAng: real;
               DateF, TimeF :String; isUTC, isDegs : boolean);

    function TimeFromString(s: string):TDateTime;
    var FormatSettings: TFormatSettings; I :integer;
    begin
     FormatSettings.ShortDateFormat := TimeF;
     FormatSettings.LongTimeFormat  := FormatSettings.ShortDateFormat;
     FormatSettings.TimeSeparator := GetSep(TimeF)[1];

     if Pos(',', TimeF) > 1 then
      FormatSettings.DecimalSeparator := ','
         else
           FormatSettings.DecimalSeparator := '.';

     I := Pos(',', S);
     if  I <> 0 then
       s[I] :=  FormatSettings.DecimalSeparator;

     I := Pos('.', S);
     if  I <> 0 then
       s[I] :=  FormatSettings.DecimalSeparator;

     try
       Result := StrToDateTime(S, FormatSettings);
     except
     end;

    end;

    function DateTimeFromString(s:string):TDateTime;
    var FormatSettings: TFormatSettings;
    begin
     FormatSettings.ShortDateFormat := DateF + ' ' + TimeF;
     FormatSettings.LongTimeFormat  := FormatSettings.ShortDateFormat;

     FormatSettings.DateSeparator := GetSep(DateF)[1];
     FormatSettings.TimeSeparator := GetSep(TimeF)[1];

     if Pos(',', TimeF) > 1 then
      FormatSettings.DecimalSeparator := ','
         else
           FormatSettings.DecimalSeparator := '.';

     try
       Result := StrToDateTime(S, FormatSettings);
     except
     end;

    end;

var S: TStringList;
    st: string;
    i, j, Progress : integer;
    T0: TDateTime;
begin
  if not Fileexists(FileName) then
    exit;

  S := TStringList.Create;
  S.LoadFromFile(FileName);
  SetLength(RedAngles, 0);

  Progress := 0;

  FLoadGPS.Show;
  FLoadGPS.MapLoad.Visible := false;
  FLoadGPS.Label2.Hide;
  FLoadGPS.Label1.Hide;
  FLoadGPS.LCount.Caption := '';
  FLoadGPS.Label3.Show;
  FLoadGPS.Repaint;
  FloadGPS.ProgressBar1.Position := 0;

  T0 := _Date0;

  for I := StartI to S.Count - 1 do
  Begin
     if S[i] = '' then
       continue;

     Progress := round(I*100/(S.Count-1));
     if FloadGPS.ProgressBar1.Position - Progress <> 0 then
        FloadGPS.ProgressBar1.Position := Progress;

     SetLength(RedAngles, Length(RedAngles)+1);
     J := Length(RedAngles)-1;
     ClearAngles(RedAngles,J);

     st := GetCols(S[I], Ttab, 1, Spc, False);

     IF TimeF<>'' THEN
     BEGIN
       case DateTab of
         -1: begin
              RedAngles[j].T := DateTimeFromString(st);
           end;
         -2: begin
              RedAngles[j].T := T0 + TimeFromString(st);
              if j > 0 then
                if  RedAngles[j].T < RedAngles[j-1].T   then   //// ����� �����
                begin
                  T0 := T0+1;
                  RedAngles[j].T := RedAngles[j].T +1;
                end;
           end;
        else
          begin
              st :=  GetCols(S[I],DateTab,1,Spc,False) + ' ' +  st;
              RedAngles[j].T := DateTimeFromString(st);
           end;
        end;
     END
      ELSE
      BEGIN
           if DateF = '' then //// Week.seconds
              RedAngles[j].T :=  TimeFromWeekSec(StrToFloat2(st))
                else  ///  DOY
                  RedAngles[j].T :=  TimeFromDOY(StrToInt(DateF), StrToFloat2(st));
      END;

      if isUTC then
        RedAngles[j].T := UTCToGPS(RedAngles[j].T);

     RedAngles[J].N := -1;

     RedAngles[J].Yaw := StrToFloat2(GetCols(S[I], Yawtab, 1, Spc, True));
     RedAngles[J].isAzimuth := YawKind > 0;
     RedAngles[J].Pitch := StrToFloat2(GetCols(S[I], Pitchtab, 1, Spc, True));
     RedAngles[J].Roll  := StrToFloat2(GetCols(S[I], Rolltab, 1, Spc, True));

     if isDegs then
     Begin
       RedAngles[J].Pitch :=  RedAngles[J].Pitch*pi/180;
       RedAngles[J].Roll  :=  RedAngles[J].Roll *pi/180;
       RedAngles[J].Yaw   :=  RedAngles[J].Yaw  *pi/180;
     End;

     if YawKind = 2 then
       RedAngles[J].Yaw   := RedAngles[J].Yaw  + MagAng*180/pi;
  End;

  FLoadGPS.Close;

  S.Free;
end;

function GetTrackStat(Track: TTrack):TTrackStat;
var
  I, FSN, RSN : Integer;
  L: real;
  olddt, dt :TDateTime;
begin

 result.MinT := 0;
 result.MaxT := 0;
 result.EpCount := 0;
 result.TrackL := 0;
 result.SlipCount := 0;
 result.EpOnRoutes := 0;
 result.AvgH := 0;
 result.AvgHGeo := 0;
 result.AvgSpd := 0;
 result.AvgFSpd := 0;
 result.AvgRSpd := 0;

 FSN := 0;    RSN := 0;

 if Length(Track)< 2 then
   exit;

 result.MinT := Track[0].T;
 result.MaxT := Track[Length(Track)-1].T;
 result.EpCount := Length(Track);

 for I := 1 to  Length(Track) - 1 do
 begin
    result.TrackL := result.TrackL+ sqrt ( sqr(Track[I].x-Track[I-1].x)+
                     sqr(Track[I].y-Track[I-1].y) );

    result.AvgH := result.AvgH + Track[I].H;
    result.AvgHGeo :=  result.AvgHGeo + Track[I].HGeo;

    result.AvgSpd := result.AvgSpd + Track[I].Speed;

    if (Track[I].Speed > 10) or (Track[I].Altitude > 5) then
    begin
      inc(FSN);
      result.AvgFSpd := result.AvgFSpd + Track[I].Speed;
    end;

    if (Track[I].RouteN > -1) or (Track[I].RouteName <> '---') then
    begin
      inc(RSN);
      result.AvgRSpd := result.AvgRSpd + Track[I].Speed;
    end;

    dT := Track[i].T - Track[i-1].T;

    if (Track[i].RouteN <> -1) then
      inc(result.EpOnRoutes);

    if I > 1 then
      if dT > olddT*2 then
          inc(result.SlipCount);

    if dt<>0 then
      olddt := dt;
 end;

 if FSN > 0 then
   result.AvgFSpd := result.AvgFSpd/FSN
 else
   result.AvgFSpd := 0;

 if RSN > 0 then
   result.AvgRSpd := result.AvgRSpd/RSN
 else
   result.AvgRSpd := 0;

 result.AvgSpd := result.AvgSpd/(Length(Track)-1);
 result.AvgH := result.AvgH/(Length(Track)-1);
 result.AvgHGeo :=  result.AvgHGeo/(Length(Track)-1);

 if (Track[0].RouteN <> -1) then
   inc(result.EpOnRoutes);

 result.PrOnRoutes := round(100*result.EpOnRoutes/result.EpCount);

end;


procedure AttachToRoute(var Track :TTrack; T1, T2 :TDateTime; RNum, RMethod :integer;
                       MaxD :Double; DoFilter, DoReset:Boolean);
var R, R1, R2: integer; // Routes start-end cycle
    I, N, N1, N2, DN: integer; // Epochs start-end cycle
    F1, F2, J :Integer;  /// Epochs that can be attacheded - from ... to
    Rmin : real;
    FStarted: Boolean; /// found start!
    isZero  : Boolean;
    RPD, RPi :TRoutePosAndDist;
begin

//// ROUTES DIAP
  if RNum>=0 then
  Begin
    R1 := RNum;
    R2 := RNum;
  End
  else
    begin
      R1 := 0;
      R2 := RouteCount-1;
    end;

//// TIME DIAP (Numbers of Epohcs)
  N := Length(Track) - 1;

  for I := 0 to N do
    if Track[I].T >= T1 then
    begin
      N1 := I;
      break;
    end;

  for I := N downto N1 do
    if Track[I].T <= T2 then
    begin
      N2 := I;
      break;
    end;
  DN := N2-N1;

  if DoReset then
    For I := N1 To N2 Do
    begin
      Track[I].RouteN := -1;
      Track[I].RouteName := '---';
      Track[I].RouteDist := 0;
      Track[I].RouteProgress := 0;
    end;
  for R := R1 to R2 do
  begin
    FStarted := false;
    For I := N1 To N2 Do
    try
      RPD := PosAndDistToRoute(Track[I].x, Track[I].y, R);
      if Length(Route[R].WPT) = 1 then
      begin
           if  (RPD.Dist < MaxD)  then   ////// ROUTE = 1 point
           begin
              Track[I].RouteN := R;
              Track[I].RouteName := Route[R].Name;
              if Track[I-1].RouteN<>R then
               Track[I].RouteProgress := 0
                else
                 Track[I].RouteProgress := 100;

           end;
      end
        else
      case DoFilter of
        FALSE:
          if (RPD.Dist < MaxD) then
             if (RPD.Pos >= 0)and (RPD.Pos <=1) then
               begin
                 Track[I].RouteN := R;
                 Track[I].RouteName := Route[R].Name;
                 Track[I].RouteProgress := round(RPD.Pos*100);
                 Track[I].RouteDist := RPD.Dist;
               end;

        TRUE:
        BEGIN
          case FStarted of
            false:
               if (RPD.Dist < MaxD) then
                 if (RPD.Pos >= 0)and (RPD.Pos <= 1) then
                 begin
                    FStarted := True;
                    F1 := I;
                    isZero := (RPD.Pos < 0.5);
                 end;

            true:
               if (RPD.Dist > MaxD*2) then
                   FStarted := False
                    else
                      if not ( (RPD.Pos >= 0)and (RPD.Pos <= 1) ) or (I>=N2) then
                      begin
                       FStarted := False;
                       F2 := I-1;
                       if ( (RPD.Pos > 0.5) and IsZero ) or
                          ( (isZero = false)and(RPD.Pos < 0.5) ) then
                             for J := F1 to F2 do
                             begin
                                  Track[j].RouteN := R;
                                  Track[j].RouteName := Route[R].Name;

                                  RPi := PosAndDistToRoute(Track[j].x, Track[j].y, R);
                                  Track[j].RouteProgress := round(RPi.Pos*100);
                              //    if not isZero then
                              //       Track[j].RouteProgress := 100 - Track[j].RouteProgress;
                                  Track[j].RouteDist := RPi.Dist;
                             end;
                      end;
          end;    //// case end

        END;

      end; ///// filter case end
    Except
    End;

  end;
//
end;

procedure MakeStops(Track:TTrack; T1, T2 :TDateTime; RMethod:integer;
                    MaxL, MinN, MinT :real; DelOld:Boolean);
var
   I, J, K, DK, N, N1, N2, DN :Integer;
   mx, my, L :real;
   isFound :boolean;
   A1, A2: Array of TMyPointEx;
   BL: TLatLong;
begin
  if Length(Track) < 2 then
     exit;

  if DelOld then
     ResetMarkers;

  N := Length(Track) - 1;

  for I := 0 to N do
    if Track[I].T >= T1 then
    begin
      N1 := I;
      break;
    end;

  for I := N downto N1 do
    if Track[I].T <= T2 then
    begin
      N2 := I;
      break;
    end;
  DN := N2-N1;

  SetLength(A1, 0);
  I := N1;
  J := N1;
  FOR I := N1 TO N2 DO
  BEGIN
     L := Sqrt (sqr(Track[i].x - Track[j].x)
        + sqr(Track[i].y - Track[j].y));

     if ( L > MaxL) or
        ( (I=N2) and (L <= maxL) ) then
     begin
        case RMethod of
          0: isfound := (I-1)-J >= MinN;
          1: isfound := (Track[i-1].t - Track[j].t)*86400 >= MinT;
        end;

        if isfound then
        begin
            setLength(A1, Length(A1)+1);
            A1[Length(A1)-1].x := 0;
            A1[Length(A1)-1].y := 0;
            A1[Length(A1)-1].H := 0;
            A1[Length(A1)-1].Hgeo := 0;

            DK := I - J;

            for K := I-1 Downto J do
            begin
                A1[Length(A1)-1].x := A1[Length(A1)-1].x + (Track[k].x);
                A1[Length(A1)-1].y := A1[Length(A1)-1].y + (Track[k].y);
                A1[Length(A1)-1].H := A1[Length(A1)-1].H + (Track[k].H);
                A1[Length(A1)-1].HGeo := A1[Length(A1)-1].Hgeo + (Track[k].Hgeo);
            end;
            if DK > 0 then
            begin
                A1[Length(A1)-1].x := A1[Length(A1)-1].x / DK;
                A1[Length(A1)-1].y := A1[Length(A1)-1].y / DK;
                A1[Length(A1)-1].H := A1[Length(A1)-1].H / DK;
                A1[Length(A1)-1].Hgeo := A1[Length(A1)-1].Hgeo / DK;
            end;

            isfound := false;
        end;

        j := I;
     end;

  END;
  setLength(A2, 0);
  J := 0;
  /// filtering
  for I := 1 to Length(A1) - 1  do
  begin
    if SQRT( Sqr(A1[J].x - A1[I].x) + Sqr(A1[J].y - A1[I].y)) >= MaxL then
    begin
         setLength(A2, Length(A2)+1);
         A2[Length(A2)-1].x := 0;
         A2[Length(A2)-1].y := 0;
         A2[Length(A2)-1].H := 0;
         A2[Length(A2)-1].Hgeo := 0;

         DK := I - J;

         for K := I-1 Downto J do
         begin
            A2[Length(A2)-1].x := A2[Length(A2)-1].x + (A1[k].x);
            A2[Length(A2)-1].y := A2[Length(A2)-1].y + (A1[k].y);
            A2[Length(A2)-1].H := A2[Length(A2)-1].H + (A1[k].H);
            A2[Length(A2)-1].Hgeo := A2[Length(A2)-1].Hgeo + (A1[k].Hgeo);
         end;

         if DK > 1 then
         begin
            A2[Length(A2)-1].x := A2[Length(A2)-1].x / DK;
            A2[Length(A2)-1].y := A2[Length(A2)-1].y / DK;
            A2[Length(A2)-1].H := A2[Length(A2)-1].H / DK;
            A2[Length(A2)-1].Hgeo := A2[Length(A2)-1].Hgeo / DK;
         end;
         J := I;
    end;
  end;


  for I := 0 to Length(A2) - 1 do
  begin
    BL := MapToBL(A2[I].x, A2[I].y);
    AddMarker(IntToStr(I+1), BL.Lat, BL.Long, A2[I].H, A2[I].HGeo, 0);
  end;
   ///RecomputeMarkers(WaitForZone);
end;

procedure MakeRINStops(Track:TTrack; T1, T2 :TDateTime;
          DoFilter, DelOld, AddAntH, AddPts:Boolean; FCount: integer);

var
   I, J, K, DK, N, N1, N2, DN :Integer;
   AvgX, AvgY, AvgH, AvgHGeo :real;

   isFound :boolean;
   A1: Array of TMyPointEx;
   A2: Array of TMyPointEx;
   BL: TLatLong;

  procedure AddToA1(AddI:Integer);
  begin
    SetLength(A1, Length(A1)+1);
    A1[Length(A1)-1].x    := Track[AddI].x;
    A1[Length(A1)-1].y    := Track[AddI].y;
    A1[Length(A1)-1].H    := Track[AddI].H;
    A1[Length(A1)-1].HGeo := Track[AddI].HGeo;
  end;

  procedure CalcA1Avgs;
  var I:integer;
  begin
   AvgX :=0; AvgY :=0; AvgH := 0; AvgHGeo := 0;
    for I := 0 to Length(A1) - 1 do
    Begin
      AvgX := AvgX + A1[I].x;
      AvgY := AvgY + A1[I].y;
      AvgH := AvgH + A1[I].H;
      AvgHGeo := AvgHGeo + A1[I].HGeo;
    End;
    AvgX := AvgX/Length(A1);  AvgY := AvgY/Length(A1);
    AvgH := AvgH/Length(A1);  AvgHGeo := AvgHGeo/Length(A1);
  end;

  procedure DelA1(DelI: integer);
  var I : integer;
  begin
     if Length(A1) > 0 then
       for I := DelI to Length(A1) - 2 do
         A1[I] := A1[I+1];

     SetLength(A1, Length(A1)-1);
  end;

  procedure Filter3sigma;
  var avgL, sigma2, sigma :real;
      L: array of real;
      I : integer;
  begin
    sigma2 := 0;
    avgL := 0;

    SetLength(L, Length(A1));
    for I := 0 to Length(A1) - 1 do
    begin

      L[I] := sqrt( sqr(AvgX - A1[I].x) + sqr(AvgY - A1[I].y) +
                 sqr(AvgH - A1[I].H) + sqr(AvgHGeo - A1[I].HGeo) ) ;

      avgL := avgL + L[I]/Length(A1);

    end;

    for I := 0 to Length(A1) - 1 do
    Begin
       sigma2 := sigma2 + sqr(L[I] - avgL)/Length(A1);
    End;
       sigma := sqrt(sigma2);

    for I := Length(A1) - 1 downTo 0 do
    Begin
       if L[I] > 3*sigma then
          DelA1(I);
    End;

    SetLength(L, 0);
  end;

begin
  if Length(Track) < 2 then
     exit;

  if Length(RinMarkers) < 1 then
     exit;

  if DelOld then
     ResetMarkers;

  N := Length(Track) - 1;

  for I := 0 to N do
    if Track[I].T >= T1 then
    begin
      N1 := I;
      break;
    end;

  for I := N downto N1 do
    if Track[I].T <= T2 then
    begin
      N2 := I;
      break;
    end;
  DN := N2-N1;

  SetLength(A1, 0);
  I := N1;
  J := N1;

  FOR J := 0 TO Length(RinMarkers) DO
  BEGIN

    //// STEP 1. SEARCH FOR DATA
    SetLength(A1, 0);
    For I := N1 To N2 Do
    Begin
     if (Track[I].T < RinMarkers[J].T1) then
       continue
       else
       if (Track[I].T >= RinMarkers[J].T1) and (Track[I].T <= RinMarkers[J].T2) then
         AddToA1(I)
         else
         if Track[I].T > RinMarkers[J].T2 then
         begin
             N1 := I;   //// For speed-up next search
             break;
         end;
    End;

    if Length(A1) = 0 then
       continue;

    //// STEP 2. PROCESS THE DATA

    /// 2a Filtering
    If DoFilter Then
    for I := 1 to FCount do
    Begin
    /// Here will be filtering algorithm
       CalcA1Avgs;
       Filter3sigma;
    End;

    /// 2b Calculate Averages
    CalcA1Avgs;

    //// 2c AntH apply
    if AddAntH then
    Begin
      AvgH := AvgH - RinMarkers[J].AntH;
      AvgHGeo := AvgHGeo - RinMarkers[J].AntH;
    End;

    /// 2d AddToMap if neccessary
    if AddPts then    
      for I := 0 to Length(A1) - 1 do
      Begin
        BL := MapToBL(A1[I].x, A1[I].y);
        AddMarker('!#9999', BL.Lat, BL.Long, A1[I].H, A1[I].HGeo, 0);
      End;

    //// STEP 3. Save as Marker

    BL := MapToBL(AvgX, AvgY);
    AddMarker(RinMarkers[J].MarkerName, BL.Lat, BL.Long, AvgH, AvgHGeo, 0);

    { L := Sqrt (sqr(Track[i].x - Track[j].x)
        + sqr(Track[i].y - Track[j].y));

     if ( L > MaxL) or
        ( (I=N2) and (L <= maxL) ) then
     begin
        case RMethod of
          0: isfound := (I-1)-J >= MinN;
          1: isfound := (Track[i-1].t - Track[j].t)*86400 >= MinT;
        end;

        if isfound then
        begin
            setLength(A1, Length(A1)+1);
            A1[Length(A1)-1].x := 0;
            A1[Length(A1)-1].y := 0;
            DK := I - J;

            for K := I-1 Downto J do
            begin
                A1[Length(A1)-1].x := A1[Length(A1)-1].x + (Track[k].x);
                A1[Length(A1)-1].y := A1[Length(A1)-1].y + (Track[k].y);
            end;
            if DK > 0 then
            begin
                A1[Length(A1)-1].x := A1[Length(A1)-1].x / DK;
                A1[Length(A1)-1].y := A1[Length(A1)-1].y / DK;
            end;

            isfound := false;
        end;

        j := I;
     end;  }

  END;

end;

function GetTrackFullL(Track:TTrack):Double;
  var J :integer;
begin
  result := 0;
  for J := 1 to Length(Track) - 1 do
  begin
    result := result + sqrt(
              Sqr(Track[J].x - Track[J-1].x) +
              Sqr(Track[J].y - Track[J-1].y));
  end;
end;

function GetCroppedTrackFullL(Track:TTrack; N1, N2 :Integer):Double;
  var J :integer;
begin
  result := 0;
  for J := N1 to N2 do
  begin
    result := result + sqrt(
              Sqr(Track[J].x - Track[J-1].x) +
              Sqr(Track[J].y - Track[J-1].y));
  end;
end;

procedure CropAndResampleTrack(var Track:TTrack; NewStep :Double; N1, N2:Integer);
var X1, Y1, X2, Y2, H1, H2,  HGeo1, HGeo2, T1, T2: Double;
    CurL, FullL, SegL, CStep : Double;  SegN:Integer;

  procedure AddTrackPoint(var Tr:TTrack; N :Integer; x, y, h, hgeo, t :Double);
  var J: Integer;
  begin
    if Length(Tr) <= N-1 then
      SetLength(Tr, N+1000);

    Tr[N].x := x;  Tr[N].y := y;
    Tr[N].HGeo := HGeo;  Tr[N].H := H;  Tr[N].T := T;
    Tr[N].Speed := 0;
    Tr[N].Azimuth := 0;
    Tr[N].Visible := True;
  end;

  function GetSegL:double;
  begin
     result := sqrt( Sqr(X2 - X1) + Sqr(Y2 - Y1));
  end;

  procedure NextSeg;
  begin
    inc(SegN);

    if SegN > Length(Track) - 1  then
      SegL := -1
      else
        begin
           X1 := Track[SegN-1].x;        X2 := Track[SegN].x;
           Y1 := Track[SegN-1].y;        Y2 := Track[SegN].y;
           T1 := Track[SegN-1].T;        T2 := Track[SegN].T;
           H1 := Track[SegN-1].H;        H2 := Track[SegN].H;
           HGeo1 := Track[SegN-1].H;     HGeo2 := Track[SegN].H;

           SegL := GetSegL;
        end;
  end;


var I, Max :Integer;
    _Track :TTrack;
    c :Double;
begin
  if NewStep = 0 then
  begin
    SetLength(_Track, N2-N1 +1);
    for I := N1 to N2 do
      _Track[I- N1] :=   Track[I];
  end

  else
  begin
    CropAndResampleTrack(Track, 0, N1, N2);

    FullL := GetTrackFullL(Track);
    SetLength(_Track, trunc(FullL / NewStep)+2);

    N1 := 0; N2 := Length(_Track);
    _Track[0] := Track[0];
    CurL  := 0;   CStep := 0;    SegL  := 0;   SegN := 0;   Max := 0;

    if FullL > NewStep then
    repeat
      CurL  := CurL  + NewStep;
      cStep := cStep + NewStep;

      while (SegL <= cStep) or (SegL = 0) do
      begin
        cStep := cStep - SegL;
        NextSeg;

        if SegL < 0 then
          break;
      end;

      if SegL < 0 then
         break;

      inc(Max);
      c := cStep / SegL;
      X1 := X1 + c*(X2 - X1);   Y1 := Y1 + c*(Y2 - Y1);
      T1 := T1 + c*(T2 - T1);   H1 := H1 + c*(H2 - H1);
      HGeo1 := HGeo1 + c*(HGeo2 - HGeo1);

      AddTrackPoint(_Track, Max, X1, Y1, H1, HGeo1, T1);

      SegL := GetSegL;
      cStep := 0;
    until CurL > FullL;

    inc(Max);
    SetLength(_Track, Max+1);
    _Track[Max] := Track[length(Track)-1];
  end;

  SetLength(Track, Length(_Track));
  for I := 0 to Length(_Track) - 1 do
    Track[I] := _Track[I];
end;

procedure MakeMNKRoute(Track :TTrack; T1, T2 :TDateTime; RMethod:integer;
                       MinL: Double; DoMinL, DoReset:Boolean; RName:String;
                       NewStep :Double);
var
  I, J, N, N1, N2, DN :Integer;
  A, B, sX, sY, sX2, sXY, mX, mY, azn :real;
  p1, p2, p1n, p2n :TMyPoint;
begin
  if Length(Track) < 2 then
  exit;

  if DoReset then
    ResetRoutes;
  inc(RouteCount);
  sX := 0;
  sY := 0;
  sX2 := 0;
  sXY := 0;

  N := Length(Track) - 1;

  for I := 0 to N do
    if Track[I].T >= T1 then
    begin
      N1 := I;
      break;
    end;

  for I := N downto N1 do
    if Track[I].T <= T2 then
    begin
      N2 := I;
      break;
    end;
  DN := N2-N1;

  if DN < 2  then
   exit;

  CropAndResampleTrack(Track, NewStep, N1, N2);
  N1 := 0;
  N2 := Length(Track)-1;
  DN := N2-N1;

  mX := Track[N1].X;
  mY := Track[N1].Y;

  for I := N1 to N2 do
  begin
     sX := sX + (Track[I].X-mx);        //// ����� �� � ������� � mX, mY
     sY := sY + (Track[I].Y-my);
  end;

  for I := N1 to N2 do
  begin
      sXY := sXY + (Track[I].X-mx)*(Track[I].Y-my);
      sX2 := sX2 + sqr(Track[I].X-mx);
  end;

  a   := (sy - DN*sxy/sx);     /// a, b - ������������
  azn := (sx - DN*sx2/sx);
  a := a/azn;
  b := (sxy - a*sx2)/sx;

  p1.x := Track[N1].X - mx;
  p1.y := a*p1.x + b;

  p2.x := Track[N2].X - mx;
  p2.y := a*p2.x + b;

  /// SHIFT!
  p1.x := p1.x  + mx;     p1.y := p1.y  + my;
  p2.x := p2.x  + mx;     p2.y := p2.y  + my;

  p1n := GetNormalPt(p1.x, p1.y, p2.x, p2.y, Track[N1].X, Track[N1].y, false, 0);
  p2n := GetNormalPt(p1.x, p1.y, p2.x, p2.y, Track[N2].X, Track[N2].y, false, 0);

  if RName = '' then
     RName := inf[83];

  Inc(MeanLineCount);
  if MeanLineCount > 1 then
    Route[RouteCount-1].Name := RName +' ('+IntToStr(MeanLineCount)+')'
    else
      Route[RouteCount-1].Name :=  RName;

  SetLength(Route[RouteCount-1].WPT, 2);
  Route[RouteCount-1].WPT[0] := p1n;
  Route[RouteCount-1].WPT[1] := p2n;

  RoutesToGeo;
  RecomputeRoutes(WaitForZone);

  if DoMinL then
    ExpandShortRoutes(MinL, RouteCount-1);

end;


procedure LoadAnglesFromNMEA(FileName:String);
Function LatLongFromNMEA(SLatLong, SSign:String; isLat: Boolean): Double;
  begin

    case isLat of
      true:
        Begin
          Insert(' ',SLatLong,3);
          Result := StrToLatLon(SLatLong, true);
          if AnsiUpperCase(SSign) = 'S' then
             Result := - Result;
        End;

      false:
        Begin
          Insert(' ',SLatLong,4);
          Result := StrToLatLon(SLatLong, false);
          if AnsiUpperCase(SSign) = 'W' then
             Result := - Result;
        End;
    end;

  end;

  Function TimeFromNMEA(SDate, STime:String): TDateTime;
  var  _Year, _Day, _Month, _Hour, _Min, _Sec, _mSec : Integer;
  begin
    _Day   := StrToInt(Copy(SDate,1,2));
    _Month := StrToInt(Copy(SDate,3,2));
    _Year  := StrToInt(Copy(SDate,5,2));

    _Hour  := StrToInt(Copy(STime,1,2));
    _Min   := StrToInt(Copy(STime,3,2));
    _Sec   := StrToInt(Copy(STime,5,2));

    _mSec  := trunc( (StrToFloat2(STime)-trunc(StrToFloat2(STime)))*1000 );

    if _Year < 70 then
       _Year := _Year + 2000
         else
         if _Year < 1900 then
            _Year := _Year + 1900;

    Result := EncodeDateTime(_Year, _Month, _Day, _Hour, _Min, _Sec, _mSec);
  end;

  var I, J, Progress :integer;
      T :TDateTime;
      S :TStringList;

      B,L :Real;
      Tab0 :Integer;
      str, str2 :String;
begin

   if FileExists(FileName) = false then
      exit;

   S := TStringList.Create;
   S.LoadFromFile(FileName);

   SetLength(RedAngles, 0);

   FLoadGPS.Show;
   FLoadGPS.MapLoad.Visible := false;
   FLoadGPS.Label2.Hide;
   FLoadGPS.Label1.Hide;
   FLoadGPS.LCount.Caption := '';
   FLoadGPS.Label3.Show;
   FLoadGPS.Repaint;
   FloadGPS.ProgressBar1.Position := 0;

   /// NMEA0183
   for I := 0 to S.Count - 1 do
   begin
     Progress := round(I*100/(S.Count-1));
     if FloadGPS.ProgressBar1.Position - Progress <> 0 then
        FloadGPS.ProgressBar1.Position := Progress;

     J := Pos ('RMC', S[I]);
     if J > 0 then
     try
       Tab0  := GetColN(S[I],',',J);
       Str   := GetCols(S[I], Tab0 + 1, 1, ',', False); /// TIME
       Str2  := GetCols(S[I], Tab0 + 9, 1, ',', False); /// DATE
       T     := UTCToGPS(TimeFromNmea(Str2, Str));

       J := Length(RedAngles) - 1;                        //// OLD or NEW Point
       if (J = -1) then
       begin
         SetLength(RedAngles, Length(RedAngles)+1);
         ClearAngles(RedAngles, Length(RedAngles)-1);
       end
         else
           if (RedAngles[J].T) <> T then
           begin
               SetLength(RedAngles, Length(RedAngles)+1);
               ClearAngles(RedAngles, Length(RedAngles)-1);
           end;

       J := Length(RedAngles) - 1;
       RedAngles[J].T  := T;

       Str :=  GetCols(S[I], Tab0 + 3, 1, ',', False); /// Lat
       Str2 := GetCols(S[I], Tab0 + 4, 1, ',', False);
       B  := LatLongFromNmea(Str, Str2, True);

       Str :=  GetCols(S[I], Tab0 + 5, 1, ',', False); /// Long
       Str2 := GetCols(S[I], Tab0 + 6, 1, ',', False);
       L  := LatLongFromNmea(Str, Str2, False);

       if (abs(B)>90) or (L<-180) or (L>180) then
       begin
          SetLength(RedAngles, Length(RedAngles)-1);
          continue;
       end;

       Str := GetCols(S[I], Tab0 + 8, 1, ',', False);
       RedAngles[J].Yaw := StrToFloat2(Str)*pi/180;
       RedAngles[J].Yaw := AzimuthToDirAngle(RedAngles[J].Yaw, B, L, MyZone, UTM);
       
     except
      // showmessage('!');
     end;

   end;

   FLoadGPS.Close;
   S.Free;

end;

procedure SelectedPointsToRoute(Track:TTrack; N1, N2, Rn:integer);
var I: integer;
    RP :TRoutePosAndDist;
begin

  for i := N1 to N2 do
  try

      Track[i].RouteN := Rn;
      if Rn >=0 then
      begin
        Track[i].RouteName := Route[Rn].Name;
        RP := PosAndDistToRoute(Track[i].x,  Track[i].y, Rn);
        Track[I].RouteProgress:= Round(RP.Pos*100);
                       
        Track[I].RouteDist := RP.Dist;
      end
       else
        begin
            Track[i].RouteName := '---';
            Track[I].RouteProgress:= 0;
            Track[I].RouteDist := 0;
        end;


  except
  end;

end;

procedure SelectedPointsToRoute(Track:TTrack;Rn:integer);
var I: integer;
    P1, P2, P3: TMyPoint;
    RP :TRoutePosAndDist;
begin
  P1 := BLToScreen(CanvCursorBL.lat,  CanvCursorBL.long);
  P2 := BLToScreen(CanvCursorBL0.lat, CanvCursorBL0.long);
  for i := 0 to Length(Track) - 1 do
  try
   P3 := MapToScreen(Track[i].X, Track[i].Y);
   if PointInRect(P1.x, P1.y, P2.x, P2.y, P3.X, P3.y) then
   begin
      Track[i].RouteN := Rn;
      if Rn >=0 then
      begin
        Track[i].RouteName := Route[Rn].Name;
        RP := PosAndDistToRoute(Track[i].x,  Track[i].y, Rn);
        Track[I].RouteProgress:= Round(RP.Pos*100);
        Track[I].RouteDist := RP.Dist;
      end
       else
        begin
            Track[i].RouteName := '---';
            Track[I].RouteProgress:= 0;
            Track[I].RouteDist := 0;
        end;
   end;
  except
  end;

end;

procedure DrawTrackInfo(Track: TTrack; AsphCanvas: TAsphyreCanvas;
              AsphImages: TAsphyreImages; AshpFonts: TAsphyreFonts;
              TrackColor, MenuColor, InfColor, RedColor, FntColor,
              InactiveTrack, RouteColor:Cardinal; X, Y : Real;
              RouteNum, Mselect:Integer; DoSmooth:Boolean);

   procedure CrackDot(x, y: Double; Col:Cardinal);
   begin
     If (x > 0) And (y > 0) And (X < DispSize.X) And (y < DispSize.y) Then
     Begin
       AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8, 8));
       AsphCanvas.TexMap(pRotate4c(Point2(x,y),Point2(8, 8), 0),cColor4(Col));
     End;
   end;

var I, L, J, lastn, n :integer;
    BarSizeX, StrCount :integer;
    P: TPosAndDist;
    Str: array [1..10] of String;
    P1, P2, P3 : TMyPoint;
    FindP3 :Boolean;
    Dist, MinDist, DA: real;
    PDR:TRouteposandDist; /// to route
const Distpx = 32;


function Col:Cardinal;
begin
  Result := TrackColor;

  if RouteNum = -2 then
    exit
    else
    begin

      if (Track[i-1].RouteN <> -1) or (Track[i].RouteN <> -1) then
      begin
        Result := TrackColor;

        if RouteNum > -1 then
          if not((Track[i-1].RouteN = RouteNum)or (Track[i].RouteN = RouteNum)) then
            Result := TrackColor - $B0000000;
      end
        else
           result := InactiveTrack;

    end;
end;

begin

  MinDist := DistPx;
  J := -1;
  ViewTrackPoint := -1;
  LastN := 0;

  if (RouteNum = -3) and (TrackColorSch.Kind = 8) then
    RouteNum := -1;


  if MSelect>0 then
  begin
    P1.X := X;
    P1.Y := Y;
    P2 := BLToScreen(CanvCursorBL0.lat, CanvCursorBL0.long);
    for i := 0 to Length(Track) - 1 do
    try
        P3 := MapToScreen(Track[i].X, Track[i].Y);
        if Track[i].Visible = true then
          if PointInRect(P1.x, P1.y, P2.x, P2.y, P3.X, P3.Y) then
          begin
             CrackDot(P3.x, P3.y, RouteColor);
          end;
    except
    end;
    exit;
  end;

  P1 := ScreenToMap(X,Y);
  case ChoosedTrackPoint of
    -1:
    for i := 1 to Length(Track) - 1 do
    try
        if Track[i].Visible = true then
        begin
          Dist := abs(P1.x- Track[i].x) +  abs(P1.y- Track[i].y);
          if Dist < Distpx*Scale*2 then
          begin
             P2 := MapToScreen(Track[i].x,Track[i].y);
             CrackDot(P2.x, P2.y, Col);

             if Track = MainTrack then
             Begin

               ////////////////////////// NORMAL TO ROUTE
               if RouteNum > -2 then
               begin
                 if Track[I].RouteN>=0 then
                    if (Track[I].RouteN=RouteNum)or(RouteNum=-1) then
                    try
                       PDR := PosAndDistToRoute(Track[I].x, Track[I].y, Track[I].RouteN);
                       if PDR.Dist <> -1 then
                       begin
                         P3.x := PDR.x;
                         P3.y := PDR.y;
                         P3 := MapToScreen(P3.X, P3.Y);

                         if abs(P3.x-P2.x)+abs(P3.y-P2.y) > 2 then
                            MyLine(AsphCanvas, P3.x, P3.y, P2.x,
                               P2.y, False, DoSmooth, RouteColor);
                         CrackDot(P3.x, P3.y, RouteColor);
                       end;
                    except
                    end;
               end;
               if Length(ReductedMainTrack) > 0 then
               Begin
                  ////////////////////////// LINE TO REDUCTED POINT
                  FindP3 := false;

                  if Length(ReductedMainTrack)-1 > I then
                   if Abs(ReductedMainTrack[i].T - MainTrack[i].T) <= mindT then
                   Begin
                      FindP3 := true;
                      P3 := MapToScreen(ReductedMainTrack[i].X, ReductedMainTrack[i].Y);
                   End;

                  if not FindP3 then
                    for n := lastn to Length(ReductedMainTrack)-1 do
                      if Abs(ReductedMainTrack[n].T - MainTrack[i].T) <= mindT then
                      Begin
                        FindP3 := true;
                        Lastn := n;
                        P3 := MapToScreen(ReductedMainTrack[n].X, ReductedMainTrack[n].Y);
                      End;

                  if FindP3 then
                  begin
                    if abs(P3.x-P2.x)+abs(P3.y-P2.y) > 2 then
                        MyLine(AsphCanvas, P3.x, P3.y, P2.x,
                            P2.y, False, DoSmooth, RedColor);

                    CrackDot(P3.x, P3.y, RedColor);
                  end;
               End;

             End;
          end;
          if Dist < MinDist*Scale then
          Begin
             J := I;
             MinDist := Dist/Scale;
             ViewTrackPoint := J;
          End;
        end;
    except
    end;

    else
      begin

         if ChoosedTrackPoint < Length(Track) -1 then
            J := ChoosedTrackPoint
              else
              begin
                ChoosedTrackPoint := -1;
                exit;
              end;
      end;
  end;

    if J <> -1 then
    Begin
       with Track[J] do
       DA := AzimuthToDirAngle(Azimuth, B, L, MyZone, UTM);
       P2 := MapToScreen(Track[j].x,Track[j].y);

       AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
       AsphCanvas.TexMap(pRotate4c(Point2(P2.x,P2.y),Point2(32, 32), DA+fi),cColor4(InfColor));

        if Track = MainTrack then

        if Length(ReductedMainTrack) > 0 then
        Begin
          ////////////////////////// LINE TO REDUCTED POINT
          FindP3 := false;

          if Length(ReductedMainTrack)-1 > j then
             if Abs(ReductedMainTrack[j].T - MainTrack[j].T) <= MindT then
             Begin
                FindP3 := true;
                P3 := MapToScreen(ReductedMainTrack[j].X, ReductedMainTrack[j].Y);
             End;

             if not FindP3 then
               for n := 0 to Length(ReductedMainTrack)-1 do
                 if Abs(ReductedMainTrack[n].T - MainTrack[j].T) <= MindT then
                 Begin
                   FindP3 := true;
                   Lastn := n;
                   P3 := MapToScreen(ReductedMainTrack[n].X, ReductedMainTrack[n].Y);
                 End;

             if FindP3 then
             Begin
               if abs(P3.x-P2.x)+abs(P3.y-P2.y) > 2 then
                    FatLine(AsphCanvas, P3.x, P3.y, P2.x,
                           P2.y, 1, False, DoSmooth, RedColor);
               CrackDot(P3.x, P3.y, InfColor);
             End;
        end;

        ////////////////////////// NORMAL TO ROUTE
        if RouteNum > -2 then
        begin
          if Track[j].RouteN>=0 then
              if (Track[j].RouteN=RouteNum)or(RouteNum=-1) then
              try
                  PDR := PosAndDistToRoute(Track[j].x,Track[j].y,Track[j].RouteN);
                  if PDR.Dist <> -1 then
                   begin
                         P3.x := PDR.x;
                         P3.y := PDR.y;
                         P3 := MapToScreen(P3.X, P3.Y);

                         if abs(P3.x-P2.x)+abs(P3.y-P2.y) > 2 then
                            FatLine(AsphCanvas, P3.x, P3.y, P2.x,
                               P2.y, 1, False, DoSmooth, RouteColor);
                         CrackDot(P3.x, P3.y, RouteColor);
                  end;

              except
              end;
        end;

       BarSizeX := 0;
       StrCount := 0;

       str[1] := Track[j]._T;
       if Track[j].H <> 0 then
          str[2] := inf[39] + Format('%n',[Track[j].HGeo]) + inf[40]
            else
              str[2] := '';

       if Track[j].HGeo <> 0 then
       begin
          if str[2]<>'' then
             str[2] := str[2] + '; ';
          str[2] := str[2] + inf[38] + Format('%n',[Track[j].H]) + inf[40];
       end;

       str[3] := inf[34] + IntToStr(round(Track[j].Speed)) + inf[35];

       if Track[j].SatN > 0 then
          str[4] := inf[36] + IntToStr(Track[j].SatN)
            else
              str[4] := '';

       if Track[j].PDOP <> 0 then
       begin
          if str[4]<>'' then
            str[4] := str[4] + '; ';
          str[4] := str[4] +  inf[37] + Format('%n',[Track[j].PDOP])
       end;

       str[6] := Track[j].Comment;

       str[5] := '';
       if Track[j].RouteN>=0 then
       begin
         str[5] := inf[85] + Track[j].RouteName + ' '+inf[86]
                           + Format('%n',[Track[j].RouteDist])+ inf[40]
                           + ' ' + inf[87] + IntTostr(Track[j].RouteProgress) +'%';
       end;

       for I := 1 to 6 do
       begin
         if str[I]<>'' then
           inc(StrCount);
         if BarSizeX < AsphFonts[Font0].TextWidth(Str[I]) then
            BarSizeX := Trunc(AsphFonts[Font0].TextWidth(Str[I]));
       end;

       AsphCanvas.FillRect(RECT( trunc(P2.x) + 10, trunc(P2.y) + 10,
                                 trunc(P2.x) + 15 + BarsizeX,
                                 trunc(P2.y) + 12 + (StrCount)*15), MenuColor);

       StrCount := 0;
       for I := 1 to 6 do
       begin
         if str[I]<>'' then
         begin
            AsphFonts[Font0].TextOut( Point2(trunc(P2.x) + 12,
                                      trunc(P2.y) + 12 + StrCount*15),
                                      str[i], cColor2(FntColor));
            inc(StrCount);
         end;
       end;

    End;
end;


procedure FocusOnTrack(Track:TTrack);
var xmax, ymax, xmin, ymin: real;
    i, j, Count : integer;
begin
 Count := Length(Track);

 if Count = 0 then
    exit;

  RecomputeTrack(Track, WaitForZone);

  if Count > 0 then
  Begin
     xmax := Track[0].x;
     ymax := Track[0].y;
     xmin := Track[0].x;
     ymin := Track[0].y;

     for I := 0 to Count - 1 do
     Begin

          if Track[i].x < xmin then
             xmin := Track[i].x;
          if Track[i].x > xmax then
             xmax := Track[i].x;

          if Track[i].y < ymin then
             ymin := Track[i].y;
          if Track[i].y > ymax then
             ymax := Track[i].y;
     End;

  End;

  Center.x := (xmin+xmax)/2;
  Center.y := (ymin+ymax)/2;

  I := 0;
  repeat
     inc(i);
     if abs(xmin-xmax) > abs(ymin-ymax) then
       J := trunc( abs(xmin-xmax) /TMashtab[I])
         else
          J := trunc( abs(ymin-ymax) /TMashtab[I]);

  until (I >= MaxMashtab-1) or (J<= DispSize.Y div 100);
  Mashtab := I;

  ShiftCenter.x := Center.x;
  ShiftCenter.y := Center.y;

end;


procedure TestColSchm;
var I:Integer;
begin
  TrackColorSch.isOn :=  false;

  if Length(MainTrack) = 0 then
    exit;

  TrackColorSch.isOn :=  true;
  TrackColorSch.Kind :=  1;

  TrackColorSch.Min :=  MainTrack[0].H;
  TrackColorSch.Max :=  MainTrack[0].H;

  for I := 0 to Length(MainTrack) - 1 do
  begin
    if MainTrack[I].H < TrackColorSch.Min then
      TrackColorSch.Min :=  MainTrack[I].H;
    if MainTrack[I].H > TrackColorSch.Max then
      TrackColorSch.Max :=  MainTrack[I].H;
  end;


    TrackColorSch.CSMarkCount := 3;
    //SetLength(TrackColorSch.CSMarks, TrackColorSch.CSMarkCount);

    TrackColorSch.CSMarks[0].R := 255;
    TrackColorSch.CSMarks[0].G := 0;
    TrackColorSch.CSMarks[0].B := 0;
    TrackColorSch.CSMarks[0].Mark := TrackColorSch.Min;

    TrackColorSch.CSMarks[1].R := 255;
    TrackColorSch.CSMarks[1].G := 255;
    TrackColorSch.CSMarks[1].B := 0;
    TrackColorSch.CSMarks[1].Mark := (TrackColorSch.Max + TrackColorSch.Min)/2;

    TrackColorSch.CSMarks[2].R := 0;
    TrackColorSch.CSMarks[2].G := 255;
    TrackColorSch.CSMarks[2].B := 0;
    TrackColorSch.CSMarks[2].Mark := TrackColorSch.Max;

    TrackColorSch.isSmooth := True;
end;



procedure DrawTrack(Track: TTrack; AsphCanvas: TAsphyreCanvas; AsphImages: TAsphyreImages;
      TrackColor, RedTrackColor, InactiveTrack :Cardinal; DrawPoints :Boolean; DrawCracks :Boolean;
      OptimizeStep :Integer; Smooth: Boolean; RouteNum:Integer);

   procedure CrackDot(x, y: Double; Col:Cardinal; isMin: Boolean);
   begin
     If (x > 0) And (y > 0) And (X < DispSize.X) And (y < DispSize.y) Then
     Begin
       AsphCanvas.UseImagePx(AsphImages.Image['dot.image'], pxBounds4(0, 0, 8, 8));
       if isMin then
        AsphCanvas.TexMap(pRotate4c(Point2(x,y),Point2(4, 4), 0), cColor4(Col))
        else
         AsphCanvas.TexMap(pRotate4c(Point2(x,y),Point2(8, 8), 0), cColor4(Col));
     End;
   end;

var   i, j   : Integer;
      L      : Double;
      P1, P2, oldP :TMyPoint;

      deT, OlddT :real;
      isCrack, notFirst: boolean;

  function Col(I:integer):Cardinal;
  var Value, ColI, ColK : Double; N:Integer;
  begin
    Result := TrackColor;

    if RouteNum = -2 then
      exit
    else

    if RouteNum = -3 then
    begin
      /// Color Scheme MODE
      if TrackColorSch.CSMarkCount = 0 then
        exit;

      Result := $FF000000 + RGB(0,0,0);
      case TrackColorSch.Kind of
          0: Value := Track[i-1].Altitude;
          1: Value := Track[i-1].AltR;
          2: Value := Track[i-1].AltL;
          3: Value := Track[i-1].H;
          4: Value := Track[i-1].HGeo;
          5: Value := Track[i-1].Speed;
          6: Value := Track[i-1].SatN;
          7: Value := Track[i-1].PDOP;
          8: Value := Track[i-1].RouteDist;
      end;

      for N := 1 to TrackColorSch.CSMarkCount - 1 do
      begin
         if (Value >= TrackColorSch.CSMarks[N-1].Mark) and
            (Value <= TrackColorSch.CSMarks[N].Mark) then
         begin
           if TrackColorSch.isSmooth = false then
             Result :=  $FF000000 +  RGB(TrackColorSch.CSMarks[N-1].B,
                              TrackColorSch.CSMarks[N-1].G,
                              TrackColorSch.CSMarks[N-1].R
                              )
           else
           try
             ColK := (Value - TrackColorSch.CSMarks[N-1].Mark) /
                     (TrackColorSch.CSMarks[N].Mark - TrackColorSch.CSMarks[N-1].Mark);
             Result :=   $FF000000 + RGB(
                       trunc(TrackColorSch.CSMarks[N-1].B + ColK*(TrackColorSch.CSMarks[N].B - TrackColorSch.CSMarks[N-1].B) ),
                       trunc(TrackColorSch.CSMarks[N-1].G + ColK*(TrackColorSch.CSMarks[N].G - TrackColorSch.CSMarks[N-1].G) ),
                       //trunc(TrackColorSch.CSMarks[N-1].B + ColK*(TrackColorSch.CSMarks[N].B - TrackColorSch.CSMarks[N-1].B) )
                       trunc(TrackColorSch.CSMarks[N-1].R + ColK*(TrackColorSch.CSMarks[N].R - TrackColorSch.CSMarks[N-1].R) )
                       );
           except
              Result :=  $FF000000 + RGB(TrackColorSch.CSMarks[N-1].B,
                              TrackColorSch.CSMarks[N-1].G,
                              TrackColorSch.CSMarks[N-1].R
                              );
           end;

           break;
         end;
      end;

      N := TrackColorSch.CSMarkCount - 1;
         if (Value > TrackColorSch.CSMarks[N].Mark) then
            Result :=  $FF000000 +  RGB(TrackColorSch.CSMarks[N].B,
                              TrackColorSch.CSMarks[N].G,
                              TrackColorSch.CSMarks[N].R
                              );


      if TrackColorSch.Kind = 8 then
        if Track[i-1].RouteN < 0 then
           Result := InactiveTrack;
                                 
    end

    else
    begin
      /// Route-Track MODE
      if (Track[i-1].RouteN <> -1) or (Track[i].RouteN <> -1) then
      begin
        Result := TrackColor;

        if RouteNum > -1 then
          if not((Track[i-1].RouteN = RouteNum)or (Track[i].RouteN = RouteNum)) then
            Result := TrackColor - $D0000000;
      end
        else
           result := InactiveTrack;

    end;
  end;


  procedure DrawTrackArrows;
  var i,j : integer;
     L, Ang : Double;
     P1, P2 : TMyPoint;
     needpt, onscreen : boolean;
      MinL, MinLineL : real;
  begin
     try    
       L := _Scale/Scale;
       MinL := 350 * L;
       MinLineL := 350 * L;
     except
       MinL := 350;
       MinLineL := 350;
     end;

    if Length(Track) <= 1 then
      exit;

    L := 0;
    for I := 1 to Length(Track)-1 do
    BEGIN
        P1 := MapToScreen(Track[i-1].X, Track[i-1].Y);
        P2 := MapToScreen(Track[i].X, Track[i].Y);


        Ang := arctan2(Track[i].X - Track[i-1].X,
                       Track[i].Y - Track[i-1].Y);

        OnScreen :=  (not( (P1.x < 0) and (P2.x < 0) ))  and
                     (not( (P1.x > DispSize.X) and (P2.x > DispSize.X))) and
                     (not( (P1.y < 0) and (P2.y < 0))) and
                     (not( (P1.y > DispSize.y) and (P2.y > DispSize.y))) and
                     (not( (abs(P1.y-P2.y) < 1) and (abs(P1.x-P2.x) < 1) ));

        L := L + abs(P1.y-P2.y) + abs(P1.x-P2.x);
        needpt := L > MinL;

        if needpt or ((I = 1) and (OnScreen)) then
        begin
           AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
           AsphCanvas.TexMap(pRotate4c(Point2(P1.x,P1.y),Point2(16, 16), Ang+fi),cColor4(Col(I+1)));
        end;

        if (I = Length(Track)-1) and (OnScreen)  then
        begin
           AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
           AsphCanvas.TexMap(pRotate4c(Point2(P2.x,P2.y),Point2(16, 16), Ang+fi),cColor4(Col(i)));
        end;

        if (L > MinLineL) and OnScreen then
        begin
          CutLineByFrame(P1.x, P1.y, P2.x, P2.y);
          if abs(P1.y-P2.y) + abs(P1.x-P2.x) > MinL then
          begin
             AsphCanvas.UseImagePx(AsphImages.Image['arrow1.image'], pxBounds4(0, 0, 32, 32));
             AsphCanvas.TexMap(pRotate4c(Point2((P2.x + P1.x)/2,(P1.y + P2.y)/2),Point2(16, 16), Ang+fi),cColor4(Col(I+1)));
          end;
        end;

        if needpt then
          L := 0;
    END;
  end;

var skippy :boolean;
begin

    if (Length(Track) = 0) then
        exit ;

    Track[0].Visible := false;

    oldP.x := 0;
    oldP.y := 0;
    OlddT := 0;

    for i := 1 to Length(Track) - 1 do
    try
        Track[i].Visible := false;

        P1 := MapToScreen(Track[i-1].X, Track[i-1].Y);
        P2 := MapToScreen(Track[i].X, Track[i].Y);

        if I = 1 then
           oldP := P1;
        skippy := false;
        if (abs(P2.x - OldP.x) < OptimizeStep) and
           (abs(P2.y - OldP.y) < OptimizeStep) {and
           (Track[i-1].RouteN = Track[i].RouteN)} then
        begin
          skippy := true;
          //Track[i].Visible := false;
          //continue
        end
         else
         begin
           P1 := oldP;
           oldP := P2;

           if (P2.x > 0) and (P2.x < DispSize.X) then
              if (P2.y > 0) and (P2.y < DispSize.Y) then
                 Track[i].Visible := true;
         end;

        isCrack := false;
        case DrawCracks of
          false:
            begin
               if Track[i].Visible then
                 FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, Col(I));
            end;
          true:
            begin
              deT := MilliSecondsBetween(Track[i].T,Track[i-1].T);
              if (abs(deT) > olddT*2) and (I > 1) then
                Begin
                   MyLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, true, Smooth, Col(I));

                   if Track[i].Visible then
                   begin
                     CrackDot(P1.x, P1.y, Col(I), false);
                     CrackDot(P2.x, P2.y, Col(I), false);
                   end;

                   isCrack := True;
                End
                Else
                begin

                  //if (Track[i].Visible) or (Track[i-1].Visible) then
                  if not skippy then                  
                    FatLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, 1, false, Smooth, col(I));
                end;
              if det<>0 then
                olddT := abs(deT);
            end;
        end;

        if TrackHasComments then
          if Track[i].Comment<> '' then
          Begin
             CrackDot(P2.x, P2.y,  Col(I), false);
          End;

        if DrawPoints then
          if not isCrack then
          Begin
             CrackDot(P1.x, P1.y,  Col(I), false);
             if i = Length(Track) - 1 then
                CrackDot(P2.x, P2.y, Col(I), false);
          End;

    except
      //showmessage(IntToStr(I)+' '+IntToStr(Length(Track) - 1));
    end;

    OlddT := 0;
    if Track = MainTrack then

       for I := 1 to Length(ReductedMainTrack) - 1 do
        //  if Track[i].Visible = true then
                 Begin
                  // P1 := MapToScreen(Track[i].X, Track[i].Y);

                   P1 := MapToScreen(ReductedMainTrack[i-1].X, ReductedMainTrack[i-1].Y);
                   P2 := MapToScreen(ReductedMainTrack[i].X, ReductedMainTrack[i].Y);

                   if I=1 then
                     OldP := P1;

                   if (abs(P2.x - OldP.x) < OptimizeStep) and (abs(P2.y - OldP.y) < OptimizeStep) then
                       continue;

                   if DrawPoints then
                     if abs(P1.x-P2.x)+abs(P1.y-P2.y) > 2 then
                         CrackDot(P2.x+ RedTrack[I].dX/Scale, P2.y+ RedTrack[I].dy/Scale,
                              RedTrackColor, true);

                    isCrack := false;
        case DrawCracks of
          false:
             MyLine(AsphCanvas, OldP.x, OldP.y, P2.x,
                           P2.y, False, Smooth,  RedTrackColor);
          true:
            begin
              deT := MilliSecondsBetween(ReductedMainTrack[i].T, ReductedMainTrack[i-1].T);
              if deT > olddT*3 then
                Begin
                   MyLine(AsphCanvas, P1.x, P1.y, P2.x, P2.y, true, Smooth, RedTrackColor);
                   isCrack := True;
                End
                Else
                     MyLine(AsphCanvas, OldP.x, OldP.y, P2.x,
                           P2.y, False, Smooth,  RedTrackColor);


            end;
        end;

                    olddT := deT;

                    OldP := P2;
                 End;
  if TrackArrowsEnabled then
    DrawTrackArrows
end;


function TrackMeanBL(Track:TTrack):TLatLong;
var Cmin, Cmax, Cmean: TLatLong;
    I, J : Integer;
begin
  Result.lat  := 0;
  Result.long := -360;

  if Length(Track) < 1 then
    exit
     else
     Begin
       Cmin.lat := Track[0].B;
       Cmin.long:= Track[0].L;
       Cmax.lat := Track[0].B;
       Cmax.long:= Track[0].L;
     End;

  //// Find min-max bounds
  for I := 0 to Length(Track) - 1 do
  begin
     if Track[I].B < Cmin.lat then
        Cmin.lat  := Track[I].B;

     if Track[I].L < Cmin.long then
        Cmin.long := Track[I].L;

     if Track[I].B > Cmax.lat then
        Cmax.lat  := Track[I].B;

     if Track[I].L > Cmax.long then
        Cmax.long := Track[I].L;
  end;

   /// Compute mean B, L        ! (�� �����, ������ ����� �� �������)
  Cmean.lat  := (Cmin.lat  + Cmax.lat ) /2;
  Cmean.long := (Cmin.long + Cmax.long) /2;
end;

function TrackMeanUTMZone(Track:TTrack):Integer;
var Cmean: TLatLong;

const
   Linit = 180;
   ZoneW = 6;
begin
  Result := -1;

  Cmean := TrackMeanBL(Track);

  if (Cmean.Lat = 0) and (Cmean.Long = -360) then
      exit;

  /// LOL GetZone
  Result := trunc((Cmean.Long + Linit + ZoneW)/ZoneW);
end;

procedure GetRouteDist(Track:TTrack; TrackI:Integer);
var I:integer;
   RP:TRoutePosAndDist;
begin
  try
    if (Track[TrackI].RouteDist=0)and(Track[TrackI].RouteProgress=0) then
    begin
      RP := PosAndDistToRoute(Track[Tracki].x,  Track[Tracki].y, Track[Tracki].RouteN);
      Track[TrackI].RouteProgress:= Round(RP.Pos*100);
      Track[TrackI].RouteDist := RP.Dist;
    end;
  except;
  end;
end;

function GetDateTime(Str:String; Method: byte):TDateTime;
var
   DTI     :Array [0..6] of Integer;  /// Variable for DateTime Decoding
   D       :Double;                   /// Seconds.milliseconds
   J, K    :Integer;
   SubStr  :String;
begin

  case Method of
    1:
    begin
      for K := 0 to 4 do
         DTI[K] := StrToInt(GetCols(str, K, 1, ' ', false));

      D := StrToFloat(GetCols(str, K, 1, ' ', true));
    end;

    2:
    begin
       substr := GetCols(Str, 0, 1, ' ', false);

       DTI[2] := StrToInt(Copy(SubStr, length(Substr)-1, 2));
       DTI[1] := StrToInt(Copy(SubStr, length(Substr)-3, 2));
       DTI[0] := StrToInt(Copy(SubStr, 1, length(Substr)-4));

       substr := GetCols(Str, 1, 1, ' ', false);

       DTI[3] := StrToInt(Copy(SubStr, 1, 2));
       DTI[4] := StrToInt(Copy(SubStr, 3, 2));
       D := StrToFloat2(Copy(SubStr, 5, length(SubStr)-4));

    end;

  end;

  DTI[5] := Trunc(D);
  DTI[6] := Trunc((D-DTI[5])*1000);

  if DTI[0] < 1900 then
  Begin
     if DTI[0] < 80 then
       DTI[0] := 2000 + DTI[0]
       else
         DTI[0] := 1900 + DTI[0];
  End;

  Result := EncodeDateTime(DTI[0], DTI[1], DTI[2], DTI[3], DTI[4], DTI[5], DTI[6]);
end;

procedure AddRoutePointsToTrack(Track: TTrack; R:TRoute; sT:TDateTime);
var I, J: Integer;
    BL: TLatLong;
begin
  J := Length(Track);
  SetLength(Track, J + Length(R.WPT));

  for I := 0 to Length(R.WPT) - 1 do
  with Track[I+J-1] do
  begin
    x := R.WPT[I].x;
    y := R.WPT[I].y;
    T := sT;
    BL := MapToBL(x,y);
    B := BL.lat;
    L := BL.long;
    CS := WGS;
  end;


end;

procedure ReduceTrackPoints(var Track: TTrack; RMethod : Byte; C1, C2 :Double);
var I, j, MTC:Integer;
    MyTrack :TTrack;
    OldT, ox, oy, L: Double;
begin
  MTC := 0;

  case RMethod of
    0: begin
       j := trunc(C1);
       if j <= 1 then
          exit;

       SetLength(MyTrack, (Length(Track) div j));

       for I := 0 to Length(MyTrack) - 1 do
         if Length(Track) > i*j then
         begin
           Inc(MTC);
           MyTrack[I] := Track[i*j];
         end;

    end;
    1: begin
       SetLength(MyTrack, Length(Track));

       for I := 0 to Length(Track) - 1 do
       begin
           if I = 0 then
           begin
             OldT := Track[I].T;
             continue;
           end;

           if Track[I].T - OldT >= C1/86400 - 0.000001 then
           begin
             OldT := Track[I].T;
             Inc(MTC);
             MyTrack[MTC-1] := Track[i];
           end;
       end;
    end;
    2: begin
       SetLength(MyTrack, Length(Track));

       for I := 0 to Length(Track) - 1 do
       begin
           if I = 0 then
           begin
             OldT := Track[I].T;
             ox := Track[I].x;
             oy := Track[I].y;
             continue;
           end;

           L := sqrt(sqr(Track[I].x - ox) + sqr(Track[I].y - oy));
           if L >= C1 then
           begin
             ox := Track[I].x;
             oy := Track[I].y;
             Inc(MTC);
             MyTrack[MTC-1] := Track[i];
           end;
       end;
    end;
    3: begin
       {}
    end;
  end;

  SetLength(MyTrack, MTC);
  SetLength(Track,   MTC);
  Track := MyTrack;
end;


function RouteSpecialStepBreak(RouteN: Integer; Step: Double):TRoute;
var I, J :Integer;
    R    :TRoute;
    T    :TTrack;
    c    :Double;
    XY   :TMyPoint;
    P    :TPosAndDist;
begin
   Route[RouteN] := RouteStepBreak( RouteN, Step);
   RoutesToGeo;

   R := Route[RouteN];

   J := Length(R.GWPT);
   SetLength(T, J + 1);
   for I := 0 to J - 1 do
   begin
     P := GetPosAndDist(R.Gx1, R.Gy1, R.Gx2, R.Gy2, R.GWPT[I].x, R.GWPT[I].y);

     T[I].B := P.x;     T[I].L := P.y;

     XY := BLToMap(T[I].B, T[I].L);

     T[I].x := XY.x;     T[I].y := XY.y;

     ///AddMarker('TEST'+intToStr(I), R.GWPT[I].x, R.GWPT[I].y);
   end;


   Result := RouteToTrack(R, T, 1, True, R.Name);
end;

function RouteToTrack(R :TRoute; T:TTrack; RMethod :Byte; InBorders:Boolean; Name:String):TRoute;

var I, J, N, Imin, NewI: Integer;
    PD, PD2, MinPD     :TPosAndDist;
    X1, X2, Y1, Y2     :Double;
    NewX, NewY         :Double;
    c, Sc, cMin        :Double;                

begin
   //Result := R;
   Result.Name  := Name;
   Result.Geo   := false;
   SetLength(Result.WPT, Length(R.WPT));
   SetLength(Result.GWPT, Length(R.GWPT));
   Result.Status := 0;
   Result.Fixed := False;

   SpecialI := 0;

   if Length(R.WPT) <= 1 then
     exit;

   if T = nil then
     exit;

   if Length(T) <= 1 then
     exit;

   NewI := 0;
   For I := 0 To Length(R.WPT) - 1 Do
   Begin
     /// 1) ���� X1..Y2 �������, �� ������� ������������

     J := Length(R.WPT) - 1;
     case RMethod of
        1: begin
          X1 := R.WPT[0].x;
          Y1 := R.WPT[0].y;
          X2 := R.WPT[j].x;
          Y2 := R.WPT[j].y;
          PD := GetPosAndDist(X1, Y1, X2, Y2, R.WPT[i].x, R.WPT[i].y);
          Sc := PD.Pos;
        end;

        2: begin
          if I = 0 then
          begin
            X1 := R.WPT[i].x;
            Y1 := R.WPT[i].y;
            X2 := R.WPT[i+1].x;
            Y2 := R.WPT[i+1].y;
            Sc := 0;
          end
            else
            if I = J then
            begin
              X1 := R.WPT[i-1].x;
              Y1 := R.WPT[i-1].y;
              X2 := R.WPT[i].x;
              Y2 := R.WPT[i].y;
              Sc := 1;
            end
              else
              begin
                  X1 := R.WPT[i-1].x;
                  Y1 := R.WPT[i-1].y;
                  X2 := R.WPT[i+1].x;
                  Y2 := R.WPT[i+1].y;
                  PD := GetPosAndDist(X1, Y1, X2, Y2, R.WPT[i].x, R.WPT[i].y);
                  Sc := PD.Pos;
              end;
        end;
     end; {END of case}


     /// 2) ����� ������� ���������� � ��������� ���������

     J := Length(T) - 1;  Imin := -1;
     for N := 0 to J-1 do
     begin
        PD :=   GetPosAndDist(X1, Y1, X2, Y2,
                 T[N].x, T[N].y);
        PD2 :=  GetPosAndDist(X1, Y1, X2, Y2,
                 T[N+1].x, T[N+1].y);

        if ( ( (PD.Pos - Sc <= 0) and (PD2.Pos - Sc >= 0) ) or
             ( (PD.Pos - Sc >= 0) and (PD2.Pos - Sc <= 0) ) )
             and (PD.Pos <> PD2.Pos) then
        begin
          Imin := N;

          // cMin := abs(PD.Pos - Sc);
          //MinPD := PD;

          Inc(NewI);

          c := (Sc - PD.Pos)/(PD2.Pos - PD.Pos);

          Result.WPT[NewI-1].x := T[N].x + c*(T[N+1].x - T[N].x);
          Result.WPT[NewI-1].y := T[N].y + c*(T[N+1].y - T[N].y);

          break;
        end;

     end;

     if Imin = -1 then
     if not inBorders then
     begin
       PD :=   GetPosAndDist(X1, Y1, X2, Y2,
                 T[0].x, T[0].y);
       PD2 :=  GetPosAndDist(X1, Y1, X2, Y2,
                 T[j].x, T[j].y);

       if abs(PD.Pos-Sc) > abs(PD2.Pos-Sc) then
         N := J-1
       else
         N := 0;

       PD :=   GetPosAndDist(X1, Y1, X2, Y2,
                 T[Imin].x, T[Imin].y);
       PD2 :=  GetPosAndDist(X1, Y1, X2, Y2,
                 T[Imin+1].x, T[Imin+1].y);

       c := (Sc - PD.Pos)/(PD2.Pos - PD.Pos);

       Result.WPT[NewI-1].x := T[Imin].x + c*(T[Imin+1].x - T[Imin].x);
       Result.WPT[NewI-1].y := T[Imin].y + c*(T[Imin+1].y - T[Imin].y);
     end
     else
     begin
       if NewI = 0 then
         Inc(SpecialI);
     end;


     

     /// 2a) ����� ����� 1
    {
   
     J := Length(T) - 1;
     for N := 0 to J do
     begin
        PD := GetPosAndDist(X1, Y1, X2, Y2, T[N].x, T[N].y);

        if (abs(PD.Pos - Sc) < cMin) or (N = 0)  then
        begin
          cMin := abs(PD.Pos - Sc);
          Imin := N;
          MinPD := PD;
        end;
     end;
     N := Imin;

     X1 := T[N].x;
     Y1 := T[N].y;

     /// 2�) ����� ����� 2
     if N = J then
     begin
       X2 := T[N-1].x;
       Y2 := T[N-1].y;
       if not inBorders then
       begin
             PD := GetPosAndDist(X1, Y1, X2, Y2, R.WPT[i].x, R.WPT[i].y);
             c  := PD.Pos;
       end
         else c := 1;
     end
      else
      if N = 0 then
      begin
         X2 := T[N+1].x;
         Y2 := T[N+1].y;
         if not inBorders then
         begin
             PD := GetPosAndDist(X1, Y1, X2, Y2, R.WPT[i].x, R.WPT[i].y);
             c  := PD.Pos;
         end
          else c := 0;
      end
        else
        BEGIN
          X2 := T[N-1].x;
          Y2 := T[N-1].y;
          PD := GetPosAndDist(X1, Y1, X2, Y2, R.WPT[i].x, R.WPT[i].y);
          c  := PD.Pos;
          if (c < 0) or (c > 1) then
          begin
            X2 := T[N+1].x;
            Y2 := T[N+1].y;
            PD := GetPosAndDist(X1, Y1, X2, Y2, R.WPT[i].x, R.WPT[i].y);
            c  := PD.Pos;
            if (c < 0) or (c > 1) then
            begin
              X2 := X1;
              Y2 := Y1;
              c := 0;
            end;
          end;

        END;

     Result.WPT[I].x := X1 + c*(X2 - X1);
     Result.WPT[I].y := Y1 + c*(Y2 - Y1);
                    }
   End;  {end of For I ...}
   SetLength(Result.WPT, NewI);
   SetLength(Result.GWPT, NewI);
end;

function SearchRinEvents(FileName:String):String;

  procedure PrepareString(var str:string; sep: string);
  var I : integer;
  begin
   //  if (Sep = #$9) or (Sep = ' ') then
     // exit;

     for I :=  1 To Length(Str) Do
       if Str[I] <> sep then
          break;
     Delete(Str,1,I-1);
  //   for I := Length(Str)  DownTo 2 Do
 //      if (Str[I-1] = Sep) and (Str[I] = Sep) then
  //       Insert(' ', Str, I);
  end;

var I, I2, ls, J, Ppos : Integer;
    S: TStringList;
    RINversion, ANTH: real;
    str1, str2: string;
    T, TS, Te, TF, TCE :TDateTime;     /// TS - start; TE - End; TF - FirstObs; TCE - CurrentEpoch

 const
      ComCount = 19;                                //// COMMANDS LIST COUNT
      Coms : array [1..ComCount] of String =        //// COMMANDS
         ( 'RINEX VERSION / TYPE',
           'PGM / RUN BY / DATE',
           'OBSERVER / AGENCY',
           'MARKER NAME',
           'MARKER NUMBER',
           'REC # / TYPE / VERS',
           'ANT # / TYPE',
           'APPROX POSITION',
           'ANTENNA: DELTA H/E/N',
           'WAVELENGTH FACT L1/2',
           '# / TYPES OF OBSERV',
           'INTERVAL',
           'LEAP SECONDS',
           'RCV CLOCK OFFS APPL',
           'TIME OF FIRST OBS',
           'TIME OF LAST OBS',
           'PRN / # OF OBS',
           'COMMENT',
           'END OF HEADER' );
begin
  SetLength(RinMarkers, 0);
  Result := 'No data detected';

  S := TStringList.Create;
  Ts := 0;  Te := 0;   I2 := 0; AntH := 0;

  

  try
    S.LoadFromFile(FileName);

    if S.Count = 0 then
    begin
       S.Free;
       exit;
    end;

    //// Progressbar form

    FLoadGPS.Show;
    FLoadGPS.MapLoad.Visible := false;
    FLoadGPS.Label2.Hide;
    FLoadGPS.Label1.Hide;
    FLoadGPS.LCount.Caption := '';
    FLoadGPS.Label3.Show;
    FLoadGPS.Repaint;
    FloadGPS.ProgressBar1.Position := 0;

    /// Header
    for I := 0 to S.Count - 1 do
    begin
      str1 := Copy (S[I], 1, 60);                    //// Header's Info (1 - 60)
      str2 := Copy (S[I], 61, length(S[I]) - 60);    //// Header's markers

      PPos := round(100*I/(S.Count-1));
      if FloadGPS.ProgressBar1.Position <> PPos then
         FloadGPS.ProgressBar1.Position := PPos;

      FOR J := 1 to ComCount DO
           IF Pos(Coms[J],AnsiUpperCase(str2)) <> 0 THEN
           BEGIN
             Case J of
               1:  {'RINEX VERSION / TYPE'}
               begin
                 PrepareString(str1, ' ');
                 RinVersion := StrToFloat2(GetCols(copy(str1,1,20), 0, 1, ' ', false));
                 Result  := 'RINEX ' + GetCols(copy(str1,1,20), 0, 1, ' ', false);
               end;

               9:  {'ANTENNA: DELTA H/E/N'}
               begin
                 AntH := StrToFloat2(GetCols(str1, 0, 1, ' ', false));
               end;

               13: {'LEAP SECONDS'}
               begin
                  Ls := Trunc(StrToFloat2(str1));
               end;

               15: {'TIME OF FIRST OBS'}
                 Ts := GetDateTime(Str1,1);

               16: {'TIME OF LAST OBS'}
                 Te  := GetDateTime(Str1,1);

               19: {'END OF HEADER'}
               begin
                 I2 := I;
                 Break;
               end;
             End;
           END;
    end;

    if (Ts<>0) then
       Result  :=  Result + ' // [' + DateTimeToStr(Ts)+']';

    if (Ts<>0)and (Te<>0) then
       Result  :=  Result + ' - ['+  DateTimeToStr(Te)+']';

    /// Body
    if I2 <> 0 then
    begin

/////////////////////////////////////////////////////////////// RIN 2
      if (RinVersion >= 2) then
      BEGIN

        for I := I2 to S.Count - 1 do
        begin

          PPos := round(100*I/(S.Count-1));
          if FloadGPS.ProgressBar1.Position <> PPos then
            FloadGPS.ProgressBar1.Position := PPos;


          str1 := s[I];
          if Length(Str1) < 2 then
             continue;
             //str1 := str1 + '           ';

          if ((RinVersion < 3) and ((str1[1]=' ')and(str1[2]<>' ')))
             or ((RinVersion >= 3) and (str1[1]='>'))  then
          Begin
           if RinVersion >= 3 then
              str1 := Copy(S[I], 2, length(S[I])-1);

           T :=  GetDateTime(str1, 1);
           if TF = 0 then
              TF := T;

           if  T<>0 then
              TCE := T;

           TCE := GetDateTime(str1, 1);

           if Length(Str1)< 30 then
              continue;

           if ((RinVersion < 3) and (Copy(Str1,29,1) = '3')) or
              ((RinVersion >= 3) and (Copy(Str1,31,1) = '3'))then
           Begin
             SetLength(RinMarkers, Length(RinMarkers)+1);
             RinMarkers[Length(RinMarkers)-1].T1 := GetDateTime(str1, 1);
             RinMarkers[Length(RinMarkers)-1].T2 := 0;
             RinMarkers[Length(RinMarkers)-1].AntH := AntH;
           End;

           if ((RinVersion < 3) and (Copy(Str1,29,1) = '2')) or
              ((RinVersion >= 3) and (Copy(Str1,29,1) = '2'))then
           Begin
             if Length(RinMarkers) = 0 then
             Begin
                SetLength(RinMarkers, Length(RinMarkers)+1);
                RinMarkers[Length(RinMarkers)-1].T1 := TF;
                RinMarkers[Length(RinMarkers)-1].T2 := GetDateTime(str1, 1);
             End
               Else
                 RinMarkers[Length(RinMarkers)-1].T2 := GetDateTime(str1, 1);
           End;

          End;
          if Length(RinMarkers) > 0 then

           if RinMarkers[Length(RinMarkers)-1].T2 = 0 then
           Begin
             if Pos('MARKER NAME', str1) <> 0  then
             begin

                for J := 60 Downto  1 do
                  if str1[J]<>' ' then
                    break;
                str2 := copy(str1,1,j);
                RinMarkers[Length(RinMarkers)-1].MarkerName := Str2;
             end;

             if RinMarkers[Length(RinMarkers)-1].AntH = AntH then
             if Pos('ANTENNA: DELTA H/E/N', str1) <> 0  then
             begin

                str2 := copy(str1,1,j);
                RinMarkers[Length(RinMarkers)-1].AntH := StrToFloat2(GetCols(str1, 0, 1, ' ', false));
             end;

             if I = S.Count - 1 then
              RinMarkers[Length(RinMarkers)-1].T2 := TCE;
           End;

        end;
        Result  :=  Result + #13 + inf[93] + ' ' + IntToStr(Length(RinMarkers)) ;
      END

    end
     else
       Result  :=  Result + #13 + inf[94];

  except
    Result  :=  inf[95];
  end;

  S.Free;
  FLoadGPS.Close;
end;

end.
