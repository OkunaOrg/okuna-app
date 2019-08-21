import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/checkbox.dart';
import 'package:Okuna/widgets/fields/checkbox_field.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';

class OBConfirmOpenUrlBottomSheet extends StatelessWidget {
  final String url;
  BuildContext _context;

  OBConfirmOpenUrlBottomSheet({this.url});

  @override
  Widget build(BuildContext context) {
    var localizationService = OpenbookProvider.of(context).localizationService;
    _context = context;

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBText(
              localizationService.post__open_url_message,
            ),
            const SizedBox(
              height: 10,
            ),
            OBSmartText(
              text: url,
            ),
            const SizedBox(
              height: 10,
            ),
            OBCheckboxField(
              value: false,
              title: localizationService.post__open_url_dont_ask_again,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OBButton(
                    size: OBButtonSize.medium,
                    type: OBButtonType.highlight,
                    child: Text(localizationService.post__open_url_cancel),
                    onPressed: _onCancel,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OBButton(
                    size: OBButtonSize.medium,
                    type: OBButtonType.primary,
                    child: Text(localizationService.post__open_url_continue),
                    onPressed: _onConfirmOpen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirmOpen() {
    Navigator.pop(_context, true);
  }

  void _onCancel() {
    Navigator.pop(_context, false);
  }
}
