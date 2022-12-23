unit UMarkEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, BasicMapObjects, LangLoader, GeoCalcUnit,
  GeoString, MapFunctions, TabFunctions, GeoFunctions, GeoClasses, MapEditor,
  PointClasses;

type
  TMarkEd = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Bevel1: TBevel;
    label2: TRadioButton;
    RadioButton1: TRadioButton;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label7: TLabel;
    CCS: TSpeedButton;
    BB1: TSpeedButton;
    BB2: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CCSClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Edits;
    procedure label2Click(Sender: TObject);
    procedure BB1Click(Sender: TObject);
    procedure BB2Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MarkN : integer;
    PMode : integer;
    isOk  : boolean;
  end;

var
  MarkEd: TMarkEd;

implementation

uses MapperFm, CoordSysFm, SaveTXT, UMarkerList, UDevStar, UMarkH;

{$R *.dfm}

procedure TMarkEd.BB1Click(Sender: TObject);
var B, L, H, X, Y, Z : Double;
begin
  B := StrToLatLon(Edit2.Text, true);
  L := StrToLatLon(Edit3.Text, false);
  try
      Geo1ForceToGeo2(B,L,0, WGS,
                       CoordinateSystemList[MapFm.CoordSysN].DatumN, B, L, H);

      DatumToCoordinateSystem(MapFm.CoordSysN,B,L,H,X,Y,Z);


       case CoordinateSystemList[MapFm.CoordsysN].ProjectionType of
          0:begin
             Edit4.Text:= DegToDMS(X,true, 5, false);
             Edit5.Text := DegToDMS(Y,false,5, false);
          end;
          1:begin
            Edit4.Text := Format('%.3f',[X]);
            Edit5.Text := Format('%.3f',[Y]);
            Edit6.Text := Format('%.3f',[Z]);
          end;
          2..4:begin
            Edit4.Text := Format('%n',[X]);
            Edit5.Text := Format('%n',[Y]);
          end;
       end;


  finally
    RadioButton1.Checked := true;
  end;

end;

procedure TMarkEd.BB2Click(Sender: TObject);
var B, L, X, Y, Z, H : Double;
begin
  X := 0; Y := 0;
  
  if MapFM.CoordSysN<>-1 then
  BEGIN

   Z := 0;
   case CoordinateSystemList[MapFM.CoordSysN].ProjectionType of
    0:
    begin
      X := StrToLatLon(Edit4.Text, true);
      Y := StrToLatLon(Edit5.Text, false);
    end;
    1: begin
      X := StrToFloat2(Edit4.Text);
      Y := StrToFloat2(Edit5.Text);
      Z := StrToFloat2(Edit6.Text);
    end;
    2 : begin
      X := StrToFloat2(Edit4.Text);
      Y := StrToFloat2(Edit5.Text);
    end;
    3,4 : begin
      X := StrToFloat2(Edit4.Text);
      Y := StrToFloat2(Edit5.Text);
    end;
   end;
  END
    ELSE
    begin
      Label2.Checked := true;
      exit;
    end;


  try
      CoordinateSystemToDatum(MapFm.CoordSysN, X, Y, Z, B, L, H);

      Geo1ForceToGeo2(B, L, H, CoordinateSystemList[MapFm.CoordSysN].DatumN, WGS,
                        B, L, H);

      Edit2.Text:=  DegToDMS(B,true, 5, false);
      Edit3.Text := DegToDMS(L,false,5, false);

  finally
    Label2.Checked := true;
  end;
end;

procedure TMarkEd.Button1Click(Sender: TObject);
var P:TMyPoint;
begin
  isOk := true;

  if RadioButton1.Checked then
     BB2.Click;

  case PMode of
  
  0:
  Begin
      if MarkN = -1 then
      Begin
        MarkN := Length(Markers);
        SetLength(Markers, Length(Markers)+1);
      End;

      if MarkN < Length(Markers) then
      Begin
        Markers[MarkN].Gx := StrToLatLon(Edit2.Text, true);
        Markers[MarkN].Gy := StrToLatLon(Edit3.Text, false);
        Markers[MarkN].MarkerName := Edit1.Text;
      End;

      RecomputeMarkers(WaitForZone);
    End;

    1:  Begin
       Base[2].x := StrToLatLon(Edit2.Text, true);
       Base[2].y := StrToLatLon(Edit3.Text, false);
       RecomputeBase(WaitForZone);
       P := BLToMap(StrToLatLon(Edit2.Text,true), StrToLatLon(Edit3.Text, false));
       Center.x := P.X;
       Center.y := P.Y;
    End;

    2:  Begin


    End;

    3:  Begin
       DevStarFm.Edit2.Text := Edit2.Text;
       DevStarFm.Edit3.Text := Edit3.Text;
    End;

    4:  Begin
       P := BLToMap(StrToLatLon(Edit2.Text,true), StrToLatLon(Edit3.Text, false));
       if Length(SelectedKnots)>0 then
       try
           KnotPoints[SelectedKnots[0]].Cx := P.x;
           KnotPoints[SelectedKnots[0]].Cy := P.y;
       except
       end;

    End;
    
  end;

  
  Close;

end;

procedure TMarkEd.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TMarkEd.Button3Click(Sender: TObject);
begin
   if MarkN < 0 then
      exit;
   if MarkN > Length(Markers)-1 then
      exit;
      
   if MessageDLG(inf[19], MtConfirmation, mbYesNo, 0) = 6 then
   begin
     DelMarker(MarkN);
     MarkerList.RefreshList(true);
     close;
   end;
end;

procedure TMarkEd.Button4Click(Sender: TObject);
begin
  if PMode = 0 then
  Begin
     MarkH.MarkHN := MarkN;
     MarkH.Edit2.Text := FormatFloat('0.000', Markers[MarkN].H);
     MarkH.Edit1.Text := FormatFloat('0.000', Markers[MarkN].HGeo);
     MarkH.Edit3.Text := FormatFloat('0.000', Markers[MarkN].Alt);
     MarkH.SpinEdit1.Value := Markers[MarkN].MarkerKind;
     MarkH.ShowModal;
  End;
end;

procedure TMarkEd.FormShow(Sender: TObject);
begin
  isOk := false;

  Edits;

  Button4.Visible := False;
  Button3.Visible := False;
  Label1.Visible  := False;
  Edit1.Visible   := False;
  Panel2.Visible := False;
  RadioButton1.Caption := MapFm.Csys.Caption;

  if PMode = 0 then
  Begin
     Button3.Visible :=  MarkN <> -1;
     Button4.Visible :=  MarkN <> -1;
     Label1.Visible  := True;
     Edit1.Visible   := True;
     Panel2.Visible := True;
  End;

  if Panel2.Visible then
    ClientHeight := Panel1.Height + Panel2.Height
      else
         ClientHeight := Panel1.Height;

  if MapFM.CoordSysN <> -1 then
    BB1.Click;

  if Edit1.Visible then
  begin
     Edit1.SetFocus;
     Edit1.SelectAll;
  end;
end;

procedure TMarkEd.label2Click(Sender: TObject);
begin
  if BB2.Enabled then
     BB2.Click;
  Edits;
end;

procedure TMarkEd.RadioButton1Click(Sender: TObject);
begin
  if MapFM.CoordSysN = -1 then
     CCS.Click;

  Edits;
end;

procedure TMarkEd.SpeedButton1Click(Sender: TObject);
begin
  GeoCalcUnit.ReturnB := Edit2;
  GeoCalcUnit.ReturnL := Edit3;

  GeoCalcFm.PointB := StrToLatLon(Edit2.Text, true);
  GeoCalcFm.PointL := StrToLatLon(Edit3.Text, false);
  
  GeoCalcFm.ShowModal;
end;

procedure TMarkEd.CCSClick(Sender: TObject);
begin
 if MapFM.CoordSysN <> -1 then
   BB2.Click;
 CSForm.ShowModal;
  if MapFM.CoordSysN <> -1 then
    MapFM.Csys.Caption := CoordinateSystemList[MapFM.CoordSysN].Caption;
  SaveTXTFm.Csys.Caption := MapFM.Csys.Caption;

  if MapFM.CoordSysN = -1 then
    Label2.Checked := true
     else
      BB1.Click;

  RadioButton1.Caption := MapFm.Csys.Caption;
end;

procedure TMarkEd.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = vk_return then
   Button1.Click;
end;

procedure TMarkEd.Edits;
begin
  Label3.Caption := Inf[0]+#176+':';
  Label4.Caption := Inf[1]+#176+':';

  Edit4.Enabled := RadioButton1.Checked;
  Edit5.Enabled := RadioButton1.Checked;
  Edit6.Enabled := RadioButton1.Checked;

  if MapFM.CoordSysN<>-1 then
  begin
    Edit6.Visible := CoordinateSystemList[MapFM.CoordSysN].ProjectionType = 1;
    Label7.Visible := CoordinateSystemList[MapFM.CoordSysN].ProjectionType = 1;
  end;

  if MapFM.CoordSysN<>-1 then
  case CoordinateSystemList[MapFM.CoordSysN].ProjectionType of
    0:
    begin
       Label5.Caption := Inf[0]+#176+':';
       Label6.Caption := Inf[1]+#176+':';
    end;
    1: begin
       Label5.Caption := Inf[2]+':';
       Label6.Caption := Inf[3]+':';
       Label7.Caption := Inf[4]+':';
    end;
    2,3: begin
       Label6.Caption := Inf[10]+':';
       Label5.Caption := Inf[5]+':';
    end;
    4: begin
       Label6.Caption := Inf[9]+':';
       Label5.Caption := Inf[6]+':';
    end;
  end;

  Edit2.Enabled := not RadioButton1.Checked;
  Edit3.Enabled := not RadioButton1.Checked;

  BB1.Enabled := not RadioButton1.Checked;
  BB2.Enabled :=  RadioButton1.Checked;

  if BB1.Enabled then
    BB1.Enabled :=  MapFM.CoordSysN<>-1 ;
end;

end.
