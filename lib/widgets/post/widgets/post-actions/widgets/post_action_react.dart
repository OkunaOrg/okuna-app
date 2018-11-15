import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/buttons/pill_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;

  OBPostActionReact(this._post);

  @override
  Widget build(BuildContext context) {
    return OBPillButton(
      text: 'React',
      icon: OBIcon(
        OBIcons.react,
        size: OBIconSize.medium,
      ),
      color: Color.fromARGB(5, 0, 0, 0),
      textColor: Colors.black87,
      onPressed: () {},
    );
  }
}
