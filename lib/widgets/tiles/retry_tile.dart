import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBRetryTile extends StatelessWidget {
  final String text;
  final VoidCallback onWantsToRetry;

  const OBRetryTile(
      {Key key, this.text = 'Tap to retry.', @required this.onWantsToRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onWantsToRetry,
      child: ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const OBIcon(OBIcons.refresh),
            const SizedBox(
              width: 10.0,
            ),
            OBText(text)
          ],
        ),
      ),
    );
  }
}
