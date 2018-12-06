import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_list/widgets/follows_list_header/widgets/follows_list_name.dart';
import 'package:Openbook/widgets/follows_list_icon.dart';
import 'package:flutter/material.dart';

class OBFollowsListHeader extends StatelessWidget {
  final FollowsList followsList;

  OBFollowsListHeader(this.followsList);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: followsList.updateChange,
        initialData: followsList,
        builder: (BuildContext context, AsyncSnapshot<FollowsList> snapshot) {
          var followsList = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: OBFollowsListName(followsList),
                    ),
                    OBFollowsListEmoji(
                      followsListEmojiUrl: followsList.getEmojiImage(),
                      size: OBFollowsListEmojiSize.large,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Users',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              ),
              Divider(),
            ],
          );
        });
  }
}
