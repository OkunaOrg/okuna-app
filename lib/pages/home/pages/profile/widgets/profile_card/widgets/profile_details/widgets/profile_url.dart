import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OBProfileUrl extends StatelessWidget {
  User user;

  OBProfileUrl(this.user);

  @override
  Widget build(BuildContext context) {
    String url = user.getProfileUrl();

    if (url == null) {
      return SizedBox();
    }

    Uri uri = Uri.parse(url);

    String prettyUrl = uri.host + uri.path + uri.query;

    Color color = Colors.black45;

    return GestureDetector(
      onTap: _launchURL,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.link,
            size: 14,
            color: color,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
              child: Text(
                prettyUrl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, decoration: TextDecoration.underline),
          ))
        ],
      ),
    );
  }

  _launchURL() async {
    String url = user.getProfileUrl();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
