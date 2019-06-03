import 'package:Openbook/models/moderation/moderated_object_log.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import 'moderated_object_log_actor.dart';

class OBModeratedObjectVerifiedChangedLogTile extends StatelessWidget {
  final ModeratedObjectLog log;
  final ModeratedObjectVerifiedChangedLog moderatedObjectVerifiedChangedLog;
  final VoidCallback onPressed;

  const OBModeratedObjectVerifiedChangedLogTile(
      {Key key,
      @required this.log,
      @required this.moderatedObjectVerifiedChangedLog,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBText(
            'Verified changed from:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          OBSecondaryText(
              moderatedObjectVerifiedChangedLog.changedFrom.toString()),
          const SizedBox(
            height: 10,
          ),
          OBText(
            'To:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          OBSecondaryText(
              moderatedObjectVerifiedChangedLog.changedTo.toString()),
          const SizedBox(
            height: 10,
          ),
          OBText(
            'By:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          OBModeratedObjectLogActor(
            actor: log.actor,
          )
        ],
      ),
    );
  }
}
