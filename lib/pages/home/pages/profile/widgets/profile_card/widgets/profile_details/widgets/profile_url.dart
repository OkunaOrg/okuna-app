import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileUrl extends StatelessWidget {
  final User user;

  const OBProfileUrl(this.user);

  @override
  Widget build(BuildContext context) {
    String url = user.getProfileUrl();

    if (url == null) {
      return const SizedBox();
    }

    Uri uri = Uri.parse(url);

    String prettyUrl = uri.host + uri.path + uri.query;

    return GestureDetector(
      onTap: () async {
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
        openbookProvider.urlLauncherService.launchUrl(url);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const OBIcon(
            OBIcons.link,
            customSize: 14,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
              child: OBText(
                prettyUrl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(decoration: TextDecoration.underline),
              ))
        ],
      ),
    );
  }
}
