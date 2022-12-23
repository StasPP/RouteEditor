object Fknotgrouprenum: TFknotgrouprenum
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1086#1084#1077#1088#1072' '#1088#1072#1089#1089#1090#1086#1085#1086#1074#1086#1082' '#1087#1077#1090#1077#1083#1100
  ClientHeight = 168
  ClientWidth = 426
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
    Left = 8
    Top = 8
    Width = 49
    Height = 13
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077
  end
  object Button1: TButton
    Left = 120
    Top = 135
    Width = 96
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 229
    Top = 135
    Width = 92
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object KindA: TComboBox
    Left = 8
    Top = 27
    Width = 169
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 2
    Text = #1044#1086#1073#1072#1074#1080#1090#1100' '#1095#1080#1089#1083#1086
    OnChange = KindAChange
    Items.Strings = (
      #1044#1086#1073#1072#1074#1080#1090#1100' '#1095#1080#1089#1083#1086
      #1055#1077#1088#1077#1085#1091#1084#1077#1088#1086#1074#1072#1090#1100)
  end
  object isAllK: TRadioGroup
    Left = 8
    Top = 57
    Width = 169
    Height = 64
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    ItemIndex = 0
    Items.Strings = (
      #1050' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1084' '#1087#1077#1090#1083#1103#1084
      #1050#1086' '#1074#1089#1077#1084' '#1087#1077#1090#1083#1103#1084)
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 192
    Top = 8
    Width = 226
    Height = 113
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 4
    object RPC: TPageControl
      Left = 3
      Top = 16
      Width = 221
      Height = 94
      ActivePage = TabSheet2
      Style = tsFlatButtons
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        TabVisible = False
        object Label2: TLabel
          Left = 3
          Top = 3
          Width = 105
          Height = 13
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1086#1090#1085#1103#1090#1100':'
        end
        object AddL1: TSpinEdit
          Left = 3
          Top = 20
          Width = 60
          Height = 22
          MaxValue = 1000000
          MinValue = -1000000
          TabOrder = 0
          Value = 1
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
        TabVisible = False
        object Label3: TLabel
          Left = 5
          Top = 3
          Width = 49
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1053#1072#1095#1072#1090#1100' '#1089':'
        end
        object Label4: TLabel
          Left = 120
          Top = 3
          Width = 38
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1064#1072#1075':'
        end
        object AddL2: TSpinEdit
          Left = 60
          Top = 0
          Width = 45
          Height = 22
          MaxValue = 100000
          MinValue = -100000
          TabOrder = 0
          Value = 1
        end
        object doSortK: TRadioGroup
          Left = 1
          Top = 26
          Width = 210
          Height = 59
          Caption = #1055#1086#1088#1103#1076#1086#1082' '#1085#1091#1084#1077#1088#1072#1094#1080#1080
          ItemIndex = 0
          Items.Strings = (
            #1055#1086' '#1089#1087#1080#1089#1082#1091' '#1087#1077#1090#1077#1083#1100
            #1055#1086' '#1080#1089#1093#1086#1076#1085#1086#1084#1091' '#1085#1086#1084#1077#1088#1091' '#1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1080)
          TabOrder = 1
        end
        object StepL: TSpinEdit
          Left = 164
          Top = 0
          Width = 45
          Height = 22
          MaxValue = 100000
          MinValue = -100000
          TabOrder = 2
          Value = 1
        end
      end
    end
  end
end
