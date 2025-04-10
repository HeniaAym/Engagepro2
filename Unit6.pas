unit Unit6;

interface

uses
 System.UITypes, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Skia, Data.DB,Vcl.Skia,
  Vcl.Menus;

type
  TForm6 = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox5: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Label8: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Button1: TButton;
    edtNumCarte: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure SkAnimatedImage1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

uses Unit5;

procedure TForm6.Button1Click(Sender: TObject);
var
  newEngagement: Double;       // قيمة الالتزام الجديد المُدخل للبطاقة المُعدّلة
  idOperation, cardNumber: Integer; // رقم العملية ورقم البطاقة
  license: Double;             // قيمة الرخصة للعملية
  prevTotal: Double;           // مجموع الالتزامات للبطاقة السابقة
  currInitial, currRemaining, currTotal: Double;
  carryTotal: Double;          // مجموع الالتزامات المحسوب للبطاقات اللاحقة
  cardEngagement: Double;      // قيمة الالتزام لبطاقة لاحقة
  bm: TBookmark;
begin
  try
    // التأكد من صحة المدخلات الأساسية
    if (Trim(Edit1.Text) = '') or
       (Trim(Form5.ComboBox.Text) = '') or
       (Trim(edtNumCarte.Text) = '') or
       (Trim(memo1.Text) = '') or
       (Trim(Edit2.Text) = '') then
    begin
      ShowMessage('الرجاء إدخال جميع البيانات المطلوبة');
      Exit;
    end;

    // تحويل المدخلات إلى قيم رقمية
    if not TryStrToFloat(Edit1.Text, newEngagement) then
    begin
      ShowMessage('الرجاء إدخال قيمة صحيحة للالتزام المقترح');
      Exit;
    end;
    if not TryStrToInt(Form5.ComboBox.Text, idOperation) then
    begin
      ShowMessage('الرجاء إدخال قيمة صحيحة للعملية');
      Exit;
    end;
    if not TryStrToInt(edtNumCarte.Text, cardNumber) then
    begin
      ShowMessage('الرجاء إدخال رقم البطاقة الصحيح');
      Exit;
    end;

    // التأكد من وجود العملية والحصول على قيمة الرخصة
    if not Form5.ADOTableOperation.Locate('id_opération', idOperation, []) then
    begin
      ShowMessage('العملية غير موجودة');
      Exit;
    end;
    license := Form5.ADOTableOperation.FieldByName('License').AsFloat;

    {
      نبحث عن السجل الذي يحمل رقم البطاقة المطلوب (cardNumber) للعملية (idOperation).
      سنستخدم حلقة للتنقل عبر السجلات لأن طريقة Locate قد لا تعيد السجل الصحيح في حالة عدم ترتيب
      الجدول حسب الحقلين بشكل مناسب.
    }
    Form5.ADOTableEngagementCarte.DisableControls;
    try
      Form5.ADOTableEngagementCarte.First;
      while not Form5.ADOTableEngagementCarte.Eof do
      begin
        if (Form5.ADOTableEngagementCarte.FieldByName('id_opération').AsInteger = idOperation) and
           (Form5.ADOTableEngagementCarte.FieldByName('num_carte').AsInteger = cardNumber) then
          Break;
        Form5.ADOTableEngagementCarte.Next;
      end;
      if Form5.ADOTableEngagementCarte.Eof then
      begin
        ShowMessage('البطاقة غير موجودة');
        Exit;
      end;

      { حساب مجموع الالتزامات للبطاقة السابقة:
        إذا كانت البطاقة المُعدّلة ليست الأولى، ننقل جميع السجلات لنجد آخر سجل برقم بطاقة أقل من cardNumber.
        إذا كانت البطاقة الأولى يكون المجموع صفر.
      }
      prevTotal := 0;
      Form5.ADOTableEngagementCarte.First;
      while not Form5.ADOTableEngagementCarte.Eof do
      begin
        if (Form5.ADOTableEngagementCarte.FieldByName('id_opération').AsInteger = idOperation) and
           (Form5.ADOTableEngagementCarte.FieldByName('num_carte').AsInteger < cardNumber) then
        begin
          // نحفظ قيمة مجموع الالتزامات للبطاقة الأخيرة قبل البطاقة المُعدّلة
          prevTotal := Form5.ADOTableEngagementCarte.FieldByName('total_engagements').AsFloat;
        end;
        Form5.ADOTableEngagementCarte.Next;
      end;

      { حساب القيم للبطاقة المُعدّلة:
        - الرصيد الأولي (solde_initial) = License - مجموع الالتزامات السابقة (prevTotal)
        - يجب التأكد من أن قيمة الالتزام الجديد (newEngagement) لا تتجاوز الرصيد الأولي.
        - الرصيد المتبقي (solde_restant) = الرصيد الأولي - newEngagement.
        - مجموع الالتزامات لهذه البطاقة = prevTotal + newEngagement.
      }
      currInitial := license - prevTotal;
      if newEngagement > currInitial then
      begin
        ShowMessage('الرصيد غير كافٍ لهذه البطاقة');
        Exit;
      end;
      currRemaining := currInitial - newEngagement;
      currTotal := prevTotal + newEngagement;

      // تعديل سجل البطاقة المُعدّلة (الموجود عند cardNumber)
      Form5.ADOTableEngagementCarte.Edit;
      Form5.ADOTableEngagementCarte.FieldByName('engagement_proposé').AsFloat := newEngagement;
      Form5.ADOTableEngagementCarte.FieldByName('total_engagements').AsFloat := currTotal;
      Form5.ADOTableEngagementCarte.FieldByName('solde_initial').AsFloat := currInitial;
      Form5.ADOTableEngagementCarte.FieldByName('solde_restant').AsFloat := currRemaining;
      Form5.ADOTableEngagementCarte.FieldByName('objet_engagement').AsString := memo1.Text;
      Form5.ADOTableEngagementCarte.FieldByName('Contrat_avec').AsString := Edit2.Text;
      Form5.ADOTableEngagementCarte.Post;

      // حفظ مؤشر موقع البطاقة المُعدّلة
      bm := Form5.ADOTableEngagementCarte.GetBookmark;
      // carryTotal يبدأ بقيمة مجموع الالتزامات للبطاقة المُعدّلة
      carryTotal := currTotal;

      { تحديث البطاقات التالية (أي تلك التي رقمها أكبر من cardNumber)
        لكل بطاقة لاحقة:
          - الرصيد الأولي = License - carryTotal
          - قراءة قيمة الالتزام الخاصة بالبطاقة (engagement_proposé)
          - التأكد من أن قيمة الالتزام لا تتجاوز الرصيد الأولي
          - الرصيد المتبقي = الرصيد الأولي - قيمة الالتزام
          - مجموع الالتزامات = carryTotal + قيمة الالتزام
          - تحديث carryTotal لاستخدامها في البطاقة التالية.
      }
      Form5.ADOTableEngagementCarte.First;
      while not Form5.ADOTableEngagementCarte.Eof do
      begin
        if (Form5.ADOTableEngagementCarte.FieldByName('id_opération').AsInteger = idOperation) and
           (Form5.ADOTableEngagementCarte.FieldByName('num_carte').AsInteger > cardNumber) then
        begin
          currInitial := license - carryTotal;
          cardEngagement := Form5.ADOTableEngagementCarte.FieldByName('engagement_proposé').AsFloat;
          if cardEngagement > currInitial then
          begin
            Form5.ADOTableEngagementCarte.Cancel;
            ShowMessage('بعد التعديل يصبح الرصيد سالباً في البطاقة رقم ' +
              Form5.ADOTableEngagementCarte.FieldByName('num_carte').AsString +
              '. يرجى مراجعة الالتزامات.');
            Form5.ADOTableEngagementCarte.GotoBookmark(bm);
            Form5.ADOTableEngagementCarte.FreeBookmark(bm);
            Exit;
          end;
          currRemaining := currInitial - cardEngagement;
          currTotal := carryTotal + cardEngagement;

          Form5.ADOTableEngagementCarte.Edit;
          Form5.ADOTableEngagementCarte.FieldByName('total_engagements').AsFloat := currTotal;
          Form5.ADOTableEngagementCarte.FieldByName('solde_initial').AsFloat := currInitial;
          Form5.ADOTableEngagementCarte.FieldByName('solde_restant').AsFloat := currRemaining;
          Form5.ADOTableEngagementCarte.Post;

          carryTotal := currTotal;
        end;
        Form5.ADOTableEngagementCarte.Next;
      end;

      // تحديث سجل العملية بناءً على بيانات آخر بطاقة
      Form5.ADOQueryLastNumCarte.Close;
      Form5.ADOQueryLastNumCarte.SQL.Text :=
        'SELECT TOP 1 * FROM EngagementCarte WHERE id_opération = :id_opération ORDER BY num_carte DESC';
      Form5.ADOQueryLastNumCarte.Parameters.ParamByName('id_opération').Value := idOperation;
      Form5.ADOQueryLastNumCarte.Open;
      if not Form5.ADOQueryLastNumCarte.IsEmpty then
      begin
        Form5.ADOTableOperation.Edit;
        Form5.ADOTableOperation.FieldByName('total_engagements').AsFloat :=
          Form5.ADOQueryLastNumCarte.FieldByName('total_engagements').AsFloat;
        Form5.ADOTableOperation.FieldByName('solde_initial').AsFloat :=
          Form5.ADOQueryLastNumCarte.FieldByName('solde_initial').AsFloat;
        Form5.ADOTableOperation.FieldByName('solde_restant').AsFloat :=
          Form5.ADOQueryLastNumCarte.FieldByName('solde_restant').AsFloat;
        Form5.ADOTableOperation.Post;
      end;

      // تحرير مؤشر البوك مارك إن كان صالحاً
      if Form5.ADOTableEngagementCarte.BookmarkValid(bm) then
        Form5.ADOTableEngagementCarte.FreeBookmark(bm);
    finally
      Form5.ADOTableEngagementCarte.EnableControls;
    end;

    ShowMessage('تم تعديل البطاقة وتحديث البطاقات التالية بنجاح');
  except
    on E: Exception do
      ShowMessage('حدث خطأ أثناء التعديل: ' + E.Message);
  end;
end;



procedure TForm6.Button2Click(Sender: TObject);
var
  license: Double;
  engagement: Double;
  totalEngagements: Double;
  soldeInitial: Double;
  soldeRestant: Double;
begin
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
          totalEngagements := engagement;
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

  ShowMessage('تم تحديث الحسابات لجميع البطاقات بنجاح');
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
 memo1.Clear;
end;

procedure TForm6.N1Click(Sender: TObject);
var
  license: Double;
  engagement: Double;
  totalEngagements: Double;
  soldeInitial: Double;
  soldeRestant: Double;
begin
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

  ShowMessage('تم تحديث الحسابات لجميع البطاقات بنجاح');
end;

procedure TForm6.SkAnimatedImage1Click(Sender: TObject);
begin
close;
end;

end.
