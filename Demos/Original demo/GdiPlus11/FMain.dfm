object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'GDI+ 1.1 Demos'
  ClientHeight = 672
  ClientWidth = 1029
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter: TSplitter
    Left = 329
    Top = 0
    Width = 5
    Height = 672
  end
  object TreeViewDemos: TTreeView
    Left = 0
    Top = 0
    Width = 329
    Height = 672
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    HideSelection = False
    Indent = 19
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeViewDemosChange
  end
  object PanelClient: TPanel
    Left = 334
    Top = 0
    Width = 695
    Height = 672
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object SplitterRight: TSplitter
      Left = 0
      Top = 243
      Width = 695
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 245
    end
    object RichEdit: TRichEdit
      Left = 0
      Top = 248
      Width = 695
      Height = 424
      Align = alBottom
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object PanelGraphic: TPanel
      Left = 0
      Top = 0
      Width = 695
      Height = 243
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object PaintBoxTopRuler: TPaintBox
        Left = 0
        Top = 0
        Width = 695
        Height = 15
        Align = alTop
        OnPaint = PaintBoxTopRulerPaint
        ExplicitWidth = 689
      end
      object PaintBoxLeftRuler: TPaintBox
        Left = 0
        Top = 15
        Width = 15
        Height = 228
        Align = alLeft
        OnPaint = PaintBoxLeftRulerPaint
        ExplicitTop = 16
        ExplicitHeight = 628
      end
      object PaintBox: TPaintBox
        Left = 15
        Top = 15
        Width = 680
        Height = 228
        Align = alClient
        OnPaint = PaintBoxPaint
        ExplicitLeft = 188
        ExplicitTop = 148
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
end
