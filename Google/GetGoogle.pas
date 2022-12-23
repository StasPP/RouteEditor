unit GetGoogle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, StdCtrls, Jpeg, Buttons, ShellAPI, XPMan, GeoString,
  BasicMapObjects, GoogleMap, HintFm, LangLoader, MapFunctions;

type
  TWForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Bevel2: TBevel;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Label3: TLabel;
    Button4: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Button5: TButton;
    Button2: TButton;
    Panel1: TPanel;
    MapList: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    OpenMaps: TOpenDialog;
    AsdbList: TListBox;
    OpenRoutes: TOpenDialog;
    Panel2: TPanel;
    SpeedButton4: TSpeedButton;
    Edit2: TEdit;
    Panel3: TPanel;
    SpeedButton3: TSpeedButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Label7: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WForm: TWForm;
  S: TStringList;
  NeedHint :Boolean = true;
implementation

uses MapperFm, LoadData, GeoCalcUnit, RTypes;

{$R *.dfm}

procedure TWForm.Button2Click(Sender: TObject);
begin
  shellexecute(Wform.Handle,'open',
              'https://developers.google.com/maps/pricing-and-plans/','','',sw_restore);
end;

procedure TWForm.Button3Click(Sender: TObject);
begin

  GeoCalcFm.SetEdits(Edit3, Edit4);
  GeoCalcFm.Showmodal;

  if Edit3.Text='' then
     exit;

  Button3.Hide;
  Panel3.Show;

  SetBaseBL( StrToLatLon(Edit3.Text, True),StrToLatLon(Edit4.Text, False) );
end;

procedure TWForm.Button4Click(Sender: TObject);
var S: String;
    j: integer;
begin
  if OpenRoutes.Execute then
  Begin
    Button4.Hide;
    Panel2.Show;

    S := OpenRoutes.FileName;
    LoadRData.OpenFile(S);

    J := Pos('\', S);
    while J > 1 do
    Begin
       S := Copy(S, J+1, Length(S)-J);
       J := Pos('\', S);
    End;
    
    Edit2.Text := S;


    if Copy(S, Length(S)-3,4)<>'.rts' then
      LoadRData.ShowModal
        else
           LoadRoutesFromRTS(OpenRoutes.FileName);
  End;
end;

procedure TWForm.Button5Click(Sender: TObject);
var I, j:Integer;
    S : String;
begin
  if OpenMaps.Execute then
  Begin
      Button5.Visible := false;
      Panel1.Visible  := true;


       for I := 0 to OpenMaps.Files.Count-1 do
       Begin
         AsdbList.Items.Add(OpenMaps.Files[i]);

         S := OpenMaps.Files[i];
         J := Pos('\', S);
         while J > 1 do
         Begin
           S := Copy(S, J+1, Length(S)-J);
           J := Pos('\', S);
         End;
         MapList.Items.Add(S);
             
       End;
  End;
end;

procedure TWForm.ComboBox1Change(Sender: TObject);
var
  S: string;
const
  MapStyles: array [0..3] of String =
    ('road','sat','hyb','ter');

begin
   S := MapStyles[Combobox1.ItemIndex] + Combobox2.Items[Combobox2.ItemIndex];
  Image1.Picture.LoadFromFile('Data\Scales\'+s+'.jpg');
end;

procedure TWForm.Edit1Change(Sender: TObject);
begin
  CheckBox1.Checked := true;
end;

procedure TWForm.Button1Click(Sender: TObject);
var MList : Array of String;
    I : Integer;
begin
 SetCurrentDir(MyDir);
 
 if (Panel1.Visible = false) and (Panel2.Visible = false)
   and (Panel3.Visible = false) then
   Begin
     MessageDlg(inf[15],mtError,[MbOk], 0);
     exit;
   End;
 
   if (Panel2.Visible = false) then
     ResetRoutes;

   MapFm.CoordSysN :=-1;

   if (Panel3.Visible = false) and (Panel2.Visible = false) then
      ResetSettings;

 { if CheckBox1.Checked then
    MapFm.GKey.Text := Edit1.Text
      else
        MapFm.GKey.Text := '';

  MapFm.MS.ItemIndex := ComboBox1.ItemIndex;
  MapFm.ZoomB.ItemIndex := ComboBox2.ItemIndex;    }

  SetCurrentDir(MyDir);
  
  if Edit1.Text <>'' then
  Begin
    if S.Count<1 then
      S.Add(Edit1.Text)
      else
       S[0] := Edit1.Text;
     S.SaveToFile('Data\Googlekey.txt');
  End;
  S.Clear; 

  MapFm.PC.ActivePageIndex := 1;

  ResetGoogle;
  ZoomA := StrToInt(ComboBox2.Items[ComboBox2.ItemIndex]);

  MapFm.StaticText2.Caption := ComboBox1.Items[ComboBox1.ItemIndex];
  MapFm.StaticText3.Caption := ComboBox2.Items[ComboBox2.ItemIndex];
  MapFm.StaticText5.Caption := '0';

  GoogleKey := Edit1.Text;

  ResetMaps(AsphMapImages);

  SetLength(MList, AsdbList.Items.Count);
  for I := 0 to Length(MList) - 1 do
     MList[I] := AsdbList.Items[I];

  GoogleStyle := GoogleMapStyles[ComboBox1.ItemIndex];

  if NeedHint then
     HintForm.ShowModal;
  NeedHint := false;

  LoadMaps(MList, MapperFm.MyDir+'\Data', AsphMapImages);
  MapFm.ShowModal;

  Button3.Show;
  Panel3.Hide;
  Button4.Show;
  Panel2.Hide;
  Button5.Show;
  Panel1.Hide;
  AsdbList.Clear;
  MapList.Clear;
end;

procedure TWForm.FormActivate(Sender: TObject);
begin
//  SaveLngs;
  LoadLang;

  ComboBox1.ItemIndex := 1;
  if Fileexists('Data\Googlekey.txt') then
  Begin
    S.LoadFromFile('Data\Googlekey.txt');
    Edit1.Text := s[0];
    if Edit1.Text <> '' then
      CheckBox1.Checked := true;
  End;
end;

procedure TWForm.FormCreate(Sender: TObject);
begin
  S:= TStringList.Create;
  MyDir := GetCurrentDir;
end;

procedure TWForm.FormDestroy(Sender: TObject);
begin

  S.Destroy;
end;

procedure TWForm.FormShow(Sender: TObject);
begin
  ResetSettings;
end;

procedure TWForm.SpeedButton2Click(Sender: TObject);
  var
   j:integer;
begin
 j :=  MapList.ItemIndex - 1;
 if MapList.ItemIndex <> -1 then
 Begin
    AsdbList.Items.Delete(MapList.ItemIndex);
    MapList.Items.Delete(MapList.ItemIndex);
 End;

 if j > -1 then
   MapList.ItemIndex := j
     else
        MapList.ItemIndex := 0;

end;

procedure TWForm.SpeedButton3Click(Sender: TObject);
begin
 Button3.Show;
 Panel3.Hide;
 SetBaseBL( 0,0 );
 WaitForZone := true;

end;

procedure TWForm.SpeedButton4Click(Sender: TObject);
begin
 Button4.Show;
 Panel2.Hide;
 ResetRoutes;
end;

end.
