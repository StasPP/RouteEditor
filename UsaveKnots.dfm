object FSaveKnots: TFSaveKnots
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1085#1072#1073#1086#1088' '#1075#1077#1085#1077#1088#1072#1090#1086#1088#1085#1099#1093' '#1087#1077#1090#1077#1083#1100
  ClientHeight = 147
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 145
    Height = 97
    Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1074' '#1084#1072#1088#1082#1077#1088#1099
    TabOrder = 0
    object doP: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = #1055#1080#1082#1077#1090#1099
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object doK: TCheckBox
      Left = 16
      Top = 47
      Width = 97
      Height = 17
      Caption = #1059#1075#1083#1099' '#1087#1077#1090#1077#1083#1100
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object doC: TCheckBox
      Left = 16
      Top = 70
      Width = 97
      Height = 17
      Caption = #1062#1077#1085#1090#1088#1099' '#1087#1077#1090#1077#1083#1100
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 56
    Top = 112
    Width = 131
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 193
    Top = 112
    Width = 120
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object DoExp: TCheckBox
    Left = 167
    Top = 78
    Width = 195
    Height = 17
    Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
    TabOrder = 3
  end
  object DelOld: TRadioGroup
    Left = 159
    Top = 8
    Width = 218
    Height = 64
    Caption = #1044#1088#1091#1075#1080#1077' '#1084#1072#1088#1082#1077#1088#1099
    ItemIndex = 0
    Items.Strings = (
      #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1072#1088#1099#1077' '#1084#1072#1088#1082#1077#1088#1099
      #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1082' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1084)
    TabOrder = 4
  end
  object Exp: TButton
    Left = 352
    Top = 8
    Width = 26
    Height = 25
    TabOrder = 5
    Visible = False
    OnClick = ExpClick
  end
end
