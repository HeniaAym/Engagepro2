unit Unit5;

interface

uses
  System.UITypes,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  frxSmartMemo, frxClass, frxDBSet, frCoreClasses, Vcl.Grids, Vcl.DBGrids,
  frxDesgn, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls, System.Skia, Vcl.Skia;

type
  TForm5 = class(TForm)
    cboProgram: TComboBox;
    edtEngagementPropose: TEdit;
    cboActivity: TComboBox;
    cboSousProgram: TComboBox;
    cboOrderer: TComboBox;
    ADOConnection1: TADOConnection;
    ADOTableOperation: TADOTable;
    DataSource1: TDataSource;
    ADOTableEngagementCarte: TADOTable;
    Button1: TButton;
    ADOTable1: TADOTable;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ADOQProgram: TADOQuery;
    ADOQOrderer: TADOQuery;
    ADOQSousProgram: TADOQuery;
    ADOQActivity: TADOQuery;
    cboOperation: TComboBox;
    ADOQoperation: TADOQuery;
    Memo1: TMemo;
    Editcontrat: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    ADOTablecontrat: TADOTable;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    ADOQuery1: TADOQuery;
    ButtonEdit: TButton;
    frxReport2: TfrxReport;
    PopupMenu1: TPopupMenu;
    Print1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    ComboBox: TComboBox;
    DBGrid1: TDBGrid;
    ADOQueryLastNumCarte: TADOQuery;
    ADOQuery2: TADOQuery;
    ButtonSave: TButton;
    ProgressBar1: TProgressBar;
    DataSource2: TDataSource;
    N1: TMenuItem;
    ADOQuery3: TADOQuery;
    Edit2: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure cboProgramEnter(Sender: TObject);
    procedure cboOrdererEnter(Sender: TObject);
    procedure cboSousProgramEnter(Sender: TObject);
    procedure cboActivityEnter(Sender: TObject);
    procedure cboOperationEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure frxReport1BeforePrint(Sender: TfrxReportComponent);
    procedure Print1Click(Sender: TObject);
    procedure ComboBoxEnter(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure N1Click(Sender: TObject);

  private
    { Private declarations }


  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses Unit6;


procedure TForm5.DBGrid1CellClick(Column: TColumn);
var
  Field: TField;
begin
  // التحقق من وجود الحقل 'id_opération' في مجموعة البيانات
  Field := DBGrid1.DataSource.DataSet.FindField('id_opération');
  if Field = nil then
  begin
    ShowMessage('يرجى تحديد عملية .');
    Exit;
  end;

  // تفعيل زر التعديل عند اختيار صف
  ButtonEdit.visible := True;
end;
 procedure TForm5.Button1Click(Sender: TObject);
var
  engagementPropose: Double;
  idOperation: integer;
  totalEngagementsPrev: Double;
  License: Double;
  soldeInitial: Double;
  lastNumCarte: Integer;
  S: String;
  List: TStringList;
  Part: String;
begin

  try
    // التحقق من صحة المدخلات
    if (Trim(edtEngagementPropose.Text) = '') or (Trim(cboOperation.Text) = '') or
       (Trim(memo1.Text) = '') or (Trim(Editcontrat.Text) = '') or
       (Trim(cboSousProgram.Text) = '') or (Trim(cboOrderer.Text) = '') or
       (Trim(cboActivity.Text) = '') or (Trim(cboProgram.Text) = '') then
    begin
      ShowMessage('الرجاء إدخال جميع البيانات المطلوبة');
      Exit;
    end;

   idOperation := integer(cboOperation.Items.Objects[cboOperation.ItemIndex]);
    if not TryStrToFloat(edtEngagementPropose.Text, engagementPropose) then
    begin
      ShowMessage('الرجاء إدخال قيمة صحيحة للالتزام المقترح');
      Exit;
    end;


    // التحقق من قيمة الالتزام
    if engagementPropose <= 0 then
    begin
      ShowMessage('قيمة الالتزام يجب أن تكون أكبر من صفر');
      Exit;
    end;


    ProgressBar1.Visible := True;
    ProgressBar1.Position := 0;
    ProgressBar1.Max := 100;
    ProgressBar1.Update;
    ADOTableOperation.Refresh;
    // الحصول على القيم الحالية من جدول Operation
    if not ADOTableOperation.Locate('id_opération', idOperation, []) then
    begin
      ShowMessage('العملية غير موجودة');
      Exit;
    end;

    License := ADOTableOperation.FieldByName('License').AsFloat;
    totalEngagementsPrev := ADOTableOperation.FieldByName('total_engagements').AsFloat;
  




    // التحقق من توفر الرصيد الصحيح:
    // التأكد من أن الرصيد المتاح (License - totalEngagementsPrev) يكفي للالتزام المقترح.
    if (License - totalEngagementsPrev) < engagementPropose then
    begin
      ShowMessage('الرصيد غير كافٍ لهذا الالتزام');
      Exit;
    end;

    ProgressBar1.Position := 20;
    ProgressBar1.Update;
    ADOTableEngagementCarte.Refresh;
    ADOQueryLastNumCarte.Close;
    ADOQueryLastNumCarte.SQL.Text :=
      'SELECT MAX(num_carte) AS last_num_carte FROM EngagementCarte WHERE id_opération = :id_opération';
    ADOQueryLastNumCarte.Parameters.ParamByName('id_opération').Value := idOperation;
    ADOQueryLastNumCarte.Open;
    ProgressBar1.Position := 30;
    ProgressBar1.Update;

    // الحصول على آخر num_carte
    if not ADOQueryLastNumCarte.FieldByName('last_num_carte').IsNull then
      lastNumCarte := ADOQueryLastNumCarte.FieldByName('last_num_carte').AsInteger
    else
      lastNumCarte := 0;

    // زيادة القيمة بمقدار 1 للحصول على رقم البطاقة الجديد
    lastNumCarte := lastNumCarte + 1;
    ProgressBar1.Position := 40;
    ProgressBar1.Update;

    // حساب القيم الجديدة مع التفرع الخاص للبطاقة الأولى
    if lastNumCarte = 1 then
    begin
      // في حالة البطاقة الأولى:
      // نجعل مجموع الالتزامات صفر والرصيد الأولي يساوي License
      totalEngagementsPrev := 0;
      soldeInitial := License;
    end
    else
    begin
      // للبطاقات الأخرى: تُضاف قيمة الالتزام المقترح إلى المجموع السابق،
      // ويتم حساب الرصيد الأولي كـ (License - totalEngagementsPrev)
      totalEngagementsPrev := totalEngagementsPrev + engagementPropose;
      soldeInitial := License - totalEngagementsPrev;
    end;

    ProgressBar1.Position := 45;
    ProgressBar1.Update;

    // تحديث جدول Operation بالقيم الجديدة
    ADOTableOperation.Edit;
    ADOTableOperation.FieldByName('total_engagements').AsFloat := totalEngagementsPrev;
    ADOTableOperation.FieldByName('solde_initial').AsFloat := soldeInitial;
    // تحديث الرصيد المتبقي: يُحسب دائمًا كـ (الرصيد الأولي - الالتزام المقترح)
    ADOTableOperation.FieldByName('solde_restant').AsFloat := soldeInitial - engagementPropose;
    ADOTableOperation.Post;

    ProgressBar1.Position := 50;
    ProgressBar1.Update;

    // إضافة بطاقة التزام جديدة
    ADOTableEngagementCarte.Append;
    ADOTableEngagementCarte.FieldByName('id_opération').Asinteger := integer(idOperation);
    ADOTableEngagementCarte.FieldByName('num_carte').AsInteger := lastNumCarte;
    ADOTableEngagementCarte.FieldByName('engagement_proposé').AsFloat := engagementPropose;
    // إذا كانت البطاقة الأولى: نجعل مجموع الالتزامات صفر، وإلا نستخدم المجموع المحسوب
    if lastNumCarte = 1 then
      ADOTableEngagementCarte.FieldByName('total_engagements').AsFloat := 0
    else
      ADOTableEngagementCarte.FieldByName('total_engagements').AsFloat := totalEngagementsPrev;
    ADOTableEngagementCarte.FieldByName('solde_initial').AsFloat := soldeInitial;
    // تحديث الرصيد المتبقي للبطاقة دائماً كـ (الرصيد الأولي - الالتزام المقترح)
    ADOTableEngagementCarte.FieldByName('solde_restant').AsFloat := soldeInitial - engagementPropose;
    ADOTableEngagementCarte.FieldByName('date_create').AsString:= Edit2.Text;
    ADOTableEngagementCarte.Post;
    ADOTableEngagementCarte.Refresh;

    ProgressBar1.Position := 60;
    ProgressBar1.Update;

    // تحديث الحقول المرتبطة للسجل (فتح وضع التعديل)
    ADOTableEngagementCarte.Edit;
    if (cboProgram.ItemIndex > -1) then
      ADOTableEngagementCarte.FieldByName('id_programme').AsInteger :=
        Integer(cboProgram.Items.Objects[cboProgram.ItemIndex]);

    if (cboActivity.ItemIndex > -1) then
      ADOTableEngagementCarte.FieldByName('id_activité').AsInteger :=
        Integer(cboActivity.Items.Objects[cboActivity.ItemIndex]);

    if (cboOrderer.ItemIndex > -1) then
      ADOTableEngagementCarte.FieldByName('id_ordonnateur').AsInteger :=
        Integer(cboOrderer.Items.Objects[cboOrderer.ItemIndex]);

    if (cboSousProgram.ItemIndex > -1) then
      ADOTableEngagementCarte.FieldByName('id_sous_programme').AsInteger :=
        Integer(cboSousProgram.Items.Objects[cboSousProgram.ItemIndex]);
    ADOTableEngagementCarte.Post;

    ProgressBar1.Position := 70;
    ProgressBar1.Update;

    // التحقق من موضوع الالتزام والمتعاقد معه
    if (Trim(memo1.Text) = '') or (Trim(Editcontrat.Text) = '') then
    begin
      ShowMessage('الرجاء إدخال موضوع الالتزام والمتعاقد معه');
      Exit;
    end;
    ProgressBar1.Position := 80;
    ProgressBar1.Update;

    // تحديث موضوع الالتزام والمتعاقد معه للسجل
    ADOTableEngagementCarte.Edit;
    ADOTableEngagementCarte.FieldByName('objet_engagement').AsString := memo1.Text;
    ADOTableEngagementCarte.FieldByName('Contrat_avec').AsString := Editcontrat.Text;
    ADOTableEngagementCarte.Post;
    ADOTableEngagementCarte.Refresh;

    // تأكيد المعاملة
    ShowMessage('تم اضافة البطاقة بنجاح');
    ProgressBar1.Position := 100;
    ProgressBar1.Update;

  if MessageDlg('هل تريد طباعة البطاقة؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      ADOQuery1.Close;
      ADOQuery1.Parameters.ParamByName('id_opération').Value := ADOTableEngagementCarte.FieldByName('id_opération').AsInteger;
      ADOQuery1.Parameters.ParamByName('num_carte').Value := ADOTableEngagementCarte.FieldByName('num_carte').AsInteger;
      ADOQuery1.Open;

      frxDBDataset1.DataSet := ADOQuery1;

      frxReport1.LoadFromFile('D:\Management System\report\report.fr3');

      // قراءة السلسلة وتقسيمها إلى أجزاء
      S := ADOQuery1.FieldByName('num_opération').AsString; // قراءة السلسلة من قاعدة البيانات
      List := TStringList.Create;
      try
        // تقسيم السلسلة عند النقاط
        while Pos('.', S) > 0 do
        begin
          Part := Copy(S, 1, Pos('.', S) - 1);
          List.Add(Part);
          Delete(S, 1, Pos('.', S));
        end;
        if S <> '' then
          List.Add(S);  // إضافة الجزء الأخير إذا كان موجودًا

        // تعيين المتغيرات بشكل يدوي من Part1 إلى Part9
        if List.Count > 0 then frxReport1.Variables['Part1'] := QuotedStr(List[0]);
        if List.Count > 1 then frxReport1.Variables['Part2'] := QuotedStr(List[1]);
        if List.Count > 2 then frxReport1.Variables['Part3'] := QuotedStr(List[2]);
        if List.Count > 3 then frxReport1.Variables['Part4'] := QuotedStr(List[3]);
        if List.Count > 4 then frxReport1.Variables['Part5'] := QuotedStr(List[4]);
        if List.Count > 5 then frxReport1.Variables['Part6'] := QuotedStr(List[5]);
        if List.Count > 6 then frxReport1.Variables['Part7'] := QuotedStr(List[6]);
        if List.Count > 7 then frxReport1.Variables['Part8'] := QuotedStr(List[7]);
        if List.Count > 8 then frxReport1.Variables['Part9'] := QuotedStr(List[8]);

      finally
        List.Free;
      end;

      frxReport1.PrepareReport;
      frxReport1.ShowReport;

      DataSource1.DataSet := ADOQuery1;
    except
      on E: Exception do
        ShowMessage('حدث خطأ: ' + E.Message);
    end;
  end;

  except
    on E: Exception do
      ShowMessage('حدث خطأ: ' + E.Message);
  end;
end;









procedure TForm5.ButtonEditClick(Sender: TObject);
begin
   try
    // التحقق من وجود صف محدد
    if DBGrid1.DataSource.DataSet.RecordCount > 0 then
    begin
      // تحميل البيانات من DBGrid إلى المكونات
      Form6.Edit1.Text := DBGrid1.DataSource.DataSet.FieldByName('engagement_proposé').AsString;
      Form6.memo1.Text := DBGrid1.DataSource.DataSet.FieldByName('objet_engagement').AsString;
      Form6.Edit2.Text := DBGrid1.DataSource.DataSet.FieldByName('Contrat_avec').AsString;
       Form6.edtNumCarte.Text := DBGrid1.DataSource.DataSet.FieldByName('num_carte').AsString;


      // تحميل القيم في ComboBoxes
      Form6.ComboBox5.Text := DBGrid1.DataSource.DataSet.FieldByName('nom_programme').AsString;
      Form6.ComboBox2.Text:= DBGrid1.DataSource.DataSet.FieldByName('nom_activité').AsString;
      Form6.ComboBox1.Text := DBGrid1.DataSource.DataSet.FieldByName('ordonnateur').AsString;
      Form6.ComboBox3.Text :=DBGrid1.DataSource.DataSet.FieldByName('nom_sous_programme').AsString;

      // تفعيل زر الحفظ
      Form6.Showmodal;
    end
    else
    begin
      ShowMessage('الرجاء تحديد بطاقة لتعديلها');
    end;
  except
    on E: Exception do
      ShowMessage('حدث خطأ أثناء تحميل البيانات: ' + E.Message);
  end;
end;


procedure TForm5.cboActivityEnter(Sender: TObject);
begin
   cboActivity.Clear;
  ADOQActivity.Close;
  ADOQActivity.SQL.Text := 'SELECT id_activité, nom_activité FROM Activité ORDER BY nom_activité';
  ADOQActivity.Open;
  while not ADOQActivity.Eof do
  begin
    cboActivity.Items.AddObject(
      ADOQActivity.FieldByName('nom_activité').AsString,
      TObject(ADOQActivity.FieldByName('id_activité').AsInteger)
    );
    ADOQActivity.Next;
  end;
end;

procedure TForm5.cboOrdererEnter(Sender: TObject);
begin
   cboOrderer.Clear;
  ADOQOrderer.Close;
  ADOQOrderer.SQL.Text := 'SELECT id_ordonnateur, ordonnateur FROM Ordonnateur ORDER BY ordonnateur';
  ADOQOrderer.Open;
  while not ADOQOrderer.Eof do
  begin
    cboOrderer.Items.AddObject(
      ADOQOrderer.FieldByName('ordonnateur').AsString,
      TObject(ADOQOrderer.FieldByName('id_ordonnateur').AsInteger)
    );
    ADOQOrderer.Next;
  end;

end;

procedure TForm5.cboProgramEnter(Sender: TObject);
begin
    cboProgram.Clear;
  ADOQProgram.Close;
  ADOQProgram.SQL.Text := 'SELECT id_programme, nom_programme FROM Programme ORDER BY nom_programme';
  ADOQProgram.Open;
  while not ADOQProgram.Eof do
  begin
    cboProgram.Items.AddObject(
      ADOQProgram.FieldByName('nom_programme').AsString,
      TObject(ADOQProgram.FieldByName('id_programme').AsInteger)
    );
    ADOQProgram.Next;
  end;
end;

procedure TForm5.cboSousProgramEnter(Sender: TObject);
begin
  cboSousProgram.Clear;
  ADOQSousProgram.Close;
  ADOQSousProgram.SQL.Text := 'SELECT id_sous_programme, nom_sous_programme FROM sous_programme ORDER BY nom_sous_programme';
  ADOQSousProgram.Open;
  while not ADOQSousProgram.Eof do
  begin
    cboSousProgram.Items.AddObject(
      ADOQSousProgram.FieldByName('nom_sous_programme').AsString,
      TObject(ADOQSousProgram.FieldByName('id_sous_programme').AsInteger)
    );
    ADOQSousProgram.Next;
  end;
end;

procedure TForm5.ComboBoxChange(Sender: TObject);
var
  SelectedOperationID: Integer;
begin
  // الحصول على id_opération المحدد
  SelectedOperationID := Integer(ComboBox.Items.Objects[ComboBox.ItemIndex]);

  // تحديث استعلام ADOQuery1 لتصفية البطاقات المرتبطة بالعملية المحددة

   ADOQuery2.Close;
  ADOQuery2.Parameters.ParamByName('id_opération').Value := SelectedOperationID;
  ADOQuery2.Open;

  // تحديث DBGrid1 ليعرض البيانات المصفاة
  DataSource2.DataSet := ADOQuery2;
  DBGrid1.DataSource := DataSource2;

end;



procedure TForm5.ComboBoxEnter(Sender: TObject);
begin
    ComboBox.Clear;
  ADOQOperation.Close;
  ADOQOperation.SQL.Text := 'SELECT id_opération FROM opération ';
  ADOQOperation.Open;
  while not ADOQOperation.Eof do
  begin
    ComboBox.Items.AddObject(
      ADOQOperation.FieldByName('id_opération').AsString,
      TObject(ADOQOperation.FieldByName('id_opération').AsInteger)
    );
    ADOQOperation.Next;
  end;
  ADOQOperation.Close;
  ComboBox.ItemIndex := 0;
end;


procedure TForm5.Delete1Click(Sender: TObject);
begin
if MessageDlg('هل أنت متأكد أنك تريد حذف البطاقة وأرشفتها؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  try
    // تأكد من إعداد الاتصال بقاعدة البيانات

    // نقل السجل إلى جدول الأرشيف
    ADOQuery3.SQL.Text := 'INSERT INTO EngagementCartearchif (id_carte, id_opération, id_programme, id_activité, id_sous_programme, id_ordonnateur, engagement_proposé, num_carte, objet_engagement, Contrat_avec, total_engagements, solde_initial, solde_restant) ' +
                          'SELECT id_carte, COALESCE(id_opération, NULL) AS id_opération, id_programme, id_activité, id_sous_programme, id_ordonnateur, engagement_proposé, num_carte, objet_engagement, Contrat_avec, total_engagements, solde_initial, solde_restant ' +
                          'FROM EngagementCarte WHERE num_carte = :num_carte';
    ADOQuery3.Parameters.ParamByName('num_carte').Value := DBGrid1.DataSource.DataSet.FieldByName('num_carte').AsInteger;
    ADOQuery3.ExecSQL;

    // حذف السجل من الجدول الأصلي
    ADOQuery3.SQL.Text := 'DELETE FROM EngagementCarte WHERE num_carte = :num_carte';
    ADOQuery3.Parameters.ParamByName('num_carte').Value := DBGrid1.DataSource.DataSet.FieldByName('num_carte').AsInteger;
    ADOQuery3.ExecSQL;

    ShowMessage('تمت أرشفة البطاقة وحذفها بنجاح.');
  except
    on E: Exception do
      ShowMessage('حدث خطأ أثناء أرشفة البطاقة: ' + E.Message);
  end;
end;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
memo1.Clear;
Edit2.Text := FormatDateTime('yyyy-mm-dd', Date);

end;

procedure TForm5.frxReport1BeforePrint(Sender: TfrxReportComponent);
begin
   if (Sender is TfrxMemoView) and
     (TfrxMemoView(Sender).Name = 'engagement_propose') then
  begin
    TfrxMemoView(Sender).DisplayFormat.FormatStr := '#,##0.000';
    TfrxMemoView(Sender).DisplayFormat.Kind := fkNumeric;
  end;
end;

procedure TForm5.N1Click(Sender: TObject);
var
  license: Double;
  engagement: Double;
  totalEngagements: Double;
  soldeInitial: Double ;
  soldeRestant: Double ;
begin
  soldeInitial:= 0 ;
  soldeRestant:= 0 ;
  ADOTableEngagementCarte.Refresh;
  if not Form5.ADOTableOperation.Locate('id_opération', Form5.ComboBox.Text, []) then
  begin
    ShowMessage('العملية المطلوبة غير موجودة');
    Exit;
  end;

  // استرجاع قيمة الرخصة
  license := Form5.ADOTableOperation.FieldByName('License').AsFloat;
  totalEngagements := 0; // مجموع الالتزامات يبدأ من 0

  Form5.ADOTableEngagementCarte.DisableControls;
  try
    Form5.ADOTableEngagementCarte.First;

    while not Form5.ADOTableEngagementCarte.Eof do
    begin
      if Form5.ADOTableEngagementCarte.FieldByName('id_opération').AsInteger = StrToInt(Form5.ComboBox.Text) then
      begin
        engagement := Form5.ADOTableEngagementCarte.FieldByName('engagement_proposé').AsFloat;

        if Form5.ADOTableEngagementCarte.FieldByName('num_carte').AsInteger = 1 then
        begin
          // البطاقة الأولى

          totalEngagements := 0; // أول بطاقة، مجموع الالتزامات = 0
 // أول بطاقة، الالتزام المقترح فقط
        end
        else
        begin
          // البطاقات التالية
          totalEngagements := totalEngagements + engagement; // مجموع الالتزامات السابق + الالتزام الحالي
        end;

        if not (Form5.ADOTableEngagementCarte.State in [dsEdit, dsInsert]) then
          Form5.ADOTableEngagementCarte.Edit;

        // حساب الرصيد الأولي والرصيد المتبقي
        soldeInitial := license - totalEngagements;
        soldeRestant := soldeInitial - engagement;

        // تحديث الحقول
        Form5.ADOTableEngagementCarte.FieldByName('total_engagements').AsFloat := totalEngagements;
        Form5.ADOTableEngagementCarte.FieldByName('solde_initial').AsFloat := soldeInitial;
        Form5.ADOTableEngagementCarte.FieldByName('solde_restant').AsFloat := soldeRestant;

        Form5.ADOTableEngagementCarte.Post;
      end;

      Form5.ADOTableEngagementCarte.Next;
    end;
  finally
    Form5.ADOTableEngagementCarte.EnableControls;
  end;

  // بعد الانتهاء من جميع الحسابات على ADOTableEngagementCarte، نقوم بتحديث ADOTableOperation
  if not (Form5.ADOTableOperation.State in [dsEdit, dsInsert]) then
    Form5.ADOTableOperation.Edit;

  // تحديث الحقول في جدول ADOTableOperation
  Form5.ADOTableOperation.FieldByName('total_engagements').AsFloat := totalEngagements;
  Form5.ADOTableOperation.FieldByName('solde_initial').AsFloat := soldeInitial;
  Form5.ADOTableOperation.FieldByName('solde_restant').AsFloat := soldeRestant;

  // حفظ التحديثات في جدول ADOTableOperation
  Form5.ADOTableOperation.Post;

  ShowMessage('تم تحديث الحسابات لجميع البطاقات وجدول العمليات بنجاح');
end;

procedure TForm5.Print1Click(Sender: TObject);
var
  S: String;
  List: TStringList;
  Part: String;
begin
  if MessageDlg('هل تريد طباعة البطاقة؟', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      ADOQuery1.Close;
      ADOQuery1.Parameters.ParamByName('id_opération').Value := ComboBox.Text;
      ADOQuery1.Parameters.ParamByName('num_carte').Value := DBGrid1.DataSource.DataSet.FieldByName('num_carte').AsInteger;
      ADOQuery1.Open;

      frxDBDataset1.DataSet := ADOQuery1;

      frxReport1.LoadFromFile('D:\Management System\report\report.fr3');

      // قراءة السلسلة وتقسيمها إلى أجزاء
      S := ADOQuery1.FieldByName('num_opération').AsString; // قراءة السلسلة من قاعدة البيانات
      List := TStringList.Create;
      try
        // تقسيم السلسلة عند النقاط
        while Pos('.', S) > 0 do
        begin
          Part := Copy(S, 1, Pos('.', S) - 1);
          List.Add(Part);
          Delete(S, 1, Pos('.', S));
        end;
        if S <> '' then
          List.Add(S);  // إضافة الجزء الأخير إذا كان موجودًا

        // تعيين المتغيرات بشكل يدوي من Part1 إلى Part9
        if List.Count > 0 then frxReport1.Variables['Part1'] := QuotedStr(List[0]);
        if List.Count > 1 then frxReport1.Variables['Part2'] := QuotedStr(List[1]);
        if List.Count > 2 then frxReport1.Variables['Part3'] := QuotedStr(List[2]);
        if List.Count > 3 then frxReport1.Variables['Part4'] := QuotedStr(List[3]);
        if List.Count > 4 then frxReport1.Variables['Part5'] := QuotedStr(List[4]);
        if List.Count > 5 then frxReport1.Variables['Part6'] := QuotedStr(List[5]);
        if List.Count > 6 then frxReport1.Variables['Part7'] := QuotedStr(List[6]);
        if List.Count > 7 then frxReport1.Variables['Part8'] := QuotedStr(List[7]);
        if List.Count > 8 then frxReport1.Variables['Part9'] := QuotedStr(List[8]);

      finally
        List.Free;
      end;

      frxReport1.PrepareReport;
      frxReport1.ShowReport;

      DataSource1.DataSet := ADOQuery1;
    except
      on E: Exception do
        ShowMessage('حدث خطأ: ' + E.Message);
    end;
  end;
end;





procedure TForm5.cboOperationEnter(Sender: TObject);
begin
  cboOperation.Clear;
  ADOQOperation.Close;
  ADOQOperation.SQL.Text := 'SELECT id_opération, num_opération FROM opération ORDER BY num_opération';
  ADOQOperation.Open;
  while not ADOQOperation.Eof do
  begin
    cboOperation.AddItem(
      ADOQOperation.FieldByName('num_opération').AsString,  // نضيف num_opération بدلاً من id_opération
      TObject(ADOQOperation.FieldByName('id_opération').AsInteger)  // نحفظ id_opération في TObject
    );
    ADOQOperation.Next;
  end;
end;

end.
