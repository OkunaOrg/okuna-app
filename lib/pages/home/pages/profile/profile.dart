import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_bio.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_cover.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_location.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBProfilePage extends StatefulWidget {
  User user;

  OBProfilePage(this.user);

  @override
  OBProfilePageState createState() {
    return OBProfilePageState();
  }
}

class OBProfilePageState extends State<OBProfilePage> {
  User _user;
  bool _needsBootstrap;
  bool _refreshUserInProgress;
  UserService _userService;
  ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _refreshUserInProgress = false;
    _needsBootstrap = true;
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          Positioned(child: OBProfileCover(_user)),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                OBProfileNavBar(_user),
                Container(
                    margin: EdgeInsets.only(top: 100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          top: - ((OBUserAvatar.AVATAR_SIZE_LARGE / 2) * 0.7),
                          left: 30,
                          child: OBUserAvatar(
                            avatarUrl: _user.getProfileAvatar(),
                            size: OBUserAvatarSize.large,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: OBUserAvatar.AVATAR_SIZE_LARGE,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _user.getProfileName(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '@' + _user.username,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20.0),
                              child: Column(
                                children: <Widget>[
                                  OBProfileBio(_user),
                                  OBProfileLocation(_user)
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _bootstrap() async {
    await _refreshUser();
  }

  void _refreshUser() async {
    _setRefreshUserInProgress(true);

    try {
      var user = await _userService.getUserWithUsername(_user.username);
      _setUser(user);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection');
    } catch (e) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    } finally {
      _setRefreshUserInProgress(false);
    }
  }

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
  }

  void _setRefreshUserInProgress(bool refreshUserInProgress) {
    setState(() {
      this._refreshUserInProgress = refreshUserInProgress;
    });
  }
}
