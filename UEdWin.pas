unit UEdWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ImgList, ComCtrls, BasicMapObjects,
  LangLoader, MapFunctions, MapEditor;

type
  TEdWin = class(TForm)
    TreeView1: TTreeView;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure ReFreshTree;
    procedure TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EdWin: TEdWin;
  Started: Boolean = false;
  RNode, FNode : TTreeNode;
implementation

uses MapperFm;

{$R *.dfm}

procedure TEdWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MapFm.EdW.Flat := true;
end;

procedure TEdWin.FormShow(Sender: TObject);
begin
  if not Started then
  Begin
    Started := true;
    Top   := MapFm.Top + 20 +(MapFm.Height - Height) div 2;
    Left := MapFm.Left + MapFm.Width - Width;
  End;
  ReFreshTree;
end;

procedure TEdWin.ReFreshTree;
var I, J :Integer;
    Node1, Node2, Node3, Node4, Node5 : TTreeNode;
begin
  TreeView1.Items.Clear;

  RNode := nil;
  FNode := nil;

  if RouteCount > 0 then
  Begin
    Node1 := TreeView1.Items.AddFirst(nil, Inf[24]);
    RNode := Node1;
    with Node1 do
    begin
       ImageIndex := 2;
       SelectedIndex := 7;
    end;
    for I := 0 to RouteCount - 1 do
    Begin
      Node2 := TreeView1.Items.AddChild(Node1,Route[I].Name);
      with Node2 do
      begin
         ImageIndex := 3;
         SelectedIndex := 8;
      end;
      for J := 0 to Length(Route[I].WPT)-1 do
      begin
         Node3 := TreeView1.Items.AddChild(Node2,Inf[25]+IntToStr(J+1));
         with Node3 do
         begin
           ImageIndex := 4;
           SelectedIndex := 9;
         end;
      end;
    End;
  End;

  if Frame then
  Begin
    Node5 := TreeView1.Items.AddFirst(nil, Inf[23]);
    FNode := Node5;
    with Node5 do
    begin
       ImageIndex := 0;
       SelectedIndex := 5;
    end;

    for I := 0 to FrameCount - 2 do
    Begin
      Node4 := TreeView1.Items.AddChild(Node5,Inf[25]+IntToStr(i+1));
      with Node4 do
      begin
         ImageIndex := 1;
         SelectedIndex := 6;
      end;
    End;
  End;

   
  case ClickMode of
    21,22,25,27: if FNode <> nil then
    begin


      if FNode.Count > 0 then
         FNode.Expand(true);

      FNode.Selected := true;

      if ClickMode<>25 then
        for I := 0 to FNode.Count - 1 do
        try
           Node4 := FNode[I];
           if SelectedFramePoints[I] then
             TreeView1.Select(Node4, [ssCtrl]);

        except
        end;
    end;

    23,24,26,28: if RNode <> nil then
    if RNode.Count > 0 then
    begin

       RNode.Expand(false);
       RNode.Selected := true;

       if ClickMode=26 then
       begin
         if  RNode[ RNode.Count - 1 ].Count > 0 then
             RNode[ RNode.Count - 1 ].Expand(true)
       end
       else
       for I := 0 to RNode.Count - 1 do
         if RNode.Count > 0 then
           for J := 0 to RNode[I].Count - 1 do
           try
              Node4 := RNode[I][J];

              if (I = MapFm.RouteBox.ItemIndex-1) or
                 (ClickMode = 28)and ( PointToAddRouteNum = I) then
                if  RNode[I].Expanded = false then
                    RNode[I].Expand(true);

              if SelectedRoutePoints[I][J] then
              Begin
                if  RNode[I].Expanded = false then
                    RNode[I].Expand(true);

                   TreeView1.Select(Node4, [ssCtrl]);
              End;

           except
           end;

    end;
  end;


end;

procedure TEdWin.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
// RefreshSelectionArrays;

end;

procedure TEdWin.TreeView1Click(Sender: TObject);
var I, J, K : integer;
begin
  K := -1;
  RefreshSelectionArrays;
  if RNode <> nil then
    if RNode.Count>0 then
      for I := 0 to RNode.Count - 1 do
          if RNode[I].Count>0 then
          for J := 0 to RNode[I].Count - 1 do
             if RNode[I][J].Selected then
             Begin
                Inc(SelectedRoutePointsCount);
                if K = -1 then
                Begin
                   SelectedRouteN := I;
                   K := I;
                   Inc(SelectedRoutesCount);
                End;

                if K <> I then
                Begin
                   K:= I;
                   Inc(SelectedRoutesCount);
                End;

                MapFm.TreeSelectRoutePoint(I, J);
             End;


  if FNode <> nil then
    if FNode.Count>0 then
      for I := 0 to FNode.Count - 1 do
             if FNode[I].Selected then
             Begin
                 Inc(SelectedFramePointsCount);
                 MapFm.TreeSelectFramePoint(I);
             End;

  MapFm.GetEdTools;
end;

procedure TEdWin.TreeView1DblClick(Sender: TObject);
var I, J, K : integer;
begin
{  K := -1;
  RefreshSelectionArrays;
  if RNode <> nil then
    if RNode.Count>0 then
      for I := 0 to RNode.Count - 1 do
          if RNode[I].Count>0 then
          for J := 0 to RNode[I].Count - 1 do
             if RNode[I][J].Selected then
             Begin
                Inc(SelectedRoutePointsCount);
                if K = -1 then
                Begin
                   SelectedRouteN := I;
                   K := I;
                   Inc(SelectedRoutesCount);
                End;

                if K <> I then
                Begin
                   K:= I;
                   Inc(SelectedRoutesCount);
                End;

                MapFm.TreeSelectRoutePoint(I, J);
             End;


  if FNode <> nil then
    if FNode.Count>0 then
      for I := 0 to FNode.Count - 1 do
             if FNode[I].Selected then
             Begin
                 Inc(SelectedFramePointsCount);
                 MapFm.TreeSelectFramePoint(I);
             End;

  JumpToSelRoutesMap;
  MapFm.GetEdTools;
  RefreshSelectionArrays; }

  JumpToSelRoutesMap;
end;

procedure TEdWin.TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  TreeView1.SetFocus;
end;

end.
