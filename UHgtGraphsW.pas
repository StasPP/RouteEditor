unit UHgtGraphsW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TrackFunctions, LangLoader;

type
  THgtGraphs = class(TForm)
    Button1: TButton;
    Button2: TButton;
    rg: TRadioGroup;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HgtGraphs: THgtGraphs;

implementation

uses MapperFm;

{$R *.dfm}

procedure THgtGraphs.Button1Click(Sender: TObject);
var s, s2, DopSt: string;
begin
  SetCurrentDir(MapperFm.MyDir);
  SaveRTTFile(MainTrack, 'Tmp\Prof.rtt', false);

  s := 'Tmp\Prof.rtt';
  s2 := 'Data\Graph\'+Lang;
  case RG.ItemIndex of
    0: s2 := s2 + '\A_Hgt_t.chs';
    1: s2 := s2 + '\A_HgtE_t.chs';
    2: s2 := s2 + '\A_HAG_t.chs';
    3: s2 := s2 + '\A_HAG2_t.chs'
  end;
  Dopst := ' -l_Data\Graph\'+Lang+'.txt -thick -menu -rnav -readonly -n -gray';
  winexec(PChar('Graph.exe '+s+' '+s2+ ' ' +DopSt),sw_restore);
end;

procedure THgtGraphs.Button2Click(Sender: TObject);
begin
  close;
end;

end.
