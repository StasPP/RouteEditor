unit UNamer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TNamer = class(TForm)
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public

    isOk : boolean ;
    { Public declarations }
  end;

var
  Namer: TNamer;
implementation

{$R *.dfm}

procedure TNamer.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = Vk_Return then
     SpeedButton1.Click;
end;

procedure TNamer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Edit1.Text = '' then
     Edit1.Text := '*';

end;

procedure TNamer.FormShow(Sender: TObject);
begin
  isOk := false;
end;

procedure TNamer.SpeedButton1Click(Sender: TObject);
begin
  IsOk := True;
  close;
end;

end.
