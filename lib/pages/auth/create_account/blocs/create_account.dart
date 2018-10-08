import 'dart:async';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/validation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';


class CreateAccountBloc {
  ValidationService _validationService;
  LocalizationService _localizationService;

  // Serves as a snapshot to the data
  final userRegistrationData = UserRegistrationData();

  // Birthday begins

  Sink<DateTime> get birthday => _birthdayController.sink;
  final _birthdayController = StreamController<DateTime>();

  Stream<bool> get birthdayIsValid => _birthdayIsValidSubject.stream;

  final _birthdayIsValidSubject = BehaviorSubject<bool>();

  Stream<String> get birthdayFeedback => _birthdayFeedbackSubject.stream;

  final _birthdayFeedbackSubject = BehaviorSubject<String>();

  Stream<String> get validatedBirthday => _validatedBirthdaySubject.stream;

  final _validatedBirthdaySubject = BehaviorSubject<String>();

  // Birthday ends

  // Name begins

  Sink<String> get name => _nameController.sink;
  final _nameController = StreamController<String>();

  Stream<bool> get nameIsValid => _nameIsValidSubject.stream;

  final _nameIsValidSubject = BehaviorSubject<bool>();

  Stream<String> get nameFeedback => _nameFeedbackSubject.stream;

  final _nameFeedbackSubject = BehaviorSubject<String>();

  Stream<String> get validatedName => _validatedNameSubject.stream;

  final _validatedNameSubject = BehaviorSubject<String>();

  // Name ends

  // Username begins

  Sink<String> get username => _usernameController.sink;
  final _usernameController = StreamController<String>();

  Stream<bool> get usernameIsValid => _usernameIsValidSubject.stream;

  final _usernameIsValidSubject = BehaviorSubject<bool>();

  Stream<String> get usernameFeedback => _usernameFeedbackSubject.stream;

  final _usernameFeedbackSubject = BehaviorSubject<String>();

  Stream<String> get validatedUsername => _validatedUsernameSubject.stream;

  final _validatedUsernameSubject = BehaviorSubject<String>();

  StreamSubscription<bool> _usernameCheckSub;

  // Username ends

  // Email begins

  Sink<String> get email => _emailController.sink;
  final _emailController = StreamController<String>();

  Stream<bool> get emailIsValid => _emailIsValidSubject.stream;

  final _emailIsValidSubject = BehaviorSubject<bool>();

  Stream<String> get emailFeedback => _emailFeedbackSubject.stream;

  final _emailFeedbackSubject = BehaviorSubject<String>();

  Stream<String> get validatedEmail => _validatedEmailSubject.stream;

  final _validatedEmailSubject = BehaviorSubject<String>();

  StreamSubscription<bool> _emailCheckSub;

  // Email ends

  // Password begins

  Sink<String> get password => _passwordController.sink;
  final _passwordController = StreamController<String>();

  Stream<bool> get passwordIsValid => _passwordIsValidSubject.stream;

  final _passwordIsValidSubject = BehaviorSubject<bool>();

  Stream<String> get passwordFeedback => _passwordFeedbackSubject.stream;

  final _passwordFeedbackSubject = BehaviorSubject<String>();

  Stream<String> get validatedPassword => _validatedPasswordSubject.stream;

  final _validatedPasswordSubject = BehaviorSubject<String>();

  // Password ends

  CreateAccountBloc() {
    _emailController.stream.listen(_onEmail);
    _nameController.stream.listen(_onName);
    _passwordController.stream.listen(_onPassword);
    _usernameController.stream.listen(_onUsername);
    _birthdayController.stream.listen(_onBirthday);
  }

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  // Birthday begins

  void _onBirthday(DateTime birthday) {
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
    _onBirthdayIsInvalid();
  }

  void _onBirthdayIsInvalid() {
    _birthdayIsValidSubject.add(false);
    _validatedBirthdaySubject.add(null);
    userRegistrationData.birthday = null;
  }

  void _onBirthdayIsValid(DateTime birthday) {
    String parsedDate = new DateFormat.yMd().format(birthday);

    _birthdayFeedbackSubject.add(null);
    userRegistrationData.birthday = parsedDate;
    _validatedBirthdaySubject.add(parsedDate);
    _birthdayIsValidSubject.add(true);
  }

  // Birthday ends

  // Name begins

  bool hasName() {
    return userRegistrationData.name != null &&
        userRegistrationData.name.isNotEmpty;
  }

  void _onName(String name) {
    if (name == null || name.isEmpty) {
      _onNameIsEmpty();
      return;
    }

    if (name.length > 50) {
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
    _onNameIsInvalid();
  }

  void _onNameTooLong() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.NAME_MAX_LENGTH_ERROR');
    _nameFeedbackSubject.add(errorFeedback);
    _onNameIsInvalid();
  }

  void _onNameInvalidCharacters() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.NAME_CHARACTERS_ERROR');
    _nameFeedbackSubject.add(errorFeedback);
    _onNameIsInvalid();
  }

  void _onNameIsInvalid() {
    _nameIsValidSubject.add(false);
    _validatedNameSubject.add(null);
    userRegistrationData.name = null;
  }

  void _onNameIsValid(String name) {
    _nameFeedbackSubject.add(null);

    userRegistrationData.name = name;
    _validatedNameSubject.add(name);
    _nameIsValidSubject.add(true);
  }

  // Name ends

  // Username begins

  void _onUsername(String username) async {

    if(_usernameCheckSub != null){
      _usernameCheckSub.cancel();
      _usernameCheckSub = null;
    }

    if (username == null || username.isEmpty) {
      _onUsernameIsEmpty();
      return;
    }

    if (username.length > 50) {
      _onUsernameTooLong();
      return;
    }

    if (!_validationService.isAlphanumericWithUnderscores(username)) {
      _onUsernameInvalidCharacters();
      return;
    }

    _usernameCheckSub = _checkUsernameIsAvailable(username).asStream().listen((bool usernameIsAvailable){
      if(!usernameIsAvailable){
        _onUsernameIsNotAvailable(username);
        return;
      }

      String feedback =
      _localizationService.trans('AUTH.CREATE_ACC.USERNAME_SUCCESS');
      _usernameFeedbackSubject.add(feedback);

      _onUsernameIsValid(username);
    });
  }

  void _onUsernameIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_EMPTY_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);

    _onUsernameIsInvalid();
  }

  void _onUsernameTooLong() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_MAX_LENGTH_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);
    _onUsernameIsInvalid();
  }

  void _onUsernameInvalidCharacters() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.USERNAME_CHARACTERS_ERROR');
    _usernameFeedbackSubject.add(errorFeedback);
    _onUsernameIsInvalid();
  }

  void _onUsernameIsNotAvailable(String username) {
    String errorFeedback =
    _localizationService.trans('AUTH.CREATE_ACC.USERNAME_TAKEN_ERROR');

    String parsedFeedback = sprintf(errorFeedback, [username]);
    _usernameFeedbackSubject.add(parsedFeedback);
    _onUsernameIsInvalid();
  }

  void _onUsernameIsInvalid() {
    _usernameIsValidSubject.add(false);
    _validatedUsernameSubject.add(null);
    userRegistrationData.username = null;
  }

  void _onUsernameIsValid(String username) {
    userRegistrationData.username = username;
    _validatedUsernameSubject.add(username);
    _usernameIsValidSubject.add(true);
  }

  Future<bool> _checkUsernameIsAvailable(String username) async {

    String progressFeedback =
    _localizationService.trans('AUTH.CREATE_ACC.USERNAME_CHECK');
    _usernameFeedbackSubject.add(progressFeedback);

    return Future<bool>.delayed(new Duration(seconds: 3), () {
      return true;
    });
  }

  // Username ends

  // Email begins

  void _onEmail(String email) {

    if(_usernameCheckSub != null){
      _usernameCheckSub.cancel();
      _usernameCheckSub = null;
    }

    if (email == null || email.isEmpty) {
      _onEmailIsEmpty();
      return;
    }

    if (!_validationService.isQualifiedEmail(email)) {
      _onEmailIsNotQualifiedEmail();
      return;
    }

    _emailCheckSub = _checkEmailIsAvailable(email).asStream().listen((bool emailIsAvailable){
      if(!emailIsAvailable){
        _onEmailIsNotAvailable(email);
        return;
      }

      String feedback =
      _localizationService.trans('AUTH.CREATE_ACC.EMAIL_SUCCESS');
      _emailFeedbackSubject.add(feedback);

      _onEmailIsValid(email);
    });
  }

  void _onEmailIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.EMAIL_EMPTY_ERROR');
    _emailFeedbackSubject.add(errorFeedback);
    _onEmailIsInvalid();
  }

  void _onEmailIsNotQualifiedEmail() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.EMAIL_INVALID_ERROR');
    _emailFeedbackSubject.add(errorFeedback);
    _onEmailIsInvalid();
  }

  void _onEmailIsNotAvailable(String email) {
    String errorFeedback =
    _localizationService.trans('AUTH.CREATE_ACC.EMAIL_TAKEN_ERROR');

    String parsedFeedback = sprintf(errorFeedback, [email]);
    _emailFeedbackSubject.add(parsedFeedback);
    _onEmailIsInvalid();
  }

  void _onEmailIsInvalid() {
    _emailIsValidSubject.add(false);
    _validatedEmailSubject.add(null);
    userRegistrationData.email = null;
  }

  void _onEmailIsValid(String email) {
    userRegistrationData.email = email;
    _validatedEmailSubject.add(email);
    _emailIsValidSubject.add(true);
  }

  Future<bool> _checkEmailIsAvailable(String email) async {

    String progressFeedback =
    _localizationService.trans('AUTH.CREATE_ACC.EMAIL_CHECK');
    _emailFeedbackSubject.add(progressFeedback);

    return Future<bool>.delayed(new Duration(seconds: 3), () {
      return true;
    });
  }

  // Email ends

  // Password begins

  void _onPassword(String password) {
    if (password == null || password.isEmpty) {
      _onPasswordIsEmpty();
      return;
    }

    if (password.length < 8) {
      _onPasswordTooSmall();
      return;
    }

    if (password.length > 64) {
      _onPasswordTooLong();
      return;
    }

    _onPasswordIsValid(password);
  }

  void _onPasswordIsEmpty() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.PASSWORD_EMPTY_ERROR');
    _passwordFeedbackSubject.add(errorFeedback);
    _onPasswordIsInvalid();
  }

  void _onPasswordTooSmall() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.PASSWORD_MIN_LENGTH_ERROR');
    _passwordFeedbackSubject.add(errorFeedback);
    _onPasswordIsInvalid();
  }

  void _onPasswordTooLong() {
    String errorFeedback =
        _localizationService.trans('AUTH.CREATE_ACC.PASSWORD_MIN_LENGTH_ERROR');
    _passwordFeedbackSubject.add(errorFeedback);
    _onPasswordIsInvalid();
  }

  void _onPasswordIsInvalid() {
    _passwordIsValidSubject.add(false);
    _validatedPasswordSubject.add(null);
    userRegistrationData.email = null;
  }

  void _onPasswordIsValid(String password) {
    _passwordFeedbackSubject.add(null);

    userRegistrationData.password = password;
    _validatedPasswordSubject.add(password);
    _passwordIsValidSubject.add(true);
  }

// Password ends
}

class UserRegistrationData {
  String name;
  String birthday;
  String username;
  String email;
  String password;
}
