object GeoCalcFm: TGeoCalcFm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
  ClientHeight = 270
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelZ: TLabel
    Left = 16
    Top = 101
    Width = 31
    Height = 13
    Caption = 'LabelZ'
    Visible = False
  end
  object LabelY: TLabel
    Left = 16
    Top = 53
    Width = 31
    Height = 13
    Caption = 'LabelY'
  end
  object LabelX: TLabel
    Left = 16
    Top = 8
    Width = 31
    Height = 13
    Caption = 'LabelX'
  end
  object Label3: TLabel
    Left = 16
    Top = 152
    Width = 150
    Height = 43
    AutoSize = False
    Caption = #1048#1079#1084#1077#1085#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1073#1091#1076#1091#1090' '#1087#1077#1088#1077#1074#1077#1076#1077#1085#1099' '#1074' WGS-84 '#1080' '#1087#1077#1088#1077#1076#1072#1085#1099' '#1085#1072#1079#1072#1076
    WordWrap = True
  end
  object PageControl1: TPageControl
    Left = 186
    Top = 8
    Width = 257
    Height = 249
    ActivePage = TabSheet1
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = #1044#1072#1090#1091#1084#1099
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ComboBox1: TComboBox
        Left = 3
        Top = 5
        Width = 243
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
        OnChange = ComboBox1Change
      end
      object RadioGroup2: TRadioGroup
        Left = 4
        Top = 33
        Width = 240
        Height = 180
        Caption = #1058#1080#1087' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
        ItemIndex = 0
        Items.Strings = (
          #1064#1080#1088#1086#1090#1072'/'#1044#1086#1083#1075#1086#1090#1072
          #1055#1088#1086#1089#1090#1088#1072#1085#1089#1090#1074#1077#1085#1085#1099#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
          #1055#1088#1086#1077#1082#1094#1080#1103' '#1043#1072#1091#1089#1089#1072'-'#1050#1088#1102#1075#1077#1088#1072
          #1055#1088#1086#1077#1082#1094#1080#1103' UTM (WGS84/NAD83) - '#1057#1077#1074#1077#1088
          #1055#1088#1086#1077#1082#1094#1080#1103' UTM (WGS84/NAD83) - '#1070#1075)
        TabOrder = 1
        OnClick = RadioGroup2Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1080#1089#1090#1077#1084#1099' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ComboBox2: TComboBox
        Left = 3
        Top = 5
        Width = 243
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
        OnChange = ComboBox2Change
      end
      object ListBox4: TListBox
        Left = 3
        Top = 33
        Width = 243
        Height = 185
        Hint = '111'
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = ListBox4Click
        OnMouseMove = ListBox4MouseMove
      end
    end
  end
  object EX: TEdit
    Left = 16
    Top = 24
    Width = 150
    Height = 21
    TabOrder = 1
    OnChange = EZChange
  end
  object EY: TEdit
    Left = 16
    Top = 70
    Width = 150
    Height = 21
    TabOrder = 2
    OnChange = EZChange
  end
  object EZ: TEdit
    Left = 16
    Top = 117
    Width = 150
    Height = 21
    TabOrder = 3
    Visible = False
    OnChange = EZChange
  end
  object Button1: TButton
    Left = 16
    Top = 201
    Width = 150
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 232
    Width = 150
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
    OnClick = Button2Click
  end
end
