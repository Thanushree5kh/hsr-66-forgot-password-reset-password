class AppStrings {
  const AppStrings({required this.locale});

  final String locale;

  bool get isHindi => locale == 'hi';

  static AppStrings of(String locale) => AppStrings(locale: locale);

  // Language Picker
  String get selectLanguage => isHindi ? 'भाषा चुनें' : 'Select Language';
  String get english => 'English';
  String get hindi => 'हिंदी';
  String get currentLanguageName => isHindi ? 'हिंदी' : 'English';

  // Common Navigation & Actions
  String get backToLogin => isHindi ? 'लॉगिन पर वापस जाएं' : 'Back to Login';
  String get backToSignIn => isHindi ? 'साइन इन पर वापस जाएं' : 'Back to sign in';
  String get login => isHindi ? 'लॉगिन करें' : 'Log in';
  String get signUp => isHindi ? 'साइन अप करें' : 'Sign up';
  String get dontHaveAccount => isHindi ? 'खाता नहीं है? ' : "Don't have an account? ";
  String get createAccount => isHindi ? 'खाता बनाएं' : 'Create account';

  // Login Screen
  String get welcomeBack => isHindi ? 'आपका वापस स्वागत है!' : 'Welcome Back!';
  String get loginSubtitle => isHindi
      ? 'कृपया लॉगिन करने के लिए अपनी जानकारी दर्ज करें।'
      : 'Please enter your credentials to log in.';
  String get emailLabel => isHindi ? 'ईमेल' : 'Email';
  String get emailHint => isHindi ? 'अपना ईमेल दर्ज करें' : 'Enter your email';
  String get passwordLabel => isHindi ? 'पासवर्ड' : 'Password';
  String get passwordHint => isHindi ? 'अपना पासवर्ड दर्ज करें' : 'Enter your password';
  String get forgotPasswordQuestion =>
      isHindi ? 'पासवर्ड भूल गए?' : 'Forgot password?';

  // Forgot Password Screen
  String get forgotPasswordTitle =>
      isHindi ? 'पासवर्ड भूल गए?' : 'Forgot Password?';
  String get forgotPasswordSubtitle => isHindi
      ? 'अपना पासवर्ड रीसेट करने के लिए 6-अंकों का सत्यापन ओटीपी प्राप्त करने हेतु अपना ईमेल पता दर्ज करें।'
      : 'Enter your email address to receive a 6-digit verification OTP to reset your password.';
  String get emailAddressLabel => isHindi ? 'ईमेल पता' : 'Email Address';
  String get emailAddressHint =>
      isHindi ? 'अपना ईमेल दर्ज करें' : 'enter your email';
  String get sendOtp => isHindi ? 'ओटीपी भेजें' : 'Send OTP';
  String get emailValidationError => isHindi
      ? 'कृपया एक मान्य ईमेल पता दर्ज करें।'
      : 'Please enter a valid email address.';
  String get failedToSendOtp => isHindi
      ? 'ओटीपी भेजने में विफल। कृपया पुनः प्रयास करें।'
      : 'Failed to send OTP. Please try again.';
  String get demoOtpBanner => isHindi
      ? 'डेमो ओटीपी: 123456 (नीचे दिया गया टिप कार्ड देखें)'
      : 'Demo OTP: 123456 (Check the tip card below)';

  // Verify OTP Screen
  String get verifyOtpTitle => isHindi ? 'ओटीपी सत्यापित करें' : 'Verify OTP';
  String get verifyOtpSubtitlePrefix => isHindi
      ? 'पर भेजा गया 6-अंकों का सत्यापन कोड दर्ज करें\n'
      : 'Enter the 6-digit verification code sent to\n';
  String get yourEmailFallback => isHindi ? 'आपका ईमेल' : 'your email';
  String get didntReceiveCode =>
      isHindi ? 'कोड नहीं मिला? ' : "Didn't receive the code? ";
  String get resendOtp => isHindi ? 'ओटीपी पुनः भेजें' : 'Resend OTP';
  String resendInSeconds(int seconds) =>
      isHindi ? '${seconds}s में पुनः भेजें' : 'Resend in ${seconds}s';
  String get verifyOtpButton => isHindi ? 'ओटीपी सत्यापित करें' : 'Verify OTP';
  String get tipDemoModeTitle =>
      isHindi ? 'टिप (डेमो मोड)' : 'Tip (Demo Mode)';
  String get tipDemoModeTextPrefix => isHindi
      ? 'यदि आवश्यक हो तो स्पैम फ़ोल्डर जांचें। बैकएंड परिनियोजन से पहले परीक्षण के लिए, डेमो ओटीपी का उपयोग करें: '
      : 'Check your spam folder if needed. For testing before backend deployment, use Demo OTP: ';
  String get invalidOtpError => isHindi
      ? 'अमान्य ओटीपी। कृपया कोड जांचें और पुनः प्रयास करें।'
      : 'Invalid OTP. Please check the code and try again.';
  String get failedToResendOtp => isHindi
      ? 'ओटीपी पुनः भेजने में विफल। कृपया पुनः प्रयास करें।'
      : 'Failed to resend OTP. Please try again.';

  // Reset Password Screen
  String get createNewPasswordTitle =>
      isHindi ? 'नया पासवर्ड बनाएं' : 'Create New Password';
  String get createNewPasswordSubtitle => isHindi
      ? 'आपका नया पासवर्ड आपके पिछले पासवर्ड से अलग होना चाहिए।'
      : 'Your new password must be different from your previous password.';
  String get newPasswordLabel => isHindi ? 'नया पासवर्ड' : 'New Password';
  String get newPasswordHint =>
      isHindi ? 'नया पासवर्ड दर्ज करें' : 'Enter new password';
  String get confirmPasswordLabel =>
      isHindi ? 'पासवर्ड की पुष्टि करें' : 'Confirm Password';
  String get confirmPasswordHint =>
      isHindi ? 'नया पासवर्ड पुनः दर्ज करें' : 'Re-enter new password';
  String get passwordsDoNotMatch =>
      isHindi ? 'पासवर्ड मेल नहीं खाते।' : 'Passwords do not match.';
  String get passwordsMatch =>
      isHindi ? 'पासवर्ड मेल खाते हैं।' : 'Passwords match.';
  String get resetPasswordButton =>
      isHindi ? 'पासवर्ड रीसेट करें' : 'Reset Password';
  String get failedToResetPassword => isHindi
      ? 'पासवर्ड रीसेट करने में विफल। कृपया पुनः प्रयास करें।'
      : 'Failed to reset password. Please try again.';

  // Password Requirements Checklist
  String get passwordMustContain =>
      isHindi ? 'पासवर्ड में शामिल होना चाहिए:' : 'Password must contain:';
  String get reqMinLength =>
      isHindi ? 'कम से कम 8 वर्ण' : 'At least 8 characters';
  String get reqUppercase =>
      isHindi ? 'कम से कम एक बड़ा अक्षर (A-Z)' : 'At least one uppercase letter (A-Z)';
  String get reqLowercase =>
      isHindi ? 'कम से कम एक छोटा अक्षर (a-z)' : 'At least one lowercase letter (a-z)';
  String get reqNumber =>
      isHindi ? 'कम से कम एक संख्या (0-9)' : 'At least one number (0-9)';
  String get reqSpecialChar => isHindi
      ? 'कम से कम एक विशेष वर्ण (!@#\$%^&*)'
      : 'At least one special character (!@#\$%^&*)';

  // Password Reset Success Screen
  String get passwordResetSuccessfulTitle =>
      isHindi ? 'पासवर्ड रीसेट सफल रहा' : 'Password Reset Successful';
  String get passwordResetSuccessfulSubtitle => isHindi
      ? 'अब आप अपने नए पासवर्ड से लॉगिन कर सकते हैं।'
      : 'You can now log in with your new password.';

  // Register Screen
  String get nameLabel => isHindi ? 'नाम' : 'Name';

  // Dashboard Screen
  String get neetCommunity => isHindi ? 'नीट कम्युनिटी' : 'NEET Community';
  String get streakLabel => isHindi ? 'स्ट्रीक' : 'Streak';
  String get zeroDays => isHindi ? '0 दिन' : '0 days';
  String get aiDoubtsLeftLabel =>
      isHindi ? 'शेष एआई शंकाएं' : 'AI doubts left';
  String get doubtsCount => '5 / 5';
  String get todaysQuizTitle =>
      isHindi ? "आज की प्रश्नोत्तरी" : "Today's Quiz";
  String get todaysQuizSubtitle => isHindi
      ? 'दैनिक प्रश्नोत्तरी यहां दिखाई देगी (NEET-19)।'
      : 'Placeholder — daily quiz will appear here (NEET-19).';
  String get weakTopicsTitle =>
      isHindi ? 'कमजोर विषय' : 'Weak topics';
  String get weakTopicsSubtitle => isHindi
      ? 'किनेमेटिक्स · जेनेटिक्स · थर्मोडायनामिक्स'
      : 'Kinematics · Genetics · Thermodynamics';
  String get navHome => isHindi ? 'होम' : 'Home';
  String get navQuizzes => isHindi ? 'प्रश्नोत्तरी' : 'Quizzes';
  String get navLeaderboard => isHindi ? 'लीडरबोर्ड' : 'Leaderboard';
  String get navAiDoubt => isHindi ? 'एआई शंका' : 'AI Doubt';
}
