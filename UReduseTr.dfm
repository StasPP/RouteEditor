object FreduceTrack: TFreduceTrack
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1072#1079#1088#1077#1076#1080#1090#1100' '#1090#1088#1072#1077#1082#1090#1086#1088#1080#1102
  ClientHeight = 184
  ClientWidth = 281
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
  object Panel1: TPanel
    Left = 8
    Top = 76
    Width = 265
    Height = 62
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 78
      Top = 34
      Width = 21
      Height = 13
      Caption = #1089#1077#1082'.'
    end
    object Label2: TLabel
      Left = 206
      Top = 34
      Width = 6
      Height = 13
      Caption = #1084
    end
    object dTEp: TCheckBox
      Left = 8
      Top = 8
      Width = 105
      Height = 17
      Caption = #1055#1086' '#1074#1088#1077#1084#1077#1085#1080
      TabOrder = 0
      OnClick = IEpClick
    end
    object dLEp: TCheckBox
      Left = 152
      Top = 8
      Width = 105
      Height = 17
      Caption = #1055#1086' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1102
      TabOrder = 1
      OnClick = IEpClick
    end
    object EpT: TComboBox
      Left = 24
      Top = 31
      Width = 48
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 2
      Text = '1'
      Items.Strings = (
        '1'
        '2'
        '5'
        '10'
        '15'
        '30')
    end
    object EpL: TComboBox
      Left = 152
      Top = 31
      Width = 48
      Height = 21
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 3
      Text = '1'
      Items.Strings = (
        '0,1'
        '0,5'
        '1'
        '2'
        '5'
        '10'
        '20'
        '50')
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 144
    Width = 265
    Height = 1
    BevelInner = bvLowered
    TabOrder = 1
    Visible = False
    object Label4: TLabel
      Left = 249
      Top = 34
      Width = 6
      Height = 13
      Caption = #1084
    end
    object Label3: TLabel
      Left = 149
      Top = 34
      Width = 41
      Height = 13
      Caption = #1085#1077' '#1088#1077#1078#1077
    end
    object dAzmtEp: TCheckBox
      Left = 8
      Top = 8
      Width = 233
      Height = 17
      Caption = #1055#1086' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1102' '#1072#1079#1080#1084#1091#1090#1072' '#1076#1074#1080#1078#1077#1085#1080#1103
      TabOrder = 0
      OnClick = IEpClick
    end
    object EpAzmt2: TComboBox
      Left = 198
      Top = 31
      Width = 48
      Height = 21
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 1
      Text = '1'
      Items.Strings = (
        '0,1'
        '0,5'
        '1'
        '2'
        '5'
        '10'
        '20'
        '50')
    end
    object EpAzmt1: TComboBox
      Left = 24
      Top = 31
      Width = 75
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '1'#176
      Items.Strings = (
        '0'#176' 30'#39
        '1'#176
        '5'#176
        '15'#176)
    end
  end
  object bOk: TButton
    Left = 16
    Top = 151
    Width = 122
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Enabled = False
    TabOrder = 2
    OnClick = bOkClick
  end
  object bCancel: TButton
    Left = 144
    Top = 151
    Width = 122
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = bCancelClick
  end
  object Panel3: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 62
    BevelInner = bvLowered
    TabOrder = 4
    object EpI: TSpinEdit
      Left = 24
      Top = 31
      Width = 49
      Height = 22
      MaxValue = 1000
      MinValue = 2
      TabOrder = 0
      Value = 2
    end
    object IEp: TCheckBox
      Left = 8
      Top = 8
      Width = 169
      Height = 17
      Caption = #1054#1089#1090#1072#1074#1080#1090#1100' '#1082#1072#1078#1076#1091#1102' i-'#1102' '#1101#1087#1086#1093#1091
      TabOrder = 1
      OnClick = IEpClick
    end
  end
end
