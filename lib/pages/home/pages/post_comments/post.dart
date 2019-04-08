import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post-commenter.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/user_preferences.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/widgets/load_more.dart';
import 'package:Openbook/services/httpie.dart';

class OBPostCommentsPage extends StatefulWidget {
  final Post post;
  final bool autofocusCommentInput;

  OBPostCommentsPage(
    this.post, {
    this.autofocusCommentInput: false,
  });

  @override
  State<OBPostCommentsPage> createState() {
    return OBPostCommentsPageState();
  }
}

class OBPostCommentsPageState extends State<OBPostCommentsPage> {
  UserService _userService;
  ToastService _toastService;
  ThemeService _themeService;
  UserPreferencesService _userPreferencesService;
  ThemeValueParserService _themeValueParserService;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  ScrollController _postCommentsScrollController;
  List<PostComment> _postComments = [];
  bool _noMoreItemsToLoad;
  bool _needsBootstrap;
  FocusNode _commentInputFocusNode;
  PostCommentsSortType _currentSort;

  CancelableOperation _refreshCommentsOperation;
  CancelableOperation _refreshPostOperation;
  CancelableOperation _loadMoreBottomCommentsOperation;
  CancelableOperation _toggleSortCommentsOperation;

  @override
  void initState() {
    super.initState();
    _postCommentsScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
    _postComments = [];
    _currentSort = PostCommentsSortType.dec;
    _noMoreItemsToLoad = true;
    _commentInputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    if (_refreshCommentsOperation != null) _refreshCommentsOperation.cancel();
    if (_loadMoreBottomCommentsOperation != null)
      _loadMoreBottomCommentsOperation.cancel();
    if (_refreshPostOperation != null) _refreshPostOperation.cancel();
    if (_toggleSortCommentsOperation != null)
      _toggleSortCommentsOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _toastService = provider.toastService;
      _themeValueParserService = provider.themeValueParserService;
      _themeService = provider.themeService;
      _userPreferencesService = provider.userPreferencesService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'Post comments',
        ),
        child: OBPrimaryColorContainer(
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
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _postCommentsScrollController,
                              padding: EdgeInsets.all(0),
                              itemCount: _postComments.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _buildCommentsHeader(),
                                    ],
                                  );
                                }

                                int commentIndex = index - 1;

                                var postComment = _postComments[commentIndex];

                                var onPostCommentDeletedCallback = () {
                                  _removePostCommentAtIndex(commentIndex);
                                };

                                return OBPostComment(
                                    key: Key('postComment#${postComment.id}'),
                                    postComment: postComment,
                                    post: widget.post,
                                    onPostCommentDeletedCallback:
                                        onPostCommentDeletedCallback);
                              }),
                          onLoadMore: _loadMoreBottomComments),
                    ),
                    onRefresh: _refreshComments),
              ),
              OBPostCommenter(
                widget.post,
                autofocus: widget.autofocusCommentInput,
                commentTextFieldFocusNode: _commentInputFocusNode,
                onPostCommentCreated: _onPostCommentCreated,
                onPostCommentWillBeCreated: _onPostCommentWillBeCreated,
              )
            ],
          ),
        ));
  }

  void _bootstrap() async {
    await _setPostCommentsSortTypeFromPreferences();
    await _refreshPost();
    await _refreshComments();
  }

  Future _setPostCommentsSortTypeFromPreferences() async {
    PostCommentsSortType sortType =
        await _userPreferencesService.getPostCommentsSortType();
    _currentSort = sortType;
  }

  Widget _buildCommentsHeader() {
    var theme = _themeService.getActiveTheme();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: OBSecondaryText(
              _postComments.length > 0
                  ? _currentSort == PostCommentsSortType.dec
                      ? 'Newest comments'
                      : 'Oldest comments'
                  : 'Be the first to comment!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          FlatButton(
              child: Row(
                children: <Widget>[
                  OBText(
                    _postComments.length > 0
                        ? _currentSort == PostCommentsSortType.dec
                            ? 'See oldest comments'
                            : 'See newest comments'
                        : '',
                    style: TextStyle(
                        color: _themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onPressed: _onWantsToToggleSortComments),
        ],
      ),
    );
  }

  void _onWantsToToggleSortComments() async {
    if (_toggleSortCommentsOperation != null)
      _toggleSortCommentsOperation.cancel();
    PostCommentsSortType newSortType;

    if (_currentSort == PostCommentsSortType.asc) {
      newSortType = PostCommentsSortType.dec;
    } else {
      newSortType = PostCommentsSortType.asc;
    }

    try {
      _toggleSortCommentsOperation = CancelableOperation.fromFuture(
          _userService.getCommentsForPost(widget.post, sort: newSortType));

      _postComments = (await _toggleSortCommentsOperation.value).comments;
      _setCurrentSortValue(newSortType);
      _userPreferencesService.setPostCommentsSortType(newSortType);
      _setPostComments(_postComments);
      _scrollToTop();
      _setNoMoreItemsToLoad(false);
    } catch (error) {
      _onError(error);
    } finally {
      _toggleSortCommentsOperation = null;
    }
  }

  Future<void> _refreshComments() async {
    if (_refreshCommentsOperation != null) _refreshCommentsOperation.cancel();
    try {
      _refreshCommentsOperation = CancelableOperation.fromFuture(
          _userService.getCommentsForPost(widget.post, sort: _currentSort));
      _postComments = (await _refreshCommentsOperation.value).comments;
      _setPostComments(_postComments);
      _scrollToTop();
      _setNoMoreItemsToLoad(false);
    } catch (error) {
      _onError(error);
    } finally {
      _refreshCommentsOperation = null;
    }
  }

  Future<void> _refreshPost() async {
    if (_refreshPostOperation != null) _refreshPostOperation.cancel();
    try {
      // This will trigger the updateSubject of the post
      _refreshPostOperation = CancelableOperation.fromFuture(
          _userService.getPostWithUuid(widget.post.uuid));
      await _refreshPostOperation.value;
    } catch (error) {
      _onError(error);
    } finally {
      _refreshPostOperation = null;
    }
  }

  Future<bool> _loadMoreBottomComments() async {
    if (_loadMoreBottomCommentsOperation != null)
      _loadMoreBottomCommentsOperation.cancel();
    if (_postComments.length == 0) return true;

    var lastPost = _postComments.last;
    var lastPostId = lastPost.id;

    try {
      var moreComments;

      if (_currentSort == PostCommentsSortType.dec) {
        _loadMoreBottomCommentsOperation = CancelableOperation.fromFuture(
            _userService.getCommentsForPost(widget.post, maxId: lastPostId));
      } else {
        _loadMoreBottomCommentsOperation = CancelableOperation.fromFuture(
            _userService.getCommentsForPost(widget.post,
                minId: lastPostId + 1, sort: _currentSort));
      }

      moreComments = (await _loadMoreBottomCommentsOperation.value).comments;

      if (moreComments.length == 0) {
        _setNoMoreItemsToLoad(true);
      } else {
        _addPostComments(moreComments);
      }
      return true;
    } catch (error) {
      _onError(error);
    } finally {
      _loadMoreBottomCommentsOperation = null;
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

  Future _onPostCommentWillBeCreated() {
    _setCurrentSortValue(PostCommentsSortType.dec);
    return _refreshComments();
  }

  void _setCurrentSortValue(PostCommentsSortType newSortType) {
    setState(() {
      _currentSort = newSortType;
    });
  }

  void _scrollToTop() {
    _postCommentsScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
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

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}

class OBInfinitePostCommentsLoadMoreDelegate extends LoadMoreDelegate {
  const OBInfinitePostCommentsLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status, {LoadMoreTextBuilder builder}) {
    String text = builder(status);

    if (status == LoadMoreStatus.fail) {
      return SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.refresh),
            const SizedBox(
              width: 10.0,
            ),
            Text('Tap to retry loading comments.')
          ],
        ),
      );
    }
    if (status == LoadMoreStatus.idle) {
      // No clue why is this even a state.
      return const SizedBox();
    }
    if (status == LoadMoreStatus.loading) {
      return SizedBox(
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
      return const SizedBox();
    }

    return Text(text);
  }
}
