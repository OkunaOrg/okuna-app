import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Openbook/services/httpie.dart';

class OBExpandedPostComment extends StatefulWidget {
  final PostComment postComment;
  final Post post;
  final VoidCallback onPostCommentDeletedCallback;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  OBExpandedPostComment(
      {@required this.post,
      @required this.postComment,
      Key key,
      this.onPostCommentDeletedCallback,
      @required this.onWantsToSeeUserProfile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBExpandedPostCommentState();
  }
}

class OBExpandedPostCommentState extends State<OBExpandedPostComment> {
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;
  TapGestureRecognizer _usernameTapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _usernameTapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    _usernameTapGestureRecognizer.onTap = () {
      widget.onWantsToSeeUserProfile(widget.post.creator);
    };

    User loggedInUser = _userService.getLoggedInUser();

    Widget postTile = _buildPostTile();

    if (_requestInProgress) {
      postTile = Opacity(
        opacity: 0.5,
        child: postTile,
      );
    }

    if (widget.postComment.getCommenterId() == loggedInUser.id) {
      // Its our own comment
      postTile = Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: postTile,
        secondaryActions: <Widget>[
          new IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: _deletePostComment,
          ),
        ],
      );
    }

    return postTile;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameTapGestureRecognizer.dispose();
  }

  Widget _buildPostTile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBUserAvatar(
            onPressed: () {
              widget.onWantsToSeeUserProfile(widget.post.creator);
            },
            size: OBUserAvatarSize.medium,
            avatarUrl: widget.postComment.getCommenterProfileAvatar(),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                  maxLines: null,
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.postComment.getCommenterUsername(),
                        recognizer: _usernameTapGestureRecognizer,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    TextSpan(text: '  '),
                    TextSpan(
                        text: widget.postComment.text,
                        style: TextStyle(color: Colors.black87))
                  ])),
              SizedBox(
                height: 5.0,
              ),
              Text(
                widget.postComment.getRelativeCreated(),
                style: TextStyle(fontSize: 12.0),
              )
            ],
          ))
        ],
      ),
    );
  }

  void _deletePostComment() async {
    _setRequestInProgress(true);
    try {
      await _userService.deletePostComment(
          postComment: widget.postComment, post: widget.post);
      _setRequestInProgress(false);
      if (widget.onPostCommentDeletedCallback != null) {
        widget.onPostCommentDeletedCallback();
      }
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
      _setRequestInProgress(false);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      _setRequestInProgress(false);
      rethrow;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}

typedef void OnWantsToSeeUserProfile(User user);
