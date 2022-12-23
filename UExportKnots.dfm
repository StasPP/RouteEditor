object FExportKnots: TFExportKnots
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Export loops'
  ClientHeight = 250
  ClientWidth = 454
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
  object DoDel: TCheckBox
    Left = 12
    Top = 185
    Width = 205
    Height = 17
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1084#1072#1088#1082#1077#1088#1099' '#1087#1086#1089#1083#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103
    TabOrder = 0
  end
  object NewOnly: TCheckBox
    Left = 12
    Top = 162
    Width = 205
    Height = 17
    Caption = #1057#1086#1093#1088#1072#1085#1080#1088#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1086#1074#1099#1077' '#1084#1072#1088#1082#1077#1088#1099
    TabOrder = 1
  end
  object Csys: TStaticText
    Left = 12
    Top = 135
    Width = 432
    Height = 21
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    TabOrder = 2
    OnClick = CsysClick
  end
  object EPC: TPageControl
    Left = 8
    Top = 8
    Width = 440
    Height = 122
    ActivePage = TabSheet1
    Style = tsButtons
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083' *.txt'
      OnShow = TabSheet1Show
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 145
        Height = 87
        Caption = #1057#1086#1093#1088#1072#1085#1103#1077#1084#1099#1077' '#1076#1072#1085#1085#1099#1077
        TabOrder = 0
        object doP: TCheckBox
          Left = 12
          Top = 19
          Width = 103
          Height = 17
          Caption = #1055#1080#1082#1077#1090#1099
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object doK: TCheckBox
          Left = 12
          Top = 40
          Width = 103
          Height = 17
          Caption = #1059#1075#1083#1099' '#1087#1077#1090#1077#1083#1100
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object doC: TCheckBox
          Left = 12
          Top = 61
          Width = 103
          Height = 17
          Caption = #1062#1077#1085#1090#1088#1099' '#1087#1077#1090#1077#1083#1100
          TabOrder = 2
        end
      end
      object RSpacer: TRadioGroup
        Left = 163
        Top = 0
        Width = 182
        Height = 87
        Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1080
        Columns = 2
        ItemIndex = 1
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
        Left = 255
        Top = 59
        Width = 41
        Height = 21
        Enabled = False
        MaxLength = 1
        TabOrder = 2
        OnChange = SpacerChange
      end
      object AddHeader: TCheckBox
        Left = 353
        Top = 16
        Width = 72
        Height = 26
        Caption = #1064#1072#1087#1082#1072
        Checked = True
        State = cbChecked
        TabOrder = 3
        WordWrap = True
      end
      object AddNum: TCheckBox
        Left = 353
        Top = 45
        Width = 72
        Height = 31
        Caption = #1057#1090#1086#1083#1073#1077#1094' '#1085#1086#1084#1077#1088#1086#1074
        Checked = True
        State = cbChecked
        TabOrder = 4
        WordWrap = True
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Surfer *.bln'
      ImageIndex = 1
      OnShow = TabSheet2Show
      object Label3: TLabel
        Left = 219
        Top = 3
        Width = 180
        Height = 13
        Caption = #1055#1086#1088#1103#1076#1086#1082' '#1087#1077#1088#1077#1095#1080#1089#1083#1077#1085#1080#1103' '#1082#1086#1086#1088#1076#1080#1085#1072#1090':'
      end
      object BlnData: TRadioGroup
        Left = 20
        Top = 3
        Width = 187
        Height = 87
        Caption = #1057#1086#1093#1088#1072#1085#1103#1077#1084#1099#1077' '#1076#1072#1085#1085#1099#1077
        ItemIndex = 0
        Items.Strings = (
          #1050#1086#1085#1090#1091#1088#1099' '#1087#1077#1090#1077#1083#1100
          #1055#1088#1086#1092#1080#1083#1080
          #1059#1095#1072#1089#1090#1086#1082' '#1088#1072#1073#1086#1090)
        TabOrder = 0
      end
      object BlnDataOrder: TComboBox
        Left = 219
        Top = 19
        Width = 153
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'GPS EXchange *.gpx'
      ImageIndex = 2
      OnShow = TabSheet3Show
      object GroupBox2: TGroupBox
        Left = 20
        Top = 3
        Width = 384
        Height = 87
        Caption = #1057#1086#1093#1088#1072#1085#1103#1077#1084#1099#1077' '#1076#1072#1085#1085#1099#1077
        TabOrder = 0
        object gPick: TCheckBox
          Left = 11
          Top = 17
          Width = 103
          Height = 17
          Caption = #1055#1080#1082#1077#1090#1099
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object gCorn: TCheckBox
          Left = 11
          Top = 40
          Width = 103
          Height = 17
          Caption = #1059#1075#1083#1099' '#1087#1077#1090#1077#1083#1100
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object gCent: TCheckBox
          Left = 11
          Top = 63
          Width = 103
          Height = 17
          Caption = #1062#1077#1085#1090#1088#1099' '#1087#1077#1090#1077#1083#1100
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object gRout: TCheckBox
          Left = 179
          Top = 17
          Width = 171
          Height = 17
          Caption = #1055#1088#1086#1092#1080#1083#1080' ('#1084#1072#1088#1096#1088#1091#1090#1099')'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object gArea: TCheckBox
          Left = 179
          Top = 63
          Width = 190
          Height = 17
          Caption = #1043#1088#1072#1085#1080#1094#1099' '#1091#1095#1072#1089#1090#1082#1072' ('#1082#1072#1082' '#1084#1072#1088#1096#1088#1091#1090')'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object gKnot: TCheckBox
          Left = 179
          Top = 40
          Width = 193
          Height = 17
          Caption = #1043#1088#1072#1085#1080#1094#1099' '#1087#1077#1090#1077#1083#1100' ('#1082#1072#1082' '#1084#1072#1088#1096#1088#1091#1090#1099')'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'EMDP *.xyz/*.mxyz'
      ImageIndex = 3
      OnShow = TabSheet4Show
      object EMDP: TRadioGroup
        Left = 14
        Top = 2
        Width = 107
        Height = 83
        Caption = #1060#1086#1088#1084#1072#1090
        ItemIndex = 0
        Items.Strings = (
          'XYZ'
          'mXYZ')
        TabOrder = 0
        OnClick = EMDPClick
      end
      object EMDP_dec: TCheckBox
        Left = 140
        Top = 61
        Width = 241
        Height = 17
        Caption = #1054#1082#1088#1091#1075#1083#1103#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1076#1086' '#1094#1077#1083#1099#1093
        TabOrder = 1
      end
      object EMDP_ext: TCheckBox
        Left = 140
        Top = 14
        Width = 241
        Height = 17
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1088#1072#1089#1096#1080#1088#1077#1085#1080#1103' *.prf/*.eds'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object EMDP_name: TCheckBox
        Left = 140
        Top = 38
        Width = 280
        Height = 17
        Caption = #1053#1086#1084#1077#1088' '#1075#1077#1085#1077#1088#1072#1090#1086#1088#1072' '#1087#1086' '#1080#1084#1077#1085#1080' '#1080' '#1085#1086#1084#1077#1088#1091' '#1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1080
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 3
      end
    end
  end
  object Button1: TButton
    Left = 72
    Top = 215
    Width = 169
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 247
    Top = 215
    Width = 169
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
    OnClick = Button2Click
  end
  object SaveEveryOne: TCheckBox
    Left = 254
    Top = 166
    Width = 190
    Height = 31
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1090#1076#1077#1083#1100#1085#1099#1077' '#1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1080
    TabOrder = 6
    WordWrap = True
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text file *.txt|*.txt|Any file *.*|*.*'
    Left = 408
    Top = 160
  end
end
