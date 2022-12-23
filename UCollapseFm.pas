﻿unit UCollapseFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, BAsicMapObjects, Spin, LangLoader,
  MapEditor;

type
  TCollapseFm = class(TForm)
    BottomPanel: TPanel;
    ButtonsPanel: TPanel;
    OkButton: TButton;
    CancelButton: TButton;
    MainPanel: TPanel;
    Splitter: TSplitter;
    RPanel: TPanel;
    RoutesMerge: TListBox;
    RButtonsPanel: TPanel;
    UpBtn: TSpeedButton;
    DelBtn: TSpeedButton;
    UpBtn2: TSpeedButton;
    DownBtn2: TSpeedButton;
    DownBtn: TSpeedButton;
    DelAllBtn: TSpeedButton;
    RTitlePanel: TPanel;
    RTitle: TLabel;
    LPanel: TPanel;
    AllRTS: TListBox;
    LButtonsPanel: TPanel;
    SendBtn: TSpeedButton;
    SendAllBtn: TSpeedButton;
    LTitlePanel: TPanel;
    LTitle: TLabel;
    SpacerPanel: TPanel;
    DoRad: TCheckBox;
    GroupBox1: TGroupBox;
    NoLoop: TRadioButton;
    DoLoop: TRadioButton;
    Label2: TLabel;
    RtStep: TSpinEdit;
    DelOld: TCheckBox;
    GroupBox2: TGroupBox;
    imiLabel1: TLabel;
    imiLabel3: TLabel;
    imiStep: TSpinEdit;
    ImiRad: TSpinEdit;
    NewH: TSpinEdit;
    AddH: TCheckBox;
    procedure RoutesMergeClick(Sender: TObject);
    procedure RoutesMergeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AllRTSMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AllRTSClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure Init(Arr: Array of Integer);
    procedure RefreshLists;
    procedure SendBtnClick(Sender: TObject);
    procedure SendAllBtnClick(Sender: TObject);
    procedure UpBtn2Click(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure DownBtn2Click(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure DelAllBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CollapseFm: TCollapseFm;
   A, B : Array of Integer;
  _Selected : Array of Integer;

implementation

uses MapperFm, UNamer;

{$R *.dfm}

procedure GetSelected(ListBox:TListBox);
var I: Integer;
begin
  SetLength(_Selected, 0);
  for I := 0 to ListBox.Count - 1 do
     if ListBox.Selected[I] then
        Begin
          SetLength(_Selected, Length(_Selected)+1);
          _Selected[Length(_Selected)-1] := I;
        End;
end;

function FirstSel(ListBox:TListBox):integer;
var I: Integer;
begin
  result := -1;
  for I := 0 to ListBox.Count - 1 do
     if ListBox.Selected[I] then
        Begin
          result := i;
          break;
        End;
end;

function LastSel(ListBox:TListBox):integer;
var I: Integer;
begin
  result := -1;
  for I := ListBox.Count - 1 downto 0 do
     if ListBox.Selected[I] then
        Begin
          result := i;
          break;
        End;
end;

procedure TCollapseFm.AllRTSClick(Sender: TObject);
begin
  SendBtn.Enabled     := AllRTS.SelCount > 0;
  SendAllBtn.Enabled  := AllRTS.Count > 0;
end;

procedure TCollapseFm.AllRTSMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  AllRTS.SetFocus;
end;

procedure TCollapseFm.CancelButtonClick(Sender: TObject);
begin
  close;
end;

procedure TCollapseFm.DelAllBtnClick(Sender: TObject);
procedure DelFromB(N:Integer);
 var I: Integer;
 begin
   For I := N To Length(B) -2 Do
     B[I] := B[I+1];

   SetLength(B, Length(B) -1);
 end;

 var J:integer;
begin

  while Length(B) > 0 do
  begin

    J := Length(A);
    SetLength(A, J +1);

    A[J] := B[0];

    DelFromB(0);

  end;

   RefreshLists;
end;

procedure TCollapseFm.DelBtnClick(Sender: TObject);
procedure DelFromB(N:Integer);
 var I: Integer;
 begin
   For I := N To Length(B) -2 Do
     B[I] := B[I+1];

   SetLength(B, Length(B) -1);
 end;

var I, J: Integer;
begin

  GetSelected(RoutesMerge);
  for I := Length(_Selected) - 1 downto 0 do
  begin

    J := Length(A);
    SetLength(A, J +1);

    A[J] := B[_Selected[I]];

    DelFromB(_Selected[I]);
  end;

  RefreshLists;

  if _Selected[0] > 0 then
  Begin
       RoutesMerge.ItemIndex := _Selected[0] -1;
       RoutesMerge.Selected[_Selected[0] -1] := True;
  End else
  if _Selected[0] = 0 then
    if RoutesMerge.Count > 0 then
      RoutesMerge.Selected[0] := True;

  RoutesMerge.onClick(nil);
end;

procedure TCollapseFm.DownBtn2Click(Sender: TObject);
var I, J, K :Integer;
begin
  GetSelected(RoutesMerge);
  while _Selected[Length(_Selected) - 1] < RoutesMerge.Count-1 do
  for I := Length(_Selected) - 1 downto 0 do
  begin
    J := B[_Selected[I]+1];

    B[_Selected[I]+1] := B[_Selected[I]];
    B[_Selected[I]]   := J;

    _Selected[I] := _Selected[I]+1;
  end;

  RefreshLists;

  for I := 0 to Length(_Selected) - 1 do
     RoutesMerge.Selected[_Selected[I]] := True;

  RoutesMerge.OnClick(nil);
end;

procedure TCollapseFm.DownBtnClick(Sender: TObject);
var I, J :Integer;
begin

  GetSelected(RoutesMerge);

  if _Selected[Length(_Selected) - 1] < RoutesMerge.Count-1 then
  for I := Length(_Selected) - 1 downto 0 do
  begin
    J := B[_Selected[I]+1];

    B[_Selected[I]+1] := B[_Selected[I]];
    B[_Selected[I]]   := J;

    _Selected[I] := _Selected[I]+1;
  end;

  RefreshLists;

  for I := 0 to Length(_Selected) - 1 do
     RoutesMerge.Selected[_Selected[I]] := True;

  RoutesMerge.OnClick(nil);
end;

procedure TCollapseFm.Init(Arr: array of Integer);
var I, I1, I2, J :Integer;   found:boolean;
begin
  SetLength(A, RouteCount - Length(Arr));
  SetLength(B, Length(Arr));

  For I := 0 To Length(Arr)-1 Do
  Begin
     B[I] := Arr[I];
  End;

  I1 := 0;
  For I := 0 to RouteCount - 1 do
  Begin
    found := false;

    for j := 0 To Length(Arr)-1 do
      if I = Arr[j] then
      begin
        found :=true;
        break;
      end;

    if found then
       continue;

    A[I1] := I;
    Inc(I1);
  End;


  RefreshLists;
end;

procedure TCollapseFm.OkButtonClick(Sender: TObject);

 procedure SortArr(var Ar:array of Integer);
  var i, j, k :integer;
  begin
    for I := 0 to Length(Ar) - 1  do
      for j := I+1 to Length(Ar) - 1 do
         if Ar[I] > Ar[j]  then
         begin
            k := Ar[I];
            Ar[I] := Ar[j];
            Ar[j] := k;
         end;
  end;

var I, j:Integer;
begin
  MapFm.SaveCtrlZ;
  //// СНАЧАЛА ФОРМУ ЗАДАТЬ ИМЯ!
  Namer.Edit1.Text := Inf[28];
  Namer.ShowModal;


  if Namer.isOk then
  Begin
    j := 0;
    if AddH.Checked then
      j := NewH.Value;
      
    MergeRoutesArr(B,
                DoRad.Checked, DoLoop.Checked,
                ImiRad.Value, RtStep.Value, ImiStep.Value, j,
                Namer.Edit1.Text);
    RoutesToGeo;            
    close;            
  End;


  ///  Удалить исходные по списку
  if DelOld.Checked then
  begin
    SortArr(B);
    for j := Length(B)-1 downTo 0 do
      DelRoute(B[j]);
  end;
end;

procedure TCollapseFm.RefreshLists;
var I, J :Integer;
begin

  J:= AllRTS.ItemIndex;
  AllRTS.Clear;
  For I := 0 to Length(A)-1 do
  Begin
    AllRTS.Items.Add(Route[A[I]].Name);
  End;
  AllRTS.ItemIndex:= J;

  J:= RoutesMerge.ItemIndex;
  RoutesMerge.Clear;
  For I := 0 to Length(B)-1 do
  Begin
    RoutesMerge.Items.Add(Route[B[I]].Name);
  End;
  RoutesMerge.ItemIndex := J;

  AllRTS.OnClick(nil);
  RoutesMerge.OnClick(nil);

end;

procedure TCollapseFm.RoutesMergeClick(Sender: TObject);
begin
  UpBtn.Enabled    := FirstSel(RoutesMerge) > 0;
  UpBtn2.Enabled   := FirstSel(RoutesMerge) > 0;

  DownBtn.Enabled  := (LastSel(RoutesMerge) >= 0) and
      (LastSel(RoutesMerge) < RoutesMerge.Items.Count -1);
  DownBtn2.Enabled := (LastSel(RoutesMerge) >= 0) and
      (LastSel(RoutesMerge)< RoutesMerge.Items.Count -1);

  DelBtn.Enabled   := RoutesMerge.SelCount > 0;


  DelAllBtn.Enabled:= RoutesMerge.Items.Count > 0;
  OkButton.Enabled := RoutesMerge.Items.Count > 0;
end;

procedure TCollapseFm.RoutesMergeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  RoutesMerge.SetFocus
end;

procedure TCollapseFm.SendAllBtnClick(Sender: TObject);
var I, J, K: Integer;
begin
  I := length(A);

  if I = -1 then
     exit;

  J := Length(B);
  SetLength(B, J + I);

  for K := 0 To I-1 Do
    B[J + K] := A[K];

  SetLength(A, 0);

  RefreshLists;
end;

procedure TCollapseFm.SendBtnClick(Sender: TObject);
 procedure DelFromA(N:Integer);
 var I: Integer;
 begin
   For I := N To Length(A) -2 Do
     A[I] := A[I+1];

   SetLength(A, Length(A) -1);
 end;

var I, J, n: Integer;
begin
  if AllRTS.SelCount <= 0 then
     exit;

  GetSelected(AllRTs);

  for n := Length(_Selected) - 1 downto 0 do
  begin
    I := _Selected[n];

    J := Length(B);
    SetLength(B, J + 1);

    B[J] := A[I];

    DelFromA(I);
  end;

  RefreshLists;

  if _Selected[0] > 0 then
  Begin
       AllRTS.ItemIndex := _Selected[0] -1;
       AllRTS.Selected[_Selected[0] -1] := True;
  End else
  if _Selected[0] = 0 then
    if AllRTs.Count > 0 then
      AllRTS.Selected[0] := True;

   AllRTS.onClick(nil);
end;

procedure TCollapseFm.UpBtn2Click(Sender: TObject);
var I, J, K :Integer;
begin
  GetSelected(RoutesMerge);
 while _Selected[0] > 0 do
  for I := Length(_Selected) - 1 downto 0 do
  begin
    J := B[_Selected[I]-1];

    B[_Selected[I]-1] := B[_Selected[I]];
    B[_Selected[I]]   := J;

    _Selected[I] := _Selected[I] - 1;
  end;

  RefreshLists;

  for I := 0 to Length(_Selected) - 1 do
     RoutesMerge.Selected[_Selected[I]] := True;

  RoutesMerge.OnClick(nil);
end;

procedure TCollapseFm.UpBtnClick(Sender: TObject);
var I, J :Integer;
begin

  GetSelected(RoutesMerge);

  if _Selected[0] > 0 then
  for I := 0 to Length(_Selected) - 1 do
  begin
    J := B[_Selected[I]-1];

    B[_Selected[I]-1] := B[_Selected[I]];
    B[_Selected[I]]   := J;

    _Selected[I] := _Selected[I]-1;
  end;

  RefreshLists;

  for I := 0 to Length(_Selected) - 1 do
     RoutesMerge.Selected[_Selected[I]] := True;

  RoutesMerge.OnClick(nil);
end;

end.
