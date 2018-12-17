import 'package:flutter/cupertino.dart';

abstract class OBPostAddon {
  String identifier;

  List<String> getExcludedAddonsIdentifiers() {
    return [];
  }

  Widget buildButton(
      {@required BuildContext context, @required VoidCallback enableAddon});

  Widget buildPreview(
      {@required BuildContext context, @required VoidCallback disableAddon});

  void handleRequestBody({@required Map<String, dynamic> body});
}
