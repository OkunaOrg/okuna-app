import 'dart:async';

import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/widgets/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class OBPostBodyLinkPreview extends StatelessWidget {
  final Post post;

  const OBPostBodyLinkPreview({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Post>(
        stream: post.updateSubject,
        initialData: post,
        builder: _buildLinkPreview);
  }

  Widget _buildLinkPreview(BuildContext context, AsyncSnapshot<Post> snapshot) {
    if (post.linkPreview != null)
      return OBLinkPreview(
        linkPreview: post.linkPreview,
      );

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

    String link =
        openbookProvider.linkPreviewService.checkForLinkPreviewUrl(post.text);

    return OBLinkPreview(
        link: link, onLinkPreviewRetrieved: _onLinkPreviewRetrieved);
  }

  void _onLinkPreviewRetrieved(LinkPreview linkPreview) {
    post.setLinkPreview(linkPreview);
  }
}
