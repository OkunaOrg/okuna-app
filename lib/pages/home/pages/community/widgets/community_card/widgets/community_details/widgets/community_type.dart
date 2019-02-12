import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityType extends StatelessWidget {
  final Community community;

  const OBCommunityType(this.community);

  @override
  Widget build(BuildContext context) {
    String type = community.type;

    if (type == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const OBIcon(
          OBIcons.info,
          customSize: 14,
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: OBText(
            type,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
