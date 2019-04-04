import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBPostBodyText extends StatelessWidget {
  final Post _post;
  ToastService _toastService;
  BuildContext _context;

  OBPostBodyText(this._post);

  @override
  Widget build(BuildContext context) {
    _toastService = OpenbookProvider.of(context).toastService;
    _context = context;

    return GestureDetector(
        onLongPress: _copyText,
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: OBActionableSmartText(
              text: _post.getText(),
            ))
    );
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _post.getText()));
    _toastService.toast(message: 'Text copied!', context: _context, type: ToastType.info);
  }
}
