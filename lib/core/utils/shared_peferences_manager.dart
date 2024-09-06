import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyIsPhoneVerified = 'is_phone_verified';
  //static const String _keyIsEmailVerified = 'is_email_verified';
  static const String _keyUserName = 'user_name';
  static const String _keyBearerToken = 'bearer_token';
  static const String _keySignUpCompleted = 'is_sign_up_completed';

  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save Email
  setUserEmail(String email) {
    _prefs.setString(_keyUserEmail, email);
  }

  // Get Email
  getUserEmail() {
    return _prefs.getString(_keyUserEmail) ?? "";
  }

  // Save Login Status
  setLoginStatus(bool isLoggedIn) {
    _prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  // Get Login Status
  bool getLoginStatus() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Save SignUp Status
  setSignUpStatus(bool isLoggedIn) {
    _prefs.setBool(_keySignUpCompleted, isLoggedIn);
  }

  bool getSignUpStatus() {
    return _prefs.getBool(_keySignUpCompleted) ?? false;
  }

  setPhoneVerificationStatus(bool isPhoneVerifiedIn) {
    _prefs.setBool(_keyIsPhoneVerified, isPhoneVerifiedIn);
  }

  bool getPhoneVerificationStatus() {
    return _prefs.getBool(_keyIsPhoneVerified) ?? false;
  }

  setBearerToken(String token) {
    _prefs.setString(_keyBearerToken, token);
  }

  String getBearerToken() {
    return _prefs.getString(_keyBearerToken) ?? "";
  }

  setUserName(String userName) {
    _prefs.setString(_keyUserName, userName);
  }

  getUserName() {
    return _prefs.getString(_keyUserName);
  }

  // Clear All Preferences
  clearAll() {
    _prefs.clear();
  }
}
