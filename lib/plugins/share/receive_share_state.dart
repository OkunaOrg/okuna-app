import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'share.dart';

abstract class ReceiveShareState<T extends StatefulWidget> extends State<T> {
  static const stream = const EventChannel('openbook.social/receive_share');

  StreamSubscription shareReceiveSubscription = null;

  void enableReceiving() {
    if (shareReceiveSubscription == null) {
      shareReceiveSubscription =
          stream.receiveBroadcastStream().listen(_onReceiveShare);
      debugPrint("enabled share receiving");
    }
  }

  void disableReceiving() {
    if (shareReceiveSubscription != null) {
      shareReceiveSubscription.cancel();
      shareReceiveSubscription = null;
    }
  }

  void _onReceiveShare(dynamic shared) {
    receiveShare(Share.fromReceived(shared));
  }

  void receiveShare(Share share);
}
