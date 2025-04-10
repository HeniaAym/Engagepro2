unit Unit2;

interface

uses
 System.UITypes, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxSmartMemo, frCoreClasses, frxClass,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, System.Skia, Vcl.Skia, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, PythonEngine, frGIFGraphic, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg;

type
  TForm2 = class(TForm)
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Editnumprog: TEdit;
    Editnomprog: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Buttonaddprog: TButton;
    Buttoneditprog: TButton;
    Buttondelprog: TButton;
    Editprog: TEdit;
    Label4: TLabel;
    ADOConnection2: TADOConnection;
    ADOTablepro: TADOTable;
    DataSource2: TDataSource;
    SkAnimatedImage1: TSkAnimatedImage;
    ADOTableord: TADOTable;
    Editnumord: TEdit;
    Editord: TEdit;
    Editdord: TEdit;
    Buttonaddord: TButton;
    Buttoneditord: TButton;
    Buttondelord: TButton;
    activiteID: TEdit;
    activitenum: TEdit;
    activitedel: TEdit;
    Butactiviteadd: TButton;
    Butactiviteedit: TButton;
    Butactivitedel: TButton;
    ADOTableact: TADOTable;
    Editpnum: TEdit;
    Editpnom: TEdit;
    Editpdel: TEdit;
    Buttonpadd: TButton;
    Buttonpedit: TButton;
    Buttonpdel: TButton;
    ADOTableps: TADOTable;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    OpenDialog1: TOpenDialog;
    PythonEngine1: TPythonEngine;
    Button3: TButton;
    Button1: TButton;
    Button5: TButton;
    Button9: TButton;
    Button8: TButton;
    Button7: TButton;
    Button2: TButton;
    Button6: TButton;
    Button4: TButton;
    Image1: TImage;
    Panel1: TPanel;
    SkAnimatedImage2: TSkAnimatedImage;
    SkAnimatedImage3: TSkAnimatedImage;
    SkAnimatedImage4: TSkAnimatedImage;
    SkAnimatedImage5: TSkAnimatedImage;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SkAnimatedImage1Click(Sender: TObject);
    procedure ButtonaddprogClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ButtonaddordClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ButactiviteaddClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonpaddClick(Sender: TObject);
    procedure ButtonpeditClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ButactiviteeditClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ButtoneditordClick(Sender: TObject);
    procedure ButtoneditprogClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure ButtondelprogClick(Sender: TObject);
    procedure ButactivitedelClick(Sender: TObject);
    procedure ButtondelordClick(Sender: TObject);
    procedure ButtonpdelClick(Sender: TObject);
    procedure SkAnimatedImage2Click(Sender: TObject);
    procedure SkAnimatedImage3Click(Sender: TObject);
    procedure SkAnimatedImage4Click(Sender: TObject);
    procedure SkAnimatedImage5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit3, Unit4, Unit5, Unit10, Unit11;

procedure TForm2.ButtonaddordClick(Sender: TObject);
begin
 if (Trim(Editord.Text) = '') or (Trim(editnumord.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTableord.Append;
    ADOTableord.FieldByName('num_ordonnateur').AsString:= Editnumord.Text;
    ADOTableord.FieldByName('ordonnateur').AsString := editord.Text;

    ADOTableord.Post;
    ShowMessage('تمت الإضافة بنجاح');
    ADOTableord.Refresh;
    Editnumord.Clear;
    editord.clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ: ' + E.Message);
      ADOTableord.Cancel;
    end;
  end;
end;

procedure TForm2.ButtonaddprogClick(Sender: TObject);
begin
 if (Trim(Editnomprog.Text) = '') or (Trim(editnumprog.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTablepro.Append;
    ADOTablepro.FieldByName('num_programme').AsString:= editnumprog.Text;
    ADOTablepro.FieldByName('nom_programme').AsString := Editnomprog.Text;

    ADOTablepro.Post;
    ShowMessage('تمت إضافة البرنامج بنجاح');
    ADOTablepro.Refresh;
     editnumprog.Clear;
      Editnomprog.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ أثناء إضافة العملية: ' + E.Message);
      ADOTable1.Cancel;
    end;
  end;
end;

procedure TForm2.ButtondelordClick(Sender: TObject);
begin
if Editdord.Text <> '' then
  begin
     if MessageDlg('هل أنت متأكد أنك تريد حذف هذا السجل؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try

        if ADOTableord.Locate('num_ordonnateur', Editdord.Text, []) then
        begin

          ADOTableord.Delete;
          ShowMessage('تم الحذف بنجاح.');
          ADOTableord.Refresh;
          Editnumord.Clear;
          editord.clear;
        end
        else
        begin
          ShowMessage('لم يتم العثور على السجل المطلوب.');
        end;
      except
        on E: Exception do
          ShowMessage('حدث خطأ أثناء الحذف: ' + E.Message);
      end;
    end;
   end
    else
    begin
    ShowMessage('يرجى تحديد رقم النشاط المراد حذفه.');
    end;
end;

procedure TForm2.ButtondelprogClick(Sender: TObject);

begin
    if Editprog.Text <> '' then
  begin

    if MessageDlg('هل أنت متأكد أنك تريد حذف هذا السجل؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try

        if ADOTablepro.Locate('num_programme', Editprog.Text, []) then
        begin

          ADOTablepro.Delete;
          ShowMessage('تم الحذف بنجاح.');
          ADOTablepro.Refresh;
          editnumprog.Clear;
           Editnomprog.Clear;
        end
        else
        begin
          ShowMessage('لم يتم العثور على السجل المطلوب.');
        end;
      except
        on E: Exception do
          ShowMessage('حدث خطأ أثناء الحذف: ' + E.Message);
      end;
    end;
  end
  else
  begin
    ShowMessage('يرجى تحديد رقم النشاط المراد حذفه.');
  end;
end;


procedure TForm2.ButtoneditordClick(Sender: TObject);
begin
     if DBGrid1.DataSource.DataSet.RecordCount > 0 then
    begin
    Editnumord.Text:= DBGrid1.DataSource.DataSet.FieldByName('num_ordonnateur').AsString ;
    editord.Text:=DBGrid1.DataSource.DataSet.FieldByName('ordonnateur').AsString  ;
     button12.Visible := true;
    end
     else
    begin
      ShowMessage('رجاء تحديد حقل لتعديله');
    end;
end;

procedure TForm2.ButtoneditprogClick(Sender: TObject);
begin
    if DBGrid1.DataSource.DataSet.RecordCount > 0 then
    begin
    editnumprog.Text := DBGrid1.DataSource.DataSet.FieldByName('num_programme').AsString;
    Editnomprog.Text := DBGrid1.DataSource.DataSet.FieldByName('nom_programme').AsString  ;
    button13.Visible := true;
    end

    else
    begin
      ShowMessage('رجاء تحديد حقل لتعديله');
    end;
end;

procedure TForm2.ButtonpaddClick(Sender: TObject);
begin
if (Trim(Editpnum.Text) = '') or (Trim(Editpnom.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTableps.Append;
    ADOTableps.FieldByName('num_sous_programme').AsString:= Editpnum.Text;
    ADOTableps.FieldByName('nom_sous_programme').AsString := Editpnom.Text;

    ADOTableps.Post;
    ShowMessage('تمت الإضافة بنجاح');
     ADOTableps.Refresh;
     Editpnum.Clear;
      Editpnom.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ: ' + E.Message);
      ADOTableps.Cancel;
    end;
  end;
end;

procedure TForm2.ButtonpdelClick(Sender: TObject);
begin
   if Editpdel.Text <> '' then
  begin
     if MessageDlg('هل أنت متأكد أنك تريد حذف هذا السجل؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try

        if ADOTableps.Locate('num_sous_programme', Editpdel.Text, []) then
        begin

          ADOTableps.Delete;
          ShowMessage('تم الحذف بنجاح.');
           ADOTableps.Refresh;
     Editpnum.Clear;
      Editpnom.Clear;
        end
        else
        begin
          ShowMessage('لم يتم العثور على السجل المطلوب.');
        end;
      except
        on E: Exception do
          ShowMessage('حدث خطأ أثناء الحذف: ' + E.Message);
      end;
    end;
   end
    else
    begin
    ShowMessage('يرجى تحديد رقم النشاط المراد حذفه.');
    end;
end;

procedure TForm2.ButtonpeditClick(Sender: TObject);
begin
  if DBGrid1.DataSource.DataSet.RecordCount > 0 then
    begin
    Editpnum.Text:= DBGrid1.DataSource.DataSet.FieldByName('num_sous_programme').AsString ;
    Editpnom.Text:=DBGrid1.DataSource.DataSet.FieldByName('nom_sous_programme').AsString  ;
      button10.Visible := true;
    end
        else
    begin
      ShowMessage('رجاء تحديد حقل لتعديله');
    end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
  Form2 := nil;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  OpenDialog1.FileName :=('D:\Management System\Counselor\script.py')
end;

procedure TForm2.ButactiviteaddClick(Sender: TObject);
begin
 if (Trim(activiteID.Text) = '') or (Trim(activitenum.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTableact.Append;
    ADOTableact.FieldByName('num_activitè').AsString:= activiteID.Text;
    ADOTableact.FieldByName('nom_activité').AsString := activitenum.Text;

    ADOTableact.Post;

    ShowMessage('تمت الإضافة بنجاح');
     ADOTableact.Refresh;
     activiteID.Clear;
      activitenum.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ: ' + E.Message);
      ADOTableact.Cancel;
    end;
  end;
end;

procedure TForm2.ButactivitedelClick(Sender: TObject);
begin
  if activitedel.Text <> '' then
  begin
     if MessageDlg('هل أنت متأكد أنك تريد حذف هذا السجل؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try

        if ADOTableact.Locate('num_activitè', activitedel.Text, []) then
        begin

          ADOTableact.Delete;
          ShowMessage('تم الحذف بنجاح.');
           ADOTableact.Refresh;
         activiteID.Clear;
        activitenum.Clear;
        end
        else
        begin
          ShowMessage('لم يتم العثور على السجل المطلوب.');
        end;
      except
        on E: Exception do
          ShowMessage('حدث خطأ أثناء الحذف: ' + E.Message);
      end;
    end;
   end
    else
    begin
    ShowMessage('يرجى تحديد رقم النشاط المراد حذفه.');
    end;
end;

procedure TForm2.ButactiviteeditClick(Sender: TObject);
begin


   if DBGrid1.DataSource.DataSet.RecordCount > 0 then
    begin
    activiteID.Text:= DBGrid1.DataSource.DataSet.FieldByName('num_activitè').AsString ;
    activitenum.Text:=DBGrid1.DataSource.DataSet.FieldByName('nom_activité').AsString  ;
     button11.Visible := true;
    end
       else
    begin
      ShowMessage('رجاء تحديد حقل لتعديله');
    end;
end;

procedure TForm2.Button10Click(Sender: TObject);
begin
if (Trim(Editpnum.Text) = '') or (Trim(Editpnom.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTableps.edit;
    ADOTableps.FieldByName('num_sous_programme').AsString:= Editpnum.Text;
    ADOTableps.FieldByName('nom_sous_programme').AsString := Editpnom.Text;
    ADOTableps.Post;
    DBGrid1.DataSource.DataSet.Edit;
    DBGrid1.DataSource.DataSet.FieldByName('num_sous_programme').AsString:= Editpnum.Text;
    DBGrid1.DataSource.DataSet.FieldByName('nom_sous_programme').AsString := Editpnom.Text;
     DBGrid1.DataSource.DataSet.Post;
    ShowMessage('تم التعديل بنجاح');
     button10.Visible := false;
     ADOTableps.Refresh;
     Editpnum.Clear;
      Editpnom.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ: ' + E.Message);
      ADOTableps.Cancel;
    end;
  end;
end;

procedure TForm2.Button11Click(Sender: TObject);

 begin
 if (Trim(activiteID.Text) = '') or (Trim(activitenum.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTableact.Edit;
    ADOTableact.FieldByName('num_activitè').AsString:= activiteID.Text;
    ADOTableact.FieldByName('nom_activité').AsString := activitenum.Text;
    ADOTableact.Post;
      DBGrid1.DataSource.DataSet.Edit;
    DBGrid1.DataSource.DataSet.FieldByName('num_activitè').AsString:= activiteID.Text;
    DBGrid1.DataSource.DataSet.FieldByName('nom_activité').AsString := activitenum.Text;
     DBGrid1.DataSource.DataSet.Post;
    ShowMessage('تم التعديل بنجاح');
    button11.Visible := false;
     ADOTableact.Refresh;
     activiteID.Clear;
      activitenum.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ: ' + E.Message);
      ADOTableact.Cancel;
    end;
  end;
end;

procedure TForm2.Button12Click(Sender: TObject);
begin
 if (Trim(Editord.Text) = '') or (Trim(editnumord.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTableord.edit;
    ADOTableord.FieldByName('num_ordonnateur').AsString:= Editnumord.Text;
    ADOTableord.FieldByName('ordonnateur').AsString := editord.Text;
    ADOTableord.Post;
    DBGrid1.DataSource.DataSet.Edit;
    DBGrid1.DataSource.DataSet.FieldByName('num_ordonnateur').AsString:= Editnumord.Text;
    DBGrid1.DataSource.DataSet.FieldByName('ordonnateur').AsString := editord.Text;
     DBGrid1.DataSource.DataSet.Post;
    ShowMessage('تم التعديل بنجاح');
    button12.Visible := false;
    ADOTableord.Refresh;
    Editnumord.Clear;
    editord.clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ: ' + E.Message);
      ADOTableord.Cancel;
    end;
  end;
end;

procedure TForm2.Button13Click(Sender: TObject);
 begin
 if (Trim(Editnomprog.Text) = '') or (Trim(editnumprog.Text) = '')  then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  try
    ADOTablepro.edit;
    ADOTablepro.FieldByName('num_programme').AsString:= editnumprog.Text;
    ADOTablepro.FieldByName('nom_programme').AsString := Editnomprog.Text;
    ADOTablepro.Post;
    DBGrid1.DataSource.DataSet.Edit;
    DBGrid1.DataSource.DataSet.FieldByName('num_programme').AsString:= editnumprog.Text;
    DBGrid1.DataSource.DataSet.FieldByName('nom_programme').AsString := Editnomprog.Text;
     DBGrid1.DataSource.DataSet.Post;
    ShowMessage('تم التعديل بنجاح');
    button13.Visible := false;
    ADOTablepro.Refresh;
     editnumprog.Clear;
      Editnomprog.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ أثناء إضافة العملية: ' + E.Message);
      ADOTable1.Cancel;
    end;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  PythonCode: TStringList;
begin
  PythonCode := TStringList.Create;
  try
    PythonCode.LoadFromFile(OpenDialog1.FileName, TEncoding.UTF8);
    PythonEngine1.ExecStrings(PythonCode);
  finally
    PythonCode.Free;
  end
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 DataSource2.DataSet := ADOTableps;
panel2.Visible := true;
label1.Caption :=  'رمز البرنامج الفرعي';
label2.Caption :='عنوان البرنامج الفرعي ';

label4.Caption :='رمز البرنامج الفرعي الذي تريد حذفه';
//الأزرار
Butactiviteadd.Visible:=false;
Butactiviteedit.Visible := false;
Butactivitedel.Visible := false;
Buttonaddord.Visible := false;
Buttondelord.Visible := false;
Buttoneditord.Visible := false;
Buttonaddprog.Visible := false;
Buttondelprog.Visible := false;
Buttoneditprog.Visible := false;
Buttonpedit.Visible := true;
Buttonpadd.Visible := true;
Buttonpdel.Visible := true;
button10.Visible := false;
button11.Visible := false;
button12.Visible := false;
button13.Visible := false;
//edit

editnumord.Visible := false;
activiteID.Visible := false;
activitedel.Visible := false;
Editnumord.Visible := false;

Editprog.Visible :=false;
Editord.Visible := false;
Editnumprog.Visible := false;
Editnomprog.Visible := false;

Editdord.Visible := false;
activitenum.Visible := false;

editpnum.Visible := true;
editpnom.Visible := true;
editpdel.Visible := true;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
if not Assigned(Form3) then
  Form3 := TForm3.Create(Application);  // إنشاء النموذج الفرعي وربطه بالتطبيق

Form3.Show;  // عرض النموذج الفرعي

end;
procedure TForm2.Button4Click(Sender: TObject);
begin
form11.showmodal;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
form4.visible := true;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
form5.Visible:= true;
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
DataSource2.DataSet := ADOTablepro ;
panel2.Visible := true;
label1.Caption :='رمز البرنامج ';
label2.Caption :='عنوان البرنامج';

label4.Caption :='رمز البرنامج الذي تريد حذفه';
//الأزرار
Butactiviteadd.Visible:=false;
Butactiviteedit.Visible := false;
Butactivitedel.Visible := false;
Buttonaddord.Visible := false;
Buttondelord.Visible := false;
Buttoneditord.Visible := false;
Buttonaddprog.Visible := true;
Buttondelprog.Visible := true;
Buttoneditprog.Visible := true;
Buttonpedit.Visible := false;
Buttonpadd.Visible := false;
Buttonpdel.Visible := false;
 button10.Visible := false;
button11.Visible := false;
button12.Visible := false;
button13.Visible := false;
//edit

editnumord.Visible := false;
activiteID.Visible := false;
activitedel.Visible := false;
Editnumord.Visible := false;

Editprog.Visible :=true;
Editord.Visible := false;
Editnumprog.Visible := true;
Editnomprog.Visible := true;

Editdord.Visible := false;
activitenum.Visible := false;

editpnum.Visible := false;
editpnom.Visible := false;
editpdel.Visible := false;
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
DataSource2.DataSet := ADOTableact ;
panel2.Visible := true;
DBGrid1.SelectedRows.Clear;
DBGrid1.DataSource.DataSet.DisableControls;
label1.Caption :='رمز النشاط ';
label2.Caption :='عنوان النشاط';

label4.Caption :='رمز النشاط الذي تريد حذفه';
//الأزرار
Butactiviteadd.Visible:=true;
Butactiviteedit.Visible := true;
Butactivitedel.Visible := true;
Buttonaddord.Visible := false;
Buttondelord.Visible := false;
Buttoneditord.Visible := false;
Buttonaddprog.Visible := false;
Buttondelprog.Visible := false;
Buttoneditprog.Visible := false;
Buttonpedit.Visible := false;
Buttonpadd.Visible := false;
Buttonpdel.Visible := false;
button10.Visible := false;
button11.Visible := false;
button12.Visible := false;
button13.Visible := false;
//edit

editnumord.Visible := false;
activiteID.Visible := true;
activitedel.Visible := true;
activitenum.Visible := true;
Editnumord.Visible := false;

Editprog.Visible := false;
Editord.Visible := false;
Editnumprog.Visible := false;
Editnomprog.Visible := false;

Editdord.Visible := false;

editpnum.Visible := false;
editpnom.Visible := false;
editpdel.Visible := false;

end;

procedure TForm2.Button9Click(Sender: TObject);
begin
DataSource2.DataSet := adotableord;
DBGrid1.DataSource := DataSource2;
 DBGrid1.SelectedRows.Clear;
  DBGrid1.DataSource.DataSet.DisableControls;
label1.Caption :='رمز الأمر بالصرف ';
label2.Caption :='عنوان الأمر بالصرف';

label4.Caption :='رمز الأمر بالصرف الذي تريد حذفه';
panel2.Visible := true;
//الأزرار
Butactiviteadd.Visible:=false;
Butactiviteedit.Visible := false;
Butactivitedel.Visible := false;
Buttonaddord.Visible := true;
Buttondelord.Visible := true;
Buttoneditord.Visible := true;
Buttonaddprog.Visible := false;
Buttondelprog.Visible := false;
Buttoneditprog.Visible := false;
Buttonpedit.Visible := false;
Buttonpadd.Visible := false;
Buttonpdel.Visible := false;
button10.Visible := false;
button11.Visible := false;
button12.Visible := false;
button13.Visible := false;
//edit

editnumord.Visible := true;
activiteID.Visible := false;
activitedel.Visible := false;
Editnumord.Visible := true;

Editprog.Visible := false;
Editord.Visible := true;
Editnumprog.Visible := false;
Editnomprog.Visible := false;

Editdord.Visible := true;
activitenum.Visible := false;

editpnum.Visible := false;
editpnom.Visible := false;
editpdel.Visible := false;
end;

procedure TForm2.SkAnimatedImage1Click(Sender: TObject);
begin
panel2.Visible := false;
end;

procedure TForm2.SkAnimatedImage2Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm2.SkAnimatedImage3Click(Sender: TObject);
begin
    WindowState := wsNormal;
    SkAnimatedImage3.Visible := false;
    SkAnimatedImage4.Visible := true;
end;

procedure TForm2.SkAnimatedImage4Click(Sender: TObject);

begin
     WindowState := wsMaximized;
  SkAnimatedImage3.Visible := true;
    SkAnimatedImage4.Visible := false;
end;

procedure TForm2.SkAnimatedImage5Click(Sender: TObject);
begin
Form2.Visible := True; // تأكد من أن النافذة مرئية
Form2.WindowState := wsMinimized;

end;

end.
