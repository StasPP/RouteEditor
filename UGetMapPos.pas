unit UGetMapPos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, uRegions;

type
  TGetMapPos = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    ResultB, ResultL :String;
    GMMode: boolean;
    PointB, PointL :Double;
    { Public declarations }
  end;

var
  GetMapPos: TGetMapPos;
  Bs, Ls :String;

implementation

{$R *.dfm}

procedure TGetMapPos.FormShow(Sender: TObject);
var X, Y, B, L : integer;
begin
try
   Label4.Visible := not GMMode;
   label4.Caption := '';
   if not GMMode then
   Begin
      Label1.Caption := GetRegion(PointB, PointL);
      B := round(PointB); L := round(PointL);
      
      Y := trunc(- PointB*2 -1 + Image1.Height div 2);
      X := trunc(PointL*2 -1 + Image1.Width div 2);

      if (X < 0) or (X > Image1.Width) or
         (Y < 0) or (Y > Image1.Height)then
      begin
         Image2.Hide;
         Label3.Show;
         Label2.Hide;
      end
      else
        begin
          Image2.Left := Image1.Left+ X - 8;
          Image2.Top :=  Image1.Top + Y - 8;
          Image2.Show;
          Label3.Hide;

          if B < 0 Then
          begin
            B := -B;
            Bs := 'S '+ IntToStr(B)
          end
          else
            Bs := 'N '+ IntToStr(B);

          if L < 0 Then
          begin
           L := -L;
           Ls := 'W ' + IntToStr(L);
          end
          else
           Ls:= 'E ' + IntToStr(L);

           Label2.Caption := Bs + #13 + Ls;
           Label2.Left := Image2.Left + 18;
           Label2.Top := Image2.Top;
           Label2.Show;
        end;



   End;

except
   close;
end;
end;

procedure TGetMapPos.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
    S1, S2: String;
    B, L: real;
begin

  B := - (Y+1 - Image1.Height div 2 )div 2;
  L := (X+1 - Image1.Width div 2 )div 2;

  if B < 0 Then
  begin
     B := -B;
     S1 := 'S ';
  end
   else
    S1 := 'N ';

  if L < 0 Then
  begin
     L := -L;
     S2 := 'W ';
  end
   else
    S2 := 'E ';

  Bs :=  S1 + IntToStr(Round(B));
  Ls :=  S2 +  IntToStr(Round(L));

  if not GMMode then
  begin
    Label4.Caption := Bs + #13 + Ls  ;
    

    if y > 10 then
       Label4.Top := y - 10
    else
       Label4.Top := 0;

    if y > Image1.Height - Label4.Height then
       Label4.Top := Image1.Height - Label4.Height;

    if x + Label4.Width < ClientWidth - 12 then
       Label4.Left := x + 12
    else
       Label4.Left := ClientWidth - Label4.Width
  end
  else
    Label1.Caption := Bs + ' ' + Ls;

end;

procedure TGetMapPos.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    S1, S2: String;
    B, L: real;
begin
  if not GMMode then
    exit;

  ResultB := Bs;
  ResultL := Ls;

  X := X + Image2.Left - Image1.Left;
  Y := Y + Image2.Top - Image1.Top;

  Label2.Caption := Bs + #13 + Ls;
  Image2.Left := Image1.Left+ X-7; Image2.Top :=Image1.Top + Y-7;

  Label2.Left := Image2.Left + 18;
  Label2.Top := Image2.Top;

  Label2.Show;
  Image2.Show;

end;

procedure TGetMapPos.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var
    S1, S2: String;
    B, L: real;
begin
{
 if B < 0 Then
  begin
     B := -B;
     S1 := 'S ';
  end
   else
    S1 := 'N ';

  if L < 0 Then
  begin
     L := -L;
     S2 := 'W ';
  end
   else
    S2 := 'E ';

  Bs := S1+ IntToStr(Round(B));
  Ls :=  S2 +  IntToStr(Round(L));

  if not GMMode then
  begin
    Label4.Caption := Bs + $#13 + Ls
    Label4.Top := Image2.Top + Y;
    Label4.Left := Image2.Left + X;
  end
  else
    Label1.Caption := Bs + ' ' + Ls;
      }
   Image1MouseMove(Sender, Shift, Image2.Left +X, Image2.Top +Y);
end;

procedure TGetMapPos.Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   Image1MouseMove(Sender, Shift, label2.Left +X, label2.Top +Y);
end;

procedure TGetMapPos.Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   Image1MouseMove(Sender, Shift, label4.Left +X, label4.Top +Y);
end;

procedure TGetMapPos.Button1Click(Sender: TObject);
begin
  close;
end;

end.
