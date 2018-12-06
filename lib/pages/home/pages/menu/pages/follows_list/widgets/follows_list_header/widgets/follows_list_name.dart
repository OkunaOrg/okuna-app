import 'package:Openbook/models/follows_list.dart';
import 'package:flutter/material.dart';

class OBFollowsListName extends StatelessWidget {
  final FollowsList followsList;

  OBFollowsListName(this.followsList);

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
              Text(
                'List',
                style: TextStyle(color: Colors.black45),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      followsList.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
