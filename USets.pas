unit USets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LangLoader, GoogleMap, ExtCtrls, RTypes, ShellAPI, Buttons,
  TrackFunctions;

type
  TSetFm = class(TForm)
    Button1: TButton;
    Ln: TComboBox;
    Label1: TLabel;
    Smooth: TCheckBox;
    GroupBox1: TGroupBox;
    Cl: TComboBox;
    Vsync: TCheckBox;
    Button2: TButton;
    BackGroundColor: TShape;
    LinesColor: TShape;
    ObjColor: TShape;
    DopObjColor: TShape;
    IntColor: TShape;
    InfoColor: TShape;
    TrackColor: TShape;
    RedTrackColor: TShape;
    FntColor: TShape;
    BackGround: TLabel;
    Lines: TLabel;
    Obj: TLabel;
    Track: TLabel;
    Info: TLabel;
    Int: TLabel;
    RedTrack: TLabel;
    Fnt: TLabel;
    DopObj: TLabel;
    ChoosedColor: TShape;
    Choosed: TLabel;
    SimpleN: TCheckBox;
    Sav: TSpeedButton;
    DrMesh: TCheckBox;
    ColorDialog1: TColorDialog;
    AlwaysN: TCheckBox;
    LabelStyle: TRadioGroup;
    TA: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClChange(Sender: TObject);
    procedure LnChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SavClick(Sender: TObject);
    procedure BackGroundMouseLeave(Sender: TObject);
    procedure BackGroundMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DopObjClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure SaveSettings;
    procedure LoadSettings;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetFm: TSetFm;

implementation

uses MapperFm;

{$R *.dfm}

procedure TSetFm.Button1Click(Sender: TObject);
  function MyCol(Col: TColor): Cardinal;
  begin
     Result :=  GetBValue(Col) or (GetGValue(Col) shl 8)or (GetRValue(Col) shl 16)
          or (255 shl 24);
  end;

  function MyIntCol(Col: TColor): Cardinal;
  begin
     Result :=  GetBValue(Col) or (GetGValue(Col) shl 8)or (GetRValue(Col) shl 16)
          or (200 shl 24);
  end;

var S:TStringList;
begin
 // GoogleKey := Edit1.Text;
  AsphDevice.VSync :=  VSync.Checked;
  MapperFm.Smooth  :=  Smooth.Checked;
  MapperFm.DoDrawLines := DrMesh.Checked;

  MapperFm.LStyle          := LabelStyle.ItemIndex;
  MapperFm.AlwaysN         := AlwaysN.Checked;
  MapperFm.BackGroundColor := MyCol(BackGroundColor.Brush.Color);
  MapperFm.LinesColor      := MyCol(LinesColor.Brush.Color);
  MapperFm.ChoosedColor    := MyCol(ChoosedColor.Brush.Color);
  MapperFm.DopObjColor     := MyCol(DopObjColor.Brush.Color);
  MapperFm.ObjColor        := MyCol(ObjColor.Brush.Color);
  MapperFm.IntColor        := MyIntCol(IntColor.Brush.Color);
  MapperFm.InfoColor       := MyCol(InfoColor.Brush.Color);
  MapperFm.TrackColor      := MyCol(TrackColor.Brush.Color);
  MapperFm.RedTrackColor   := MyCol(RedTrackColor.Brush.Color);
  MapperFm.FntColor        := MyCol(FntColor.Brush.Color);

  TrackArrowsEnabled       := TA.Checked;

  case SimpleN.Checked of
    true:  MapperFm.ArKind := 2;
    false: MapperFm.ArKind := 1;
  end;

 { S := TStringList.Create;
  try
    S.Add(Edit1.Text);
    S.SaveToFile(MyDir+'Data\GoogleKey.txt');
  except
  end;
  S.Free;
  }

  SaveSettings;

  MapFm.PC.Pages[6].TabVisible := GoogleKey <> '';
  MapFm.Agoogle2.Enabled := MapFm.PC.Pages[6].TabVisible;

  close;
end;

procedure TSetFm.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TSetFm.Button3Click(Sender: TObject);
begin
  shellexecute(SetFm.Handle,'open',
              'https://developers.google.com/maps/pricing-and-plans/','','',sw_restore);
end;

procedure TSetFm.ClChange(Sender: TObject);
const ColSets: array [0..3] of String = ('Standard', 'Black', 'White', 'User');
begin
  MapFm.LoadSettings(MyDir+'Data\Colors\'+ColSets[Cl.ItemIndex]+'.cfg');
  Sav.Visible := false;
end;

procedure TSetFm.DopObjClick(Sender: TObject);
var I : integer;
begin

  for I := 0 to ComponentCount - 1 do
    if Components[I].Name = TLabel(Sender).name+'Color' then
      if Components[I] is TShape then
         begin
            if ColorDialog1.Execute then
                TShape(Components[I]).Brush.Color := ColorDialog1.Color;
              break;
         end;

  Cl.ItemIndex := Cl.Items.Count-1;
  Sav.Visible := true;
end;

procedure TSetFm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MapFm.ModeButtons;
end;

procedure TSetFm.FormCreate(Sender: TObject);
begin
  MapFm.LoadSettings('Data\Colors\Standard.cfg');
end;

procedure TSetFm.FormShow(Sender: TObject);
var I, J :integer;
begin
  J := 0;
  Ln.Items.Clear;
  for I := 0 to Length(Langs) - 1 do
  begin
    if Lang = Langs[I] then
      J := I;
    Ln.Items.Add(Langs[I]);
  end;
      Ln.ItemIndex := J;

 // Edit1.Text := GoogleKey;
  VSync.Checked := AsphDevice.VSync;
  Smooth.Checked := MapperFm.Smooth;
  DrMesh.Checked := MapperFm.DoDrawLines;
end;

procedure TSetFm.BackGroundMouseLeave(Sender: TObject);
begin
  with Sender as TLabel Do
   Font.Style:=  Font.Style - [fsUnderLine];
end;

procedure TSetFm.BackGroundMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as TLabel Do
    Font.Style:=  Font.Style + [fsUnderLine];
end;

procedure TSetFm.LnChange(Sender: TObject);
var I:Integer;
    S:TStringList;
begin
  LoadLang(Ln.ItemIndex, false);
  with MapFm do
  begin
    I := KnotAreaOrder.ItemIndex;
    KnotAreaOrder.Items[0] := inf[158];    KnotAreaOrder.Items[1] := inf[159];
    KnotAreaOrder.ItemIndex := I;

    e1.Hint := Extra.Caption;  Extra.Hint := Extra.Caption;  Extra.Caption  := '';
    e2.Hint := Extra2.Caption; Extra2.Hint := Extra2.Caption; Extra2.Caption := '';
    e3.Hint := Extra3.Caption; Extra3.Hint := Extra3.Caption; Extra3.Caption := '';
  end;

  SetCurrentDir(MapperFm.MyDir);
  S := TStringList.Create;
  S.Add(IntToStr(Ln.ItemIndex));
  if fileexists('..\Data\Language.config') then
    S.SaveToFile('..\Data\Language.config')
  else
    S.SaveToFile('Data\Language.config');
  S.Destroy;
end;

procedure TSetFm.LoadSettings;
var S: TstringList;
begin
  S := TStringList.Create;
  SetCurrentDir(MapperFm.MyDir);
  if fileexists('Data\Editor.config') then
  try
    S.LoadFromFile('Data\Editor.config');

    Smooth.Checked := S[0] = '1';
    VSync.Checked  := S[1] = '1';
    Cl.ItemIndex   := StrToInt(S[2]);

    BackGroundColor.Brush.Color := StringToColor(S[3]);
    LinesColor.Brush.Color      := StringToColor(S[4]);
    DopObjColor.Brush.Color     := StringToColor(S[5]);
    ObjColor.Brush.Color        := StringToColor(S[6]);
    InfoColor.Brush.Color       := StringToColor(S[7]);
    TrackColor.Brush.Color      := StringToColor(S[8]);
    RedTrackColor.Brush.Color   := StringToColor(S[9]);
    IntColor.Brush.Color        := StringToColor(S[10]);
    ChoosedColor.Brush.Color    := StringToColor(S[11]);
    FntColor.Brush.Color        := StringToColor(S[12]);

    LabelStyle.ItemIndex := StrToInt(S[13]);
    DrMesh.Checked       := S[14] = '1';
    SimpleN.Checked      := S[15] = '1';
    AlwaysN.Checked      := S[16] = '1';
    TA.Checked           := S[17] = '1';

    Button1.Click;
  except
  end;
  S.Free;
end;

procedure TSetFm.SavClick(Sender: TObject);
begin
  MapFm.SaveSettings(MapperFm.MyDir +'\Data\Colors\User.cfg');
end;

procedure TSetFm.SaveSettings;
var S: TstringList;
begin
  S := TStringList.Create;
  SetCurrentDir(MapperFm.MyDir);
//  if fileexists('Data\Editor.config') then
//  begin
    if Smooth.Checked then
       S.Add('1')
    else
       S.Add('0');

    if VSync.Checked then
       S.Add('1')
    else
       S.Add('0');

    S.Add(IntToStr(Cl.ItemIndex));
    S.Add(ColorToString(BackGroundColor.Brush.Color));
    S.Add(ColorToString(LinesColor.Brush.Color));
    S.Add(ColorToString(DopObjColor.Brush.Color));

    S.Add(ColorToString(ObjColor.Brush.Color));
    S.Add(ColorToString(InfoColor.Brush.Color));
    S.Add(ColorToString(TrackColor.Brush.Color));
    S.Add(ColorToString(RedTrackColor.Brush.Color));

    S.Add(ColorToString(IntColor.Brush.Color));
    S.Add(ColorToString(ChoosedColor.Brush.Color));
    S.Add(ColorToString(FntColor.Brush.Color));

    S.Add(IntToStr(LabelStyle.ItemIndex));

    if DrMesh.Checked then
       S.Add('1')
    else
       S.Add('0');

    if SimpleN.Checked then
       S.Add('1')
    else
       S.Add('0');

    if AlwaysN.Checked then
       S.Add('1')
    else
       S.Add('0');

    if TA.Checked then
       S.Add('1')
    else
       S.Add('0');
//  end;
  S.SaveToFile('Data\Editor.config');
  S.Free;
end;

end.
