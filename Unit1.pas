unit Unit1;

interface

uses
 System.UITypes, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.Skia, Vcl.Skia, Vcl.Mask;

type
  TForm1 = class(TForm)
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Shape1: TShape;
    SkAnimatedImage1: TSkAnimatedImage;
    SkAnimatedImage2: TSkAnimatedImage;
    SkAnimatedImage3: TSkAnimatedImage;
    SkAnimatedImage4: TSkAnimatedImage;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Label5: TLabel;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    SkAnimatedImage5: TSkAnimatedImage;
    Timer3: TTimer;
    SkAnimatedImage6: TSkAnimatedImage;
    SkAnimatedImage7: TSkAnimatedImage;
    Label7: TLabel;
    procedure SkAnimatedImage4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure SkAnimatedImage7Click(Sender: TObject);
    procedure SkAnimatedImage6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2, Unit3;

procedure TForm1.Button2Click(Sender: TObject);
begin
  try
    ADOTable1.Open;

    if ADOTable1.Locate('Username;Password', VarArrayOf([ComboBox1.Text, Edit2.Text]), []) then
    begin
      if ADOTable1.FieldByName('Account status').AsString = 'معطل' then
      begin
        ShowMessage('الحساب معطل. يرجى التواصل مع الإدارة لتفعيل الحساب.');
        Exit;
      end;

      if Assigned(Form3) then
      begin
        if ADOTable1.FieldByName('Role').AsString = 'Administrator' then
        begin
          Form3.Button7.Enabled := true;
          Form3.Button10.Enabled := true;
          Form3.Button8.Enabled := true;
        end
        else
        begin
          Form3.Button7.Enabled := false;
          Form3.Button10.Enabled := false;
          Form3.Button8.Enabled := false;
        end;
      end;

      Timer3.Enabled := True;
      SkAnimatedImage5.Visible := true;
    end
    else
    begin
      ShowMessage('اسم المستخدم أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.');
    end;
  except
    on E: Exception do
      ShowMessage('حدث خطأ: ' + E.Message);
  end;

  if ADOTable1.Active then
    ADOTable1.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

 ADOConnection1.Open;

  ADOQuery1.Open;

  ComboBox1.Items.Clear;
  while not ADOQuery1.Eof do
  begin
    ComboBox1.Items.Add(ADOQuery1.FieldByName('Username').AsString);
    ADOQuery1.Next;
  end;

  ADOQuery1.Close;

     if not Assigned(Form2) then
    Form2 := TForm2.Create(nil);
  

end;

procedure TForm1.SkAnimatedImage4Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.SkAnimatedImage6Click(Sender: TObject);
begin
      SkAnimatedImage6.Visible :=false;
 SkAnimatedImage7.Visible :=True;
 edit2.PasswordChar :='*';
end;

procedure TForm1.SkAnimatedImage7Click(Sender: TObject);
begin
   SkAnimatedImage7.Visible :=false;
   SkAnimatedImage6.Visible :=True;
 edit2.PasswordChar := #0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin


  Label6.Caption := FormatDateTime('DD/MM/YYYY     **       hh:nn:ss', Now);


end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin

  Timer3.Enabled := False;

        if not Assigned(Form2) then
  Form2 := TForm2.Create(Application);  // استخدام Application بدلاً من nil

Form2.Show;
Form2.ShowInTaskBar := True;
Form1.Hide;
end;

end.
