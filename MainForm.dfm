object TSIForm: TTSIForm
  Left = 0
  Top = 0
  Caption = 'Tiny Server Inventory'
  ClientHeight = 446
  ClientWidth = 673
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    673
    446)
  PixelsPerInch = 96
  TextHeight = 13
  object lblNoServers: TLabel
    Left = 191
    Top = 8
    Width = 437
    Height = 270
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Please add a server to continue. :-)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -75
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object grpDetails: TGroupBox
    Left = 191
    Top = 8
    Width = 474
    Height = 407
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    Visible = False
    StyleElements = [seFont, seClient]
    DesignSize = (
      474
      407)
    object Label1: TLabel
      Left = 10
      Top = 16
      Width = 79
      Height = 13
      Caption = 'Displayed name:'
    end
    object Label2: TLabel
      Left = 10
      Top = 82
      Width = 68
      Height = 13
      Caption = 'IPv4 Address:'
    end
    object Label3: TLabel
      Left = 10
      Top = 112
      Width = 68
      Height = 13
      Caption = 'IPv6 Address:'
    end
    object Label4: TLabel
      Left = 10
      Top = 179
      Width = 49
      Height = 13
      Caption = 'Comment:'
    end
    object Label8: TLabel
      Left = 10
      Top = 253
      Width = 113
      Height = 13
      Caption = 'Services on this server:'
    end
    object Label5: TLabel
      Left = 10
      Top = 144
      Width = 90
      Height = 13
      Caption = 'Operating System:'
    end
    object Label6: TLabel
      Left = 335
      Top = 82
      Width = 107
      Height = 13
      Caption = '(opens a cmd window)'
    end
    object Label7: TLabel
      Left = 335
      Top = 112
      Width = 107
      Height = 13
      Caption = '(opens a cmd window)'
    end
    object Label9: TLabel
      Left = 10
      Top = 48
      Width = 78
      Height = 13
      Caption = 'Primary Domain:'
    end
    object btnSaveChanges: TButton
      Left = 371
      Top = 379
      Width = 101
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'save changes'
      Enabled = False
      TabOrder = 8
      OnClick = btnSaveChangesClick
    end
    object etNickname: TEdit
      Left = 135
      Top = 13
      Width = 330
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = etNicknameChange
    end
    object etIPv6: TEdit
      Left = 135
      Top = 110
      Width = 139
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnChange = etIPv6Change
    end
    object etComment: TRichEdit
      Left = 135
      Top = 176
      Width = 329
      Height = 68
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Zoom = 100
      OnChange = etCommentChange
    end
    object btnAddService: TButton
      Left = 10
      Top = 272
      Width = 113
      Height = 25
      Caption = 'add a service'
      TabOrder = 7
      OnClick = btnAddServiceClick
    end
    object etOS: TEdit
      Left = 135
      Top = 142
      Width = 330
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnChange = etIPv6Change
    end
    object etIPv4: TEdit
      Left = 135
      Top = 80
      Width = 139
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnChange = etIPv4Change
    end
    object btnPingIPv4: TButton
      Left = 280
      Top = 77
      Width = 49
      Height = 25
      Caption = 'Ping'
      Enabled = False
      TabOrder = 9
      OnClick = btnPingIPv4Click
    end
    object btnPingIPv6: TButton
      Left = 280
      Top = 107
      Width = 49
      Height = 25
      Caption = 'Ping'
      Enabled = False
      TabOrder = 10
      OnClick = btnPingIPv6Click
    end
    object vleServices: TStringGrid
      Left = 135
      Top = 253
      Width = 343
      Height = 120
      ColCount = 3
      FixedCols = 0
      RowCount = 2
      Options = [goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
      TabOrder = 6
      ColWidths = (
        64
        64
        64)
      RowHeights = (
        24
        24)
    end
    object etDomain: TEdit
      Left = 135
      Top = 46
      Width = 164
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = etDomainChange
    end
    object btnPingDomain: TButton
      Left = 305
      Top = 42
      Width = 49
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ping'
      Enabled = False
      TabOrder = 11
      OnClick = btnPingDomainClick
    end
    object btnOpenInWeb: TButton
      Left = 360
      Top = 42
      Width = 106
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Open as Website'
      Enabled = False
      TabOrder = 12
      OnClick = btnOpenInWebClick
    end
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 8
    Width = 177
    Height = 373
    Anchors = [akLeft, akTop, akBottom]
    Indent = 19
    TabOrder = 0
    StyleElements = [seFont, seClient]
  end
  object btnAddConn: TButton
    Left = 8
    Top = 387
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'add'
    TabOrder = 1
    OnClick = btnAddConnClick
  end
  object btnRemoveConn: TButton
    Left = 103
    Top = 388
    Width = 82
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'remove'
    Enabled = False
    TabOrder = 2
    OnClick = btnRemoveConnClick
  end
  object btnExit: TButton
    Left = 590
    Top = 421
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'exit'
    TabOrder = 4
    OnClick = btnExitClick
  end
  object btnExportList: TButton
    Left = 8
    Top = 421
    Width = 177
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'export server list as ASCII text'
    TabOrder = 5
    OnClick = btnExportListClick
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 24
    object N1: TMenuItem
      Caption = '?'
      object mnuNANY: TMenuItem
        Caption = 'N.A.N.Y. 2017'
        OnClick = mnuNANYClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuLicense: TMenuItem
        Caption = 'License'
        OnClick = mnuLicenseClick
      end
      object mnuAbout: TMenuItem
        Caption = 'About'
        OnClick = mnuAboutClick
      end
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=.\TinyServerInventory.db'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    Left = 64
    Top = 104
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 16
    Top = 80
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 72
    Top = 32
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 56
    Top = 192
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    Left = 24
    Top = 88
  end
end
