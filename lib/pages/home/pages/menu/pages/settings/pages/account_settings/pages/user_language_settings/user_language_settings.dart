import 'package:Openbook/main.dart';
import 'package:Openbook/models/language.dart';
import 'package:Openbook/models/language_list.dart';
import 'package:Openbook/pages/home/pages/menu/pages/settings/pages/account_settings/pages/user_language_settings/widgets/language_selectable_tile.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/translation/constants.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUserLanguageSettingsPage extends StatefulWidget {
  @override
  OBUserLanguageSettingsPageState createState() {
    return OBUserLanguageSettingsPageState();
  }
}

class OBUserLanguageSettingsPageState
    extends State<OBUserLanguageSettingsPage> {
  Language _selectedLanguage;
  Locale _selectedLocale;
  Language _currentUserLanguage;
  List<Language> _allLanguages;
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  bool _needsBootstrap;
  bool _bootstrapInProgress;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _bootstrapInProgress = true;
    _requestInProgress = false;
    _allLanguages = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: _localizationService.user__language_settings_title,
        ),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: _bootstrapInProgress
                  ? _buildBootstrapInProgressIndicator()
                  : _buildLanguageSelector()),
        ));
  }

  Widget _buildBootstrapInProgressIndicator() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: const EdgeInsets.all(20),
              child: const OBProgressIndicator(),
            )
          ],
        )
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Opacity(
      opacity: _requestInProgress ? 0.6 : 1,
      child: IgnorePointer(
        ignoring: _requestInProgress,
        child: Column(
          children: <Widget>[
            ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: _allLanguages.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Language language = _allLanguages[index];
                  bool isSelected = language.code == _selectedLanguage.code;

                  return OBLanguageSelectableTile(
                    language,
                    isSelected: isSelected,
                    onLanguagePressed: _onNewLanguageSelected,
                  );
                }),
          ],
        ),
      ),
    );
  }

  void _saveNewLanguage() async {
    _setRequestInProgress(true);
    try {
      await _userService.setNewLanguage(_selectedLanguage);
      MyApp.setLocale(context, _selectedLocale);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onNewLanguageSelected(newLanguage) {
    print('New language ${newLanguage.code}');
    _setSelectedLanguageInWidget(newLanguage);
    _saveNewLanguage();
  }

  void _setLanguagesList(LanguagesList list) {
    List<Language> supportedList = list.languages.where((Language language) =>
        supportedLanguages.contains(language.code)).toList();
    setState(() {
      _allLanguages = supportedList;
    });
  }

  void _setSelectedLanguageInWidget(Language language) {
    setState(() {
      _selectedLanguage = language;
    });
    _setSelectedLocaleFromLanguage(language);
  }

  void _setSelectedLocaleFromLanguage(Language language) {
    Locale supportedMatchedLocale = supportedLocales.firstWhere((
        Locale locale) => locale.languageCode == language.code);
    setState(() {
      _selectedLocale = supportedMatchedLocale;
    });
  }

  void _setCurrentUserLanguage(Language language) {
    setState(() {
      _currentUserLanguage = language;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _bootstrap() async {
    Language userLanguage = _userService
        .getLoggedInUser()
        .language;
    _setSelectedLanguageInWidget(userLanguage);
    _setCurrentUserLanguage(userLanguage);
    await _refreshLanguages();
    _setBootstrapInProgress(false);
  }

  Future _refreshLanguages() async {
    try {
      LanguagesList languages = await _userService.getAllLanguages();
      _setLanguagesList(languages);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setBootstrapInProgress(bool bootstrapInProgress) {
    setState(() {
      _bootstrapInProgress = bootstrapInProgress;
    });
  }
}

