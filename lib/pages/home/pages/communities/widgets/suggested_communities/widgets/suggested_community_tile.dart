import 'package:Okuna/models/community.dart';
import 'package:Okuna/widgets/checkbox.dart';
import 'package:Okuna/widgets/fields/checkbox_field.dart';
import 'package:Okuna/widgets/tiles/community_tile.dart';
import 'package:flutter/material.dart';

class OBSuggestedCommunityTile extends StatelessWidget {
  final Community community;
  final OnCommunityPressed onCommunityPressed;
  final bool isSelected;
  final bool isDisabled;

  const OBSuggestedCommunityTile(this.community,
      {Key key, this.onCommunityPressed, this.isSelected = false, this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.onCommunityPressed(community),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: OBCommunityTile(
              community,
              key: Key(community.name),
            ),
          ),
          OBCheckbox(
            value: isSelected,
          )
        ],
      ),
    );
  }
}

typedef void OnCommunityPressed(Community selectedCommunity);
