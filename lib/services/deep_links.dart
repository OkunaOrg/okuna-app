import 'dart:async';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/auth_api.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

class DeepLinksService {
  StreamSubscription _sub;
  StreamSubscription _onLoggedInUserChangeSubscription;
  AuthApiService _authApiService;
  ToastService _toastService;
  UserService _userService;
  CreateAccountBloc _createAccountBloc;
  bool _areAppLinksInitialised = false;
  static const String VERIFY_EMAIL_LINK = '/api/auth/email/verify';
  static const String CREATE_ACCOUNT_LINK = '/api/auth/invite';


  Future<Null> initUniLinks() async {
    if (_areAppLinksInitialised) return;
    _areAppLinksInitialised = true;
    print('Initialising universal links');
    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      print('This is the link from stream:: $link');
      // Parse the link and warn the user, if it is not correct
      _handleLink(link);
    }, onError: (err) {
      print(err);
      // Handle exception by warning the user their action did not succeed
      _toastService.error(message: 'Oops! Something went wrong, please try again', context: null);
    });

    try {
      String initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print('This is the initial link:: $initialLink');
      _handleLink(initialLink);
    } on PlatformException {
      print('Platform exception occurred');
      // Handle exception by warning the user their action did not succeed
      _toastService.error(message: 'Oops! Something went wrong, please try again', context: null);
      return;
    }
  }

  void _handleLink(String link) async {
    if (link == null) return;
    if (link.indexOf(VERIFY_EMAIL_LINK) != -1) {
      final token = _getEmailVerificationTokenFromLink(link);
      _onLoggedInUserChangeSubscription = _userService.loggedInUserChange.listen((User newUser){
        _onLoggedInUserChange(newUser, token);
      });
    } else if (link.indexOf(CREATE_ACCOUNT_LINK) != -1) {
      final String token = _getAccountCreationTokenFromLink(link);
      _createAccountBloc.setToken(token);
    }
  }

  _onLoggedInUserChange(User newUser, String token) async {
    try {
      HttpieResponse response = await _authApiService.verifyEmailWithToken(token);
      if (response.isOk()) {
        _toastService.success(message: 'Awesome! Your email is now verified', context: null);
      }  else if (response.isUnauthorized()) {
        _toastService.error(message: 'Oops! Your token was not valid or expired, please try again', context: null);
      }
    } on HttpieConnectionRefusedError {
    _toastService.error(message: 'No internet connection', context: null);
    } catch (e) {
    _toastService.error(message: 'Unknown error.', context: null);
    rethrow;
    }
  }

  String _getAccountCreationTokenFromLink(String link) {
    final params = Uri.parse(link).queryParametersAll;
    var token = '';
    if (params.containsKey('token')) {
      token = params['token'][0];
    }
    return token;
  }

  String _getEmailVerificationTokenFromLink(String link) {
    final linkParts = _getDeepLinkParts(link);
    return linkParts[linkParts.length - 1];
  }

  List<String> _getDeepLinkParts(String link) {
    final uri = Uri.parse(link);
    return uri.path.split('/');
  }

  void clearSubscriptionStreams() {
    _sub.cancel();
    _onLoggedInUserChangeSubscription.cancel();
  }

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setToastService(ToastService toastService) {
    _toastService = toastService;
  }

  void setUserService(UserService userService) {
    _userService = userService;
  }

  void setCreateAccountBloc(CreateAccountBloc createAccountBloc) {
    _createAccountBloc = createAccountBloc;
  }
}
