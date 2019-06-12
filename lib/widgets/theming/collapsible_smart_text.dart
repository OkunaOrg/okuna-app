import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/smart_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'actionable_smart_text.dart';

class OBCollapsibleSmartText extends StatelessWidget {
  final String text;
  final int maxlength;
  final OBTextSize size;
  final TextOverflow overflow;
  final TextOverflow lengthOverflow;
  final SmartTextElement trailingSmartTextElement;

  const OBCollapsibleSmartText(
      {Key key,
      this.text,
      this.maxlength,
      this.size = OBTextSize.medium,
      this.overflow = TextOverflow.clip,
      this.lengthOverflow = TextOverflow.ellipsis,
      this.trailingSmartTextElement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool shouldBeCollapsed = text.length > maxlength;

    return shouldBeCollapsed
        ? _buildExpandableActionableSmartText()
        : _buildActionableSmartText();
  }

  Widget _buildExpandableActionableSmartText() {
    return ExpandableNotifier(
      controller: ExpandableController(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: _buildActionableSmartText(maxLength: maxlength),
            expanded: _buildActionableSmartText(),
          ),
          Builder(builder: (BuildContext context) {
            var exp = ExpandableController.of(context);

            if (exp.expanded) return const SizedBox();

            return GestureDetector(
                onTap: () {
                  exp.toggle();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OBSecondaryText(
                        'Show more',
                        size: OBTextSize.medium,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OBIcon(
                        OBIcons.arrowDown,
                        themeColor: OBIconThemeColor.secondaryText,
                      )
                    ],
                  ),
                ));
          })
        ],
      ),
    );
  }

  Widget _buildActionableSmartText({int maxLength}) {
    return OBActionableSmartText(
      text: text,
      maxlength: maxLength,
      size: size,
      lengthOverflow: lengthOverflow,
      trailingSmartTextElement: trailingSmartTextElement,
    );
  }
}
