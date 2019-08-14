import 'package:Okuna/pages/auth/create_account/blocs/create_account.dart';
import 'package:Okuna/services/auth_api.dart';
import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/categories_api.dart';
import 'package:Okuna/services/communities_api.dart';
import 'package:Okuna/services/connections_circles_api.dart';
import 'package:Okuna/services/connections_api.dart';
import 'package:Okuna/services/date_picker.dart';
import 'package:Okuna/services/devices_api.dart';
import 'package:Okuna/services/dialog.dart';
import 'package:Okuna/services/documents.dart';
import 'package:Okuna/services/intercom.dart';
import 'package:Okuna/services/moderation_api.dart';
import 'package:Okuna/services/notifications_api.dart';
import 'package:Okuna/services/push_notifications/push_notifications.dart';
import 'package:Okuna/services/text_account_autocompletion.dart';
import 'package:Okuna/services/universal_links/universal_links.dart';
import 'package:Okuna/services/emoji_picker.dart';
import 'package:Okuna/services/emojis_api.dart';
import 'package:Okuna/services/environment_loader.dart';
import 'package:Okuna/services/follows_api.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/image_picker.dart';
import 'package:Okuna/services/follows_lists_api.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/modal_service.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/posts_api.dart';
import 'package:Okuna/services/storage.dart';
import 'package:Okuna/services/string_template.dart';
import 'package:Okuna/services/theme.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/services/user_invites_api.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:Okuna/services/utils_service.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/services/waitlist_service.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

// TODO Waiting for dependency injection support
// https://github.com/flutter/flutter/issues/21980

class OpenbookProvider extends StatefulWidget {
  final Widget child;

  const OpenbookProvider({Key key, @required this.child}) : super(key: key);

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
  UserPreferencesService userPreferencesService = UserPreferencesService();
  CreateAccountBloc createAccountBloc = CreateAccountBloc();
  ValidationService validationService = ValidationService();
  HttpieService httpService = HttpieService();
  AuthApiService authApiService = AuthApiService();
  PostsApiService postsApiService = PostsApiService();
  StorageService storageService = StorageService();
  UserService userService = UserService();
  ModerationApiService moderationApiService = ModerationApiService();
  ToastService toastService = ToastService();
  StringTemplateService stringTemplateService = StringTemplateService();
  EmojisApiService emojisApiService = EmojisApiService();
  ThemeService themeService = ThemeService();
  ImagePickerService imagePickerService = ImagePickerService();
  DatePickerService datePickerService = DatePickerService();
  EmojiPickerService emojiPickerService = EmojiPickerService();
  FollowsApiService followsApiService = FollowsApiService();
  CommunitiesApiService communitiesApiService = CommunitiesApiService();
  CategoriesApiService categoriesApiService = CategoriesApiService();
  NotificationsApiService notificationsApiService = NotificationsApiService();
  DevicesApiService devicesApiService = DevicesApiService();
  ConnectionsApiService connectionsApiService = ConnectionsApiService();
  ConnectionsCirclesApiService connectionsCirclesApiService =
      ConnectionsCirclesApiService();
  FollowsListsApiService followsListsApiService = FollowsListsApiService();
  UserInvitesApiService userInvitesApiService = UserInvitesApiService();
  ThemeValueParserService themeValueParserService = ThemeValueParserService();
  ModalService modalService = ModalService();
  NavigationService navigationService = NavigationService();
  WaitlistApiService waitlistApiService = WaitlistApiService();

  LocalizationService localizationService;
  UniversalLinksService universalLinksService = UniversalLinksService();
  BottomSheetService bottomSheetService = BottomSheetService();
  PushNotificationsService pushNotificationsService =
      PushNotificationsService();
  UrlLauncherService urlLauncherService = UrlLauncherService();
  IntercomService intercomService = IntercomService();
  DialogService dialogService = DialogService();
  UtilsService utilsService = UtilsService();
  DocumentsService documentsService = DocumentsService();
  TextAccountAutocompletionService textAccountAutocompletionService =
      TextAccountAutocompletionService();

  SentryClient sentryClient;

  @override
  void initState() {
    super.initState();
    initAsyncState();
    imageCache.maximumSize = 200 << 20; // 200MB
    userPreferencesService.setStorageService(storageService);
    connectionsCirclesApiService.setHttpService(httpService);
    httpService.setUtilsService(utilsService);
    connectionsCirclesApiService
        .setStringTemplateService(stringTemplateService);
    communitiesApiService.setHttpieService(httpService);
    communitiesApiService.setStringTemplateService(stringTemplateService);
    followsListsApiService.setHttpService(httpService);
    followsListsApiService.setStringTemplateService(stringTemplateService);
    userInvitesApiService.setHttpService(httpService);
    userInvitesApiService.setStringTemplateService(stringTemplateService);
    connectionsApiService.setHttpService(httpService);
    authApiService.setHttpService(httpService);
    authApiService.setStringTemplateService(stringTemplateService);
    followsApiService.setHttpService(httpService);
    createAccountBloc.setAuthApiService(authApiService);
    createAccountBloc.setUserService(userService);
    userService.setAuthApiService(authApiService);
    userService.setPostsApiService(postsApiService);
    userService.setEmojisApiService(emojisApiService);
    userService.setHttpieService(httpService);
    userService.setStorageService(storageService);
    userService.setUserInvitesApiService(userInvitesApiService);
    userService.setFollowsApiService(followsApiService);
    userService.setFollowsListsApiService(followsListsApiService);
    userService.setConnectionsApiService(connectionsApiService);
    userService.setConnectionsCirclesApiService(connectionsCirclesApiService);
    userService.setCommunitiesApiService(communitiesApiService);
    userService.setCategoriesApiService(categoriesApiService);
    userService.setNotificationsApiService(notificationsApiService);
    userService.setDevicesApiService(devicesApiService);
    userService.setCreateAccountBlocService(createAccountBloc);
    userService.setWaitlistApiService(waitlistApiService);
    waitlistApiService.setHttpService(httpService);
    userService.setModerationApiService(moderationApiService);
    emojisApiService.setHttpService(httpService);
    categoriesApiService.setHttpService(httpService);
    postsApiService.setHttpieService(httpService);
    postsApiService.setStringTemplateService(stringTemplateService);
    notificationsApiService.setHttpService(httpService);
    notificationsApiService.setStringTemplateService(stringTemplateService);
    devicesApiService.setHttpService(httpService);
    devicesApiService.setStringTemplateService(stringTemplateService);
    validationService.setAuthApiService(authApiService);
    validationService.setFollowsListsApiService(followsListsApiService);
    validationService.setCommunitiesApiService(communitiesApiService);
    validationService
        .setConnectionsCirclesApiService(connectionsCirclesApiService);
    themeService.setStorageService(storageService);
    themeService.setThemeValueParserService(themeValueParserService);
    pushNotificationsService.setUserService(userService);
    intercomService.setUserService(userService);
    dialogService.setThemeService(themeService);
    dialogService.setThemeValueParserService(themeValueParserService);
    imagePickerService.setValidationService(validationService);
    documentsService.setHttpService(httpService);
    moderationApiService.setStringTemplateService(stringTemplateService);
    moderationApiService.setHttpieService(httpService);
  }

  void initAsyncState() async {
    Environment environment =
        await EnvironmentLoader(environmentPath: ".env.json").load();
    httpService.setMagicHeader(
        environment.magicHeaderName, environment.magicHeaderValue);
    authApiService.setApiURL(environment.apiUrl);
    postsApiService.setApiURL(environment.apiUrl);
    emojisApiService.setApiURL(environment.apiUrl);
    userInvitesApiService.setApiURL(environment.apiUrl);
    followsApiService.setApiURL(environment.apiUrl);
    moderationApiService.setApiURL(environment.apiUrl);
    connectionsApiService.setApiURL(environment.apiUrl);
    connectionsCirclesApiService.setApiURL(environment.apiUrl);
    followsListsApiService.setApiURL(environment.apiUrl);
    communitiesApiService.setApiURL(environment.apiUrl);
    categoriesApiService.setApiURL(environment.apiUrl);
    notificationsApiService.setApiURL(environment.apiUrl);
    devicesApiService.setApiURL(environment.apiUrl);
    waitlistApiService
        .setOpenbookSocialApiURL(environment.openbookSocialApiUrl);
    intercomService.bootstrap(
        iosApiKey: environment.intercomIosKey,
        androidApiKey: environment.intercomAndroidKey,
        appId: environment.intercomAppId);

    sentryClient = SentryClient(dsn: environment.sentryDsn);
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
    universalLinksService.dispose();
    pushNotificationsService.dispose();
  }

  setLocalizationService(LocalizationService newLocalizationService) {
    localizationService = newLocalizationService;
    createAccountBloc.setLocalizationService(localizationService);
    httpService.setLocalizationService(localizationService);
    userService.setLocalizationsService(localizationService);
  }

  setValidationService(ValidationService newValidationService) {
    validationService = newValidationService;
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
