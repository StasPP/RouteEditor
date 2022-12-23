unit USaveTrack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TrackFunctions, ExtCtrls, LangLoader, GeoClasses,
  GeoFunctions, GeoString, GeoTime;

type
  TTrackSaver = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    iXYH: TCheckBox;
    iBLH: TCheckBox;
    Angs: TCheckBox;
    dXYH: TCheckBox;
    GroupBox3: TGroupBox;
    RedXYH: TCheckBox;
    RedBLH: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    TimeSys: TRadioGroup;
    SepDate: TCheckBox;
    GroupBox4: TGroupBox;
    OlderCS: TRadioButton;
    newCS: TRadioButton;
    Csys: TStaticText;
    OldSys: TStaticText;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CsysClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OldSysClick(Sender: TObject);
    procedure newCSClick(Sender: TObject);
  private
    { Private declarations }
  public
    FN: String;
    { Public declarations }
  end;

var
  TrackSaver: TTrackSaver;

implementation

uses CoordSysFm, MapperFm, LoadTrack;

{$R *.dfm}

procedure TTrackSaver.Button1Click(Sender: TObject);

var S: TStringList;
    str: string;
    I, J, K, LastN, L: Integer;
    newX, newY, newH, iB, iL, iH : Double;
    FormatSettings:TFormatSettings;
const
    sep :char = #$9;
begin
  S := TStringList.Create;

  InitDTFormat(FormatSettings);

  S.Add(inf[45] + TimeSys.Items[TimeSys.ItemIndex]);                //// 1) Time
  if SepDate.Checked then
  begin
     str := S[0];
     str[6] := sep;
     S[0] := str;
  end;

  L := S.Count-1;
  case NewCS.Checked of
    false:
       if MainTrackDatum = -1 then
         J := CoordinateSystemList[MainTrackCS].ProjectionType
         else
           J := MaintrackCS;
    true:
        J := CoordinateSystemList[MapFm.CoordSysN].ProjectionType;

  end;

  if iXYH.Checked then         //// 2) ixyh
    case J of
      0: S[l] := S[l] + sep + inf[46] + inf[0] +#176+ sep +
                 inf[46] + inf[1] +#176 + sep +
                 inf[46] + inf[51]+','+ inf[40];

      1: S[l] := S[l] + sep + inf[46] +inf[2] + sep + inf[46] +inf[3] + inf[46] +inf[4];

      2..4: S[l] := S[l] + sep + inf[46] + inf[8]
                         + sep + inf[46] + inf[7]
                         + sep + inf[46] + inf[52]+','+ inf[40];
    end;

  if iBLH.Checked then      //// 3) iblh
      S[l] := S[l] + sep + inf[46] + inf[0] +#176+ ' (WGS)'
                   + sep + inf[46] + inf[1] +#176+ ' (WGS)'
                   + sep + inf[46] + inf[51]+','+ inf[40];

  if Angs.Checked then     /// 4) angs
      S[l] := S[l] + sep + inf[48]+', ' +#176
                   + sep + inf[49]+', ' +#176
                   + sep + inf[50]+', ' +#176;

  if dXYH.Checked then     /// 5) dxyh
      S[l] := S[l] + sep + 'dX ' + inf[40]
                   + sep + 'dY,' + inf[40]
                   + sep + 'dH,' + inf[40];

  if redXYH.Checked then    //// 6) iblh
    case J of
      0: S[l] := S[l] + sep + inf[47] + inf[0] +#176+ sep +
                 inf[47] + inf[1] +#176 + sep +
                 inf[47] + inf[51]+','+ inf[40];

      1: S[l] := S[l] + sep + inf[47] +inf[2] + sep + inf[47] +inf[3] + inf[47] +inf[4];

      2..4: S[l] := S[l] + sep + inf[47] + inf[8]
                         + sep + inf[47] + inf[7]
                         + sep + inf[47] + inf[52]+','+ inf[40];
    end;

  if redBLH.Checked then      //// 7) redblh
      S[l] := S[l] + sep + inf[47] + inf[0] +#176+ ' (WGS)'
                   + sep + inf[47] + inf[1] +#176+ ' (WGS)'
                   + sep + inf[47] + inf[51]+','+ inf[40];

  LastN:=0;
                   
  for I := 0 to Length(RedTrack) - 1 do
  begin
     if TimeSys.ItemIndex = 0 then
      S.Add(ReductedMainTrack[I]._T)                //// 1) Time
        else
          S.Add(DateTimeToStr2(GPSToUTC(ReductedMainTrack[I].T) ,FormatSettings));

     L := S.Count-1;

     if SepDate.Checked then
     begin
        K := Pos(' ',S[L]);
        Str := S[L];
        if K > 0 then
        begin
          str[K] := sep;
          S[L] := str;
        end;
     end;



     if iXYH.Checked then         //// 2) ixyh
     Begin
      case NewCS.Checked of
        false :
        case J of
           0: S[l] := S[l] + sep + DegToDMS(MainTrack[I]._x,0)
                      + sep + DegToDMS(MainTrack[I]._y,0)
                      + sep + format('%.3f',[MainTrack[I]._z]);

           1..4: S[l] := S[l] + sep + format('%.3f',[MainTrack[I]._x])
                         + sep + format('%.3f',[MainTrack[I]._y])
                         + sep + format('%.3f',[MainTrack[I]._z]);
        end;

        true :
        begin
           Geo1ForceToGeo2(MainTrack[I].B,MainTrack[I].L, MainTrack[I].H, WGS,
                       CoordinateSystemList[MapFm.CoordSysN].DatumN, iB, iL, iH);

           DatumToCoordinateSystem(MapFm.CoordSysN, iB, iL, iH, newX, newY, newH);

           case J of
              0: S[l] := S[l] + sep + DegToDMS(newy,0)
                      + sep + DegToDMS(newx,0)
                      + sep + format('%.3f',[newh]);

              1..4: S[l] := S[l] + sep + format('%.3f',[newx])
                         + sep + format('%.3f',[newy])
                         + sep + format('%.3f',[newh]);
            end;
        end;


      end;
     End;

    if iBLH.Checked then         //// 3) BLH
       S[l] := S[l] + sep + DegToDMS(MainTrack[I].B,0)
                    + sep + DegToDMS(MainTrack[I].L,0)
                    + sep + format('%.3f',[MainTrack[I].H]);

    if Angs.Checked then     /// 4) angs
      for K := LastN to Length(RedAngles)-1 do
      begin
         if RedAngles[K].N = I  then
         begin
           LastN := K;
           S[l] := S[l] + sep + format('%.3f',[RedAngles[K].Yaw  *180/pi])
                        + sep + format('%.3f',[RedAngles[K].Pitch*180/pi])
                        + sep + format('%.3f',[RedAngles[K].Roll *180/pi]);
           break;
         end
          else
            if RedAngles[K].N > I  then
            begin
              S[l] := S[l] + sep + '-----'
                        + sep + '-----'
                        + sep + '-----';
              break;
            end;
      end;

   if dXYH.Checked then     /// 5) dxyh
      S[l] := S[l] + sep + format('%.3f',[RedTrack[I].dx])
                   + sep + format('%.3f',[RedTrack[I].dy])
                   + sep + format('%.3f',[RedTrack[I].dz]);


    if redXYH.Checked then         //// 6) ixyh
      case NewCS.Checked of
      true:
        begin
            Geo1ForceToGeo2(ReductedMainTrack[I].B, ReductedMainTrack[I].L, ReductedMainTrack[I].H, WGS,
                       CoordinateSystemList[MapFm.CoordSysN].DatumN, iB, iL, iH);

            DatumToCoordinateSystem(MapFm.CoordSysN, iB, iL, iH, newX, newY, newH);

            case J of
              0: S[l] := S[l] + sep + DegToDMS(newx,0)
                      + sep + DegToDMS(newy,0)
                      + sep + format('%.3f',[newh]);

              1..4: S[l] := S[l] + sep + format('%.3f',[newy])
                         + sep + format('%.3f',[newx])
                         + sep + format('%.3f',[newh]);
            end;

        end;

      false:
          case J of
              0: S[l] := S[l] + sep + DegToDMS(ReductedMainTrack[I]._x,0)
                      + sep + DegToDMS(ReductedMainTrack[I]._y,0)
                      + sep + format('%.3f',[ReductedMainTrack[I]._z]);

              1..4: S[l] := S[l] + sep + format('%.3f',[ReductedMainTrack[I]._x])
                         + sep + format('%.3f',[ReductedMainTrack[I]._y])
                         + sep + format('%.3f',[ReductedMainTrack[I]._z]);
          end;

    end;

    if redBLH.Checked then         //// 7) BLH
       S[l] := S[l] + sep + DegToDMS(ReductedMainTrack[I].B,0)
                    + sep + DegToDMS(ReductedMainTrack[I].L,0)
                    + sep + format('%.3f',[ReductedMainTrack[I].H]);

  end;

  S.SaveToFile(FN);
  S.Free;
  close;
end;

procedure TTrackSaver.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TTrackSaver.CsysClick(Sender: TObject);
begin
  CSForm.ShowModal;
  if MapFm.CoordSysN <> -1 then
     Csys.Caption := CoordinateSystemList[MapFm.CoordSysN].Caption;
  MapFm.Csys.Caption := Csys.Caption;
  NewCS.Checked := MapFm.CoordSysN <> -1;

end;

procedure TTrackSaver.FormShow(Sender: TObject);
begin
  Csys.Caption := MapFm.Csys.Caption;

  if MainTrackDatum <> -1 then
  begin
    try
       OldSys.Caption := DatumList[MainTrackDatum].Caption;
       OldSys.Caption := OldSys.Caption + ' (' + LoadT.RadioGroup2.Items[MainTrackCS]+ ')';
    except
    end;
  end
   else
      try
        OldSys.Caption := CoordinateSystemList[MainTrackCS].Caption;
      except
      end;
  

end;

procedure TTrackSaver.newCSClick(Sender: TObject);
begin
 if MapFm.CoordSysN = -1 then
   Csys.OnClick(nil);
end;

procedure TTrackSaver.OldSysClick(Sender: TObject);
begin
  OlderCS.Checked := true;
end;

end.
