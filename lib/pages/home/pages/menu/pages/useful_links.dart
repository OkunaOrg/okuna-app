import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUsefulLinksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var urlLauncherService = openbookProvider.urlLauncherService;
    var _localizationService = openbookProvider.localizationService;

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.drawer__useful_links_title,
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              physics: const ClampingScrollPhysics(),
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const OBIcon(OBIcons.guide),
                  title: OBText(_localizationService.drawer__useful_links_guidelines),
                  subtitle: OBSecondaryText(
                      _localizationService.drawer__useful_links_guidelines_desc),
                  onTap: () {
                    OpenbookProviderState openbookProvider =
                        OpenbookProvider.of(context);
                    openbookProvider.navigationService
                        .navigateToCommunityGuidelinesPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.dashboard),
                  title: OBText(_localizationService.drawer__useful_links_guidelines_github),
                  subtitle: OBSecondaryText(
                      _localizationService.drawer__useful_links_guidelines_github_desc),
                  onTap: () {
                    urlLauncherService.launchUrlWithoutConfirmation(
                        'https://github.com/orgs/OkunaOrg/projects/3');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.featureRequest),
                  title: OBText(_localizationService.drawer__useful_links_guidelines_feature_requests),
                  subtitle: OBSecondaryText(
                      _localizationService.drawer__useful_links_guidelines_feature_requests_desc),
                  onTap: () {
                    urlLauncherService.launchUrlWithoutConfirmation(
                        'https://okuna.canny.io/feature-requests');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.bug),
                  title: OBText(_localizationService.drawer__useful_links_guidelines_bug_tracker),
                  subtitle:
                      OBSecondaryText(_localizationService.drawer__useful_links_guidelines_bug_tracker_desc),
                  onTap: () {
                    urlLauncherService.launchUrlWithoutConfirmation(
                        'https://okuna.canny.io/bugs');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.guide),
                  title: OBText(_localizationService.drawer__useful_links_guidelines_handbook),
                  subtitle: OBSecondaryText(
                     _localizationService.drawer__useful_links_guidelines_handbook_desc),
                  onTap: () {
                    urlLauncherService.
                        launchUrlWithoutConfirmation('https://openbook.support/');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.slackChannel),
                  title: OBText(_localizationService.drawer__useful_links_slack_channel),
                  subtitle: OBSecondaryText(
                      _localizationService.drawer__useful_links_slack_channel_desc),
                  onTap: () {
                    urlLauncherService.launchUrlWithoutConfirmation(
                        'https://join.slack.com/t/okuna/shared_invite/enQtNDI2NjI3MDM0MzA2LTYwM2E1Y2NhYWRmNTMzZjFhYWZlYmM2YTQ0MWEwYjYyMzcxMGI0MTFhNTIwYjU2ZDI1YjllYzlhOWZjZDc4ZWY');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.support),
                  title: OBText(_localizationService.drawer__useful_links_support),
                  subtitle: OBSecondaryText(
                      _localizationService.drawer__useful_links_support_desc),
                  onTap: () {
                    urlLauncherService.
                        launchUrlWithoutConfirmation('https://www.okuna.io/en/faq');
                  },
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
