unit LoadTrac;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, ValEdit, StdCtrls, ExtCtrls, ComCtrls, Grids;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ComboBox1: TComboBox;
    RadioGroup2: TRadioGroup;
    TabSheet2: TTabSheet;
    ComboBox2: TComboBox;
    ListBox4: TListBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    RSpacer: TRadioGroup;
    Spacer: TEdit;
    ValueList: TValueListEditor;
    SpinEdit1: TSpinEdit;
    RoutesBE: TRadioGroup;
    ValueList2: TValueListEditor;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
