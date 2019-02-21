import 'package:Openbook/models/community.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
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

    const TextStyle listItemSubtitleStyle = TextStyle(fontSize: 14);

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
              children: <Widget>[
                ListTile(
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
                ),
                community.isCreator
                    ? ListTile(
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
                      )
                    : const SizedBox(),
                ListTile(
                  leading: const OBIcon(OBIcons.communityModerators),
                  title: const OBText('Moderators'),
                  subtitle: const OBText(
                    'See, add and remove moderators.',
                    style: listItemSubtitleStyle,
                  ),
                  onTap: () {
                    navigationService.navigateToFollowsLists(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.communityBannedUsers),
                  title: const OBText('Banned users'),
                  subtitle: const OBText(
                    'See, add and remove banned users.',
                    style: listItemSubtitleStyle,
                  ),
                  onTap: () {
                    navigationService.navigateToFollowsLists(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.deleteCommunity),
                  title: const OBText('Delete community'),
                  subtitle: const OBText(
                    'Delete the community, forever.',
                    style: listItemSubtitleStyle,
                  ),
                  onTap: () {
                    navigationService.navigateToFollowsLists(context: context);
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
