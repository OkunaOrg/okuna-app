import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/smart_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'actionable_smart_text.dart';

class OBCollapsibleSmartText extends StatefulWidget {
  final String text;
  final int maxlength;
  final OBTextSize size;
  final TextOverflow overflow;
  final TextOverflow lengthOverflow;
  final SmartTextElement trailingSmartTextElement;
  final Function getChild;

  const OBCollapsibleSmartText(
      {Key key,
      this.text,
      this.maxlength,
      this.size = OBTextSize.medium,
      this.overflow = TextOverflow.clip,
      this.lengthOverflow = TextOverflow.ellipsis,
      this.getChild,
      this.trailingSmartTextElement})
      : super(key: key);

  @override
  OBCollapsibleSmartTextState createState() {
    return OBCollapsibleSmartTextState();
  }
}

class OBCollapsibleSmartTextState extends State<OBCollapsibleSmartText> {
  ExpandableController _expandableController;

  @override
  void initState() {
    super.initState();
    _expandableController = ExpandableController();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldBeCollapsed = widget.text.length > widget.maxlength;

    return shouldBeCollapsed
        ? _buildExpandableActionableSmartText()
        : _buildActionableSmartText();
  }

  Widget _buildExpandableActionableSmartText() {
    return ExpandableNotifier(
      controller: _expandableController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: _buildActionableSmartText(maxLength: widget.maxlength),
            expanded: _buildActionableSmartText(),
          ),
          Builder(builder: (BuildContext context) {
            var exp = ExpandableController.of(context);

            if (exp.expanded) return const SizedBox();

            return GestureDetector(
                onTap: _toggleExpandable,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.getChild(),
                      Row(
                        children: <Widget>[
                          OBSecondaryText(
                            'Show more',
                            size: widget.size,
                            textAlign: TextAlign.start,
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
                    ],
                  ),
                ));
          })
        ],
      ),
    );
  }

  void _toggleExpandable() {
    _expandableController.toggle();
  }

  Widget _buildActionableSmartText({int maxLength}) {
    Widget translateButton;

    if (maxLength != null) {
      translateButton = SizedBox();
    } else {
      translateButton = Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: widget.getChild(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBActionableSmartText(
          text: widget.text,
          maxlength: maxLength,
          size: widget.size,
          lengthOverflow: widget.lengthOverflow,
          trailingSmartTextElement: widget.trailingSmartTextElement,
        ),
        translateButton
      ],
    );
  }
}
