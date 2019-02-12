import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityCategories extends StatelessWidget {
  final Community community;

  OBCommunityCategories(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data;
        if (community == null) return const SizedBox();
        List<Category> categories = community.categories.categories;

        List<Widget> connectionItems = [
          const OBText(
            'In lists',
            size: OBTextSize.small,
          )
        ];

        categories.forEach((Category category) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBText(
                category.name,
                size: OBTextSize.small,
              )
            ],
          ));
        });

        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: connectionItems,
          ),
        );
      },
    );
  }
}
