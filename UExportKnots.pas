unit UExportKnots;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CoordSysFm, MapEditor, GeoFunctions, GeoClasses, MapperFm,
  ComCtrls, ExtCtrls, BasicMapObjects, LangLoader;

type
  TFExportKnots = class(TForm)
    DoDel: TCheckBox;
    Csys: TStaticText;
    NewOnly: TCheckBox;
    EPC: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    BlnData: TRadioGroup;
    BlnDataOrder: TComboBox;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    doP: TCheckBox;
    doK: TCheckBox;
    doC: TCheckBox;
    GroupBox2: TGroupBox;
    gPick: TCheckBox;
    gCorn: TCheckBox;
    gCent: TCheckBox;
    gRout: TCheckBox;
    gArea: TCheckBox;
    RSpacer: TRadioGroup;
    Spacer: TEdit;
    AddHeader: TCheckBox;
    AddNum: TCheckBox;
    SaveDialog1: TSaveDialog;
    gKnot: TCheckBox;
    SaveEveryOne: TCheckBox;
    TabSheet4: TTabSheet;
    EMDP: TRadioGroup;
    EMDP_dec: TCheckBox;
    EMDP_ext: TCheckBox;
    EMDP_name: TCheckBox;
    procedure CsysClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure RSpacerClick(Sender: TObject);
    procedure SpacerChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CSbox;
    procedure TabSheet1Show(Sender: TObject);
    procedure EMDPClick(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
  private
    { Private declarations }
  public
    NewFrom: Integer;
    { Public declarations }
  end;

var
  FExportKnots: TFExportKnots;

implementation

{$R *.dfm}

procedure TFExportKnots.Button1Click(Sender: TObject);
var Rs:String;
    FromN:Integer;
    DoDir: Boolean;
begin
 DoDir := false;
 FromN := 0;
 if NewOnly.Checked then
   FromN := NewFrom;

 case EPC.ActivePageIndex of
   0: begin
      SaveDialog1.Filter := 'Text files *.txt|*.txt|Any file|*.*';


      if not SaveDialog1.Execute then
         exit;

      Case RSpacer.itemIndex of
        0: Rs := ' ';
        1: Rs := #$9;
        2: Rs := Spacer.Text[1];
        3: Rs := ';';
        4: Rs := ',';
      end;

      if SaveEveryOne.Checked then
        DoDir := MessageDlg(inf[168], mtConfirmation, mbYesNo, 0) = 6;

      SaveTXTKnotMarkers(SaveDialog1.FileName, MapFm.CoordSysN, FromN, Rs,
           doP.Checked, doK.Checked, doC.Checked, AddHeader.Checked,
           AddNum.Checked, true, SaveEveryOne.Checked, DoDir);
   end;

   1: begin
      SaveDialog1.Filter := 'Surfer *.Bln files|*.bln|Any file|*.*';

      if not SaveDialog1.Execute then
         exit;

      SaveBLNKnotFile(SaveDialog1.FileName, MapFm.CoordSysN, FromN,
               BlnData.ItemIndex, BlnDataOrder.ItemIndex, true);
   end;

   2: begin
      SaveDialog1.Filter := 'GPS eXchange format *.GPX|*.gpx|Any file|*.*';

      if not SaveDialog1.Execute then
         exit;

      if SaveEveryOne.Checked then
        DoDir := MessageDlg(inf[168], mtConfirmation, mbYesNo, 0) = 6;

      SaveGPXFile(SaveDialog1.FileName, true, gPick.Checked,
          gCorn.Checked, gCent.Checked, gRout.Checked, gKnot.Checked,
          gArea.Checked, false, FromN, SaveEveryOne.Checked, DoDir);
   end;

   3: begin
      if CoordinateSystemList[MapFm.CoordSysN].ProjectionType < 2 then
      begin
        MessageDlg(inf[169], mtError, [mbOk], 0);
        exit;
      end;

      case EMDP.ItemIndex of
        0: SaveDialog1.Filter := 'EMDP coordinates *.xyz|*.xyz|Any file|*.*';
        1: SaveDialog1.Filter := 'EMDP loops coordinates *.mxyz|*.mxyz|Any file|*.*';
      end;

      if not SaveDialog1.Execute then
         exit;

      case EMDP.ItemIndex of
        0: SaveXYZFile(SaveDialog1.FileName, MapFm.CoordSysN, FromN,
             EMDP_dec.Checked, EMDP_ext.Checked, true);
        1: SaveMXYZFile(SaveDialog1.FileName, MapFm.CoordSysN, FromN,
             EMDP_dec.Checked, EMDP_name.Checked, EMDP_ext.Checked, true);
      end;
   end;

 end;

 if DoDel.Checked then
 begin
   SetLength(Markers, FromN);
   NewFrom := 0;
 end;

 close
end;

procedure TFExportKnots.CSbox;
begin
 if MapFm.CoordSysN >= 0 then
 Begin
  BlnDataOrder.Clear;
  case CoordinateSystemList[MapFm.CoordSysN].ProjectionType of
    0: begin
      BlnDataOrder.Items.Add(inf[112]);
      BlnDataOrder.Items.Add(inf[113]);
    end;
    1: BlnDataOrder.Items.Add(inf[114]);
    2..4: begin
      BlnDataOrder.Items.Add(inf[115]);
      BlnDataOrder.Items.Add(inf[116]);
    end;
  end;
  BlnDataOrder.ItemIndex := 0;
 End;
 //
end;

procedure TFExportKnots.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TFExportKnots.CsysClick(Sender: TObject);
begin
  CSForm.ShowModal;
  if MapFm.CoordSysN <> -1 then
    Csys.Caption := CoordinateSystemList[MapFm.CoordSysN].Caption;
  MapFm.Csys.Caption := Csys.Caption;
  CSBox;
end;



procedure TFExportKnots.EMDPClick(Sender: TObject);
begin
  EMDP_Name.Enabled := EMDP.ItemIndex = 1;
end;

procedure TFExportKnots.FormShow(Sender: TObject);
begin
  Csys.Caption := CoordinateSystemList[MapFm.CoordSysN].Caption;
  CsBox;
end;

procedure TFExportKnots.RSpacerClick(Sender: TObject);
begin
  Spacer.Enabled := RSpacer.ItemIndex = 2;
end;

procedure TFExportKnots.SpacerChange(Sender: TObject);
begin
 RSpacer.ItemIndex := 2;
end;

procedure TFExportKnots.TabSheet1Show(Sender: TObject);
begin
 Csys.Show;
 SaveEveryOne.Show;
end;

procedure TFExportKnots.TabSheet2Show(Sender: TObject);
begin
 Csys.Show;
 SaveEveryOne.Hide;
end;

procedure TFExportKnots.TabSheet3Show(Sender: TObject);
begin
 SaveEveryOne.Show;
 Csys.Hide
end;

procedure TFExportKnots.TabSheet4Show(Sender: TObject);
begin
 Csys.Show;
 SaveEveryOne.Hide;
end;

end.
