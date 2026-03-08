// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get login => 'Mag-login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signUp => 'Mag-sign up';

  @override
  String get forgotPassword => 'Nakalimutan ang Password';

  @override
  String get pleaseFillAllFields => 'Mangyaring punan ang lahat ng field';

  @override
  String get invalidEmailOrPassword => 'Maling email o password';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Wika';

  @override
  String get privacy => 'Pagkapribado';

  @override
  String get help => 'Tulong';

  @override
  String get about => 'Tungkol sa';

  @override
  String get logout => 'Mag-logout';

  @override
  String get deleteAccount => 'I-delete ang Account';

  @override
  String get deleteAccountConfirm =>
      'Sigurado ka bang gusto mong i-delete ang iyong account? Hindi na ito mababawi.';

  @override
  String get selectLanguage => 'Pumili ng Wika';

  @override
  String get privacyPolicy =>
      'Ang lahat ng impormasyon ay nasa iyong lokal na storage lamang at walang ipinapadalang impormasyon sa labas.';

  @override
  String get helpContent =>
      'Mangyaring mag-email para sa suporta: \"423002722@ntc.edu.ph\"';

  @override
  String get aboutContent =>
      'Advanced Mobile Development \nGina para sa Terminal Assessment 1\n\nTeam Leader / Coordinator \nCerna, Reymartin Angelo I.\n\nUI/UX Designer\nDacles, Pearl Diane J.\n\nState Management Developer\nTeodoro, Romelio C.\n\nFrontend Developer\nRivera, Edmon Daniel C.\n\nDocumentation / Reporter\nBasit, Krizandra Josephine L.\n\n3.3BSIT\n03/10/26';

  @override
  String get fullName => 'Buong Pangalan';

  @override
  String get confirmPassword => 'Kumpirmahin ang Password';

  @override
  String get agreeToTerms => 'Sumasang-ayon ako sa mga tuntunin at kondisyon';

  @override
  String get agreeToTermsError =>
      'Mangyaring sumang-ayon sa mga tuntunin at kondisyon';

  @override
  String get passwordsDoNotMatch => 'Hindi magkatugma ang mga password';

  @override
  String get registrationSuccessful => 'Matagumpay ang pagpaparehistro!';

  @override
  String get registrationFailed =>
      'Bigo ang pagpaparehistro. Maaaring mayroon na ang email.';

  @override
  String get backToLogin => 'Bumalik sa Login';

  @override
  String get myGrades => 'Aking mga Grade';

  @override
  String get overallGrade => 'Kabuuang grade';

  @override
  String get terminalAssessments => 'Terminal Assessments';

  @override
  String get assignments => 'Mga Assignment';

  @override
  String get activity => 'Gawain';

  @override
  String get noSubjectYet => 'Wala pang Subject';

  @override
  String get addSubjectSubtitle =>
      'Magdagdag ng bagong subject para makita dito';

  @override
  String get recent => 'Kamakailan';

  @override
  String get noRecentTasks => 'Walang kamakailang gawain';

  @override
  String get editSubjectName => 'I-edit ang Pangalan ng Subject';

  @override
  String get subjectName => 'Pangalan ng Subject';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get save => 'I-save';

  @override
  String get deleteSubject => 'I-delete ang Subject';

  @override
  String deleteSubjectConfirm(String title) {
    return 'Sigurado ka bang gusto mong i-delete ang \"$title\"? Burado rin ang lahat ng gawain nito.';
  }

  @override
  String get delete => 'I-delete';

  @override
  String get newActivity => 'Bagong Gawain';

  @override
  String get editActivity => 'I-edit ang Gawain';

  @override
  String get type => 'Uri';

  @override
  String get terminalAssessmentsSingle => 'Terminal Assessment';

  @override
  String get assignmentsSingle => 'Assignment';

  @override
  String get activityName => 'Pangalan ng Gawain';

  @override
  String get description => 'Deskripsyon';

  @override
  String get gradePercent => 'Grade (%)';

  @override
  String get dueDate => 'Petsa ng Pagpasa';

  @override
  String get completed => 'Tapos na';

  @override
  String get edit => 'I-edit';

  @override
  String get markAsFinished => 'Markahan bilang Tapos';

  @override
  String get pending => 'nakabinbin';

  @override
  String get emptyOverallWarning => 'Walang laman. Magdagdag ng bagong Gawain!';

  @override
  String get tasksDueTime => 'Mga Gawain at Oras:';

  @override
  String get noPendingTasks => 'Walang nakabinbing gawain';

  @override
  String get totalGrading => 'Kabuuang Grading';

  @override
  String get addNewSubject => 'Magdagdag ng Bagong Subject';

  @override
  String get addSubjectDescription =>
      'Ipasok ang pangalan ng subject na gusto mong i-track.';

  @override
  String get subjectNameHint => 'hal. Mathematics, History, Art';

  @override
  String get createSubject => 'Gumawa ng Subject';

  @override
  String get enterSubjectName => 'Mangyaring maglagay ng pangalan ng subject';

  @override
  String get navHome => 'Home';

  @override
  String get navAdd => 'Magdagdag';

  @override
  String get navProfile => 'Profile';
}
