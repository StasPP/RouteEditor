object TrackSaver: TTrackSaver
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'TrackSaver'
  ClientHeight = 272
  ClientWidth = 416
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
  object GroupBox1: TGroupBox
    Left = 199
    Top = 8
    Width = 210
    Height = 74
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1088#1077#1076#1091#1082#1094#1080#1080
    TabOrder = 0
    object Angs: TCheckBox
      Left = 16
      Top = 25
      Width = 153
      Height = 17
      Caption = #1059#1075#1083#1099': '#1082#1088#1077#1085', '#1090#1072#1085#1075#1072#1078', '#1082#1091#1088#1089
      TabOrder = 0
    end
    object dXYH: TCheckBox
      Left = 16
      Top = 48
      Width = 153
      Height = 17
      Caption = #1055#1086#1087#1088#1072#1074#1082#1080' '#1079#1072' '#1088#1077#1076#1091#1082#1094#1080#1102
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 74
    Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
    TabOrder = 1
    object iXYH: TCheckBox
      Left = 16
      Top = 25
      Width = 135
      Height = 17
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' X, Y, H(msl)'
      TabOrder = 0
    end
    object iBLH: TCheckBox
      Left = 16
      Top = 48
      Width = 154
      Height = 17
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' B, L, H (WGS-84)'
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 88
    Width = 233
    Height = 74
    Caption = #1056#1077#1076#1091#1094#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1082#1086#1086#1088#1076#1080#1085#1082#1072#1090#1099
    TabOrder = 2
    object RedXYH: TCheckBox
      Left = 16
      Top = 25
      Width = 177
      Height = 17
      Caption = #1056#1077#1076#1091#1094#1080#1088#1086#1074#1072#1085#1085#1099#1077' X, Y, H(msl)'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 0
    end
    object RedBLH: TCheckBox
      Left = 16
      Top = 48
      Width = 193
      Height = 17
      Caption = #1056#1077#1076#1091#1094#1080#1088#1086#1074#1072#1085#1085#1099#1077' B, L, H (WGS-84)'
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 67
    Top = 237
    Width = 137
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 210
    Top = 237
    Width = 137
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = Button2Click
  end
  object TimeSys: TRadioGroup
    Left = 247
    Top = 88
    Width = 162
    Height = 42
    Caption = #1042#1088#1077#1084#1103
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'GPS'
      'UTC')
    TabOrder = 5
  end
  object SepDate: TCheckBox
    Left = 256
    Top = 134
    Width = 145
    Height = 28
    Caption = #1044#1072#1090#1072' '#1086#1090#1076#1077#1083#1100#1085#1099#1084' '#1089#1090#1086#1083#1073#1094#1086#1084
    TabOrder = 6
    WordWrap = True
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 168
    Width = 401
    Height = 63
    Caption = #1057#1080#1089#1090#1077#1084#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090' X Y H'
    TabOrder = 7
    object OlderCS: TRadioButton
      Left = 9
      Top = 19
      Width = 97
      Height = 17
      Caption = #1048#1089#1093#1086#1076#1085#1072#1103
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object newCS: TRadioButton
      Left = 9
      Top = 41
      Width = 107
      Height = 14
      Caption = #1047#1072#1076#1072#1090#1100' '#1085#1086#1074#1091#1102
      TabOrder = 1
      OnClick = newCSClick
    end
    object Csys: TStaticText
      Left = 112
      Top = 39
      Width = 281
      Height = 17
      Cursor = crHandPoint
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1080#1089#1090#1077#1084#1091' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      Color = clWindow
      ParentColor = False
      TabOrder = 2
      OnClick = CsysClick
    end
    object OldSys: TStaticText
      Left = 112
      Top = 18
      Width = 281
      Height = 17
      Cursor = crArrow
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1080#1089#1090#1077#1084#1091' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      Color = clWindow
      ParentColor = False
      TabOrder = 3
      OnClick = OldSysClick
    end
  end
end
