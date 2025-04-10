unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, Vcl.StdCtrls, Vcl.ExtCtrls, System.Skia, Vcl.Skia,
  Vcl.NumberBox, frxSmartMemo, frCoreClasses, frxClass, Vcl.ComCtrls,
  Vcl.DBCtrls, Vcl.Menus;

type
  TForm4 = class(TForm)
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SkAnimatedImage1: TSkAnimatedImage;
    Memo1: TMemo;
    NumberBox1: TNumberBox;
    Edit1: TEdit;
    ADOConnection1: TADOConnection;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo2: TMemo;
    NumberBox2: TNumberBox;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Button4: TButton;
    Button2: TButton;
    Button3: TButton;
    SkAnimatedImage3: TSkAnimatedImage;
    Label7: TLabel;
    frxReport1: TfrxReport;
    Button5: TButton;
    ComboBox2: TComboBox;
    ADOQuery1: TADOQuery;
    PopupMenu1: TPopupMenu;
    Deleteoperation1: TMenuItem;
    Button6: TButton;
    procedure DBGrid1Enter(Sender: TObject);
    procedure SkAnimatedImage1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SkAnimatedImage3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Deleteoperation1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses Unit8, Unit9;

procedure TForm4.Button1Click(Sender: TObject);
begin
panel1.Visible := True;
end;

procedure TForm4.Button2Click(Sender: TObject);
var
licenseValue: Currency;
begin
if (Trim(Edit1.Text) = '') or (Trim(Memo1.Text) = '') or (NumberBox1.Value = 0) then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  licenseValue := NumberBox1.Value;


  try
    ADOTable1.append;
    ADOTable1.FieldByName('num_opération').Asstring := Edit1.Text;
    ADOTable1.FieldByName('titre_opération').AsString :=Memo1.Text;
    ADOTable1.FieldByName('License').AsCurrency := licenseValue;
    ADOTable1.FieldByName('année').AsString  := combobox2.text;
    ADOTable1.Post;
    ShowMessage('تمت الاضافة بنجاح');
    ADOTable1.Refresh;
    Edit1.clear;
     Memo1.clear;
     NumberBox1.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ أثناء إضافة العملية: ' + E.Message);
      ADOTable1.Cancel;
    end;
  end;
end;

procedure TForm4.Button3Click(Sender: TObject);
 var
licenseValue: Currency;
begin
if (Trim(Edit2.Text) = '') or (Trim(Memo2.Text) = '') or (NumberBox2.Value = 0) then
  begin
    ShowMessage('يرجى إدخال جميع الحقول!');
    Exit;
  end;

  licenseValue := NumberBox2.Value;


  try
    ADOTable1.edit;
    ADOTable1.FieldByName('num_opération').Asstring := Edit2.Text;
    ADOTable1.FieldByName('titre_opération').AsString :=Memo2.Text;
    ADOTable1.FieldByName('License').AsCurrency := licenseValue;
    ADOTable1.Post;
    ShowMessage('تم التعديل بنجاح');
    ADOTable1.Filtered := false;
    ADOTable1.Refresh;
    Edit2.clear;
     Memo2.clear;
     NumberBox2.Clear;
  except
    on E: Exception do
    begin
      ShowMessage('حدث خطأ أثناء إضافة العملية: ' + E.Message);
      ADOTable1.Cancel;
    end;
  end;
end;



procedure TForm4.Button4Click(Sender: TObject);
begin
panel2.Visible:= true;
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
   form9.Button1.Visible:= true;
  form9.Button2.Visible:= true;
  form9.SpeedButton1.Visible:= true;
  form9.memo1.Visible:= true;
  form9.edit5.Visible:= true;
   form9.label6.Visible:= true;
    form9.label5.Visible:= true;
form9.Button3.Visible:= false;
 form9.showmodal;

end;

procedure TForm4.Button6Click(Sender: TObject);
begin
  form9.Button1.Visible:= false;
  form9.Button2.Visible:= false;
  form9.SpeedButton1.Visible:= false;
  form9.memo1.Visible:= false;
  form9.edit5.Visible:= false;
  form9.label5.Visible:= false;
  form9.label6.Visible:= false;
  form9.Button3.Visible:= true;
  form9.showmodal;


end;

procedure TForm4.ComboBox1Change(Sender: TObject);
var
  SelectedID: string; // القيمة الحرفية لـ num_opération
begin
  if ComboBox1.ItemIndex >= 0 then
  begin
    // الحصول على القيمة الحرفية لـ num_opération من ComboBox
    SelectedID := ComboBox1.Text; // أو ComboBox1.Items[ComboBox1.ItemIndex]

    // فلترة الجدول حسب num_opération (حرفي)
    ADOTable1.Close;
    ADOTable1.TableName := 'opération'; // تأكد من أن اسم الجدول صحيح
    ADOTable1.Filter := 'num_opération = ''' + SelectedID + ''''; // إضافة علامات تنصيص للنص
    ADOTable1.Filtered := True;
    ADOTable1.Open;

    // التحقق من وجود بيانات
    if ADOTable1.RecordCount > 0 then
    begin
      Edit2.Text := ADOTable1.FieldByName('num_opération').AsString;
      Memo2.Text := ADOTable1.FieldByName('titre_opération').AsString;
      NumberBox2.Text := ADOTable1.FieldByName('License').AsString;
    end
    else
    begin
      ShowMessage('لا توجد بيانات مطابقة للرقم المحدد');
      Edit2.Clear;
      Memo2.Clear;
      NumberBox2.Clear;
    end;
  end
  else
  begin
    ShowMessage('رجاء تحديد عنصر من القائمة');
  end;
end;

procedure TForm4.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  InitialBalance, Threshold: Double;
begin
  // تأكد من أن DataSource و DataSet مرتبطين بشكل صحيح بـ DBGrid
  if DBGrid1.DataSource <> nil then
  begin
    if DBGrid1.DataSource.DataSet <> nil then
    begin
      // الوصول إلى الحقل المرتبط بالرصيد الأولي في DataSet
      InitialBalance := DBGrid1.DataSource.DataSet.FieldByName('solde_initial').AsFloat;  // استبدل 'InitialBalance' بالحقل الصحيح

      Threshold := 0.10; // 10% كنسبة مئوية

      // إذا كانت القيمة أقل من 10%
      if InitialBalance < (Threshold * 100) then
      begin
        // تغيير لون الخلفية إلى اللون الأصفر
        DBGrid1.Canvas.Brush.Color := clYellow;
      end;
    end;
  end;

  // استدعاء DefaultDrawColumnCell لرسم الخلية مع التعديلات
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TForm4.DBGrid1Enter(Sender: TObject);
begin
DBGrid1.Columns[1].Width := 300;
DBGrid1.Columns[2].Width := 500;
DBGrid1.Font.Charset := ARABIC_CHARSET;
DBGrid1.Font.Name := 'arial'; // أو أي خط يدعم اللغة العربية

end;

procedure TForm4.Deleteoperation1Click(Sender: TObject);
var
  SQLQuery: string;
begin
  try
    // ابدأ معاملة قاعدة البيانات لضمان تنفيذ جميع الأوامر معًا
    ADOConnection1.BeginTrans;

    // استعلام لحفظ العملية المحذوفة في جدول الأرشيف Opérationarchif
    SQLQuery := 'INSERT INTO Opérationarchif (id_opérationar, num_opération, titre_opération, année, License, total_engagements, solde_initial, solde_restant, crédits_paiement) ' +
                'SELECT id_opération, num_opération, titre_opération, année, License, total_engagements, solde_initial, solde_restant, crédits_paiment ' +
                'FROM Opération WHERE id_opération = :OperationID';
    ADOQuery1.SQL.Text := SQLQuery;
    ADOQuery1.Parameters.ParamByName('OperationID').Value := DBGrid1.DataSource.DataSet.FieldByName('id_opération').AsInteger;
    ADOQuery1.ExecSQL;

    // استعلام لحفظ بطاقات الالتزام المرتبطة بالعملية المحذوفة في جدول الأرشيف EngagementCartearchif
    SQLQuery := 'INSERT INTO EngagementCartearchif (id_carte, id_opérationar, id_programme, id_activité, id_sous_programme, id_ordonnateur, engagement_proposé, num_carte, objet_engagement, Contrat_avec, total_engagements, solde_initial, solde_restant, id_opération) ' +
                'SELECT id_carte, id_opération, id_programme, id_activité, id_sous_programme, id_ordonnateur, engagement_proposé, num_carte, objet_engagement, Contrat_avec, total_engagements, solde_initial, solde_restant, id_opération ' +
                'FROM EngagementCarte WHERE id_opération = :OperationID';
    ADOQuery1.SQL.Text := SQLQuery;
    ADOQuery1.Parameters.ParamByName('OperationID').Value := DBGrid1.DataSource.DataSet.FieldByName('id_opération').AsInteger;
    ADOQuery1.ExecSQL;

    // استعلام لحذف البطاقات المرتبطة من جدول EngagementCarte
    SQLQuery := 'DELETE FROM EngagementCarte WHERE id_opération = :OperationID';
    ADOQuery1.SQL.Text := SQLQuery;
    ADOQuery1.Parameters.ParamByName('OperationID').Value := DBGrid1.DataSource.DataSet.FieldByName('id_opération').AsInteger;
    ADOQuery1.ExecSQL;

    // استعلام لحذف العملية من جدول Opération
    SQLQuery := 'DELETE FROM Opération WHERE id_opération = :OperationID';
    ADOQuery1.SQL.Text := SQLQuery;
    ADOQuery1.Parameters.ParamByName('OperationID').Value := DBGrid1.DataSource.DataSet.FieldByName('id_opération').AsInteger;
    ADOQuery1.ExecSQL;

    // تأكيد المعاملة
    ADOConnection1.CommitTrans;
  except
    on E: Exception do
    begin
      // في حالة حدوث خطأ، يتم إلغاء المعاملة
      ADOConnection1.RollbackTrans;
      ShowMessage('Error: ' + E.Message);
    end;
  end;
end;


procedure TForm4.FormCreate(Sender: TObject);

var
  StartYear, EndYear, Year: Integer;
begin
  // تحديد سنة البداية والنهاية
  StartYear := 2015;
  EndYear := CurrentYear;; // السنة الحالية (تلقائيًا)


  // إفراغ ComboBox أولاً
  ComboBox2.Clear;

  // إضافة السنوات من StartYear إلى EndYear
  for Year := StartYear to EndYear do
  begin
    ComboBox2.Items.Add(IntToStr(Year));
  end;

  // اختيار السنة الحالية بشكل افتراضي (اختياري)
  ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(IntToStr(EndYear));
   ADOTable1.Open;


ComboBox1.Clear;
ADOTable1.First;
while not ADOTable1.Eof do
begin
  ComboBox1.Items.AddObject(
    ADOTable1.FieldByName('num_opération').AsString,  // تم تعديل هذا السطر
    TObject(ADOTable1.FieldByName('num_opération').Asstring));
  ADOTable1.Next;
end;

  NumberBox1.SpinButtonOptions.Placement := nbspNone;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  Memo1.Clear;

end;

procedure TForm4.SkAnimatedImage1Click(Sender: TObject);
begin
panel1.Visible := false;


end;

procedure TForm4.SkAnimatedImage3Click(Sender: TObject);
begin
 panel2.Visible := false;
 ADOTable1.Filtered := false;
end;

end.
