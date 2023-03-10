unit UOrderW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, BasicMapObjects, MapEditor, LangLoader,
  ImgList, MapFunctions, Menus;

type
  TOrderW = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    RUp: TSpeedButton;
    RDown: TSpeedButton;
    RInv: TSpeedButton;
    Panel2: TPanel;
    RRew: TSpeedButton;
    RRnm: TSpeedButton;
    RDel: TSpeedButton;
    Collapse: TSpeedButton;
    Clone: TSpeedButton;
    Panel3: TPanel;
    Panel4: TPanel;
    OKButton: TButton;
    AddOrt: TSpeedButton;
    ImageList1: TImageList;
    rHidden: TSpeedButton;
    rFix: TSpeedButton;
    Panel5: TPanel;
    JumpRoutes: TSpeedButton;
    Zoom1: TSpeedButton;
    Zoom2: TSpeedButton;
    Panel6: TPanel;
    SA: TSpeedButton;
    PM: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure GetSelected;
    procedure CheckButtons;
    procedure RefreshList;

    procedure FormShow(Sender: TObject);
    procedure RUpClick(Sender: TObject);
    procedure RDownClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure RDelClick(Sender: TObject);
    procedure RRewClick(Sender: TObject);
    procedure RRnmClick(Sender: TObject);
    procedure RInvClick(Sender: TObject);
    procedure CollapseClick(Sender: TObject);
    procedure CloneClick(Sender: TObject);
    procedure CheckSave;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKButtonClick(Sender: TObject);
    procedure AddOrtClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure rHiddenClick(Sender: TObject);
    procedure rFixClick(Sender: TObject);
    procedure ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure JumpRoutesClick(Sender: TObject);
    procedure Zoom1Click(Sender: TObject);
    procedure Zoom2Click(Sender: TObject);
    procedure SAClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    NeedSave: Boolean;
    { Public declarations }
  end;

var
  OrderW: TOrderW;
  _Selected: Array of Integer;
  Started: Boolean = false;
implementation

uses MapperFm, UClone, URNewOps, UCollapseFm;

{$R *.dfm}

procedure TOrderW.AddOrtClick(Sender: TObject);
begin

  RouteOps.Caption := AddOrt.Hint;
  RouteOps.isShowSpin := 2;
  MapFm.RefreshRouteBox;
  RouteOps.RouteBox.Items := MapFm.RouteBox.Items;
  RouteOps.RouteBox.ItemIndex := ListBox1.ItemIndex+1;
  RouteOps.ShowModal;

  if RouteOps.isROk then
  begin
    OrthoRoutes(RouteOps.RouteBox.ItemIndex-1,
                RouteOps.Do1Ort.Checked,
                URNewOps.OrtStep1.Value, URNewOps.OrtStep.Value,
                URNewOps.OrtL.Value, URNewOps.OrtR.Value,
                RouteOps.OrtStartN.Value,
                RouteOps.OrtName.Text, RouteOps.OrtSep.Text);

    MapFm.SaveCtrlZ;
  end;
  RefreshList;
  ReComputeRoutes(False);
  RefreshSelectionArrays;
  RefreshList;
  CheckButtons;
end;

procedure TOrderW.CheckButtons;
begin
  GetSelected;
  Panel2.Visible := Length(_Selected) > 0;
  RRnm.Enabled := Length(_Selected) = 1;
  Collapse.Enabled :=  Length(_Selected) >= 2;
  Clone.Enabled :=  Length(_Selected) = 1;
  AddOrt.Enabled :=  Length(_Selected) = 1;
  Rinv.Enabled := RouteCount > 1;

  SA.Enabled := RouteCount > 1;

  RUp.Enabled   := False;
  RDown.Enabled := False;
  if Length(_Selected) > 0 then
  Begin
   RUp.Enabled   := _Selected[0] > 0;
   RDown.Enabled := _Selected[Length(_Selected)-1] < ListBox1.Count-1;
  End;
end;

procedure TOrderW.CheckSave;
begin
  if not(NeedSave) then
  Begin
    NeedSave := true;
    MapFm.SaveCtrlZ;
  End;
end;

procedure TOrderW.CloneClick(Sender: TObject);
var OldRouteCount :Integer;
begin
  if CloneFm.CloneRouteNum = -1 then
    exit;

  CloneFm.CloneRouteNum := ListBox1.ItemIndex;
  CloneFm.NameEdit.Text := ListBox1.Items[ListBox1.ItemIndex]+ inf[101];
  CloneFm.ShowModal;

  RefreshList;
  ReComputeRoutes(False);
  RefreshSelectionArrays;
  RefreshList;
  CheckButtons;
end;

procedure TOrderW.CollapseClick(Sender: TObject);
    var SysCurPos :TPoint;
begin
  GetCursorPos(SysCurPos);
  if Length(_Selected) = 2 then
     PM.Popup(SysCurPos.X, SysCurPos.Y)
  else
     N2.Click;
end;

procedure TOrderW.FormActivate(Sender: TObject);
begin
 if not Started then
  Begin
    Started := true;
  //  Top   := MapFm.Top + 20 +(MapFm.Height - Height) div 2;
  //  Left  := MapFm.Left + MapFm.Width - Width;
  End;
end;

procedure TOrderW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 RouteAsk := -1;
 if NeedSave then
    MapFm.SaveCtrlZ;
end;

procedure TOrderW.FormShow(Sender: TObject);
begin

 RefreshList;
 GetSelected;
 CheckButtons;
 NeedSave := false;
end;

procedure TOrderW.GetSelected;
var I: Integer;
begin
  SetLength(_Selected, 0);
  for I := 0 to ListBox1.Count - 1 do
     if ListBox1.Selected[I] then
        Begin
          SetLength(_Selected, Length(_Selected)+1);
          _Selected[Length(_Selected)-1] := I;
        End;

   RouteAsk := -1;
  if Length(_Selected) = 1 then
     RouteAsk := _Selected[0];
end;

procedure TOrderW.JumpRoutesClick(Sender: TObject);
begin
  MapFm.JumpRoutes.Click;
end;

procedure TOrderW.ListBox1Click(Sender: TObject);
begin
  GetSelected;
  CheckButtons;
end;

procedure TOrderW.ListBox1DblClick(Sender: TObject);
begin

    if Length(_Selected) = 1 then
    begin
      RouteAsk := _Selected[0];
      Width := Constraints.MinWidth;
      Top   := MapFm.Top + 20 +(MapFm.Height - Height) div 2;
      Left  := MapFm.Left + MapFm.Width - Width;

      Panel5.Visible := true;
    end;
    MapFm.JumpToRoutesMap(RouteAsk);

end;

procedure TOrderW.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var  Offset, dy: Integer; { ?????? ??????? ?????? }
begin

  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    Offset := 48;
    if Index < RouteCount then
    begin
      case Route[Index].Status of
        0..3:  ImageList1.Draw(ListBox1.Canvas, Rect.Left + 1, Rect.Top, 0);
        else   ImageList1.Draw(ListBox1.Canvas, Rect.Left + 1, Rect.Top, 1);
      end;
      if Length(Route[Index].WPT) = 1 then
        ImageList1.Draw(ListBox1.Canvas, Rect.Left + 18, Rect.Top, 2)
      else
        if Length(Route[Index].WPT) > 2 then
          ImageList1.Draw(ListBox1.Canvas, Rect.Left + 18, Rect.Top, 4)
        else
          ImageList1.Draw(ListBox1.Canvas, Rect.Left + 18, Rect.Top, 3);

      case Route[Index].Fixed of
        false:  ImageList1.Draw(ListBox1.Canvas, Rect.Left + 32, Rect.Top, 5);
        true:   ImageList1.Draw(ListBox1.Canvas, Rect.Left + 32, Rect.Top, 6);
      end;
    end;


    TextOut(Rect.Left + Offset, Rect.Top+1, (Control as TListBox).Items[Index])
  end;
end;

procedure TOrderW.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = Ord('Z')) then
  begin
   MapFm.LoadCtrlZ(ssShift in Shift);
   RefreshList;
   GetSelected;
   CheckButtons;
  end;

  if Key = vk_Return then
  begin
    if Length(_Selected) = 1 then
    begin
      RouteAsk := _Selected[0];
      Width := Constraints.MinWidth;
      Top   := MapFm.Top + 20 +(MapFm.Height - Height) div 2;
      Left  := MapFm.Left + MapFm.Width - Width;

      Panel5.Visible := true;
    end;
    MapFm.JumpToRoutesMap(RouteAsk);
  end;
  
  if Key = vk_Delete then
    RDel.Click;
end;

procedure TOrderW.ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var P:TPoint; I:LongInt; s:string;
begin
  if not (Sender is TListBox) then
     exit;

  P.X := X; P.Y := Y;
  I := ListBox1.ItemAtPos(P, true);
  s := '';
  if I<>-1 then
  try
    case X of
      0..16 : if Route[I].Status < 4 then
                s := inf[161]
              else
                s := inf[162];
      17..32: case length(Route[I].WPT) of
                1: s := inf[163];
                0, 2: s := inf[164];
                else s := inf[165];
              end;
      33..48: if Route[I].Fixed then
                s := inf[167]
              else
                s := inf[166];
    end;
  except
  end;

  if s <> '' then
  begin
    if not ListBox1.ShowHint then
      ListBox1.ShowHint := true;


    idx := I;
    if (idx < 0) or (idx = oldidx) then
      Exit;

    Application.ProcessMessages;
    if s <> Hint then
    begin
       Application.CancelHint;
       Hint := s;
       Application.ActivateHint(P);
    end;

    HintX := x+10;
    HintY := y;
   
  end
  else
    begin
      Application.CancelHint;
      Hint := '';
      ListBox1.ShowHint := false;
    end;

end;

procedure TOrderW.N1Click(Sender: TObject);
var I:Integer;
begin
  GetSelected;
  MapFm.SaveCtrlZ;

   CollapseRoutes(_Selected[0], _Selected[1]);
    if _Selected[0] < _Selected[1] then
        I := _Selected[0]
    else
        I := _Selected[1];

  RefreshSelectionArrays;
  RefreshList;
  ListBox1.ItemIndex := I;
  CheckButtons;
end;

procedure TOrderW.N2Click(Sender: TObject);
  var I: integer;
begin
  GetSelected;
  
  CollapseFm.Init(_Selected);
  CollapseFm.ShowModal;

  MapFm.SaveCtrlZ;
  RefreshSelectionArrays;
  RefreshList;
  ListBox1.ItemIndex := ListBox1.Items.Count-1;
  CheckButtons;
end;

procedure TOrderW.OKButtonClick(Sender: TObject);
begin
  Close;
  MapFm.RefreshRouteBox;
end;

procedure TOrderW.RUpClick(Sender: TObject);
var I: Integer;
begin
   GetSelected;

   if Length(_Selected)=0 then
      exit;

   if _Selected[0] = 0 then
      exit;

   for I := 0  to Length(_Selected)-1   do
     ReplaceRoute(_Selected[I]-1, _Selected[I]);

   RefreshSelectionArrays;
   RefreshList;

   for I := 0  to Length(_Selected)-1   do
     ListBox1.Selected[_Selected[I]-1] := True;

   CheckButtons;
   CheckSave;
end;

procedure TOrderW.SAClick(Sender: TObject);
var I:Integer;  b:boolean;
begin
  if ListBox1.Count = 0 then
    exit;

  b := ListBox1.Selected[0];

  for I := 0 to ListBox1.Count - 1 do
    ListBox1.Selected[I] := not b;

  GetSelected;
  CheckButtons;
end;

procedure TOrderW.Zoom1Click(Sender: TObject);
begin
  CanvCursor.x := MapFm.Canv.Width div 2 -50;
  CanvCursor.y := MapFm.Canv.Height div 2;
  ShiftMap(0);
end;

procedure TOrderW.Zoom2Click(Sender: TObject);
begin
  CanvCursor.x := MapFm.Canv.Width div 2 -50;
  CanvCursor.y := MapFm.Canv.Height div 2;
  ShiftMap(1);
end;

procedure TOrderW.RDownClick(Sender: TObject);
var I: integer;
begin
   GetSelected;

   if Length(_Selected)=0 then
      exit;

   if _Selected[Length(_Selected)-1] >= ListBox1.Count-1  then
      exit;

   for I := Length(_Selected)-1 Downto 0  do
     ReplaceRoute(_Selected[I]+1, _Selected[I]);

   RefreshSelectionArrays;
   RefreshList;

   for I := 0  to Length(_Selected)-1   do
     ListBox1.Selected[_Selected[I]+1] := True;

  CheckButtons;
  CheckSave; 
end;

procedure TOrderW.RefreshList;
var I: integer;
begin
  ListBox1.Clear;
  for I := 0 to RouteCount - 1 do
    ListBox1.Items.Add(Route[I].Name);

  //CheckButtons;
  //MapFm.RenderEvent(nil);
end;

procedure SetRouteVis(I:Integer; Vis:boolean);
begin
  if (I < RouteCount) and (I >= 0) then
  case Vis of
    true: if Route[I].Status >= 4 then
             Route[I].Status :=  Route[I].Status - 4;
    false: if Route[I].Status < 4 then
             Route[I].Status :=  Route[I].Status + 4;
  end;
end;

procedure SetRouteFix(I:Integer; Fix:boolean);
begin
   if (I < RouteCount) and (I >= 0) then
     Route[I].Fixed := Fix;
end;

procedure TOrderW.rFixClick(Sender: TObject);
var f: boolean; I:Integer;
begin
   GetSelected;

   if Length(_Selected) = 0 then
     exit;

   f := Route[_Selected[0]].Fixed;

   for I := 0 to length(_Selected)-1 do
      SetRouteFix(_Selected[I], not f);



  RefreshSelectionArrays;
  RefreshList;
  for I := 0 to Length(_Selected)-1 do
    ListBox1.Selected[_Selected[I]] := True;
  CheckSave;
end;

procedure TOrderW.rHiddenClick(Sender: TObject);
var vis:Boolean; I:Integer;
begin
   GetSelected;

   if Length(_Selected) = 0 then
     exit;

   vis := Route[_Selected[0]].Status < 4;

   for I := 0 to length(_Selected)-1 do
      SetRouteVis(_Selected[I], not vis);

  RefreshSelectionArrays;
  RefreshList;
  for I := 0 to Length(_Selected)-1 do
    ListBox1.Selected[_Selected[I]] := True;
  CheckSave;
end;

procedure TOrderW.RInvClick(Sender: TObject);
var I: Integer;
    A:Array of Integer;
begin

   GetSelected;

//   if Length(_Selected) >0 then
//   if _Selected[Length(_Selected)-1] >= ListBox1.Count-1  then
//      exit;

   if Length(_Selected) < 2 then
   begin
      for I := 0 to trunc((ListBox1.Count-1)/ 2) do
        ReplaceRoute(I, RouteCount-I-1);
   end
   else
      for I := 0 to trunc((length(_Selected)-1)/2) do
        ReplaceRoute(_Selected[I], _Selected[length(_Selected)-I-1]);


 

  RefreshList;
  CheckSave;

  for I := 0 to Length(_Selected)-1 do
    ListBox1.Selected[_Selected[I]] := True;
end;

procedure TOrderW.RRewClick(Sender: TObject);
var I: Integer;
begin
  GetSelected;
  if Length(_Selected)=0 then
      exit;

   CheckSave;
      
   for I := 0  to Length(_Selected)-1   do
     RewerseRoute(_Selected[I]);    

   RoutesToGeo;
   RecomputeRoutes(false);
   RefreshSelectionArrays;
   

   ShowMessage(inf[30]);
end;

procedure TOrderW.RRnmClick(Sender: TObject);
begin
  GetSelected;
  if Length(_Selected)=0 then
      exit;

   SelectedRouteN := _Selected[0];
   MapFm.RenameRoute;

   RefreshSelectionArrays;
   RefreshList;
   ListBox1.Selected[_Selected[0]] := True;
end;

procedure TOrderW.RDelClick(Sender: TObject);
var I: Integer;
begin
   GetSelected;

   if Length(_Selected)=0 then
      exit;

   CheckSave;   

   for I := Length(_Selected)-1 Downto 0  do
     DelRoute(_Selected[I]);

   I := ListBox1.ItemIndex;

   RefreshSelectionArrays;
   RefreshList;


   try
      if I > 0 then
         Dec(I);
      if I >= ListBox1.Count  then
         I := ListBox1.Count - 1;

      if ListBox1.Count > 0 then
         ListBox1.Selected[I] := True;
   except
   end;
   CheckButtons;
end;

end.
