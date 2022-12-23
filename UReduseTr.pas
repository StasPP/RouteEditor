unit UReduseTr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, TrackFunctions, GeoString;

type
  TFreduceTrack = class(TForm)
    Panel1: TPanel;
    dTEp: TCheckBox;
    dLEp: TCheckBox;
    EpT: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    EpL: TComboBox;
    Panel2: TPanel;
    Label4: TLabel;
    dAzmtEp: TCheckBox;
    EpAzmt2: TComboBox;
    EpAzmt1: TComboBox;
    Label3: TLabel;
    bOk: TButton;
    bCancel: TButton;
    Panel3: TPanel;
    EpI: TSpinEdit;
    IEp: TCheckBox;
    procedure bCancelClick(Sender: TObject);
    procedure IEpClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FreduceTrack: TFreduceTrack;

implementation

{$R *.dfm}

procedure TFreduceTrack.bCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFreduceTrack.bOkClick(Sender: TObject);
begin
  if IEp.Checked then
     ReduceTrackPoints(MainTrack, 0, EpI.Value, 0)
  else
  if Panel1.Enabled then
  begin
    if dTEp.Checked then
      ReduceTrackPoints(MainTrack, 1, StrToFloat2(EpT.Text), 0);
    if dLEp.Checked then
      ReduceTrackPoints(MainTrack, 2, StrToFloat2(EpL.Text), 0);
  end else
   if dAzmtEp.Checked then
      ReduceTrackPoints(MainTrack, 2, StrToLatLon(EpAzmt1.Text, true),
                                      StrToFloat2(EpAzmt1.Text));

  close;
end;

procedure TFreduceTrack.IEpClick(Sender: TObject);
begin
  Panel1.Enabled := not (IEp.Checked or (dAzmtEp.Checked));
  Panel2.Enabled := not ((IEp.Checked) or (dTEp.Checked) or (dLEp.Checked));
  Panel3.Enabled := not ((dAzmtEp.Checked) or (dTEp.Checked) or (dLEp.Checked));
  bOk.Enabled := (IEp.Checked) or (dTEp.Checked) or (dLEp.Checked)
                 or (dAzmtEp.Checked);
end;

end.
