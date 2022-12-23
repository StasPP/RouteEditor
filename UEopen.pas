unit UEopen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, TrackFunctions, MapperFm, Spin, LangLoader;

type
  TEOpen = class(TForm)
    Button1: TButton;
    HGTBox: TGroupBox;
    HLabelLV: TLabel;
    HLabelRV: TLabel;
    dotsLabel1: TLabel;
    dotsLabel2: TLabel;
    MaxHgtL: TSpinEdit;
    MinHgtL: TSpinEdit;
    MinHgtR: TSpinEdit;
    MaxHgtR: TSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    MaxXTE: TSpinEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EOpen: TEOpen;

implementation

{$R *.dfm}

procedure TEOpen.Button1Click(Sender: TObject);
var S:TstringList;
begin
  SaveRTTFileForAnalysis(MainTrack,'Data\LastTrack.rtt', MapFm.CoordSysN, False);
  S := TStringList.Create;
  S.Add(MyDir+'Data\LastTrack.rtt');
  S.Add(IntToStr(MinHGTR.Value));
  S.Add(IntToStr(MaxHGTR.Value));
  S.Add(IntToStr(MinHGTL.Value));
  S.Add(IntToStr(MaxHGTL.Value));
  S.Add(IntToStr(MaxXTE.Value));
  S.Add(Lang);
  S.SaveToFile(MyDir+'Data\LastTrack.log');
  S.Free;
  setCurrentDir(MyDir);
  winexec('EstimHgt.exe Data\LastTrack.log', sw_restore);
  close;
end;

end.
