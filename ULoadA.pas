unit ULoadA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Spin, ExtCtrls, TrackFunctions, TabFunctions,
  LangLoader, GeoString;

type
  TLoadA = class(TForm)
    GroupBox4: TGroupBox;
    TimeSys: TRadioGroup;
    GroupBox5: TGroupBox;
    isDoy: TRadioButton;
    isFormatted: TRadioButton;
    isWoy: TRadioButton;
    Edit3: TSpinEdit;
    Edit1: TComboBox;
    Edit2: TComboBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Col1: TSpinEdit;
    Col2: TSpinEdit;
    Col3: TSpinEdit;
    Col4: TSpinEdit;
    StringGrid1: TStringGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    RSpacer: TRadioGroup;
    Spacer: TEdit;
    StartFrom: TSpinEdit;
    GroupBox6: TGroupBox;
    Col10: TSpinEdit;
    C12: TRadioButton;
    C10: TRadioButton;
    C14: TRadioButton;
    YawKind: TRadioGroup;
    Panel1: TPanel;
    Edit4: TEdit;
    Label6: TLabel;
    Button1: TButton;
    Button2: TButton;
    isDegs: TRadioGroup;
    Label7: TLabel;
    procedure RefreshRes;
    procedure RenameTabs(var StringGrid: TStringGrid);
    procedure Button2Click(Sender: TObject);
    procedure isDoyClick(Sender: TObject);
    procedure RSpacerClick(Sender: TObject);
    procedure Col1Click(Sender: TObject);
    procedure SpacerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure YawKindClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Fname: string;
  end;

var
  LoadA: TLoadA;
  S : TStringList;
implementation

uses ParUnit1;

{$R *.dfm}

procedure TLoadA.Button1Click(Sender: TObject);
var sep : char;
    datetab: integer;
    DateF, TimeF : String;
begin
  case RSpacer.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Spacer.Text<> '' then sep := Spacer.Text[1];
        3: sep:=';';
        4: sep:=',';
   end;

 if c10.Checked then
    DateTab := Col10.Value-1
    else
       if C14.Checked then
         DateTab := -2
         else
           DateTab := 0;

 if IsFormatted.Checked then
  begin
    TimeF := Edit2.Text;
    DateF := Edit1.Text;
  end
   else
   begin
     TimeF := '';
     DateF := '';
     if isDoy.Checked then
        DateF := IntToStr(Edit3.Value);
   end;

 LoadAnglesFromFile(FName, Sep, StartFrom.Value-1,
                    Col1.Value-1, Col2.Value-1, Col3.Value-1, Col4.Value-1,
                    DateTab, YawKind.itemIndex, StrToFloat2(Edit4.text),
                    DateF, TimeF, TimeSys.ItemIndex = 1, isDegs.ItemIndex = 0);
 close;
end;

procedure TLoadA.Button2Click(Sender: TObject);
begin
  RedForm.AnglesSource.ItemIndex := 0;

  close;
end;

procedure TLoadA.Col1Click(Sender: TObject);
begin
  RefreshRes;
end;

procedure TLoadA.FormCreate(Sender: TObject);
begin
  S := TstringList.Create;
end;

procedure TLoadA.FormDestroy(Sender: TObject);
begin
  S.Free;
end;

procedure TLoadA.FormShow(Sender: TObject);
begin
  Label7.Caption := #176;
  try
  S.LoadFromFile(Fname);
  RSpacer.OnClick(nil);
  except
    close;
  end;
end;

procedure TLoadA.isDoyClick(Sender: TObject);
begin
  Edit3.Visible := isDOY.Checked;
  Edit1.Visible := (isFormatted.Checked)and(not C14.Checked);
  Edit2.Visible := isFormatted.Checked;
  RefreshRes;
end;

procedure ClearGrid(StringGrid: TStringGrid);
var i, j: Integer;
begin
  with StringGrid do
  begin
    for i:=1 to RowCount-1 do
    for j:=0 to ColCount-1 do
      Cells[j, i]:='';
    StringGrid.RowCount := 2;
  end;
end;

procedure TLoadA.RefreshRes;
var i, J : integer;
    Sep : String;
begin
   ClearGrid(StringGrid1);

   RenameTabs(StringGrid1);

   try

   for i:= StartFrom.Value-1 to S.count-1 do
   Begin
     if i<0 then
       continue;
       
     if i > (StartFrom.Value-1)+3 then exit;

     with StringGrid1 do
         RowCount := 5;

     if StringGrid1.RowCount > 1 then
       StringGrid1.FixedRows := 1;

     case RSpacer.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Spacer.Text<> '' then sep := Spacer.Text[1];
        3: sep:=';';
        4: sep:=',';
     end;

       StringGrid1.Cells[0,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col1.Value -1, 1, sep[1], False);
       StringGrid1.Cells[1,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col2.Value -1, 1, sep[1], False);
       StringGrid1.Cells[2,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col3.Value -1, 1, sep[1], False);
       StringGrid1.Cells[3,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col4.Value -1, 1, sep[1], False);

       if C10.Checked then
       begin
         StringGrid1.Cells[4,i+1-(StartFrom.Value-1)] :=
            GetCols(s[i], Col10.Value -1, 1, sep[1], False);
       end;


     end;


   except
   end;

end;

procedure TLoadA.RenameTabs(var StringGrid: TStringGrid);
var i: integer;
begin

  StringGrid.ColCount := 4;

  StringGrid.Cells[0,0] := Label2.Caption;
  StringGrid.Cells[1,0] := Label3.Caption;
  StringGrid.Cells[2,0] := Label4.Caption;
  StringGrid.Cells[3,0] := Label5.Caption;

  if C10.Checked then
  begin
     StringGrid1.ColCount := StringGrid1.ColCount+1;
     StringGrid1.Cells[StringGrid1.ColCount-1,0] :=  inf[32];
  end;

  for i:= 0 to StringGrid.ColCount-1 do
    StringGrid.ColWidths[i] := (StringGrid.Width - 10) div StringGrid.ColCount;
end;

procedure TLoadA.RSpacerClick(Sender: TObject);
begin
 RefreshRes;
 Spacer.Enabled := RSpacer.ItemIndex = 2;
end;

procedure TLoadA.SpacerClick(Sender: TObject);
begin
 RefreshRes;
end;

procedure TLoadA.YawKindClick(Sender: TObject);
begin
  Panel1.Visible := YawKind.ItemIndex = 2;
end;

end.
