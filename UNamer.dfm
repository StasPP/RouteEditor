object Namer: TNamer
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1047#1072#1076#1072#1081#1090#1077' '#1080#1084#1103
  ClientHeight = 62
  ClientWidth = 235
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 56
    Top = 35
    Width = 129
    Height = 22
    Caption = 'OK'
    OnClick = SpeedButton1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 219
    Height = 21
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
end
