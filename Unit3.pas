unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, System.Skia, Vcl.StdCtrls,
  Vcl.Skia, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Data.Win.ADODB;

type
  TForm3 = class(TForm)
    Panel2: TPanel;
    Button7: TButton;
    DBGrid1: TDBGrid;
    Button8: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SkAnimatedImage1: TSkAnimatedImage;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Button12: TButton;
    Edit5: TEdit;
    Edit6: TEdit;
    SkAnimatedImage2: TSkAnimatedImage;
    Panel5: TPanel;
    SkAnimatedImage3: TSkAnimatedImage;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    Button13: TButton;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    procedure Button13Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure CheckBox1Enter(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SkAnimatedImage1Click(Sender: TObject);
    procedure SkAnimatedImage2Click(Sender: TObject);
    procedure SkAnimatedImage3Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure SkAnimatedImage4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button10Click(Sender: TObject);
begin
  panel5.Visible:=True;
 panel4.Visible:=false;
 panel3.Visible:=false;
button7.Visible:=false;
button8.Visible:=false;
button11.Visible:=false;
button10.Visible:=false;
end;

procedure TForm3.Button11Click(Sender: TObject);
begin
  panel4.Visible:=true;
 panel3.Visible:=false;
button7.Visible:=false;
button8.Visible:=false;
button11.Visible:=false;
button10.Visible:=false;
end;

procedure TForm3.Button12Click(Sender: TObject);
begin
 // التحقق من إدخال جميع الحقول
  if (Trim(Edit3.Text) = '') or (Trim(Edit4.Text) = '') or (Trim(Edit5.Text) = '') or (Trim(Edit6.Text) = '') then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  // التحقق من تطابق كلمة المرور الجديدة مع التأكيد
  if Trim(Edit4.Text) <> Trim(Edit5.Text) then
  begin
    ShowMessage('كلمة المرور الجديدة وتأكيدها غير متطابقين!');
    Exit;
  end;

  // تصفية السجل بناءً على اسم المستخدم
  ADOTable1.Filter := Format('Username = ''%s''', [Trim(Edit3.Text)]);
  ADOTable1.Filtered := True;

  // التحقق من وجود المستخدم
  if ADOTable1.IsEmpty then
  begin
    ShowMessage('المستخدم غير موجود!');
    ADOTable1.Filtered := False;
    Exit;
  end;

  // التحقق من صحة كلمة المرور الحالية
  if ADOTable1.FieldByName('Password').AsString <> Trim(Edit6.Text) then
  begin
    ShowMessage('كلمة المرور الحالية غير صحيحة!');
    ADOTable1.Filtered := False;
    Exit;
  end;

  // تحديث كلمة المرور
  try
    ADOTable1.Edit;
    ADOTable1.FieldByName('Password').AsString := Trim(Edit4.Text);
    ADOTable1.Post;
    ShowMessage('تم تغيير كلمة المرور بنجاح!');
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ أثناء تغيير كلمة المرور: ' + E.Message);
      ADOTable1.Cancel;
    end;
  end;

  // إلغاء التصفية
  ADOTable1.Filtered := False;
end;

procedure TForm3.Button13Click(Sender: TObject);
begin
 if ComboBox2.Text = '' then
begin
  ShowMessage('يرجى اختيار مستخدم أولاً!');

end;

ADOTable1.Filter := Format('Username = ''%s''', [ComboBox2.Text]);
ADOTable1.Filtered := True;

if ADOTable1.IsEmpty then
begin
  ShowMessage('المستخدم غير موجود!');

end;

// التحقق من أن الحساب ليس للمدير
if ADOTable1.FieldByName('Role').AsString = 'مدير' then
begin
  ShowMessage('لا يمكن تعطيل حساب المدير!');
  ADOTable1.Filtered := False;

end;

try
  ADOTable1.Edit;

  // تحديث الحالة بناءً على CheckBox
  if CheckBox1.Checked then
  begin
    ADOTable1.FieldByName('Account status').AsString := 'نشط';
     CheckBox1.Caption := 'تعطيل';
  end
  else
  begin
    ADOTable1.FieldByName('Account status').AsString := 'معطل';
      CheckBox1.Caption := 'تمكين';
  end;

  ADOTable1.Post;
  ShowMessage('تم تحديث حالة الحساب بنجاح!');
except
  on E: Exception do
  begin
    ShowMessage('حدث خطأ أثناء تحديث حالة الحساب: ' + E.Message);
    ADOTable1.Cancel;
  end;
end;
ADOTable1.Filtered := False;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
close;
end;

procedure TForm3.Button7Click(Sender: TObject);
begin
 panel3.Visible:=true;
button7.Visible:=false;
button8.Visible:=false;
button11.Visible:=false;
button10.Visible:=false;
end;

procedure TForm3.Button9Click(Sender: TObject);
begin

  if (Trim(Edit1.Text) = '') or (Trim(Edit2.Text) = '') or (Trim(ComboBox1.Text) = '') then
begin
  ShowMessage('يرجى إدخال جميع الحقول!');

end;

  ADOTable1.Filter := Format('Username = ''%s''', [Edit1.Text]);
  ADOTable1.Filtered := True;
  if not ADOTable1.IsEmpty then
  begin
    ShowMessage('اسم المستخدم موجود بالفعل!');
    ADOTable1.Filtered := False;

  end;
  ADOTable1.Filtered := False;


  try
    ADOTable1.Append;
    ADOTable1.FieldByName('Username').AsString := Edit1.Text;
    ADOTable1.FieldByName('Password').AsString := Edit2.Text;
    ADOTable1.FieldByName('Role').AsString := ComboBox1.Text;
    ADOTable1.FieldByName('Account status').AsString := 'نشط';
    ADOTable1.Post;
    ShowMessage('تمت إضافة المستخدم بنجاح!');

  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ أثناء إضافة المستخدم: ' + E.Message);
      ADOTable1.Cancel;
    end;
  end;
end;

procedure TForm3.CheckBox1Click(Sender: TObject);
begin
    if CheckBox1.Checked then
  begin

    CheckBox1.Caption := 'تعطيل';
  end
  else
  begin

    CheckBox1.Caption := 'تمكين';
  end;
end;

procedure TForm3.CheckBox1Enter(Sender: TObject);
begin
   if CheckBox1.Checked then
  begin

    CheckBox1.Caption := 'تعطيل';
  end
  else
  begin

    CheckBox1.Caption := 'تمكين';
  end;
end;

procedure TForm3.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.Text = '' then Exit;

  ADOTable1.Filter := Format('Username = ''%s''', [ComboBox2.Text]);
  ADOTable1.Filtered := True;

  if not ADOTable1.IsEmpty then
  begin

    if ADOTable1.FieldByName('Account status').AsString = 'نشط' then
    begin
      CheckBox1.Checked := True;

    end
    else
    begin
      CheckBox1.Checked := False;

    end;
  end
  else
  begin
    ShowMessage('لم يتم العثور على المستخدم!');
  end;
end;

procedure TForm3.ComboBox2Enter(Sender: TObject);
begin
ComboBox2.Items.Clear;
ADOTable1.First;
while not ADOTable1.Eof do
begin
  if ADOTable1.FieldByName('Role').AsString <> 'Administrator' then
  begin
    ComboBox2.Items.Add(ADOTable1.FieldByName('Username').AsString);
  end;
  ADOTable1.Next;
end;
end;
procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caHide;
end;

procedure TForm3.SkAnimatedImage1Click(Sender: TObject);
begin
panel3.Visible:=false;
button7.Visible:=True;
button8.Visible:=True;
button10.Visible:=True;
button11.Visible:=True;
end;

procedure TForm3.SkAnimatedImage2Click(Sender: TObject);
begin
 panel4.Visible:=false;

button7.Visible:=True;
button8.Visible:=True;
button10.Visible:=True;
button11.Visible:=True;
end;

procedure TForm3.SkAnimatedImage3Click(Sender: TObject);
begin
 panel5.Visible:=false;

button7.Visible:=True;
button8.Visible:=True;
button10.Visible:=True;
button11.Visible:=True;
end;

procedure TForm3.SkAnimatedImage4Click(Sender: TObject);
begin
Self.Close;
end;

end.
