import 'package:Okuna/models/community.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBCommunityActionMore extends StatelessWidget {
  final Community community;

  const OBCommunityActionMore(this.community);

  @override
  Widget build(BuildContext context) {

    return IconButton(
    icon: const OBIcon(
      OBIcons.moreVertical,
      customSize: 30,
    ),
    onPressed: () {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      openbookProvider.bottomSheetService.showCommunityActions(context: context, community: community);
    },
  );
  }
}
