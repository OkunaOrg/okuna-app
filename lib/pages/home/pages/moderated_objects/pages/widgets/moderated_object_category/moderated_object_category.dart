import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:Openbook/widgets/tiles/moderation_category_tile.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectCategory extends StatelessWidget {
  final bool isEditable;
  final ModeratedObject moderatedObject;
  final ValueChanged<ModerationCategory> onCategoryChanged;

  const OBModeratedObjectCategory(
      {Key key,
      @required this.moderatedObject,
      @required this.isEditable,
      this.onCategoryChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBTileGroupTitle(
          title: 'Category',
        ),
        StreamBuilder(
          initialData: moderatedObject,
          stream: moderatedObject.updateSubject,
          builder:
              (BuildContext context, AsyncSnapshot<ModeratedObject> snapshot) {
            return OBModerationCategoryTile(
              category: snapshot.data.category,
              onPressed: (category) async {
                if (!isEditable) return;
                OpenbookProviderState openbookProvider =
                    OpenbookProvider.of(context);
                ModerationCategory newModerationCategory =
                    await openbookProvider.modalService
                        .openModeratedObjectUpdateCategory(
                            context: context, moderatedObject: moderatedObject);
                if (newModerationCategory != null && onCategoryChanged != null)
                  onCategoryChanged(newModerationCategory);
              },
              trailing: isEditable ? const OBIcon(
                OBIcons.edit,
                themeColor: OBIconThemeColor.secondaryText,
              ) : null,
            );
          },
        ),
      ],
    );
  }
}
