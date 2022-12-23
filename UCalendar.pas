unit UCalendar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, GeoTime;

type
  TFCalendar = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Date1: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Date1Click(Sender: TObject);
    procedure Date1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCalendar: TFCalendar;

implementation

uses LoadTrack;

{$R *.dfm}

procedure TFCalendar.Button1Click(Sender: TObject);
begin
  LoadT.WeekEdit.Value := StrToInt(Label5.Caption);
  close;
end;

procedure TFCalendar.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFCalendar.Date1Click(Sender: TObject);
var TD: Double;
    Week, Ls :Integer;
    YearB, tmp1, tmp2: Word;
    YearBg: TDateTime;
begin
  Week := 0;

  DecodeDate(Date1.DateTime, YearB, tmp1, tmp2);
  YearBg := EncodeDate(YearB,1,1);
  Label4.Caption := IntToStr(trunc(Date1.Date - YearBg)+1);

  DatetimeToTOW(Date1.DateTime,0, Week);
  Label5.Caption := IntToStr(Week);

  Ls := GetLeapSecond('', Date1.Date);
  Label8.Caption := IntToStr(ls);

  tmp1 := DayOfWeek(Date1.DateTime);
  Label6.Caption:= Label5.Caption+  IntToStr(trunc(tmp1)-1);
end;

procedure TFCalendar.Date1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Date1.OnClick(nil);
end;

end.
