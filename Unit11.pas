unit Unit11;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdServerIOHandler, IdSSL, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, REST.Types, REST.Client,  Data.Bind.Components,
  Data.Bind.ObjectScope, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON,System.Threading, System.Skia,
  Vcl.Skia,System.DateUtils, System.IOUtils
  ;

type
  TForm11 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ADOCommand1: TADOCommand;
    ADOConnection1: TADOConnection;
    IdHTTP1: TIdHTTP;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    NetHTTPClient1: TNetHTTPClient;
    Button4: TButton;
    SkAnimatedImage1: TSkAnimatedImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

procedure TForm11.Button1Click(Sender: TObject);
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


procedure TForm11.Button2Click(Sender: TObject);
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

procedure TForm11.Button3Click(Sender: TObject);
var
  BackupFolder, BackupFileName, BackupPath, DBName: string;
  SQLBackup: string;
  ADOCommand: TADOCommand;
  FileStream: TFileStream;
  DropboxAPIArg, AccessToken, DropboxPath: string;
  Response: IHTTPResponse;
begin
  // اسم قاعدة البيانات
  DBName := ADOConnection1.DefaultDatabase;

  if DBName = '' then
  begin
    ShowMessage('لم يتم تحديد قاعدة بيانات في ADOConnection1.');
    Exit;
  end;

  // إعداد مجلد النسخ الاحتياطي
  BackupFolder := ExtractFilePath(ParamStr(0)) + 'Backup\';
  if not DirectoryExists(BackupFolder) then
    CreateDir(BackupFolder);

  BackupFileName := DBName + '_Backup_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.bak';
  BackupPath := BackupFolder + BackupFileName;

  // أمر SQL للنسخ الاحتياطي
  SQLBackup := Format(
    'BACKUP DATABASE [%s] TO DISK = N''%s'' WITH INIT',
    [DBName, BackupPath]);

  // تنفيذ النسخ الاحتياطي باستخدام ADOConnection1
  ADOCommand := TADOCommand.Create(nil);
  try
    ADOCommand.Connection := ADOConnection1;
    ADOCommand.CommandText := SQLBackup;
    ADOCommand.Execute;
  finally
    ADOCommand.Free;
  end;

  // --- رفع النسخة إلى Dropbox ---

  // أدخل توكن Dropbox الخاص بك هنا
  AccessToken := 'sl.u.AFqvMXwt2pgfT50zMht2Jmxh7yoJX2Z59zHwSFin1HzciF2Ic56Eq4kpupR6xh-i9m8B3G68uL9ewpt6IpCvf7qsbgtjZlNDwGdcYXD26I6HADE7gzPF_cYiNAbIZemkDiP5hbHCLCUGQ9CO7crQ05h_QCgmJWWU9leoX5A-xZY-qr2jRbnJGi4kbxMwU2m5gFdhZsA5qZo7DydPZBFrFIegR8ZK1ee6p3UJEAjDaSxOhPZo3rKFiZV_zHdm1lMFBoxUZaXU6SNwzold8JRRkuOYW3EwZCW_V5VscWuHyeM3fjkmOWjOcD2by-nxV9eLP-AvCfGFwZrzutiGXyq9wo9XH0WLA3CPg5fjwLlxO914UQMlL1ECeVtkUXXmql_tIl90E7YAgCD9KZFQlC-jCH7q6rrvhS1Le8528UyxGEGI0c4lcbcSihRSKYU-cgzy8D8FiUEyuHq0CDlFDfKAUqp2vWi7HbrOPTodqtpqu5T5_P0kiCJE9f4RbTFuQuIi3Hgpj7uXwABr1asZHbC3fQQQu-BrWqhEgtTSVBT8_OELSkpiAAUsbPx59_SRQKorPwOCzXU6rNTncH5j-bo5jk05aYbLV5LNJ0fSWKDdDFSrCWFXv50tJA825aqkuwhi2u0zxJJrO2qr5TuvJGJzKEDDrsf0_S8aZA6NdnNcpkiOl0fSgoO3UFyqvw2TJSlhu3qsEWqrp5l6pz0l-xC-HjD9TRwxGEQfxAhLQHmTFPbo3YIsRSKScUoF_wPP7eFknQUnJAMoS-JR0iV4SAr7-3zuvIkL3CvG5F3q7gVXnJmSrDj7mHhdhchVn0frPjPNpjLPvdIYPu6pqM2tWfKr8VZM4rXd1HMAKK1Bw0ONHYzSTs0_Xsf0dbXA3MGMUQSqBHHB3xq2HRXo0o2c78n_52ZgJUmzNo-zfnV_eJZl657F__xYEteRkg0obr9HIStGJQkH8olFbXJ6TSKONeyATFFPVZJl1aqWpembDgy7JcRp0peL1FlyZj7FQURuR2kbIa8J6AQDpQDsyFYT3ZcXpAwxqydnrj0TRD9Ozj761tPp_Ugd15agXGx2R0ElGd50Xocaay-XSJRXgzxpMyKcKxKhNKqo4yT_PGIRMksrzHR95IJrmnT6mKrfqqON-7GYvzYEJyGEtFuT2fDZiHI5KIp52M40BV8ZFU-cXLLUVJOoRGlgWBcqiuxJ0ai6YVf-LxwLXSfNBs2Ds84E3VDk0QuC4CBkdstRbkhzglkDuATiO6LnFjsegB9jEatefx4mPPur2xnI-5stxFSGRean-wqETQJdD_b2yh6cmQO9PxWySLQFdHyuGbxeJ5bznT2uauyd3MqyClnBuOwi1b2LIKLzjP6_asLd-v9r2cZ5ZfArtIzsUqqmQ6GVH-HLQqw2KoRjllYjP-jMvQ8ryAMBHAgk_fZCnBY7Z5zvbR3cfNQTN8lsuJLpk4uw6fPMMMIcarHxY9BlABPjA1g6wUFSjeAs';

  DropboxPath := '/' + BackupFileName;

  DropboxAPIArg := TJSONObject.Create
    .AddPair('path', DropboxPath)
    .AddPair('mode', 'add')
    .AddPair('autorename', TJSONBool.Create(True))
    .AddPair('mute', TJSONBool.Create(False))
    .ToString;

  FileStream := TFileStream.Create(BackupPath, fmOpenRead or fmShareDenyWrite);
  try
    NetHTTPClient1.CustomHeaders['Authorization'] := 'Bearer ' + AccessToken;
    NetHTTPClient1.CustomHeaders['Dropbox-API-Arg'] := DropboxAPIArg;
    NetHTTPClient1.CustomHeaders['Content-Type'] := 'application/octet-stream';

    try
      Response := NetHTTPClient1.Post('https://content.dropboxapi.com/2/files/upload', FileStream);
      if Response.StatusCode = 200 then
        ShowMessage('✔ تم عمل نسخة احتياطية ورفعها إلى Dropbox بنجاح.')
      else
        ShowMessage('✖ فشل رفع الملف إلى Dropbox: ' + Response.ContentAsString);
    except
      on E: Exception do
        ShowMessage('✖ خطأ أثناء الرفع: ' + E.Message);
    end;
  finally
    FileStream.Free;
  end;
end;
end.
