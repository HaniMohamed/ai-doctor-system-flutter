// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'AI Doctor System';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => '登录';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get email => '电子邮件';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get dashboard => '仪表板';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get symptomChecker => '症状检查器';

  @override
  String get appointments => '预约';

  @override
  String get doctors => '找医生';

  @override
  String get patients => 'Patients';

  @override
  String get notifications => '通知';

  @override
  String get chat => '与AI聊天';

  @override
  String get send => 'Send';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get error => '错误';

  @override
  String get success => 'Success';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get finish => 'Finish';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get cut => 'Cut';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get firstName => '名字';

  @override
  String get lastName => '姓氏';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get createAccount => '创建账户';

  @override
  String get joinAIDoctorSystem => '加入AI医生系统';

  @override
  String get createYourAccount => '创建您的账户开始使用';

  @override
  String get iAmA => '我是：';

  @override
  String get patient => '患者';

  @override
  String get doctor => '医生';

  @override
  String get iNeedMedicalCare => '我需要医疗护理';

  @override
  String get iProvideMedicalCare => '我提供医疗护理';

  @override
  String get firstNameRequired => '名字是必需的';

  @override
  String get lastNameRequired => '姓氏是必需的';

  @override
  String get emailRequired => '电子邮件是必需的';

  @override
  String get validEmailRequired => '请输入有效的电子邮件';

  @override
  String get phoneRequired => '电话号码是必需的';

  @override
  String get passwordRequired => '密码是必需的';

  @override
  String get passwordMinLength => '密码必须至少8个字符';

  @override
  String get confirmPasswordRequired => '请确认您的密码';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get agreeToTerms => '我同意';

  @override
  String get termsOfService => '服务条款';

  @override
  String get and => '和';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get signIn => '登录';

  @override
  String get agreeToTermsError => '请同意服务条款和隐私政策';

  @override
  String get accountCreatedSuccessfully => '账户创建成功！请登录。';

  @override
  String get registrationFailed => '注册失败：';

  @override
  String get resetPassword => '重置密码';

  @override
  String get enterEmailForReset => '输入您的电子邮件地址，我们将发送重置密码的说明';

  @override
  String get checkYourEmail => '检查您的电子邮件';

  @override
  String get resetInstructionsSent => '我们已向您的电子邮件地址发送密码重置说明';

  @override
  String get enterRegisteredEmail => '输入您注册的电子邮件';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get resetLinkSent => '重置链接已发送！';

  @override
  String get checkEmailInstructions => '请检查您的电子邮件并按照说明重置密码。链接将在24小时后过期。';

  @override
  String get resendEmail => '重新发送电子邮件';

  @override
  String get backToSignIn => '返回登录';

  @override
  String get checkSpamFolder => '如果您在几分钟内没有收到电子邮件，请检查您的垃圾邮件文件夹或联系支持。';

  @override
  String get passwordResetSent => '密码重置说明已发送到您的电子邮件';

  @override
  String get failedToSendReset => '发送重置电子邮件失败：';

  @override
  String get resetInstructionsResent => '重置说明已重新发送到您的电子邮件';

  @override
  String get failedToResend => '重新发送失败：';

  @override
  String get aiAssistant => 'AI助手';

  @override
  String get clearChat => '清除聊天';

  @override
  String get typeYourMessage => '输入您的消息...';

  @override
  String get welcomeMessage => '您好！我是您的AI健康助手。今天我能为您做些什么？';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String get demoResponse => '感谢您的消息。这是一个演示回复。真正的AI集成即将到来！';

  @override
  String get noAppointments => '没有预约';

  @override
  String get noDoctors => '没有医生';

  @override
  String get noNotifications => '没有通知';

  @override
  String get noProfileData => '没有个人资料数据';

  @override
  String get organization => '组织：';

  @override
  String get describeYourSymptoms => '描述您的症状';

  @override
  String get enterSymptomsHint => '输入您的症状（例如：头痛、发烧、恶心）';

  @override
  String get clearAllSymptoms => '清除所有症状';

  @override
  String get addSymptom => '添加症状';

  @override
  String get analyzeSymptoms => '分析症状';

  @override
  String get symptoms => '症状';

  @override
  String get analysisResults => '分析结果';

  @override
  String get possibleConditions => '可能的疾病';

  @override
  String get recommendations => '建议';

  @override
  String get severity => '严重程度';

  @override
  String get confidence => '置信度';

  @override
  String get nextSteps => '下一步';

  @override
  String get whenToSeekHelp => '何时寻求帮助';

  @override
  String get emergency => '紧急';

  @override
  String get urgent => '紧急';

  @override
  String get moderate => '中等';

  @override
  String get mild => '轻微';

  @override
  String get high => '高';

  @override
  String get medium => '中等';

  @override
  String get low => '低';

  @override
  String get upcoming => '即将到来';

  @override
  String get unread => '未读';

  @override
  String get quickActions => '快速操作';

  @override
  String get scheduleWithDoctor => '与医生预约';

  @override
  String get aiPoweredHealthCheck => 'AI驱动的健康检查';

  @override
  String get getInstantMedicalAdvice => '获得即时医疗建议';

  @override
  String get browseAvailableDoctors => '浏览可用医生';

  @override
  String get viewYourAlerts => '查看您的提醒';

  @override
  String get manageYourAccount => '管理您的账户';

  @override
  String get overview => '概览';

  @override
  String get totalAppointments => '总预约数';

  @override
  String get totalNotifications => '总通知数';
}
