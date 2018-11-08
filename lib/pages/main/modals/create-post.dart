import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePostModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePostModalState();
  }
}

class CreatePostModalState extends State<CreatePostModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return Material(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              child: Icon(Icons.close, color: Colors.black87),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            middle: Text('Create post'),
            trailing: OBPrimaryButton(
              isSmall: true,
              onPressed: () {},
              child: Text('Post'),
            ),
          ),
          child: SafeArea(
              child: Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10.0)),
                              height: 39.0,
                              width: 39.0,
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: _buildUserAvatar(userService),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20.0, right: 20.0, bottom: 20.0),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                      hintText: 'What\'s up?'),
                                  autocorrect: true,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.red,
                        padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                        child: Row(
                          children: <Widget>[
                            Text('A'),
                            Text('B'),
                          ],
                        ),
                      )
                    ],
                  )))),
    );
  }

  Widget _buildUserAvatar(UserService userService) {
    return StreamBuilder(
      stream: userService.loggedInUserChange,
      initialData: null,
      builder: (context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        var avatar;

        if (user == null) {
          avatar = AssetImage('assets/images/avatar.png');
        } else {
          avatar = NetworkImage(user.profile.avatar);
        }

        return Container(
          child: null,
          decoration: BoxDecoration(
              image: DecorationImage(image: avatar, fit: BoxFit.cover)),
        );
      },
    );
  }
}
