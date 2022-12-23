object HgtGraphs: THgtGraphs
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'HgtGraphs'
  ClientHeight = 185
  ClientWidth = 234
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
  object Button1: TButton
    Left = 8
    Top = 152
    Width = 121
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 135
    Top = 152
    Width = 90
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object rg: TRadioGroup
    Left = 8
    Top = 8
    Width = 218
    Height = 121
    Caption = #1044#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1075#1088#1072#1092#1080#1082#1072
    ItemIndex = 0
    Items.Strings = (
      'H '#1086#1088#1090#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103
      'H '#1085#1072#1076' '#1101#1083#1083#1080#1087#1089#1086#1080#1076#1086#1084
      #1042#1099#1089#1086#1090#1086#1084#1077#1088
      #1042#1099#1089#1086#1090#1086#1084#1077#1088' (2)')
    TabOrder = 2
  end
end
