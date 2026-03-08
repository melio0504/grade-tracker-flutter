// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get login => 'ログイン';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get signUp => 'サインアップ';

  @override
  String get forgotPassword => 'パスワードを忘れた場合';

  @override
  String get pleaseFillAllFields => 'すべての項目を入力してください';

  @override
  String get invalidEmailOrPassword => 'メールアドレスまたはパスワードが正しくありません';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get privacy => 'プライバシー';

  @override
  String get help => 'ヘルプ';

  @override
  String get about => 'アプリについて';

  @override
  String get logout => 'ログアウト';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountConfirm => 'アカウントを削除してもよろしいですか？この操作は取り消せません。';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get privacyPolicy => 'すべての情報はローカルストレージにのみ保存され、外部に送信されることはありません。';

  @override
  String get helpContent => 'サポートについてはメールでお問い合わせください: \"423002722@ntc.edu.ph\"';

  @override
  String get aboutContent =>
      'Advanced Mobile Development \nTerminal Assessment 1のために作成\n\nチームリーダー / コーディネーター\nCerna, Reymartin Angelo I.\n\nUI/UXデザイナー\nDacles, Pearl Diane J.\n\n状態管理デベロッパー\nTeodoro, Romelio C.\n\nフロントエンドデベロッパー\nRivera, Edmon Daniel C.\n\nドキュメント / レポーター\nBasit, Krizandra Josephine L.\n\n3.3BSIT\n03/10/26';

  @override
  String get fullName => '氏名';

  @override
  String get confirmPassword => 'パスワード（確認）';

  @override
  String get agreeToTerms => '利用規約に同意します';

  @override
  String get agreeToTermsError => '利用規約に同意してください';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get registrationSuccessful => '登録が完了しました！';

  @override
  String get registrationFailed => '登録に失敗しました。メールアドレスが既に登録されている可能性があります。';

  @override
  String get backToLogin => 'ログインに戻る';

  @override
  String get myGrades => '成績';

  @override
  String get overallGrade => '総合評価';

  @override
  String get terminalAssessments => '定期試験';

  @override
  String get assignments => '課題';

  @override
  String get activity => 'アクティビティ';

  @override
  String get noSubjectYet => '教科がありません';

  @override
  String get addSubjectSubtitle => '新しい教科を追加して追跡を開始しましょう';

  @override
  String get recent => '最近';

  @override
  String get noRecentTasks => '最近のタスクはありません';

  @override
  String get editSubjectName => '教科名の編集';

  @override
  String get subjectName => '教科名';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get deleteSubject => '教科を削除';

  @override
  String deleteSubjectConfirm(String title) {
    return '「$title」を削除してもよろしいですか？関連するすべてのアクティビティも削除されます。';
  }

  @override
  String get delete => '削除';

  @override
  String get newActivity => '新しいアクティビティ';

  @override
  String get editActivity => 'アクティビティを編集';

  @override
  String get type => 'タイプ';

  @override
  String get terminalAssessmentsSingle => '定期試験';

  @override
  String get assignmentsSingle => '課題';

  @override
  String get activityName => 'アクティビティ名';

  @override
  String get description => '説明';

  @override
  String get gradePercent => '成績 (%)';

  @override
  String get dueDate => '期日';

  @override
  String get completed => '完了';

  @override
  String get edit => '編集';

  @override
  String get markAsFinished => '完了としてマーク';

  @override
  String get pending => '保留中';

  @override
  String get emptyOverallWarning => 'データがありません。アクティビティを追加してください！';

  @override
  String get tasksDueTime => 'タスクと期日:';

  @override
  String get noPendingTasks => '保留中のタスクはありません';

  @override
  String get totalGrading => '合計点数';

  @override
  String get addNewSubject => '新しい教科を追加';

  @override
  String get addSubjectDescription => '追跡したい教科の名前を入力してください。';

  @override
  String get subjectNameHint => '例：数学、歴史、美術';

  @override
  String get createSubject => '教科を作成';

  @override
  String get enterSubjectName => '教科名を入力してください';

  @override
  String get navHome => 'ホーム';

  @override
  String get navAdd => '追加';

  @override
  String get navProfile => 'プロフィール';
}
