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

import 'icon.dart';

class OBPostUploader extends StatefulWidget {
  final OBCreatePostData uploadData;

  const OBPostUploader({Key key, @required this.uploadData}) : super(key: key);

  @override
  OBPostUploaderState createState() {
    return OBPostUploaderState();
  }
}

class OBPostUploaderState extends State<OBPostUploader> {
  UserService _userService;
  LocalizationService _localizationService;

  bool _needsBootstrap;
  OBPostUploaderStatus _status;

  String _statusMessage;

  Post _createdDraftPost;
  List<File> _remainingMediaToUpload;
  List<File> _mediaToUpload;

  static double mediaPreviewSize = 40;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _status = OBPostUploaderStatus.idle;
    _mediaToUpload = widget.uploadData.getMedia();
    _remainingMediaToUpload = widget.uploadData.getMedia();
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

    if (widget.uploadData.hasMedia()) {
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
      _setStatusMessage(_localizationService.post_uploader__success);
      _setStatus(OBPostUploaderStatus.success);
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

    if (widget.uploadData.community != null) {
      draftPost = await _userService.createPostForCommunity(
          widget.uploadData.community,
          text: widget.uploadData.text);
    } else {
      draftPost = await _userService.createPost(
          text: widget.uploadData.text,
          circles: widget.uploadData.getCircles());
    }

    this._createdDraftPost = draftPost;
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
}

class OBCreatePostData {
  String text;
  List<File> media;
  Community community;
  List<Circle> circles;

  OBCreatePostData({this.text, this.media, this.community, this.circles});

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
  success,
  failed,
  cancelling,
  cancelled,
}
