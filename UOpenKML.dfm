object KmlOpn: TKmlOpn
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'KmlOpn'
  ClientHeight = 211
  ClientWidth = 210
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 168
    Width = 210
    Height = 43
    Align = alBottom
    Shape = bsTopLine
  end
  object Button1: TButton
    Left = 16
    Top = 178
    Width = 89
    Height = 25
    Caption = 'Open'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 113
    Top = 178
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 194
    Height = 92
    Caption = 'Objects'
    TabOrder = 2
    object DoMark: TCheckBox
      Left = 16
      Top = 19
      Width = 97
      Height = 17
      Caption = 'Markers'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object DoRts: TCheckBox
      Left = 16
      Top = 42
      Width = 97
      Height = 17
      Caption = 'Routes'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object DoFrame: TCheckBox
      Left = 16
      Top = 65
      Width = 97
      Height = 17
      Caption = 'Area borders'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object DoAddR: TRadioButton
    Left = 16
    Top = 112
    Width = 186
    Height = 17
    Caption = 'Add to existing'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object DoResetR: TRadioButton
    Left = 16
    Top = 135
    Width = 186
    Height = 17
    Caption = 'Reset existing'
    TabOrder = 4
  end
end
