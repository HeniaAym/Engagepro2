object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 628
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Mudir MT'
  Font.Style = [fsBold]
  OnCreate = FormCreate
  TextHeight = 23
  object Button1: TButton
    Left = 424
    Top = 520
    Width = 107
    Height = 40
    Caption = #1601#1578#1581' '#1575#1604#1588#1575#1578
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Mudir MT'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 523
    Width = 75
    Height = 33
    Caption = 'Button2'
    TabOrder = 1
  end
  object PythonEngine1: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 176
    Top = 520
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.py'
    Filter = 'Python files|*.py|Text files|*.txt|All files|*.*'
    Title = 'Open'
    Left = 368
    Top = 448
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = False
    RawOutput = False
    Left = 184
    Top = 480
  end
end
