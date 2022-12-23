unit URList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Menus, BasicMapObjects, TrackFunctions, MapperFm, GeoString,
  GeoClasses, ExtCtrls, StdCtrls, LangLoader, Buttons, uReduseTr;

type
  TFRList = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    TrackPts: TStringGrid;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    C5: TCheckBox;
    C6: TCheckBox;
    C8: TCheckBox;
    C4: TCheckBox;
    C7: TCheckBox;
    C12: TCheckBox;
    C10: TCheckBox;
    C11: TCheckBox;
    C9: TCheckBox;
    C3: TCheckBox;
    C2: TCheckBox;
    C1: TCheckBox;
    Label1: TLabel;
    Bevel1: TBevel;
    sb1: TSpeedButton;
    sb2: TSpeedButton;
    sb3: TSpeedButton;
    PopupMenu2: TPopupMenu;
    N4: TMenuItem;
    sb4: TSpeedButton;
    C13: TCheckBox;
    sb0: TSpeedButton;
    sb5: TSpeedButton;
    sb6: TSpeedButton;
    sb7: TSpeedButton;
    TrkS: TSaveDialog;
    procedure RefreshList;

    procedure AddPopupItems(var PopupMenu: TMenuItem; ItmName:String);
    procedure N1Click(Sender: TObject);
    procedure PopupMenuRoutesClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure C5Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure sb1Click(Sender: TObject);
    procedure TrackPtsClick(Sender: TObject);
    procedure sb3Click(Sender: TObject);
    procedure sb4Click(Sender: TObject);
    procedure sb0Click(Sender: TObject);
    procedure sb5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sb6Click(Sender: TObject);
    procedure TrackPtsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sb7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRList: TFRList;

implementation

uses UHgtGraphsW;

{$R *.dfm}

procedure TFRList.AddPopupItems(var PopupMenu: TMenuItem; ItmName:String);
var
  NewItem: TMenuItem;
begin
  NewItem := TMenuItem.Create(PopupMenu); // create the new item
  PopupMenu.Add(NewItem);           // add it to the Popupmenu
  NewItem.Caption := ItmName;

  NewItem.Tag := PopupMenu.Count-1;

  NewItem.OnClick := PopupMenuRoutesClick;
end;

procedure TFRList.C5Click(Sender: TObject);
begin
  RefreshList;
end;

procedure TFRList.Label1Click(Sender: TObject);
begin
  MapFm.Csys.OnClick(nil);
  RefreshList;
end;

procedure TFRList.N1Click(Sender: TObject);
var I:Integer;
begin
  for I := N1.Count - 1  Downto 0 do
  begin
    if I<> 0 then
      N1.Items[I].Free;
  end;

  for I := 0 to RouteCount - 1 do
     AddPopupItems(N1, Route[I].Name);
end;

procedure TFRList.N2Click(Sender: TObject);
var I :integer; Sl:TgridRect;
begin

 SelectedPointsToRoute(MainTrack,TrackPts.Selection.Top-1 , TrackPts.Selection.Bottom-1,-1);

 Sl := TrackPts.Selection;
 I := TrackPts.row;

 RefreshList;
 TrackPts.Selection := Sl;
 TrackPts.row := I;


end;

procedure TFRList.N3Click(Sender: TObject);
var I :integer;
begin

 DelTrackPoints(MainTrack,TrackPts.Selection.Top-1 , TrackPts.Selection.Bottom-1);

 I := TrackPts.row;

 RefreshList;
 if I < TrackPts.RowCount then
   TrackPts.row := I
    else
      I := TrackPts.RowCount -1;
end;

procedure TFRList.PopupMenu1Popup(Sender: TObject);
begin
  N1.Enabled := (TrackPts.Selection.Top>=1);
  N3.Enabled := N1.Enabled;
end;

procedure TFRList.PopupMenuRoutesClick(Sender: TObject);
var I :integer; Sl:TgridRect;
begin

   with Sender as TMenuItem do
   Try
      //Maintrack[I].RouteN := Tag-1;
      //Maintrack[I].RouteName := Route[Tag-1].Name;
      SelectedPointsToRoute(MainTrack,TrackPts.Selection.Top-1 , TrackPts.Selection.Bottom-1, Tag-1);
   Except
   End;

 Sl := TrackPts.Selection;
 I := TrackPts.row;

 RefreshList;
 TrackPts.Selection := Sl;
 TrackPts.row := I;

end;

procedure TFRList.RefreshList;
var I, J, K, L:integer;
    Sx, Sy, Sz:string;
begin
   if Length(MainTrack) = 0 then
      close;

   TrackPts.RowCount := 2;
   TrackPts.ColCount := 15;

   TrackPts.Cells[0,0] := inf[31];
   TrackPts.Cells[1,0] := inf[0]+#176 ;
   TrackPts.Cells[2,0] := inf[1]+#176 ;

   J := 3;
   if MapFm.CoordSysN<>-1 then
   case CoordinateSystemList[MapFm.CoordsysN].ProjectionType of
     1: begin
        inc(j);
        TrackPts.Cells[1,0] := inf[2];
        TrackPts.Cells[2,0] := inf[3];
        TrackPts.Cells[3,0] := inf[4];
     end;
     2,3: begin
        TrackPts.Cells[1,0] := inf[5];
        TrackPts.Cells[2,0] := inf[10];
     end;
     4: begin
        TrackPts.Cells[1,0] := inf[6];
        TrackPts.Cells[2,0] := inf[9];
     end;
   end;
       

   if C3.Checked then
   begin
     J := J + 2;
     TrackPts.Cells[J-2,0] := inf[0]+#176 + ' (WGS-84)' ;
     TrackPts.Cells[J-1,0] := inf[1]+#176 + ' (WGS-84)';
   end;

   for K := 4 to 13 do
   for i := 0 to FRList.ComponentCount - 1 do
    if  FRList.Components[I].Name = 'C'+IntToStr(K) then
     if TCheckBox(FRList.Components[I]).Checked then
     begin
       inc(J);
       TrackPts.Cells[J-1,0] := TCheckBox(FRList.Components[I]).Caption ;
       case K of
          6: TrackPts.Cells[J-1,0] :=  TrackPts.Cells[J-1,0] + ', '+inf[35];
          7: TrackPts.Cells[J-1,0] :=  TrackPts.Cells[J-1,0] + ', '+#176;
          //13 : TrackPts.Cells[J-1,0] :=  TrackPts.Cells[9,0] + '2';
       end;
     end;


   TrackPts.ColCount := j;

   TrackPts.DefaultColWidth := 65;
   TrackPts.ColWidths[0] := 160;
   TrackPts.ColWidths[1] := 105;  TrackPts.ColWidths[2] := 105;
   if MapFm.CoordsysN >-1 then
   if CoordinateSystemList[MapFm.CoordsysN].ProjectionType = 1 then
     TrackPts.ColWidths[3] := 105;


   if Length(Maintrack) < 1 then
     exit;

   TrackPts.RowCount := Length(Maintrack) + 1;

   for I := 0 to Length(Maintrack) - 1 do
   Begin
      TrackPts.Cells[0,I+1] := Maintrack[I]._T;
      MapFm.PointPos(Maintrack[I].B, Maintrack[I].L, Maintrack[I].H, Sx, Sy, Sz);

      TrackPts.Cells[1,I+1] := Sx;
      TrackPts.Cells[2,I+1] := Sy;

      J := 3;
      if MapFm.CoordsysN >-1 then
       if CoordinateSystemList[MapFm.CoordsysN].ProjectionType = 1 then
       begin
          TrackPts.Cells[J-1,I+1] := Sz;
          inc(J);
       end;

      if C3.Checked then
      begin
         J := J+2;
         TrackPts.ColWidths[J-1] := 115;
         TrackPts.ColWidths[J-2] := 115;
         TrackPts.Cells[J-2,I+1] := DegToDMS(Maintrack[I].B, true,5);
         TrackPts.Cells[J-1,I+1] := DegToDMS(Maintrack[I].L, false,5);
      end;

      for K := 4 to 13 do
      for L := 0 to FRList.ComponentCount - 1 do
      if  FRList.Components[L].Name = 'C'+IntToStr(K) then
        if TCheckBox(FRList.Components[L]).Checked then
        begin
          inc(J);
          case K of
             4: TrackPts.Cells[J-1,I+1] := Format('%.3f',[Maintrack[I].H]);
             5: TrackPts.Cells[J-1,I+1] := Format('%.3f',[Maintrack[I].HGeo]);
             6: TrackPts.Cells[J-1,I+1] := IntToStr(round(Maintrack[I].Speed));
             7: begin
                TrackPts.Cells[J-1,I+1] := Format('%.1f',[Maintrack[I].Azimuth*180/pi]);
                TrackPts.ColWidths[J-1] := 55;
               end;
             8: begin
                TrackPts.Cells[J-1,I+1] := Format('%.1f',[Maintrack[I].PDOP]);
                TrackPts.ColWidths[J-1] := 55;
               end;
             9: begin
                TrackPts.Cells[J-1,I+1] := Maintrack[I].RouteName;
                TrackPts.ColWidths[J-1] := 85;
               end;
             11: begin
                 TrackPts.Cells[J-1,I+1] := IntToStr(Maintrack[I].SatN);
                end;
             10: TrackPts.Cells[J-1,I+1] := Format('%.3f',[Maintrack[I].Altitude]);
             12: begin
                  TrackPts.Cells[J-1,I+1] := Maintrack[I].Comment;
                  TrackPts.ColWidths[J-1] := 155;
                end;
             13: TrackPts.Cells[J-1,I+1] := Format('%.3f',[Maintrack[I].AltL]);
          end;
          
        end;


    //  TrackPts.Cells[4,I+1] := Maintrack[I].RouteName;

     // TrackPts.Cells[5,I+1] := DEGTODMS(Maintrack[I].L,false,5);
     // TrackPts.Cells[6,I+1] :=  Format('%.3f',[Maintrack[I].H]);
   End;
   Label1.Caption := MapFm.Csys.Caption;
end;

procedure TFRList.sb0Click(Sender: TObject);
begin
  HgtGraphs.Showmodal;
end;

procedure TFRList.sb1Click(Sender: TObject);
var I:Integer;
    MI: TMenuItem;
    SysCurPos :TPoint;
begin
 GetCursorPos(SysCurPos);

 for I := PopupMenu2.Items.Count - 1  Downto 0 do
  begin
    if I<> 0 then
      PopupMenu2.Items[I].Free
    else
      PopupMenu2.Items[I].Caption := N2.Caption
  end;

  for I := 0 to RouteCount - 1 do
  begin
     MI := TMenuItem.Create(PopupMenu2);
     MI.Caption := Route[I].Name;
     MI.Tag := I+1;
     MI.OnClick := PopupMenuRoutesClick;
     PopupMenu2.Items.Add(MI);
  end;

  PopupMenu2.Popup(SysCurPos.X, SysCurPos.Y);
end;

procedure TFRList.sb3Click(Sender: TObject);
begin
  FReduceTrack.ShowModal;
  RefreshList;
end;

procedure TFRList.sb4Click(Sender: TObject);
var s:string; D:Double;  I:Integer;  DT:TFormatSettings;
begin
  if InputQuery(inf[127], inf[124], s) then
  Begin

    try
       D := StrToFloat2(s);
    except
      MessageDlg(inf[126], mtError, [mbOk], 0);
      exit;
    end;

    if D = 0 then
    begin
      MessageDlg(inf[126], mtError, [mbOk], 0);
      exit;
    end;

    case MessageDlg(inf[125], mtConfirmation, mbYesNo, 0) of
      6: for I := 0 to Length(MainTrack) - 1 do
           MainTrack[I].T := MainTrack[I].T + D/86400;
      else
        for I := TrackPts.Selection.Top-1 to TrackPts.Selection.Bottom-1 do
           MainTrack[I].T := MainTrack[I].T + D/86400;
    end;
    InitDTFormat(DT);
    for I := 0 to Length(MainTrack) - 1 do
           MainTrack[I]._T := DateTimeToStr2(MainTrack[I].T, DT);
    RefreshList;
  End;

end;

var lasts: string = '';
procedure SearchTab(new:boolean);
var s:string; I, j, k :integer;  found, isenter:boolean;
begin
 s := lasts;
 if new then
   isenter := InputQuery(inf[195], inf[196], s)
 else
   isenter := true;

 if isenter then
 Begin
   if s = '' then
    exit;
   k := FRList.TrackPts.Selection.Bottom + 1;
   found := false;
   lasts := s;
   for I := FRList.TrackPts.Selection.Bottom + 1 to FRList.TrackPts.RowCount - 1 do
   begin
     for j := 0 to FRList.TrackPts.ColCount - 1 do
     if Pos(s, FRList.TrackPts.Cells[j, I]) > 0 then
     begin
       FRList.TrackPts.Row := I;
       found := true;
       break;
     end;
     if found then
        break;
   end;

   if FRList.TrackPts.Selection.Bottom > 1 then
   if not found then
     if  MessageDlg(inf[200],mtConfirmation, [mbYes, mbNo],0) = 6 then
     BEGIN
       for I := 1 to FRList.TrackPts.Selection.Top do
       begin
         for j := 0 to FRList.TrackPts.ColCount - 1 do
         if Pos(s, FRList.TrackPts.Cells[j, I]) > 0 then
         begin
            FRList.TrackPts.Row := I;
            found := true;
            break;
         end;
         if found then
           break;
       end;
     END
     ELSE exit;

    if not Found then
      MessageDlg(inf[197],mtWarning,[mbOk],0);
 End;
end;


procedure TFRList.sb5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SearchTab(Button <> mbright);
end;

procedure TFRList.sb6Click(Sender: TObject);
var s:string; D:Double;  I, j:Integer;  DT:TFormatSettings;
begin
  if InputQuery(inf[198], inf[199], s) then
  Begin
    for I := TrackPts.Selection.Top-1 to TrackPts.Selection.Bottom-1 do
       MainTrack[I].Comment := s;
    if not C12.Checked then
    begin
      C12.Checked := true;
      C5.OnClick(Sender);
    end;
    j := TrackPts.Selection.Top;
    RefreshList;
    if j > 1 then
      TrackPts.Row := j;

    if s <> '' then
      TrackHasComments := true;
  End;
end;

procedure TFRList.sb7Click(Sender: TObject);
var I, J :integer;
    S :TStringList;
    FileName, ext:String;
begin
  if TrkS.Execute then
  Begin
    FileName := TrkS.FileName;
    ext := '.txt';

    if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> ext then
       FileName := FileName + ext;
    if fileexists(FileName) then
        if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

    S := TStringList.Create;

    for I := 0 to TrackPts.RowCount - 1 do
    begin
       S.Add('');
       for j := 0 to TrackPts.ColCount - 1 do
          S[S.Count - 1] :=  S[S.Count - 1] + TrackPts.Cells[j,i] + #$9
    end;
      

    S.SaveToFile(FileName);
    S.Free
  End;
end;

procedure TFRList.TrackPtsClick(Sender: TObject);
begin
  sb1.Enabled := (TrackPts.Selection.Top>=1);
  sb2.Enabled := N1.Enabled;
  sb3.Enabled := TrackPts.RowCount > 2;
  sb6.Enabled := TrackPts.RowCount > 2;
  sb4.Enabled := TrackPts.RowCount > 2;
end;

procedure TFRList.TrackPtsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Sr: TGridRect;
begin
  if key = vk_F3 then
    SearchTab(false);

  if (key = 70) and (ssCtrl in Shift) then
     SearchTab(true);

  if key = vk_Delete then
    if sb2.Enabled then sb2.Click;

  if (key = vk_Return) and (ssCtrl in Shift) then
    if sb6.Enabled then sb6.Click;

  if (key = 82) and (ssCtrl in Shift) then
    if sb1.Enabled then sb1.Click;

  if (key = 65) and (ssCtrl in Shift) then
  begin
    Sr.Left := 0;
    Sr.Right := TrackPts.ColCount-1;
    Sr.Top := 1;
    Sr.Bottom := TrackPts.RowCount-1;
    TrackPts.Selection := Sr;
  end;
end;

end.
