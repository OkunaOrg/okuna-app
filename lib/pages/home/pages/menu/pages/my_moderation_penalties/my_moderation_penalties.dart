import 'dart:async';

import 'package:Openbook/models/moderation/moderation_penalty_list.dart';
import 'package:Openbook/models/moderation/moderation_penalty.dart';
import 'package:Openbook/pages/home/pages/menu/pages/my_moderation_penalties/widgets/moderation_penalty/moderation_penalty.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyModerationPenaltiesPage extends StatefulWidget {
  @override
  State<OBMyModerationPenaltiesPage> createState() {
    return OBMyModerationPenaltiesPageState();
  }
}

class OBMyModerationPenaltiesPageState
    extends State<OBMyModerationPenaltiesPage> {
  UserService _userService;

  OBHttpListController _httpListController;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _httpListController = OBHttpListController();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Moderation penalties',
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<ModerationPenalty>(
          padding: EdgeInsets.all(15),
          controller: _httpListController,
          listItemBuilder: _buildModerationPenaltyListItem,
          listRefresher: _refreshModerationPenalties,
          listOnScrollLoader: _loadMoreModerationPenalties,
          resourceSingularName: 'moderation penalty',
          resourcePluralName: 'moderation penalties',
        ),
      ),
    );
  }

  Widget _buildModerationPenaltyListItem(
      BuildContext context, ModerationPenalty moderationPenalty) {
    return OBModerationPenaltyTile(
      moderationPenalty: moderationPenalty,
    );
  }

  Future<List<ModerationPenalty>> _refreshModerationPenalties() async {
    ModerationPenaltiesList moderationPenalties =
        await _userService.getModerationPenalties();
    return moderationPenalties.moderationPenalties;
  }

  Future<List<ModerationPenalty>> _loadMoreModerationPenalties(
      List<ModerationPenalty> moderationPenaltiesList) async {
    var lastModerationPenalty = moderationPenaltiesList.last;
    var lastModerationPenaltyId = lastModerationPenalty.id;
    var moreModerationPenalties = (await _userService.getModerationPenalties(
      maxId: lastModerationPenaltyId,
      count: 10,
    ))
        .moderationPenalties;
    return moreModerationPenalties;
  }
}
