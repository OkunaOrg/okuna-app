import 'dart:async';
import 'package:Openbook/services/auth_api.dart';
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

  final _isOfLegalAgeSubject = ReplaySubject<bool>(maxSize: 1);
  final _nameSubject = ReplaySubject<String>(maxSize: 1);

  // Username begins

  Stream<bool> get usernameIsValid => _usernameIsValidSubject.stream;

  final _usernameIsValidSubject = ReplaySubject<bool>(maxSize: 1);

  Stream<String> get usernameFeedback => _usernameFeedbackSubject.stream;

  final _usernameFeedbackSubject = ReplaySubject<String>(maxSize: 1);

  Stream<String> get validatedUsername => _validatedUsernameSubject.stream;

  final _validatedUsernameSubject = ReplaySubject<String>(maxSize: 1);

  // Username ends

  final _emailSubject = ReplaySubject<String>(maxSize: 1);
  final _passwordSubject = ReplaySubject<String>(maxSize: 1);
  final _avatarSubject = ReplaySubject<File>(maxSize: 1);


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
    _isOfLegalAgeSubject.stream.listen(_onLegalAgeConfirmationChange);
    _nameSubject.stream.listen(_onNameChange);
    _emailSubject.stream.listen(_onEmailChange);
    _passwordSubject.listen(_onPasswordChange);
    _avatarSubject.listen(_onAvatarChange);
  }

  void dispose() {
    _isOfLegalAgeSubject.close();
    _nameSubject.close();
    _usernameIsValidSubject.close();
    _usernameFeedbackSubject.close();
    _validatedUsernameSubject.close();
    _emailSubject.close();
    _passwordSubject.close();
    _avatarIsValidSubject.close();
    _avatarFeedbackSubject.close();
    _validatedAvatarSubject.close();
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

  Future<bool> setUsername(String username) async {
    clearUsername();

    if (username == null) return Future.value(false);

    String usernameFeedback = _validationService.validateUserUsername(username);
    if (usernameFeedback != null) {
      _usernameFeedbackSubject.add(usernameFeedback);
      return Future.value(false);
    }

    var usernameSet = false;

    try {
      var usernameIsTaken = await _validationService.isUsernameTaken(username);

      if (!usernameIsTaken) {
        _onUsernameIsAvailable(username);
        return true;
      } else {
        _onUsernameIsNotAvailable(username);
      }
    } catch (error) {
      _onUsernameCheckServerError();
      rethrow;
    }

    return usernameSet;
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

  Future<bool> createAccount() async {
    _clearCreateAccount();

    _createAccountInProgressSubject.add(true);

    var accountWasCreated = false;

    try {
      HttpieStreamedResponse response = await _authApiService.createUser(
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
    _clearName();
    _clearEmail();
    _clearAvatar();
    _clearPassword();
    clearUsername();
  }
}

class UserRegistrationData {
  String name;
  bool isOfLegalAge;
  String birthday;
  String username;
  String email;
  String password;
  File avatar;
}
