import 'dart:io';

import 'package:Okuna/models/circle.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/follows_list.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/models/post_comment_reaction.dart';
import 'package:Okuna/models/post_reaction.dart';
import 'package:Okuna/pages/home/bottom_sheets/community_actions.dart';
import 'package:Okuna/pages/home/bottom_sheets/community_type_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/confirm_open_url.dart';
import 'package:Okuna/pages/home/bottom_sheets/confirm_url_setting_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/connection_circles_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/image_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/link_previews_setting_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/post_comment_more_actions.dart';
import 'package:Okuna/pages/home/bottom_sheets/follows_lists_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/post_actions.dart';
import 'package:Okuna/pages/home/bottom_sheets/video_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/react_to_post.dart';
import 'package:Okuna/pages/home/bottom_sheets/react_to_post_comment.dart';
import 'package:Okuna/pages/home/bottom_sheets/videos_autoplay_setting_picker.dart';
import 'package:Okuna/pages/home/bottom_sheets/videos_sound_setting_picker.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:public_suffix/public_suffix.dart';

import 'media.dart';

class BottomSheetService {
  Future<PostReaction> showReactToPost(
      {@required Post post, @required BuildContext context}) async {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return Material(
            child: OBReactToPostBottomSheet(post),
          );
        });
  }

  Future<PostCommentReaction> showReactToPostComment(
      {@required PostComment postComment,
      @required Post post,
      @required BuildContext context}) async {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return Material(
            child: OBReactToPostCommentBottomSheet(
                postComment: postComment, post: post),
          );
        });
  }

  void showConnectionsCirclesPicker(
      {@required BuildContext context,
      @required String title,
      @required String actionLabel,
      @required OnPickedCircles onPickedCircles,
      List<Circle> initialPickedCircles}) {
    showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBConnectionCirclesPickerBottomSheet(
            initialPickedCircles: initialPickedCircles,
            title: title,
            actionLabel: actionLabel,
            onPickedCircles: onPickedCircles,
          );
        });
  }

  Future<void> showCommunityTypePicker(
      {@required BuildContext context,
      ValueChanged<CommunityType> onChanged,
      CommunityType initialType}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBCommunityTypePickerBottomSheet(
              onTypeChanged: onChanged, initialType: initialType);
        });
  }

  Future<void> showVideosSoundSettingPicker(
      {@required BuildContext context,
      ValueChanged<VideosSoundSetting> onChanged,
      VideosSoundSetting initialValue}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBVideosSoundSettingPickerBottomSheet(
              onTypeChanged: onChanged, initialValue: initialValue);
        });
  }

  Future<void> showVideosAutoPlaySettingPicker(
      {@required BuildContext context,
      ValueChanged<VideosAutoPlaySetting> onChanged,
      VideosAutoPlaySetting initialValue}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBVideosAutoPlaySettingPickerBottomSheet(
              onTypeChanged: onChanged, initialValue: initialValue);
        });
  }

  Future<void> showLinkPreviewsSettingPicker(
      {@required BuildContext context,
        ValueChanged<LinkPreviewsSetting> onChanged,
        LinkPreviewsSetting initialValue}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBLinkPreviewsSettingPickerBottomSheet(
              onTypeChanged: onChanged, initialValue: initialValue);
        });
  }

  Future<void> showConfirmUrlSettingPicker(
      {@required BuildContext context,
        ValueChanged<bool> onChanged,
        bool initialValue}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBConfirmUrlSettingPickerBottomSheet(
              onTypeChanged: onChanged, initialValue: initialValue);
        });
  }

  Future<List<FollowsList>> showFollowsListsPicker(
      {@required BuildContext context,
      @required String title,
      @required String actionLabel,
      List<FollowsList> initialPickedFollowsLists}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBFollowsListsPickerBottomSheet(
            initialPickedFollowsLists: initialPickedFollowsLists,
            title: title,
            actionLabel: actionLabel,
          );
        });
  }

  Future<void> showPostActions(
      {@required BuildContext context,
      @required Post post,
      @required OnPostDeleted onPostDeleted,
      @required ValueChanged<Post> onPostReported,
      bool isTopPost = false,
      Function onCommunityExcluded,
      Function onUndoCommunityExcluded,
      List<FollowsList> initialPickedFollowsLists}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBPostActionsBottomSheet(
            post: post,
            isTopPost: isTopPost,
            onCommunityExcluded: onCommunityExcluded,
            onUndoCommunityExcluded: onUndoCommunityExcluded,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
          );
        });
  }

  Future<void> showCommunityActions(
      {@required BuildContext context,
      @required Community community,
      OnCommunityReported onCommunityReported}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBCommunityActionsBottomSheet(
            community: community,
            onCommunityReported: onCommunityReported,
          );
        });
  }

  Future<void> showMoreCommentActions({
    @required BuildContext context,
    @required Post post,
    @required PostComment postComment,
    @required ValueChanged<PostComment> onPostCommentDeleted,
    @required ValueChanged<PostComment> onPostCommentReported,
  }) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBPostCommentMoreActionsBottomSheet(
              onPostCommentReported: onPostCommentReported,
              onPostCommentDeleted: onPostCommentDeleted,
              post: post,
              postComment: postComment);
        });
  }

  Future<File> showVideoPicker({@required BuildContext context}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBVideoPickerBottomSheet();
        });
  }

  Future<bool> showConfirmOpenUrl(
      {@required BuildContext context, @required PublicSuffix link}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBConfirmOpenUrlBottomSheet(
            urlInfo: link,
          );
        });
  }

  Future<File> showImagePicker({@required BuildContext context}) {
    return showModalBottomSheetApp(
        context: context,
        builder: (BuildContext context) {
          return OBImagePickerBottomSheet();
        });
  }
}

//Flutter Modal Bottom Sheet
//Modified by Suvadeep Das
//Based on https://gist.github.com/andrelsmoraes/9e4af0133bff8960c1feeb0ead7fd749

const Duration _kBottomSheetDuration = const Duration(milliseconds: 200);

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.bottomInset);

  final double progress;
  final double bottomInset;

  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Mega OPENBOOK HACK!
    return new Offset(
        0.0,
        size.height -
            bottomInset +
            (bottomInset > 50 ? 50 : 0) -
            childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        bottomInset != oldDelegate.bottomInset;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T> route;

  @override
  _ModalBottomSheetState<T> createState() => new _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: widget.route.dismissOnTap ? () => Navigator.pop(context) : null,
        child: new AnimatedBuilder(
            animation: widget.route.animation,
            builder: (BuildContext context, Widget child) {
              double bottomInset = widget.route.resizeToAvoidBottomPadding
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 0.0;
              return new ClipRect(
                  child: new CustomSingleChildLayout(
                      delegate: new _ModalBottomSheetLayout(
                          widget.route.animation.value, bottomInset),
                      child: new BottomSheet(
                          animationController:
                              widget.route._animationController,
                          onClosing: () => Navigator.pop(context),
                          builder: widget.route.builder)));
            }));
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
    this.resizeToAvoidBottomPadding,
    this.dismissOnTap,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final ThemeData theme;
  final bool resizeToAvoidBottomPadding;
  final bool dismissOnTap;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: new _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) bottomSheet = new Theme(data: theme, child: bottomSheet);
    return bottomSheet;
  }
}

/// Shows a modal material design bottom sheet.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the use from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// See also:
///
///  * [BottomSheet], which is the widget normally returned by the function
///    passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * <https://material.google.com/components/bottom-sheets.html#bottom-sheets-modal-bottom-sheets>
Future<T> showModalBottomSheetApp<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool dismissOnTap: false,
  bool resizeToAvoidBottomPadding: true,
}) {
  assert(context != null);
  assert(builder != null);
  return Navigator.push(
      context,
      new _ModalBottomSheetRoute<T>(
        builder: builder,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
        dismissOnTap: dismissOnTap,
      ));
}
