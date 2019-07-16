import 'package:Openbook/models/language.dart';
import 'package:Openbook/models/language_list.dart';
import 'package:Openbook/pages/home/pages/language/widgets/language_selectable_tile.dart';
import 'package:Openbook/translation/constants.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../main.dart';

class OBLanguageSettingsPage extends StatefulWidget {
  @override
  OBLanguageSettingsPageState createState() {
    return OBLanguageSettingsPageState();
  }
}

class OBLanguageSettingsPageState
    extends State<OBLanguageSettingsPage> {
  Language _selectedLanguage;
  Locale _selectedLocale;
  Language _currentUserLanguage;
  List<Language> _allLanguages;
  UserService _userService;
  ToastService _toastService;

  bool _needsBootstrap;
  bool _bootstrapInProgress;
  bool _isSetLanguageInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _bootstrapInProgress = true;
    _isSetLanguageInProgress = false;
    _allLanguages = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: 'Language settings',
          trailing: OBButton(
            size: OBButtonSize.small,
            type: OBButtonType.primary,
            isLoading: _isSetLanguageInProgress,
            isDisabled: _selectedLanguage != null && _selectedLanguage.code == _currentUserLanguage.code,
            onPressed: () => _saveNewLanguage(context),
            child: Text('Save'),
          ),
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
    return Column(
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
    );
  }

  void _saveNewLanguage(BuildContext context) async {
    _setSaveInProgress(true);
    try {
      await _userService.setNewLanguage(_selectedLanguage);
      MyApp.setLocale(context, _selectedLocale);
      _showLanguageChangedSuccessToast();
      Navigator.pop(context);
    } catch(error) {
      _onError(error);
    } finally {
      _setSaveInProgress(false);
    }
  }

  void _onNewLanguageSelected(newLanguage) {
    print('New language ${newLanguage.code}');
    _setSelectedLanguageInWidget(newLanguage);
  }

  void _setLanguagesList(LanguagesList list) {
    List<Language> supportedList = list.languages.where((Language language) => supportedLanguages.contains(language.code)).toList();
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
    Locale supportedMatchedLocale = supportedLocales.firstWhere((Locale locale) => locale.languageCode == language.code);
    setState(() {
      _selectedLocale = supportedMatchedLocale;
    });
  }

  void _setCurrentUserLanguage(Language language) {
    setState(() {
      _currentUserLanguage = language;
    });
  }

  void _setSaveInProgress(bool saveInProgress) {
    setState(() {
      _isSetLanguageInProgress = saveInProgress;
    });
  }

  void _bootstrap() async {
    Language userLanguage = _userService.getLoggedInUser().language;
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
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _showLanguageChangedSuccessToast() {
    _toastService.success(message: 'Language changed successfully', context: context);
  }

  void _setBootstrapInProgress(bool bootstrapInProgress) {
    setState(() {
      _bootstrapInProgress = bootstrapInProgress;
    });
  }
}
