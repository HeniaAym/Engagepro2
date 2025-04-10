unit Unit10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.Win.ADODB, Data.DB;

type
  TForm10 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ADOCommand1: TADOCommand;
    ADOConnection1: TADOConnection;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.dfm}

procedure TForm10.Button1Click(Sender: TObject);
var
  SelectedPath: string;
  BackupFilePath: string;
begin
  // 1. إعداد الحوار
  SaveDialog1.FileName := 'Backup.bak'; // اسم ملف افتراضي
  SaveDialog1.Title := 'اختر مجلدًا لحفظ النسخة الاحتياطية';
  SaveDialog1.Filter := 'Backup Files|*.bak'; // تصفية الملفات

  // 2. فتح الحوار
  if SaveDialog1.Execute then
  begin
    // 3. استخراج المسار فقط (حتى لو عدل المستخدم اسم الملف)
    SelectedPath := ExtractFilePath(SaveDialog1.FileName);

    // 4. إنشاء مسار النسخة مع اسم ثابت (مثال: Backup_2024-07-20.bak)
    BackupFilePath := IncludeTrailingPathDelimiter(SelectedPath)
                      + ADOConnection1.DefaultDatabase + '.bak';

    // 5. تنفيذ النسخ الاحتياطي
    ADOCommand1.CommandText :=
      'BACKUP DATABASE [ManagementSystem] TO DISK = ''' + BackupFilePath + ''' WITH INIT, FORMAT';
    try
      ADOCommand1.Execute;
      ShowMessage('تم الحفظ في: ' + BackupFilePath);
    except
      on E: Exception do
        ShowMessage('خطأ: ' + E.Message);
    end;
  end
  else
    ShowMessage('تم الإلغاء');
    end;
procedure TForm10.Button2Click(Sender: TObject);
var
  BackupFile: string;
begin
  OpenDialog1.Title := 'اختر ملف النسخة الاحتياطية';
  OpenDialog1.Filter := 'Backup Files|*.bak';

  if OpenDialog1.Execute then
  begin
    BackupFile := OpenDialog1.FileName;

    try
      // 1. إغلاق الاتصال الحالي (إذا كان مفتوحًا)
      if ADOConnection1.Connected then
        ADOConnection1.Connected := False;

      // 2. تنفيذ أمر الاسترجاع مع إجبار إغلاق الجلسات النشطة
      ADOCommand1.CommandText :=
        'ALTER DATABASE [ManagementSystem] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ' +
        'RESTORE DATABASE [ManagementSystem] FROM DISK = ''' + BackupFile + ''' WITH REPLACE; ' +
        'ALTER DATABASE [ManagementSystem] SET MULTI_USER;';

      ADOCommand1.Execute;
      ShowMessage('تم الاسترجاع بنجاح!');

    except
      on E: Exception do
        ShowMessage('خطأ: ' + E.Message);
    end;

    // 3. إعادة الاتصال بالقاعدة
    ADOConnection1.Connected := True;
  end;


end;

end.
