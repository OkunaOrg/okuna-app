import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectDescription extends StatelessWidget {
  final bool isEditable;
  final ModeratedObject moderatedObject;

  const OBModeratedObjectDescription(
      {Key key, @required this.moderatedObject, @required this.isEditable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBTileGroupTitle(
          title: 'Description',
        ),
        ListTile(
          onTap: () {
            OpenbookProviderState openbookProvider =
                OpenbookProvider.of(context);
            openbookProvider.navigationService
                .navigateToModeratedObjectUpdateDescription(
                    context: context, moderatedObject: moderatedObject);
          },
          title: StreamBuilder(
            initialData: moderatedObject,
            stream: moderatedObject.updateSubject,
            builder: (BuildContext context,
                AsyncSnapshot<ModeratedObject> snapshot) {
              return OBText(snapshot.data.description);
            },
          ),
          trailing: const OBIcon(OBIcons.chevronRight),
        )
      ],
    );
  }
}
