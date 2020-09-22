object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'GDI+ 1.0 Demos'
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
    Left = 369
    Top = 0
    Width = 5
    Height = 672
  end
  object TreeViewDemos: TTreeView
    Left = 0
    Top = 0
    Width = 369
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
    Left = 374
    Top = 0
    Width = 655
    Height = 672
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object SplitterRight: TSplitter
      Left = 0
      Top = 235
      Width = 655
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 237
    end
    object Pages: TPageControl
      Left = 0
      Top = 0
      Width = 655
      Height = 235
      ActivePage = TabSheetPrint
      Align = alClient
      TabOrder = 0
      object TabSheetGraphic: TTabSheet
        Caption = 'Graphic'
        object PaintBox: TPaintBox
          Left = 15
          Top = 15
          Width = 632
          Height = 190
          Align = alClient
          OnPaint = PaintBoxPaint
          ExplicitLeft = 188
          ExplicitTop = 148
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
        object PaintBoxTopRuler: TPaintBox
          Left = 0
          Top = 0
          Width = 647
          Height = 15
          Align = alTop
          OnPaint = PaintBoxTopRulerPaint
          ExplicitWidth = 689
        end
        object PaintBoxLeftRuler: TPaintBox
          Left = 0
          Top = 15
          Width = 15
          Height = 190
          Align = alLeft
          OnPaint = PaintBoxLeftRulerPaint
          ExplicitTop = 16
          ExplicitHeight = 628
        end
      end
      object TabSheetText: TTabSheet
        Caption = 'Text'
        ImageIndex = 1
        object Memo: TMemo
          Left = 0
          Top = 0
          Width = 647
          Height = 205
          Align = alClient
          BorderStyle = bsNone
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheetPrint: TTabSheet
        Caption = 'Printer'
        ImageIndex = 2
        object ButtonPrint: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Print'
          TabOrder = 0
          OnClick = ButtonPrintClick
        end
      end
    end
    object RichEdit: TRichEdit
      Left = 0
      Top = 240
      Width = 655
      Height = 432
      Align = alBottom
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object PrintDialog: TPrintDialog
    Left = 424
    Top = 32
  end
end
