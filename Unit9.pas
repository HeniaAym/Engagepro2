unit Unit9;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxSmartMemo, Data.DB, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids, frxClass, frxDBSet, frCoreClasses, Vcl.StdCtrls,
  frxExportBaseDialog, frxExportBaseImageSettingsDialog, frxExportXLS,
  frxExportXLSX, frDPIAwareControls, frxDPIAwareBaseControls, frxPreview,
  frxExportCSV, Vcl.Menus,System.Generics.Collections, Datasnap.DBClient,
  Vcl.Buttons, frxDesgn, Math ,TypInfo, System.Skia, Vcl.Skia;

type

  TForm9 = class(TForm)
    frxReport1: TfrxReport;
    ADOConnection1: TADOConnection;
    frxDBDataset1: TfrxDBDataset;
    DataSource1: TDataSource;

    Button1: TButton;
    TempCDS: TClientDataSet;
    Edit1: TEdit;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    ANEX041: TMenuItem;
    SpeedButton1: TSpeedButton;
    MainMenu1: TMainMenu;
    Edit2: TMenuItem;
    Edit3: TMenuItem;
    frxDesigner1: TfrxDesigner;
    DataSource2: TDataSource;
    Button2: TButton;
    DBGrid1: TDBGrid;
    ANEX011: TMenuItem;
    ALLPrintANEX021: TMenuItem;
    Edit4: TEdit;
    Label1: TLabel;
    ADOTable1: TADOTable;
    SkAnimatedImage1: TSkAnimatedImage;
    EditHeaderraport1: TMenuItem;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    Memo1: TMemo;
    Label6: TLabel;
    Button3: TButton;
    ADOQuery1: TADOQuery;
    frxDBDataset2: TfrxDBDataset;
    ComboBox3: TComboBox;
    ALLPrintDPCA1: TMenuItem;
    Label7: TLabel;
    TempCDS2: TClientDataSet;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ANEX041Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ANEX011Click(Sender: TObject);
    procedure ALLPrintANEX021Click(Sender: TObject);
    procedure SkAnimatedImage1Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ALLPrintDPCA1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}







procedure TForm9.ALLPrintANEX021Click(Sender: TObject);
var
   TotalSum: Double;
begin
TotalSum := 0.00;
  if not DataSource1.DataSet.Active then
    Exit;
  DataSource1.DataSet.DisableControls;
  try
    DataSource1.DataSet.First;
    while not DataSource1.DataSet.Eof do
    begin
      TotalSum :=    TotalSum + DataSource1.DataSet.FieldByName('total_engagements').AsFloat;
      DataSource1.DataSet.Next;
    end;
  finally

    DataSource1.DataSet.EnableControls;
end;
      ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;


  frxDBDataset2.DataSet :=  DataSource2.DataSet;


  frxReport1.LoadFromFile('D:\Management System\report\AN02.fr3');
  frxReport1.Variables['TotalSum'] := FloatToStr(TotalSum);
  frxReport1.Variables['Content'] := QuotedStr(memo1.Text);
  frxReport1.Variables['CODE'] := QuotedStr(Edit5.Text);
  frxDBDataset1.DataSet := DataSource1.DataSet;

  // عرض التقرير
  frxReport1.ShowReport;
end;

procedure TForm9.ALLPrintDPCA1Click(Sender: TObject);
var
  TotalSum: Double;
  Totacredits: Double;
   mid: Integer;
   Totallicense: Double;
begin
  TotalSum := 0.00;    // تهيئة صريحة
  Totacredits := 0.00;
  Totallicense := 0.00;

// تأكد من أن الـ DataSet مفتوح
  if not DataSource1.DataSet.Active then
    Exit;

  // حفظ موضع السجل الحالي
  DataSource1.DataSet.DisableControls; // لتعطيل التحديثات أثناء الحساب
  try
    DataSource1.DataSet.First; // الانتقال إلى السجل الأول

    // المرور على جميع السجلات
    while not DataSource1.DataSet.Eof do
    begin

      Totacredits :=    Totacredits + DataSource1.DataSet.FieldByName('crédits_paiment').AsFloat;
      TotalSum := TotalSum + DataSource1.DataSet.FieldByName('total_engagements').AsFloat;
      Totallicense :=  Totallicense + DataSource1.DataSet.FieldByName('License').AsFloat;
       DataSource1.DataSet.Next;
    end;
  finally
    // إعادة التحكم بالتحديثات
    DataSource1.DataSet.EnableControls;
  end;

      ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;

  // تحميل التقرير وربطه ببيانات TempCDS
  frxReport1.LoadFromFile('D:\Management System\report\DPCA.fr3');
  TfrxMemoView(frxReport1.FindObject('Memo37')).Text := FloatToStrF(Totallicense, ffNumber, 10, 2);
  TfrxMemoView(frxReport1.FindObject('Memo39')).Text := FloatToStrF(TotalSum, ffNumber, 10, 2);
  TfrxMemoView(frxReport1.FindObject('Memo42')).Text := FloatToStrF(Totacredits, ffNumber, 10, 2);
  frxDBDataset1.DataSet := DataSource1.DataSet;
   frxDBDataset2.DataSet :=  DataSource2.DataSet;
  mid := (frxDBDataset1.RecordCount + 1) div 2;
  frxReport1.Variables['MiddleRec'] := mid;
  frxReport1.ShowReport;
end;


procedure TForm9.ANEX011Click(Sender: TObject);
var
   Totacredits: Double;
begin
Totacredits := 0.00;
  if not DataSource1.DataSet.Active then
    Exit;
  DataSource1.DataSet.DisableControls;
  try
    DataSource1.DataSet.First;
    while not DataSource1.DataSet.Eof do
    begin
      Totacredits :=    Totacredits + DataSource1.DataSet.FieldByName('crédits_paiment').AsFloat;
      DataSource1.DataSet.Next;
    end;
  finally

    DataSource1.DataSet.EnableControls;
end;
    ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;


  frxDBDataset2.DataSet :=  DataSource2.DataSet;

  frxReport1.LoadFromFile('D:\Management System\report\AN01.fr3');
  frxReport1.Variables['Totacredits'] := FloatToStr(Totacredits);
      frxReport1.Variables['Content'] := QuotedStr(memo1.Text);
  frxReport1.Variables['CODE'] := QuotedStr(Edit5.Text);
  frxDBDataset1.DataSet := DataSource1.DataSet;

  // عرض التقرير
  frxReport1.ShowReport;
end;

procedure TForm9.ANEX041Click(Sender: TObject);
var
  TotalSum: Double;
   Totacredits: Double;
begin
TotalSum := 0.00;    // تهيئة صريحة
Totacredits := 0.00;

  // تأكد من أن الـ DataSet مفتوح
  if not DataSource1.DataSet.Active then
    Exit;

  // حفظ موضع السجل الحالي
  DataSource1.DataSet.DisableControls; // لتعطيل التحديثات أثناء الحساب
  try
    DataSource1.DataSet.First; // الانتقال إلى السجل الأول

    // المرور على جميع السجلات
    while not DataSource1.DataSet.Eof do
    begin
      // جمع القيم من الحقل المطلوب (استبدل FieldName باسم الحقل المراد)

      Totacredits :=    Totacredits + DataSource1.DataSet.FieldByName('crédits_paiment').AsFloat;
      TotalSum := TotalSum + DataSource1.DataSet.FieldByName('total_engagements').AsFloat;

      DataSource1.DataSet.Next; // الانتقال إلى السجل التالي
    end;
  finally
    // إعادة التحكم بالتحديثات
    DataSource1.DataSet.EnableControls;
  end;
         ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;


  frxDBDataset2.DataSet :=  DataSource2.DataSet;

  // عرض المجموع في Edit أو Label مثلاً
  frxReport1.LoadFromFile('D:\Management System\report\ANEX04.fr3');
  TfrxMemoView(frxReport1.FindObject('Memo16')).Text := FloatToStrF(TotalSum, ffNumber, 10, 2);
  TfrxMemoView(frxReport1.FindObject('Memo17')).Text := FloatToStrF(Totacredits, ffNumber, 10, 2);
  frxDBDataset1.DataSet := DataSource1.DataSet;

  // عرض التقرير
  frxReport1.ShowReport;
end;

procedure TForm9.Button1Click(Sender: TObject);
var
  BM: TBookmark;
  i: Integer;
var
  TotalSum: Double;
  Totacredits: Double;
begin

  TotalSum := 0.00;    // تهيئة صريحة
  Totacredits := 0.00;

  if not TempCDS.Active then
  begin
    with TempCDS.FieldDefs do
    begin
      Clear;
      Add('num_opération', ftString, 40);
      TempCDS.FieldDefs.Add('titre_opération', ftWideString, 255);
      Add('total_engagements', ftFloat);
      Add('crédits_paiment', ftFloat);
    end;
    TempCDS.CreateDataSet;
    TempCDS.Open;
  end
  else
    TempCDS.EmptyDataSet;

  with DBGrid1 do
  begin
    for i := 0 to SelectedRows.Count - 1 do
    begin
      BM := SelectedRows.Items[i];
      DataSource.DataSet.GotoBookmark(BM);

      TempCDS.Append;
      TempCDS.FieldByName('num_opération').Value := DataSource.DataSet.FieldByName('num_opération').Value;
      TempCDS.FieldByName('titre_opération').Value := DataSource.DataSet.FieldByName('titre_opération').Value;
      TempCDS.FieldByName('total_engagements').Value := DataSource.DataSet.FieldByName('total_engagements').Value;
      TempCDS.FieldByName('crédits_paiment').Value := DataSource.DataSet.FieldByName('crédits_paiment').Value;
      TempCDS.Post;

      Totacredits :=    Totacredits + DataSource.DataSet.FieldByName('crédits_paiment').AsFloat;
      TotalSum := TotalSum + DataSource.DataSet.FieldByName('total_engagements').AsFloat;
    end;
  end;

                   ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;


  frxDBDataset2.DataSet :=  DataSource2.DataSet;
  // تحميل التقرير وربطه ببيانات TempCDS
  frxReport1.LoadFromFile('D:\Management System\report\ANEX04.fr3');
  TfrxMemoView(frxReport1.FindObject('Memo16')).Text := FloatToStrF(TotalSum, ffNumber, 10, 2);
  TfrxMemoView(frxReport1.FindObject('Memo17')).Text := FloatToStrF(Totacredits, ffNumber, 10, 2);
    frxReport1.Variables['Content'] := QuotedStr(memo1.Text);
  frxReport1.Variables['CODE'] := QuotedStr(Edit5.Text);
  frxDBDataset1.DataSet := TempCDS;

  // عرض التقرير
  frxReport1.ShowReport;


end;

procedure TForm9.Button2Click(Sender: TObject);
var
  BM: TBookmark;
  i: Integer;
  TotalSum: Double;
begin
  TotalSum := 0.00;

  // التأكد من أن `TempCDS2` مفتوح قبل الاستخدام
  if not TempCDS2.Active then
  begin
    TempCDS2.FieldDefs.Clear;
    with TempCDS2.FieldDefs do
    begin
      Add('num_opération', ftString, 40);
      Add('titre_opération', ftWideString, 255);
      Add('total_engagements', ftFloat);
    end;
    TempCDS2.CreateDataSet;
  end
  else
    TempCDS2.EmptyDataSet;

  // معالجة البيانات المختارة من DBGrid1
  with DBGrid1 do
  begin
    for i := 0 to SelectedRows.Count - 1 do
    begin
      BM := SelectedRows.Items[i];
      DataSource.DataSet.GotoBookmark(BM);

      if not TempCDS2.Active then
        TempCDS2.Open;

      // تأكد أن السجل الجديد مضاف بشكل صحيح
      TempCDS2.Append;
      try
        TempCDS2.FieldByName('num_opération').AsString := DataSource.DataSet.FieldByName('num_opération').AsString;
        TempCDS2.FieldByName('titre_opération').AsString := DataSource.DataSet.FieldByName('titre_opération').AsString;
        TempCDS2.FieldByName('total_engagements').AsFloat := DataSource.DataSet.FieldByName('total_engagements').AsFloat;
        TempCDS2.Post;  // تأكيد الحفظ بعد الإضافة
      except
        TempCDS2.Cancel;  // إلغاء الإضافة في حالة وجود خطأ
        raise;  // إعادة إرسال الخطأ لعرضه
      end;

      // حساب المجموع الإجمالي
      TotalSum := TotalSum + DataSource.DataSet.FieldByName('total_engagements').AsFloat;
    end;
  end;

  // إعداد `ADOQuery1`
  ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text;
  ADOQuery1.Open;

  // إعداد التقرير
  frxDBDataset2.DataSet := DataSource2.DataSet;
  frxReport1.LoadFromFile('D:\Management System\report\AN02.fr3');
  frxReport1.Variables['TotalSum'] := FloatToStr(TotalSum);
  frxReport1.Variables['Content'] := QuotedStr(memo1.Text);
  frxReport1.Variables['CODE'] := QuotedStr(Edit5.Text);
  frxDBDataset1.DataSet := TempCDS2;

  // عرض التقرير
  frxReport1.ShowReport;

  // تنظيف البيانات بعد الطباعة
  TempCDS2.EmptyDataSet;
end;


procedure TForm9.Button3Click(Sender: TObject);
var
  BM: TBookmark;
  i: Integer;
var
  TotalSum: Double;
  Totacredits: Double;
   mid: Integer;
   Totallicense: Double;
begin
  TotalSum := 0.00;    // تهيئة صريحة
  Totacredits := 0.00;
  Totallicense := 0.00;
  if not TempCDS.Active then
  begin
     TempCDS.FieldDefs.Clear;
    with TempCDS.FieldDefs do
    begin
      Clear;
      Add('num_opération', ftString, 40);
      TempCDS.FieldDefs.Add('titre_opération', ftWideString, 255);
      Add('total_engagements', ftFloat);
      Add('crédits_paiment', ftFloat);
      Add('License', ftFloat);
    end;
    TempCDS.CreateDataSet;
    TempCDS.Open;
  end
  else
    TempCDS.EmptyDataSet;

  with DBGrid1 do
  begin
    for i := 0 to SelectedRows.Count - 1 do
    begin
      BM := SelectedRows.Items[i];
      DataSource.DataSet.GotoBookmark(BM);

      TempCDS.Append;
      TempCDS.FieldByName('num_opération').Value := DataSource.DataSet.FieldByName('num_opération').Value;
      TempCDS.FieldByName('titre_opération').Value := DataSource.DataSet.FieldByName('titre_opération').Value;
      TempCDS.FieldByName('total_engagements').Value := DataSource.DataSet.FieldByName('total_engagements').Value;
      TempCDS.FieldByName('crédits_paiment').Value := DataSource.DataSet.FieldByName('crédits_paiment').Value;
      TempCDS.FieldByName('License').Value := DataSource.DataSet.FieldByName('License').Value;
      TempCDS.Post;

      Totacredits :=    Totacredits + DataSource.DataSet.FieldByName('crédits_paiment').AsFloat;
      TotalSum := TotalSum + DataSource.DataSet.FieldByName('total_engagements').AsFloat;
      Totallicense :=  Totallicense + DataSource.DataSet.FieldByName('License').AsFloat;
    end;
  end;

      ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;

  // تحميل التقرير وربطه ببيانات TempCDS
  frxReport1.LoadFromFile('D:\Management System\report\DPCA.fr3');
  TfrxMemoView(frxReport1.FindObject('Memo37')).Text := FloatToStrF(Totallicense, ffNumber, 10, 2);
  TfrxMemoView(frxReport1.FindObject('Memo39')).Text := FloatToStrF(TotalSum, ffNumber, 10, 2);
  TfrxMemoView(frxReport1.FindObject('Memo42')).Text := FloatToStrF(Totacredits, ffNumber, 10, 2);
  frxDBDataset1.DataSet := TempCDS;
   frxDBDataset2.DataSet :=  DataSource2.DataSet;
  mid := (frxDBDataset1.RecordCount + 1) div 2;
  frxReport1.Variables['MiddleRec'] := mid;
  frxReport1.ShowReport;
end;

procedure TForm9.Button4Click(Sender: TObject);
begin
 frxReport1.LoadFromFile('D:\Management System\report\DPCA.fr3');
  frxReport1.ShowReport;

end;

procedure TForm9.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  searchText: string;
  found: Boolean;
  i: Integer;
    Text: string;
  DrawRect: TRect;
begin
  searchText := LowerCase(Edit1.Text);
  found := False;

  // تفحص جميع الأعمدة في الصف للتأكد من وجود النص
  if searchText <> '' then
    for i := 0 to DBGrid1.Columns.Count - 1 do
      if Pos(searchText, LowerCase(DBGrid1.Columns[i].Field.AsString)) > 0 then
      begin
        found := True;
        Break;
      end;

  if found then
    DBGrid1.Canvas.Brush.Color := clYellow
  else
    DBGrid1.Canvas.Brush.Color := clWindow;

  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  with DBGrid1.Canvas do
  begin
    FillRect(Rect); // Clear the cell
    Text := Column.Field.AsString;
    DrawRect := Rect;
    DrawText(Handle, PChar(Text), Length(Text), DrawRect, DT_WORDBREAK or DT_LEFT or DT_NOPREFIX);
  end;
end;


procedure TForm9.Edit1Change(Sender: TObject);
begin
DBGrid1.Repaint;
end;

procedure TForm9.Edit1Enter(Sender: TObject);
begin
   if Edit1.Text = 'البحث لتحديد حقول' then
  begin
    Edit1.Text := '';  // امسح النص
    Edit1.Font.Color := clWindowText;  // غيّر لون الخط للنص العادي
  end;
end;

procedure TForm9.Edit1Exit(Sender: TObject);
begin
  // إذا كان الحقل فارغًا بعد الخروج، أعد النص الإرشادي
  if Edit1.Text = '' then
  begin
    Edit1.Text := 'البحث لتحديد حقول';  // ضع النص الإرشادي
    Edit1.Font.Color := clGray;  // غيّر لون الخط ليدل على أنه إرشادي
  end;
end;

procedure TForm9.Edit3Click(Sender: TObject);
begin
frxReport1.LoadFromFile('D:\Management System\report\ANEX04.fr3');
frxReport1.DesignReport()
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
   // عند إنشاء النموذج، ضع النص الإرشادي الافتراضي
  Edit1.Text := 'البحث لتحديد حقول';
  Edit1.Font.Color := clGray;  // غيّر لون الخط ليدل على أنه إرشادي
  memo1.Clear;
    ADOQuery1.SQL.Text := 'SELECT num_programme FROM Programme';
  ADOQuery1.Open;
  ComboBox1.Items.Clear;
  while not ADOQuery1.Eof do
  begin
    ComboBox1.Items.Add(ADOQuery1.FieldByName('num_programme').AsString);
    ADOQuery1.Next;
  end;
  ADOQuery1.Close;

  // لملء ComboBox2 بالقيم من جدول Activité
  ADOQuery1.SQL.Text := 'SELECT num_activitè FROM Activité';
  ADOQuery1.Open;
  ComboBox2.Items.Clear;
  while not ADOQuery1.Eof do
  begin
    ComboBox2.Items.Add(ADOQuery1.FieldByName('num_activitè').AsString);
    ADOQuery1.Next;
  end;
  ADOQuery1.Close;

  // لملء ComboBox3 بالقيم من جدول sous_programme
  ADOQuery1.SQL.Text := 'SELECT num_sous_programme FROM sous_programme';
  ADOQuery1.Open;
  ComboBox3.Items.Clear;
  while not ADOQuery1.Eof do
  begin
    ComboBox3.Items.Add(ADOQuery1.FieldByName('num_sous_programme').AsString);
    ADOQuery1.Next;
  end;
  ADOQuery1.Close;
end;

procedure TForm9.SkAnimatedImage1Click(Sender: TObject);
var
  searchTerm: string;
begin
  // الحصول على النص المدخل من المستخدم
  searchTerm := Edit4.Text;

  // تعيين الفلترة بناءً على النص المدخل
  ADOTable1.Filter := 'num_opération LIKE ''%' + searchTerm + '%''';
  ADOTable1.Filtered := True;
end;

procedure TForm9.SpeedButton1Click(Sender: TObject);
var
  BM: TBookmark;
  i: Integer;
var
  Totacredits: Double;
begin
  Totacredits := 0.00;
    TempCDS.Close;        // إغلاق مجموعة البيانات بعد الطباعة
  TempCDS.Open;         // فتح مجموعة البيانات مرة أخرى
  TempCDS.EmptyDataSet;
  if not TempCDS.Active then
  begin
     TempCDS.FieldDefs.Clear;
    with TempCDS.FieldDefs do

    begin
      Clear;
      Add('num_opération', ftString, 40);
      TempCDS.FieldDefs.Add('titre_opération', ftWideString, 255);
      Add('crédits_paiment', ftFloat);
    end;
    TempCDS.CreateDataSet;
    TempCDS.Open;
  end
  else
    TempCDS.EmptyDataSet;

  with DBGrid1 do
  begin
    for i := 0 to SelectedRows.Count - 1 do
    begin
      BM := SelectedRows.Items[i];
      DataSource.DataSet.GotoBookmark(BM);

      TempCDS.Append;
      TempCDS.FieldByName('num_opération').Value := DataSource.DataSet.FieldByName('num_opération').Value;
      TempCDS.FieldByName('titre_opération').Value := DataSource.DataSet.FieldByName('titre_opération').Value;
      TempCDS.FieldByName('crédits_paiment').Value := DataSource.DataSet.FieldByName('crédits_paiment').Value;
      TempCDS.Post;

      Totacredits :=    Totacredits + DataSource.DataSet.FieldByName('crédits_paiment').AsFloat;
    end;
  end;
        ADOQuery1.SQL.Text := 'SELECT Programme.num_programme , ' +
                        'Programme.nom_programmefr, ' +
                        'Activité.num_activitè , ' +
                        'Activité.nom_activité, ' +
                        'sous_programme.num_sous_programme, ' +
                        'sous_programme.nom_sous_programmefr  ' +
                        'FROM Programme, Activité, sous_programme ' +
                        'WHERE Programme.num_programme = :num_programme ' +
                        'AND Activité.num_activitè = :num_activitè ' +
                        'AND sous_programme.num_sous_programme = :num_sous_programme';

  // تعيين قيم الباراميترز (تعديل القيم بناءً على التطبيق)
  ADOQuery1.Parameters.ParamByName('num_programme').Value := ComboBox1.Text;  // على فرض أن القيم مخزنة في ComboBox1
  ADOQuery1.Parameters.ParamByName('num_activitè').Value := ComboBox2.Text;   // على فرض أن القيم مخزنة في ComboBox2
  ADOQuery1.Parameters.ParamByName('num_sous_programme').Value := ComboBox3.Text; // على فرض أن القيم مخزنة في ComboBox3
  ADOQuery1.Open;



  // تحميل التقرير وربطه ببيانات TempCDS
  frxReport1.LoadFromFile('D:\Management System\report\AN01.fr3');
  frxReport1.Variables['Totacredits'] := FloatToStr(Totacredits);
  frxReport1.Variables['Content'] := QuotedStr(memo1.Text);
  frxReport1.Variables['CODE'] := QuotedStr(Edit5.Text);

  frxDBDataset2.DataSet :=  DataSource2.DataSet;
   frxDBDataset1.DataSet := TempCDS;
  // عرض التقرير
  frxReport1.ShowReport;
end;

end.
