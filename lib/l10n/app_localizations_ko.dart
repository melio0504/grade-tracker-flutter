// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get login => '로그인';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get signUp => '가입하기';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get pleaseFillAllFields => '모든 필드를 채워주세요';

  @override
  String get invalidEmailOrPassword => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get darkMode => '다크 모드';

  @override
  String get language => '언어';

  @override
  String get privacy => '개인정보 보호';

  @override
  String get help => '도움말';

  @override
  String get about => '정보';

  @override
  String get logout => '로그아웃';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountConfirm => '계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get privacyPolicy => '모든 정보는 로컬 저장소에만 저장되며 외부로 전송되지 않습니다.';

  @override
  String get helpContent => '지원을 받으려면 이메일을 보내주세요: \"423002722@ntc.edu.ph\"';

  @override
  String get aboutContent =>
      'Advanced Mobile Development \nTerminal Assessment 1을 위해 제작되었습니다\n\n팀 리더 / 코디네이터 \nCerna, Reymartin Angelo I.\n\nUI/UX 디자이너 \nDacles, Pearl Diane J.\n\n상태 관리 개발자 \nTeodoro, Romelio C.\n\n프론트엔드 개발자 \nRivera, Edmon Daniel C.\n\n문서 / 리포터 \nBasit, Krizandra Josephine L.\n\n3.3BSIT\n03/10/26';

  @override
  String get fullName => '성명';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get agreeToTerms => '이용 약관에 동의합니다';

  @override
  String get agreeToTermsError => '이용 약관에 동의해 주세요';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get registrationSuccessful => '회원가입 성공!';

  @override
  String get registrationFailed => '회원가입 실패. 이미 존재하는 이메일일 수 있습니다.';

  @override
  String get backToLogin => '로그인으로 돌아가기';

  @override
  String get myGrades => '내 성적';

  @override
  String get overallGrade => '전체 성적';

  @override
  String get terminalAssessments => '기말 평가';

  @override
  String get assignments => '과제';

  @override
  String get activity => '활동';

  @override
  String get noSubjectYet => '등록된 과목 없음';

  @override
  String get addSubjectSubtitle => '새 과목을 추가하여 추적을 시작하세요';

  @override
  String get recent => '최근';

  @override
  String get noRecentTasks => '최근 작업 없음';

  @override
  String get editSubjectName => '과목명 수정';

  @override
  String get subjectName => '과목명';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get deleteSubject => '과목 삭제';

  @override
  String deleteSubjectConfirm(String title) {
    return '\"$title\" 과목을 삭제하시겠습니까? 관련된 모든 활동도 삭제됩니다.';
  }

  @override
  String get delete => '삭제';

  @override
  String get newActivity => '새 활동';

  @override
  String get editActivity => '활동 수정';

  @override
  String get type => '유형';

  @override
  String get terminalAssessmentsSingle => '기말 평가';

  @override
  String get assignmentsSingle => '과제';

  @override
  String get activityName => '활동명';

  @override
  String get description => '설명';

  @override
  String get gradePercent => '성적 (%)';

  @override
  String get dueDate => '마감일';

  @override
  String get completed => '완료';

  @override
  String get edit => '수정';

  @override
  String get markAsFinished => '완료로 표시';

  @override
  String get pending => '대기 중';

  @override
  String get emptyOverallWarning => '데이터가 없습니다. 활동을 추가해 주세요!';

  @override
  String get tasksDueTime => '작업 및 마감 시간:';

  @override
  String get noPendingTasks => '대기 중인 작업 없음';

  @override
  String get totalGrading => '총점';

  @override
  String get addNewSubject => '새 과목 추가';

  @override
  String get addSubjectDescription => '추적할 과목의 이름을 입력하세요.';

  @override
  String get subjectNameHint => '예: 수학, 역사, 미술';

  @override
  String get createSubject => '과목 생성';

  @override
  String get enterSubjectName => '과목명을 입력해 주세요';

  @override
  String get navHome => '홈';

  @override
  String get navAdd => '추가';

  @override
  String get navProfile => '프로필';
}
