object frmEditSID: TfrmEditSID
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmEditSID'
  ClientHeight = 115
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 44
    Width = 74
    Height = 19
    Caption = 'Sample ID'
  end
  object lblSEQ: TLabel
    Left = 8
    Top = 8
    Width = 52
    Height = 19
    Caption = 'lblSEQ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 221
    Top = 74
    Width = 129
    Height = 33
    Caption = 'Simpan'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object edSID: TEdit
    Left = 104
    Top = 41
    Width = 233
    Height = 27
    CharCase = ecUpperCase
    TabOrder = 1
  end
  object cmdUpdate: TADOCommand
    Connection = FormMain.ADOMySQL
    Parameters = <>
    Left = 88
    Top = 72
  end
end
