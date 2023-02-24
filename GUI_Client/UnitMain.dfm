object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Instrument Worklist'
  ClientHeight = 551
  ClientWidth = 883
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 883
    Height = 551
    Align = alClient
    Caption = 'Mapped'
    TabOrder = 0
    object Panel2: TPanel
      Left = 2
      Top = 21
      Width = 879
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label2: TLabel
        Left = 16
        Top = 11
        Width = 32
        Height = 19
        Caption = 'Date'
      end
      object BtnRefresh: TButton
        Left = 172
        Top = 8
        Width = 117
        Height = 27
        Caption = 'Refresh'
        TabOrder = 0
        OnClick = BtnRefreshClick
      end
    end
    object DBGrid2: TDBGrid
      Left = 2
      Top = 62
      Width = 454
      Height = 487
      Cursor = crHandPoint
      Align = alClient
      DataSource = DSMapped
      Options = [dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = DBGrid2CellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'host_sample_id'
          Title.Caption = 'Seq'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'sample_id'
          Title.Caption = 'SampleID'
          Width = 124
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'audit_date'
          Title.Caption = 'Date Time'
          Width = 171
          Visible = True
        end>
    end
    object dtpTgl: TDateTimePicker
      Left = 56
      Top = 29
      Width = 112
      Height = 27
      Date = 42820.895811527780000000
      Time = 42820.895811527780000000
      TabOrder = 2
      OnChange = dtpTglChange
    end
    object pnlDtl: TPanel
      Left = 456
      Top = 62
      Width = 425
      Height = 487
      Align = alRight
      TabOrder = 3
      object DBGrid1: TDBGrid
        Left = 1
        Top = 49
        Width = 423
        Height = 396
        Align = alClient
        DataSource = DataSource1
        Options = [dgTitles, dgColumnResize, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -16
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object Panel1: TPanel
        Left = 1
        Top = 445
        Width = 423
        Height = 41
        Align = alBottom
        TabOrder = 1
        object btnEdit: TButton
          Left = 5
          Top = 6
          Width = 148
          Height = 27
          Caption = 'Edit Sample ID'
          TabOrder = 0
          OnClick = btnEditClick
        end
        object btnKirim: TButton
          Left = 168
          Top = 6
          Width = 129
          Height = 27
          Caption = 'Kirim ke HOST'
          TabOrder = 1
          OnClick = btnKirimClick
        end
      end
      object lblSID: TPanel
        Left = 1
        Top = 1
        Width = 423
        Height = 48
        Align = alTop
        TabOrder = 2
        object DBText1: TDBText
          Left = -3
          Top = 17
          Width = 299
          Height = 24
          Alignment = taCenter
          DataField = 'sample_id'
          DataSource = DSMapped
        end
      end
    end
  end
  object ADOMySQL: TADOConnection
    Connected = True
    ConnectionString = 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=LIS;'
    LoginPrompt = False
    Left = 224
    Top = 64
  end
  object ADODSWorklist: TADODataSet
    Connection = ADOMySQL
    CursorType = ctStatic
    CommandText = 'select sampleid from worklist order by id'
    Parameters = <>
    Left = 224
    Top = 112
  end
  object DSWorklist: TDataSource
    DataSet = ADODSWorklist
    Left = 224
    Top = 160
  end
  object ADODSMapped: TADODataSet
    Connection = ADOMySQL
    CursorType = ctStatic
    CommandText = 
      'select distinct sample_id,host_sample_id,audit_date'#13#10'from'#13#10'instr' +
      'ument_result'#13#10'limit 10'
    Parameters = <>
    Left = 224
    Top = 208
  end
  object DSMapped: TDataSource
    DataSet = ADODSMapped
    Left = 224
    Top = 256
  end
  object ADOCmd: TADOCommand
    Connection = ADOMySQL
    Parameters = <>
    Left = 224
    Top = 304
  end
  object ADOQCek: TADOQuery
    Connection = ADOMySQL
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select id from worklist'
      'limit 1')
    Left = 160
    Top = 368
  end
  object qDtl: TADOQuery
    Connection = ADOMySQL
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT analyt_code,result_value'
      'FROM'
      'instrument_result'
      'WHERE'
      'host_sample_id = '#39'253'#39
      'ORDER BY id desc')
    Left = 480
    Top = 24
  end
  object DataSource1: TDataSource
    DataSet = qDtl
    Left = 538
    Top = 29
  end
  object cmdUpdate: TADOCommand
    Connection = ADOMySQL
    Parameters = <>
    Left = 769
    Top = 467
  end
end
