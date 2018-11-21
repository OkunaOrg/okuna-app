import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/post/widgets/expanded_post_comment.dart';
import 'package:Openbook/pages/home/pages/post/widgets/page_scaffold.dart';
import 'package:Openbook/pages/home/pages/post/widgets/post-commenter.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore_widget.dart';
import 'package:Openbook/services/httpie.dart';

class OBPostPage extends StatefulWidget {
  final Post post;
  final bool autofocusCommentInput;
  final OnWantsToReactToPost onWantsToReactToPost;

  OBPostPage(this.post,
      {this.autofocusCommentInput: false, this.onWantsToReactToPost});

  @override
  State<OBPostPage> createState() {
    return OBPostPageState();
  }
}

class OBPostPageState extends State<OBPostPage> {
  UserService _userService;
  ToastService _toastService;

  GlobalKey _postCommentsKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  ScrollController _postCommentsScrollController;
  List<PostComment> _postComments = [];
  bool _noMoreItemsToLoad;
  bool _needsBootstrap;
  FocusNode _commentInputFocusNode;

  @override
  void initState() {
    super.initState();
    _postCommentsScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
    _postComments = [];
    _noMoreItemsToLoad = true;
    _commentInputFocusNode = FocusNode();
    _postCommentsKey = new GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    child: GestureDetector(
                      onTap: _unfocusCommentInput,
                      child: LoadMore(
                          whenEmptyLoad: false,
                          isFinish: _noMoreItemsToLoad,
                          delegate: OBInfinitePostCommentsLoadMoreDelegate(),
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: _postCommentsScrollController,
                              padding: EdgeInsets.all(0),
                              itemCount: _postComments.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      OBPostHeader(widget.post),
                                      OBPostBody(widget.post),
                                      OBPostReactions(widget.post),
                                      OBPostActions(
                                        widget.post,
                                        onWantsToCommentPost: _onWantsToComment,
                                        onWantsToReactToPost:
                                            widget.onWantsToReactToPost,
                                      ),
                                      Divider(),
                                      Padding(
                                        key: _postCommentsKey,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        child: Text(
                                          _postComments.length > 0
                                              ? 'Latest comments'
                                              : 'Be the first to comment!',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black38),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                var postComment = _postComments[index];

                                var onPostCommentDeletedCallback = () {
                                  _removePostCommentAtIndex(index);
                                };

                                return OBExpandedPostComment(
                                  postComment: postComment,
                                  post: widget.post,
                                  onPostCommentDeletedCallback:
                                      onPostCommentDeletedCallback,
                                );
                              }),
                          onLoadMore: _loadMoreComments),
                    ),
                    onRefresh: _refreshComments),
              ),
              OBPostCommenter(
                widget.post,
                autofocus: widget.autofocusCommentInput,
                commentTextFieldFocusNode: _commentInputFocusNode,
                onPostCommentCreated: _onPostCommentCreated,
              )
            ],
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Post'),
    );
  }

  void _bootstrap() async {
    await _refreshComments();
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollToComments();
    });
  }

  Future<void> _refreshComments() async {
    try {
      _postComments =
          (await _userService.getCommentsForPost(widget.post)).comments;
      _setPostComments(_postComments);
      _scrollToTop();
      _setNoMoreItemsToLoad(false);
    } on HttpieConnectionRefusedError catch (error) {
      _onConnectionRefusedError(error);
    } catch (error) {
      _onUnknownError(error);
      rethrow;
    }
  }

  Future<bool> _loadMoreComments() async {
    if (_postComments.length == 0) return true;

    var lastPost = _postComments.last;
    var lastPostId = lastPost.id;

    try {
      var moreComments = (await _userService.getCommentsForPost(widget.post,
              maxId: lastPostId))
          .comments;

      if (moreComments.length == 0) {
        _setNoMoreItemsToLoad(true);
      } else {
        _addPostComments(moreComments);
      }
      return true;
    } on HttpieConnectionRefusedError catch (error) {
      _onConnectionRefusedError(error);
    } catch (error) {
      _onUnknownError(error);
      rethrow;
    }

    return false;
  }

  void _removePostCommentAtIndex(int index) {
    setState(() {
      _postComments.removeAt(index);
    });
  }

  void _onPostCommentCreated(PostComment createdPostComment) {
    _unfocusCommentInput();
    setState(() {
      this._postComments.insert(0, createdPostComment);
    });
  }

  void _scrollToTop() {
    _postCommentsScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _scrollToComments() {
    Scrollable.ensureVisible(_postCommentsKey.currentContext,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 400));
  }

  void _onWantsToComment(Post post) {
    _focusCommentInput();
  }

  void _focusCommentInput() {
    FocusScope.of(context).requestFocus(_commentInputFocusNode);
  }

  void _unfocusCommentInput() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void _addPostComments(List<PostComment> postComments) {
    setState(() {
      this._postComments.addAll(postComments);
    });
  }

  void _setPostComments(List<PostComment> postComments) {
    setState(() {
      this._postComments = postComments;
    });
  }

  void _setNoMoreItemsToLoad(bool noMoreItemsToLoad) {
    setState(() {
      _noMoreItemsToLoad = noMoreItemsToLoad;
    });
  }

  void _onConnectionRefusedError(HttpieConnectionRefusedError error) {
    _toastService.error(message: 'No internet connection', context: context);
  }

  void _onUnknownError(Error error) {
    _toastService.error(message: 'Unknown error', context: context);
  }
}

class OBInfinitePostCommentsLoadMoreDelegate extends LoadMoreDelegate {
  const OBInfinitePostCommentsLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english}) {
    String text = builder(status);

    if (status == LoadMoreStatus.fail) {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.refresh),
            SizedBox(
              width: 10.0,
            ),
            Text('Tap to retry loading comments.')
          ],
        ),
      );
    }
    if (status == LoadMoreStatus.idle) {
      // No clue why is this even a state.
      return SizedBox();
    }
    if (status == LoadMoreStatus.loading) {
      return Container(
          child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 20.0,
            maxWidth: 20.0,
          ),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      ));
    }
    if (status == LoadMoreStatus.nomore) {
      return SizedBox();
    }

    return Text(text);
  }
}
