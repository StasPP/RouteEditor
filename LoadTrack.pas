unit LoadTrack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, ValEdit, StdCtrls, ExtCtrls, ComCtrls, Grids, LangLoader,
  GeoFunctions, GeoString, TabFunctions, GeoClasses, TrackFunctions, MapperFm,
  Buttons, BasicMapObjects;

type
  TLoadT = class(TForm)
    StringGrid1: TStringGrid;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ComboBox1: TComboBox;
    RadioGroup2: TRadioGroup;
    TabSheet2: TTabSheet;
    ComboBox2: TComboBox;
    ListBox4: TListBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    RSpacer: TRadioGroup;
    Spacer: TEdit;
    StartFrom: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Col1: TSpinEdit;
    Col2: TSpinEdit;
    Label3: TLabel;
    Col3: TSpinEdit;
    Label4: TLabel;
    Col4: TSpinEdit;
    Label5: TLabel;
    GroupBox4: TGroupBox;
    TimeSys: TRadioGroup;
    GroupBox5: TGroupBox;
    isDoy: TRadioButton;
    isFormatted: TRadioButton;
    isWoy: TRadioButton;
    GroupBox6: TGroupBox;
    Col10: TSpinEdit;
    C12: TRadioButton;
    C10: TRadioButton;
    C14: TRadioButton;
    Edit3: TSpinEdit;
    Edit1: TComboBox;
    Edit2: TComboBox;
    ScrollBox1: TScrollBox;
    C6: TCheckBox;
    C7: TCheckBox;
    Col5: TSpinEdit;
    Col6: TSpinEdit;
    Col7: TSpinEdit;
    Col8: TSpinEdit;
    C9: TCheckBox;
    C5: TCheckBox;
    C8: TCheckBox;
    Col9: TSpinEdit;
    C11: TCheckBox;
    Col11: TSpinEdit;
    C15: TCheckBox;
    Col15: TSpinEdit;
    C16: TCheckBox;
    Col16: TSpinEdit;
    Col17: TSpinEdit;
    C17: TCheckBox;
    PanelMinSec: TPanel;
    isMin: TCheckBox;
    isSec: TCheckBox;
    isSOW: TRadioButton;
    Date1: TDateTimePicker;
    WeekEdit: TSpinEdit;
    WeekButton: TSpeedButton;
    Panel1: TPanel;
    OTSave: TSpeedButton;
    OTDel: TSpeedButton;
    OpTmp: TComboBox;
    Panel2: TPanel;
    CheckGlobe: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RefreshRes;
    procedure C9Click(Sender: TObject);
    procedure Col1Change(Sender: TObject);
    procedure StartFromChange(Sender: TObject);
    procedure RenameTabs(var StringGrid: TStringGrid; TabNameStyle: byte);
    procedure RSpacerClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure isDoyClick(Sender: TObject);
    procedure Col10Change(Sender: TObject);
    procedure WeekButtonClick(Sender: TObject);
    procedure FindWGS;

    procedure InitOT;
    procedure LoadOTList(FN:String);
    procedure OTDelClick(Sender: TObject);
    procedure OTSaveClick(Sender: TObject);
    procedure OpTmpChange(Sender: TObject);
    procedure CheckGlobeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FName:String;
    FKind:Byte;
  end;

var
  LoadT: TLoadT;
  S, OTList :TStringList;
  LatS, LonS, XS, YS, ZS, NordS, SouthS, NSS, EWS, WestS, EastS, NameS, FName : String;
  CoordType: integer;
  Flang: string = 'Russian';
  
implementation

uses UCalendar, UGetMapPos;

{$R *.dfm}

procedure FindCat(Cat: String; ListBox: TListBox);
var i: integer;
begin
 ListBox.Items.Clear;
 for i := 0 to Length( CoordinateSystemList)-1 do
  if CoordinateSystemList[i].Category = Cat then
    ListBox.Items.Add(CoordinateSystemList[i].Caption);
end;

procedure ClearGrid(StringGrid: TStringGrid);
var i, j: Integer;
begin
  with StringGrid do
  begin
    for i:=1 to RowCount-1 do
    for j:=0 to ColCount-1 do
      Cells[j, i]:='';
    StringGrid.RowCount := 2;
  end;
end;

procedure TLoadT.RenameTabs(var StringGrid: TStringGrid; TabNameStyle: byte);
var i: integer;
begin

  StringGrid.ColCount := 3;

  Label5.Visible := false;
  PanelMinSec.Visible := false;
  Col4.Visible   := false;

  case TabNameStyle of
    4: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[2,0] := SouthS;
      StringGrid.Cells[1,0] := WestS;
    end;

    3: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := EastS;
      StringGrid.Cells[2,0] := NordS;
    end;

    2: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := EastS;
      StringGrid.Cells[2,0] := NordS;
    end;

    1: begin
      StringGrid.ColCount := 4;
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := XS;
      StringGrid.Cells[2,0] := YS;
      StringGrid.Cells[3,0] := ZS;

      Label5.Visible := true;
      Col4.Visible   := true;
    end;

    0: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := LatS+#176;
      StringGrid.Cells[2,0] := LonS+#176;
      PanelMinSec.Visible := true;
    end;
  end;

  Label4.Caption := StringGrid.Cells[2,0];
  Label3.Caption := StringGrid.Cells[1,0];
  Label5.Caption := ZS;

       if Label5.Visible then
         StringGrid.ColCount := 4;

       if C5.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] :=  C5.Caption;
       end;

       if C6.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] :=  C6.Caption;
       end;

       if C7.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] :=  C7.Caption;
       end;

       if C8.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] :=  C8.Caption;
       end;

       if C9.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] :=  C9.Caption;
       end;

       if C10.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] :=  inf[32];
       end;

       if C11.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] := C11.Caption;
       end;

       if C15.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] := C15.Caption;
       end;

       if C16.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] := C16.Caption;
       end;

       if C17.Checked then
       begin
         StringGrid1.ColCount := StringGrid1.ColCount+1;
         StringGrid1.Cells[ StringGrid1.ColCount-1,0] := C17.Caption;
       end;

       
  for i:= 0 to StringGrid.ColCount-1 do
    StringGrid.ColWidths[i] := (StringGrid.Width - 10) div StringGrid.ColCount;

  OPTmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadT.Button1Click(Sender: TObject);
var
  Dat, SK, Xtab, Ytab, Ztab, Htab, HGeoTab, SpeedTab, AzmtTab, TTab, StartI,
               PDopTAb, DateTab, CommentTab, AltTab, SatNTab, RouteTab: integer;
  isRoutesDatum, isUTC, isMinTab, isSecTab :Boolean;
  Spc : char;
  CDT :byte;
  DateF, TimeF : String;
begin

 isRoutesDatum := PageControl1.ActivePageIndex = 0;

 Case RSpacer.itemIndex of
     0: Spc := ' ';
     1: Spc := #$9;
     2: Spc := Spacer.Text[1];
     3: Spc := ';';
     4: Spc := ',';
 end;

 if isRoutesDatum then
 begin
   Dat := FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);
   SK  := RadioGroup2.ItemIndex;
 end
  else
  begin
    SK  := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
    Dat :=  -1; //CoordinateSystemList[MainForm.RoutesCS].DatumN;
  end;

  StartI := StartFrom.Value -1;

  TTab := Col1.Value -1;
  XTab := Col2.Value -1;
  YTab := Col3.Value -1;

  if Label5.Visible then
     Ztab := Col4.Value -1
       else
         Ztab := -1;

  if C5.Checked then
     HTab := Col5.Value -1
       else
         HTab := -1;

  if C6.Checked then
     HGeoTab := Col6.Value -1
       else
         HGeoTab := -1;

  if C7.Checked then
     SpeedTab := Col7.Value -1
       else
         SpeedTab := -1;

  if C8.Checked then
     AzmtTab := Col8.Value -1
       else
         AzmtTab := -1;

  if C9.Checked then
     PDopTab := Col9.Value -1
       else
         PDopTab := -1;

  if C10.Checked then
     DateTab := Col10.Value -1
       else
         if C14.Checked then
           DateTab := -2
            else
              DateTab := -1;

  if C11.Checked then
     CommentTab := Col11.Value -1
       else
         CommentTab := -1;

  if IsFormatted.Checked then
  begin
    TimeF := Edit2.Text;
    DateF := Edit1.Text;
  end
   else
   begin
     TimeF := '';
     DateF := '';
     if isDoy.Checked then
        DateF := IntToStr(Edit3.Value)
          else
           if isSOW.Checked then
              DateF := IntToStr(WeekEdit.Value)
   end;

  isUTC := (TimeSys.ItemIndex = 1);

  if C15.Checked then
     AltTab := Col15.Value -1
       else
         AltTab := -1;

  if C16.Checked then
     SatNTab := Col16.Value -1
       else
         SatNTab := -1;

  if C17.Checked then
     RouteTab := Col17.Value -1
       else
         RouteTab := -1;

  isMinTab := PanelMinSec.Visible and isMin.Checked;
  isSecTab := isMinTab and isSec.Checked;

  CDT := 0;
  if isDOY.Checked then
    CDT := 1
      else
      if isWOY.Checked then
        CDT := 2
        else
        if isSOW.Checked then
           CDT := 3;

  if Fkind = 1 then
    LoadTrackFromFile(ReductedMainTrack, FName, AddRoutes, spc, StartI, Dat, SK, TTab,
                   Xtab, Ytab, Ztab, Htab,
                   HGeoTab, SpeedTab, AzmtTab, PDopTAb, DateTab, CommentTab,
                   AltTab, -1, SatNTab, RouteTab, -1, -1, DateF, TimeF, isUTC,
                   isMinTab, isSecTab, Date1.DateTime, CDT, inf[123])
  else
    LoadTrackFromFile(MainTrack, FName, AddRoutes, spc, StartI, Dat, SK, TTab,
                   Xtab, Ytab, Ztab, Htab,
                   HGeoTab, SpeedTab, AzmtTab, PDopTAb, DateTab, CommentTab,
                   AltTab, -1, SatNTab, RouteTab, -1, -1, DateF, TimeF, isUTC,
                   isMinTab, isSecTab, Date1.DateTime, CDT, inf[123]);

  close;
end;

procedure TLoadT.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TLoadT.C9Click(Sender: TObject);
begin
 if isMin.Checked = false then
    isSec.Checked := false;

 Date1.Enabled := C14.Checked;

 RefreshRes;
 isDoy.OnClick(nil);
end;

procedure TLoadT.CheckGlobeClick(Sender: TObject);

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

var X, Y, Z, B, L, H :Double;
begin
 isRoutesDatum := PageControl1.ActivePageIndex = 0;

 if isRoutesDatum then
 begin
   RoutesDatum := FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);
   RoutesCS := RadioGroup2.ItemIndex;
 end
  else
  begin
    RoutesCS := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
    RoutesDatum :=  -1; //CoordinateSystemList[MainForm.RoutesCS].DatumN;
  end;

  
  if (isRoutesDatum) and (RoutesCS = 0) or
     (not isRoutesDatum) and (CoordinateSystemList[RoutesCS].ProjectionType = 0) then
  begin
      X := StrToLatLon(StringGrid1.Cells[1,1],true);
      Y := StrToLatLon(StringGrid1.Cells[2,1],false);
  end
   else
   begin
      X := StrToFloat2(StringGrid1.Cells[1,1]);
      Y := StrToFloat2(StringGrid1.Cells[2,1]);
   end;


  if (isRoutesDatum) and (RoutesCS = 2) or
     (not isRoutesDatum) and (CoordinateSystemList[RoutesCS].ProjectionType = 2) then
     Z := StrToFloat2(StringGrid1.Cells[3,1])
  else Z := 0;
  GetBL(X, Y, Z, B, L, H);

  GetMapPos.GMMode := false;
  GetMapPos.PointB := B;
  GetMapPos.PointL := L;
  GetMapPos.ShowModal;
end;

procedure TLoadT.Col10Change(Sender: TObject);
begin
  C10.Checked := True;
  C9.OnClick(nil);
end;

procedure TLoadT.Col1Change(Sender: TObject);
begin
  RefreshRes;
end;

procedure TLoadT.ComboBox1Change(Sender: TObject);
var i, j : integer;
begin
  if ComboBox1.ItemIndex>=0 then
  Begin

    i:= FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);

    RadioGroup2.ItemIndex := 0;
    RadioGroup2.Buttons[2].Enabled := false;
    RadioGroup2.Buttons[3].Enabled := false;
    RadioGroup2.Buttons[4].Enabled := false;
    for j:=0 to length(DatumList[i].Projections)-1 Do
    begin
      if DatumList[i].Projections[j]='Gauss' then
         RadioGroup2.Buttons[2].Enabled := true;
      if DatumList[i].Projections[j]='UTM' then
      begin
         RadioGroup2.Buttons[3].Enabled := true;
         RadioGroup2.Buttons[4].Enabled := true;
      end;
    end;

  End;
  OPTmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadT.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex<>-1 then
    findCat(ComboBox2.Items[ComboBox2.ItemIndex],ListBox4);
  //Form2.ListBox4.Sorted :=true;
  ListBox4.ItemIndex :=0;
  ListBox4.OnClick(nil);
end;

procedure TLoadT.FindWGS;
var I, j:Integer;
const CN = 'WGS84_LatLon';
begin
//
 j := -1;

 for I := 0 to Length(CoordinateSystemList)-1 do
   if CoordinateSystemList[I].Name = CN then
   begin
     j := I;
     break;
   end;

 if j = -1 then
   exit;

 for I := 0 to ComboBox2.Items.Count - 1 do
   if CoordinateSystemList[j].Category = ComboBox2.Items[I] then
   begin
     ComboBox2.ItemIndex := I;
     break;
   end;

 FindCat(CoordinateSystemList[j].Category, ListBox4);
 for I := 0 to ListBox4.Items.Count - 1 do
   if ListBox4.Items[I] = CoordinateSystemList[j].Caption then
   begin
     ListBox4.ItemIndex := I;
     break;
   end;

end;

procedure TLoadT.FormActivate(Sender: TObject);
var I : Integer;
begin
 if Lang <> FLang then
 Begin
   ComboBox2.Items.Clear;
   ComboBox1.Items.Clear;
   FLang := Lang;
   FindWGS;
 End;

 if  ComboBox1.Items.Count = 0 then
 begin

   ComboBox2.Clear;
   for i := 0 to Length(CoorinateSystemCategories)-1 do
     ComboBox2.Items.Add(CoorinateSystemCategories[i]);

   Combobox2.Sorted := true;
   ComboBox2.ItemIndex :=0;
   ComboBox2.OnChange(nil);

   for I := 0 to Length(DatumList)-1 do
     if not  DatumList[i].Hidden then
       ComboBox1.Items.Add(DatumList[i].Caption);
   ComboBox1.ItemIndex := 0;
   ComboBox1.OnChange(nil);
   FindWGS;
 end;

 if PageControl1.ActivePageIndex = 1 then
    ListBox4.OnClick(nil);
    
end;



procedure TLoadT.FormCreate(Sender: TObject);
begin
    S :=TStringList.Create;
    OTList :=TStringList.Create;
   // oldidx := -1;

    LatS := '������ B, ';
    LonS := '������� L, ';
    XS := 'X, �'; YS := 'Y, �'; ZS := 'Z, �';
    NordS := '�����, �';
    SouthS:= '��, �';
    NSS := '�����/��, �';
    EWS := '�����/������, �';
    WestS := '�����, �';
    EastS := '������, �';
    NameS := '�����'

end;

procedure TLoadT.FormDestroy(Sender: TObject);
begin
  S.Free;
  OTList.Free;
end;

procedure TLoadT.FormShow(Sender: TObject);
begin
 try
     if (AnsiLowerCase(Copy(FName, Length(FName)-3,4))='.xls')or
            (AnsiLowerCase(Copy(FName, Length(FName)-4,5))='.xlsx')  then
              ExcelToStringList(FName, S)
          else
              S.LoadFromFile(FName);
   //  S.LoadFromFile(Fname);
  except
  end;
  OnActivate(Sender);
  RadioGroup2.OnClick(nil);
  RefreshRes;

  LatS := inf[0];
  LonS := inf[1];
  XS := inf[2]; YS := inf[3]; ZS := inf[4];
  NordS := inf[5];
  SouthS:= inf[6];
  NSS := inf[7];
  EWS := inf[8];
  WestS := inf[9];
  EastS := inf[10];
  NameS := inf[31];

//  Label3.Caption := XS;
//  Label4.Caption := YS;
  InitOT;
  
  if PageControl1.ActivePageIndex = 1 then
    ListBox4.OnClick(nil)
      else
         ComboBox1.OnChange(nil)
end;

procedure TLoadT.InitOT;
var FN:string;
begin
  SetCurrentDir(MyDir);
  FN := 'Data\import_tracks.txt';

  if fileexists(FN) = false then
  begin
    OpTmp.Items.Clear;
    OpTmp.Items.SaveToFile(FN);
  end;

  LoadOTList(FN);
end;

procedure TLoadT.isDoyClick(Sender: TObject);
begin
  Edit3.Visible := isDOY.Checked;
  Edit1.Visible := (isFormatted.Checked)and(not C14.Checked);
  Edit2.Visible := isFormatted.Checked;

  WeekEdit.Visible := isSOW.Checked;
  WeekButton.Visible := isSOW.Checked;
end;

procedure TLoadT.ListBox4Click(Sender: TObject);
var i : integer;
begin
   if ListBox4.ItemIndex <= -1 then
    exit;

   i := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
   CoordType := CoordinateSystemList[i].ProjectionType;
                
 {  case CoordType of
    3,4: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);
    end;

    2: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);

    end;

    1: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := XS;
      ValueList.Keys[3] := YS;

      if ValueList.RowCount<5 then
        ValueList.InsertRow(ZS, '4', true);

      ValueList2.Keys[1] := XS;
      ValueList2.Keys[2] := YS;

      if ValueList2.RowCount<4 then
         ValueList2.InsertRow(ZS, '7', true);
    end;

    0: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := LatS+#176;
      ValueList.Keys[3] := LonS+#176;

      if ValueList.RowCount = 5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] :=  LatS +#176;
      ValueList2.Keys[2] :=  LonS +#176;

      if ValueList2.RowCount = 4 then
         ValueList2.DeleteRow(3);
    end;    
  end;      }
  RenameTabs(StringGrid1,CoordType);
end;

procedure TLoadT.ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  idx : Longint;
begin
  with Sender as TListBox do begin
    idx := ItemAtPos(Point(x,y),True);
    if (idx < 0) or (idx = oldidx) then
      Exit;

    Application.ProcessMessages;
    Application.CancelHint;

    oldidx := idx;

    HintX := TListBox(Sender).itemRect(idx).Left;
    HintY := TListBox(Sender).itemRect(idx).Top;

    Hint := '';
    if Canvas.TextWidth(Items[idx]) > Width - 24 then
      Hint:=Items[idx];

  end;

end;

procedure TLoadT.LoadOTList(FN: String);
var I:Integer;
begin
  OTList.LoadFromFile(FN);
  OpTmp.Items.Clear;
  OpTmp.Items.Add('');
  for I := 0 to OTList.Count - 1 do
    OpTmp.Items.Add(GetCols(OTList[I],0,1,#$9, false));
end;

procedure TLoadT.OpTmpChange(Sender: TObject);
var I, N, j : Integer;
begin
  OTDel.Visible := OpTmp.ItemIndex > 0;
  N :=  OpTmp.ItemIndex - 1;
  if OpTmp.ItemIndex > 0 then
  begin
    PageControl1.ActivePageIndex := StrToInt(GetCols(OTList[N],1,1,#$9, false));

    case PageControl1.ActivePageIndex of
      0: begin
           for I := 0 to Length(DatumList) - 1 do
             if DatumList[I].Name = GetCols(OTList[N],2,1,#$9, false) then
             begin
               for j := 0 to Combobox1.Items.Count - 1 do
                 if  DatumList[I].Caption = Combobox1.Items[j] then
                 begin
                   Combobox1.ItemIndex := j;
                   break;
                 end;
               break;
             end;
           Radiogroup2.ItemIndex := StrToInt(GetCols(OTList[N],3,1,#$9, false));
           RadioGroup2.OnClick(nil);
      end;
      1: begin
           for I := 0 to Length(CoordinateSystemList) - 1 do
             if CoordinateSystemList[I].Name = GetCols(OTList[N],2,1,#$9, false) then
             begin
               for j := 0 to ComboBox2.Items.Count - 1 do
                 if CoordinateSystemList[I].Category = ComboBox2.Items[j] then
                 begin
                   ComboBox2.ItemIndex := j;
                   ComboBox2.OnChange(nil);
                   break;
                 end;

                 for j := 0 to ListBox4.Items.Count - 1 do
                 if ListBox4.Items[j] = CoordinateSystemList[I].Caption then
                 begin
                   ListBox4.ItemIndex := j;
                   ListBox4.OnClick(nil);
                   break;
                 end;
               
               break;
             end;
      end;
    end;

    RSpacer.ItemIndex := StrToInt(GetCols(OTList[N],4,1,#$9, false));
    Spacer.Text := GetCols(OTList[N],5,1,#$9, false);
    StartFrom.Value := StrToInt(GetCols(OTList[N],6,1,#$9, false));

    Col1.Value := StrToInt(GetCols(OTList[N],7,1,#$9, false));
    Col2.Value := StrToInt(GetCols(OTList[N],8,1,#$9, false));
    Col3.Value := StrToInt(GetCols(OTList[N],9,1,#$9, false));

    Col5.Value := StrToInt(GetCols(OTList[N],10,1,#$9, false));
    Col6.Value := StrToInt(GetCols(OTList[N],11,1,#$9, false));
    Col7.Value := StrToInt(GetCols(OTList[N],12,1,#$9, false));
    Col8.Value := StrToInt(GetCols(OTList[N],13,1,#$9, false));
    Col9.Value := StrToInt(GetCols(OTList[N],14,1,#$9, false));

    Col10.Value := StrToInt(GetCols(OTList[N],15,1,#$9, false));
    Col11.Value := StrToInt(GetCols(OTList[N],16,1,#$9, false));

    Col15.Value := StrToInt(GetCols(OTList[N],17,1,#$9, false));
    Col16.Value := StrToInt(GetCols(OTList[N],18,1,#$9, false));
    Col17.Value := StrToInt(GetCols(OTList[N],19,1,#$9, false));

    C5.Checked := GetCols(OTList[N],20,1,#$9, false) = '1';
    C6.Checked := GetCols(OTList[N],21,1,#$9, false) = '1';
    C7.Checked := GetCols(OTList[N],22,1,#$9, false) = '1';
    C8.Checked := GetCols(OTList[N],23,1,#$9, false) = '1';
    C9.Checked := GetCols(OTList[N],24,1,#$9, false) = '1';

    C10.Checked := GetCols(OTList[N],25,1,#$9, false) = '1';
    C11.Checked := GetCols(OTList[N],26,1,#$9, false) = '1';
    C12.Checked := GetCols(OTList[N],27,1,#$9, false) = '1';

    C14.Checked := GetCols(OTList[N],28,1,#$9, false) = '1';
    C15.Checked := GetCols(OTList[N],29,1,#$9, false) = '1';
    C16.Checked := GetCols(OTList[N],30,1,#$9, false) = '1';
    C17.Checked := GetCols(OTList[N],31,1,#$9, false) = '1';

    isMin.Checked := GetCols(OTList[N],32,1,#$9, false) = '1';
    isSec.Checked := GetCols(OTList[N],33,1,#$9, false) = '1';

    isWOY.Checked := GetCols(OTList[N],34,1,#$9, false) = '1';
    isDOY.Checked := GetCols(OTList[N],35,1,#$9, false) = '1';
    isSOW.Checked := GetCols(OTList[N],36,1,#$9, false) = '1';
    isFormatted.Checked := GetCols(OTList[N],37,1,#$9, false) = '1';

    Edit1.Text := GetCols(OTList[N],38,1,#$9, false);
    Edit2.Text := GetCols(OTList[N],39,1,#$9, false);

    Edit3.Value := StrToInt(GetCols(OTList[N],40,1,#$9, false));
    WeekEdit.Value := StrToInt(GetCols(OTList[N],41,1,#$9, false));
    Date1.DateTime := StrToFloat2(GetCols(OTList[N],42,1,#$9, false));
    TimeSys.ItemIndex := StrToInt(GetCols(OTList[N],43,1,#$9, false));

    Col4.Value := StrToInt(GetCols(OTList[N],44,1,#$9, false));

    RefreshRes;
    OpTmp.ItemIndex :=  N + 1;

  end;
    OTDel.Visible := OpTmp.ItemIndex > 0;
end;

procedure TLoadT.OTDelClick(Sender: TObject);
var FN:string;
begin
  if OPTmp.ItemIndex = 0 then
    exit;

  SetCurrentDir(MyDir);
  FN := 'Data\import_tracks.txt';

  if messageDlg(inf[224], mtConfirmation, mbYesNo, 0) = 6 then
  begin
    OTList.Delete(OPTmp.ItemIndex-1);
    OPTmp.Items.Delete(OPTmp.ItemIndex);
    OTList.SaveToFile(FN);
  end;

  OPTmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadT.OTSaveClick(Sender: TObject);
var FN, NewName, NewStr:string; I : Integer;
begin
  SetCurrentDir(MyDir);
  FN := 'Data\import_tracks.txt';

  if InputQuery(inf[223], inf[223], NewName) then
  begin
    if NewName = '' then
      NewName := '*';

    NewStr := Newname + #$9 + IntToStr(PageControl1.ActivePageIndex);
    case PageControl1.ActivePageIndex of
      0: NewStr := NewStr  + #$9 +
         DatumList[FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex])].Name
         + #$9 +  IntToStr(RadioGroup2.ItemIndex);
      1: NewStr := NewStr  + #$9 +
         CoordinateSystemList[FindCoordinateSystemByCaption
                                  (ListBox4.Items[ListBox4.ItemIndex])].Name + #$9 + '0';
    end;

    if Spacer.Text ='' then
       Spacer.Text :=' ';
       
    NewStr := NewStr + #$9 + IntToStr(RSpacer.ItemIndex) + #$9 + Spacer.Text;
    NewStr := NewStr + #$9 + IntToStr(StartFrom.Value);

    /// COLS
    NewStr := NewStr + #$9 + IntToStr(Col1.Value);
    NewStr := NewStr + #$9 + IntToStr(Col2.Value);
    NewStr := NewStr + #$9 + IntToStr(Col3.Value);

    NewStr := NewStr + #$9 + IntToStr(Col5.Value);
    NewStr := NewStr + #$9 + IntToStr(Col6.Value);
    NewStr := NewStr + #$9 + IntToStr(Col7.Value);
    NewStr := NewStr + #$9 + IntToStr(Col8.Value);
    NewStr := NewStr + #$9 + IntToStr(Col9.Value);

    NewStr := NewStr + #$9 + IntToStr(Col10.Value);
    NewStr := NewStr + #$9 + IntToStr(Col11.Value);

    NewStr := NewStr + #$9 + IntToStr(Col15.Value);
    NewStr := NewStr + #$9 + IntToStr(Col16.Value);
    NewStr := NewStr + #$9 + IntToStr(Col17.Value);

    ///  CS
    if C5.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C6.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C7.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C8.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C9.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';

    if C10.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C11.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C12.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';

    if C14.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C15.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C16.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if C17.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';

    /// minSec
    if isMin.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if isSec.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';

    ///  Time
    if isWOY.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if isDOY.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if isSOW.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';
    if isFormatted.Checked then  NewStr := NewStr + #$9 + '1' else NewStr := NewStr + #$9 + '0';

    if Edit1.Text = '' then
      Edit1.Text := ' ';
    if Edit2.Text = '' then
      Edit2.Text := ' ';

    NewStr := NewStr + #$9 + Edit1.Text;
    NewStr := NewStr + #$9 + Edit2.Text;

    NewStr := NewStr + #$9 + IntToStr(Edit3.Value);
    NewStr := NewStr + #$9 + IntToStr(WeekEdit.Value);
    NewStr := NewStr + #$9 + FloatToStr(Date1.DateTime);

    NewStr := NewStr + #$9 + IntToStr(TimeSys.ItemIndex);

    NewStr := NewStr + #$9 + IntToStr(Col4.Value);

    OTList.Add(NewStr);
    OTList.SaveToFile(FN);

    OPTmp.Items.Add(NewName);
    OPTmp.ItemIndex := OPTmp.Items.Count-1;
  end;
end;

procedure TLoadT.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: begin
         ComboBox1.OnChange(nil);
         RadioGroup2.OnClick(nil);
       end;
    1: begin
        ComboBox2.OnChange(nil);
        ListBox4.OnClick(nil);
      end;
  end;
end;

procedure TLoadT.RadioGroup2Click(Sender: TObject);
begin
{case RadioGroup2.ItemIndex of
    3,4: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);
    end;

    2: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);

    end;

    1: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := XS;
      ValueList.Keys[3] := YS;

      if ValueList.RowCount<5 then
        ValueList.InsertRow(ZS, '4', true);

      ValueList2.Keys[1] := XS;
      ValueList2.Keys[2] := YS;

      if ValueList2.RowCount<4 then
         ValueList2.InsertRow(ZS, '7', true);
    end;

    0: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := LatS+#176;
      ValueList.Keys[3] := LonS+#176;

      if ValueList.RowCount = 5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] :=  LatS +#176;
      ValueList2.Keys[2] :=  LonS +#176;

      if ValueList2.RowCount = 4 then
         ValueList2.DeleteRow(3);
    end;
  end;   }
  CoordType := RadioGroup2.ItemIndex ;
  RenameTabs(StringGrid1,CoordType);
  RefreshRes;
end;

procedure TLoadT.RefreshRes;
var i, J : integer;
    Sep : String;
begin
   ClearGrid(StringGrid1);
   OPTmp.ItemIndex := 0;
   OTDel.Visible := false;   
   RenameTabs(StringGrid1,CoordType);

   try

   for i:= StartFrom.Value-1 to S.count-1 do
   Begin
     if i<0 then
       continue;
       
     if i > (StartFrom.Value-1)+3 then exit;

     with StringGrid1 do
      // if i >= 4 - (StartFrom.Value-1) + RowCount-2 then
         RowCount := 5;

     if StringGrid1.RowCount > 1 then
       StringGrid1.FixedRows := 1;

     case RSpacer.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Spacer.Text<> '' then sep := Spacer.Text[1];
        3: sep:=';';
        4: sep:=',';
     end;

       StringGrid1.Cells[0,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col1.Value -1, 1, sep[1], False);
       StringGrid1.Cells[1,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col2.Value -1, 1, sep[1], False);
       StringGrid1.Cells[2,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col3.Value -1, 1, sep[1], False);

       if PanelMinSec.Visible then
       Begin
         if isSec.Checked then
         begin
           StringGrid1.Cells[1,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col2.Value -1, 3, sep[1], False);
           StringGrid1.Cells[2,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col3.Value -1, 3, sep[1], False);
         end
           else
           if isMin.Checked then
           begin
             StringGrid1.Cells[1,i+1-(StartFrom.Value-1)] :=
              GetCols(s[i], Col2.Value -1, 2, sep[1], False);
             StringGrid1.Cells[2,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col3.Value -1, 2, sep[1], False);
           end;
       End;

       J := 2;

       if Label5.Visible then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
             GetCols(s[i], Col4.Value -1, 1, sep[1], False);
       end;

       if C5.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col5.Value -1, 1, sep[1], False);
       end;

       if C6.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col6.Value -1, 1, sep[1], False);
       end;

       if C7.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col7.Value -1, 1, sep[1], False);
       end;

       if C8.Checked then
         StringGrid1.Cells[ StringGrid1.ColCount-1,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col8.Value -1, 1, sep[1], False);

       if C9.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col9.Value -1, 1, sep[1], False);
       end;

       if C10.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col10.Value -1, 1, sep[1], False);
       end;

       if C11.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col11.Value -1, 1, sep[1], False);
       end;

       if C15.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col15.Value -1, 1, sep[1], False);
       end;

       if C16.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col16.Value -1, 1, sep[1], False);
       end;

       if C17.Checked then
       begin
         inc(J);
         StringGrid1.Cells[J,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col17.Value -1, 1, sep[1], False);
       end;

     end;


   except
   end;

   // for i:= 0 to StringGrid1.ColCount-1 do
   // StringGrid1.ColWidths[i] := (StringGrid1.Width - 10) div StringGrid1.ColCount;
end;

procedure TLoadT.RSpacerClick(Sender: TObject);
begin
  Spacer.Enabled := RSpacer.ItemIndex = 2;

  RefreshRes;
end;

procedure TLoadT.StartFromChange(Sender: TObject);
begin
  RefreshRes;
end;

procedure TLoadT.WeekButtonClick(Sender: TObject);
begin
  FCalendar.ShowModal;
end;

end.
