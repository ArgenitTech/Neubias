object FormMerge: TFormMerge
  Left = 0
  Top = 0
  Caption = 'CEM 3D Miyelin Merge Marking'
  ClientHeight = 722
  ClientWidth = 1484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 335
    Top = 3
    Width = 931
    Height = 697
    Align = alClient
    TabOrder = 0
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 929
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object AdvPanel4: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 174
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clRed
        ParentBackground = False
        TabOrder = 0
        object BtnOpen1: TButton
          Tag = 1
          AlignWithMargins = True
          Left = 109
          Top = 4
          Width = 61
          Height = 27
          Align = alRight
          Caption = 'Open'
          TabOrder = 0
          TabStop = False
          WordWrap = True
          OnClick = BtnOpen1Click
        end
        object ChkActive1: TCheckBox
          Left = 6
          Top = 10
          Width = 51
          Height = 17
          Caption = 'Active'
          Enabled = False
          TabOrder = 1
          OnClick = ChkActive1Click
        end
        object BtnHist1: TButton
          Tag = 1
          AlignWithMargins = True
          Left = 64
          Top = 4
          Width = 39
          Height = 27
          Align = alRight
          Caption = 'H'
          TabOrder = 2
          TabStop = False
          WordWrap = True
          OnClick = BtnHist1Click
        end
      end
      object Panel4: TPanel
        AlignWithMargins = True
        Left = 183
        Top = 3
        Width = 174
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        Color = clGreen
        ParentBackground = False
        TabOrder = 1
        object BtnOpen2: TButton
          Tag = 2
          AlignWithMargins = True
          Left = 110
          Top = 3
          Width = 61
          Height = 29
          Align = alRight
          Caption = 'Open'
          TabOrder = 0
          TabStop = False
          WordWrap = True
          OnClick = BtnOpen1Click
        end
        object ChkActive2: TCheckBox
          Left = 6
          Top = 10
          Width = 51
          Height = 17
          Caption = 'Active'
          Enabled = False
          TabOrder = 1
          OnClick = ChkActive1Click
        end
        object BtnHist2: TButton
          Tag = 2
          AlignWithMargins = True
          Left = 65
          Top = 3
          Width = 39
          Height = 29
          Align = alRight
          Caption = 'H'
          TabOrder = 2
          TabStop = False
          WordWrap = True
          OnClick = BtnHist1Click
        end
      end
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 363
        Top = 3
        Width = 174
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        Color = clBlue
        ParentBackground = False
        TabOrder = 2
        object BtnOpen3: TButton
          Tag = 3
          AlignWithMargins = True
          Left = 110
          Top = 3
          Width = 61
          Height = 29
          Align = alRight
          Caption = 'Open'
          TabOrder = 0
          TabStop = False
          WordWrap = True
          OnClick = BtnOpen1Click
        end
        object ChkActive3: TCheckBox
          Left = 6
          Top = 10
          Width = 51
          Height = 17
          Caption = 'Active'
          Enabled = False
          TabOrder = 1
          OnClick = ChkActive1Click
        end
        object BtnHist3: TButton
          Tag = 3
          AlignWithMargins = True
          Left = 65
          Top = 3
          Width = 39
          Height = 29
          Align = alRight
          Caption = 'H'
          TabOrder = 2
          TabStop = False
          WordWrap = True
          OnClick = BtnHist1Click
        end
      end
    end
    object ImageEnVectMain: TImageEnVect
      Left = 1
      Top = 42
      Width = 929
      Height = 654
      ParentCtl3D = False
      EnableInteractionHints = True
      Align = alClient
      TabOrder = 1
      OnSelectObject = ImageEnVectMainSelectObject
      OnNewObject = ImageEnVectMainNewObject
      object ImageEnVect1: TImageEnVect
        Left = 40
        Top = 16
        Width = 105
        Height = 105
        ParentCtl3D = False
        EnableInteractionHints = True
        Visible = False
        TabOrder = 0
      end
      object ImageEnVect2: TImageEnVect
        Left = 232
        Top = 16
        Width = 105
        Height = 105
        ParentCtl3D = False
        EnableInteractionHints = True
        Visible = False
        TabOrder = 1
      end
      object ImageEnVect3: TImageEnVect
        Left = 408
        Top = 16
        Width = 105
        Height = 105
        ParentCtl3D = False
        EnableInteractionHints = True
        Visible = False
        TabOrder = 2
      end
      object ImageEnVectTmp: TImageEnVect
        Left = 587
        Top = 16
        Width = 105
        Height = 105
        ParentCtl3D = False
        EnableInteractionHints = True
        Visible = False
        TabOrder = 3
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 326
    Height = 697
    Align = alLeft
    TabOrder = 1
    object Panel7: TPanel
      Left = 1
      Top = 1
      Width = 324
      Height = 184
      Align = alTop
      TabOrder = 0
      object LabelZLayerIndex: TLabel
        Left = 143
        Top = 80
        Width = 8
        Height = 16
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnUp: TButton
        Tag = -1
        Left = 125
        Top = 21
        Width = 49
        Height = 41
        Caption = 'Up'
        TabOrder = 0
        OnClick = BtnUpClick
      end
      object BtnDown: TButton
        Tag = 1
        Left = 125
        Top = 114
        Width = 49
        Height = 41
        Caption = 'Down'
        TabOrder = 1
        OnClick = BtnUpClick
      end
      object BtnHelp: TButton
        Tag = -1
        Left = 3
        Top = 4
        Width = 49
        Height = 22
        Caption = 'Help'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BtnHelpClick
      end
    end
    object Panel8: TPanel
      Left = 1
      Top = 185
      Width = 324
      Height = 511
      Align = alClient
      TabOrder = 1
      object BtnSaveProject: TSpeedButton
        Left = 41
        Top = 368
        Width = 89
        Height = 41
        Caption = 'Save Project'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = BtnSaveProjectClick
      end
      object BtnLoadProject: TSpeedButton
        Left = 189
        Top = 368
        Width = 89
        Height = 41
        Caption = 'Load Project'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = BtnLoadProjectClick
      end
      object Label1: TLabel
        Left = 62
        Top = 107
        Width = 72
        Height = 13
        Caption = 'Line Thickness:'
      end
      object BtnSaveMiyelinImage: TSpeedButton
        Left = 85
        Top = 435
        Width = 144
        Height = 41
        Caption = 'Save Miyelin Mask Image'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = BtnSaveMiyelinImageClick
      end
      object CmbLineThickness: TComboBox
        Left = 145
        Top = 104
        Width = 112
        Height = 21
        TabOrder = 0
        Text = 'Select'
        OnChange = CmbLineThicknessChange
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50')
      end
      object GroupBox1: TGroupBox
        Left = 24
        Top = 145
        Width = 273
        Height = 81
        Caption = 'Shortening'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object SpeedButton2: TSpeedButton
          Left = 17
          Top = 29
          Width = 47
          Height = 33
          Hint = 'Press button to  shorten the drawing from Red end'
          Caption = 'Red'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton2Click
        end
        object SpeedButton1: TSpeedButton
          Left = 112
          Top = 29
          Width = 47
          Height = 33
          Hint = 
            'Press Show button to see end points of the drawings for sortenni' +
            'ng'
          Caption = 'Show'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnMouseDown = SpeedButton1MouseDown
          OnMouseUp = SpeedButton1MouseUp
        end
        object SpeedButton3: TSpeedButton
          Left = 207
          Top = 29
          Width = 47
          Height = 33
          Hint = 'Press button to  shorten the drawing from Blue end'
          Caption = 'Blue'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton3Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 24
        Top = 6
        Width = 273
        Height = 83
        Caption = 'Muose Interact'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object BtnMiyelinDraw: TSpeedButton
          Left = 17
          Top = 24
          Width = 50
          Height = 41
          GroupIndex = 2
          Caption = 'Draw'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = BtnMiyelinDrawClick
        end
        object BtnMiyelinSelect: TSpeedButton
          Left = 112
          Top = 24
          Width = 50
          Height = 41
          GroupIndex = 2
          Caption = 'Select'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = BtnMiyelinSelectClick
        end
        object BtnMiyelinDelete: TSpeedButton
          Left = 207
          Top = 24
          Width = 50
          Height = 41
          Caption = 'Delete'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = BtnMiyelinDeleteClick
        end
      end
    end
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 703
    Width = 1484
    Height = 19
    Panels = <>
  end
  object Panel6: TPanel
    AlignWithMargins = True
    Left = 1272
    Top = 3
    Width = 209
    Height = 697
    Align = alRight
    TabOrder = 3
    object Panel9: TPanel
      Left = 1
      Top = 1
      Width = 207
      Height = 41
      Align = alTop
      TabOrder = 0
    end
    object Panel10: TPanel
      Left = 1
      Top = 42
      Width = 207
      Height = 654
      Align = alClient
      TabOrder = 1
      object StringGrid1: TStringGrid
        Left = 1
        Top = 1
        Width = 205
        Height = 652
        Align = alClient
        ColCount = 3
        FixedColor = clMedGray
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 0
        OnSelectCell = StringGrid1SelectCell
      end
    end
  end
  object OpenImageEnDialog1: TOpenImageEnDialog
    Filter = 
      'Genel Grafik Dosyalar'#305' (*.tif;*.gif;*.jpg;*.pcx;*.bmp;*.ico;*.cu' +
      'r;*.png;*.dcm;*.wmf;*.emf;*.tga;*.pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*' +
      '.crw;*.psd;*.iev;*.lyr;*.all;*.wdp;*.avi;*.mpg;*.wmv)|*.tif;*.gi' +
      'f;*.jpg;*.pcx;*.bmp;*.ico;*.cur;*.png;*.dcm;*.wmf;*.emf;*.tga;*.' +
      'pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*.crw;*.psd;*.iev;*.lyr;*.all;*.wdp' +
      ';*.avi;*.mpg;*.wmv|B'#252't'#252'n Dosyalar (*.*)|*.*|JPEG Bitmap (*.jpg;*' +
      '.jpeg;*.jpe;*.jif)|*.jpg;*.jpeg;*.jpe;*.jif|TIFF Bitmap (*.tif;*' +
      '.tiff;*.fax;*.g3n;*.g3f;*.xif)|*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.' +
      'xif|CompuServe Bitmap (*.gif)|*.gif|PaintBrush (*.pcx)|*.pcx|Win' +
      'dows Bitmap (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|Windows Icon (' +
      '*.ico)|*.ico|Windows Cursor (*.cur)|*.cur|Portable Network Graph' +
      'ics (*.png)|*.png|DICOM Bitmap (*.dcm;*.dic;*.dicom;*.v2)|*.dcm;' +
      '*.dic;*.dicom;*.v2|Windows Metafile (*.wmf)|*.wmf|Enhanced Windo' +
      'ws Metafile (*.emf)|*.emf|Targa Bitmap (*.tga;*.targa;*.vda;*.ic' +
      'b;*.vst;*.pix)|*.tga;*.targa;*.vda;*.icb;*.vst;*.pix|Portable Pi' +
      'xmap, GrayMap, BitMap (*.pxm;*.ppm;*.pgm;*.pbm)|*.pxm;*.ppm;*.pg' +
      'm;*.pbm|Wireless Bitmap (*.wbmp)|*.wbmp|JPEG2000 (*.jp2)|*.jp2|J' +
      'PEG2000 Code Stream (*.j2k;*.jpc;*.j2c)|*.j2k;*.jpc;*.j2c|Multip' +
      'age PCX (*.dcx)|*.dcx|Camera RAW (*.crw;*.cr2;*.nef;*.raw;*.pef;' +
      '*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2)|*.crw;*.cr2;*.n' +
      'ef;*.raw;*.pef;*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2|P' +
      'hotoshop PSD (*.psd)|*.psd|Vectorial objects (*.iev)|*.iev|Layer' +
      's (*.lyr)|*.lyr|Layers and objects (*.all)|*.all|Microsoft HD Ph' +
      'oto (*.wdp;*.hdp)|*.wdp;*.hdp|Windows '#304#231'in Video (*.avi)|*.avi|M' +
      'peg (*.mpeg;*.mpg)|*.mpeg;*.mpg|Windows Media Video (*.wmv)|*.wm' +
      'v'
    FilterIndex = 0
    FilterDefault = 0
    Options = [ofHideReadOnly, ofAllowMultiSelect]
    Left = 416
    Top = 104
  end
  object OpenImageEnDialog2: TOpenImageEnDialog
    Filter = 
      'Genel Grafik Dosyalar'#305' (*.tif;*.gif;*.jpg;*.pcx;*.bmp;*.ico;*.cu' +
      'r;*.png;*.dcm;*.wmf;*.emf;*.tga;*.pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*' +
      '.crw;*.psd;*.iev;*.lyr;*.all;*.wdp;*.avi;*.mpg;*.wmv)|*.tif;*.gi' +
      'f;*.jpg;*.pcx;*.bmp;*.ico;*.cur;*.png;*.dcm;*.wmf;*.emf;*.tga;*.' +
      'pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*.crw;*.psd;*.iev;*.lyr;*.all;*.wdp' +
      ';*.avi;*.mpg;*.wmv|B'#252't'#252'n Dosyalar (*.*)|*.*|JPEG Bitmap (*.jpg;*' +
      '.jpeg;*.jpe;*.jif)|*.jpg;*.jpeg;*.jpe;*.jif|TIFF Bitmap (*.tif;*' +
      '.tiff;*.fax;*.g3n;*.g3f;*.xif)|*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.' +
      'xif|CompuServe Bitmap (*.gif)|*.gif|PaintBrush (*.pcx)|*.pcx|Win' +
      'dows Bitmap (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|Windows Icon (' +
      '*.ico)|*.ico|Windows Cursor (*.cur)|*.cur|Portable Network Graph' +
      'ics (*.png)|*.png|DICOM Bitmap (*.dcm;*.dic;*.dicom;*.v2)|*.dcm;' +
      '*.dic;*.dicom;*.v2|Windows Metafile (*.wmf)|*.wmf|Enhanced Windo' +
      'ws Metafile (*.emf)|*.emf|Targa Bitmap (*.tga;*.targa;*.vda;*.ic' +
      'b;*.vst;*.pix)|*.tga;*.targa;*.vda;*.icb;*.vst;*.pix|Portable Pi' +
      'xmap, GrayMap, BitMap (*.pxm;*.ppm;*.pgm;*.pbm)|*.pxm;*.ppm;*.pg' +
      'm;*.pbm|Wireless Bitmap (*.wbmp)|*.wbmp|JPEG2000 (*.jp2)|*.jp2|J' +
      'PEG2000 Code Stream (*.j2k;*.jpc;*.j2c)|*.j2k;*.jpc;*.j2c|Multip' +
      'age PCX (*.dcx)|*.dcx|Camera RAW (*.crw;*.cr2;*.nef;*.raw;*.pef;' +
      '*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2)|*.crw;*.cr2;*.n' +
      'ef;*.raw;*.pef;*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2|P' +
      'hotoshop PSD (*.psd)|*.psd|Vectorial objects (*.iev)|*.iev|Layer' +
      's (*.lyr)|*.lyr|Layers and objects (*.all)|*.all|Microsoft HD Ph' +
      'oto (*.wdp;*.hdp)|*.wdp;*.hdp|Windows '#304#231'in Video (*.avi)|*.avi|M' +
      'peg (*.mpeg;*.mpg)|*.mpeg;*.mpg|Windows Media Video (*.wmv)|*.wm' +
      'v'
    FilterIndex = 0
    FilterDefault = 0
    Options = [ofHideReadOnly, ofAllowMultiSelect]
    Left = 600
    Top = 104
  end
  object OpenImageEnDialog3: TOpenImageEnDialog
    Filter = 
      'Genel Grafik Dosyalar'#305' (*.tif;*.gif;*.jpg;*.pcx;*.bmp;*.ico;*.cu' +
      'r;*.png;*.dcm;*.wmf;*.emf;*.tga;*.pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*' +
      '.crw;*.psd;*.iev;*.lyr;*.all;*.wdp;*.avi;*.mpg;*.wmv)|*.tif;*.gi' +
      'f;*.jpg;*.pcx;*.bmp;*.ico;*.cur;*.png;*.dcm;*.wmf;*.emf;*.tga;*.' +
      'pxm;*.wbmp;*.jp2;*.j2k;*.dcx;*.crw;*.psd;*.iev;*.lyr;*.all;*.wdp' +
      ';*.avi;*.mpg;*.wmv|B'#252't'#252'n Dosyalar (*.*)|*.*|JPEG Bitmap (*.jpg;*' +
      '.jpeg;*.jpe;*.jif)|*.jpg;*.jpeg;*.jpe;*.jif|TIFF Bitmap (*.tif;*' +
      '.tiff;*.fax;*.g3n;*.g3f;*.xif)|*.tif;*.tiff;*.fax;*.g3n;*.g3f;*.' +
      'xif|CompuServe Bitmap (*.gif)|*.gif|PaintBrush (*.pcx)|*.pcx|Win' +
      'dows Bitmap (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|Windows Icon (' +
      '*.ico)|*.ico|Windows Cursor (*.cur)|*.cur|Portable Network Graph' +
      'ics (*.png)|*.png|DICOM Bitmap (*.dcm;*.dic;*.dicom;*.v2)|*.dcm;' +
      '*.dic;*.dicom;*.v2|Windows Metafile (*.wmf)|*.wmf|Enhanced Windo' +
      'ws Metafile (*.emf)|*.emf|Targa Bitmap (*.tga;*.targa;*.vda;*.ic' +
      'b;*.vst;*.pix)|*.tga;*.targa;*.vda;*.icb;*.vst;*.pix|Portable Pi' +
      'xmap, GrayMap, BitMap (*.pxm;*.ppm;*.pgm;*.pbm)|*.pxm;*.ppm;*.pg' +
      'm;*.pbm|Wireless Bitmap (*.wbmp)|*.wbmp|JPEG2000 (*.jp2)|*.jp2|J' +
      'PEG2000 Code Stream (*.j2k;*.jpc;*.j2c)|*.j2k;*.jpc;*.j2c|Multip' +
      'age PCX (*.dcx)|*.dcx|Camera RAW (*.crw;*.cr2;*.nef;*.raw;*.pef;' +
      '*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2)|*.crw;*.cr2;*.n' +
      'ef;*.raw;*.pef;*.raf;*.x3f;*.bay;*.orf;*.srf;*.mrw;*.dcr;*.sr2|P' +
      'hotoshop PSD (*.psd)|*.psd|Vectorial objects (*.iev)|*.iev|Layer' +
      's (*.lyr)|*.lyr|Layers and objects (*.all)|*.all|Microsoft HD Ph' +
      'oto (*.wdp;*.hdp)|*.wdp;*.hdp|Windows '#304#231'in Video (*.avi)|*.avi|M' +
      'peg (*.mpeg;*.mpg)|*.mpeg;*.mpg|Windows Media Video (*.wmv)|*.wm' +
      'v'
    FilterIndex = 0
    FilterDefault = 0
    Options = [ofHideReadOnly, ofAllowMultiSelect]
    Left = 784
    Top = 112
  end
  object SavePictureDialog1: TSavePictureDialog
    Filter = 'Tif File|*.tif'
    Left = 760
    Top = 405
  end
  object OpenDialog1: TOpenDialog
    Filter = 'ini files|*.ini'
    Left = 576
    Top = 280
  end
  object SaveDialog1: TSaveDialog
    Filter = 'ini files|*.ini'
    Left = 760
    Top = 280
  end
end
