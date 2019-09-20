import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'share.dart';

abstract class ReceiveShareState<T extends StatefulWidget> extends State<T> {
  static const stream = const EventChannel('openbook.social/receive_share');

  StreamSubscription shareReceiveSubscription;
  bool queueShares;
  List<Share> shareQueue;

  @override
  void initState() {
    super.initState();
    shareQueue = <Share>[];
    queueShares = true;
    _activateShareListener();
  }

  void _activateShareListener() {
    if(Platform.isAndroid){
      if (shareReceiveSubscription == null) {
        shareReceiveSubscription =
            stream.receiveBroadcastStream().listen(_onReceiveShare);
      }
    }
  }

  Future<void> enableShareProcessing() async {
    queueShares = false;
    await Future.forEach(shareQueue, onShare);
  }

  void disableShareProcessing() {
    queueShares = false;
  }

  void disableSharing() {
    if (shareReceiveSubscription != null) {
      shareReceiveSubscription.cancel();
      shareReceiveSubscription = null;
    }
  }

  void _onReceiveShare(dynamic shared) {
    var share = Share.fromReceived(shared);

    if (queueShares) {
      shareQueue.add(share);
    } else {
      onShare(share);
    }
  }

  Future<void> onShare(Share share);
}
