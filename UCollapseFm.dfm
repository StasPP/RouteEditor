object CollapseFm: TCollapseFm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CollapseFm'
  ClientHeight = 386
  ClientWidth = 494
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel
    Left = 0
    Top = 269
    Width = 494
    Height = 117
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 8
      Top = 31
      Width = 214
      Height = 82
      TabOrder = 3
      object imiLabel1: TLabel
        Left = 16
        Top = 11
        Width = 80
        Height = 13
        Caption = #1052#1080#1085'. '#1088#1072#1076#1080#1091#1089', '#1084':'
      end
      object imiLabel3: TLabel
        Left = 118
        Top = 12
        Width = 86
        Height = 13
        Caption = #1056#1072#1079#1073#1080#1074#1082#1072' '#1076#1091#1075#1080', '#176
      end
      object imiStep: TSpinEdit
        Left = 118
        Top = 27
        Width = 58
        Height = 22
        MaxValue = 359
        MinValue = 1
        TabOrder = 0
        Value = 30
      end
      object ImiRad: TSpinEdit
        Left = 16
        Top = 26
        Width = 70
        Height = 22
        Increment = 50
        MaxValue = 100000
        MinValue = 5
        TabOrder = 1
        Value = 500
      end
      object NewH: TSpinEdit
        Left = 128
        Top = 55
        Width = 60
        Height = 22
        Increment = 50
        MaxValue = 100000
        MinValue = 0
        TabOrder = 2
        Value = 50
      end
      object AddH: TCheckBox
        Left = 12
        Top = 57
        Width = 110
        Height = 17
        Caption = #1042#1099#1089#1086#1090#1072' '#1079#1072#1093#1086#1076#1072', '#1084':'
        TabOrder = 3
      end
    end
    object ButtonsPanel: TPanel
      Left = 226
      Top = 0
      Width = 268
      Height = 117
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object OkButton: TButton
        Left = 8
        Top = 79
        Width = 137
        Height = 30
        Caption = #1054#1073#1098#1077#1076#1080#1085#1080#1090#1100' '#1084#1072#1088#1096#1088#1091#1090
        Enabled = False
        TabOrder = 0
        OnClick = OkButtonClick
      end
      object CancelButton: TButton
        Left = 151
        Top = 79
        Width = 113
        Height = 30
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 1
        OnClick = CancelButtonClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 11
        Width = 252
        Height = 61
        Caption = #1055#1086#1088#1103#1076#1086#1082' '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1080#1103
        TabOrder = 2
        object Label2: TLabel
          Left = 180
          Top = 16
          Width = 25
          Height = 13
          Caption = #1064#1072#1075':'
        end
        object NoLoop: TRadioButton
          Left = 10
          Top = 17
          Width = 113
          Height = 17
          Caption = #1055#1086' '#1087#1086#1088#1103#1076#1082#1091
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object DoLoop: TRadioButton
          Left = 10
          Top = 37
          Width = 113
          Height = 17
          Caption = #1055#1077#1090#1083#1103#1084#1080
          TabOrder = 1
        end
        object RtStep: TSpinEdit
          Left = 180
          Top = 32
          Width = 58
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 2
          Value = 1
        end
      end
    end
    object DoRad: TCheckBox
      Left = 15
      Top = 23
      Width = 175
      Height = 17
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1093#1086#1076' '#1085#1072' '#1084#1072#1088#1096#1088#1091#1090
      TabOrder = 1
    end
    object DelOld: TCheckBox
      Left = 15
      Top = 3
      Width = 201
      Height = 17
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1089#1093#1086#1076#1085#1099#1077' '#1084#1072#1088#1096#1088#1091#1090#1099
      TabOrder = 2
    end
  end
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 494
    Height = 269
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter: TSplitter
      Left = 257
      Top = 0
      Width = 8
      Height = 269
      ExplicitLeft = 281
      ExplicitTop = -6
      ExplicitHeight = 288
    end
    object RPanel: TPanel
      Left = 265
      Top = 0
      Width = 229
      Height = 269
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object RoutesMerge: TListBox
        Left = 0
        Top = 33
        Width = 181
        Height = 236
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
        OnClick = RoutesMergeClick
        OnMouseMove = RoutesMergeMouseMove
      end
      object RButtonsPanel: TPanel
        Left = 181
        Top = 33
        Width = 48
        Height = 236
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object UpBtn: TSpeedButton
          Left = 7
          Top = 30
          Width = 33
          Height = 25
          Hint = #1042#1099#1096#1077
          Enabled = False
          Flat = True
          Glyph.Data = {
            72010000424D7201000000000000760000002800000016000000150000000100
            040000000000FC00000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFF00FFFFFFFF0000000FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFF
            FFFF0EEE660FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFF0EEE660FFFFF
            FF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFF0EEE660FFFFFFF00FFFFFFFF0EE6
            660FFFFFFF00FFFFFFFF0EEE660FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFF0
            00000EEE66000000FF00FFFF0EEEEEE66666660FFF00FFFFF0EEEEEE666660FF
            FF00FFFFFF0EEEE666660FFFFF00FFFFFFF0EEEE6660FFFFFF00FFFFFFFF0EE6
            660FFFFFFF00FFFFFFFFF0EE60FFFFFFFF00FFFFFFFFFF060FFFFFFFFF00FFFF
            FFFFFFF0FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = UpBtnClick
        end
        object DelBtn: TSpeedButton
          Left = 7
          Top = 136
          Width = 33
          Height = 33
          Hint = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          Flat = True
          Glyph.Data = {
            72010000424D7201000000000000760000002800000016000000150000000100
            040000000000FC00000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFF00FFFFFF0FFFFFFFFF0FFFFF00FFFFF010FFFFFFF010FFFF00FFFF
            01110FFFFF01110FFF00FFF0911110FFF0111190FF00FF099911110F01111999
            0F00FFF09991111011119990FF00FFFF099911111119990FFF00FFFFF0999111
            119990FFFF00FFFFFF09991119990FFFFF00FFFFFFF099911110FFFFFF00FFFF
            FF09999911110FFFFF00FFFFF0999999911110FFFF00FFFF099999999911110F
            FF00FFF09999999099911110FF00FF099999990F099911110F00FFF0999990FF
            F0999110FF00FFFF09990FFFFF09990FFF00FFFFF090FFFFFFF090FFFF00FFFF
            FF0FFFFFFFFF0FFFFF00FFFFFFFFFFFFFFFFFFFFFF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = DelBtnClick
        end
        object UpBtn2: TSpeedButton
          Left = 7
          Top = 0
          Width = 33
          Height = 25
          Hint = #1042' '#1085#1072#1095#1072#1083#1086
          Enabled = False
          Flat = True
          Glyph.Data = {
            72010000424D7201000000000000760000002800000016000000150000000100
            040000000000FC00000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFF00FFFFFFFF0000000FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFF
            FFFF0EEE660FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFF0EEE660FFFFF
            FF00FFFFFFFF0EE6660FFFFFFF00FFF000000EEE66000000FF00FFFF0EEEEEE6
            6666660FFF00FFFFF0EEEEEE666660FFFF00FFFFFF0EEEE666660FFFFF00FFFF
            FFF0EEEE6660FFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFFF0EE60FFFFFF
            FF00FFFFFFFFFF060FFFFFFFFF00FFFFFFFFFFF0FFFFFFFFFF00F00000000000
            000000000000F06666666666666666666000F0EEEEEEEEEEEEEEEEEEE000F000
            00000000000000000000FFFFFFFFFFFFFFFFFFFFFF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = UpBtn2Click
        end
        object DownBtn2: TSpeedButton
          Left = 7
          Top = 95
          Width = 33
          Height = 25
          Hint = #1042' '#1082#1086#1085#1077#1094
          Enabled = False
          Flat = True
          Glyph.Data = {
            72010000424D7201000000000000760000002800000016000000150000000100
            040000000000FC00000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFF00F00000000000000000000000F06666666666666666666000F0EE
            EEEEEEEEEEEEEEEEE000F00000000000000000000000FFFFFFFFFFF0FFFFFFFF
            FF00FFFFFFFFFF060FFFFFFFFF00FFFFFFFFF0EE60FFFFFFFF00FFFFFFFF0EE6
            660FFFFFFF00FFFFFFF0EEEE6660FFFFFF00FFFFFF0EEEE666660FFFFF00FFFF
            F0EEEEEE666660FFFF00FFFF0EEEEEE66666660FFF00FFF000000EEE66000000
            FF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFF0EEE660FFFFFFF00FFFFFFFF0EE6
            660FFFFFFF00FFFFFFFF0EEE660FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFF
            FFFF0000000FFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = DownBtn2Click
        end
        object DownBtn: TSpeedButton
          Left = 7
          Top = 65
          Width = 33
          Height = 25
          Hint = #1053#1080#1078#1077
          Enabled = False
          Flat = True
          Glyph.Data = {
            72010000424D7201000000000000760000002800000016000000150000000100
            040000000000FC00000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFF00FFFFFFFFFFF0FFFFFFFFFF00FFFFFFFFFF060FFFFFFFFF00FFFF
            FFFFF0EE60FFFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFFFFF0EEEE6660FFFF
            FF00FFFFFF0EEEE666660FFFFF00FFFFF0EEEEEE666660FFFF00FFFF0EEEEEE6
            6666660FFF00FFF000000EEE66000000FF00FFFFFFFF0EE6660FFFFFFF00FFFF
            FFFF0EEE660FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFF0EEE660FFFFF
            FF00FFFFFFFF0EE6660FFFFFFF00FFFFFFFF0EEE660FFFFFFF00FFFFFFFF0EE6
            660FFFFFFF00FFFFFFFF0EEE660FFFFFFF00FFFFFFFF0EE6660FFFFFFF00FFFF
            FFFF0000000FFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = DownBtnClick
        end
        object DelAllBtn: TSpeedButton
          Left = 7
          Top = 174
          Width = 33
          Height = 33
          Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077
          Enabled = False
          Flat = True
          Glyph.Data = {
            72010000424D7201000000000000760000002800000016000000150000000100
            040000000000FC00000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF0FFFF
            FFFFF0FFFF00FFFFFF010FFFFFFF010FFF00FFFF0F1110FFFF0F1110FF00FFF0
            10F1110FF010F1190F00FF01110F111F01110F999000F0911110F1F0111190F9
            0F00099911110F011119990FFF00F09991111011119990FFFF00FF0999111111
            19990FFFFF00FFF0999111119990FFFFFF00FFFF09991119990F10FFFF00FFFF
            F099911110F1110FFF00FFFF09999911110F1110FF00FFF0999999911110F111
            0F00FF099999999911110F111000F09999999099911110F10F00099999990F09
            9911110FFF00F0999990FFF0999110FFFF00FF09990FFFFF09990FFFFF00FFF0
            90FFFFFFF090FFFFFF00FFFF0FFFFFFFFF0FFFFFFF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = DelAllBtnClick
        end
      end
      object RTitlePanel: TPanel
        Left = 0
        Top = 0
        Width = 229
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object RTitle: TLabel
          Left = 0
          Top = 0
          Width = 229
          Height = 33
          Align = alClient
          Alignment = taCenter
          Caption = #1054#1073#1098#1077#1076#1080#1085#1103#1077#1084#1099#1077' '#1084#1072#1088#1096#1088#1091#1090#1099':'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 137
          ExplicitHeight = 13
        end
      end
    end
    object LPanel: TPanel
      Left = 0
      Top = 0
      Width = 257
      Height = 269
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object AllRTS: TListBox
        Left = 15
        Top = 33
        Width = 201
        Height = 236
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
        OnClick = AllRTSClick
        OnMouseMove = AllRTSMouseMove
      end
      object LButtonsPanel: TPanel
        Left = 216
        Top = 33
        Width = 41
        Height = 236
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object SendBtn: TSpeedButton
          Left = 8
          Top = 71
          Width = 33
          Height = 44
          Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1084#1072#1088#1096#1088#1091#1090#1091
          Enabled = False
          Flat = True
          Glyph.Data = {
            7E010000424D7E01000000000000760000002800000015000000160000000100
            0400000000000801000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFF0F
            FFFFFFFFF000FFFFFFFFFF00FFFFFFFFF000FFFFFFFFFF040FFFFFFFF000FFFF
            FFFFFF0440FFFFFFF000FFFFFFFFFF04440FFFFFF0000000000000044440FFFF
            F00004444444444444440FFFF000044444444444444440FFF000044444444444
            4444440FF00004444444444444444440F00004C4C4C4C4C4C4C4C4C400000CCC
            CCCCCCCCCCCCCCC0F0000CCCCCCCCCCCCCCCCC0FF0000CCCCCCCCCCCCCCCC0FF
            F0000CCCCCCCCCCCCCCC0FFFF00000000000000CCCC0FFFFF000FFFFFFFFFF0C
            CC0FFFFFF000FFFFFFFFFF0CC0FFFFFFF000FFFFFFFFFF0C0FFFFFFFF000FFFF
            FFFFFF00FFFFFFFFF000FFFFFFFFFF0FFFFFFFFFF000FFFFFFFFFFFFFFFFFFFF
            F000}
          ParentShowHint = False
          ShowHint = True
          OnClick = SendBtnClick
        end
        object SendAllBtn: TSpeedButton
          Left = 8
          Top = 123
          Width = 33
          Height = 44
          Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1084#1072#1088#1096#1088#1091#1090#1091' '#1074#1089#1077' '#1084#1072#1088#1082#1077#1088#1099
          Enabled = False
          Flat = True
          Glyph.Data = {
            7E010000424D7E01000000000000760000002800000016000000160000000100
            0400000000000801000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFF0FFFF0
            FFFFFFFFFF00FFFFFF00FFF00FFFFFFFFF00FFFFFF040FF040FFFFFFFF00FFFF
            FF0440F0440FFFFFFF00FFFFFF04440F0440FFFFFF00000000044440F0440FFF
            FF000444444444440F0440FFFF0004444444444440F0440FFF00044444444444
            440F0440FF000444444444444440F0440F0004C4C4C4C4C4C4C40F0C40000CCC
            CCCCCCCCCCC0F0CC0F000CCCCCCCCCCCCC0F0CC0FF000CCCCCCCCCCCC0F0CC0F
            FF000CCCCCCCCCCC0F0CC0FFFF000000000CCCC0F0CC0FFFFF00FFFFFF0CCC0F
            0CC0FFFFFF00FFFFFF0CC0F0CC0FFFFFFF00FFFFFF0C0FF0C0FFFFFFFF00FFFF
            FF00FFF00FFFFFFFFF00FFFFFF0FFFF0FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
            FF00}
          ParentShowHint = False
          ShowHint = True
          OnClick = SendAllBtnClick
        end
      end
      object LTitlePanel: TPanel
        Left = 0
        Top = 0
        Width = 257
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object LTitle: TLabel
          Left = 0
          Top = 0
          Width = 257
          Height = 33
          Align = alClient
          Alignment = taCenter
          Caption = #1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1084#1072#1088#1096#1088#1091#1090#1099':'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 116
          ExplicitHeight = 13
        end
      end
      object SpacerPanel: TPanel
        Left = 0
        Top = 33
        Width = 15
        Height = 236
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 3
      end
    end
  end
end
