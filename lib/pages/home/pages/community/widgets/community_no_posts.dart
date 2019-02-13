import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/alert.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityNoPosts extends StatelessWidget {
  final Community community;
  final VoidCallback onWantsToRefreshCommunity;

  OBCommunityNoPosts(this.community,
      {@required this.onWantsToRefreshCommunity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: OBAlert(
          child: Row(children: [
        Padding(
          padding: EdgeInsets.only(right: 30, left: 10, top: 10, bottom: 10),
          child: Image.asset(
            'assets/images/stickers/perplexed-owl.png',
            height: 80,
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: OBText('There are no posts yet.', textAlign: TextAlign.center,),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              OBButton(
                icon: const OBIcon(
                  OBIcons.refresh,
                  size: OBIconSize.small,
                ),
                type: OBButtonType.highlight,
                child: Text('Refresh'),
                onPressed: onWantsToRefreshCommunity,
              )
            ],
          ),
        )
      ])),
    );
  }
}
