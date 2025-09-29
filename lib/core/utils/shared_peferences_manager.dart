import 'package:rapidlie/features/user/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyIsPhoneVerified = 'is_phone_verified';
  //static const String _keyIsEmailVerified = 'is_email_verified';
  static const String _keyUserName = 'user_name';
  static const String _keyBearerToken = 'bearer_token';
  static const String _keySignUpCompleted = 'is_sign_up_completed';
  static const String _keyUserId = 'user_id';
  static const String _keyName = 'name';
  static const String _keyTelephone = 'telephone';
  static const String _keyProfileImageLink = 'profile_image';
  static const String _keyRegistrationStep = 'registration_step';
  static const String _keyLanguageCode = 'language_code';
  static const String _keyCountryCode = 'country_code';

  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //save registration step
  setRegistrationStep(String step) {
    _prefs.setString(_keyRegistrationStep, step);
  }

  //get registration step
  getRegistrationStep() {
    return _prefs.getString(_keyRegistrationStep) ?? "";
  }

  setLanguage(String langCode) {
    _prefs.setString(_keyLanguageCode, langCode);
  }

  //get registration step
  getLanguage() {
    return _prefs.getString(_keyLanguageCode) ?? "";
  }

  setCountry(String country) {
    _prefs.setString(_keyCountryCode, country);
  }

  //get registration step
  getCountry() {
    return _prefs.getString(_keyCountryCode) ?? "";
  }

  // Save Email
  setUserEmail(String email) {
    _prefs.setString(_keyUserEmail, email);
  }

  // Get Email
  getUserEmail() {
    return _prefs.getString(_keyUserEmail) ?? "";
  }

  // Save User ID
  setUserId(String userId) {
    _prefs.setString(_keyUserId, userId);
  }

  // Get User ID
  getUserId() {
    return _prefs.getString(_keyUserId) ?? "";
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

  setName(String name) {
    _prefs.setString(_keyName, name);
  }

  getName() {
    return _prefs.getString(_keyName);
  }

  setTelephone(String telephone) {
    _prefs.setString(_keyTelephone, telephone);
  }

  getTelephone() {
    return _prefs.getString(_keyTelephone) ?? "";
  }

  // Save User Image
  setProfileImage(String userImage) {
    _prefs.setString(_keyProfileImageLink, userImage);
  }

  // Get User Image
  getProfileImage() {
    return _prefs.getString(_keyProfileImageLink) ?? "";
  }

  Future<void> saveUser(UserModel user) async {
    setUserEmail(user.email);
    setUserId(user.uuid);
    setName(user.name);
    setTelephone(user.phone);
    setLoginStatus(true);
  }

  // Clear All Preferences
  clearAll() {
    _prefs.clear();
    /* Get.offAllNamed(LoginScreen.routeName);
    context.go('/login'); */
  }
}
