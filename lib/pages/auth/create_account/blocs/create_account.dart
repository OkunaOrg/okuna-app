import 'dart:async';
import 'package:Openbook/services/auth-api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/validation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:sprintf/sprintf.dart';

/// TODO This was the first ever logic component/service.
/// Documentation and patterns from google for state management, logic encapsulation,
/// and more are quite crappy at this stage. Therefore this file resulted to be an experiment
/// which tried some of the patterns and we quickly discovered their shortcomings
/// and awkwardness. We need to rework this file in the future with the user
/// experience in mind rather than sticking to a pattern such as the BLOC which
/// dictates that everything is input and output streams. Leaving no room
/// for one time operations and behaviour related specifically to those kind
/// of operations.
/// The resulting veredict is.. use streams for eventful data. Provide methods
/// for actions rather than "Sinks" as they can be explicit about the operation
/// performed on the arguments and have a beginning and an ending which can
/// be easily reflected in the UI instead of having stream subscriptions
/// to the beginning or end of these all over the place instead of the
/// place where called. Implicit vs explicit.

class CreateAccountBloc {
  ValidationService _validationService;
  LocalizationService _localizationService;
  AuthApiService _authApiService;

  // Serves as a snapshot to the data
  final userRegistrationData = UserRegistrationData();

  // Birthday begins

  Sink<DateTime> get birthday => _birthdayController.sink;
  final _birthdayController = StreamController<DateTime>();

  Stream<bool> get birthdayIsValid => _birthdayIsValidSubject.stream;

  final _birthdayIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get birthdayFeedback => _birthdayFeedbackSubject.stream;

  final _birthdayFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<String> get validatedBirthday => _validatedBirthdaySubject.stream;

  final _validatedBirthdaySubject = ReplaySubject<String>(maxSize: 1);

  // Birthday ends

  // Name begins

  Sink<String> get name => _nameController.sink;
  final _nameController = StreamController<String>();

  Stream<bool> get nameIsValid => _nameIsValidSubject.stream;

  final _nameIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get nameFeedback => _nameFeedbackSubject.stream;

  final _nameFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<String> get validatedName => _validatedNameSubject.stream;

  final _validatedNameSubject = ReplaySubject<String>(maxSize: 1);

  // Name ends

  // Username begins

  Stream<bool> get usernameIsValid => _usernameIsValidSubject.stream;

  final _usernameIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get usernameFeedback => _usernameFeedbackSubject.stream;

  final _usernameFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<String> get validatedUsername => _validatedUsernameSubject.stream;

  final _validatedUsernameSubject = ReplaySubject<String>(maxSize: 1);

  // Username ends

  // Email begins

  Stream<bool> get emailIsValid => _emailIsValidSubject.stream;

  final _emailIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get emailFeedback => _emailFeedbackSubject.stream;

  final _emailFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<String> get validatedEmail => _validatedEmailSubject.stream;

  final _validatedEmailSubject = ReplaySubject<String>(maxSize: 1);

  // Email ends

  // Password begins

  Sink<String> get password => _passwordController.sink;
  final _passwordController = StreamController<String>();

  Stream<bool> get passwordIsValid => _passwordIsValidSubject.stream;

  final _passwordIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get passwordFeedback => _passwordFeedbackSubject.stream;

  final _passwordFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<String> get validatedPassword => _validatedPasswordSubject.stream;

  final _validatedPasswordSubject = ReplaySubject<String>(maxSize: 1);

  // Password ends

  // Avatar begins

  Sink<File> get avatar => _avatarController.sink;
  final _avatarController = StreamController<File>();

  Stream<bool> get avatarIsValid => _avatarIsValidSubject.stream;

  final _avatarIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get avatarFeedback => _avatarFeedbackSubject.stream;

  final _avatarFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<File> get validatedAvatar => _validatedAvatarSubject.stream;

  final _validatedAvatarSubject = ReplaySubject<File>(maxSize: 1);

  // Avatar ends

  // Create account begins

  Stream<bool> get createAccountInProgress =>
      _createAccountInProgressSubject.stream;

  final _createAccountInProgressSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get createAccountErrorFeedback =>
      _createAccountErrorFeedbackSubject.stream;

  final _createAccountErrorFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  // Create account ends

  CreateAccountBloc() {
    _nameController.stream.listen(_onName);
    _passwordController.stream.listen(_onPassword);
    _birthdayController.stream.listen(_onBirthday);
    _avatarController.stream.listen(_onAvatar);
  }

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  // Birthday begins

  bool hasBirthday() {
    return userRegistrationData.birthday != null;
  }

  String getBirthday() {
    return userRegistrationData.birthday;
  }

  void _onBirthday(DateTime birthday) {
    _clearBirthday();

    if (birthday == null) {
      _onBirthdayIsEmpty();
      return;
    }

    if (!_validationService.isValidBirthday(birthday)) {
      _onBirthdayIsInvalid();
      return;
    }

    _onBirthdayIsValid(birthday);
  }

  void _onBirthdayIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.BIRTHDAY_EMPTY_ERROR');
    _birthdayFeedbackSubject.add(errorFeedback);
  }

  void _onBirthdayIsInvalid() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.BIRTHDAY_INVALID_ERROR');
    _birthdayFeedbackSubject.add(errorFeedback);
  }

  void _onBirthdayIsValid(DateTime birthday) {
    String parsedDate = DateFormat('dd-MM-yyyy').format(birthday);

    _birthdayFeedbackSubject.add(null);
    userRegistrationData.birthday = parsedDate;
    _validatedBirthdaySubject.add(parsedDate);
    _birthdayIsValidSubject.add(true);
  }

  void _clearBirthday() {
    _birthdayIsValidSubject.add(false);
    _validatedBirthdaySubject.add(null);
    userRegistrationData.birthday = null;
  }

  // Birthday ends

  // Name begins

  bool hasName() {
    return userRegistrationData.name != null;
  }

  String getName() {
    return userRegistrationData.name;
  }

  void _onName(String name) {
    _clearName();

    if (name == null || name.isEmpty) {
      _onNameIsEmpty();
      return;
    }

    if (!_validationService.isNameAllowedLength(name)) {
      _onNameTooLong();
      return;
    }

    if (!_validationService.isAlphanumericWithSpaces(name)) {
      _onNameInvalidCharacters();
      return;
    }

    _onNameIsValid(name);
  }

  void _onNameIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.NAME_EMPTY_ERROR');
    _nameFeedbackSubject.add(errorFeedback);
  }

  void _onNameTooLong() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.NAME_LENGTH_ERROR');
    _nameFeedbackSubject.add(errorFeedback);
  }

  void _onNameInvalidCharacters() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.NAME_CHARACTERS_ERROR');
    _nameFeedbackSubject.add(errorFeedback);
  }

  void _onNameIsValid(String name) {
    _nameFeedbackSubject.add(null);

    userRegistrationData.name = name;
    _validatedNameSubject.add(name);
    _nameIsValidSubject.add(true);
  }

  void _clearName() {
    _nameIsValidSubject.add(false);
    _validatedNameSubject.add(null);
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

  Future<bool> setUsername(String username) async {
    clearUsername();

    if (username == null || username.isEmpty) {
      _onUsernameIsEmpty();
      return Future.value(false);
    }

    if (!_validationService.isUsernameAllowedLength(username)) {
      _onUsernameTooLong();
      return Future.value(false);
    }

    if (!_validationService.isUsernameAllowedCharacters(username)) {
      _onUsernameInvalidCharacters();
      return Future.value(false);
    }

    var isAvailable = false;

    try {
      HttpieResponse response = await _checkUsernameIsAvailable(username);
      if (response.isAccepted()) {
        _onUsernameIsAvailable(username);
        isAvailable = true;
      } else if (response.isBadRequest()) {
        _onUsernameIsNotAvailable(username);
      } else {
        _onUsernameCheckServerError();
      }
    } catch (error) {
      _onUsernameCheckServerError();
      rethrow;
    }
    return isAvailable;
  }

  void _onUsernameIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_EMPTY_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);
  }

  void _onUsernameTooLong() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_LENGTH_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);
  }

  void _onUsernameInvalidCharacters() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_CHARACTERS_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);
  }

  void _onUsernameIsAvailable(String username) {
    _usernameFeedbackSubject.add(null);

    _onUsernameIsValid(username);
  }

  void _onUsernameIsNotAvailable(String username) {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_TAKEN_ERROR');

    String parsedFeedback = sprintf(errorFeedback, [username]);
    _usernameFeedbackSubject.add(parsedFeedback);
  }

  void _onUsernameCheckServerError() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_SERVER_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);
  }

  void clearUsername() {
    _usernameFeedbackSubject.add(null);
    _usernameIsValidSubject.add(false);
    _validatedUsernameSubject.add(null);
    userRegistrationData.username = null;
  }

  void _onUsernameIsValid(String username) {
    userRegistrationData.username = username;
    _validatedUsernameSubject.add(username);
    _usernameIsValidSubject.add(true);
  }

  Future<HttpieResponse> _checkUsernameIsAvailable(String username) {
    return _authApiService.checkUsernameIsAvailable(username: username);
  }

  // Username ends

  // Email begins

  bool hasEmail() {
    return userRegistrationData.email != null;
  }

  String getEmail() {
    return userRegistrationData.email;
  }

  Future<bool> setEmail(String email) async {
    clearEmail();

    if (email == null || email.isEmpty) {
      _onEmailIsEmpty();
      return Future.value(false);
    }

    if (!_validationService.isQualifiedEmail(email)) {
      _onEmailIsNotQualifiedEmail();
      return Future.value(false);
    }

    bool emailIsAvailable = false;

    try {
      HttpieResponse response = await _checkEmailIsAvailable(email);
      if (response.isAccepted()) {
        _onEmailIsAvailable(email);
        emailIsAvailable = true;
      } else if (response.isBadRequest()) {
        _onEmailIsNotAvailable(email);
      } else {
        _onEmailCheckServerError();
      }
    } catch (error) {
      _onEmailCheckServerError();
      rethrow;
    }

    return emailIsAvailable;
  }

  void _onEmailIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.EMAIL_EMPTY_ERROR');
    _emailFeedbackSubject.add(errorFeedback);
  }

  void _onEmailIsNotQualifiedEmail() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.EMAIL_INVALID_ERROR');
    _emailFeedbackSubject.add(errorFeedback);
  }

  void _onEmailIsNotAvailable(String email) {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.EMAIL_TAKEN_ERROR');

    String parsedFeedback = sprintf(errorFeedback, [email]);
    _emailFeedbackSubject.add(parsedFeedback);
  }

  void _onEmailIsAvailable(String email) {
    _onEmailIsValid(email);
  }

  void _onEmailIsValid(String email) {
    userRegistrationData.email = email;
    _validatedEmailSubject.add(email);
    _emailIsValidSubject.add(true);
  }

  Future<HttpieResponse> _checkEmailIsAvailable(String email) async {
    return _authApiService.checkEmailIsAvailable(email: email);
  }

  void _onEmailCheckServerError() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.EMAIL_SERVER_ERROR');
    _emailFeedbackSubject.add(errorFeedback);
  }

  void clearEmail() {
    _emailFeedbackSubject.add(null);
    _emailIsValidSubject.add(false);
    _validatedEmailSubject.add(null);
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

  void _onPassword(String password) {
    _clearPassword();

    if (password == null || password.isEmpty) {
      _onPasswordIsEmpty();
      return;
    }

    if (!_validationService.isPasswordAllowedLength(password)) {
      _onPasswordLengthError();
      return;
    }

    _onPasswordIsValid(password);
  }

  void _onPasswordIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.PASSWORD_EMPTY_ERROR');
    _passwordFeedbackSubject.add(errorFeedback);
  }

  void _onPasswordLengthError() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.PASSWORD_LENGTH_ERROR');
    _passwordFeedbackSubject.add(errorFeedback);
  }

  void _onPasswordIsValid(String password) {
    _passwordFeedbackSubject.add(null);

    userRegistrationData.password = password;
    _validatedPasswordSubject.add(password);
    _passwordIsValidSubject.add(true);
  }

  void _clearPassword() {
    _passwordIsValidSubject.add(false);
    _validatedPasswordSubject.add(null);
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

  void _onAvatar(File avatar) {
    _clearAvatar();

    if (avatar == null) {
      // Avatar is optional, therefore no feedback to user.
      return;
    }

    _onAvatarIsValid(avatar);
  }

  void _onAvatarIsValid(File avatar) {
    userRegistrationData.avatar = avatar;
    _validatedAvatarSubject.add(avatar);
    _avatarIsValidSubject.add(true);
  }

  void _clearAvatar() {
    _avatarIsValidSubject.add(false);
    _validatedAvatarSubject.add(null);
    if (userRegistrationData.avatar != null) {
      userRegistrationData.avatar.deleteSync();
    }
    userRegistrationData.avatar = null;
  }

// Email ends

  Future<bool> createAccount() async {
    _clearCreateAccount();

    _createAccountInProgressSubject.add(true);

    var accountWasCreated = false;

    try {
      HttpieStreamedResponse response = await _authApiService.createAccount(
          email: userRegistrationData.email,
          username: userRegistrationData.username,
          name: userRegistrationData.name,
          birthDate: userRegistrationData.birthday,
          password: userRegistrationData.password,
          avatar: userRegistrationData.avatar);
      if (response.isCreated()) {
        accountWasCreated = true;
      } else if (response.isBadRequest()) {
        _onCreateAccountValidationError(response);
      } else {
        _onCreateAccountServerError();
      }
    } catch (error) {
      _onCreateAccountServerError();
      rethrow;
    }

    return accountWasCreated;
  }

  void _onCreateAccountServerError() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.SUBMIT_ERROR_DESC_SERVER');

    _createAccountErrorFeedbackSubject.add(errorFeedback);
  }

  void _onCreateAccountValidationError(HttpieStreamedResponse response) {
    // Validation errors.
    // TODO Display specific validation errors.
    String errorFeedback = _localizationService
        .trans('AUTH.CREATE_ACC.SUBMIT_ERROR_DESC_VALIDATION');

    _createAccountErrorFeedbackSubject.add(errorFeedback);
  }

  void _clearCreateAccount() {
    _createAccountInProgressSubject.add(null);
    _createAccountErrorFeedbackSubject.add(null);
  }

  void clearAll() {
    _clearCreateAccount();
    _clearBirthday();
    _clearName();
    clearEmail();
    _clearAvatar();
    clearUsername();
  }
}

class UserRegistrationData {
  String name;
  String birthday;
  String username;
  String email;
  String password;
  File avatar;
}
