import 'dart:async';
import 'dart:convert';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/user.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

class CreateAccountBloc {
  // @todo: rename to CreateAccountService?
  LocalizationService _localizationService;
  AuthApiService _authApiService;
  UserService _userService;

  // Serves as a snapshot to the data
  final userRegistrationData = UserRegistrationData();

  final _isOfLegalAgeSubject = ReplaySubject<bool>(maxSize: 1);
  final _nameSubject = ReplaySubject<String>(maxSize: 1);
  final _emailSubject = ReplaySubject<String>(maxSize: 1);
  final _passwordSubject = ReplaySubject<String>(maxSize: 1);
  final _avatarSubject = ReplaySubject<File>(maxSize: 1);
  final _usernameSubject = ReplaySubject<String>(maxSize: 1);
  final registrationTokenSubject = ReplaySubject<String>(maxSize: 1);

  // Create account begins

  Stream<bool> get createAccountInProgress =>
      _createAccountInProgressSubject.stream;

  final _createAccountInProgressSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get createAccountErrorFeedback =>
      _createAccountErrorFeedbackSubject.stream;

  final _createAccountErrorFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  // Create account ends

  CreateAccountBloc() {
    _isOfLegalAgeSubject.stream.listen(_onLegalAgeConfirmationChange);
    _nameSubject.stream.listen(_onNameChange);
    _emailSubject.stream.listen(_onEmailChange);
    _passwordSubject.listen(_onPasswordChange);
    _avatarSubject.listen(_onAvatarChange);
    registrationTokenSubject.listen(_onTokenChange);
  }

  void dispose() {
    _isOfLegalAgeSubject.close();
    _nameSubject.close();
    _emailSubject.close();
    _passwordSubject.close();
    _avatarSubject.close();
    _usernameSubject.close();
    registrationTokenSubject.close();
  }

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setUserService(UserService userService) {
    _userService = userService;
  }

  // Legal Age Confirmation

  bool isOfLegalAge() {
    return userRegistrationData.isOfLegalAge;
  }

  void _onLegalAgeConfirmationChange(bool isOfLegalAge) {
    userRegistrationData.isOfLegalAge = isOfLegalAge;
  }

  void setLegalAgeConfirmation(bool isOfLegalAge) {
    _isOfLegalAgeSubject.add(isOfLegalAge);
  }

  // Name begins

  bool hasName() {
    return userRegistrationData.name != null;
  }

  String getName() {
    return userRegistrationData.name;
  }

  void setName(String name) {
    _nameSubject.add(name);
  }

  void _onNameChange(String name) {
    if (name == null) return;
    userRegistrationData.name = name;
  }

  void _clearName() {
    userRegistrationData.name = null;
  }

  // Name ends

  // Username begins

  bool hasUsername() {
    return userRegistrationData.username != null;
  }

  String getUsername() {
    return userRegistrationData.username;
  }

  void setUsername(String username) async {
    if (username == null) return;
    userRegistrationData.username = username;
  }

  void clearUsername() {
    userRegistrationData.username = null;
  }

  // Username ends

  // Email begins

  bool hasEmail() {
    return userRegistrationData.email != null;
  }

  String getEmail() {
    return userRegistrationData.email;
  }

  void setEmail(String email) async {
    _emailSubject.add(email);
  }

  void _onEmailChange(String email) {
    if (email == null) return;
    userRegistrationData.email = email;
  }

  void _clearEmail() {
    userRegistrationData.email = null;
  }

  // Email ends

  // Password begins

  bool hasPassword() {
    return userRegistrationData.password != null;
  }

  String getPassword() {
    return userRegistrationData.password;
  }

  void _onPasswordChange(String password) {
    if (password == null) return;
    userRegistrationData.password = password;
  }

  void setPassword(String password) {
    _passwordSubject.add(password);
  }

  void _clearPassword() {
    userRegistrationData.password = null;
  }

// Password ends

  // Avatar begins

  bool hasAvatar() {
    return userRegistrationData.avatar != null;
  }

  File getAvatar() {
    return userRegistrationData.avatar;
  }

  void setAvatar(File avatar) {
    _avatarSubject.add(avatar);
  }

  void _onAvatarChange(File avatar) {
    if (avatar == null) {
      // Avatar is optional, therefore no feedback to user.
      return;
    }
    userRegistrationData.avatar = avatar;
  }

  void _clearAvatar() {
    userRegistrationData.avatar = null;
  }

  // Avatar ends

  // Registration Token begins
  bool hasToken() {
    return userRegistrationData.token != null;
  }

  String getToken() {
    return userRegistrationData.token;
  }

  void setToken(String token) async {
    registrationTokenSubject.add(token);
  }

  void _onTokenChange(String token) {
    if (token == null) return;
    userRegistrationData.token = token;
  }

  void _clearToken() {
    userRegistrationData.token = null;
  }

  // Registration Token ends

  Future<bool> createAccount() async {
    _clearCreateAccount();

    _createAccountInProgressSubject.add(true);

    var accountWasCreated = false;

    try {
      HttpieStreamedResponse response = await _authApiService.createUser(
          email: userRegistrationData.email,
          isOfLegalAge: userRegistrationData.isOfLegalAge,
          name: userRegistrationData.name,
          token: userRegistrationData.token,
          password: userRegistrationData.password,
          avatar: userRegistrationData.avatar);

      if (!response.isCreated()) throw HttpieRequestError(response);
      accountWasCreated = true;
      Map<String, dynamic> responseData =
          jsonDecode(await response.readAsString());
      setUsername(responseData['username']);
      _userService.loginWithAuthToken(responseData['token']);
    } catch (error) {
      if (error is HttpieConnectionRefusedError) {
        _onCreateAccountValidationError(error.toHumanReadableMessage());
      } else if (error is HttpieRequestError) {
        String errorMessage = await error.toHumanReadableMessage();
        _onCreateAccountValidationError(errorMessage);
      } else {
        _onCreateAccountValidationError('Unknown error');
        rethrow;
      }
    }

    return accountWasCreated;
  }

  void _onCreateAccountValidationError(String errorMessage) {
    _createAccountErrorFeedbackSubject.add(errorMessage);
  }

  void _clearCreateAccount() {
    _createAccountInProgressSubject.add(null);
    _createAccountErrorFeedbackSubject.add(null);
  }

  void clearAll() {
    _clearCreateAccount();
    _clearName();
    _clearEmail();
    _clearAvatar();
    _clearPassword();
    _clearToken();
  }
}

class UserRegistrationData {
  String token;
  String name;
  bool isOfLegalAge;
  String username;
  String email;
  String password;
  File avatar;
}
