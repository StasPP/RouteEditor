unit UKnotList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, MapEditor, MapFunctions, LangLoader;

type
  TFKnotList = class(TForm)
    AllKnots: TListBox;
    LButtonsPanel: TPanel;
    DelKn: TSpeedButton;
    EditKn: TSpeedButton;
    ViewKn: TSpeedButton;
    ShiftKn: TSpeedButton;
    procedure AllKnotsClick(Sender: TObject);
    procedure AllKnotsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ViewKnClick(Sender: TObject);
    procedure DelKnClick(Sender: TObject);
    procedure ShiftKnClick(Sender: TObject);
    procedure EditKnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AllKnotsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure RefreshKnotList;
    procedure ResetKnotList;
    { Public declarations }
  end;

var
  FKnotList :TFKnotList;
  NeedShift :Boolean;
implementation

uses UMovep, MapperFm, UKnotPickets, ParUnit1;

{$R *.dfm}

{ TFKnotList }

procedure TFKnotList.AllKnotsClick(Sender: TObject);
var j, I:integer;
begin
  case AllKnots.MultiSelect of
    true: begin
      EditKn.Enabled  := AllKnots.SelCount > 0;
      DelKn.Enabled   := AllKnots.SelCount > 0;
      ViewKn.Enabled  := AllKnots.SelCount > 0;
      ShiftKn.Enabled := AllKnots.SelCount > 0;
    end;
    false: begin
      EditKn.Enabled := AllKnots.ItemIndex >= 0;
      DelKn.Enabled  := AllKnots.ItemIndex >= 0;
      ViewKn.Enabled := AllKnots.ItemIndex >= 0;
      ShiftKn.Enabled:= AllKnots.ItemIndex >= 0;
    end;
  end;

  SetLength(SelectedKnots, 0);
  case AllKnots.MultiSelect of
     false: begin
        if AllKnots.ItemIndex >= 0 then
        begin
            SetLength(SelectedKnots, 1);
            SelectedKnots[0] :=  AllKnots.ItemIndex;
        end;
     end;

     true: begin
        SetLength(SelectedKnots, AllKnots.SelCount);
        j := 0;
        for I := 0 to AllKnots.Items.Count - 1 do
           if AllKnots.Selected[I] then
           begin
             SelectedKnots[j] :=  I;
             inc(j);
           end;
     end;
  end;

  MapFm.KnotSettings.Hide;

  if Movep.Showing then
     Movep.Close;
end;

procedure TFKnotList.AllKnotsDblClick(Sender: TObject);
begin
  ViewKn.Click;
  if NeedShift = false then
      EditKn.Click;
end;

procedure TFKnotList.AllKnotsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then
    DelKn.Click;

  if Key = vk_Return then
  begin
    ViewKn.Click;
    EditKn.Click;
  end;

  if Movep.Showing then
     Movep.Close;
end;

procedure TFKnotList.DelKnClick(Sender: TObject);
var I:Integer;
begin
if Length(SelectedKnots) = 0 then
   exit;

 for I := Length(SelectedKnots) - 1 downto 0 do
   DelKnot(SelectedKnots[I]);

 MapFm.SaveCtrlZ;

 if AllKnots.ItemIndex > 0 then
     AllKnots.ItemIndex := AllKnots.ItemIndex -  Length(SelectedKnots);

 SetLength(SelectedKnots, 0);
 RefreshKnotList;

 MapFm.SaveCtrlZ;

 if Movep.Showing then
     Movep.Close;
end;

procedure TFKnotList.EditKnClick(Sender: TObject);
var I, A:Integer;
    isDif :array[1..8] of boolean;
begin
  if Length(SelectedKnots) = 0  then
   exit;

  for I := 1 to 6 do
      isDif[I] := false;

  if Length(SelectedKnots) > 1  then
    for I := 1 to Length(SelectedKnots) - 1 do
    begin
      if not isDif[1] then
         if KnotPoints[SelectedKnots[0]].Name <>
            KnotPoints[SelectedKnots[I]].Name then
              isDif[1] := true;

      if not isDif[2] then
         if KnotPoints[SelectedKnots[0]].NameKind <>
            KnotPoints[SelectedKnots[I]].NameKind then
              isDif[2] := true;

      if not isDif[3] then
         if KnotPoints[SelectedKnots[0]].BoxSize <>
            KnotPoints[SelectedKnots[I]].BoxSize then
              isDif[3] := true;

      if not isDif[4] then
         if KnotPoints[SelectedKnots[0]].BoxAngle <>
            KnotPoints[SelectedKnots[I]].BoxAngle then
              isDif[4] := true;

      if not isDif[5] then
         if (KnotPoints[SelectedKnots[0]].PMethod <>
             KnotPoints[SelectedKnots[I]].PMethod) or
             (KnotPoints[SelectedKnots[0]].Lmax <>
             KnotPoints[SelectedKnots[I]].Lmax) or
             (KnotPoints[SelectedKnots[0]].Lx <>
             KnotPoints[SelectedKnots[I]].Lx) or
             (KnotPoints[SelectedKnots[0]].Ly <>
             KnotPoints[SelectedKnots[I]].Ly) or
             (KnotPoints[SelectedKnots[0]].RouteN <>
             KnotPoints[SelectedKnots[I]].RouteN) or
             (KnotPoints[SelectedKnots[0]].DropToRoute <>
             KnotPoints[SelectedKnots[I]].DropToRoute) or
             (KnotPoints[SelectedKnots[0]].StepOut <>
             KnotPoints[SelectedKnots[I]].StepOut) or
             (KnotPoints[SelectedKnots[0]].NameKind2 <>
             KnotPoints[SelectedKnots[I]].NameKind2)
          then
              isDif[5] := true;


       if KnotPoints[SelectedKnots[0]].Shp <>
            KnotPoints[SelectedKnots[I]].Shp then
              isDif[6] := true;

        if KnotPoints[SelectedKnots[0]].ShStep <>
            KnotPoints[SelectedKnots[I]].ShStep then
              isDif[7] := true;

        if KnotPoints[SelectedKnots[0]].BoxSize2 <>
            KnotPoints[SelectedKnots[I]].BoxSize2 then
              isDif[8] := true;
    end;

  MapFm.KnotSettings.Show;
  with MapFm Do
  Begin
    NotChangeKnot := true;
    if isDif[6] then
      Rndloop := 3
        else
           Rndloop := KnotPoints[SelectedKnots[0]].Shp;

    LoopShape.Glyph.Assign(nil);
    RedForm.ImageList1.GetBitmap(19 + Rndloop, LoopShape.Glyph);
    LoopShape.Hint := Inf[213 + RndLoop];
    if RndLoop = 1 then
      SetKnSizeLabel.Caption := inf[221]
    else
      SetKnSizeLabel.Caption := inf[220];

    SetSPan.Visible  :=  RndLoop = 1;
    SetS2Pan.Visible :=  RndLoop = 2;

    SetKnName.Text := KnotPoints[SelectedKnots[0]].Name;
    if isDif[1] then
      SetKnName.Font.Color := clRed
    else
      SetKnName.Font.Color := clWindowText;

    SetSstep.Text := floattostr(KnotPoints[SelectedKnots[0]].ShStep);
    if isDif[7] then
      SetSstep.Font.Color := clRed
    else
      SetSstep.Font.Color := clWindowText;

    SetKnNameKind.ItemIndex := KnotPoints[SelectedKnots[0]].NameKind-1;
    RefreshKnExamples;
    if KnotPoints[SelectedKnots[0]].NameKind = 0  then
         SetKnNameKind.ItemIndex := 0;
    if isDif[2] then
      SetKnNameKind.Font.Color := clRed
    else
      SetKnNameKind.Font.Color := clWindowText;

    SetKnSize2.Value := round(1000*KnotPoints[SelectedKnots[0]].BoxSize2)/1000;
    
    SetKnSize.Value := round(1000*KnotPoints[SelectedKnots[0]].BoxSize)/1000;
    if isDif[3] then
      SetKnSize.Font.Color := clRed
    else
      SetKnSize.Font.Color := clWindowText;

    if isDif[8] then
      SetKnSize2.Font.Color := clRed
    else
      SetKnSize2.Font.Color := clWindowText;

    A := round(1000*KnotPoints[SelectedKnots[0]].BoxAngle*180/pi);
    if A < 0 then
      A := A +360*1000;

    MapperFm.SetKnAng.Value := A/1000;
    if isDif[4] then
      MapperFm.SetKnAng.Font.Color := clRed
    else
      MapperFm.SetKnAng.Font.Color := clWindowText;

    SetKnL.Value := KnotPoints[SelectedKnots[0]].L;

    SetKnL.Enabled := not (Length(SelectedKnots) > 1);
    GroupNum.Visible := not SetKnL.Enabled; 
    SetKnLLabel.Enabled := SetKnL.Enabled;
    SetKnXY.Enabled := SetKnL.Enabled;

    GetKnotPickets(KnotPoints[SelectedKnots[0]], false);
    Label28.Caption := intToStr(PktCount);
    Label26.Caption := FKnotPickets.PktMethod.Items[ KnotPoints[SelectedKnots[0]].Pmethod ];

    if isDif[5] then
    begin
      Label26.Font.Color := clRed;
      Label28.Font.Color := clRed;
    end else
    begin
      Label26.Font.Color := clWindowText;
      Label28.Font.Color := clWindowText;
    end;

    NotChangeKnot := false;
  End;

  SaveKnots(TmpDir+'TmpKnots.rnk', false);

  MapFm.NewKnotPanel.Hide;
  MapFm.NewKnotPanel2.Hide;
  MapFm.RefreshKnExamples;
  MapFm.ModeButtons;
end;

procedure TFKnotList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MapFm.KnotSettings.Hide;
end;

procedure TFKnotList.RefreshKnotList;
var I, J:Integer;
begin
 J := AllKnots.ItemIndex;
 AllKnots.Clear;
 for I := 0 to Length(KnotPoints) - 1 do
   if I < KnotCount then
   begin
     if KnotPoints[I].Name <> '' then
       AllKnots.Items.Add(KnotPoints[I].Name
            + '_L' +FormatFloat('000', KnotPoints[I].L))
     else
       AllKnots.Items.Add('L' +FormatFloat('000', KnotPoints[I].L));
   end;


 for I := 0 to Length(SelectedKnots) - 1 do
   if AllKnots.Items.Count > SelectedKnots[I] then
      AllKnots.Selected[SelectedKnots[I]] := true;

 if AllKnots.SelCount = 0 then
 if AllKnots.Items.Count > J then
 begin
   AllKnots.ItemIndex := J;
   AllKnots.Selected[J] := true;
 end;

 AllKnots.OnClick(nil);

 if KnotCount = 0 then
   close;
end;

procedure TFKnotList.ResetKnotList;
var I, J:Integer;
begin
 AllKnots.ClearSelection;
 AllKnots.ItemIndex := -1;
 AllKnots.Clear;
 for I := 0 to Length(KnotPoints) - 1 do
   if I < KnotCount then
   begin
     if KnotPoints[I].Name <> '' then
       AllKnots.Items.Add(KnotPoints[I].Name
            + '_L' +FormatFloat('000', KnotPoints[I].L))
     else
       AllKnots.Items.Add('L' +FormatFloat('000', KnotPoints[I].L));
   end;

 //AllKnots.OnClick(nil);
 EditKn.Enabled  := AllKnots.SelCount > 0;
 DelKn.Enabled   := AllKnots.SelCount > 0;
 ViewKn.Enabled  := AllKnots.SelCount > 0;
 ShiftKn.Enabled := AllKnots.SelCount > 0;

 if KnotCount = 0 then
   close;
end;

procedure TFKnotList.ShiftKnClick(Sender: TObject);
begin
  Movep.Show;
  Movep.Top   := MapFm.Top - (MapFm.ClientHeight - MapFM.Height)
                 + MapFm.Tools.Height - 5;
  Movep.Left  := MapFm.Left - (MapFm.ClientWidth - MapFM.Width) div 2 + 3;

  if MapFm.KnotSettings.Visible then
   Movep.Left  := Movep.Left + MapFm.KnotSettings.Width + 10
   // Movep.Top := Movep.Top + MapFm.KnotSettings.Height + 10;
end;

procedure TFKnotList.ViewKnClick(Sender: TObject);
var I, j, n :Integer;
    x, y :Double;
    xmax, ymax, xmin, ymin :Double;

    procedure InitC (x, y, sz:Double);
    begin
      xmin := x - sz;  ymin := y - sz;   xmax := x + sz;    ymax := y + sz;
    end;

    procedure CompareC(x, y, sz:Double);
    begin
     if x - sz < xmin then
        xmin  := x - sz;
     if y - sz < ymin then
        ymin := y - sz;
     if x + sz > xmax then
        xmax  := x + sz;
     if y + sz > ymax then
        ymax := y + sz;
    end;

begin
  NeedShift := true;

  if AllKnots.MultiSelect then
  begin
      N := AllKnots.SelCount;

      if N <= 0 then
        exit;

      x := 0;     y := 0;     N := 0;
      for I := 0 to AllKnots.Items.Count - 1 do
       if AllKnots.Selected[I] then
       begin
         inc(N);
         if N = 1 then
            InitC(KnotPoints[I].Cx, KnotPoints[I].Cy, KnotPoints[I].BoxSize)
              else
                CompareC(KnotPoints[I].Cx, KnotPoints[I].Cy, KnotPoints[I].BoxSize);

         GetKnotPickets(KnotPoints[I], false);
         for j := 0 to PktCount - 1 do
           CompareC(KnotPoints[I].Cx + Pkt[j].x, KnotPoints[I].Cy + Pkt[j].y,
           KnotPoints[I].BoxSize);
       end;
       x := (xmin  + xmax) /2;
       y := (ymin  + ymax) /2;

       if N > 0 then
       begin
         I := 0;
         repeat
            inc(i);
            if abs(xmin-xmax) > abs(ymin-ymax) then
              N := trunc( abs(xmin-xmax) /TMashtab[I])
            else
              N := trunc( abs(ymin-ymax) /TMashtab[I])
         until (I >= MaxMashtab-1) or (N <= MapFm.Canv.Height div 100);
         Mashtab := I;
      end;

  end
  else
    begin
      I := AllKnots.ItemIndex;

      if I =-1 then
        exit;

      Center.x := KnotPoints[I].Cx;
      Center.y := KnotPoints[I].Cy;
    end;

  Center.x := x;
  Center.y := y;

  if (ShiftCenter.x = Center.x) and
     (ShiftCenter.y = Center.y) then
       NeedShift := false;

  ShiftCenter.x := Center.x;
  ShiftCenter.y := Center.y;
end;

end.
