import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/emoji_preview.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileInLists extends StatelessWidget {
  final User user;

  OBProfileInLists(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        if (user == null || !user.hasFollowLists()) return const SizedBox();
        var followsLists = user.followLists.lists;

        List<Widget> connectionItems = [
          const OBText(
            'In lists',
          )
        ];

        followsLists.forEach((FollowsList followsList) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBEmojiPreview(
                followsList.emoji,
                size: OBEmojiPreviewSize.small,
              ),
              const SizedBox(
                width: 5,
              ),
              OBText(
                followsList.name,
              )
            ],
          ));
        });

        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: connectionItems,
          ),
        );
      },
    );
  }
}
