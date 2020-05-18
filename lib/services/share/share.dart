import 'dart:async';
import 'dart:io';

import 'package:Okuna/plugins/share/share.dart' as SharePlugin;
import 'package:Okuna/services/event/event.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/media/media.dart';
import 'package:Okuna/services/media/models/media_file.dart';
import 'package:Okuna/services/share/models/share.dart';
import 'package:Okuna/services/share/models/share_event.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/validation.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareService {
  static const _stream = const EventChannel('openbook.social/receive_share');

  ToastService _toastService;
  MediaService _mediaService;
  ValidationService _validationService;
  LocalizationService _localizationService;
  EventService _eventService;

  StreamSubscription _shareReceiveSubscription;

  SharePlugin.Share _queuedShare;
  bool _isProcessingShare = false;
  Map<SharePlugin.Share, ShareOperation> _activeShares;

  BuildContext _context;

  ShareService() {
    _activeShares = {};

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

  void setEventService(EventService eventService) {
    _eventService = eventService;
    _eventService.subscribe(_onSubscriberEvent);
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> _onSubscriberEvent(SubscriptionEvent event) async {
    if (event.oldSubscriberCount == 0 && event.newSubscriberCount > 0) {
      _processQueuedShare();
    }
  }

  void _onReceiveShare(dynamic shared) async {
    _queuedShare = SharePlugin.Share.fromReceived(shared);

    if (_eventService.subscriberCount(SubscriptionEvent) > 0 && !_isProcessingShare) {
      _processQueuedShare();
    }
  }

  Future<void> _processQueuedShare() async {
    if (_queuedShare != null) {
      // Schedule cancellation of existing share operations. We don't cancel
      // immediately since that can cause concurrent modification of _activeShares.
      _activeShares
          .forEach((key, value) => Future.delayed(Duration(), value.cancel));

      var share = _queuedShare;
      _queuedShare = null;

      _isProcessingShare = true;
      _activeShares[share] = ShareOperation(share, _onShare);
      _activeShares[share].then(() => _activeShares.remove(share));
      _activeShares[share].start();
      _isProcessingShare = false;

      // Recurse since a new share might have came in while the last was being processed.
      _processQueuedShare();
    }
  }

  Future<void> _onShare(SharePlugin.Share share) async {
    String text;
    File image;
    File video;

    await _eventService.post(ShareEvent(ShareStatus.received));

    //TODO(komposten): Cancelling the share op should cancel processMedia!

    /*TODO(komposten): Send a cancel or failure event if an exception is thrown
       at any point (i.e. share.error != null, image/video too big, or text too long.
     */
    if (share.error != null) {
      _toastService.error(
          message: _localizationService.trans(share.error), context: _context);
      if (share.error.contains('uri_scheme')) {
        throw share.error;
      }
      return;
    }

    if (share.image != null) {
      image = File.fromUri(Uri.parse(share.image));
      var processedFile = await _mediaService.processMedia(
        media: MediaFile(image, FileType.image),
        context: _context,
      );
      image = processedFile.file;
    }

    if (share.video != null) {
      video = File.fromUri(Uri.parse(share.video));

      var processedFile = await _mediaService.processMedia(
        media: MediaFile(video, FileType.video),
        context: _context,
      );

      video = processedFile.file;
    }

    if (share.text != null) {
      text = share.text;
      if (!_validationService.isPostTextAllowedLength(text)) {
        String errorMessage =
            _localizationService.error__receive_share_text_too_long(
                ValidationService.POST_MAX_LENGTH);
        _toastService.error(message: errorMessage, context: _context);
        return;
      }
    }

    var newShare = Share(text: text, image: image, video: video);

    if (_activeShares[share].isCancelled) {
      return;
    }

    _eventService.post(ShareEvent(ShareStatus.processed, data: newShare));
  }
}

class ShareOperation {
  final Future<void> Function(SharePlugin.Share) _shareFunction;

  SharePlugin.Share share;
  CancelableOperation shareOperation;
  bool isCancelled = false;

  bool _shareComplete = false;
  FutureOr Function() _callback;

  ShareOperation(this.share, Future<void> Function(SharePlugin.Share) shareFunction)
      : _shareFunction = shareFunction;

  void start() {
    shareOperation = CancelableOperation.fromFuture(_shareFunction(share));
    shareOperation.then((_) {
      _shareComplete = true;
      _complete();
    });
  }

  void cancel() {
    isCancelled = true;
    shareOperation?.cancel();
  }

  void then(FutureOr Function() callback) {
    _callback = callback;
  }

  void _complete() {
    if (shareOperation == null || _shareComplete) {
      _callback();
    }
  }
}
