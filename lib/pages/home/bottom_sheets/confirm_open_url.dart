import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/theme.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/fields/checkbox_field.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';
import 'package:public_suffix/public_suffix.dart';

class OBConfirmOpenUrlBottomSheet extends StatefulWidget {
  final PublicSuffix _urlInfo;

  OBConfirmOpenUrlBottomSheet({PublicSuffix urlInfo}) : _urlInfo = urlInfo;

  @override
  OBConfirmOpenUrlBottomSheetState createState() {
    return OBConfirmOpenUrlBottomSheetState();
  }
}

class OBConfirmOpenUrlBottomSheetState extends State<OBConfirmOpenUrlBottomSheet> {
  UserPreferencesService _preferencesService;
  LocalizationService _localizationService;
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;

  bool _needsBootstrap;
  bool _ask;
  bool _askForHost;


  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _ask = true;
    _askForHost = true;
  }


  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _preferencesService = openbookProvider.userPreferencesService;
      _localizationService = openbookProvider.localizationService;
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _needsBootstrap = false;
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double maxUrlBoxHeight = screenHeight * .3;

    OBTheme theme = _themeService.getActiveTheme();
    Color secondaryTextColor = _themeValueParserService.parseColor(theme.secondaryTextColor);

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBText(
              _localizationService.post__open_url_message,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxUrlBoxHeight),
              child: SingleChildScrollView(
                child: OBSmartText(
                  text: widget._urlInfo.sourceUri.toString(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            OBCheckboxField(
              value: !_askForHost,
              onTap: _toggleDontAskForHost,
              title: _localizationService.post__open_url_dont_ask_again_for,
              titleStyle: TextStyle(fontWeight: FontWeight.normal),
              subtitle: widget._urlInfo.domain,
              subtitleStyle: TextStyle(color: secondaryTextColor),
            ),
            const SizedBox(
              height: 5,
            ),
            OBCheckboxField(
              value: !_ask,
              title: _localizationService.post__open_url_dont_ask_again,
              onTap: _toggleDontAsk,
              titleStyle: TextStyle(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OBButton(
                    size: OBButtonSize.medium,
                    type: OBButtonType.highlight,
                    child: Text(_localizationService.post__open_url_cancel),
                    onPressed: _onCancel,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OBButton(
                    size: OBButtonSize.medium,
                    type: OBButtonType.primary,
                    child: Text(_localizationService.post__open_url_continue),
                    onPressed: _onConfirmTapped,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDontAskForHost() {
    setState(() {
      _askForHost = !_askForHost;
      _ask = true;
    });
  }

  void _toggleDontAsk() {
    setState(() {
      _ask = !_ask;
      _askForHost = true;
    });
  }

  void _onConfirmTapped() async {
    if (!_askForHost) {
      await _preferencesService.setAskToConfirmOpenUrl(
          _askForHost, host: widget._urlInfo);
    }
    if (!_ask) {
      await _preferencesService.setAskToConfirmOpenUrl(_ask);
    }

    _onConfirmOpen();
  }

  void _onConfirmOpen() {
    Navigator.pop(context, true);
  }

  void _onCancel() {
    Navigator.pop(context, false);
  }
}
