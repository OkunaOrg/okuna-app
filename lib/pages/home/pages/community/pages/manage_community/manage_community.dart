import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/actions/favorite_community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBManageCommunityPage extends StatelessWidget {
  final Community community;

  const OBManageCommunityPage({@required this.community});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    NavigationService navigationService = openbookProvider.navigationService;
    ModalService modalService = openbookProvider.modalService;
    UserService userService = openbookProvider.userService;

    User loggedInUser = userService.getLoggedInUser();
    List<Widget> menuListTiles = [];

    const TextStyle listItemSubtitleStyle = TextStyle(fontSize: 14);

    bool loggedInUserIsAdministrator = community.isAdministrator(loggedInUser);
    bool loggedInUserIsModerator = community.isModerator(loggedInUser);
    bool loggedInUserIsCreator = community.isCreator;

    if (loggedInUserIsAdministrator) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.communities),
        title: const OBText('Details'),
        subtitle: const OBText(
          'Change the title, name, avatar, cover photo and more.',
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          modalService.openEditCommunity(
              context: context, community: community);
        },
      ));
    }

    if (loggedInUserIsCreator) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.communityAdministrators),
        title: const OBText('Administrators'),
        subtitle: const OBText(
          'See, add and remove administrators.',
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToCommunityAdministrators(
              context: context, community: community);
        },
      ));
    }

    if (loggedInUserIsAdministrator) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.communityModerators),
        title: const OBText('Moderators'),
        subtitle: const OBText(
          'See, add and remove moderators.',
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToCommunityModerators(
              context: context, community: community);
        },
      ));
    }

    if (loggedInUserIsAdministrator || loggedInUserIsModerator) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.communityBannedUsers),
        title: const OBText('Banned users'),
        subtitle: const OBText(
          'See, add and remove banned users.',
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToCommunityBannedUsers(
              context: context, community: community);
        },
      ));
    }

    menuListTiles.add(ListTile(
      leading: const OBIcon(OBIcons.communityInvites),
      title: const OBText('Invite people'),
      subtitle: const OBText(
        'Invite your connections and followers to join the community.',
        style: listItemSubtitleStyle,
      ),
      onTap: () {
        modalService.openInviteToCommunity(
            context: context, community: community);
      },
    ));

    menuListTiles.add(OBFavoriteCommunityTile(
        community: community,
        favoriteSubtitle: const OBText(
          'Add the community to your favorites',
          style: listItemSubtitleStyle,
        ),
        unfavoriteSubtitle: const OBText(
          'Remove the community to your favorites',
          style: listItemSubtitleStyle,
        )));

    if (loggedInUserIsCreator) {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.deleteCommunity),
        title: const OBText('Delete community'),
        subtitle: const OBText(
          'Delete the community, forever.',
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToDeleteCommunity(
              context: context, community: community);
        },
      ));
    } else {
      menuListTiles.add(ListTile(
        leading: const OBIcon(OBIcons.leaveCommunity),
        title: const OBText('Leave community'),
        subtitle: const OBText(
          'Leave the community.',
          style: listItemSubtitleStyle,
        ),
        onTap: () {
          navigationService.navigateToLeaveCommunity(
              context: context, community: community);
        },
      ));
    }

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Manage community',
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: menuListTiles)),
          ],
        ),
      ),
    );
  }
}
