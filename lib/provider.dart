import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/auth-api.dart';
import 'package:Openbook/services/environment-loader.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/posts-api.dart';
import 'package:Openbook/services/secure-storage.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:flutter/material.dart';

class OpenbookProvider extends StatefulWidget {
  Widget child;

  OpenbookProvider({this.child});

  @override
  OpenbookProviderState createState() {
    return OpenbookProviderState();
  }

  static OpenbookProviderState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_OpenbookProvider)
            as _OpenbookProvider)
        .data;
  }
}

class OpenbookProviderState extends State<OpenbookProvider> {
  CreateAccountBloc createAccountBloc = CreateAccountBloc();
  ValidationService validationService = ValidationService();
  HttpieService httpService = HttpieService();
  AuthApiService authApiService = AuthApiService();
  PostsApiService postsApiService = PostsApiService();
  SecureStorageService secureStorageService = SecureStorageService();
  UserService userService = UserService();
  LocalizationService localizationService;

  @override
  void initState() {
    super.initState();
    initAsyncState();

    createAccountBloc.setValidationService(validationService);
    authApiService.setHttpService(httpService);
    createAccountBloc.setAuthApiService(authApiService);
    userService.setAuthApiService(authApiService);
    userService.setPostsApiService(postsApiService);
    userService.setHttpieService(httpService);
    userService.setSecureStorageService(secureStorageService);
  }

  void initAsyncState() async {
    Environment environment =
        await EnvironmentLoader(environmentPath: ".env.json").load();
    authApiService.setApiURL(environment.API_URL);
  }

  @override
  Widget build(BuildContext context) {
    return new _OpenbookProvider(
      data: this,
      child: widget.child,
    );
  }

  setLocalizationService(LocalizationService newLocalizationService) {
    localizationService = newLocalizationService;
    createAccountBloc.setLocalizationService(localizationService);
    httpService.setLocalizationService(localizationService);
  }

  setValidationService(ValidationService newValidationService) {
    validationService = newValidationService;
    createAccountBloc.setValidationService(validationService);
  }
}

class _OpenbookProvider extends InheritedWidget {
  final OpenbookProviderState data;

  _OpenbookProvider({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_OpenbookProvider old) {
    return true;
  }
}
