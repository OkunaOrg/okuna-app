import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/category_badge.dart';
import 'package:flutter/material.dart';

class OBCommunityCategories extends StatelessWidget {
  final Community community;

  OBCommunityCategories(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: community,
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data;
        if (community.categories == null) return const SizedBox();
        List<Category> categories = community.categories.categories;

        List<Widget> connectionItems = [];

        categories.forEach((Category category) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCategoryBadge(
                category: category,
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
