import 'dart:io';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBSharePostPage extends StatefulWidget {
  final SharePostData sharePostData;

  const OBSharePostPage({Key key, @required this.sharePostData})
      : super(key: key);

  @override
  OBSharePostPageState createState() {
    return OBSharePostPageState();
  }
}

class OBSharePostPageState extends State<OBSharePostPage> {
  bool _loggedInUserRefreshInProgress;
  bool _needsBootstrap;
  UserService _userService;
  NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _loggedInUserRefreshInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _navigationService = openbookProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    User loggedInUser = _userService.getLoggedInUser();

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: StreamBuilder(
            stream: loggedInUser.updateSubject,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              User latestUser = snapshot.data;
              if (latestUser == null) return const SizedBox();

              if (_loggedInUserRefreshInProgress)
                return const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: const OBProgressIndicator(),
                  ),
                );

              const TextStyle shareToTilesSubtitleStyle =
                  TextStyle(fontSize: 14);

              List<Widget> shareToTiles = [
                ListTile(
                  leading: const OBIcon(OBIcons.circles),
                  title: const OBText('My circles'),
                  subtitle: const OBText(
                    'Share the post to one or multiple of your circles.',
                    style: shareToTilesSubtitleStyle,
                  ),
                  onTap: _onWantsToSharePostToCircles,
                )
              ];

              if (latestUser.isMemberOfCommunities) {
                shareToTiles.add(ListTile(
                  leading: const OBIcon(OBIcons.communities),
                  title: const OBText('A community'),
                  subtitle: const OBText(
                    'Share the post to a community you\'re part of.',
                    style: shareToTilesSubtitleStyle,
                  ),
                  onTap: _onWantsToSharePostToCommunity,
                ));
              }

              return Column(
                children: <Widget>[
                  Expanded(
                      child: ListView(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: shareToTiles)),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: 'Share with',
    );
  }

  void _bootstrap() {
    _refreshLoggedInUser();
  }

  Future<void> _refreshLoggedInUser() async {
    User refreshedUser = await _userService.refreshUser();
    if (!refreshedUser.isMemberOfCommunities) {
      // Only possibility
      _onWantsToSharePostToCircles();
    }
  }

  void _onWantsToSharePostToCircles() {
    _navigationService.navigateToSharePostWithCircles(
        context: context, sharePostData: widget.sharePostData);
  }

  void _onWantsToSharePostToCommunity() {
    _navigationService.navigateToSharePostWithCommunity(
        context: context, sharePostData: widget.sharePostData);
  }
}

class SharePostData {
  String text;
  File image;
  File video;

  SharePostData({@required this.text, this.image, this.video});
}
