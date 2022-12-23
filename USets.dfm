object SetFm: TSetFm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 294
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 30
    Height = 13
    Caption = #1071#1079#1099#1082':'
  end
  object Button1: TButton
    Left = 172
    Top = 260
    Width = 121
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Ln: TComboBox
    Left = 16
    Top = 24
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 1
    Text = 'English'
    OnChange = LnChange
    Items.Strings = (
      'English'
      'Russian')
  end
  object Smooth: TCheckBox
    Left = 291
    Top = 8
    Width = 129
    Height = 17
    Caption = #1057#1075#1083#1072#1078#1080#1074#1072#1085#1080#1077' '#1083#1080#1085#1080#1081
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 52
    Width = 404
    Height = 120
    Caption = #1062#1074#1077#1090#1086#1074#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 3
    object BackGroundColor: TShape
      Left = 16
      Top = 46
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object LinesColor: TShape
      Left = 16
      Top = 69
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object ObjColor: TShape
      Left = 144
      Top = 23
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object DopObjColor: TShape
      Left = 16
      Top = 92
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object IntColor: TShape
      Left = 274
      Top = 23
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object InfoColor: TShape
      Left = 144
      Top = 46
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object TrackColor: TShape
      Left = 144
      Top = 69
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object RedTrackColor: TShape
      Left = 144
      Top = 92
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object FntColor: TShape
      Left = 274
      Top = 70
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object BackGround: TLabel
      Left = 39
      Top = 48
      Width = 20
      Height = 13
      Cursor = crHandPoint
      Caption = #1060#1086#1085
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Lines: TLabel
      Left = 39
      Top = 70
      Width = 63
      Height = 13
      Cursor = crHandPoint
      Caption = #1051#1080#1085#1080#1080' '#1089#1077#1090#1082#1080
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Obj: TLabel
      Left = 167
      Top = 24
      Width = 54
      Height = 13
      Cursor = crHandPoint
      Caption = #1052#1072#1088#1096#1088#1091#1090#1099
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Track: TLabel
      Left = 168
      Top = 70
      Width = 60
      Height = 13
      Cursor = crHandPoint
      Caption = #1058#1088#1072#1077#1082#1090#1086#1088#1080#1103
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Info: TLabel
      Left = 168
      Top = 48
      Width = 90
      Height = 13
      Cursor = crHandPoint
      Caption = #1050#1091#1088#1089#1086#1088' '#1076#1074#1080#1078#1077#1085#1080#1103
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Int: TLabel
      Left = 298
      Top = 24
      Width = 56
      Height = 13
      Cursor = crHandPoint
      Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object RedTrack: TLabel
      Left = 167
      Top = 93
      Width = 49
      Height = 13
      Cursor = crHandPoint
      Caption = #1056#1077#1076#1091#1082#1094#1080#1080
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Fnt: TLabel
      Left = 299
      Top = 70
      Width = 29
      Height = 13
      Cursor = crHandPoint
      Caption = #1058#1077#1082#1089#1090
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object DopObj: TLabel
      Left = 41
      Top = 93
      Width = 95
      Height = 13
      Cursor = crHandPoint
      Caption = #1054#1073#1098#1077#1082#1090#1099'/'#1084#1072#1088#1082#1077#1088#1099
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object ChoosedColor: TShape
      Left = 274
      Top = 46
      Width = 17
      Height = 17
      Cursor = crArrow
    end
    object Choosed: TLabel
      Left = 298
      Top = 48
      Width = 57
      Height = 13
      Cursor = crHandPoint
      Caption = #1042#1099#1076#1077#1083#1077#1085#1080#1077
      OnClick = DopObjClick
      OnMouseMove = BackGroundMouseMove
      OnMouseLeave = BackGroundMouseLeave
    end
    object Sav: TSpeedButton
      Left = 365
      Top = 85
      Width = 31
      Height = 29
      Glyph.Data = {
        EE000000424DEE0000000000000076000000280000000F0000000F0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D70000000000
        0000D033000000770300D033000000770300D033000000770300D03300000000
        0300D033333333333300D033000000003300D030777777770300D03077777777
        0300D030777777770300D030777777770300D030777777770000D03077777777
        0700D000000000000000DDDDDDDDDDDDDDD0}
      Visible = False
      OnClick = SavClick
    end
    object Cl: TComboBox
      Left = 16
      Top = 17
      Width = 118
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 0
      Text = 'Standard'
      OnChange = ClChange
      Items.Strings = (
        'Standard'
        'Black'
        'White'
        'User')
    end
  end
  object Vsync: TCheckBox
    Left = 291
    Top = 29
    Width = 129
    Height = 17
    Caption = 'VSync'
    TabOrder = 4
  end
  object Button2: TButton
    Left = 299
    Top = 260
    Width = 121
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
    OnClick = Button2Click
  end
  object SimpleN: TCheckBox
    Left = 215
    Top = 193
    Width = 204
    Height = 18
    Caption = #1059#1087#1088#1086#1097#1077#1085#1085#1099#1081' '#1091#1082#1072#1079#1072#1090#1077#1083#1100' '#1085#1072' '#1057#1077#1074#1077#1088
    TabOrder = 6
    WordWrap = True
  end
  object DrMesh: TCheckBox
    Left = 215
    Top = 177
    Width = 129
    Height = 17
    Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1085#1072#1103' '#1089#1077#1090#1082#1072
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object AlwaysN: TCheckBox
    Left = 215
    Top = 211
    Width = 204
    Height = 18
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1057#1077#1074#1077#1088' '#1074#1089#1077#1075#1076#1072
    TabOrder = 8
    WordWrap = True
  end
  object LabelStyle: TRadioGroup
    Left = 16
    Top = 176
    Width = 185
    Height = 67
    Caption = #1057#1090#1080#1083#1100' '#1087#1086#1076#1087#1080#1089#1077#1081
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      #1054#1073#1099#1095#1085#1099#1081
      #1057' '#1090#1077#1085#1100#1102
      #1042' '#1088#1072#1084#1082#1077)
    TabOrder = 9
  end
  object TA: TCheckBox
    Left = 215
    Top = 229
    Width = 205
    Height = 18
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1090#1088#1077#1082#1072
    TabOrder = 10
    WordWrap = True
  end
  object ColorDialog1: TColorDialog
    Left = 232
    Top = 8
  end
end
