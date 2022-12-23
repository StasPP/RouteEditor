unit HintFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, GIFImg, LangLoader;

type
  THintForm = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HintForm: THintForm;

implementation

{$R *.dfm}

procedure THintForm.BitBtn1Click(Sender: TObject);
begin
 close;
end;

procedure THintForm.FormShow(Sender: TObject);
begin
  Memo1.Lines.LoadFromFile('Data\Mapper\'+Lang+'\GHint.txt');
end;

end.
