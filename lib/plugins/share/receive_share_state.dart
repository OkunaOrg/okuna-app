import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'share.dart';

abstract class ReceiveShareState<T extends StatefulWidget> extends State<T> {
  static const stream = const EventChannel('openbook.social/receive_share');

  StreamSubscription shareReceiveSubscription = null;

  void enableSharing() {
    if (shareReceiveSubscription == null) {
      shareReceiveSubscription =
          stream.receiveBroadcastStream().listen(_onReceiveShare);
    }
  }

  void disableSharing() {
    if (shareReceiveSubscription != null) {
      shareReceiveSubscription.cancel();
      shareReceiveSubscription = null;
    }
  }

  void _onReceiveShare(dynamic shared) {
    onShare(Share.fromReceived(shared));
  }

  void onShare(Share share);
}
