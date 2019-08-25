import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/widgets/markdown.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityGuidelinesPage extends StatefulWidget {
  @override
  OBCommunityGuidelinesPageState createState() {
    return OBCommunityGuidelinesPageState();
  }
}

class OBCommunityGuidelinesPageState extends State {
  String _guidelinesText;
  bool _needsBootstrap;

  CancelableOperation _getGuidelinesOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _guidelinesText = '';
  }

  @override
  void dispose() {
    super.dispose();
    if (_getGuidelinesOperation != null) _getGuidelinesOperation.cancel();
  }

  void _bootstrap() async {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    _getGuidelinesOperation = CancelableOperation.fromFuture(
        openbookProvider.documentsService.getCommunityGuidelines());

    String guidelines = await _getGuidelinesOperation.value;
    _setGuidelinesText(guidelines);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Community guidelines',
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: OBMarkdown(
              linksRequireConfirmation: false,
              data: _guidelinesText,
            )),
          ],
        ),
      ),
    );
  }

  void _setGuidelinesText(String guidelinesText) {
    setState(() {
      _guidelinesText = guidelinesText;
    });
  }
}
