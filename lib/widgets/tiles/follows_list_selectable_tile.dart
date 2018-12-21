import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/widgets/emoji_preview.dart';
import 'package:Openbook/widgets/fields/checkbox_field.dart';
import 'package:flutter/material.dart';

class OBFollowsListSelectableTile extends StatelessWidget {
  final FollowsList followsList;
  final OnFollowsListPressed onFollowsListPressed;
  final bool isSelected;
  final bool isDisabled;

  const OBFollowsListSelectableTile(this.followsList,
      {Key key,
      this.onFollowsListPressed,
      this.isSelected,
      this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int usersCount = followsList.followsCount;

    return OBCheckboxField(
      isDisabled: isDisabled,
      value: isSelected,
      title: followsList.name,
      subtitle:
          usersCount != null ? getPrettyCount(usersCount) + ' accounts' : null,
      onTap: () {
        onFollowsListPressed(followsList);
      },
      leading: Container(
        height: 40,
        width: 40,
        child: Center(
          child: OBEmojiPreview(
            followsList.emoji,
            size: OBEmojiPreviewSize.medium,
          ),
        ),
      ),
    );
  }
}

typedef void OnFollowsListPressed(FollowsList pressedFollowsList);
