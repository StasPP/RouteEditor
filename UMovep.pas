unit UMovep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons;

type
  TMovep = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    StpEd: TSpinEdit;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Movep: TMovep;

implementation

uses UEdTools, MapperFm;

{$R *.dfm}

procedure TMovep.FormShow(Sender: TObject);
begin
 if EdTools.BorderStyle = bsNone then
 begin

   Top := EdTools.Top + EdTools.Height+10;
   Left := EdTools.Left;

 end
   else
    Begin
      Top := MapFm.Top + MapFm.Height - Height;
      Left := MapFm.Left + (MapFm.Width - MapFm.ClientWidth) div 2
    End;
end;

procedure TMovep.SpeedButton1Click(Sender: TObject);
begin
  MapFm.ShiftSelected(StpEd.Value, 0);
end;

procedure TMovep.SpeedButton2Click(Sender: TObject);
begin
  MapFm.ShiftSelected(0, -StpEd.Value);
end;

procedure TMovep.SpeedButton3Click(Sender: TObject);
begin
  MapFm.ShiftSelected(0, StpEd.Value);
end;

procedure TMovep.SpeedButton4Click(Sender: TObject);
begin
  MapFm.ShiftSelected(-StpEd.Value, 0);
end;

end.
