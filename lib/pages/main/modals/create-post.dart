import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/pill-button.dart';
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
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(
                                          10.0)),
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
                                      cursorColor: Colors.black26,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'What\'s going on?'),
                                      autocorrect: true,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                      _buildPostActions()
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

  Widget _buildPostActions() {

    double actionIconHeight = 20.0;
    double actionSpacing = 10.0;

    return Container(
      height: 51.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Color.fromARGB(3, 0, 0, 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: actionSpacing,),
          OBPillButton(
            text: 'Media',
            hexColor: '#FCC14B',
            icon: Image.asset('assets/images/icons/media-icon.png', height: actionIconHeight,),
            onPressed: () {},
          ),
          SizedBox(width: actionSpacing,),
          OBPillButton(
            text: 'GIF',
            hexColor: '#0F0F0F',
            icon: Image.asset('assets/images/icons/gif-icon.png', height: actionIconHeight,),
            onPressed: () {},
          ),
          SizedBox(width: actionSpacing,),
          OBPillButton(
            text: 'Audience',
            hexColor: '#80E37A',
            icon: Image.asset('assets/images/icons/audience-icon.png', height: actionIconHeight,),
            onPressed: () {},
          ),
          SizedBox(width: actionSpacing,),
          OBPillButton(
            text: 'Burner',
            hexColor: '#F13A59',
            icon: Image.asset('assets/images/icons/burner-icon.png', height: actionIconHeight,),
            onPressed: () {},
          ),
          SizedBox(width: actionSpacing,),
        ],
      ),
    );
  }
}
