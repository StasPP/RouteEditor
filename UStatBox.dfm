object StatBox: TStatBox
  Left = 0
  Top = 0
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1095#1077#1089#1082#1080#1081' '#1086#1090#1095#1077#1090
  ClientHeight = 373
  ClientWidth = 670
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 680
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
  object WebC: TWebBrowser
    Left = 0
    Top = 89
    Width = 670
    Height = 243
    Align = alClient
    TabOrder = 3
    ExplicitLeft = 60
    ExplicitTop = 113
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C0000003F4500001D1900000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object iReport: TRichEdit
    Left = 0
    Top = 89
    Width = 670
    Height = 243
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    Visible = False
    WordWrap = False
    OnKeyDown = iReportKeyDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 332
    Width = 670
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 467
      Top = 0
      Width = 203
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button1: TButton
        Left = 24
        Top = 8
        Width = 83
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 113
        Top = 8
        Width = 80
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        TabOrder = 1
        OnClick = Button2Click
      end
    end
    object iTables: TCheckBox
      Left = 112
      Top = 11
      Width = 137
      Height = 21
      Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1087#1086#1083#1103' '#1090#1072#1073#1083#1080#1094
      Checked = True
      State = cbChecked
      TabOrder = 1
      Visible = False
      WordWrap = True
      OnClick = iAreaClick
    end
    object Csys: TStaticText
      Left = 256
      Top = 12
      Width = 224
      Height = 17
      Cursor = crHandPoint
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1080#1089#1090#1077#1084#1091' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      Color = clWindow
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Visible = False
      OnClick = CsysClick
      OnMouseMove = CsysMouseMove
    end
    object iFull: TCheckBox
      Left = 7
      Top = 4
      Width = 98
      Height = 35
      Caption = #1055#1086#1083#1085#1099#1077' '#1080#1084#1077#1085#1072
      Checked = True
      State = cbChecked
      TabOrder = 3
      WordWrap = True
      OnClick = iAreaClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 7
      Top = 3
      Width = 153
      Height = 81
      Caption = #1054#1073#1097#1080#1077
      TabOrder = 0
      object iArea: TCheckBox
        Left = 9
        Top = 18
        Width = 97
        Height = 17
        Caption = #1059#1095#1072#1089#1090#1086#1082' '#1088#1072#1073#1086#1090
        TabOrder = 0
        OnClick = iAreaClick
      end
      object iRoutes: TCheckBox
        Left = 9
        Top = 38
        Width = 142
        Height = 17
        Caption = #1052#1072#1088#1096#1088#1091#1090#1099' ('#1087#1088#1086#1092#1080#1083#1080')'
        TabOrder = 1
        OnClick = iAreaClick
      end
      object iRoutesL: TCheckBox
        Left = 9
        Top = 58
        Width = 142
        Height = 17
        Caption = #1044#1083#1080#1085#1099' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
        Enabled = False
        TabOrder = 2
        OnClick = iAreaClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 166
      Top = 3
      Width = 274
      Height = 81
      Caption = #1058#1088#1072#1077#1082#1090#1086#1088#1080#1103
      TabOrder = 1
      object CompareTrk: TSpeedButton
        Left = 156
        Top = 56
        Width = 19
        Height = 19
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF373737FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF121212060606FF00FFFF00FFFF00FFFF00FFFF00FF
          0808080404040404040404040404040404040404040404040404040303030000
          00000000070707FF00FFFF00FFFF00FF02020324242C6E6E6E6767686E6E6E6C
          6C6D6464656E6E6E6A6A6A0808080202021F1F1F8C8C8DFF00FFFF00FFFF00FF
          030306161662D5D5F5DFDFE1F4D9D8FE7C76F3837EFBA19CCD8A883309068472
          72DFDFE0EEEEEEFF00FFFF00FFFF00FF0505050101623E3EFCE1E1E3FB4943FF
          110FFF0F0CFF0703FF0703FF0703FF0703F9241FF1DCDCFF00FFFF00FFFF00FF
          0505052222620000FFB63E7DFF0504FC9E9A7A7AEF1701E99366BFFDB8B5FFA2
          9DED9591EEEEEEFF00FFFF00FFFF00FF050505626262A368C2FF0603EE707C94
          94FE0000FF2020FF1C1CFAEFEFFDFFFFFFE7E7E7EEEEEEFF00FFFF00FFFF00FF
          050505594544FA211ED70829241CF10000FF5F5FF5C1C1EE0000FF6C6CF1E7E7
          E8DBDBDCEEEEEEFF00FFFF00FFFF00FF050505620604FF2320CBADCF1414FF2E
          2EFEDEDEEDFFFFFF7B7BFB0000FFD3D3FFE7E7E7EEEEEEFF00FFFF00FFFF00FF
          060505620301FFA5A1E7E7E8C1C1FFEAEAFDEAEAEBFFFFFFE1E1EC2222FE2626
          FFE2E2E7EEEEEEFF00FFFF00FF646464050505361F1E575758C9C9CBE7E7E8E5
          E5E7DCDCDEE7E7E8DCDCDEB1B1EA0000FF7474EAEEEEEEFF00FF292929060606
          010101020202292929E0E0E2FFFFFFFCFCFDEAEAEBFFFFFFEAEAEBFCFCFD7373
          FF0000FFD6D6F2FF00FFFF00FF797979000000040404C3C3C3E4E4E6F7F7F7F5
          F5F5E5E5E6F7F7F7E5E5E6F5F5F5E4E4F73636F9A4A4F9FF00FFFF00FFFF00FF
          060606484848DEDEDFDEDEDFDEDEDFDFDFDFDFDFE0DEDEDFDFDFE0DFDFDFDEDE
          DFDEDEDFF8F8F8FF00FFFF00FFFF00FF888888FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        Visible = False
        OnClick = CompareTrkClick
      end
      object Estim: TSpeedButton
        Left = 250
        Top = 16
        Width = 19
        Height = 19
        Hint = #1059#1090#1080#1083#1080#1090#1072' '#1086#1094#1077#1085#1082#1080' '#1082#1072#1095#1077#1089#1090#1074#1072
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
          0000008888888888880008FFFFFFF4FFFF800878FFFFF4FFFF8008FFFFFFF4FF
          FF800878FFF44CCCFF8008FFFFFF4CCFFF800878FFFFF4FFFF8008FFFF1FFFFF
          878008FFF199FFFFFF8008FF11999FFF878008FFFF1FFFFFFF8008FFFF1FFFFF
          878008FFFF1FFFFFFF8000888888888888000000000000000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = EstimClick
      end
      object iSlips: TCheckBox
        Left = 9
        Top = 38
        Width = 185
        Height = 17
        Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1089#1088#1099#1074#1086#1074' '#1085#1072#1073#1083#1102#1076#1077#1085#1080#1081
        TabOrder = 0
        OnClick = iAreaClick
      end
      object iTrack: TCheckBox
        Left = 9
        Top = 18
        Width = 81
        Height = 17
        Caption = #1057#1091#1084#1084#1072#1088#1085#1086
        TabOrder = 1
        OnClick = iAreaClick
      end
      object iCompare: TCheckBox
        Left = 9
        Top = 58
        Width = 145
        Height = 17
        Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1076#1074#1091#1093' '#1090#1088#1077#1082#1086#1074
        TabOrder = 2
        OnClick = iAreaClick
      end
      object iTrackRoutes: TCheckBox
        Left = 92
        Top = 18
        Width = 157
        Height = 17
        Caption = #1042#1099#1076#1077#1088#1078#1080#1074#1072#1085#1080#1077' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
        TabOrder = 3
        OnClick = iAreaClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 446
      Top = 3
      Width = 217
      Height = 81
      Caption = #1055#1077#1090#1083#1080' '#1047#1057#1041
      TabOrder = 2
      object iLoopsM: TRadioButton
        Left = 140
        Top = 18
        Width = 76
        Height = 17
        Caption = #1052#1072#1088#1082#1077#1088#1099
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = iAreaClick
      end
      object iCompUDF: TCheckBox
        Left = 11
        Top = 58
        Width = 123
        Height = 17
        Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' c UDF'
        Enabled = False
        TabOrder = 1
        OnClick = iAreaClick
      end
      object iLC: TCheckBox
        Left = 11
        Top = 38
        Width = 65
        Height = 17
        Caption = #1062#1077#1085#1090#1088#1099
        TabOrder = 2
        OnClick = iAreaClick
      end
      object iLK: TCheckBox
        Left = 82
        Top = 38
        Width = 61
        Height = 17
        Caption = #1059#1075#1083#1099
        TabOrder = 3
        OnClick = iAreaClick
      end
      object iLP: TCheckBox
        Left = 140
        Top = 38
        Width = 76
        Height = 17
        Caption = #1055#1080#1082#1077#1090#1099
        TabOrder = 4
        OnClick = iAreaClick
      end
      object iAccuracy: TCheckBox
        Left = 140
        Top = 58
        Width = 72
        Height = 17
        Caption = #1058#1086#1095#1085#1086#1089#1090#1100
        TabOrder = 5
        Visible = False
        OnClick = iAreaClick
      end
      object iLoopsP: TRadioButton
        Left = 10
        Top = 18
        Width = 119
        Height = 17
        Caption = #1055#1088#1086#1077#1082#1090#1085#1099#1077' '#1087#1077#1090#1083#1080
        TabOrder = 6
        OnClick = iAreaClick
      end
    end
  end
  object Memo: TMemo
    Left = 477
    Top = 95
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo')
    TabOrder = 4
    Visible = False
  end
  object SaveDialog1: TSaveDialog
    Filter = 'HTML page *.html|*.html|Text file *.txt|*.txt'
    OnTypeChange = SaveDialog1TypeChange
    Left = 440
    Top = 280
  end
end
