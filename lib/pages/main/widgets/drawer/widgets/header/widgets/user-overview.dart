import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';

class MainDrawerHeaderUserOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildUserName(userService)
                ],
              ),
              Row(
                children: <Widget>[
                  _buildUserUsername(userService),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    135.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 2.0,
                    height: 1,
                  ),
                  Text('Posts'),
                  SizedBox(
                    width: 10.0,
                    height: 1,
                  ),
                  Text(
                    '3.5k',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 2.0,
                    height: 1,
                  ),
                  Text('Followers')
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserName(UserService userService){
    return StreamBuilder(
      stream: userService.loggedInUserChange,
      initialData: null,
      builder: (context, AsyncSnapshot<User> snapshot) {
        var snapshotData = snapshot.data;

        var name;

        if (snapshotData == null) {
          name = '';
        } else {
          name = snapshot.data.profile.name;
        }

        return Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0),
        );
      },
    );
  }

  Widget _buildUserUsername(UserService userService){
    return StreamBuilder(
      stream: userService.loggedInUserChange,
      initialData: null,
      builder: (context, AsyncSnapshot<User> snapshot) {
        var snapshotData = snapshot.data;

        var username;

        if (snapshotData == null) {
          username = '';
        } else {
          username = snapshot.data.username;
        }

        return Text(
          username,
          style: TextStyle(fontSize: 16.0),
        );
      },
    );
  }
}
