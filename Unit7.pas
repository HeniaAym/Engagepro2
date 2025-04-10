unit Unit7;

interface

uses
  Classes, SysUtils,
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  PythonEngine, Vcl.PythonGUIInputOutput;

type
  TForm7 = class(TForm)
    PythonEngine1: TPythonEngine;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form7: TForm7;

implementation

{$R *.DFM}

procedure TForm7.Button1Click(Sender: TObject);
var
  PythonCode: TStringList;
begin
  PythonCode := TStringList.Create;
  try
    PythonCode.LoadFromFile(OpenDialog1.FileName, TEncoding.UTF8);
    PythonEngine1.ExecStrings(PythonCode);
  finally
    PythonCode.Free;
  end;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
 OpenDialog1.FileName :=('D:\Management System\Counselor\chatcounselor.py')
end;

end.
