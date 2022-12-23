object LoadA: TLoadA
  Left = 0
  Top = 0
  Caption = 'LoadA'
  ClientHeight = 390
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object YawKind: TRadioGroup
    Left = 349
    Top = 8
    Width = 202
    Height = 121
    Caption = #1059#1075#1086#1083' '#1082#1091#1088#1089#1072
    ItemIndex = 0
    Items.Strings = (
      #1044#1080#1088#1077#1082#1094#1080#1086#1085#1085#1099#1081' '#1091#1075#1086#1083
      #1048#1089#1090#1080#1085#1085#1099#1081' '#1072#1079#1080#1084#1091#1090
      #1052#1072#1075#1085#1080#1090#1085#1099#1081' '#1072#1079#1080#1084#1091#1090' ')
    TabOrder = 5
    OnClick = YawKindClick
  end
  object GroupBox4: TGroupBox
    Left = 290
    Top = 135
    Width = 261
    Height = 121
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1088#1077#1084#1077#1085#1080
    TabOrder = 0
    object TimeSys: TRadioGroup
      Left = 6
      Top = 66
      Width = 131
      Height = 47
      Caption = #1057#1080#1089#1090#1077#1084#1072' '#1074#1088#1077#1084#1077#1085#1080
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'GPS'
        'UTC')
      TabOrder = 0
    end
    object GroupBox5: TGroupBox
      Left = 7
      Top = 17
      Width = 244
      Height = 46
      TabOrder = 1
      object isDoy: TRadioButton
        Left = 7
        Top = 4
        Width = 88
        Height = 17
        Caption = 'DOY'
        TabOrder = 0
        OnClick = isDoyClick
      end
      object isFormatted: TRadioButton
        Left = 143
        Top = 26
        Width = 88
        Height = 17
        Caption = #1055#1086' '#1092#1086#1088#1084#1072#1090#1091':'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = isDoyClick
      end
      object isWoy: TRadioButton
        Left = 7
        Top = 26
        Width = 92
        Height = 17
        Caption = 'Week.Seconds'
        TabOrder = 2
        OnClick = isDoyClick
      end
      object Edit3: TSpinEdit
        Left = 69
        Top = 3
        Width = 68
        Height = 22
        MaxValue = 2070
        MinValue = 1980
        TabOrder = 3
        Value = 2018
        Visible = False
      end
    end
    object Edit1: TComboBox
      Left = 151
      Top = 68
      Width = 101
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'MM/DD/YYYY'
      Visible = False
      Items.Strings = (
        'DD/MM/YYYY'
        'DD-MM-YYYY'
        'DD.MM.YYYY'
        'MM/DD/YYYY'
        'MM-DD-YYYY'
        'MM.DD.YYYY'
        'YYYY/MM/DD'
        'YYYY-MM-DD'
        'YYYY.MM.DD')
    end
    object Edit2: TComboBox
      Left = 151
      Top = 90
      Width = 101
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'hh:mm:ss.zzz'
      Items.Strings = (
        'hh:mm:ss.zzz'
        'hh:mm:ss'
        'hh-mm-ss.zz'
        'hh-mm-ss')
    end
  end
  object GroupBox3: TGroupBox
    Left = 185
    Top = 8
    Width = 157
    Height = 121
    Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 22
      Width = 22
      Height = 13
      Caption = 'Time'
    end
    object Label3: TLabel
      Left = 16
      Top = 46
      Width = 20
      Height = 13
      Caption = 'Yaw'
    end
    object Label4: TLabel
      Left = 16
      Top = 70
      Width = 23
      Height = 13
      Caption = 'Pitch'
    end
    object Label5: TLabel
      Left = 16
      Top = 94
      Width = 17
      Height = 13
      Caption = 'Roll'
    end
    object Col1: TSpinEdit
      Left = 96
      Top = 19
      Width = 54
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 0
      Value = 1
      OnChange = Col1Click
      OnClick = Col1Click
    end
    object Col2: TSpinEdit
      Left = 96
      Top = 43
      Width = 54
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 1
      Value = 2
      OnChange = Col1Click
      OnClick = Col1Click
    end
    object Col3: TSpinEdit
      Left = 96
      Top = 67
      Width = 54
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 2
      Value = 3
      OnChange = Col1Click
      OnClick = Col1Click
    end
    object Col4: TSpinEdit
      Left = 96
      Top = 91
      Width = 54
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 3
      Value = 4
      OnChange = Col1Click
      OnClick = Col1Click
    end
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 262
    Width = 542
    Height = 89
    ColCount = 4
    DefaultColWidth = 120
    DefaultRowHeight = 16
    FixedCols = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowMoving, goColMoving, goEditing, goThumbTracking]
    ParentFont = False
    TabOrder = 2
    ColWidths = (
      120
      120
      120
      120)
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 171
    Height = 165
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1086#1088#1084#1072#1090#1072
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 131
      Width = 93
      Height = 13
      Caption = #1053#1072#1095#1072#1090#1100' '#1089#1086' '#1089#1090#1088#1086#1082#1080':'
    end
    object RSpacer: TRadioGroup
      Left = 8
      Top = 16
      Width = 153
      Height = 105
      Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1080
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #1055#1088#1086#1073#1077#1083#1099
        'Tab'
        #1044#1088#1091#1075#1080#1077
        ';'
        ',')
      TabOrder = 1
      OnClick = RSpacerClick
    end
    object Spacer: TEdit
      Left = 81
      Top = 91
      Width = 41
      Height = 21
      Enabled = False
      MaxLength = 1
      TabOrder = 0
      OnClick = SpacerClick
    end
    object StartFrom: TSpinEdit
      Left = 110
      Top = 127
      Width = 51
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 2
      Value = 1
      OnChange = Col1Click
      OnClick = Col1Click
    end
  end
  object GroupBox6: TGroupBox
    Left = 185
    Top = 135
    Width = 99
    Height = 121
    Caption = #1044#1072#1090#1072
    TabOrder = 4
    object Col10: TSpinEdit
      Left = 48
      Top = 75
      Width = 41
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 0
      Value = 2
      OnChange = Col1Click
      OnClick = Col1Click
    end
    object C12: TRadioButton
      Left = 10
      Top = 15
      Width = 86
      Height = 28
      Caption = #1042' '#1089#1090#1086#1083#1073#1094#1077' '#1074#1088#1077#1084#1077#1085#1080
      TabOrder = 1
      WordWrap = True
      OnClick = isDoyClick
    end
    object C10: TRadioButton
      Left = 10
      Top = 47
      Width = 86
      Height = 26
      Caption = #1054#1090#1076#1077#1083#1100#1085#1099#1084' '#1089#1090#1086#1083#1073#1094#1086#1084
      TabOrder = 2
      WordWrap = True
      OnClick = isDoyClick
    end
    object C14: TRadioButton
      Left = 9
      Top = 99
      Width = 86
      Height = 17
      Caption = #1053#1077' '#1079#1072#1076#1072#1085#1072
      Checked = True
      TabOrder = 3
      TabStop = True
      WordWrap = True
      OnClick = isDoyClick
    end
  end
  object Panel1: TPanel
    Left = 474
    Top = 64
    Width = 71
    Height = 58
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object Label6: TLabel
      Left = 6
      Top = -1
      Width = 59
      Height = 26
      AutoSize = False
      Caption = #1052#1072#1075#1085#1080#1090#1085#1086#1077' '#1089#1082#1083#1086#1085#1077#1085#1080#1077':'
      WordWrap = True
    end
    object Label7: TLabel
      Left = 57
      Top = 33
      Width = 4
      Height = 13
      Caption = '!'
    end
    object Edit4: TEdit
      Left = 6
      Top = 30
      Width = 48
      Height = 21
      TabOrder = 0
      Text = '0'
    end
  end
  object Button1: TButton
    Left = 346
    Top = 357
    Width = 102
    Height = 25
    Caption = #1054#1050
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 453
    Top = 357
    Width = 97
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 8
    OnClick = Button2Click
  end
  object isDegs: TRadioGroup
    Left = 8
    Top = 176
    Width = 171
    Height = 80
    Caption = #1045#1076#1080#1085#1080#1094#1099' '
    ItemIndex = 0
    Items.Strings = (
      #1043#1088#1072#1076#1091#1089#1099
      #1056#1072#1076#1080#1072#1085#1099)
    TabOrder = 9
  end
end
