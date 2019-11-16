object AddServerForm: TAddServerForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add A New Server'
  ClientHeight = 343
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    344
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 15
    Width = 79
    Height = 13
    Caption = 'Displayed name:'
  end
  object Label2: TLabel
    Left = 7
    Top = 80
    Width = 68
    Height = 13
    Caption = 'IPv4 Address:'
  end
  object Label3: TLabel
    Left = 283
    Top = 79
    Width = 46
    Height = 13
    Caption = '(optional)'
  end
  object Label4: TLabel
    Left = 8
    Top = 112
    Width = 68
    Height = 13
    Caption = 'IPv6 Address:'
  end
  object Label5: TLabel
    Left = 283
    Top = 111
    Width = 46
    Height = 13
    Caption = '(optional)'
  end
  object Label6: TLabel
    Left = 8
    Top = 144
    Width = 90
    Height = 13
    Caption = 'Operating System:'
  end
  object Label7: TLabel
    Left = 283
    Top = 144
    Width = 46
    Height = 13
    Caption = '(optional)'
  end
  object Label8: TLabel
    Left = 8
    Top = 176
    Width = 49
    Height = 13
    Caption = 'Comment:'
  end
  object Label9: TLabel
    Left = 8
    Top = 48
    Width = 78
    Height = 13
    Caption = 'Primary Domain:'
  end
  object Label10: TLabel
    Left = 283
    Top = 47
    Width = 46
    Height = 13
    Caption = '(optional)'
  end
  object btnAddServer: TButton
    Left = 247
    Top = 310
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Add this server'
    Enabled = False
    TabOrder = 6
    OnClick = btnAddServerClick
  end
  object etNickname: TEdit
    Left = 109
    Top = 12
    Width = 212
    Height = 21
    Margins.Left = 8
    HideSelection = False
    TabOrder = 0
    TextHint = 'Enter an unique name for this server.'
    OnChange = etNicknameChange
  end
  object etIPv6: TEdit
    Left = 109
    Top = 109
    Width = 124
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
    TextHint = 'Enter IPv6 here.'
  end
  object etOS: TEdit
    Left = 109
    Top = 141
    Width = 164
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TextHint = 'This server'#39's operating system.'
  end
  object etComment: TRichEdit
    Left = 109
    Top = 173
    Width = 220
    Height = 124
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ScrollBars = ssBoth
    ShowHint = True
    TabOrder = 5
    Zoom = 100
  end
  object etIPv4: TEdit
    Left = 109
    Top = 77
    Width = 124
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TextHint = 'Enter IPv4 here.'
  end
  object etDomain: TEdit
    Left = 109
    Top = 44
    Width = 164
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextHint = 'This server'#39's primary domain.'
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 44
    Top = 192
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 68
    Top = 248
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=.\TinyServerInventory.db'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    Left = 12
    Top = 256
  end
end
