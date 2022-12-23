object RouteOps: TRouteOps
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RouteOps'
  ClientHeight = 223
  ClientWidth = 279
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
  object RouteNLabel3: TLabel
    Left = 16
    Top = 9
    Width = 50
    Height = 13
    Caption = #1052#1072#1088#1096#1088#1091#1090':'
  end
  object RouteBox: TComboBox
    Left = 16
    Top = 26
    Width = 249
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
    OnChange = RouteBoxChange
  end
  object OkButton1: TButton
    Left = 13
    Top = 193
    Width = 121
    Height = 25
    Caption = #1054#1050
    TabOrder = 1
    OnClick = OkButton1Click
  end
  object CancelButton1: TButton
    Left = 140
    Top = 193
    Width = 123
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = CancelButton1Click
  end
  object RPC: TPageControl
    Left = 8
    Top = 49
    Width = 263
    Height = 143
    ActivePage = TabSheet1
    Style = tsFlatButtons
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      TabVisible = False
      object Label2: TLabel
        Left = 5
        Top = 4
        Width = 169
        Height = 13
        Caption = #1057#1080#1084#1074#1086#1083' '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1103' ('#1080#1084#1103'-'#1085#1086#1084#1077#1088')'
      end
      object Edit1: TEdit
        Left = 3
        Top = 53
        Width = 99
        Height = 21
        TabOrder = 0
        Text = 'P'
      end
      object CheckBox1: TCheckBox
        Left = 4
        Top = 30
        Width = 137
        Height = 17
        Caption = #1047#1072#1076#1072#1090#1100' '#1080#1084#1103
        TabOrder = 1
      end
      object Edit2: TEdit
        Left = 180
        Top = 1
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '_'
      end
      object CheckBox2: TCheckBox
        Left = 3
        Top = 80
        Width = 171
        Height = 17
        Caption = #1059#1095#1077#1089#1090#1100' '#1089#1076#1074#1080#1075' '#1088#1072#1079#1073#1080#1077#1085#1080#1103' '
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      TabVisible = False
      object Label1: TLabel
        Left = 5
        Top = 1
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = #1064#1072#1075', '#1084':'
      end
      object BrkStep_: TSpinEdit
        Left = 5
        Top = 17
        Width = 112
        Height = 22
        MaxValue = 100000
        MinValue = 1
        TabOrder = 0
        Value = 500
        OnChange = BrkStep_Change
      end
      object DoM: TCheckBox
        Left = 124
        Top = 6
        Width = 128
        Height = 17
        Caption = #1057#1086#1079#1076#1072#1090#1100' '#1084#1072#1088#1082#1077#1088#1099
        TabOrder = 1
        OnClick = DoMClick
      end
      object MNamesBox: TGroupBox
        Left = 5
        Top = 39
        Width = 246
        Height = 94
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1084#1072#1088#1082#1077#1088#1086#1074
        TabOrder = 2
        Visible = False
        object MSepL: TLabel
          Left = 9
          Top = 38
          Width = 70
          Height = 13
          Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100':'
        end
        object MNFromL: TLabel
          Left = 99
          Top = 38
          Width = 49
          Height = 13
          Caption = #1053#1072#1095#1072#1090#1100' '#1089':'
        end
        object MNStepL: TLabel
          Left = 174
          Top = 38
          Width = 25
          Height = 13
          Caption = #1064#1072#1075':'
        end
        object MNames: TComboBox
          Left = 8
          Top = 15
          Width = 234
          Height = 22
          Style = csOwnerDrawFixed
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 0
          Text = #1048#1084#1103' '#1084#1072#1088#1096#1088#1091#1090#1072' + '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' + '#1085#1086#1084#1077#1088
          OnChange = MNamesChange
          Items.Strings = (
            #1048#1084#1103' '#1084#1072#1088#1096#1088#1091#1090#1072' + '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' + '#1085#1086#1084#1077#1088
            #1048#1084#1103' '#1084#1072#1088#1096#1088#1091#1090#1072
            #1053#1086#1084#1077#1088)
        end
        object MSep: TEdit
          Left = 9
          Top = 55
          Width = 47
          Height = 21
          TabOrder = 1
          Text = '_'
        end
        object MNFrom_: TSpinEdit
          Left = 99
          Top = 54
          Width = 67
          Height = 22
          MaxValue = 100000
          MinValue = -100000
          TabOrder = 2
          Value = 0
          OnChange = MNFrom_Change
        end
        object MNStep_: TSpinEdit
          Left = 174
          Top = 54
          Width = 67
          Height = 22
          MaxValue = 100000
          MinValue = -100000
          TabOrder = 3
          Value = 500
          OnChange = MNStep_Change
        end
        object EndM: TCheckBox
          Left = 99
          Top = 75
          Width = 139
          Height = 17
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1085#1077#1095#1085#1099#1081
          TabOrder = 4
        end
      end
      object DelM: TCheckBox
        Left = 124
        Top = 24
        Width = 121
        Height = 17
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1072#1088#1099#1077
        Enabled = False
        TabOrder = 3
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      TabVisible = False
      object Label3: TLabel
        Left = 189
        Top = 6
        Width = 54
        Height = 13
        Caption = #1054#1090#1089#1090#1091#1087', '#1084':'
      end
      object Label5: TLabel
        Left = 5
        Top = 91
        Width = 23
        Height = 13
        Caption = #1048#1084#1103':'
      end
      object Panel1: TPanel
        Left = 113
        Top = 47
        Width = 141
        Height = 80
        BevelOuter = bvNone
        TabOrder = 2
        object Label4: TLabel
          Left = 64
          Top = 42
          Width = 70
          Height = 13
          Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100':'
        end
        object Label6: TLabel
          Left = 76
          Top = 0
          Width = 38
          Height = 13
          Alignment = taRightJustify
          Caption = #1064#1072#1075', '#1084':'
        end
        object Label7: TLabel
          Left = 0
          Top = 42
          Width = 49
          Height = 13
          Caption = #1053#1072#1095#1072#1090#1100' '#1089':'
        end
        object OrtSep: TEdit
          Left = 64
          Top = 57
          Width = 66
          Height = 21
          TabOrder = 0
          Text = '_'
        end
        object OrtStep_: TSpinEdit
          Left = 76
          Top = 15
          Width = 54
          Height = 22
          MaxValue = 500000
          MinValue = 1
          TabOrder = 1
          Value = 500
        end
        object OrtStartN: TSpinEdit
          Left = 0
          Top = 57
          Width = 49
          Height = 22
          MaxValue = 100000
          MinValue = 0
          TabOrder = 2
          Value = 1
        end
      end
      object OrtStep1_: TSpinEdit
        Left = 189
        Top = 21
        Width = 55
        Height = 22
        MaxValue = 100000
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object OrtName: TEdit
        Left = 5
        Top = 104
        Width = 92
        Height = 21
        TabOrder = 1
        Text = 'P'
      end
      object Do1ort: TRadioButton
        Left = 3
        Top = 5
        Width = 158
        Height = 17
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1086#1076#1080#1085' '#1084#1072#1088#1096#1088#1091#1090
        TabOrder = 3
        OnClick = Do1ortClick
      end
      object DoSeveral: TRadioButton
        Left = 3
        Top = 25
        Width = 104
        Height = 17
        Caption = #1056#1072#1079#1073#1080#1090#1100' '#1087#1086' '#1096#1072#1075#1091
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = Do1ortClick
      end
      object Panel2: TPanel
        Left = 3
        Top = 47
        Width = 158
        Height = 37
        BevelOuter = bvNone
        TabOrder = 5
        object Label8: TLabel
          Left = 2
          Top = 0
          Width = 137
          Height = 13
          Caption = #1042#1099#1085#1086#1089#1099' '#1074#1083#1077#1074#1086' '#1080' '#1074#1087#1088#1072#1074#1086', '#1084':'
        end
        object OrtL_: TSpinEdit
          Left = 2
          Top = 15
          Width = 55
          Height = 22
          MaxValue = 500000
          MinValue = 0
          TabOrder = 0
          Value = 100
        end
        object OrtR_: TSpinEdit
          Left = 65
          Top = 15
          Width = 55
          Height = 22
          MaxValue = 500000
          MinValue = 0
          TabOrder = 1
          Value = 100
        end
      end
    end
  end
end
