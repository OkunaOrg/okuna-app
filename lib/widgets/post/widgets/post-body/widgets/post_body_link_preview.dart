import 'dart:async';

import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/widgets/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class OBPostBodyLinkPreview extends StatefulWidget {
  final Post post;

  const OBPostBodyLinkPreview({Key key, this.post}) : super(key: key);

  @override
  OBPostBodyLinkPreviewState createState() {
    return OBPostBodyLinkPreviewState();
  }
}

class OBPostBodyLinkPreviewState extends State<OBPostBodyLinkPreview> {
  LinkPreviewService _linkPreviewService;
  bool _needsBootstrap;

  CancelableOperation _retrieveLinkPreviewOperation;
  bool _retrievePostMediaInProgress;
  StreamSubscription _postUpdateSubscription;

  LinkPreview _linkPreview;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _retrievePostMediaInProgress = true;
  }

  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _retrievePostMediaInProgress = true;
    _needsBootstrap = true;
  }

  @override
  void dispose() {
    super.dispose();
    _retrieveLinkPreviewOperation?.cancel();
    _postUpdateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _linkPreviewService = openbookProvider.linkPreviewService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: _retrievePostMediaInProgress || _linkPreview == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: OBLinkPreview(
                linkPreview: _linkPreview,
              ),
            ),
    );
  }

  void _bootstrap() {
    if (widget.post.text == null) {
      _retrievePostMediaInProgress = false;
      return;
    }

    if (widget.post.linkPreview != null) {
      _retrievePostMediaInProgress = false;
      _linkPreview = widget.post.linkPreview;
      return;
    }

    String linkPreviewUrl =
        _linkPreviewService.checkForLinkPreviewUrl(widget.post.text);
    if (linkPreviewUrl != null) {
      _retrieveLinkPreview(linkPreviewUrl);
    } else {
      _retrievePostMediaInProgress = false;
    }
  }

  void _onPostUpdate(Post post) {
    if (post.text == null) {
      _clear();
    } else {
      String newLinkPreviewUrl =
          _linkPreviewService.checkForLinkPreviewUrl(post.text);
      if (newLinkPreviewUrl != _linkPreview?.url)
        _retrieveLinkPreview(newLinkPreviewUrl);
    }
  }

  void _retrieveLinkPreview(String link) async {
    _setRetrieveLinkPreviewInProgress(true);
    try {
      _retrieveLinkPreviewOperation =
          CancelableOperation.fromFuture(_linkPreviewService.previewLink(link));
      LinkPreview linkPreview = await _retrieveLinkPreviewOperation.value;
      widget.post.setLinkPreview(linkPreview);
    } catch (error) {
      // Don't care
    } finally {
      _setRetrieveLinkPreviewInProgress(false);
    }
  }

  void _setRetrieveLinkPreviewInProgress(bool retrievePostMediaInProgress) {
    setState(() {
      _retrievePostMediaInProgress = retrievePostMediaInProgress;
    });
  }

  void _clear() {
    setState(() {
      _linkPreview = null;
    });
  }
}
