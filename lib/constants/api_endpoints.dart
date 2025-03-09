class ApiEndpoints {
  static const String baseUrl = 'https://privacydoctor.cryptcube.io';
  static const String privacy = '$baseUrl/api/privacyConverse';
  static const String signInUrl = '$baseUrl/api/auth/signin';
  static const String signUpUrl = '$baseUrl/api/auth/signup';
  static const String appManifest = '$baseUrl/appSupport/uploadAppManifest';
  static const String getOverallPrivacyScore = '$baseUrl/privacyScore/getOverallPrivacyScore';
  static const String getApplicationPrivacyScore = '$baseUrl/privacyScore/getApplicationPrivacyScore';
  static const String getOverallScoreExplanation = '$baseUrl/privacyScore/getOverallScoreExplanation';
  static const String getApplicationScoreExplanation = '$baseUrl/privacyScore/getApplicationScoreExplanation';
  static const String uploadAppDataVector = '$baseUrl/privacyScore/uploadAppDataVector';
}