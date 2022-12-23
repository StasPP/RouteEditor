unit UStatBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, TrackFunctions, GeoClasses,
  BasicMapObjects, MapEditor, LangLoader, StrUtils, TabFunctions, MapFunctions,
  GeoString, GeoFunctions, PointClasses, OleCtrls, SHDocVw, ActiveX, MSHTML, Math;

type

  TUDF_Markers = record
     I: integer;  Dist :Double;
     I_nearest: integer;  Dist_nearest :Double;
  end;

  TUDF_Knots = record
     KnotI, PicketI: integer;
     Dist :Double;

     KnotI_nearest, PicketI_nearest: integer;
     Dist_nearest :Double;
  end;

  TUDFCompare = record
    N : Integer;               /// номер в списке маркеров
    uMarkers : TUDF_Markers;
    uKnots : TUDF_Knots;
  end;

  TStatBox = class(TForm)
    iReport: TRichEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    iArea: TCheckBox;
    iRoutes: TCheckBox;
    iSlips: TCheckBox;
    iTrack: TCheckBox;
    iCompare: TCheckBox;
    CompareTrk: TSpeedButton;
    iLoopsM: TRadioButton;
    SaveDialog1: TSaveDialog;
    iTrackRoutes: TCheckBox;
    iCompUDF: TCheckBox;
    iTables: TCheckBox;
    Estim: TSpeedButton;
    iLC: TCheckBox;
    iLK: TCheckBox;
    iLP: TCheckBox;
    Csys: TStaticText;
    iAccuracy: TCheckBox;
    iFull: TCheckBox;
    iLoopsP: TRadioButton;
    iRoutesL: TCheckBox;
    WebC: TWebBrowser;
    Memo: TMemo;
    procedure FormShow(Sender: TObject);
    procedure iAreaClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CompareTrkClick(Sender: TObject);
    procedure CompareStat;
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure EstimClick(Sender: TObject);
    procedure CsysMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure CsysClick(Sender: TObject);

    procedure GetUDFEstims(PB:TProgressBar);
    procedure iReportKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    StatDir: string;
    { Public declarations }
  end;

var
  StatBox: TStatBox;

  TrS: TTrackStat;
  isReady: Boolean;   

  FormatN :byte;

  commonPts: Integer;
  avg, stdev, max: Double; err:boolean;
  avgh, stdevh, maxh: Double;

  HasPart2 :Boolean = false;
  UDFCompare : array of TUDFCompare;
implementation

uses MapperFm;

{$R *.dfm}

procedure GetPrLPkt(S: string; var Ln, Pn, Pn2 :integer; var Pr:string);
var str, str2, str3: string;
    n, I, j : integer;
begin
  str := S;

   n := Pos('_ip', AnsiLowerCase(str));
   if n > 0 then
     str := Copy(S, 1, n-1);

   n := 0;
   while Pos ('_', str) > 0 do
   begin
      j := n;
      n := Pos ('_', str);
      str  := Copy(str, n+1, length(str)-n);
      str2 := Copy(S, j+1, n-1);
      if j > 0 then
        str3 := Copy(S, 1, j-1)
      else
        str3 := '';
   end;

   Pr := str3;
   Ln := round(StrToFloat2(str2));
   
   Pn2 := 0;
   n := Pos('-', str);
   if n > 0 then
   begin
      Pn := round(StrToFloat2(Copy(str, 1, n-1)));
      Pn2 := round(StrToFloat2(Copy(str, n+1, length(str)-n)));
   end
   else
     Pn := round(StrToFloat2(str));
end;

procedure AddHTMLTable(tableKind:byte);
 var csx, csy, csH :string;  P:TMyPoint;

  procedure BLToCS(B,L,H :double; CS:Integer);
  var cX, cY, cZ: Double;
  begin
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
            csH := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH := Format('%.3f',[cZ]);
          end;
       end;
  end;

  var
    Row, Col, IncCellWidth, CellMargin, ColCount : Integer;
    Kx : Extended;
    HeaderInt : string;
    dT, odT, a : double;   str, str2, str3, str4 :string;    found:boolean;
    I, j, k, n, i1, CurR :Integer;   SL:TStringList;

    CW: Array[0..15] of Integer;
 const  ColWidth  : Array [0..6] of Integer = (100, 152, 152, 77, 72, 72, 70);
        ColWidth2 : Array [0..6] of Integer = (55, 80, 95, 130, 130, 150, 150);
        ColWidth3 : Array [0..7] of Integer = (50, 80, 80, 115, 105, 105, 105,
                                                 105);
        ColWidth4 : Array [0..12] of Integer = (50, 90, 80, 120, 250, 120, 120,
                                                 120, 120, 120, 130, 130, 130);
begin
   Kx := 15;
   CellMargin := Round(Int(2 * Kx));
   StatBox.Memo.Lines.Add(' <table class="ReportTable' + IntToStr(tableKind)
                          + '" border="1" cellspacing="0" cellpadding="0">');
   StatBox.Memo.Lines.Add(' <thead>');
   StatBox.Memo.Lines.Add(' <tr>');

   IncCellWidth := 0;

   case tableKind of
     0: begin
       ColCount := 4;
       HeaderInt := inf[130];
     end;
     1: begin
       ColCount := 7;
       HeaderInt := inf[131];
     end;
     3: begin
       ColCount := 3;
       if RoutesMeanSize > 10000 then
           str := inf[41]
        else
           str := inf[40];
       HeaderInt := inf[222] + ',' + str;
     end;

     10, 20: begin
       ColCount := 6;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
          inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:    HeaderInt := inf[177];
         1:    HeaderInt := inf[178];
         else  HeaderInt := inf[179];
       end;
     end;
     11, 21: begin
       ColCount := 7;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:    HeaderInt := inf[180];
         1:    HeaderInt := inf[181];
         else  HeaderInt := inf[182];
       end;
     end;
     12, 22: begin
       ColCount := 7;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:    HeaderInt := inf[183];
         1:    HeaderInt := inf[184];
         else  HeaderInt := inf[185];
       end;
     end;
     15, 25, 16, 26: begin
       ColCount := 11;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:   HeaderInt := inf[186] + inf[189];
         1:   HeaderInt := inf[187] + inf[189];
         else HeaderInt := inf[188] + inf[189];
       end;
       if StatBox.iAccuracy.Checked then
          ColCount := ColCount + 2;
     end;
   end;

   for Col := 0 to ColCount-1 do begin
     if tableKind <> 0 then
     begin
       case TableKind of
         10, 20:  IncCellWidth := Round(Int( ColWidth2[Col] * Kx));
         11, 12, 21, 22:  IncCellWidth := Round(Int( ColWidth3[Col] * Kx));
         15, 25, 16, 26:  IncCellWidth := Round(Int( ColWidth4[Col] * Kx));
         else IncCellWidth := Round(Int( ColWidth[Col] * Kx));
       end;
     end
     else
     begin
        case Col of
          0: IncCellWidth := Round(Int( 40 * Kx));
          3: IncCellWidth := Round(Int( 120 * Kx));
          else IncCellWidth := Round(Int( ColWidth[Col] * Kx))
       end;
     end;

     Cw[Col] := IncCellWidth;
   end;

   /// заголовок
   for I := 0 to ColCount - 1 do
   begin
     StatBox.Memo.Lines.Add('<td style="width: '+ IntToStr(Cw[I])+
           'px;">' + GetCols(HeaderInt, I, 1, 1, false) +#$9+'</td>');
   end;

   StatBox.Memo.Lines.Add(' </thead>');
   StatBox.Memo.Lines.Add(' </tr>');
   StatBox.Memo.Lines.Add(' <tbody>');

   if tableKind = 0 then
   begin
     j := 0;
     for I := 1 to Length(MainTrack) - 2 do
     begin
        dT := MainTrack[i].T - MainTrack[i-1].T;

        if I > 1 then
          if dT > odT*2 then
          begin
            str := '-';
            if MainTrack[i-1].RouteN > -1 then
                 str := MainTrack[i-1].RouteName;

            inc(j);
            if str = '-' then 
            begin 
              str2 := '';
              str3 := ''
            end
            else 
              begin
                str2 := '<span style="color: #ff0000;">';
                str3 := '</span>'
              end;

            StatBox.Memo.Lines.Add('<td>'+ str2 + IntToStr(j) +#$9+str3+'</td>');
            StatBox.Memo.Lines.Add('<td>'+ str2 + MainTrack[i-1]._T +#$9+str3+'</td>');
            StatBox.Memo.Lines.Add('<td>'+ str2 + MainTrack[i]._T +#$9+str3+'</td>');
            StatBox.Memo.Lines.Add('<td>'+ str2 + str +#$9+str3+'</td></tr>');
        end;

        if dt <> 0 then
          odt := dt;
     end;
   end;



   if tableKind = 1 then
   begin
      CurR := -1;
      I1 := 0;   
      for I := 0 to Length(MainTrack) - 1 do
      begin
         avg := 0; stdev := 0; n := 0; max := 0;  err:=false;
         a := 0;
         if MainTrack[I].RouteN <> CurR then
         if CurR = -1 then
         begin
            CurR := MainTrack[I].RouteN;
            I1 := I;
         end
         else
           begin
             found := false;
             if MainTrack[I].RouteN <> CurR then
             if I < Length(MainTrack) - 10 then
             begin
               for j := I + 1 to I + 10 do
               if MainTrack[j].RouteN = CurR then
               begin
                 found := true;
                 break;
               end;
             end;

            if found then
              continue;


             n := (I-1) - I1;
             for j := I1 to I - 1 do
             begin

                if n <= 0 then
                  break;

                if MainTrack[j].RouteDist > 1E6 then
                begin
                  dec(n);
                  err := true;
                  continue;
                end;

                if n <= 0 then
                  break;

                avg := avg + MainTrack[j].RouteDist;
                if abs(MainTrack[j].RouteDist) > max then
                  max := abs(MainTrack[j].RouteDist);

                stdev := stdev + sqr(MainTrack[j].RouteDist);
              end;

              if n > 0 then
              begin
                str := '-';
                if MainTrack[i1].RouteN > -1 then
                  str := MainTrack[i1].RouteName;


                if not err then 
                begin 
                  str2 := '';
                  str3 := ''
                end
                else 
                begin
                  str2 := '<span style="color: #ff0000;">';
                  str3 := '</span>'
                end;  
             
                avg := avg/n;
                stdev := sqrt(stdev/n);

                str4 := '-';
                for k := 0 to RouteCount-1 do  
                  if AnsiUpperCase(Route[k].Name) = AnsiUpperCase(str) then
                  if Length(Route[k].WPT) = 2 then
                  begin
                    a := arcTan2(Route[k].WPT[1].x - Route[k].WPT[0].x,
                                 Route[k].WPT[1].y - Route[k].WPT[0].y );
                    if sqrt(sqr(Route[k].WPT[0].x -  MainTrack[i1].x)+sqr(Route[k].WPT[0].y -  MainTrack[i1].y )) > 
                       sqrt(sqr(Route[k].WPT[1].x -  MainTrack[i1].x)+sqr(Route[k].WPT[1].y -  MainTrack[i1].y )) 
                    then
                       a := a + pi;
                    if a < 0 then
                       a := 2*pi + a;
                    if a > 2*pi then
                       a := a - 2*pi;  
                                
                    str4 :=  Formatfloat('  0.0', a*180/pi);
                    break;
                  end;
                
                StatBox.Memo.Lines.Add('<td>'+ str2 + str +#$9+str3+'</td>');
                StatBox.Memo.Lines.Add('<td>'+ str2+ MainTrack[i1]._T            +#$9+str3+'</td>');
                StatBox.Memo.Lines.Add('<td>'+ str2+ MainTrack[i-1]._T           +#$9+str3+'</td>');                                                    
                StatBox.Memo.Lines.Add('<td>'+ str2+ str4  +#$9+str3+'</td>');
                StatBox.Memo.Lines.Add('<td>'+ str2+ Formatfloat('  0.00', Stdev)+#$9+str3+'</td>');
                StatBox.Memo.Lines.Add('<td>'+ str2+ Formatfloat('  0.00', Avg)  +#$9+str3+'</td>');
                StatBox.Memo.Lines.Add('<td>'+ str2+ Formatfloat('  0.00', Max)  +#$9+str3+'</td>');
                StatBox.Memo.Lines.Add('</tr>');
          end;
          CurR :=  MainTrack[I].RouteN;
        end;
      end;
   end;

   if tableKind = 3 then
   for I := 0 to RouteCount - 1 do
   begin

     if RoutesMeanSize > 10000 then
         str := Formatfloat('  0.000', RouteLenght(I)*0.001 )
       else
         str :=  Formatfloat('  0.0', RouteLenght(I) );

     StatBox.Memo.Lines.Add('<td>'+ Route[I].Name  +#$9+'</td>');
     StatBox.Memo.Lines.Add('<td>'+ IntToStr(Length(Route[I].WPT)-1) +#$9+'</td>');
     StatBox.Memo.Lines.Add('<td>'+ str+#$9+'</td></tr>');
     
   end;

   if tableKind = 10 then
     for I := 0 to KnotCount - 1 do
     begin
       str := KnotPoints[I].Name;      if str = '' then str := '&nbsp;';
       P := LatLongToPoint(MapToBL(KnotPoints[I].cx, KnotPoints[I].cy));
       BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

       StatBox.Memo.Lines.Add('<td>' + IntToStr(I+1) +#$9+'</td>');
       StatBox.Memo.Lines.Add('<td>' + str +#$9+'</td>');

       if StatBox.iFull.Checked then
       begin
         case KnotPoints[I].NameKind of
            0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
            2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
            3,4 : str := FormatFloat('000', KnotPoints[I].L);
         end;
         StatBox.Memo.Lines.Add('<td>' + str +#$9+'</td>');
       end
       else
         StatBox.Memo.Lines.Add('<td>' + 'L' + FormatFloat('000', KnotPoints[I].L) +#$9+'</td>');

       StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
       StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
       StatBox.Memo.Lines.Add('<td>'+'&nbsp;'+#$9+'</td></tr>'); // ѕримечание
       
       StatBox.Memo.Lines.Add('</tr>');
     end;  /// end talekind = 10

     if tableKind = 11 then
     for I := 0 to KnotCount - 1 do
     if KnotPoints[I].Shp <> 1 then
     for j := 1 to 4 do
     begin
       str := KnotPoints[I].Name;     if str = '' then str := '&nbsp;';
       P.x := KnotPoints[I].cx +
            Sin(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;
       P.y := KnotPoints[I].cy +
            Cos(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;
       P := LatLongToPoint(MapToBL(P.x, P.y));
       BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

       StatBox.Memo.Lines.Add('<td>' + IntToStr(I*4 + j+1)  +#$9+'</td>');
       StatBox.Memo.Lines.Add('<td>' + str +#$9+'</td>');
       StatBox.Memo.Lines.Add('<td>' + 'L' + FormatFloat('000', KnotPoints[I].L)  +#$9+'</td>');

       if StatBox.iFull.Checked then
       begin
         case KnotPoints[I].NameKind of
            0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
            2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
            3,4 : str := FormatFloat('000', KnotPoints[I].L);
         end;
         StatBox.Memo.Lines.Add('<td>' +  str + '_K' + IntToStr(j) +#$9+'</td>');
       end
       else
         StatBox.Memo.Lines.Add('<td>' + IntToStr(j) +#$9+'</td>');

       StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
       StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
       StatBox.Memo.Lines.Add('<td>'+'&nbsp;'+#$9+'</td></tr>'); // ѕримечание
    end;  /// end tablekind = 11

    I1 := 0;
    if tableKind = 12 then
    for I := 0 to KnotCount - 1 do
    begin
      GetKnotPickets(KnotPoints[I], false);

      for j := 1 to PktCount - 1 do
      begin
        Inc(I1);

        str := Pkt[j].Name;
        if StatBox.iFull.Checked = false then
        while Pos ('_', str) > 0 do
        begin
          n := Pos ('_', str);
          str := Copy(str, n+1, length(str)-n);
        end;

        P.x := KnotPoints[I].cx + Pkt[j].x;
        P.y := KnotPoints[I].cy + Pkt[j].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        StatBox.Memo.Lines.Add('<td>' + IntToStr(I1) +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + KnotPoints[I].Name +'&nbsp;'+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + 'L' + FormatFloat('000', KnotPoints[I].L) +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str +#$9+'</td>');

        StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
          StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
       StatBox.Memo.Lines.Add('<td>'+'&nbsp;'+#$9+'</td></tr>'); // ѕримечание
        
      end;
    end;  // end tablekind = 12
    

    if tableKind = 20 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin
        if Markers[I].MarkerKind = 1 then
        begin
          inc(I1);
          str := Markers[I].MarkerName;

          while Pos ('_', str) > 0 do
          begin
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, 1, n-1);
          end;
          
          if str2 = '' then str2 :='&nbsp;';
          
          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          StatBox.Memo.Lines.Add('<td>' + IntToStr(I1) +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str2 +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');

          StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
          StatBox.Memo.Lines.Add('<td>'+'&nbsp;'+#$9+'</td></tr>'); // ѕримечание
        end;
      end;

      SL := TStringList.Create;
      GetKnotMarkerList(SL, 0);
      if SL.Count > I1 then
      for I := 0 to SL.Count - 1 do     /// ADD Computed centers
      begin
         found := false;
         for j := 0 to Length(Markers) - 1 do
           if AnsiLowerCase(SL[I]) = AnsiLowerCase(Markers[j].MarkerName) then
           begin
             found := true;
             break;
           end;

          if not found then
          begin
            str := SL[I];
            if not GetMarkerKnotCenter(str, P.x, P.y) then
               continue;

            inc(I1);

            while Pos ('_', str) > 0 do
            begin
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(SL[I], 1, n-1);
            end;
            
            if str2 = '' then str2 :='&nbsp;';
            
            if StatBox.iFull.Checked then
               str := SL[I];

            P := LatLongToPoint(MapToBL(P.x, P.y));
            BLToCS(P.x, P.y, 0, MapFm.CoordSysN);       

            StatBox.Memo.Lines.Add('<strong><td>' + IntToStr(I1) +#$9+'</td>');
            StatBox.Memo.Lines.Add('<td>' + str2 +#$9+'</td>');
            StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');

            StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
            StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
            if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
              StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
            StatBox.Memo.Lines.Add('<td>'+inf[191]+#$9+'</td></strong></tr>'); // ѕримечание
          end;

      end;  /// ADD Computed centers: end
      SL.Destroy;
    End; /// tablekind = 20 end


    if tableKind = 21 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin

        if Markers[I].MarkerKind = 2 then
        begin
          inc(I1);
          str := Markers[I].MarkerName;

          n := 0;
          while Pos ('_', str) > 0 do
          begin
              j := n;
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, j+1, n-1);
              if j > 0 then
                str3 := Copy(Markers[I].MarkerName, 1, j-1)
              else
                str3 := '';
          end;

          if str3 = '' then str3 :='&nbsp;';

          if AnsiUpperCase(str2[1]) <> 'L' then
             str2 := 'L' + str2;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);


          StatBox.Memo.Lines.Add('<td>' + IntToStr(I1) +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str3 +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str2 +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');

          StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
          StatBox.Memo.Lines.Add('<td>'+'&nbsp;'+#$9+'</td></tr>'); // ѕримечание

        end;
      end;
    End; /// tablekind = 21 end

    if tableKind = 22 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin

        if Markers[I].MarkerKind = 3 then
        begin
          inc(I1);
          str := Markers[I].MarkerName;

          n := 0;
          while Pos ('_', str) > 0 do
          begin
              j := n;
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, j+1, n-1);
              if j > 0 then
                str3 := Copy(Markers[I].MarkerName, 1, j-1)
              else
                str3 := '';
          end;
          
          if str3 = '' then str3 :='&nbsp;';

          if AnsiUpperCase(str2[1]) <> 'L' then
             str2 := 'L' + str2;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          StatBox.Memo.Lines.Add('<td>' + IntToStr(I1) +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str3 +#$9+'</td>'); 
          StatBox.Memo.Lines.Add('<td>' + str2 +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');

          StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
          StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
          StatBox.Memo.Lines.Add('<td>'+'&nbsp;'+#$9+'</td></tr>'); // ѕримечание
        end;
      end;
   End; /// tablekind = 22 end 


   HasPart2 := false;
    if tableKind = 15 then
    for I := 0 to MarkersUDFCount - 1 do
    begin
     // GetPrLPkt(Markers[UDFCompare[I].N].MarkerName, j, I1, str3);
                                          //// здесь: I1 = номер пикета
    //  str2 := intToStr(j);

      found := (UDFCompare[I].uKnots.KnotI > -1) and        
               (UDFCompare[I].uKnots.KnotI < KnotCount);

      if found then
      begin
        GetKnotPickets(KnotPoints[UDFCompare[I].uKnots.KnotI], false);
        j := UDFCompare[I].uKnots.PicketI;
        if (j < PktCount) and (j >= 0) then
        begin

           str := Pkt[j].Name;
           if StatBox.iFull.Checked = false then
           while Pos ('_', str) > 0 do
           begin
              n := Pos ('_', str);
              str := Copy(str, n+1, length(str)-n);
           end;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           StatBox.Memo.Lines.Add('<td>' + IntToStr(I+1) +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + KnotPoints[UDFCompare[I].uKnots.KnotI].Name
                       + #$9+'</td>'); 
           StatBox.Memo.Lines.Add('<td>'+ 'L' +FormatFloat('000', KnotPoints[UDFCompare[I].uKnots.KnotI].L)
                       +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + Markers[UDFCompare[I].N].MarkerName +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
         
       

           P.x := KnotPoints[UDFCompare[I].uKnots.KnotI].cx
                  + Pkt[UDFCompare[I].uKnots.PicketI].x;
           P.y := KnotPoints[UDFCompare[I].uKnots.KnotI].cy
                  + Pkt[UDFCompare[I].uKnots.PicketI].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));
           BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

           StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');

           StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[UDFCompare[I].uKnots.Dist]) +#$9+'</td>');  
           
           if StatBox.iAccuracy.Checked then
           begin      
              StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</td>');
              StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</td>');
           end;

           StatBox.Memo.Lines.Add('</tr>');    
           
           if not HasPart2 then
             HasPart2 := (UDFCompare[I].uKnots.Dist - UDFCompare[I].uKnots.Dist_nearest) > 1;
        end
         else found := false;
      end;

      if not found then
      Begin
           HasPart2 := true;
            
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           str4 := '<span style="color: #ff0000;">';
           StatBox.Memo.Lines.Add('<td>' +str4+ IntToStr(I+1) +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ Markers[UDFCompare[I].N].MarkerName +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ csx +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csy +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csh +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
             
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           
           if StatBox.iAccuracy.Checked then
           begin      
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</span></td>');
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</span></td>');
           end;
              
           StatBox.Memo.Lines.Add('</tr>');   
      End;

    end;  /// tablekind = 15 end

   if tableKind = 16 then
    for I := 0 to MarkersUDFCount - 1 do
    if ((UDFCompare[I].uKnots.Dist - UDFCompare[I].uKnots.Dist_nearest) > 1) or
       (UDFCompare[I].uKnots.KnotI = -1)  then
    begin
    
      found := (UDFCompare[I].uKnots.KnotI_nearest > -1) and
               (UDFCompare[I].uKnots.KnotI_nearest < KnotCount);

      if found then
      begin
        GetKnotPickets(KnotPoints[UDFCompare[I].uKnots.KnotI_nearest], false);
        j := UDFCompare[I].uKnots.PicketI_nearest;
        if (j < PktCount) and (j >= 0) then
        begin

           str := Pkt[j].Name;
           if StatBox.iFull.Checked = false then
           while Pos ('_', str) > 0 do
           begin
              n := Pos ('_', str);
              str := Copy(str, n+1, length(str)-n);
           end;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

 
           StatBox.Memo.Lines.Add('<td>' + IntToStr(I+1) +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].Name
                       + #$9+'</td>'); 
           StatBox.Memo.Lines.Add('<td>'+ 'L' +FormatFloat('000', KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].L)
                       +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + Markers[UDFCompare[I].N].MarkerName +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');

           P.x := KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].cx
                  + Pkt[UDFCompare[I].uKnots.PicketI_nearest].x;
           P.y := KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].cy
                  + Pkt[UDFCompare[I].uKnots.PicketI_nearest].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));
           BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

           StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
              StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');    

           StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[UDFCompare[I].uKnots.Dist_nearest]) +#$9+'</td>');
           
           if StatBox.iAccuracy.Checked then
           begin
              StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</td>');
              StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</td>');
           end;
           StatBox.Memo.Lines.Add('</tr>');   
        end
         else found := false;
      end;

      if not found then
      Begin
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);
           str4 := '<span style="color: #ff0000;">';
           
           StatBox.Memo.Lines.Add('<td>' +str4+ IntToStr(I+1) +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ Markers[UDFCompare[I].N].MarkerName +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ csx +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csy +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csh +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
             
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');

           
           if StatBox.iAccuracy.Checked then
           begin
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</span></td>');
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</span></td>');
           end;
           StatBox.Memo.Lines.Add('</span></tr>');  
      End;

   end;  /// tablekind = 16 end



   if tableKind = 25 then
   for I := 0 to MarkersUDFCount - 1 do
   begin

      found := (UDFCompare[I].uMarkers.I > -1) and
               (UDFCompare[I].uMarkers.I < Length(Markers));

      if found then
      begin

        str := Markers[UDFCompare[I].uMarkers.I].MarkerName;
        n := 0;
        while Pos ('_', str) > 0 do
        begin
           j := n;
           n := Pos ('_', str);
           str  := Copy(str, n+1, length(str)-n);
           str2 := Copy(Markers[UDFCompare[I].uMarkers.I].MarkerName, j+1, n-1);
           if j > 0 then
             str3 := Copy(Markers[UDFCompare[I].uMarkers.I].MarkerName, 1, j-1)
           else
             str3 := '';
        end;

        if str3 = '' then str3 :='&nbsp;';
        
        if AnsiUpperCase(str2[1]) <> 'L' then
           str2 := 'L' + str2;

        if StatBox.iFull.Checked then
           str := Markers[UDFCompare[I].uMarkers.I].MarkerName;

        P.x := Markers[UDFCompare[I].N].x;
        P.y := Markers[UDFCompare[I].N].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));

        BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
        if Markers[UDFCompare[I].N].Hgeo <> 0 then
          csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

        StatBox.Memo.Lines.Add('<td>' + IntToStr(I+1) +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str3+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str2+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + Markers[UDFCompare[I].N].MarkerName +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');
      
        P.x := Markers[UDFCompare[I].uMarkers.I].x;
        P.y := Markers[UDFCompare[I].uMarkers.I].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
          StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>'); 

        StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[UDFCompare[I].uMarkers.Dist])  +#$9+'</td>'); 
            
        if StatBox.iAccuracy.Checked then
        begin
           StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</td>');
        end;

        StatBox.Memo.Lines.Add('</tr>'); 

        if not HasPart2 then
           HasPart2 := (UDFCompare[I].uMarkers.Dist - UDFCompare[I].uMarkers.Dist_nearest) > 1;
      end
      else
        found := false;

      if not found then
      Begin
           HasPart2 := true;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           str4 := '<span style="color: #ff0000;">';
           
           StatBox.Memo.Lines.Add('<td>' +str4+ IntToStr(I+1) +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ Markers[UDFCompare[I].N].MarkerName +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ csx +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csy +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csh +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
             
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           

           if StatBox.iAccuracy.Checked then
           begin
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</span></td>');
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</span></td>');
           end;
           StatBox.Memo.Lines.Add('</span></tr>'); 
      End;

    end;  /// tablekind = 25 end

    if tableKind = 26 then
    for I := 0 to MarkersUDFCount - 1 do
    if ((UDFCompare[I].uMarkers.Dist - UDFCompare[I].uMarkers.Dist_nearest) > 1) or
       (UDFCompare[I].uMarkers.I = -1)  then
    begin

      found := (UDFCompare[I].uMarkers.I_nearest > -1) and
               (UDFCompare[I].uMarkers.I_nearest < Length(Markers));

      if found then
      begin

        str := Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName;
        n := 0;
        while Pos ('_', str) > 0 do
        begin
           j := n;
           n := Pos ('_', str);
           str  := Copy(str, n+1, length(str)-n);
           str2 := Copy(Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName,
                  j+1, n-1);
           if j > 0 then
             str3 := Copy(Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName,
                  1, j-1)
           else
             str3 := '';
        end;

        if str3 = '' then str3 :='&nbsp;';

        if AnsiUpperCase(str2[1]) <> 'L' then
           str2 := 'L' + str2;

        if StatBox.iFull.Checked then
           str := Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName;

        P.x := Markers[UDFCompare[I].N].x;
        P.y := Markers[UDFCompare[I].N].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));

        BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
        if Markers[UDFCompare[I].N].Hgeo <> 0 then
          csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);


        StatBox.Memo.Lines.Add('<td>' + IntToStr(I+1) +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str3+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str2+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + str+#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + Markers[UDFCompare[I].N].MarkerName +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');

        P.x := Markers[UDFCompare[I].uMarkers.I_nearest].x;
        P.y := Markers[UDFCompare[I].uMarkers.I_nearest].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
           str2 := csx + #$9 + csy
        else
           str2 :=  csx + #$9 + csy + #$9 + csh;       {проектные}

        StatBox.Memo.Lines.Add('<td>' + csx +#$9+'</td>');
        StatBox.Memo.Lines.Add('<td>' + csy +#$9+'</td>');
        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
           StatBox.Memo.Lines.Add('<td>' + csh +#$9+'</td>');

        StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[UDFCompare[I].uMarkers.Dist_nearest]) +#$9+'</td>');
   
        if StatBox.iAccuracy.Checked then
        begin
           StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</td>');
           StatBox.Memo.Lines.Add('<td>' + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</td>');
        end;

        StatBox.Memo.Lines.Add('</tr>'); 
      end
      else
        found := false;

      if not found then
      Begin
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);


                      str4 := '<span style="color: #ff0000;">';
           
           StatBox.Memo.Lines.Add('<td>' +str4+ IntToStr(I+1) +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ Markers[UDFCompare[I].N].MarkerName +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ csx +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csy +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ csh +#$9+'</span></td>');

           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
             
           StatBox.Memo.Lines.Add('<td>' +str4+ '-' +#$9+'</span></td>');
           

           if StatBox.iAccuracy.Checked then
           begin
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add1]) +#$9+'</span></td>');
              StatBox.Memo.Lines.Add('<td>' +str4+ Format('%.3f',[Markers[UDFCompare[I].N].Add2]) +#$9+'</span></td>');
           end;
           StatBox.Memo.Lines.Add('</span></tr>'); 
      End;

    end;   // tablekind = 26 end

 

    
   StatBox.Memo.Lines.Add(' </tbody>');
   StatBox.Memo.Lines.Add(' </table>');
end;



procedure AddTable(tableKind:byte);

  var csx, csy, csH :string;  P:TMyPoint;

  procedure BLToCS(B,L,H :double; CS:Integer);
  var cX, cY, cZ: Double;
  begin
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
            csH := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH := Format('%.3f',[cZ]);
          end;
       end;
  end;

 function TableToRTF : AnsiString;
 var
    Row, Col, IncCellWidth, CellMargin, ColCount : Integer;
    Kx : Extended;
    HeaderInt : string;


    dT, odT : double;   str, str2, str3 :string;    found:boolean;
    I, j, n, i1, CurR :Integer;   SL:TStringList;

 const  ColWidth  : Array [0..6] of Integer = (100, 152, 152, 77, 72, 72, 70);
        ColWidth2 : Array [0..6] of Integer = (55, 80, 95, 130, 130, 150, 150);
        ColWidth3 : Array [0..7] of Integer = (50, 80, 80, 115, 105, 105, 105,
                                                 105);
        ColWidth4 : Array [0..12] of Integer = (50, 90, 80, 120, 250, 120, 120,
                                                 120, 120, 120, 130, 130, 130);
 begin
   Kx := 15;
   CellMargin := Round(Int(2 * Kx));
   Result := '{'#13#10;
   Result := Result + '{\fonttbl{\f0\fnil Tahoma;}}' + #13#10;
   Result := Result + '{\colortbl ;\red0\green0\blue0;\red255\green0\blue0;}';
   Result := Result + '\trowd\f0\fs16'
    + '\brdrs\trgaph' + IntToStr(CellMargin) + #13#10;
   IncCellWidth := 0;


   case tableKind of
     0: begin
       ColCount := 4;
       HeaderInt := inf[130];
     end;
     1: begin
       ColCount := 6;
       HeaderInt := inf[131];
     end;
     3: begin
       ColCount := 3;
       if RoutesMeanSize > 10000 then
           str := inf[41]
        else
           str := inf[40];
       HeaderInt := inf[222] + ',' + str;
     end;

     10, 20: begin
       ColCount := 6;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
          inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:    HeaderInt := inf[177];
         1:    HeaderInt := inf[178];
         else  HeaderInt := inf[179];
       end;
     end;
     11, 21: begin
       ColCount := 7;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:    HeaderInt := inf[180];
         1:    HeaderInt := inf[181];
         else  HeaderInt := inf[182];
       end;
     end;
     12, 22: begin
       ColCount := 7;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:    HeaderInt := inf[183];
         1:    HeaderInt := inf[184];
         else  HeaderInt := inf[185];
       end;
     end;
     15, 25, 16, 26: begin
       ColCount := 11;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         inc(ColCount);
       case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
         0:   HeaderInt := inf[186] + inf[189];
         1:   HeaderInt := inf[187] + inf[189];
         else HeaderInt := inf[188] + inf[189];
       end;
       if StatBox.iAccuracy.Checked then
          ColCount := ColCount + 2;
     end;
   end;

   for Col := 0 to ColCount-1 do begin
     if tableKind <> 0 then
     begin
       case TableKind of
         10, 20:  IncCellWidth := Round(Int(IncCellWidth + ColWidth2[Col] * Kx));
         11, 12, 21, 22:  IncCellWidth := Round(Int(IncCellWidth + ColWidth3[Col] * Kx));
         15, 25, 16, 26:  IncCellWidth := Round(Int(IncCellWidth + ColWidth4[Col] * Kx));
         else IncCellWidth := Round(Int(IncCellWidth + ColWidth[Col] * Kx));
       end;
     end
     else
     begin
        case Col of
          0: IncCellWidth := Round(Int(IncCellWidth + 40 * Kx));
          3: IncCellWidth := Round(Int(IncCellWidth + 120 * Kx));
          else IncCellWidth := Round(Int(IncCellWidth + ColWidth[Col] * Kx))
       end;
     end;

     Result := Result + '\cellx' + IntToStr(IncCellWidth) + #13#10;
   end;


   /// заголовок
   Result := Result + #13#10+'\pard\intbl\b\qc\cf0\fs16 ';
   for I := 0 to ColCount - 1 do
   begin
     Result := Result + GetCols(HeaderInt, I, 1, 1, false) + '\cell'#13#10;
   end;
   Result := Result + '\row'#13#10;


   if tableKind = 0 then
   begin
     j := 0;
     for I := 1 to Length(MainTrack) - 2 do
     begin
        dT := MainTrack[i].T - MainTrack[i-1].T;

        if I > 1 then
          if dT > odT*2 then
          begin
            str := '-';
            if MainTrack[i-1].RouteN > -1 then
                 str := MainTrack[i-1].RouteName;

            inc(j);

            if str <> '-' then
               Result := Result + #13#10+'\pard\intbl\b\cf2\fs16 '
            else
               Result := Result + '\intbl\cf0\b0\qr\fs16 '#13#10;

            Result := Result + IntToStr(j) + '\cell'#13#10;
            Result := Result + MainTrack[i-1]._T + '\cell'#13#10;
            Result := Result + MainTrack[i]._T + '\cell'#13#10;
            Result := Result + str + '\cell'#13#10;

            Result := Result + '\row'#13#10;
          end;

        if dt <> 0 then
          odt := dt;
     end;
   end;


   if tableKind = 1 then
   begin
      CurR := -1;
      I1 := 0;
      for I := 0 to Length(MainTrack) - 1 do
      begin
         avg := 0; stdev := 0; n := 0; max := 0;  err:=false;

         if MainTrack[I].RouteN <> CurR then
         if CurR = -1 then
         begin
            CurR := MainTrack[I].RouteN;
            I1 := I;
         end
         else
           begin

             found := false;
             if MainTrack[I].RouteN <> CurR then
             if I < Length(MainTrack) - 10 then
             begin
               for j := I + 1 to I + 10 do
               if MainTrack[j].RouteN = CurR then
               begin
                 found := true;
                 break;
               end;
             end;

            if found then
              continue;


             n := (I-1) - I1;
             for j := I1 to I - 1 do
             begin

                if n <= 0 then
                  break;

                if MainTrack[j].RouteDist > 1E6 then
                begin
                  dec(n);
                  err := true;
                  continue;
                end;

                if n <= 0 then
                  break;

                avg := avg + MainTrack[j].RouteDist;
                if abs(MainTrack[j].RouteDist) > max then
                  max := abs(MainTrack[j].RouteDist);

                stdev := stdev + sqr(MainTrack[j].RouteDist);
              end;

              if n > 0 then
              begin
                str := '-';
                if MainTrack[i1].RouteN > -1 then
                  str := MainTrack[i1].RouteName;

                if err then
                   Result := Result + #13#10+'\pard\intbl\b\cf2 '
                else
                   Result := Result + '\intbl\cf0\b0\qr '#13#10;

                avg := avg/n;
                stdev := sqrt(stdev/n);

                Result := Result + str + '\cell'#13#10;
                Result := Result + MainTrack[i1]._T  + '\cell'#13#10;
                Result := Result + MainTrack[i-1]._T + '\cell'#13#10;
                Result := Result + Formatfloat('  0.00', Stdev) + '\cell'#13#10;
                Result := Result + Formatfloat('  0.00', Avg) + '\cell'#13#10;
                Result := Result + Formatfloat('  0.00', Max) + '\cell'#13#10;
                Result := Result + '\row'#13#10;
          end;

          CurR :=  MainTrack[I].RouteN;
        end;

      end;

   end;

   if tableKind = 3 then
   for I := 0 to RouteCount - 1 do
   begin
     Result := Result + '\intbl\cf0\b0\qr '#13#10;
     Result := Result + Route[I].Name + '\cell'#13#10;
     Result := Result + IntToStr(Length(Route[I].WPT)-1) + '\cell'#13#10;
     if RoutesMeanSize > 10000 then
         str := Formatfloat('  0.000', RouteLenght(I)*0.001 )
       else
         str :=  Formatfloat('  0.0', RouteLenght(I) );
     Result := Result + str + '\cell'#13#10;
     Result := Result + '\row'#13#10;
   end;

    if tableKind = 10 then
    for I := 0 to KnotCount - 1 do
    begin
       str := KnotPoints[I].Name;  // if str = '' then str := '&nbsp;'
       P := LatLongToPoint(MapToBL(KnotPoints[I].cx, KnotPoints[I].cy));
       BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

       Result := Result + '\intbl\cf0\b0\qr '#13#10;

       Result := Result + IntToStr(I+1) + '\cell'#13#10;
       Result := Result + str + '\cell'#13#10;

       if StatBox.iFull.Checked then
       begin
         case KnotPoints[I].NameKind of
            0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
            2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
            3,4 : str := FormatFloat('000', KnotPoints[I].L);
         end;
         Result := Result +  str + '\cell'#13#10;
       end
       else
         Result := Result + 'L' + FormatFloat('000', KnotPoints[I].L)
                    + '\cell'#13#10;

       Result := Result + csx + '\cell'#13#10;
       Result := Result + csy + '\cell'#13#10;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         Result := Result + csh + '\cell'#13#10;
       Result := Result + '\row'#13#10;
    end;  /// end talekind = 10

    if tableKind = 11 then
    for I := 0 to KnotCount - 1 do
    if KnotPoints[I].Shp <> 1 then
    for j := 1 to 4 do
    begin
       str := KnotPoints[I].Name; // if str = '' then str := '&nbsp;'
       P.x := KnotPoints[I].cx +
            Sin(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;
       P.y := KnotPoints[I].cy +
            Cos(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;
       P := LatLongToPoint(MapToBL(P.x, P.y));
       BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

       Result := Result + '\intbl\cf0\b0\qr '#13#10;

       Result := Result + IntToStr(I*4 + j+1) + '\cell'#13#10;
       Result := Result + str  + '\cell'#13#10;
       Result := Result + 'L' + FormatFloat('000', KnotPoints[I].L) + '\cell'#13#10;

       if StatBox.iFull.Checked then
       begin
         case KnotPoints[I].NameKind of
            0, 1: str := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
            2 : str := 'L' +FormatFloat('000', KnotPoints[I].L);
            3,4 : str := FormatFloat('000', KnotPoints[I].L);
         end;
         Result := Result +  str + '_K' + IntToStr(j) + '\cell'#13#10;
       end
       else
         Result := Result + IntToStr(j) + '\cell'#13#10;

       Result := Result + csx + '\cell'#13#10;
       Result := Result + csy + '\cell'#13#10;
       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
         Result := Result + csh + '\cell'#13#10;
       Result := Result + '\row'#13#10;
    end;  /// end tablekind = 11

    I1 := 0;
    if tableKind = 12 then
    for I := 0 to KnotCount - 1 do
    begin
      GetKnotPickets(KnotPoints[I], false);

      for j := 1 to PktCount - 1 do
      begin
        Inc(I1);

        str := Pkt[j].Name;
        if StatBox.iFull.Checked = false then
        while Pos ('_', str) > 0 do
        begin
          n := Pos ('_', str);
          str := Copy(str, n+1, length(str)-n);
        end;

        P.x := KnotPoints[I].cx + Pkt[j].x;
        P.y := KnotPoints[I].cy + Pkt[j].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        Result := Result + '\intbl\cf0\b0\qr '#13#10;
                                                            
        Result := Result + IntToStr(I1) + '\cell'#13#10;
        Result := Result + KnotPoints[I].Name + '\cell'#13#10;
        Result := Result + 'L' + FormatFloat('000', KnotPoints[I].L) + '\cell'#13#10;
        Result := Result + str + '\cell'#13#10;
        Result := Result + csx + '\cell'#13#10;
        Result := Result + csy + '\cell'#13#10;
        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
          Result := Result + csh + '\cell'#13#10;
        Result := Result + '\row'#13#10;

      end;
    end;  // end tablekind = 12

    if tableKind = 20 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin
        if Markers[I].MarkerKind = 1 then
        begin
          inc(I1);
          str := Markers[I].MarkerName;

          while Pos ('_', str) > 0 do
          begin
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, 1, n-1);
          end;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);


          Result := Result + '\intbl\cf0\b0\qr '#13#10;

          Result := Result + IntToStr(I1) + '\cell'#13#10;
          Result := Result + str2 + '\cell'#13#10;
          Result := Result + str + '\cell'#13#10;
          Result := Result + csx + '\cell'#13#10;
          Result := Result + csy + '\cell'#13#10;
          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
            Result := Result + csh + '\cell'#13#10;
          Result := Result + '\row'#13#10;

        end;
      end;

      SL := TStringList.Create;
      GetKnotMarkerList(SL, 0);
      if SL.Count > I1 then
      for I := 0 to SL.Count - 1 do     /// ADD Computed centers
      begin
         found := false;
         for j := 0 to Length(Markers) - 1 do
           if AnsiLowerCase(SL[I]) = AnsiLowerCase(Markers[j].MarkerName) then
           begin
             found := true;
             break;
           end;

          if not found then
          begin
            str := SL[I];
            if not GetMarkerKnotCenter(str, P.x, P.y) then
               continue;

            inc(I1);

            while Pos ('_', str) > 0 do
            begin
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(SL[I], 1, n-1);
            end;

            if StatBox.iFull.Checked then
               str := SL[I];

            P := LatLongToPoint(MapToBL(P.x, P.y));
            BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

            //Result := Result + #13#10+'\pard\intbl\b\cf0 ';
            Result := Result + #13#10+'\pard\intbl\b\cf1\fs16 ';

            Result := Result + IntToStr(I1) + '\cell'#13#10;
            Result := Result + str2 + '\cell'#13#10;
            Result := Result + str + '\cell'#13#10;
            Result := Result + csx + '\cell'#13#10;
            Result := Result + csy + '\cell'#13#10;
            if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
              Result := Result + csh + '\cell'#13#10;
            Result := Result + inf[191] + '\cell'#13#10;
            Result := Result + '\row'#13#10;
          end;

      end;  /// ADD Computed centers: end
      SL.Destroy;
    End; /// tablekind = 20 end


    if tableKind = 21 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin

        if Markers[I].MarkerKind = 2 then
        begin
          inc(I1);
          str := Markers[I].MarkerName;

          n := 0;
          while Pos ('_', str) > 0 do
          begin
              j := n;
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, j+1, n-1);
              if j > 0 then
                str3 := Copy(Markers[I].MarkerName, 1, j-1)
              else
                str3 := '';
          end;

          if AnsiUpperCase(str2[1]) <> 'L' then
             str2 := 'L' + str2;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          Result := Result + '\intbl\cf0\b0\qr '#13#10;

          Result := Result + IntToStr(I1) + '\cell'#13#10;
          Result := Result + str3 + '\cell'#13#10;
          Result := Result + str2 + '\cell'#13#10;
          Result := Result + str + '\cell'#13#10;
          Result := Result + csx + '\cell'#13#10;
          Result := Result + csy + '\cell'#13#10;
          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
            Result := Result + csh + '\cell'#13#10;
          Result := Result + '\row'#13#10;


        end;
      end;
    End; /// tablekind = 21 end

    if tableKind = 22 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin

        if Markers[I].MarkerKind = 3 then
        begin
          inc(I1);
          str := Markers[I].MarkerName;

          n := 0;
          while Pos ('_', str) > 0 do
          begin
              j := n;
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, j+1, n-1);
              if j > 0 then
                str3 := Copy(Markers[I].MarkerName, 1, j-1)
              else
                str3 := '';
          end;

          if AnsiUpperCase(str2[1]) <> 'L' then
             str2 := 'L' + str2;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          Result := Result + '\intbl\cf0\b0\qr '#13#10;

          Result := Result + IntToStr(I1) + '\cell'#13#10;
          Result := Result + str3 + '\cell'#13#10;
          Result := Result + str2 + '\cell'#13#10;
          Result := Result + str + '\cell'#13#10;
          Result := Result + csx + '\cell'#13#10;
          Result := Result + csy + '\cell'#13#10;
          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
            Result := Result + csh + '\cell'#13#10;
          Result := Result + '\row'#13#10;

        end;
      end;
    End; /// tablekind = 22 end


    HasPart2 := false;
    if tableKind = 15 then
    for I := 0 to MarkersUDFCount - 1 do
    begin
     // GetPrLPkt(Markers[UDFCompare[I].N].MarkerName, j, I1, str3);
                                          //// здесь: I1 = номер пикета
    //  str2 := intToStr(j);

      found := (UDFCompare[I].uKnots.KnotI > -1) and
               (UDFCompare[I].uKnots.KnotI < KnotCount);

      if found then
      begin
        GetKnotPickets(KnotPoints[UDFCompare[I].uKnots.KnotI], false);
        j := UDFCompare[I].uKnots.PicketI;
        if (j < PktCount) and (j >= 0) then
        begin

           str := Pkt[j].Name;
           if StatBox.iFull.Checked = false then
           while Pos ('_', str) > 0 do
           begin
              n := Pos ('_', str);
              str := Copy(str, n+1, length(str)-n);
           end;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           Result := Result + '\intbl\cf0\b0\qr\fs16 '#13#10;

           Result := Result + IntToStr(I+1) + '\cell'#13#10;
           Result := Result + KnotPoints[UDFCompare[I].uKnots.KnotI].Name
                       + '\cell'#13#10;
           Result := Result + 'L' +FormatFloat('000', KnotPoints[UDFCompare[I].uKnots.KnotI].L)
                       + '\cell'#13#10;
           Result := Result + str + '\cell'#13#10;
           Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
           Result := Result + csx + '\cell'#13#10;
           Result := Result + csy + '\cell'#13#10;
           Result := Result + csh + '\cell'#13#10;

           P.x := KnotPoints[UDFCompare[I].uKnots.KnotI].cx
                  + Pkt[UDFCompare[I].uKnots.PicketI].x;
           P.y := KnotPoints[UDFCompare[I].uKnots.KnotI].cy
                  + Pkt[UDFCompare[I].uKnots.PicketI].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));
           BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

           Result := Result + csx + '\cell'#13#10;
           Result := Result + csy + '\cell'#13#10;
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
               Result := Result + csh + '\cell'#13#10;

           Result := Result + Format('%.3f',[UDFCompare[I].uKnots.Dist]) + '\cell'#13#10;

           if StatBox.iAccuracy.Checked then
           begin
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
           end;

           Result := Result + '\row'#13#10;

           if not HasPart2 then
             HasPart2 := (UDFCompare[I].uKnots.Dist - UDFCompare[I].uKnots.Dist_nearest) > 1;
        end
         else found := false;
      end;

      if not found then
      Begin
           HasPart2 := true;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           Result := Result + #13#10+'\pard\intbl\b0\cf2\fs16 ';

           Result := Result + IntToStr(I+1) + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
           Result := Result + csx + '\cell'#13#10;
           Result := Result + csy + '\cell'#13#10;
           Result := Result + csh + '\cell'#13#10;

           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
              Result := Result + '-' + '\cell'#13#10;

           Result := Result + '-' + '\cell'#13#10;

           if StatBox.iAccuracy.Checked then
           begin
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
           end;

           Result := Result + '\row'#13#10;
      End;

    end;  /// tablekind = 15 end


    if tableKind = 16 then
    for I := 0 to MarkersUDFCount - 1 do
    if ((UDFCompare[I].uKnots.Dist - UDFCompare[I].uKnots.Dist_nearest) > 1) or
       (UDFCompare[I].uKnots.KnotI = -1)  then
    begin

      found := (UDFCompare[I].uKnots.KnotI_nearest > -1) and
               (UDFCompare[I].uKnots.KnotI_nearest < KnotCount);

      if found then
      begin
        GetKnotPickets(KnotPoints[UDFCompare[I].uKnots.KnotI_nearest], false);
        j := UDFCompare[I].uKnots.PicketI_nearest;
        if (j < PktCount) and (j >= 0) then
        begin

           str := Pkt[j].Name;
           if StatBox.iFull.Checked = false then
           while Pos ('_', str) > 0 do
           begin
              n := Pos ('_', str);
              str := Copy(str, n+1, length(str)-n);
           end;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           Result := Result + #13#10+'\pard\intbl\b0\cf2\fs16 ';

           Result := Result + IntToStr(I+1) + '\cell'#13#10;
           Result := Result + KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].Name
                       + '\cell'#13#10;
           Result := Result + 'L' +FormatFloat('000', KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].L)
                       + '\cell'#13#10;
           Result := Result + str + '\cell'#13#10;
           Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
           Result := Result + csx + '\cell'#13#10;
           Result := Result + csy + '\cell'#13#10;
           Result := Result + csh + '\cell'#13#10;

           P.x := KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].cx
                  + Pkt[UDFCompare[I].uKnots.PicketI_nearest].x;
           P.y := KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].cy
                  + Pkt[UDFCompare[I].uKnots.PicketI_nearest].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));
           BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

           Result := Result + csx + '\cell'#13#10;
           Result := Result + csy + '\cell'#13#10;
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
               Result := Result + csh + '\cell'#13#10;

           Result := Result + Format('%.3f',[UDFCompare[I].uKnots.Dist_nearest]) + '\cell'#13#10;

           if StatBox.iAccuracy.Checked then
           begin
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
           end;

           Result := Result + '\row'#13#10;
        end
         else found := false;
      end;

      if not found then
      Begin
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           Result := Result + #13#10+'\pard\intbl\b0\cf1\fs16 ';

           Result := Result + IntToStr(I+1) + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
           Result := Result + csx + '\cell'#13#10;
           Result := Result + csy + '\cell'#13#10;
           Result := Result + csh + '\cell'#13#10;

           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
              Result := Result + '-' + '\cell'#13#10;

           Result := Result + '-' + '\cell'#13#10;

           if StatBox.iAccuracy.Checked then
           begin
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
              Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
           end;

           Result := Result + '\row'#13#10;
      End;

    end;  /// tablekind = 16 end




    if tableKind = 25 then
    for I := 0 to MarkersUDFCount - 1 do
    begin

      found := (UDFCompare[I].uMarkers.I > -1) and
               (UDFCompare[I].uMarkers.I < Length(Markers));

      if found then
      begin

        str := Markers[UDFCompare[I].uMarkers.I].MarkerName;
        n := 0;
        while Pos ('_', str) > 0 do
        begin
           j := n;
           n := Pos ('_', str);
           str  := Copy(str, n+1, length(str)-n);
           str2 := Copy(Markers[UDFCompare[I].uMarkers.I].MarkerName, j+1, n-1);
           if j > 0 then
             str3 := Copy(Markers[UDFCompare[I].uMarkers.I].MarkerName, 1, j-1)
           else
             str3 := '';
        end;

        if AnsiUpperCase(str2[1]) <> 'L' then
           str2 := 'L' + str2;

        if StatBox.iFull.Checked then
           str := Markers[UDFCompare[I].uMarkers.I].MarkerName;

        P.x := Markers[UDFCompare[I].N].x;
        P.y := Markers[UDFCompare[I].N].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));

        BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
        if Markers[UDFCompare[I].N].Hgeo <> 0 then
          csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

        Result := Result + #13#10+'\pard\intbl\b0\cf0\fs16 '; //1  после str :=
        Result := Result + IntToStr(I+1) + '\cell'#13#10;
        Result := Result + str3 + '\cell'#13#10;
        Result := Result + str2 + '\cell'#13#10;
        Result := Result + str + '\cell'#13#10;
        Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
        Result := Result + csX + '\cell'#13#10;
        Result := Result + csY + '\cell'#13#10;
        Result := Result + csH + '\cell'#13#10;


        P.x := Markers[UDFCompare[I].uMarkers.I].x;
        P.y := Markers[UDFCompare[I].uMarkers.I].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);


        Result := Result + csX + '\cell'#13#10;               //2  после str2 :=
        Result := Result + csY + '\cell'#13#10;
        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
           Result := Result + csH + '\cell'#13#10;

        Result := Result +  Format('%.3f',[UDFCompare[I].uMarkers.Dist]) + '\cell'#13#10;

        if StatBox.iAccuracy.Checked then
        begin
           Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
           Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
        end;

        Result := Result + '\row'#13#10;

        if not HasPart2 then
           HasPart2 := (UDFCompare[I].uMarkers.Dist - UDFCompare[I].uMarkers.Dist_nearest) > 1;
      end
      else
        found := false;

      if not found then
      Begin
           HasPart2 := true;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);


           Result := Result + #13#10+'\pard\intbl\b0\cf2\fs16 ';
           Result := Result + IntToStr(I+1) + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
           Result := Result + csX + '\cell'#13#10;
           Result := Result + csY + '\cell'#13#10;
           Result := Result + csH + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;

           if StatBox.iAccuracy.Checked then
           begin
             Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
             Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
           end;

           Result := Result + '\row'#13#10;
      End;

    end;  /// tablekind = 25 end

    if tableKind = 26 then
    for I := 0 to MarkersUDFCount - 1 do
    if ((UDFCompare[I].uMarkers.Dist - UDFCompare[I].uMarkers.Dist_nearest) > 1) or
       (UDFCompare[I].uMarkers.I = -1)  then
    begin

      found := (UDFCompare[I].uMarkers.I_nearest > -1) and
               (UDFCompare[I].uMarkers.I_nearest < Length(Markers));

      if found then
      begin

        str := Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName;
        n := 0;
        while Pos ('_', str) > 0 do
        begin
           j := n;
           n := Pos ('_', str);
           str  := Copy(str, n+1, length(str)-n);
           str2 := Copy(Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName,
                  j+1, n-1);
           if j > 0 then
             str3 := Copy(Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName,
                  1, j-1)
           else
             str3 := '';
        end;

        if AnsiUpperCase(str2[1]) <> 'L' then
           str2 := 'L' + str2;

        if StatBox.iFull.Checked then
           str := Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName;

        P.x := Markers[UDFCompare[I].N].x;
        P.y := Markers[UDFCompare[I].N].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));

        BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
        if Markers[UDFCompare[I].N].Hgeo <> 0 then
          csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

        Result := Result + #13#10+'\pard\intbl\b0\cf0\fs16 '; //1  после str :=
        Result := Result + IntToStr(I+1) + '\cell'#13#10;
        Result := Result + str3 + '\cell'#13#10;
        Result := Result + str2 + '\cell'#13#10;
        Result := Result + str + '\cell'#13#10;
        Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
        Result := Result + csX + '\cell'#13#10;
        Result := Result + csY + '\cell'#13#10;
        Result := Result + csH + '\cell'#13#10;

        P.x := Markers[UDFCompare[I].uMarkers.I_nearest].x;
        P.y := Markers[UDFCompare[I].uMarkers.I_nearest].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
           str2 := csx + #$9 + csy
        else
           str2 :=  csx + #$9 + csy + #$9 + csh;       {проектные}

        Result := Result + csX + '\cell'#13#10;               //2  после str2 :=
        Result := Result + csY + '\cell'#13#10;
        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
           Result := Result + csH + '\cell'#13#10;

        Result := Result + Format('%.3f',[UDFCompare[I].uMarkers.Dist_nearest])
                         + '\cell'#13#10;

        if StatBox.iAccuracy.Checked then
        begin
           Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
           Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
        end;

        Result := Result + '\row'#13#10;
      end
      else
        found := false;

      if not found then
      Begin
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);


           Result := Result + #13#10+'\pard\intbl\b0\cf2\fs16 ';
           Result := Result + IntToStr(I+1) + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + Markers[UDFCompare[I].N].MarkerName + '\cell'#13#10;
           Result := Result + csX + '\cell'#13#10;
           Result := Result + csY + '\cell'#13#10;
           Result := Result + csH + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             Result := Result + '-' + '\cell'#13#10;
           Result := Result + '-' + '\cell'#13#10;

           if StatBox.iAccuracy.Checked then
           begin
             Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add1]) + '\cell'#13#10;
             Result := Result + Format('%.3f',[Markers[UDFCompare[I].N].Add2]) + '\cell'#13#10;
           end;

           Result := Result + '\row'#13#10;
      End;

    end;   // tablekind = 26 end







   Result := Result + '}'#13#10;

   if TableKind = 0 then
   begin
     if (StatBox.iCompare.Checked) then
       Result := Result +'\i\b0 '
     else
       Result := Result +'\f0\i0\b\fs24 ';
   end;

   if Tablekind = 1 then
   begin
      if (StatBox.iSlips.Checked) or (StatBox.iCompare.Checked) then
      begin
         Result := Result +'\i\b0 '
      end
      else
        Result := Result +'\f0\i0\b\fs24 ';
   end;

 end;

 function GetRtfText(aRe :TRichEdit):AnsiString;
 var Ss :TStringStream;
 begin
   Ss := TStringStream.Create('');
   aRe.Lines.SaveToStream(Ss);
   Result := Ss.DataString;
   FreeAndNil(Ss);
 end;

var
  STable, SDoc : AnsiString;
  LenS, LenT : Integer;
  P1 : LongInt;
  const TableTag = '#table#';
begin

  LenS := Length(TableTag);
  StatBox.iReport.Lines.Add(tabletag);
  //StatBox.iReport.Lines.Add('');

  SDoc := GetRtfText(StatBox.iReport);
  STable := TableToRTF;

  LenT := Length(STable);
  P1 := PosEx(TableTag, SDoc, 1);

  Delete(SDoc, P1, LenS);
  Insert(STable, SDoc, P1);

  StatBox.iReport.Text := SDoc;
end;

procedure Insert2;

 function GetRtfText(aRe :TRichEdit):AnsiString;
 var Ss :TStringStream;
 begin
   Ss := TStringStream.Create('');
   aRe.Lines.SaveToStream(Ss);
   Result := Ss.DataString;
   FreeAndNil(Ss);
 end;

var
  S2, SDoc : AnsiString;
  LenS, LenT : Integer;
  P1 : LongInt;
  const Tag2 = '#2#';
begin

  LenS := Length(Tag2);


  SDoc := GetRtfText(StatBox.iReport);
  S2 := '\f1\super 2\nosupersub\i0\b0  ';

  LenT := Length(S2);
  P1 := PosEx(Tag2, SDoc, 1);

  Delete(SDoc, P1, LenS);
  Insert(S2, SDoc, P1);

  StatBox.iReport.Text := SDoc;
end;

procedure TStatBox.iAreaClick(Sender: TObject);
  procedure Ordinary;
  begin
    iReport.SelAttributes.Style := [];
    iReport.SelAttributes.Size := 10;
    //iReport.SelAttributes.Color := clBlack;
  end;

  var csx, csy, csH :string;
  procedure BLToCS(B,L,H :double; CS:Integer);
  var cX, cY, cZ: Double;
  begin
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
            csH := Format('%.3f',[cZ]);
          end;
          2..4:begin
            csY := Format('%.3f',[cX]);
            csX := Format('%.3f',[cY]);
            csH  := Format('%.3f',[cZ]);
          end;
       end;
  end;


  procedure AddFlatTable(tableKind:byte);
  var dT, odT : double;   str, str2, str3 :string;    found:boolean;
      I, j, n, i1, CurR :Integer;
      P : TMyPoint;
      SL :TStringList;
  begin
    SL := TStringList.Create;
    Ordinary;
    case tableKind of
     0, 1 : begin
          iReport.SelAttributes.Style := [fsBold];
          iReport.Lines.Add(inf[130 + tableKind]);
        end;

     3: begin
        if RoutesMeanSize > 10000 then
           str := inf[41]
        else
           str := inf[40];

        iReport.SelAttributes.Style := [fsBold];
        iReport.Lines.Add(inf[222] + ',' + str);
     end;

     10, 20: begin
        iReport.SelAttributes.Style := [fsBold];
        case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
          0:  iReport.Lines.Add(inf[177]);
          1:  iReport.Lines.Add(inf[178]);
          else  iReport.Lines.Add(inf[179]);
        end;
       end;
      11, 21: begin
        iReport.SelAttributes.Style := [fsBold];
        case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
          0:  iReport.Lines.Add(inf[180]);
          1:  iReport.Lines.Add(inf[181]);
          else  iReport.Lines.Add(inf[182]);
        end;
       end;
       12, 22: begin
        iReport.SelAttributes.Style := [fsBold];
        case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
          0:  iReport.Lines.Add(inf[183]);
          1:  iReport.Lines.Add(inf[184]);
          else  iReport.Lines.Add(inf[185]);
        end;
       end;

       15, 25, 16, 26 : begin
        iReport.SelAttributes.Style := [fsBold];
        case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
          0:  iReport.Lines.Add(inf[186]);
          1:  iReport.Lines.Add(inf[187]);
          else  iReport.Lines.Add(inf[188]);
        end;
        if iAccuracy.Checked then
          iReport.Lines[iReport.Lines.Count-1] :=
             iReport.Lines[iReport.Lines.Count-1] + inf[189];

       end;

    end;
    iReport.SelAttributes.Style := [];
    Ordinary;


    if tableKind = 0 then
    begin
      j := 0;
      for I := 1 to Length(MainTrack) - 2 do
      begin
        dT := MainTrack[i].T - MainTrack[i-1].T;

        if I > 1 then
          if dT > odT*2 then
          begin
            str := '-';
            if MainTrack[i-1].RouteN > -1 then
                 str := MainTrack[i-1].RouteName;

            inc(j);

            Ordinary;
            if str <> '-' then
              iReport.SelAttributes.Color := clRed;

              iReport.Lines.Add(IntToStr(j) +#$9 +  MainTrack[i-1]._T +
                              #$9 +  MainTrack[i]._T + #$9 + str);
          end;

        if dt <> 0 then
          odt := dt;
      end;
    end;      // end tablekind = 0


    if tableKind = 1 then
    begin
      CurR := -1;
      I1 := 0;
      for I := 0 to Length(MainTrack) - 1 do
      begin
         Ordinary;
         avg := 0; stdev := 0; n := 0; max := 0;  err:=false;

         if MainTrack[I].RouteN <> CurR then
         if CurR = -1 then
         begin
            CurR := MainTrack[I].RouteN;
            I1 := I;
         end
         else
           begin

             found := false;
             if MainTrack[I].RouteN <> CurR then
             if I < Length(MainTrack) - 10 then
             begin
               for j := I + 1 to I + 10 do
               if MainTrack[j].RouteN = CurR then
               begin
                 found := true;
                 break;
               end;
             end;

            if found then
              continue;


             n := (I-1) - I1;
             for j := I1 to I - 1 do
             begin

                if n <= 0 then
                  break;

                if MainTrack[j].RouteDist > 1E6 then
                begin
                  dec(n);
                  err := true;
                  continue;
                end;

                if n <= 0 then
                  break;

                avg := avg + MainTrack[j].RouteDist;
                if abs(MainTrack[j].RouteDist) > max then
                  max := abs(MainTrack[j].RouteDist);

                stdev := stdev + sqr(MainTrack[j].RouteDist);
              end;

              if n > 0 then
              begin
                str := '-';
                if MainTrack[i1].RouteN > -1 then
                  str := MainTrack[i1].RouteName;

                Ordinary;
                if err then
                   iReport.SelAttributes.Color := clRed;

                avg := avg/n;
                stdev := sqrt(stdev/n);

                iReport.Lines.Add(str +#$9 +  MainTrack[i1]._T +
                              #$9 +  MainTrack[i-1]._T + #$9 +
                              Formatfloat('  0.00', Stdev) + #$9 +
                              Formatfloat('  0.00', Avg) + #$9 +
                              Formatfloat('  0.00', Max));
          end;

          CurR :=  MainTrack[I].RouteN;
        end;

      end;

    end; // end tablekind = 1

    if TableKind = 3 then
    for I := 0 to RouteCount - 1 do
    begin
       if RoutesMeanSize > 10000 then
         str := Formatfloat('  0.000', RouteLenght(I)*0.001 )
       else
         str :=  Formatfloat('  0.0', RouteLenght(I) );

       iReport.Lines.Add(Route[I].Name +#$9 +  IntToStr(Length(Route[I].WPT)-1) +
                              #$9 +  str )
    end;

    if tableKind = 10 then
    for I := 0 to KnotCount - 1 do
    begin
       Ordinary;

       str := KnotPoints[I].Name;

       if StatBox.iFull.Checked then
       begin
         case KnotPoints[I].NameKind of
            0, 1: str2 := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
            2 : str2 := 'L' +FormatFloat('000', KnotPoints[I].L);
            3,4 : str2 := FormatFloat('000', KnotPoints[I].L);
         end;
       end
       else
         str2 := 'L' + FormatFloat('000', KnotPoints[I].L);


       P := LatLongToPoint(MapToBL(KnotPoints[I].cx, KnotPoints[I].cy));

       BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
         iReport.Lines.Add(IntToStr(I+1) +#$9 + str + #$9 +
                          str2 + #$9 + csx + #$9 + csy)
       else
         iReport.Lines.Add(IntToStr(I+1) +#$9 + str + #$9 + str2 + #$9 +
                 csx + #$9 + csy + #$9 + csh);
    end;

    if tableKind = 11 then
    for I := 0 to KnotCount - 1 do
    if KnotPoints[I].Shp <> 1 then
    for j := 1 to 4 do
    begin
       Ordinary;

       str := KnotPoints[I].Name;

       P.x := KnotPoints[I].cx +
            Sin(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;

       P.y := KnotPoints[I].cy +
            Cos(KnotPoints[I].BoxAngle - j*pi/2 - pi/4)*Sqrt(2)
            *KnotPoints[I].BoxSize/2;

       P := LatLongToPoint(MapToBL(P.x, P.y));

       BLToCS(P.x, P.y, 0, MapFm.CoordSysN);
       if iFull.Checked then
       begin
         case KnotPoints[I].NameKind of
           0, 1: str2 := KnotPoints[I].Name + '_L' +FormatFloat('000', KnotPoints[I].L);
           2 : str2 := 'L' +FormatFloat('000', KnotPoints[I].L);
           3,4 : str2 := FormatFloat('000', KnotPoints[I].L);
         end;
         str2 := str2 + '_K' +IntToStr(j);
       end
        else
           str2 := IntToStr(j);

       if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
         iReport.Lines.Add(IntToStr(I*4 + j+1) + #$9 +  str + #$9 + 'L' +
                 FormatFloat('000', KnotPoints[I].L) + #$9 +
                 str2 + #$9 + csx + #$9 + csy)
       else
         iReport.Lines.Add(IntToStr(I*4 + j+1) + #$9 + str + #$9 + 'L' +
                 FormatFloat('000', KnotPoints[I].L) + #$9 + str2 +
                 #$9 + csx + #$9 + csy + #$9 + csh);
    end;

    I1 := 0;
    if tableKind = 12 then
    for I := 0 to KnotCount - 1 do
    begin
      GetKnotPickets(KnotPoints[I], false);

      for j := 1 to PktCount - 1 do
      begin
        Ordinary;
        Inc(I1);

        str := Pkt[j].Name;
        if iFull.Checked = false then
        while Pos ('_', str) > 0 do
        begin
          n := Pos ('_', str);
          str := Copy(str, n+1, length(str)-n);
        end;

        P.x := KnotPoints[I].cx + Pkt[j].x;
        P.y := KnotPoints[I].cy + Pkt[j].y;

        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
          iReport.Lines.Add(IntToStr(I1) + #$9 +  KnotPoints[I].Name + #$9 +
                  'L' +FormatFloat('000', KnotPoints[I].L) + #$9 + str +
                  #$9 + csx + #$9 + csy)
         else
          iReport.Lines.Add(IntToStr(I1) + #$9 + KnotPoints[I].Name + #$9 +
                  'L' +FormatFloat('000', KnotPoints[I].L) + #$9 + str +
                  #$9 + csx + #$9 + csy + #$9 + csh);
      end;
    end;


    if tableKind = 20 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin
        if Markers[I].MarkerKind = 1 then
        begin
          inc(I1);
          Ordinary;
          str := Markers[I].MarkerName;

          while Pos ('_', str) > 0 do
          begin
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, 1, n-1);
          end;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
            iReport.Lines.Add(IntToStr(I1) +#$9 + str2 + #$9 +
                           str + #$9 + csx + #$9 + csy)
          else
            iReport.Lines.Add(IntToStr(I1) +#$9 + str2 + #$9 + str + #$9 +
                 csx + #$9 + csy + #$9 + csh);

        end;
      end;

      SL.Clear;
      GetKnotMarkerList(SL, 0);
      if SL.Count > I1 then
      for I := 0 to SL.Count - 1 do     /// ADD Computed centers
      begin
         found := false;
         for j := 0 to Length(Markers) - 1 do
           if AnsiLowerCase(SL[I]) = AnsiLowerCase(Markers[j].MarkerName) then
           begin
             found := true;
             break;
           end;

          if not found then
          begin
            str := SL[I];
            if not GetMarkerKnotCenter(str, P.x, P.y) then
               continue;

            inc(I1);

            while Pos ('_', str) > 0 do
            begin
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(SL[I], 1, n-1);
            end;
            if StatBox.iFull.Checked then
               str := SL[I];

            P := LatLongToPoint(MapToBL(P.x, P.y));
            BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

            Ordinary;  iReport.SelAttributes.Color := clRed;

            if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
              iReport.Lines.Add(IntToStr(I1) +#$9 + str2 + #$9 +
                          str + #$9 + csx + #$9 + csy + #$9 + inf[191])
            else
              iReport.Lines.Add(IntToStr(I1) +#$9 + str2 + #$9 + str + #$9 +
                   csx + #$9 + csy + #$9 + csh + #$9 + inf[191]);
          end;

      end;  /// ADD Computed centers: end

    End; /// tablekind = 20 end


    if tableKind = 21 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin

        if Markers[I].MarkerKind = 2 then
        begin
          inc(I1);
          Ordinary;
          str := Markers[I].MarkerName;

          n := 0;
          while Pos ('_', str) > 0 do
          begin
              j := n;
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, j+1, n-1);
              if j > 0 then
                str3 := Copy(Markers[I].MarkerName, 1, j-1)
              else
                str3 := '';
          end;

          if AnsiUpperCase(str2[1]) <> 'L' then
             str2 := 'L' + str2;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
            iReport.Lines.Add(IntToStr(I1) +#$9 + str3 + #$9 + str2 + #$9 +
                           str + #$9 + csx + #$9 + csy)
          else
            iReport.Lines.Add(IntToStr(I1) +#$9 + str3 + #$9 + str2 + #$9 +
                           str + #$9 + csx + #$9 + csy + #$9 + csh);

        end;
      end;
    End; /// tablekind = 21 end

    if tableKind = 22 then
    Begin
      I1 := 0;
      for I := 0 to Length(Markers) - 1 do
      begin

        if Markers[I].MarkerKind = 3 then
        begin
          inc(I1);
          Ordinary;
          str := Markers[I].MarkerName;

          n := 0;
          while Pos ('_', str) > 0 do
          begin
              j := n;
              n := Pos ('_', str);
              str  := Copy(str, n+1, length(str)-n);
              str2 := Copy(Markers[I].MarkerName, j+1, n-1);
              if j > 0 then
                str3 := Copy(Markers[I].MarkerName, 1, j-1)
              else
                str3 := '';
          end;

          if AnsiUpperCase(str2[1]) <> 'L' then
             str2 := 'L' + str2;

          if StatBox.iFull.Checked then
             str := Markers[I].MarkerName;

          BLToCS(Markers[I].Gx, Markers[I].Gy, 0, MapFm.CoordSysN);

          if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
            iReport.Lines.Add(IntToStr(I1) +#$9 + str3 + #$9 + str2 + #$9 +
                           str + #$9 + csx + #$9 + csy)
          else
            iReport.Lines.Add(IntToStr(I1) +#$9 + str3 + #$9 + str2 + #$9 +
                           str + #$9 + csx + #$9 + csy + #$9 + csh);

        end;
      end;
    End; /// tablekind = 22 end

    if (tableKind = 15) or (tableKind = 25) then
       HasPart2 := false;
       
    if tableKind = 15 then
    for I := 0 to MarkersUDFCount - 1 do
    begin
     // GetPrLPkt(Markers[UDFCompare[I].N].MarkerName, j, I1, str3);
                                          //// здесь: I1 = номер пикета
    //  str2 := intToStr(j);

      found := (UDFCompare[I].uKnots.KnotI > -1) and
               (UDFCompare[I].uKnots.KnotI < KnotCount);     

      if found then
      begin
        GetKnotPickets(KnotPoints[UDFCompare[I].uKnots.KnotI], false);
        j := UDFCompare[I].uKnots.PicketI;
        if (j < PktCount) and (j >= 0) then
        begin
           
           str := Pkt[j].Name;
           if iFull.Checked = false then
           while Pos ('_', str) > 0 do
           begin
              n := Pos ('_', str);
              str := Copy(str, n+1, length(str)-n);
           end;

           P.x := KnotPoints[UDFCompare[I].uKnots.KnotI].cx
                  + Pkt[UDFCompare[I].uKnots.PicketI].x;
           P.y := KnotPoints[UDFCompare[I].uKnots.KnotI].cy
                  + Pkt[UDFCompare[I].uKnots.PicketI].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));
           BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
             str2 := csx + #$9 + csy
           else
             str2 :=  csx + #$9 + csy + #$9 + csh;       {проектные}

           str2 := str2 + #$9 + Format('%.3f',[UDFCompare[I].uKnots.Dist]);
           
           if StatBox.iAccuracy.Checked then
             str2 := str2 + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add1])
                          + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add2]);

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           Ordinary;

           iReport.Lines.Add(IntToStr(I+1) + #$9 +
               KnotPoints[UDFCompare[I].uKnots.KnotI].Name + #$9 +
               'L' +FormatFloat('000', KnotPoints[UDFCompare[I].uKnots.KnotI].L)
               + #$9 + str + #$9 + Markers[UDFCompare[I].N].MarkerName + #$9
               + csx + #$9 + csy + #$9 + csh + #$9 + str2);

           if not HasPart2 then
             HasPart2 := (UDFCompare[I].uKnots.Dist - UDFCompare[I].uKnots.Dist_nearest) > 1;
        end
         else found := false;
      end;   

      if not found then
      Begin
           HasPart2 := true;
            
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           str2 := '-' + #$9 + '-';
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             str2 :=  str2 + #$9 + '-';

           str2 :=  str2 + #$9 + '-';
           
           if StatBox.iAccuracy.Checked then
             str2 := str2 + #$9 + '-' + #$9 + '-';

           iReport.SelAttributes.Color := clRed;
           iReport.Lines.Add(IntToStr(I+1) + #$9 + '-' + #$9 + '-' + #$9 +
                  '-' + #$9 + #$9 + Markers[UDFCompare[I].N].MarkerName +
                  #$9 + csx + #$9 + csy + #$9 + csh + str2);
      End;

    end;  /// tablekind = 15 end

    if tableKind = 16 then
    for I := 0 to MarkersUDFCount - 1 do
    if ((UDFCompare[I].uKnots.Dist - UDFCompare[I].uKnots.Dist_nearest) > 1) or
       (UDFCompare[I].uKnots.KnotI = -1)  then
    begin
    
      found := (UDFCompare[I].uKnots.KnotI_nearest > -1) and
               (UDFCompare[I].uKnots.KnotI_nearest < KnotCount);         

      if found then
      begin
        GetKnotPickets(KnotPoints[UDFCompare[I].uKnots.KnotI_nearest], false);
        j := UDFCompare[I].uKnots.PicketI_nearest;
        if (j < PktCount) and (j >= 0) then
        begin
           
           str := Pkt[j].Name;
           if iFull.Checked = false then
           while Pos ('_', str) > 0 do
           begin
              n := Pos ('_', str);
              str := Copy(str, n+1, length(str)-n);
           end;

           P.x := KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].cx
                  + Pkt[UDFCompare[I].uKnots.PicketI_nearest].x;
           P.y := KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].cy
                  + Pkt[UDFCompare[I].uKnots.PicketI_nearest].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));
           BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
             str2 := csx + #$9 + csy
           else
             str2 :=  csx + #$9 + csy + #$9 + csh;       {проектные}

           str2 := str2 + #$9 + Format('%.3f',[UDFCompare[I].uKnots.Dist_nearest]);
           
           if StatBox.iAccuracy.Checked then
             str2 := str2 + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add1])
                          + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add2]);

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           Ordinary;
           iReport.SelAttributes.Color := clRed;
           iReport.Lines.Add(IntToStr(I+1) + #$9 +
               KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].Name + #$9 +
               'L' +FormatFloat('000', KnotPoints[UDFCompare[I].uKnots.KnotI_nearest].L)
               + #$9 + str + #$9 + Markers[UDFCompare[I].N].MarkerName + #$9
               + csx + #$9 + csy + #$9 + csh + #$9 + str2);
        end
         else found := false;
      end;   

      if not found then
      Begin           
           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           str2 := '-' + #$9 + '-';
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             str2 :=  str2 + #$9 + '-';

           if StatBox.iAccuracy.Checked then
             str2 := str2 + #$9 + '-' + #$9 + '-';

           iReport.SelAttributes.Color := clRed;
           iReport.Lines.Add(IntToStr(I+1) + #$9 + '-' + #$9 + '-' + #$9 +
                  '-' + #$9 + #$9 + Markers[UDFCompare[I].N].MarkerName +
                  #$9 + csx + #$9 + csy + #$9 + csh + str2);
      End;

    end;  /// tablekind = 16 end

    if tableKind = 25 then
    for I := 0 to MarkersUDFCount - 1 do
    begin
                                                                 
      found := (UDFCompare[I].uMarkers.I > -1) and
               (UDFCompare[I].uMarkers.I < Length(Markers));      

      if found then
      begin
      
        str := Markers[UDFCompare[I].uMarkers.I].MarkerName;
        n := 0;
        while Pos ('_', str) > 0 do
        begin
           j := n;
           n := Pos ('_', str);
           str  := Copy(str, n+1, length(str)-n);
           str2 := Copy(Markers[UDFCompare[I].uMarkers.I].MarkerName, j+1, n-1);
           if j > 0 then
             str3 := Copy(Markers[UDFCompare[I].uMarkers.I].MarkerName, 1, j-1)
           else
             str3 := '';
        end;

        if AnsiUpperCase(str2[1]) <> 'L' then
           str2 := 'L' + str2;

        if StatBox.iFull.Checked then
           str := Markers[UDFCompare[I].uMarkers.I].MarkerName;

        P.x := Markers[UDFCompare[I].N].x;
        P.y := Markers[UDFCompare[I].N].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));

        BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
        if Markers[UDFCompare[I].N].Hgeo <> 0 then
          csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

        str := str3 + #$9 + str2 + #$9 + str + #$9 +
               Markers[UDFCompare[I].N].MarkerName + #$9 + 
               csx + #$9 + csy + #$9 + csh;



        P.x := Markers[UDFCompare[I].uMarkers.I].x;
        P.y := Markers[UDFCompare[I].uMarkers.I].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
           str2 := csx + #$9 + csy
        else
           str2 :=  csx + #$9 + csy + #$9 + csh;       {проектные}

        str2 := str2 + #$9 + Format('%.3f',[UDFCompare[I].uMarkers.Dist]);

        if StatBox.iAccuracy.Checked then
           str2 := str2 + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add1])
                        + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add2]);

        Ordinary;

        iReport.Lines.Add(IntToStr(I+1) + #$9 + str + #$9 + str2);

        if not HasPart2 then
           HasPart2 := (UDFCompare[I].uMarkers.Dist - UDFCompare[I].uMarkers.Dist_nearest) > 1;
      end
      else 
        found := false;

      if not found then
      Begin
           HasPart2 := true;

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           str2 := '-' + #$9 + '-';
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             str2 :=  str2 + #$9 + '-';

           str2 :=  str2 + #$9 + '-';
           
           if StatBox.iAccuracy.Checked then
             str2 := str2 + #$9 + '-' + #$9 + '-';

           iReport.SelAttributes.Color := clRed;
           iReport.Lines.Add(IntToStr(I+1) + #$9 + '-' + #$9 + '-' + #$9 +
                  '-' + #$9 + #$9 + Markers[UDFCompare[I].N].MarkerName +
                  #$9 + csx + #$9 + csy + #$9 + csh + str2);
      End;

    end;  /// tablekind = 25 end

    if tableKind = 26 then
    for I := 0 to MarkersUDFCount - 1 do
    if ((UDFCompare[I].uMarkers.Dist - UDFCompare[I].uMarkers.Dist_nearest) > 1) or
       (UDFCompare[I].uMarkers.I = -1)  then
    begin

      found := (UDFCompare[I].uMarkers.I_nearest > -1) and
               (UDFCompare[I].uMarkers.I_nearest < Length(Markers));

      if found then
      begin

        str := Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName;
        n := 0;
        while Pos ('_', str) > 0 do
        begin
           j := n;
           n := Pos ('_', str);
           str  := Copy(str, n+1, length(str)-n);
           str2 := Copy(Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName,
                  j+1, n-1);
           if j > 0 then
             str3 := Copy(Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName,
                  1, j-1)
           else
             str3 := '';
        end;

        if AnsiUpperCase(str2[1]) <> 'L' then
           str2 := 'L' + str2;

        if StatBox.iFull.Checked then
           str := Markers[UDFCompare[I].uMarkers.I_nearest].MarkerName;

        P.x := Markers[UDFCompare[I].N].x;
        P.y := Markers[UDFCompare[I].N].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));

        BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
        if Markers[UDFCompare[I].N].Hgeo <> 0 then
          csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

        str := str3 + #$9 + str2 + #$9 + str + #$9 + 
               Markers[UDFCompare[I].N].MarkerName + #$9 + 
               csx + #$9 + csy + #$9 + csh;

        P.x := Markers[UDFCompare[I].uMarkers.I_nearest].x;
        P.y := Markers[UDFCompare[I].uMarkers.I_nearest].y;
        P   := LatLongToPoint(MapToBL(P.x, P.y));
        BLToCS(P.x, P.y, 0, MapFm.CoordSysN);

        if CoordinateSystemList[MapFm.CoordSysN].ProjectionType <> 1 then
           str2 := csx + #$9 + csy
        else
           str2 :=  csx + #$9 + csy + #$9 + csh;       {проектные}

        str2 := str2 + #$9 + Format('%.3f',[UDFCompare[I].uMarkers.Dist_nearest]);
           
        if StatBox.iAccuracy.Checked then
           str2 := str2 + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add1])
                        + #$9 + Format('%.3f',[Markers[UDFCompare[I].N].Add2]);

        Ordinary;

        iReport.Lines.Add(IntToStr(I+1) + #$9 + str + #$9 + str2);
      end
      else 
        found := false;

      if not found then
      Begin

           P.x := Markers[UDFCompare[I].N].x;
           P.y := Markers[UDFCompare[I].N].y;
           P   := LatLongToPoint(MapToBL(P.x, P.y));

           BLToCS(P.x, P.y, Markers[UDFCompare[I].N].H, MapFm.CoordSysN);
           if Markers[UDFCompare[I].N].Hgeo <> 0 then
              csH  := Format('%.3f',[Markers[UDFCompare[I].N].Hgeo]);

           str2 := '-' + #$9 + '-';
           if CoordinateSystemList[MapFm.CoordSysN].ProjectionType = 1 then
             str2 :=  str2 + #$9 + '-';

           str2 :=  str2 + #$9 + '-';

           if StatBox.iAccuracy.Checked then
             str2 := str2 + #$9 + '-' + #$9 + '-';

           iReport.SelAttributes.Color := clRed;
           iReport.Lines.Add(IntToStr(I+1) + #$9 + '-' + #$9 + '-' + #$9 +
                  '-' + #$9 + #$9 + Markers[UDFCompare[I].N].MarkerName +
                  #$9 + csx + #$9 + csy + #$9 + csh + str2);
      End;

    end;  /// tablekind = 26 end




    SL.Destroy;
  end;

var I :Integer;
    LoopStat:TKnotStat;
begin
  WebC.Hide;

  if not isReady then
    exit;

  iRoutesL.Enabled := iRoutes.Checked and iRoutes.Enabled;
  Csys.Visible := (iLoopsP.Enabled or iLoopsM.Enabled) and
     (iLC.Checked or iLK.Checked or iLP.Checked or iCompUDF.Checked);
  iAccuracy.Visible := iCompUDF.Enabled and iCompUdf.Checked;
  iFull.Visible := Csys.Visible;

  Memo.Lines.Clear;

  Memo.Lines.Add('<body>');
  TRY
    Memo.Lines.Add('<h1 style = "text-align: center">'+ inf[128] +'</h1>');

    /// AREA & ROUTES

    if iArea.Checked or iRoutes.Checked then
      Memo.Lines.Add('<h2>'+ GroupBox1.Caption +'</h2>');

    if iArea.Checked then
    begin
       Memo.Lines.Add('<p><strong>'+ iArea.Caption +'</strong>');
       Memo.Lines.Add('<br />'+inf[53] + Format('%n',[FrameArea]) + inf[40]+
                       '<sup>2</sup>');
       Memo.Lines.Add('<br />'+inf[59] + Format('%n',[FramePerimeter]) + inf[40]);
       Memo.Lines.Add('<br />'+inf[129] + IntToStr(FrameCount-1)+'</p>');
    end;

    if iRoutes.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iRoutes.Caption +'</strong>');
      Memo.Lines.Add('<br />'+ inf[54] + IntToStr(RouteCount) );
      Memo.Lines.Add('<br />'+ inf[55] + IntToStr(GalsCount));
      Memo.Lines.Add('<br />'+ inf[56] + Format('%n',[RoutesAllSize])  + inf[40]);
      Memo.Lines.Add('<br />'+ inf[57] + Format('%n',[RoutesMeanSize]) + inf[40]+'</p>');
    end;

    if iRoutesL.Checked and iRoutesL.Enabled then
    begin
      Memo.Lines.Add('<p><strong>'+ iRoutesL.Caption +'</strong>');
      AddHTMLTable(3);
      Memo.Lines.Add('<br /></p>');
    end;

    /// TRACK

    if iTrack.Checked or iSlips.Checked or iCompare.Checked then
       Memo.Lines.Add('<h2>'+ GroupBox2.Caption +'</h2>');

    if iTrack.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iTrack.Caption +'</strong>');
      Memo.Lines.Add('<br />'+ inf[77] + Format('%n',[Trs.TrackL]) + inf[40]);
      Memo.Lines.Add('<br />'+ inf[78] + IntToStr(Trs.EpCount));
      Memo.Lines.Add('<br />'+ inf[79] + DateTimeToStr(Trs.MinT));
      Memo.Lines.Add('<br />'+ inf[80] + DateTimeToStr(Trs.MaxT));
      Memo.Lines.Add('<br />'+ inf[81] + IntToStr(Trs.SlipCount));
      Memo.Lines.Add('<br />'+ inf[82] + IntToStr(Trs.EpOnRoutes) + ' ('+IntToStr(Trs.PrOnRoutes)+' %)');
      Memo.Lines.Add('<br />'+ inf[225] +  Format('%n',[Trs.AvgSpd]) +' '+inf[35]);

      if Trs.AvgFSpd > 0 then
        Memo.Lines.Add('<br />'+ inf[226] +  Format('%n',[Trs.AvgFSpd]) +' '+inf[35]);

      if Trs.AvgRSpd > 0 then
        Memo.Lines.Add('<br />'+ inf[227] +  Format('%n',[Trs.AvgRSpd]) +' '+inf[35]);

      Memo.Lines.Add('<br /></p>');
    end;

    if iTrackRoutes.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iTrackRoutes.Caption +'</strong>');
      AddHTMLTable(1);
      Memo.Lines.Add('<br /></p>');
    end;

    if iSlips.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iSlips.Caption +'</strong>');
      AddHTMLTable(0);
      Memo.Lines.Add('<br /></p>');
    end;

    if iCompare.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iCompare.Caption +'</strong>');
      CompareStat;
      Memo.Lines.Add('<br />'+inf[132]+ IntToStr(CommonPts));
      if commonPts > 0 then
      begin
        Memo.Lines.Add('<br />'+inf[135] + inf[133] + FormatFloat('0.000',StDev));
        if StDevH > 0 then
          Memo.Lines.Add('<br />'+inf[135] + inf[134] + FormatFloat('0.000',StDevH));
        Memo.Lines.Add('<br />'+inf[136] + inf[133] + FormatFloat('0.000',Avg));
        if StDevH > 0 then
          Memo.Lines.Add('<br />'+inf[136] + inf[134] + FormatFloat('0.000',AvgH));

        Memo.Lines.Add('<br />'+inf[137] + inf[133] + FormatFloat('0.000',Max));

        if StDevH > 0 then
          Memo.Lines.Add('<br />'+inf[137] + inf[134] + FormatFloat('0.000',MaxH));
        
      end;

      if err then
      begin
        Memo.Lines.Add('<br /><span style="color: #ff0000;">'+inf[138]+'</span>');
      end;

      Memo.Lines.Add('<br /></p>');
    end;

    /// LOOPS

    if (iLoopsP.Enabled and iLoopsP.Checked) or
     (iLoopsM.Enabled and iLoopsM.Checked) then
        Memo.Lines.Add('<h2>'+ GroupBox3.Caption +'</h2>');

    if iLoopsP.Enabled and iLoopsP.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iLoopsP.Caption +'</strong>');
      LoopStat := GetKnotStat(false);
      Memo.Lines.Add('<br />'+inf[139]+ IntToStr(LoopStat.Count));
      Memo.Lines.Add('<br />'+inf[140]+ IntToStr(LoopStat.InArea));

      if abs(LoopStat.SizeMin - LoopStat.SizeMax) < 0.001 then
       Memo.Lines.Add('<br />'+inf[142]+': '
                         + FormatFloat('0.0',LoopStat.AvgSize))
      else
         Memo.Lines.Add('<br />'+inf[142] + inf[144]
           + FormatFloat('0.00', LoopStat.AvgSize)
           +' (' + inf[145] + FormatFloat('0.0',LoopStat.SizeMin) + inf[146]
           + FormatFloat('0.0',LoopStat.SizeMax)+')');

      Memo.Lines.Add('<br />'+inf[141]+ IntToStr(LoopStat.Pickets));

      if LoopStat.PMin = LoopStat.PMax then
        Memo.Lines.Add('<br />'+inf[143]+': '+
                         FormatFloat('0.0', LoopStat.AvgPicketsByLoop))
      else
         Memo.Lines.Add('<br />'+inf[143] + inf[144]
           + FormatFloat('0.00',LoopStat.AvgPicketsByLoop)
           +' (' + inf[145] +  IntTostr(LoopStat.PMin) + inf[146]
           + IntTostr(LoopStat.PMax)+')');


      if FrameArea > 0 then
        Memo.Lines.Add('<br />'+inf[147]+ Formatfloat('  0.000',
                      (LoopStat.InArea/FrameArea*1E6)) + inf[148]+'<sup>2</sup>');

      Memo.Lines.Add('<br /></p>');
      if iLC.Checked then
      begin
        Memo.Lines.Add('<p><strong>'+ inf[173] +'</strong>');
        AddHTMLTable(10);
        Memo.Lines.Add('<br /></p>');
      end;

      if iLK.Checked then
      begin
        Memo.Lines.Add('<p><strong>'+ inf[174] +'</strong>');
        AddHTMLTable(11);
        Memo.Lines.Add('<br /></p>');
      end;

      if iLP.Checked then
      begin
        Memo.Lines.Add('<p><strong>'+ inf[175] +'</strong>');
        AddHTMLTable(12);
        Memo.Lines.Add('<br /></p>');
      end;

      if iCompUDF.Checked then
      begin
        Memo.Lines.Add('<h2>'+ inf[176] +'</h2>');
        Memo.Lines.Add('<p><strong>'+ inf[192] +'</strong>');
        AddHTMLTable(15);
        Memo.Lines.Add('<br /></p>');
        if HasPart2 then
        Begin
          Memo.Lines.Add('<p><strong>'+ inf[193] +'</strong>');
          AddHTMLTable(16);
          Memo.Lines.Add('<br /></p>');
        End;
        if iAccuracy.Checked then
           Memo.Lines.Add('<p>'+inf[190]+'</p>');
      end;

    end;




    if iLoopsM.Enabled and iLoopsM.Checked then
    begin
      Memo.Lines.Add('<p><strong>'+ iLoopsM.Caption +'</strong>');
      LoopStat := GetKnotStat(true);
  
      Memo.Lines.Add('<br />'+inf[139]+ IntToStr(LoopStat.Count));
      Memo.Lines.Add('<br />'+inf[140]+ IntToStr(LoopStat.InArea));
       
      if abs(LoopStat.SizeMin - LoopStat.SizeMax) < 0.001 then
        Memo.Lines.Add('<br />'+inf[142]+': '
                         + FormatFloat('0.0',LoopStat.AvgSize))
      else
       Memo.Lines.Add('<br />'+inf[142] + inf[144]
           + FormatFloat('0.00', LoopStat.AvgSize)
           +' (' + inf[145] + FormatFloat('0.0',LoopStat.SizeMin) + inf[146]
           + FormatFloat('0.0',LoopStat.SizeMax)+')');
 
      Memo.Lines.Add('<br />'+inf[141]+ IntToStr(LoopStat.Pickets));

    
      if LoopStat.PMin = LoopStat.PMax then
        Memo.Lines.Add('<br />'+inf[143]+': '+
                         FormatFloat('0.0', LoopStat.AvgPicketsByLoop))
      else
        Memo.Lines.Add('<br />'+inf[143] + inf[144]
           + FormatFloat('0.00',LoopStat.AvgPicketsByLoop)
           +' (' + inf[145] +  IntTostr(LoopStat.PMin) + inf[146]
           + IntTostr(LoopStat.PMax)+')');

      if FrameArea > 0 then      
        Memo.Lines.Add('<br />'+inf[147] + Formatfloat('  0.000',
                      LoopStat.InArea/FrameArea*1E6) + inf[148]+'<sup>2</sup>');
      Memo.Lines.Add('<br /></p>');


      if iLC.Checked then
      begin
        Memo.Lines.Add('<p><strong>'+ inf[173] +'</strong>');
        AddHTMLTable(20);
        Memo.Lines.Add('<br /></p>');
      end;

      if iLK.Checked then
      begin
        Memo.Lines.Add('<p><strong>'+ inf[174] +'</strong>');
        AddHTMLTable(21);
        Memo.Lines.Add('<br /></p>');
      end; 

      if iLP.Checked then
      begin
        Memo.Lines.Add('<p><strong>'+ inf[175] +'</strong>');
        AddHTMLTable(22);
        Memo.Lines.Add('<br /></p>');
      end; 

      
      
      if iCompUDF.Checked then
      begin
        Memo.Lines.Add('<h2>'+ inf[176] +'</h2>');
        Memo.Lines.Add('<p><strong>'+ inf[192] +'</strong>');
        AddHTMLTable(25);
        Memo.Lines.Add('<br /></p>');
        if HasPart2 then
        Begin
          Memo.Lines.Add('<p><strong>'+ inf[193] +'</strong>');
          AddHTMLTable(26);
          Memo.Lines.Add('<br /></p>');
        End;
        if iAccuracy.Checked then
           Memo.Lines.Add('<p>'+inf[190]+'</p>');
           
      end;
      
    end;
    
  EXCEPT
  END;






  Memo.Lines.Add('</body>');
  Memo.Lines.SaveToFile(MyDir+'Tmp\Report.html');

  WebC.Show;
  WebC.Navigate(MyDir+'Tmp\Report.html');

{  iReport.Lines.Clear;
  iReport.Hide;

  iReport.Perform(EM_LIMITTEXT, maxint, 0);
  iRoutesL.Enabled := iRoutes.Checked and iRoutes.Enabled;

  TRY

  Csys.Visible := (iLoopsP.Enabled or iLoopsM.Enabled) and
     (iLC.Checked or iLK.Checked or iLP.Checked or iCompUDF.Checked);
  iAccuracy.Visible := iCompUDF.Enabled and iCompUdf.Checked;
  iFull.Visible := Csys.Visible;


  if iTables.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.Lines.Add('#2#');
    Insert2;
    iReport.Lines.Clear;
  end;

  iReport.SelAttributes.Size := 18;
  iReport.SelAttributes.Style := [fsBold];
  iReport.Paragraph.Alignment := taCenter;
  iReport.Lines.Add(inf[128]);
  iReport.Lines.Add('');
  iReport.Paragraph.Alignment := taLeftJustify;

  if iArea.Checked or iRoutes.Checked then
  begin
    iReport.SelAttributes.Size := 12;
    iReport.SelAttributes.Style := [fsBold];
    iReport.Lines.Add(GroupBox1.Caption);
    iReport.Lines.Add('');
  end;

  if iArea.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iArea.Caption);
    Ordinary;
    if iTables.Checked then
    begin
       iReport.Lines.Add(inf[53] + Format('%n',[FrameArea]) + inf[40]+ '#2#');
       Insert2;
    end
     else
       iReport.Lines.Add(inf[53] + Format('%n',[FrameArea]) + inf[58]);
    Ordinary;
    iReport.Lines.Add(inf[59] + Format('%n',[FramePerimeter]) + inf[40]);
    Ordinary;
    iReport.Lines.Add(inf[129] + IntToStr(FrameCount));
    Ordinary;
    iReport.Lines.Add('');
  end;

  if iRoutes.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iRoutes.Caption);
    iReport.SelAttributes.Style := [];
     Ordinary;
    iReport.Lines.Add(inf[54] + IntToStr(RouteCount));
     Ordinary;
    iReport.Lines.Add(inf[55] + IntToStr(GalsCount));
     Ordinary;
    iReport.Lines.Add(inf[56] + Format('%n',[RoutesAllSize])  + inf[40]);
     Ordinary;
    iReport.Lines.Add(inf[57] + Format('%n',[RoutesMeanSize]) + inf[40]);
     Ordinary;
    iReport.Lines.Add('');
  end;

  if iRoutesL.Checked and iRoutesL.Enabled then
  begin
    Ordinary;
    iReport.Lines.Add('');
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iRoutesL.Caption);
    Ordinary;
    if iTables.Checked then
      AddTable(3)
    else
    begin
      AddFlatTable(3);
      Ordinary;
      iReport.Lines.Add('');
    end;
  end;

  if iTrack.Checked or iSlips.Checked or iCompare.Checked then
  begin
    iReport.SelAttributes.Size := 12;
    iReport.SelAttributes.Style := [fsBold];
    iReport.Lines.Add(GroupBox2.Caption);
     Ordinary;
    iReport.Lines.Add('');
  end;

  if iTrack.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iTrack.Caption);
    iReport.SelAttributes.Style := [];

    Ordinary;
    iReport.Lines.Add(inf[77] + Format('%n',[Trs.TrackL]) + inf[40]);
    Ordinary;
    iReport.Lines.Add(inf[78] + IntToStr(Trs.EpCount));
    Ordinary;
    iReport.Lines.Add(inf[79] + DateTimeToStr(Trs.MinT));
    Ordinary;
    iReport.Lines.Add(inf[80] + DateTimeToStr(Trs.MaxT));
    Ordinary;
    iReport.Lines.Add(inf[81] + IntToStr(Trs.SlipCount));
    Ordinary;
    iReport.Lines.Add(inf[82] + IntToStr(Trs.EpOnRoutes) + ' ('+IntToStr(Trs.PrOnRoutes)+' %)');
    Ordinary;
    iReport.Lines.Add(inf[225] +  Format('%n',[Trs.AvgSpd]) +' '+inf[35]);

    if Trs.AvgFSpd > 0 then
    begin
      Ordinary;
      iReport.Lines.Add(inf[226] +  Format('%n',[Trs.AvgFSpd]) +' '+inf[35]);
    end;

    if Trs.AvgRSpd > 0 then
    begin
      Ordinary;
      iReport.Lines.Add(inf[227] +  Format('%n',[Trs.AvgRSpd]) +' '+inf[35]);
    end;

    Ordinary;
    iReport.Lines.Add('');
  end;

  if iTrackRoutes.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iTrackRoutes.Caption);
    iReport.SelAttributes.Style := [];
    Ordinary;
    if iTables.Checked then
      AddTable(1)
    else
    begin
      AddFlatTable(1);
      Ordinary;
      iReport.Lines.Add('');
    end;
  end;

  if iSlips.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iSlips.Caption);
    iReport.SelAttributes.Style := [];
    Ordinary;
    if iTables.Checked then
      AddTable(0)
    else
    begin
      AddFlatTable(0);
      Ordinary;
      iReport.Lines.Add('');
    end;
  end;

  if iCompare.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iCompare.Caption);
     Ordinary;
    CompareStat;
    iReport.Lines.Add(inf[132]+ IntToStr(CommonPts));
    if commonPts > 0 then
    begin
      Ordinary;
      iReport.Lines.Add(inf[135] + inf[133] + FormatFloat('0.000',StDev));
      Ordinary;
      if StDevH > 0 then
         iReport.Lines.Add(inf[135] + inf[134] + FormatFloat('0.000',StDevH));
      Ordinary;
      iReport.Lines.Add(inf[136] + inf[133] + FormatFloat('0.000',Avg));
      Ordinary;
      if StDevH > 0 then
         iReport.Lines.Add(inf[136] + inf[134] + FormatFloat('0.000',AvgH));
      Ordinary;
      iReport.Lines.Add(inf[137] + inf[133] + FormatFloat('0.000',Max));
      Ordinary;
      if StDevH > 0 then
         iReport.Lines.Add(inf[137] + inf[134] + FormatFloat('0.000',MaxH));   
    end;

    if err then
    begin
       iReport.SelAttributes.Color := clRed;
       iReport.SelAttributes.Size := 10;
       iReport.Lines.Add(inf[138]);
    end;
    Ordinary;
    iReport.Lines.Add('');
  end;

  if (iLoopsP.Enabled and iLoopsP.Checked) or
     (iLoopsM.Enabled and iLoopsM.Checked) then
  begin
    Ordinary;
    iReport.SelAttributes.Size := 12;
    iReport.SelAttributes.Style := [fsBold];
    iReport.Lines.Add(GroupBox3.Caption);
    Ordinary;
    iReport.Lines.Add('');
  end;
  
  if iLoopsP.Enabled and iLoopsP.Checked then
  begin
    Ordinary;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iLoopsP.Caption);
    iReport.SelAttributes.Style := [];

    LoopStat := GetKnotStat(false);
    Ordinary;
    iReport.Lines.Add(inf[139]+ IntToStr(LoopStat.Count));
    Ordinary;
    iReport.Lines.Add(inf[140]+ IntToStr(LoopStat.InArea));
    
    Ordinary;
    if abs(LoopStat.SizeMin - LoopStat.SizeMax) < 0.001 then
       iReport.Lines.Add(inf[142]+': '
                         + FormatFloat('0.0',LoopStat.AvgSize))
    else
       iReport.Lines.Add(inf[142] + inf[144]
           + FormatFloat('0.00', LoopStat.AvgSize)
           +' (' + inf[145] + FormatFloat('0.0',LoopStat.SizeMin) + inf[146]
           + FormatFloat('0.0',LoopStat.SizeMax)+')');

    Ordinary;
    iReport.Lines.Add(inf[141]+ IntToStr(LoopStat.Pickets));

    Ordinary;
    if LoopStat.PMin = LoopStat.PMax then
       iReport.Lines.Add(inf[143]+': '+
                         FormatFloat('0.0', LoopStat.AvgPicketsByLoop))
    else
       iReport.Lines.Add(inf[143] + inf[144]
           + FormatFloat('0.00',LoopStat.AvgPicketsByLoop)
           +' (' + inf[145] +  IntTostr(LoopStat.PMin) + inf[146]
           + IntTostr(LoopStat.PMax)+')');

    Ordinary;
    if FrameArea > 0 then
    begin
      if itables.Checked then
      begin
        iReport.Lines.Add(inf[147]+ Formatfloat('  0.000',
                      (LoopStat.InArea/FrameArea*1E6)) + inf[148]+'#2#');
        Insert2;
      end
      else
         iReport.Lines.Add(inf[147]+ Formatfloat('  0.000',
                      (LoopStat.InArea/FrameArea*1E6)) + inf[148]+'2');
    end;
    Ordinary;
    iReport.Lines.Add('');

    if iLC.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[173]);
      iReport.SelAttributes.Style := [];

      if iTables.Checked then
        AddTable(10)
      else
      begin
        AddFlatTable(10);
        Ordinary;
        iReport.Lines.Add('');
      end;
    end;

    if iLK.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[174]);
      iReport.SelAttributes.Style := [];

      if iTables.Checked then
        AddTable(11)
      else
      begin
        AddFlatTable(11);
        Ordinary;
        iReport.Lines.Add('');
      end;
    end;

    if iLP.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[175]);
      iReport.SelAttributes.Style := [];
      if iTables.Checked then
        AddTable(12)
      else
      begin
        AddFlatTable(12);
        Ordinary;
        iReport.Lines.Add('');
      end;
    end;

    if iCompUDF.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[176]);
      iReport.SelAttributes.Style := [];

      if iTables.Checked then
      begin 
        Ordinary;
        iReport.Lines.Add(inf[192]);
        AddTable(15);
        if HasPart2 then
        Begin
          Ordinary;
          iReport.Lines.Add(inf[193]);
          AddTable(16);
        End;
        Ordinary;
        if iAccuracy.Checked then
           iReport.Lines.Add(inf[190]);
      end
      else
      begin
        AddFlatTable(15);
        Ordinary;
        iReport.Lines.Add('');
        if HasPart2 then
        begin
          Ordinary;
          iReport.Lines.Add(inf[193]);
          AddFlatTable(16);
          Ordinary;
          iReport.Lines.Add('');
        end;
        Ordinary;
        if iAccuracy.Checked then
           iReport.Lines.Add(inf[190]);
      end;
    end;

  end;

  if iLoopsM.Enabled and iLoopsM.Checked then
  begin
    iReport.SelAttributes.Size := 10;
    iReport.SelAttributes.Style := [fsItalic];
    iReport.Lines.Add(iLoopsM.Caption);
    iReport.SelAttributes.Style := [];

    LoopStat := GetKnotStat(true);
    Ordinary;
    iReport.Lines.Add(inf[139]+ IntToStr(LoopStat.Count));
    Ordinary;
    iReport.Lines.Add(inf[140]+ IntToStr(LoopStat.InArea));
    Ordinary;
    if abs(LoopStat.SizeMin - LoopStat.SizeMax) < 0.001 then
       iReport.Lines.Add(inf[142]+': '
                         + FormatFloat('0.0',LoopStat.AvgSize))
    else
       iReport.Lines.Add(inf[142] + inf[144]
           + FormatFloat('0.00', LoopStat.AvgSize)
           +' (' + inf[145] + FormatFloat('0.0',LoopStat.SizeMin) + inf[146]
           + FormatFloat('0.0',LoopStat.SizeMax)+')');
    Ordinary;
    iReport.Lines.Add(inf[141]+ IntToStr(LoopStat.Pickets));

    Ordinary;
    if LoopStat.PMin = LoopStat.PMax then
       iReport.Lines.Add(inf[143]+': '+
                         FormatFloat('0.0', LoopStat.AvgPicketsByLoop))
    else
       iReport.Lines.Add(inf[143] + inf[144]
           + FormatFloat('0.00',LoopStat.AvgPicketsByLoop)
           +' (' + inf[145] +  IntTostr(LoopStat.PMin) + inf[146]
           + IntTostr(LoopStat.PMax)+')');

    Ordinary;
    if FrameArea > 0 then
    begin
      if itables.Checked then
      begin
        iReport.Lines.Add(inf[147] + Formatfloat('  0.000',
                      LoopStat.InArea/FrameArea*1E6) + inf[148]+'#2#');
        Insert2;
      end
      else
        iReport.Lines.Add(inf[147] + Formatfloat('  0.000',
                      LoopStat.InArea/FrameArea*1E6) + inf[148]+'2');
    end;
    Ordinary;
    iReport.Lines.Add('');

    if iLC.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[173]);
      iReport.SelAttributes.Style := [];

      if iTables.Checked then
        AddTable(20)
      else
      begin
        AddFlatTable(20);
        Ordinary;
        iReport.Lines.Add('');
      end;
    end;

    if iLK.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[174]);
      iReport.SelAttributes.Style := [];
      if iTables.Checked then
        AddTable(21)
      else
      begin
        AddFlatTable(21);
        Ordinary;
        iReport.Lines.Add('');
      end;
    end;

    if iLP.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[175]);
      iReport.SelAttributes.Style := [];
      if iTables.Checked then
        AddTable(22)
      else
      begin
        AddFlatTable(22);
        Ordinary;
        iReport.Lines.Add('');
      end;
    end;

    if iCompUDF.Checked then
    begin
      iReport.SelAttributes.Size := 10;
      iReport.SelAttributes.Style := [fsItalic];
      iReport.Lines.Add(inf[176]);
      iReport.SelAttributes.Style := [];
      if iTables.Checked then
      begin
        Ordinary;
        iReport.Lines.Add(inf[192]);
        AddTable(25);
        
        if HasPart2 then
        begin
          Ordinary;
          iReport.Lines.Add(inf[193]);
          AddTable(26);
        end;
        Ordinary;
        if iAccuracy.Checked then
           iReport.Lines.Add(inf[190]);
      end
      else
      begin
        Ordinary;
        iReport.Lines.Add(inf[192]);
        AddFlatTable(25);
        Ordinary;
        iReport.Lines.Add('');
        if HasPart2 then
        begin
          Ordinary;
          iReport.Lines.Add(inf[193]);
          AddFlatTable(26);
          Ordinary;
          iReport.Lines.Add('');
        end;
        Ordinary;
        if iAccuracy.Checked then
           iReport.Lines.Add(inf[190]);
      end;
    end;

  end;

  iReport.Lines.Add('');
  EXCEPT
  END;

  iReport.Show; }

end;

procedure TStatBox.iReportKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = vk_F5 then
 begin
    if iTables.Checked then
     begin
      iTables.Checked := not iTables.Checked;
      iArea.OnClick(nil);
      iTables.Checked := not iTables.Checked;
     end;
     iArea.OnClick(nil);
 end;
end;

procedure TStatBox.SaveDialog1TypeChange(Sender: TObject);
begin
 FormatN := SaveDialog1.FilterIndex;
end;


procedure TStatBox.Button1Click(Sender: TObject);
var FileName:String;
    H: IHTMLDocument2;
begin
  SaveDialog1.FilterIndex := 1;
  if not SaveDialog1.Execute then
    exit;

  FileName := SaveDialog1.FileName;
  case FormatN of
     1: if AnsiLowerCase(Copy(FileName, Length(FileName)-4,5)) <> '.html' then
          FileName := FileName + '.html';
     2: if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.txt' then
          FileName := FileName + '.txt';
  end;

  if Fileexists(FileName) then
     if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
       exit;

  case FormatN of
     1: Memo.Lines.SaveToFile(FileName);
     2: begin
        H := WebC.Document as IHTMLDocument2;
        Memo.Text := H.body.innerText;
        Memo.Lines.SaveToFile(FileName);
     end;
  end;

 { FileName := SaveDialog1.FileName;
  case FormatN of
     1: if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.rtf' then
          FileName := FileName + '.rtf';
     2: if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> '.txt' then
          FileName := FileName + '.txt';
  end;


  if Fileexists(FileName) then
     if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
       exit;

  case FormatN of
     1: iReport.Lines.SaveToFile(FileName);
     2: begin
        iReport.PlainText := true;
        iReport.Lines.SaveToFile(FileName);
        iReport.PlainText := false;
     end;
  end;  }

end;

procedure TStatBox.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TStatBox.CompareStat;
var I, j, n, lastn, c:Integer;
    S :TStringList;  str:string;
    L, dh :Double; find, HGeo:Boolean;
begin    
   SetCurrentDir(StatDir);
   S := TStringList.Create;

   avg := 0;    stdev := 0;  max := 0;   n:= 0;  err := false; 
   stdevh:= 0;  maxh := 0;   avgh := 0;  dh := 0;
   
   lastn := 0;  c:= 0; 

   HGeo := TrS.AvgHGeo <> 0;
   
   for I := 0 to Length(MainTrack)- 1 do
   begin
      find := false;
      str := '';
      if Length(ReductedMainTrack) > I then
      if Abs(ReductedMainTrack[i].T - MainTrack[i].T) <= mindT then
      Begin
        Find := true;
        j := I;
      End;

      if not Find then
        for n := lastn to Length(ReductedMainTrack)-1 do
          if Abs(ReductedMainTrack[n].T - MainTrack[i].T) <= mindT then
          Begin
             Find := true;
             Lastn := n;
             j := n;
          End;

      if Find then
      begin
         L := sqrt(sqr(ReductedMainTrack[j].x-MainTrack[i].x) 
                 + sqr(ReductedMainTrack[j].y-MainTrack[i].y)); 


         if HGeo then
            dh := ReductedMainTrack[j].Hgeo-MainTrack[i].Hgeo
         else
            dh := ReductedMainTrack[j].H-MainTrack[i].H;
             
         S.Add( ReductedMainTrack[j]._T + #$9 + 
                FloatToStr(ReductedMainTrack[j].x-MainTrack[i].x) + #$9 +
                FloatToStr(ReductedMainTrack[j].y-MainTrack[i].y) + #$9 +
                FloatToStr(ReductedMainTrack[j].H-MainTrack[i].H) + #$9 +
                FloatToStr(ReductedMainTrack[j].Hgeo-MainTrack[i].Hgeo) + #$9 +
                FloatToStr(L));
                 
         if L> 1E6 then
         begin
           err := true;
           continue;
         end;
             
         inc(c);
         avg := avg + L;
         if L > max then
           max := L;
           
         avgh := avgh + dh;
         if abs(dh) > maxh then
           maxh := abs(dh);
           
         stdev := stdev + sqr(L);  
         stdevh := stdevh + sqr(dH);
      end

      
   end;

   if c > 0 then
   begin
     avg   := avg/c; 
     stdev := sqrt(stdev/c);
     avgh   := avgh/c; 
     stdevh := sqrt(stdevh/c);
   end;

   CommonPts := C;
   
   S.SaveToFile('Data\Compare.txt');
   S.Free;
end;

procedure TStatBox.CompareTrkClick(Sender: TObject);
var S, DopSt:String;
begin    
  CompareStat;
  Dopst := ' -l_Data\Graph\'+Lang+'.txt -thick -menu -rnav -readonly -n -gray';
  s := 'Graph.exe Data\Compare.txt Data\Graph\'+ Lang+'\Dev_plan.chs'+Dopst;
  Winexec(PAnsiChar(S) , sw_restore);

  if stdevh > 0 then
  begin
    s := 'Graph.exe Data\Compare.txt Data\Graph\'+ Lang+'\Dev_hgt.chs'+Dopst;
    Winexec(PAnsiChar(S) , sw_restore);
  end;
end;

procedure TStatBox.CsysClick(Sender: TObject);
begin
  MapFm.Csys.OnClick(nil);
  Csys.Caption := MapFm.Csys.Caption;
  iArea.OnClick(nil);
end;

procedure TStatBox.CsysMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Csys.Hint := Csys.Caption;
  Canvas.Font := Csys.Font;
  Csys.ShowHint := Canvas.TextWidth(Csys.Caption) > Csys.Width; 
end;

procedure TStatBox.EstimClick(Sender: TObject);
begin
  MapFm.Estim.Click;
end;

procedure TStatBox.FormShow(Sender: TObject);
begin
  isReady := false;
  iReport.Lines.Clear;

  if (FrameCount=0) and (RouteCount = 0) and (Length(MainTrack) = 0)and
     (MarkersAreLoops = false) and (KnotCount = 0) then
  begin
    close;
    exit;
  end;

  if FrameCount = 0 then
  begin
     iArea.Checked := false;
     iArea.Enabled := false;
  end
  else
  begin
     iArea.Checked := true;
     iArea.Enabled := true;
  end;

  if RouteCount = 0 then
  begin
     iRoutes.Checked := false;
     iRoutes.Enabled := false;
  end
  else
  begin
     iRoutes.Checked := true;
     iRoutes.Enabled := true;
  end;
  if Length(MainTrack) = 0 then
  begin
     iTrack.Checked := false;
     iTrack.Enabled := false;
     iSlips.Checked := false;
     iSlips.Enabled := false;
     iTrackRoutes.Enabled := false;
     iTrackRoutes.Checked := false;
  end
  else
  begin
     TRs := GetTrackStat(MainTrack);
     iTrack.Checked := true;
     iTrack.Enabled := true;

     iSlips.Enabled := false;
     iTrackRoutes.Enabled := false;
     
     if Trs.EpOnRoutes > 0 then
        iTrackRoutes.Enabled := true;
     if Trs.SlipCount  > 0 then
        iSlips.Enabled := true;
  end;
  if (Length(MainTrack) > 0) and (Length(ReductedMainTrack) > 0) then
  begin
     iCompare.Enabled := true;
     CompareTrk.Visible := Fileexists(StatDir+'Graph.exe');  
  end
  else
  begin
     iCompare.Checked := false;
     iCompare.Enabled := false;
     CompareTrk.Visible := false;
  end;

  if not MarkersAreLoops then
  begin
     iLoopsM.Checked := false;
     iLoopsM.Enabled := false;
  end
  else
  begin
     iLoopsM.Checked := true;
     iLoopsM.Enabled := true;
  end;

  if KnotCount = 0 then
  begin
     iLoopsP.Checked := false;
     iLoopsP.Enabled := false;
  end
  else
  begin
     iLoopsP.Checked := true;
     iLoopsP.Enabled := true;
  end;

  if ((iLoopsM.Enabled = true) or (iLoopsP.Enabled = true))
     and ( (MarkersUDFCount > 0)and(Length(Markers) - MarkersUDFCount > 0) or
        ((KnotCount > 0) and (MarkersUDFCount > 0)) )  then
    iCompUdf.Enabled := true
  else
  begin
    iCompUdf.Checked := false;
    iCompUdf.Enabled := false;
  end;

  if (iLoopsP.Enabled or iLoopsM.Enabled) then
  begin
     iLC.Enabled := true;
     iLK.Enabled := true;
     iLP.Enabled := true;
  end
   else
   begin
     iLC.Checked := false;
     iLK.Checked := false;
     iLP.Checked := false;
     iLC.Enabled := false;
     iLK.Enabled := false;
     iLP.Enabled := false;
   end;

  Estim.Visible := iTrackRoutes.Enabled;

  if iLoopsP.Enabled and iLoopsM.Enabled then
  begin
    if ClickMode = 30 then
      iLoopsP.Checked := true
    else
      iLoopsM.Checked := true;
  end;

  Csys.Caption := MapFm.Csys.Caption;
  Csys.Visible := (iLoopsP.Enabled or iLoopsM.Enabled) and
     (iLC.Checked or iLK.Checked or iLP.Checked or iCompUDF.Checked);
  iFull.Visible := Csys.Visible;
  iAccuracy.Visible := iCompUDF.Enabled and iCompUdf.Checked;

  isReady := true;
  iArea.OnClick(nil);
end;

procedure TStatBox.GetUDFEstims(PB: TProgressBar);


  procedure FindNearest(UDF_I:Integer);
  var I, j : Integer;
      Lmin, L, x, y, xi, yi : Double;

      Lnum, Pktnum, Pktnum2, Lnum_I, Pktnum_I, Pktnum2_I : integer;
      ProfName, ProfName_I :string;  
  begin
    x := Markers[UDFCompare[UDF_I].N].x;
    y := Markers[UDFCompare[UDF_I].N].y;

    GetPrLPkt(Markers[UDFCompare[UDF_I].N].MarkerName, 
                       Lnum, Pktnum, Pktnum2, ProfName);
    
    Lmin := -1; 
    UDFCompare[UDF_I].uMarkers.I_nearest := -1;
    UDFCompare[UDF_I].uMarkers.Dist_nearest := -1;
    for I := 0 to Length(Markers) - 1 do
    if Markers[I].MarkerKind = 3 then
    begin
       xi := Markers[I].x;
       yi := Markers[I].y;
       L := sqrt( sqr(xi - x) + sqr(yi - y) );

       if (Lmin = -1) or (L < Lmin) or (abs(L - Lmin) < 0.1) then
       begin
          
          if (abs(L - Lmin) < 0.1) and (Lmin > -1) then     
          {спорна€ ситуаци€: дополнительно проверить по номеру расстановки}
          begin
             GetPrLPkt(Markers[I].MarkerName, Lnum_i, Pktnum_i, Pktnum2_i,
                    ProfName_i);
                   
             if not ((Lnum_i = Lnum) and (ProfName_i = ProfName)) then
                 continue;
          end;
          
          UDFCompare[UDF_I].uMarkers.I_nearest    := I;
          UDFCompare[UDF_I].uMarkers.Dist_nearest := L;
          Lmin := L;
       end;
    end;

    Lmin := -1;
    UDFCompare[UDF_I].uKnots.KnotI_nearest   := -1;
    UDFCompare[UDF_I].uKnots.PicketI_nearest := -1;
    UDFCompare[UDF_I].uKnots.Dist_nearest    := -1;
    for I := 0 to KnotCount - 1 do
    begin
       GetKnotPickets(KnotPoints[I], false);

       for j := 0 to PktCount - 1 do
       begin
         xi := KnotPoints[I].cx + Pkt[j].x;
         yi := KnotPoints[I].cy + Pkt[j].y;

         L := sqrt( sqr(xi - x) + sqr(yi - y) );

         if (Lmin = -1) or (L < Lmin) or (abs(L - Lmin) < 0.1) then
         begin
          
            if (abs(L - Lmin) < 0.1) and (Lmin > -1) then     
            {спорна€ ситуаци€: дополнительно проверить по номеру расстановки}
            begin
             if not((KnotPoints[I].L = Lnum)and(KnotPoints[I].Name = ProfName)) then
               continue;
            end;
            UDFCompare[UDF_I].uKnots.KnotI_nearest   := I;
            UDFCompare[UDF_I].uKnots.PicketI_nearest := j;
            UDFCompare[UDF_I].uKnots.Dist_nearest    := L;
            Lmin := L;
         end;
       end;
    end;

  end;

  procedure FindByName(UDF_I:Integer);
  var I, j : Integer; Uname :string;
      L, x, y, xi, yi : Double;
                      
      Lnum, Pktnum, Pktnum2, Lnum_I, Pktnum_I, Pktnum2_I : integer;
      ProfName, ProfName_I :string;   found : boolean;
  begin
    x := Markers[UDFCompare[UDF_I].N].x;
    y := Markers[UDFCompare[UDF_I].N].y;
    uName := Markers[UDFCompare[UDF_I].N].MarkerName;
    GetPrLPkt(uName, Lnum, Pktnum, Pktnum2, ProfName);

    if uName = '' then
      exit;
      
    UDFCompare[UDF_I].uMarkers.I    := -1;
    UDFCompare[UDF_I].uMarkers.Dist := -1;
    for I := 0 to Length(Markers) - 1 do
    if Markers[I].MarkerKind = 3 then
    begin
      GetPrLPkt(Markers[I].MarkerName, Lnum_i, Pktnum_i, Pktnum2_i,ProfName_i);
      if (Pos(Markers[I].MarkerName, uName) > 0) or
        (Lnum_i = Lnum) and (Pktnum_i = Pktnum)  and (Pktnum2_i = Pktnum2) and 
        (ProfName_i = ProfName) then
        begin
           xi := Markers[I].x;
           yi := Markers[I].y;
           L := sqrt( sqr(xi - x) + sqr(yi - y) );

           UDFCompare[UDF_I].uMarkers.I    := I;
           UDFCompare[UDF_I].uMarkers.Dist := L;

           break;
        end;

    end;

    found := false;
    UDFCompare[UDF_I].uKnots.KnotI   := -1;
    UDFCompare[UDF_I].uKnots.PicketI := -1;
    UDFCompare[UDF_I].uKnots.Dist    := -1;
    for I := 0 to KnotCount - 1 do
    if (KnotPoints[I].L = Lnum) and
       (KnotPoints[I].Name = ProfName) then
    begin
       GetKnotPickets(KnotPoints[I], false);
       for j := 0 to PktCount - 1 do
       Begin
        GetPrLPkt(Pkt[j].Name, Lnum_i, Pktnum_i, Pktnum2_I, ProfName_i);
       
        if (Pos(Pkt[j].Name, uName) > 0) or
           (Lnum_i = Lnum) and (Pktnum_i = Pktnum) and (Pktnum2_i = Pktnum2) and
           (ProfName_i = ProfName) then
        begin
          xi := KnotPoints[I].cx + Pkt[j].x;
          yi := KnotPoints[I].cy + Pkt[j].y;
          L := sqrt( sqr(xi - x) + sqr(yi - y) );
          UDFCompare[UDF_I].uKnots.KnotI   := I;
          UDFCompare[UDF_I].uKnots.PicketI := j;
          UDFCompare[UDF_I].uKnots.Dist    := L;

          found := true;
          break;
        end;
       End;
       if found then
         break;
    end;

  end;


var i, j, i1, i2, pg :Integer;
begin
  I1 := 0;
  PB.Position := 0;
  SetLength(UDFCompare, MarkersUDFCount);
  for I := 0 to Length(UDFCompare) - 1 do
  begin
    PG := round(I*100/Length(UDFCompare));
    if PB.Position <> PG then
    begin
      PB.Position := PG;
      PB.Repaint;
    end;
    for j := I1 to Length(Markers) - 1 do
    if Markers[j].MarkerKind = 10 then
    begin
       I1 := j + 1;
       UDFCompare[I].N := j;
       FindByName(I);
       FindNearest(I);
       break;
    end;
  end;

end;

end.
