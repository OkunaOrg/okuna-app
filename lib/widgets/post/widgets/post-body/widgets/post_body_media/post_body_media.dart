import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/models/post_media.dart';
import 'package:Okuna/models/post_media_list.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_body_media/widgets/post_body_image.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_body_media/widgets/post_body_video.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class OBPostBodyMedia extends StatefulWidget {
  final Post post;
  final String inViewId;

  const OBPostBodyMedia({Key key, this.post, this.inViewId}) : super(key: key);

  @override
  OBPostBodyMediaState createState() {
    return OBPostBodyMediaState();
  }
}

class OBPostBodyMediaState extends State<OBPostBodyMedia> {
  UserService _userService;
  LocalizationService _localizationService;
  bool _needsBootstrap;
  String _errorMessage;

  CancelableOperation _retrievePostMediaOperation;
  bool _retrievePostMediaInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _retrievePostMediaInProgress = true;
    _errorMessage = '';
  }

  void didUpdateWidget(oldWidget){
    super.didUpdateWidget(oldWidget);
    _retrievePostMediaInProgress = true;
    _needsBootstrap = true;
    _errorMessage = '';
  }

  @override
  void dispose() {
    super.dispose();
    if (_retrievePostMediaOperation != null)
      _retrievePostMediaOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }
    return _errorMessage.isEmpty ? _buildPostMedia() : _buildErrorMessage();
  }

  Widget _buildErrorMessage() {
    return Stack(
      children: <Widget>[
        _buildPostMediaItemsThumbnail(),
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(3)),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildPostMedia() {
    return _retrievePostMediaInProgress
        ? _buildPostMediaItemsThumbnail()
        : StreamBuilder(
            stream: widget.post.updateSubject,
            initialData: widget.post,
            builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
              List<PostMedia> postMediaItems = widget.post.getMedia();
              return _buildPostMediaItems(postMediaItems);
            },
          );
  }

  Widget _buildPostMediaItemsThumbnail() {
    String thumbnailUrl = widget.post.mediaThumbnail;
    double mediaWidth = widget.post.mediaWidth;
    double mediaHeight = widget.post.mediaHeight;
    double screenWidth = MediaQuery.of(context).size.width;

    double thumbnailAspectRatio = mediaWidth / mediaHeight;
    double thumbnailHeight = (screenWidth / thumbnailAspectRatio);

    return SizedBox(
        width: screenWidth,
        height: thumbnailHeight,
        child: Image(
            image: AdvancedNetworkImage(thumbnailUrl,
                useDiskCache: true,
                fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
                retryLimit: 3,
                timeoutDuration: const Duration(seconds: 3))));
  }

  Widget _buildPostMediaItems(List<PostMedia> postMediaItems) {
    // We support only one atm
    PostMedia postMediaItem = postMediaItems.first;
    return _buildPostMediaItem(postMediaItem);
  }

  Widget _buildPostMediaItem(PostMedia postMediaItem) {
    Widget postMediaItemWidget;

    dynamic postMediaItemContentObject = postMediaItem.contentObject;

    switch (postMediaItemContentObject.runtimeType) {
      case PostImage:
        postMediaItemWidget = OBPostBodyImage(
          postImage: postMediaItemContentObject,
        );
        break;
      case PostVideo:
        postMediaItemWidget = OBPostBodyVideo(
            postVideo: postMediaItemContentObject,
            post: widget.post,
            inViewId: widget.inViewId);
        break;
      default:
        postMediaItemWidget = Center(
          child: OBText(_localizationService.post_body_media__unsupported),
        );
    }

    return postMediaItemWidget;
  }

  void _bootstrap() {
    if (widget.post.media != null) {
      _retrievePostMediaInProgress = false;
      return;
    }
    _retrievePostMedia();
  }

  void _retrievePostMedia() async {
    _setRetrievePostMediaInProgress(true);
    try {
      _retrievePostMediaOperation = CancelableOperation.fromFuture(
          _userService.getMediaForPost(post: widget.post));
      PostMediaList mediaList = await _retrievePostMediaOperation.value;
      widget.post.setMedia(mediaList);
    } catch (error) {
      _onError(error);
    } finally {
      _setRetrievePostMediaInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _setErrorMessage(error.toHumanReadableMessage());
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _setErrorMessage(errorMessage);
    } else {
      _setErrorMessage(_localizationService.error__unknown_error);
      throw error;
    }
  }

  void _setErrorMessage(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
  }

  void _setRetrievePostMediaInProgress(bool retrievePostMediaInProgress) {
    setState(() {
      _retrievePostMediaInProgress = retrievePostMediaInProgress;
    });
  }
}
