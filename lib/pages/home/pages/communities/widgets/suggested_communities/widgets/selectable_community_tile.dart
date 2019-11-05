import 'package:Okuna/models/community.dart';
import 'package:Okuna/widgets/checkbox.dart';
import 'package:Okuna/widgets/fields/checkbox_field.dart';
import 'package:Okuna/widgets/tiles/community_tile.dart';
import 'package:flutter/material.dart';

class OBSelectableCommunityTile extends StatelessWidget {
  final Community community;
  final OnCommunityPressed onCommunityPressed;
  final bool isSelected;
  final bool isDisabled;

  const OBSelectableCommunityTile(this.community,
      {Key key, this.onCommunityPressed, this.isSelected = false, this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget field = GestureDetector(
      onTap: () {
        if (!isDisabled) this.onCommunityPressed(community);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: OBCommunityTile(
              community,
              key: Key(community.name),
            ),
          ),
          const SizedBox(width: 10.0),
          OBCheckbox(
            value: isSelected,
          )
        ],
      ),
    );

    if (isDisabled) {
      field = Opacity(
        opacity: 0.5,
        child: field,
      );
    }

    return field;
  }
}

typedef void OnCommunityPressed(Community selectedCommunity);
