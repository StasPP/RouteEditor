unit UMarkH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BasicMapObjects, StdCtrls, ExtCtrls, Spin, GeoString, MapperFm,
  LangLoader;

type
  TMarkH = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    MarkHN : integer;
    { Public declarations }
  end;

var
  MarkH: TMarkH;

implementation

{$R *.dfm}

procedure TMarkH.Button1Click(Sender: TObject);
begin
 if MarkHN = -1 then
   exit;

 if (Markers[MarkHN].H  <> StrToFloat2(Edit2.Text)) or 
    (Markers[MarkHN].HGeo <> StrToFloat2(Edit1.Text)) or
    (Markers[MarkHN].MarkerKind <> SpinEdit1.Value) then
    MapFm.SaveCtrlZ;
    
 Markers[MarkHN].H    := StrToFloat2(Edit2.Text);
 Markers[MarkHN].HGeo := StrToFloat2(Edit1.Text);
 Markers[MarkHN].Alt := StrToFloat2(Edit3.Text);
 Markers[MarkHN].MarkerKind := SpinEdit1.Value;
 close;
end;

procedure TMarkH.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TMarkH.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
     Button1.Click;
end;

procedure TMarkH.FormActivate(Sender: TObject);
begin
  SpinEdit1.Enabled := false;
end;

procedure TMarkH.Label1Click(Sender: TObject);
begin
  SpinEdit1.Enabled := true;
end;

procedure TMarkH.SpinEdit1Change(Sender: TObject);
begin
  Label5.Caption := '';
  if (SpinEdit1.Value >= 0) and (SpinEdit1.Value <= 15) then
      Label5.Caption :=  inf[257+ SpinEdit1.Value];

  if (SpinEdit1.Value = 5) then
    Label4.Caption := inf[273]
  else
    Label4.Caption := inf[274];
end;

end.
