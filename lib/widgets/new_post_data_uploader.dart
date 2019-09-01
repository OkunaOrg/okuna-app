import 'dart:async';
import 'dart:io';

import 'package:Okuna/models/circle.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:async/async.dart';

import 'icon.dart';

class OBNewPostDataUploader extends StatefulWidget {
  final OBNewPostData data;
  final ValueChanged<Post> onPostUploaded;

  const OBNewPostDataUploader(
      {Key key, @required this.data, @required this.onPostUploaded})
      : super(key: key);

  @override
  OBNewPostDataUploaderState createState() {
    return OBNewPostDataUploaderState();
  }
}

class OBNewPostDataUploaderState extends State<OBNewPostDataUploader> {
  UserService _userService;
  LocalizationService _localizationService;

  bool _needsBootstrap;
  OBPostUploaderStatus _status;

  String _statusMessage;

  Post _createdDraftPost;
  OBPostStatus _createdDraftPostStatus;
  List<File> _remainingMediaToUpload;
  List<File> _mediaToUpload;

  static double mediaPreviewSize = 40;

  Timer _checkPostStatusTimer;

  CancelableOperation _getPostStatusOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _status = OBPostUploaderStatus.idle;
    _mediaToUpload = widget.data.getMedia();
    _remainingMediaToUpload = widget.data.getMedia();
  }

  @override
  void dispose() {
    super.dispose();
    _ensurePostStatusTimerIsCancelled();
    if (_getPostStatusOperation != null) _getPostStatusOperation.cancel();
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

    List<Widget> rowItems = [];

    if (widget.data.hasMedia()) {
      rowItems.addAll([
        _buildMediaPreview(),
        const SizedBox(
          width: 15,
        ),
      ]);
    }

    rowItems.addAll([_buildStatusText(), _buildActionButtons()]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(children: rowItems),
              _status == OBPostUploaderStatus.creatingPost ||
                      _status == OBPostUploaderStatus.addingPostMedia
                  ? _buildProgressBar()
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }

  void _bootstrap() {
    _uploadPost();
  }

  Future _uploadPost() async {
    try {
      if (_createdDraftPost == null) {
        _setStatus(OBPostUploaderStatus.creatingPost);
        _setStatusMessage(_localizationService.post_uploader__creating_post);
        _createdDraftPost = await _createPost();
      }

      if (_remainingMediaToUpload.isNotEmpty) {
        _setStatusMessage(_localizationService.post_uploader__uploading_media);
        _setStatus(OBPostUploaderStatus.addingPostMedia);
        await _addPostMedia();
      }
      _setStatusMessage(_localizationService.post_uploader__processing);
      _setStatus(OBPostUploaderStatus.processing);
      _ensurePostStatusTimerIsCancelled();

      if (_createdDraftPostStatus == null ||
          _createdDraftPostStatus != OBPostStatus.published) {
        _checkPostStatusTimer =
            Timer.periodic(new Duration(seconds: 1), (timer) async {
          if (_getPostStatusOperation != null) return;
          _getPostStatusOperation = CancelableOperation.fromFuture(
              _userService.getPostStatus(post: _createdDraftPost));
          OBPostStatus status = await _getPostStatusOperation.value;
          _createdDraftPostStatus = status;
          if (_createdDraftPostStatus == OBPostStatus.published) {
            _checkPostStatusTimer.cancel();
            _getPublishedPost();
          }
        });
      } else {
        _getPublishedPost();
      }
    } catch (error) {
      if (error is HttpieConnectionRefusedError) {
        _setStatusMessage(error.toHumanReadableMessage());
      } else if (error is HttpieRequestError) {
        String errorMessage = await error.toHumanReadableMessage();
        _setStatusMessage(errorMessage);
      } else {
        _setStatusMessage(
            _localizationService.post_uploader__generic_upload_failed);
        throw error;
      }
      _setStatus(OBPostUploaderStatus.failed);
    }
  }

  Future _createPost() async {
    Post draftPost;

    if (widget.data.community != null) {
      draftPost = await _userService.createPostForCommunity(
          widget.data.community,
          text: widget.data.text);
    } else {
      draftPost = await _userService.createPost(
          text: widget.data.text, circles: widget.data.getCircles());
    }

    this._createdDraftPost = draftPost;
  }

  Future _getPublishedPost() async {
    Post publishedPost =
        await _userService.getPostWithUuid(_createdDraftPost.uuid);
    widget.onPostUploaded(publishedPost);
  }

  Future _addPostMedia() {
    return Future.wait(
        _remainingMediaToUpload.map(_uploadPostMediaItem).toList());
  }

  Future _uploadPostMediaItem(File file) async {
    await _userService.addMediaToPost(file: file, post: _createdDraftPost);
    _remainingMediaToUpload.remove(file);
  }

  Widget _buildProgressBar() {
    if (_status != OBPostUploaderStatus.addingPostMedia &&
        _status != OBPostUploaderStatus.creatingPost) return const SizedBox();
    return LinearProgressIndicator();
  }

  Widget _buildMediaPreview() {
    if (_mediaToUpload.isEmpty) return const SizedBox();

    return FutureBuilder(
      future: _getMediaThumbnail(),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.data == null) return const SizedBox();

        File mediaThumbnail = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
            image: FileImage(mediaThumbnail),
            height: mediaPreviewSize,
            width: mediaPreviewSize,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Future<File> _getMediaThumbnail() async {
    File mediaToPreview = _mediaToUpload.first;
    File mediaThumbnail;

    String mediaMime = lookupMimeType(mediaToPreview.path);
    String mediaMimeType = mediaMime.split('/')[0];

    if (mediaMimeType == 'image') {
      mediaThumbnail = mediaToPreview;
    } else if (mediaMimeType == 'video') {
      String mediaThumbnailPath = await Thumbnails.getThumbnail(
          // creates the specified path if it doesnt exist
          videoFile: mediaToPreview.path,
          imageType: ThumbFormat.JPEG,
          quality: 30);
      mediaThumbnail = File(mediaThumbnailPath);
    } else {
      print('Unsupported media type');
    }

    return mediaThumbnail;
  }

  Widget _buildStatusText() {
    return OBText(_statusMessage);
  }

  Widget _buildActionButtons() {
    List<Widget> activeActions = [];

    switch (_status) {
      case OBPostUploaderStatus.creatingPost:
      case OBPostUploaderStatus.addingPostMedia:
        activeActions.add(_buildCancelButton());
        break;
      case OBPostUploaderStatus.failed:
        activeActions.add(_buildRetryButton());
        break;
      default:
    }

    return Row(
      children: activeActions,
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: _onWantsToCancel,
      child: OBIcon(OBIcons.cancel),
    );
  }

  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: _onWantsToRetry,
      child: OBIcon(OBIcons.retry),
    );
  }

  void _onWantsToRetry() async {
    if (_status == OBPostUploaderStatus.creatingPost ||
        _status == OBPostUploaderStatus.addingPostMedia) return;

    _uploadPost();
  }

  void _onWantsToCancel() async {
    if (_status == OBPostUploaderStatus.cancelling) return;
    _setStatus(OBPostUploaderStatus.cancelling);
    // Delete post
    if (_createdDraftPost != null) {
      // If it doesnt work, will get cleaned up by a scheduled job
      _userService.deletePost(_createdDraftPost);
    }

    _deleteMediaFiles();
    _setStatus(OBPostUploaderStatus.cancelled);
  }

  void _deleteMediaFiles() async {
    _mediaToUpload.forEach((File mediaFile) {
      mediaFile.delete();
    });
  }

  void _setStatus(OBPostUploaderStatus status) {
    setState(() {
      _status = status;
    });
  }

  void _setStatusMessage(String statusMessage) {
    setState(() {
      _statusMessage = statusMessage;
    });
  }

  void _ensurePostStatusTimerIsCancelled() {
    if (_checkPostStatusTimer != null && _checkPostStatusTimer.isActive)
      _checkPostStatusTimer.cancel();
  }
}

class OBNewPostData {
  String text;
  List<File> media;
  Community community;
  List<Circle> circles;

  OBNewPostData({this.text, this.media, this.community, this.circles});

  bool hasMedia() {
    return media != null && media.isNotEmpty;
  }

  List<File> getMedia() {
    return hasMedia() ? media.toList() : [];
  }

  void setCircles(List<Circle> circles) {
    this.circles = circles;
  }

  void setCommunity(Community community) {
    this.community = community;
  }

  List<Circle> getCircles() {
    return circles.toList();
  }
}

enum OBPostUploaderStatus {
  idle,
  creatingPost,
  addingPostMedia,
  processing,
  success,
  failed,
  cancelling,
  cancelled,
}
