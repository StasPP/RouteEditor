object MarkH: TMarkH
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'MarkH'
  ClientHeight = 241
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnShow = SpinEdit1Change
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 22
    Height = 13
    Caption = #1058#1080#1087':'
    OnClick = Label1Click
  end
  object Label2: TLabel
    Left = 16
    Top = 58
    Width = 103
    Height = 13
    Caption = 'H '#1086#1088#1090#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103':'
  end
  object Label3: TLabel
    Left = 16
    Top = 107
    Width = 103
    Height = 13
    Caption = 'H '#1101#1083#1083#1080#1087#1089#1086#1080#1076#1072#1083#1100#1085#1072#1103':'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 200
    Width = 250
    Height = 41
    Align = alBottom
    Shape = bsTopLine
    ExplicitLeft = -35
    ExplicitTop = 203
    ExplicitWidth = 285
  end
  object Label4: TLabel
    Left = 16
    Top = 152
    Width = 69
    Height = 13
    Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077':'
  end
  object Label5: TLabel
    Left = 96
    Top = 32
    Width = 3
    Height = 13
  end
  object Button1: TButton
    Left = 15
    Top = 211
    Width = 104
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 125
    Top = 211
    Width = 108
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '0'
    OnKeyDown = Edit1KeyDown
  end
  object Edit2: TEdit
    Left = 16
    Top = 123
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '0'
    OnKeyDown = Edit1KeyDown
  end
  object SpinEdit1: TSpinEdit
    Left = 16
    Top = 28
    Width = 57
    Height = 22
    Enabled = False
    MaxValue = 15
    MinValue = 0
    TabOrder = 4
    Value = 0
    OnChange = SpinEdit1Change
  end
  object Edit3: TEdit
    Left = 16
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '0'
    OnKeyDown = Edit1KeyDown
  end
end
