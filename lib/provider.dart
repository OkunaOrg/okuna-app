import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/connections_api.dart';
import 'package:Openbook/services/date_picker.dart';
import 'package:Openbook/services/emojis_api.dart';
import 'package:Openbook/services/environment_loader.dart';
import 'package:Openbook/services/file_cache.dart';
import 'package:Openbook/services/follows_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/posts_api.dart';
import 'package:Openbook/services/storage.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/toast.dart';
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
  StorageService storageService = StorageService();
  UserService userService = UserService();
  ToastService toastService = ToastService();
  FileCacheService fileCacheService = FileCacheService();
  StringTemplateService stringTemplateService = StringTemplateService();
  EmojisApiService emojisApiService = EmojisApiService();
  ThemeService themeService = ThemeService();
  ImagePickerService imagePickerService = ImagePickerService();
  DatePickerService datePickerService = DatePickerService();
  FollowsApiService followsApiService = FollowsApiService();
  ConnectionsApiService connectionsApiService = ConnectionsApiService();

  LocalizationService localizationService;

  @override
  void initState() {
    super.initState();
    initAsyncState();

    createAccountBloc.setValidationService(validationService);
    connectionsApiService.setHttpService(httpService);
    authApiService.setHttpService(httpService);
    followsApiService.setHttpService(httpService);
    createAccountBloc.setAuthApiService(authApiService);
    userService.setAuthApiService(authApiService);
    userService.setPostsApiService(postsApiService);
    userService.setEmojisApiService(emojisApiService);
    userService.setHttpieService(httpService);
    userService.setStorageService(storageService);
    userService.setFollowsApiService(followsApiService);
    userService.setConnectionsApiService(connectionsApiService);
    emojisApiService.setHttpService(httpService);
    postsApiService.setHttpieService(httpService);
    postsApiService.setStringTemplateService(stringTemplateService);
    validationService.setAuthApiService(authApiService);
  }

  void initAsyncState() async {
    Environment environment =
        await EnvironmentLoader(environmentPath: ".env.json").load();
    authApiService.setApiURL(environment.API_URL);
    postsApiService.setApiURL(environment.API_URL);
    emojisApiService.setApiURL(environment.API_URL);
    followsApiService.setApiURL(environment.API_URL);
    connectionsApiService.setApiURL(environment.API_URL);
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
