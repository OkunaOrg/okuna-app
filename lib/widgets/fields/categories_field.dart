import 'package:Openbook/models/category.dart';
import 'package:Openbook/widgets/categories_picker.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCategoriesField extends StatelessWidget {
  final List<Category> initialCategories;
  final ValueChanged<List<Category>> onChanged;
  final String title;
  final Widget subtitle;
  final int max;
  final int min;

  const OBCategoriesField(
      {Key key,
      this.initialCategories,
      @required this.onChanged,
      @required this.title,
      this.subtitle,
      @required this.max,
      @required this.min})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBText(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: OBText('Pick up to $max categories'),
            ),
          ),
          OBCategoriesPicker(
            maxSelections: max,
            initialCategories: initialCategories,
            onChanged: onChanged,
          ),
          SizedBox(
            height: 20,
          ),
          OBDivider()
        ]);
  }
}
