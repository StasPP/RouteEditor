unit UOpenKML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MapEditor, BasicMapObjects;

type
  TKmlOpn = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    DoMark: TCheckBox;
    DoRts: TCheckBox;
    DoFrame: TCheckBox;
    DoAddR: TRadioButton;
    DoResetR: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KmlOpn: TKmlOpn;

implementation

uses LoadData;

{$R *.dfm}

procedure TKmlOpn.Button1Click(Sender: TObject);
begin
  LoadKMLFile(LoadRData.FName, doRts.Checked, doMark.Checked, doFrame.Checked,
              false, DoAddR.Checked);
  close
end;

procedure TKmlOpn.Button2Click(Sender: TObject);
begin
  close
end;

procedure TKmlOpn.FormShow(Sender: TObject);
begin
  DoAddR.Checked := AddRoutes;
  DoResetR.Checked := not AddRoutes;
end;

end.
