import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/connections_circles_api.dart';
import 'package:Openbook/services/connections_api.dart';
import 'package:Openbook/services/date_picker.dart';
import 'package:Openbook/services/deep_links.dart';
import 'package:Openbook/services/emoji_picker.dart';
import 'package:Openbook/services/emojis_api.dart';
import 'package:Openbook/services/environment_loader.dart';
import 'package:Openbook/services/file_cache.dart';
import 'package:Openbook/services/follows_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/follows_lists_api.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/posts_api.dart';
import 'package:Openbook/services/storage.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
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
  EmojiPickerService emojiPickerService = EmojiPickerService();
  FollowsApiService followsApiService = FollowsApiService();
  ConnectionsApiService connectionsApiService = ConnectionsApiService();
  ConnectionsCirclesApiService connectionsCirclesApiService =
      ConnectionsCirclesApiService();
  FollowsListsApiService followsListsApiService = FollowsListsApiService();
  ThemeValueParserService themeValueParserService = ThemeValueParserService();

  LocalizationService localizationService;
  DeepLinksService deepLinksService = DeepLinksService();

  @override
  void initState() {
    super.initState();
    initAsyncState();
    deepLinksService.setAuthApiService(authApiService);
    deepLinksService.setToastService(toastService);
    deepLinksService.setUserService(userService);
    createAccountBloc.setValidationService(validationService);
    connectionsCirclesApiService.setHttpService(httpService);
    connectionsCirclesApiService
        .setStringTemplateService(stringTemplateService);
    followsListsApiService.setHttpService(httpService);
    followsListsApiService.setStringTemplateService(stringTemplateService);
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
    userService.setFollowsListsApiService(followsListsApiService);
    userService.setConnectionsApiService(connectionsApiService);
    userService.setConnectionsCirclesApiService(connectionsCirclesApiService);
    emojisApiService.setHttpService(httpService);
    postsApiService.setHttpieService(httpService);
    postsApiService.setStringTemplateService(stringTemplateService);
    validationService.setAuthApiService(authApiService);
    validationService.setFollowsListsApiService(followsListsApiService);
    themeService.setStorageService(storageService);
  }

  void initAsyncState() async {
    Environment environment =
        await EnvironmentLoader(environmentPath: ".env.json").load();
    authApiService.setApiURL(environment.apiUrl);
    postsApiService.setApiURL(environment.apiUrl);
    emojisApiService.setApiURL(environment.apiUrl);
    followsApiService.setApiURL(environment.apiUrl);
    connectionsApiService.setApiURL(environment.apiUrl);
    connectionsCirclesApiService.setApiURL(environment.apiUrl);
    followsListsApiService.setApiURL(environment.apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return new _OpenbookProvider(
      data: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    deepLinksService.clearSubscriptionStreams();
  }

  setLocalizationService(LocalizationService newLocalizationService) {
    localizationService = newLocalizationService;
    createAccountBloc.setLocalizationService(localizationService);
    httpService.setLocalizationService(localizationService);
    initialiseDeepLinks(); // depends on localizationService being set
  }

  initialiseDeepLinks() {
    deepLinksService.initUniLinks();
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
