import 'dart:io';

import 'package:Okuna/models/post.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:flutter/material.dart';

class OBPostUploader extends StatefulWidget {
  final OBPostUploaderUploadData uploadData;

  const OBPostUploader({Key key, @required this.uploadData}) : super(key: key);

  @override
  OBPostUploaderState createState() {
    return OBPostUploaderState();
  }
}

class OBPostUploaderState extends State<OBPostUploader> {
  ToastService _toastService;
  UserService _userService;
  LocalizationService _localizationService;

  bool _needsBootstrap;
  OBPostUploaderStatus _status;

  String _statusMessage;

  Post _createdDraftPost;
  List<File> _remainingMediaToUpload;
  List<File> _mediaToUpload;

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
      _toastService = openbookProvider.toastService;
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
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
            _localizationService.post_uploader__generic_upload_error);
        throw error;
      }
      _setStatus(OBPostUploaderStatus.failed);
    }
  }

  Future _createPost() async {
    Post draftPost =
        await _userService.createPost(text: widget.uploadData.text);
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
    return LinearProgressIndicator();
  }

  Widget _buildMediaPreview() {}

  Widget _buildStatusText() {}

  Widget _buildActionButtons() {}

  Widget _buildCancelButton() {}

  Widget _buildRetryButton() {}

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
      await _userService.deletePost(_createdDraftPost);
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

class OBPostUploaderUploadData {
  final String text;
  final List<File> media;

  OBPostUploaderUploadData({@required this.text, @required this.media});

  bool hasMedia() {
    return media != null && media.isNotEmpty;
  }

  List<File> getMedia() {
    return hasMedia() ? media.toList() : [];
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
