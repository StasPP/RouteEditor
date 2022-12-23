object LoadBlnData: TLoadBlnData
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1084#1087#1086#1088#1090' '#1080#1079' '#1092#1086#1088#1084#1072#1090#1072' Surfer *.Bln'
  ClientHeight = 145
  ClientWidth = 392
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
  object Label1: TLabel
    Left = 16
    Top = 52
    Width = 157
    Height = 13
    Caption = #1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1080#1088#1091#1077#1084#1099#1093' '#1086#1073#1098#1077#1082#1090#1086#1074':'
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 139
    Height = 13
    Caption = #1057#1080#1089#1090#1077#1084#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090' '#1092#1072#1081#1083#1072':'
  end
  object Label3: TLabel
    Left = 201
    Top = 52
    Width = 180
    Height = 13
    Caption = #1055#1086#1088#1103#1076#1086#1082' '#1087#1077#1088#1077#1095#1080#1089#1083#1077#1085#1080#1103' '#1082#1086#1086#1088#1076#1080#1085#1072#1090':'
  end
  object Csys: TStaticText
    Left = 16
    Top = 27
    Width = 365
    Height = 19
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    TabOrder = 0
    OnClick = CsysClick
  end
  object BlnDataKind: TComboBox
    Left = 16
    Top = 71
    Width = 153
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 1
    Text = #1043#1088#1072#1085#1080#1094#1099' '#1091#1095#1072#1089#1090#1082#1072
    Items.Strings = (
      #1043#1088#1072#1085#1080#1094#1099' '#1091#1095#1072#1089#1090#1082#1072
      #1052#1072#1088#1096#1088#1091#1090#1099' ('#1087#1088#1086#1092#1080#1083#1080')'
      #1043#1088#1072#1085#1080#1094#1099' + '#1084#1072#1088#1096#1088#1091#1090#1099)
  end
  object BlnDataOrder: TComboBox
    Left = 201
    Top = 71
    Width = 153
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 2
  end
  object Button1: TButton
    Left = 81
    Top = 112
    Width = 108
    Height = 25
    Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 195
    Top = 112
    Width = 108
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = Button2Click
  end
end
