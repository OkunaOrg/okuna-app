import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:Okuna/plugins/share/share.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'media.dart';

class ShareService {
  static const _stream = const EventChannel('openbook.social/receive_share');

  ToastService _toastService;
  MediaService _mediaService;
  ValidationService _validationService;
  LocalizationService _localizationService;

  StreamSubscription _shareReceiveSubscription;
  List<Share> _shareQueue;
  List<Future<dynamic> Function({String text, File image, File video})> _subscribers;

  CancelableOperation _activeShareOperation;

  BuildContext _context;

  ShareService() {
    _shareQueue = [];
    _subscribers = [];

    if (Platform.isAndroid) {
      if (_shareReceiveSubscription == null) {
        _shareReceiveSubscription =
            _stream.receiveBroadcastStream().listen(_onReceiveShare);
      }
    }
  }

  void setToastService(ToastService toastService) {
    _toastService = toastService;
  }

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  void setMediaService(MediaService mediaService) {
    _mediaService = mediaService;
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  /// Subscribe to share events.
  ///
  /// [onShare] should return [true] if it consumes the share immediately,
  /// a [CancelableOperation] if some amount of work has to be done first (like
  /// gif to video conversion in OBSavePostModal), or [false] if the subscriber
  /// did _not_ consume the share (the share will be passed on to the next subscriber).
  ///
  /// If a [CancelableOperation] is returned, it _must_ handle cancellation
  /// properly.
  void subscribe(Future<dynamic> Function({String text, File image, File video}) onShare) {
    _subscribers.add(onShare);

    if (_subscribers.length == 1) {
      _emptyQueue();
    }
  }

  void unsubscribe(Future<dynamic> Function({String text, File image, File video}) subscriber) {
    _subscribers.remove(subscriber);
  }

  Future<void> _emptyQueue() async {
    var consumed = <Share>[];
    for (Share share in _shareQueue) {
      if (await _onShare(share)) {
        consumed.add(share);
      }
    }

    consumed.forEach((e) => _shareQueue.remove(e));
  }

  void _onReceiveShare(dynamic shared) async {
    var share = Share.fromReceived(shared);

    if (_subscribers.isEmpty) {
      _shareQueue.add(share);
    } else {
      await _onShare(share);
    }
  }

  Future<bool> _onShare(Share share) async {
    String text;
    File image;
    File video;

    if (_activeShareOperation != null) {
      _activeShareOperation.cancel();
    }

    if (share.error != null) {
      _toastService.error(
          message: _localizationService.trans(share.error), context: _context);
      if (share.error.contains('uri_scheme')) {
        throw share.error;
      }
      return true;
    }

    if (share.image != null) {
      image = File.fromUri(Uri.parse(share.image));
      image = await _mediaService.processImage(image);
      if (!await _validationService.isImageAllowedSize(
          image, OBImageType.post)) {
        _showFileTooLargeToast(
            _validationService.getAllowedImageSize(OBImageType.post));
        return true;
      }
    }

    if (share.video != null) {
      video = File.fromUri(Uri.parse(share.video));

      if (!await _validationService.isVideoAllowedSize(video)) {
        _showFileTooLargeToast(_validationService.getAllowedVideoSize());
        return true;
      }
    }

    if (share.text != null) {
      text = share.text;
      if (!_validationService.isPostTextAllowedLength(text)) {
        _toastService.error(
            message:
                'Text too long (limit: ${ValidationService.POST_MAX_LENGTH} characters)',
            context: _context);
        return true;
      }
    }

    for (var sub in _subscribers.reversed) {
      var subResult = await sub(text: text, image: image, video: video);

      // Stop event propagation if we have a sub-result that is either true or
      // a CancelableOperation.
      if (subResult is CancelableOperation) {
        _activeShareOperation = subResult;
        return true;
      }
      else if (subResult is bool && subResult) {
        return true;
      }
    }

    return false;
  }

  Future _showFileTooLargeToast(int limitInBytes) async {
    _toastService.error(
        message: _localizationService.image_picker__error_too_large(
            limitInBytes ~/ 1048576),
        context: _context);
  }
}