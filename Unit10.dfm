object Form10: TForm10
  Left = 0
  Top = 0
  Caption = 'Form10'
  ClientHeight = 342
  ClientWidth = 840
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  Visible = True
  StyleName = 'Windows'
  TextHeight = 15
  object Button1: TButton
    Left = 648
    Top = 32
    Width = 147
    Height = 57
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 648
    Top = 104
    Width = 147
    Height = 57
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 648
    Top = 176
    Width = 147
    Height = 57
    Caption = 'Button3'
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 432
    Top = 256
  end
  object SaveDialog1: TSaveDialog
    Left = 504
    Top = 248
  end
  object ADOCommand1: TADOCommand
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=ManagementSystem;Data Source=AYMEN'
    Parameters = <>
    Left = 528
    Top = 184
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSOLEDBSQL.1;Integrated Security=SSPI;Persist Security ' +
      'Info=False;User ID="";Initial Catalog=ManagementSystem;Data Sour' +
      'ce=AYMEN;Initial File Name="";Server SPN="";Authentication="";Ac' +
      'cess Token=""'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL.1'
    Left = 440
    Top = 192
  end
end
