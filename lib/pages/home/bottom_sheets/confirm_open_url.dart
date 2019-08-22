import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/fields/checkbox_field.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';

class OBConfirmOpenUrlBottomSheet extends StatefulWidget {
  final Uri _uri;

  OBConfirmOpenUrlBottomSheet({String url}) : _uri = Uri.parse(url);

  @override
  OBConfirmOpenUrlBottomSheetState createState() {
    return OBConfirmOpenUrlBottomSheetState();
  }
}

class OBConfirmOpenUrlBottomSheetState extends State<OBConfirmOpenUrlBottomSheet> {
  UrlLauncherService _urlLauncherService;
  LocalizationService _localizationService;

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
      _urlLauncherService = openbookProvider.urlLauncherService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double maxUrlBoxHeight = screenHeight * .3;

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
                  text: widget._uri.toString(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            OBCheckboxField(
              value: !_askForHost,
              title: _localizationService.post__open_url_dont_ask_again_for(widget._uri.host),
              onTap: _toggleDontAskForHost,
              titleStyle: TextStyle(fontWeight: FontWeight.normal),
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
                    isDisabled: !_ask || !_askForHost,
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
                    onPressed: _onConfirmOpen,
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
      _urlLauncherService.storeAskToConfirmOpen(_askForHost, host: widget._uri.host);
    });
  }

  void _toggleDontAsk() {
    setState(() {
      _ask = !_ask;
      _urlLauncherService.storeAskToConfirmOpen(_ask);
    });
  }

  void _onConfirmOpen() {
    Navigator.pop(context, true);
  }

  void _onCancel() {
    Navigator.pop(context, false);
  }
}
