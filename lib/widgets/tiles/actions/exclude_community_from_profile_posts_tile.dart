import 'package:Okuna/models/post.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class OBExcludeCommunityFromProfilePostsTile extends StatefulWidget {
  final Post post;
  final ValueChanged<Post> onPostCommunityExcludedFromProfilePosts;
  final ValueChanged<Post> onPostCommunityUnexcludedFromProfilePosts;

  const OBExcludeCommunityFromProfilePostsTile({
    Key key,
    @required this.post,
    this.onPostCommunityExcludedFromProfilePosts,
    this.onPostCommunityUnexcludedFromProfilePosts,
  }) : super(key: key);

  @override
  OBExcludeCommunityFromProfilePostsTileState createState() {
    return OBExcludeCommunityFromProfilePostsTileState();
  }
}

class OBExcludeCommunityFromProfilePostsTileState
    extends State<OBExcludeCommunityFromProfilePostsTile> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  BottomSheetService _bottomSheetService;
  CancelableOperation _excludeCommunityOperation;
  CancelableOperation _undoExcludeCommunityOperation;

  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    return StreamBuilder(
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;

        bool isExcluded = post.isExcludedFromProfilePosts;

        return OBLoadingTile(
          isLoading: _requestInProgress,
          leading: OBIcon(isExcluded
              ? OBIcons.undoExcludePostCommunity
              : OBIcons.excludePostCommunity),
          title: OBText(isExcluded
              ? _localizationService
                  .post__undo_exclude_community_from_profile_posts
              : _localizationService
                  .post__exclude_community_from_profile_posts),
          onTap: isExcluded ? _undoExcludePostCommunity : _excludePostCommunity,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_excludeCommunityOperation != null) _excludeCommunityOperation.cancel();
    if (_undoExcludeCommunityOperation != null)
      _undoExcludeCommunityOperation.cancel();
  }

  void _excludePostCommunity() async {
    if (_excludeCommunityOperation != null) return;
    _setRequestInProgress(true);
    try {
      _excludeCommunityOperation = CancelableOperation.fromFuture(
          _userService.excludeCommunityFromProfilePosts(widget.post.community));
      await _excludeCommunityOperation.value;
      widget.post.updateIsExcludedFromProfilePosts(true);
      if (widget.onPostCommunityExcludedFromProfilePosts != null)
        widget.onPostCommunityExcludedFromProfilePosts(widget.post);
      _bottomSheetService.dismissActiveBottomSheet(context: context);
      _toastService.success(message: _localizationService
          .post__undo_exclude_community_from_profile_posts, context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _excludeCommunityOperation = null;
      _setRequestInProgress(false);
    }
  }

  void _undoExcludePostCommunity() async {
    if (_undoExcludeCommunityOperation != null) return;
    _setRequestInProgress(true);
    try {
      _undoExcludeCommunityOperation = CancelableOperation.fromFuture(
          _userService
              .undoExcludeCommunityFromProfilePosts(widget.post.community));
      String message = await _undoExcludeCommunityOperation.value;
      if (widget.onPostCommunityUnexcludedFromProfilePosts != null)
        widget.onPostCommunityUnexcludedFromProfilePosts(widget.post);
      _toastService.success(message: message, context: context);
      widget.post.updateIsExcludedFromProfilePosts(false);
    } catch (e) {
      _onError(e);
    } finally {
      _undoExcludeCommunityOperation = null;
      _setRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
