import 'package:flutter/cupertino.dart';

class ShareSubscription {
  final VoidCallback _cancel;

  ShareSubscription(this._cancel);

  void cancel() {
    _cancel();
  }
}
