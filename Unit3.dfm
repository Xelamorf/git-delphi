object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit Client'
  ClientHeight = 199
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 158
    Width = 488
    Height = 41
    Align = alBottom
    BevelInner = bvSpace
    BevelKind = bkSoft
    TabOrder = 0
    DesignSize = (
      484
      37)
    object BitBtn1: TBitBtn
      Left = 393
      Top = 4
      Width = 75
      Height = 25
      Cursor = crNo
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      DoubleBuffered = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      ModalResult = 2
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 312
      Top = 4
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      DoubleBuffered = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 1
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 488
    Height = 158
    Align = alClient
    BevelInner = bvLowered
    BevelKind = bkFlat
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 51
      Height = 13
      Caption = 'First Name'
    end
    object Label2: TLabel
      Left = 16
      Top = 48
      Width = 50
      Height = 13
      Caption = 'Last Name'
    end
    object Label3: TLabel
      Left = 16
      Top = 94
      Width = 62
      Height = 13
      Caption = 'SecondName'
    end
    object Label4: TLabel
      Left = 369
      Top = 48
      Width = 41
      Height = 13
      Caption = 'BirnDate'
    end
    object Edit1: TEdit
      Left = 16
      Top = 27
      Width = 337
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 16
      Top = 67
      Width = 337
      Height = 21
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 16
      Top = 115
      Width = 337
      Height = 21
      TabOrder = 2
    end
    object DateTimePicker1: TDateTimePicker
      Left = 369
      Top = 67
      Width = 96
      Height = 21
      Date = 42213.320251550920000000
      Time = 42213.320251550920000000
      TabOrder = 3
    end
    object UpDown1: TUpDown
      Left = 401
      Top = 27
      Width = 16
      Height = 21
      Associate = LabeledEdit1
      TabOrder = 4
    end
    object LabeledEdit1: TLabeledEdit
      Left = 369
      Top = 27
      Width = 32
      Height = 21
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = 'Status'
      TabOrder = 5
      Text = '0'
    end
    object LabeledEdit2: TLabeledEdit
      Left = 423
      Top = 27
      Width = 42
      Height = 21
      Color = clInactiveCaption
      EditLabel.Width = 41
      EditLabel.Height = 13
      EditLabel.Caption = 'ID Client'
      ReadOnly = True
      TabOrder = 6
    end
  end
end
