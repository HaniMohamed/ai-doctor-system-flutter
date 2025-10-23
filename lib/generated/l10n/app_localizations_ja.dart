// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'AI医師システム';

  @override
  String get welcome => 'ようこそ';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get register => '登録';

  @override
  String get email => 'メール';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワード確認';

  @override
  String get forgotPassword => 'パスワードを忘れましたか？';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get symptomChecker => '症状チェッカー';

  @override
  String get appointments => '予約';

  @override
  String get bookingAssistant => '予約アシスタント';

  @override
  String get welcomeToBookingAssistant => 'AI予約アシスタントへようこそ';

  @override
  String get bookingAssistantDescription =>
      '予約の予約、医師の検索、ヘルスケアスケジュールの管理をお手伝いできます。何が必要か教えてください！';

  @override
  String get iNeedToBookAnAppointment => '予約をする必要があります';

  @override
  String get startBooking => '予約を開始';

  @override
  String get clearConversation => '会話をクリア';

  @override
  String get typeYourMessage => 'メッセージを入力...';

  @override
  String get sendMessage => 'メッセージを送信';

  @override
  String get suggestions => '提案';

  @override
  String get availableDoctors => '利用可能な医師';

  @override
  String get suggestedTimeSlots => '提案された時間枠';

  @override
  String get select => '選択';

  @override
  String get doctors => '医師を探す';

  @override
  String get patients => '患者';

  @override
  String get notifications => '通知';

  @override
  String get chat => 'AIチャット';

  @override
  String get send => '送信';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get confirm => '確認';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get ok => 'OK';

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get loading => '読み込み中...';

  @override
  String get retry => '再試行';

  @override
  String get close => '閉じる';

  @override
  String get back => '戻る';

  @override
  String get next => '次へ';

  @override
  String get previous => '前へ';

  @override
  String get finish => '完了';

  @override
  String get search => '検索';

  @override
  String get filter => 'フィルター';

  @override
  String get sort => '並び替え';

  @override
  String get refresh => '更新';

  @override
  String get share => '共有';

  @override
  String get copy => 'コピー';

  @override
  String get paste => '貼り付け';

  @override
  String get cut => '切り取り';

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直し';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get deselectAll => 'すべて選択解除';

  @override
  String get changeLanguage => '言語を変更';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get joinAIDoctorSystem => 'AI医師システムに参加';

  @override
  String get createYourAccount => 'アカウントを作成して開始';

  @override
  String get iAmA => '私は：';

  @override
  String get patient => '患者';

  @override
  String get doctor => '医師';

  @override
  String get iNeedMedicalCare => '医療ケアが必要です';

  @override
  String get iProvideMedicalCare => '医療ケアを提供します';

  @override
  String get firstNameRequired => '名が必要です';

  @override
  String get lastNameRequired => '姓が必要です';

  @override
  String get emailRequired => 'メールが必要です';

  @override
  String get validEmailRequired => '有効なメールアドレスを入力してください';

  @override
  String get phoneRequired => '電話番号が必要です';

  @override
  String get passwordRequired => 'パスワードが必要です';

  @override
  String get passwordMinLength => 'パスワードは8文字以上である必要があります';

  @override
  String get confirmPasswordRequired => 'パスワードを確認してください';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get agreeToTerms => '同意します';

  @override
  String get termsOfService => '利用規約';

  @override
  String get and => 'と';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get signIn => 'サインイン';

  @override
  String get agreeToTermsError => '利用規約とプライバシーポリシーに同意してください';

  @override
  String get accountCreatedSuccessfully => 'アカウントが正常に作成されました！ログインしてください。';

  @override
  String get registrationFailed => '登録に失敗しました：';

  @override
  String get resetPassword => 'パスワードリセット';

  @override
  String get enterEmailForReset => 'メールアドレスを入力すると、パスワードリセットの手順をお送りします';

  @override
  String get checkYourEmail => 'メールを確認してください';

  @override
  String get resetInstructionsSent => 'パスワードリセットの手順をメールアドレスに送信しました';

  @override
  String get enterRegisteredEmail => '登録済みメールを入力';

  @override
  String get sendResetLink => 'リセットリンクを送信';

  @override
  String get resetLinkSent => 'リセットリンクが送信されました！';

  @override
  String get checkEmailInstructions =>
      'メールを確認し、パスワードリセットの手順に従ってください。リンクは24時間で期限切れになります。';

  @override
  String get resendEmail => 'メールを再送信';

  @override
  String get backToSignIn => 'サインインに戻る';

  @override
  String get checkSpamFolder =>
      '数分以内にメールが届かない場合は、スパムフォルダを確認するか、サポートにお問い合わせください。';

  @override
  String get passwordResetSent => 'パスワードリセットの手順がメールに送信されました';

  @override
  String get failedToSendReset => 'リセットメールの送信に失敗しました：';

  @override
  String get resetInstructionsResent => 'リセット手順がメールに再送信されました';

  @override
  String get failedToResend => '再送信に失敗しました：';

  @override
  String get aiAssistant => 'AIアシスタント';

  @override
  String get clearChat => 'チャットをクリア';

  @override
  String get welcomeMessage => 'こんにちは！私はあなたのAI健康アシスタントです。今日はどのようにお手伝いできますか？';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int count) {
    return '$count分前';
  }

  @override
  String hoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String get demoResponse => 'メッセージをありがとうございます。これはデモ応答です。実際のAI統合は間もなく！';

  @override
  String get noAppointments => '予約なし';

  @override
  String get noDoctors => '医師なし';

  @override
  String get noNotifications => '通知なし';

  @override
  String get noProfileData => 'プロフィールデータなし';

  @override
  String get organization => '組織：';

  @override
  String get describeYourSymptoms => '症状を説明してください';

  @override
  String get enterSymptomsHint => '症状を入力してください（例：頭痛、発熱、吐き気）';

  @override
  String get clearAllSymptoms => 'すべての症状をクリア';

  @override
  String get addSymptom => '症状を追加';

  @override
  String get analyzeSymptoms => '症状を分析';

  @override
  String get symptoms => '症状';

  @override
  String get analysisResults => '分析結果';

  @override
  String get possibleConditions => '可能性のある疾患';

  @override
  String get recommendations => '推奨事項';

  @override
  String get severity => '重症度';

  @override
  String get confidence => '信頼度';

  @override
  String get nextSteps => '次のステップ';

  @override
  String get whenToSeekHelp => 'いつ助けを求めるか';

  @override
  String get emergency => '緊急';

  @override
  String get urgent => '緊急';

  @override
  String get moderate => '中等度';

  @override
  String get mild => '軽度';

  @override
  String get high => '高';

  @override
  String get medium => '中';

  @override
  String get low => '低';

  @override
  String get upcoming => '今後の';

  @override
  String get unread => '未読';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get scheduleWithDoctor => '医師と予約';

  @override
  String get aiPoweredHealthCheck => 'AI駆動の健康チェック';

  @override
  String get getInstantMedicalAdvice => '即座の医療アドバイスを取得';

  @override
  String get browseAvailableDoctors => '利用可能な医師を閲覧';

  @override
  String get viewYourAlerts => 'アラートを表示';

  @override
  String get manageYourAccount => 'アカウントを管理';

  @override
  String get overview => '概要';

  @override
  String get totalAppointments => '総予約数';

  @override
  String get totalNotifications => '総通知数';

  @override
  String get appDescription => 'AIを活用した包括的なヘルスケア管理プラットフォーム。';

  @override
  String get appBuiltWith => 'クロスプラットフォーム互換性のためにFlutterで構築。';

  @override
  String get confirmSignOut => 'サインアウトしてもよろしいですか？';

  @override
  String get aiInitializingNeuralNetwork => '🧠 ニューラルネットワークを初期化中...';

  @override
  String get aiScanningSymptomPatterns => '🔍 症状パターンをスキャン中...';

  @override
  String get aiAnalyzingMedicalHistory => '📊 病歴を分析中...';

  @override
  String get aiProcessingGeneticData => '🧬 遺伝子データを処理中...';

  @override
  String get aiRunningDiagnostics => '🤖 AI診断を実行中...';

  @override
  String get aiCrossReferencingDatabases => '📈 データベースを照合中...';

  @override
  String get aiGeneratingInsights => '💡 洞察を生成中...';

  @override
  String get aiEvaluatingBiomarkers => '🔬 バイオマーカーを評価中...';

  @override
  String get aiCalculatingProbabilities => '🎯 確率を計算中...';

  @override
  String get aiFinalizingRecommendations => '✨ 推奨事項を最終化中...';

  @override
  String get currentSymptoms => '現在の症状';

  @override
  String get analyzing => '分析中...';

  @override
  String get addSymptomsAboveToGetAnalysis => '上記に症状を追加してAI分析を取得';

  @override
  String get clickAnalyzeSymptomsToGetRecommendations =>
      '推奨事項を取得するには「症状を分析」をクリック';

  @override
  String get urgency => '緊急度';

  @override
  String get recommendedSpecialties => '推奨専門分野';

  @override
  String get analysisFailed => '分析失敗';

  @override
  String get aiAnalysis => 'AI分析';

  @override
  String get suggestedQuestions => '提案された質問';

  @override
  String get actionCompleted => 'アクション完了';

  @override
  String get somethingWentWrong => '何か問題が発生しました';

  @override
  String get dismiss => '却下';

  @override
  String get findADoctor => '医師を探す';

  @override
  String get iNeedToFindADoctor => '医師を見つける必要があります';

  @override
  String get checkAvailability => '空き状況を確認';

  @override
  String get showMeAvailableAppointments => '利用可能な予約を表示';

  @override
  String get aiIsResponding => 'AIが応答しています...';

  @override
  String get aiIsThinking => 'AIが考えています...';

  @override
  String get intent => '意図';

  @override
  String get aiIntent => 'AI意図';

  @override
  String percent(String value) {
    return '$value%';
  }

  @override
  String get analyzingYourRequest => 'リクエストを分析し、最適な応答を準備中';

  @override
  String get aiRecommendations => 'AI推奨事項';

  @override
  String get recommendedDoctors => '推奨医師';

  @override
  String get basedOnYourPreferences => 'あなたの好みと空き状況に基づいて';

  @override
  String get drUnknown => 'Dr.不明';

  @override
  String get book => '予約';

  @override
  String get today => '今日';

  @override
  String get tomorrow => '明日';

  @override
  String get askYourAIAssistant => 'AIアシスタントに質問してください...';

  @override
  String get bookingAssistantWelcomeMessage =>
      'こんにちは！私はあなたのAI予約アシスタントです。今日はどのようにお手伝いできますか？';
}
