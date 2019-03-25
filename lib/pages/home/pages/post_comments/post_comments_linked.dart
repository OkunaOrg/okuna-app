import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post-commenter.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:Openbook/widgets/theming/post_divider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:Openbook/services/httpie.dart';

class OBPostCommentsLinkedPage extends StatefulWidget {
  final PostComment postComment;
  final bool autofocusCommentInput;

  OBPostCommentsLinkedPage(
    this.postComment, {
    this.autofocusCommentInput: false,
  });

  @override
  State<OBPostCommentsLinkedPage> createState() {
    return OBPostCommentsLinkedPageState();
  }

}

class OBPostCommentsLinkedPageState extends State<OBPostCommentsLinkedPage> with SingleTickerProviderStateMixin {
  UserService _userService;
  ToastService _toastService;
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;
  Post _post;
  AnimationController _animationController;
  Animation<double> _animation;

  GlobalKey _postCommentsKey;
  ScrollController _postCommentsScrollController;
  List<PostComment> _postComments = [];
  bool _noMoreItemsToLoad;
  bool _noMoreEarlierItemsToLoad;
  bool _needsBootstrap;
  bool _shouldHideStackedLoadingScreen;
  String _currentSort;
  FocusNode _commentInputFocusNode;
  static const LOAD_MORE_COMMENTS_COUNT = 5;
  static const COUNT_MIN_INCLUDING_LINKED_COMMENT = 2;
  static const COUNT_MAX_AFTER_LINKED_COMMENT = 3;
  static const TOTAL_COMMENTS_IN_SLICE = COUNT_MIN_INCLUDING_LINKED_COMMENT
      + COUNT_MAX_AFTER_LINKED_COMMENT;
  static const SORT_ASCENDING = 'ASC';
  static const SORT_DESCENDING = 'DESC';

  @override
  void initState() {
    super.initState();
    _post = widget.postComment.post;
    _needsBootstrap = true;
    _postComments = [];
    _noMoreItemsToLoad = true;
    _currentSort = SORT_DESCENDING;
    _noMoreEarlierItemsToLoad = false;
    _shouldHideStackedLoadingScreen = false;
    _commentInputFocusNode = FocusNode();
    _postCommentsKey = new GlobalKey();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = new Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _shouldHideStackedLoadingScreen = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;
    _themeValueParserService = provider.themeValueParserService;
    _themeService = provider.themeService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'Post comments',
        ),
        child: OBPrimaryColorContainer(
          child: Stack(
            children: _getStackChildren(),
          ),
        ));
  }

  void _bootstrap() async {
    await _refreshPost();
    await _refreshCommentsSlice();
  }

  List <Widget> _getStackChildren() {
    var theme = _themeService.getActiveTheme();
    var primaryColor =
    _themeValueParserService.parseColor(theme.primaryColor);

    List<Widget> _stackChildren = [];

    if (_shouldHideStackedLoadingScreen) {
      _stackChildren.add( Column(
        children: _getColumnChildren(),
      ));
    } else {
      _stackChildren.addAll([
        Column(
          children: _getColumnChildren(),
        ),
        Positioned(
            top: 0.0,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                color: primaryColor,
                height: _post.getImageHeight(),
                width: _post.getImageWidth(),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            )
        )
      ]);
    }

    return _stackChildren;
  }

  List<Widget> _getColumnChildren() {
    List<Widget> _columnChildren = [];
    _postCommentsScrollController = ScrollController(initialScrollOffset: _post.getImageHeight() + 200.0);
    _columnChildren.addAll([
      Expanded(
        child: LoadMore(
            whenEmptyLoad: false,
            isFinish: _noMoreItemsToLoad,
            delegate: OBInfinitePostCommentsLoadMoreDelegate(),
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                controller: _postCommentsScrollController,
                padding: EdgeInsets.all(0),
                itemCount: _postComments.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _getPostPreview();
                  } else {
                    return _getCommentTile(index);
                  }
                }),
            onLoadMore: _loadMoreComments),
      ),
      OBPostCommenter(
        _post,
        autofocus: widget.autofocusCommentInput,
        commentTextFieldFocusNode: _commentInputFocusNode,
        onPostCommentCreated: _onPostCommentCreated,
      )
    ]);

    return _columnChildren;

  }

  Widget _getCommentTile(int index) {
    int commentIndex = index - 1;
    var postComment = _postComments[commentIndex];
    var onPostCommentDeletedCallback = () {
      _removePostCommentAtIndex(commentIndex);
    };

    if (postComment.id == widget.postComment.id) {
      var theme = _themeService.getActiveTheme();
      var primaryColor =
      _themeValueParserService.parseColor(theme.primaryColor);
      final bool isDarkPrimaryColor =
          primaryColor.computeLuminance() < 0.179;

      return DecoratedBox(
        decoration: BoxDecoration(
          color: isDarkPrimaryColor
              ? Color.fromARGB(20, 255, 255, 255)
              : Color.fromARGB(10, 0, 0, 0),
        ),
        child: OBExpandedPostComment(
          postComment: postComment,
          post: _post,
          onPostCommentDeletedCallback:
          onPostCommentDeletedCallback,
        ),
      );
    } else {
      if (index == TOTAL_COMMENTS_IN_SLICE) {
        Future.delayed(Duration(milliseconds: 0), () {
          _animationController.forward();
        });
      }
      return OBExpandedPostComment(
        postComment: postComment,
        post: _post,
        onPostCommentDeletedCallback:
        onPostCommentDeletedCallback,
      );
    }
  }

  Widget _getPostPreview() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBPostHeader(
            post: _post,
            onPostDeleted: _onPostDeleted,
          ),
          OBPostBody(_post),
          OBPostReactions(_post),
          OBPostCircles(_post),
          OBPostActions(
            _post,
            onWantsToCommentPost: _focusCommentInput,
          ),
          const SizedBox(
            height: 16,
          ),
          OBPostDivider(),
          _buildLoadEarlierCommentsBar(),
        ],
      );
  }

  Future<void> _refreshCommentsSlice() async {
    try {
      _postComments =
          (await _userService.getCommentsForPost(
              _post,
              minId: widget.postComment.id,
              maxId: widget.postComment.id,
              countMax: COUNT_MAX_AFTER_LINKED_COMMENT,
              countMin: COUNT_MIN_INCLUDING_LINKED_COMMENT))
              .comments;
      _setPostComments(_postComments);
      _setNoMoreItemsToLoad(false);
    } catch (error) {
      _onError(error);
    }
  }

  Future<void> _refreshPost() async {
    try {
      // This will trigger the updateSubject of the post
      await _userService.getPostWithUuid(_post.uuid);
    } catch (error) {
      _onError(error);
    }
  }

  Future<bool> _loadMoreComments() async {
    print('calling load more');
    if (_postComments.length == 0) return true;

    var lastPost = _postComments.last;
    var lastPostId = lastPost.id;
    var moreComments;
    try {
      if (_currentSort == SORT_DESCENDING) {
        moreComments = (await _userService.getCommentsForPost(_post,
            countMax: LOAD_MORE_COMMENTS_COUNT,
            maxId: lastPostId,
            sort: _currentSort))
            .comments;
      } else {
        moreComments = (await _userService.getCommentsForPost(_post,
            countMin: LOAD_MORE_COMMENTS_COUNT,
            minId: lastPostId + 1,
            sort: _currentSort))
            .comments;
      }

      if (moreComments.length == 0) {
        _setNoMoreItemsToLoad(true);
      } else {
        _addPostComments(moreComments);
      }
      return true;
    } catch (error) {
      _onError(error);
    }

    return false;
  }

  Future<bool> _loadEarlierComments() async {
    if (_postComments.length == 0) return true;

    var firstPost = _postComments.first;
    var firstPostId = firstPost.id;

    try {
      var moreComments = (await _userService.getCommentsForPost(_post,
          countMax: 1, minId: firstPostId+1))
          .comments;

      if (moreComments.length == 0) {
        _setNoMoreEarlierItemsToLoad(true);
      } else {
        _addToStartPostComments(moreComments);
      }
      return true;
    } catch (error) {
      _onError(error);
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

  void _onPostDeleted(Post post) {
    Navigator.of(context).pop();
  }

  void _onWantsToLoadEarlierComments() async {
    await _loadEarlierComments();
  }

  void _onWantsToLoadLatestComments() async {
    try {
      _postComments =
      (await _userService.getCommentsForPost(
      _post)).comments;
      _setPostComments(_postComments);
      _setNoMoreItemsToLoad(false);
      _setNoMoreEarlierItemsToLoad(true);
    } catch (error) {
      _onError(error);
    }
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

  void _addToStartPostComments(List<PostComment> postComments) {
    postComments.reversed.forEach((comment) {
      setState(() {
        this._postComments.insert(0, comment);
      });
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

  void _setNoMoreEarlierItemsToLoad(bool noMoreItemsToLoad) {
    setState(() {
      _noMoreEarlierItemsToLoad = noMoreItemsToLoad;
    });
  }

  void _setCurrentSortValue(String newSortValue) {
    setState(() {
      _currentSort = newSortValue;
    });
  }

  void _onWantsToToggleSortComments() async {
    var newSortValue = SORT_ASCENDING;
    if (_currentSort == SORT_ASCENDING) {
      newSortValue = SORT_DESCENDING;
    }
    try {
      _postComments =
          (await _userService.getCommentsForPost(_post, sort: newSortValue)).comments;
      _setCurrentSortValue(newSortValue);
      _setPostComments(_postComments);
      _setNoMoreItemsToLoad(false);
    } catch (error) {
      _onError(error);
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
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  Widget _buildLoadEarlierCommentsBar() {
    var theme = _themeService.getActiveTheme();

    if (_noMoreEarlierItemsToLoad) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: OBSecondaryText(
                _postComments.length > 0
                    ? _currentSort == SORT_DESCENDING ? 'Latest comments' : 'Oldest comments'
                    : 'Be the first to comment!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
            FlatButton(
                child: Row(
                  children: <Widget>[
                    OBText(_currentSort == SORT_DESCENDING ? 'See oldest comments' : 'See latest comments',
                      style: TextStyle(
                          color: _themeValueParserService
                              .parseGradient(theme.primaryAccentColor)
                              .colors[1],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                onPressed: _onWantsToToggleSortComments
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                child: Row(
                  children: <Widget>[
                    OBIcon(OBIcons.arrowUp),
                    const SizedBox(width: 10.0),
                    OBText('Earlier',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: _onWantsToLoadEarlierComments
            ),
            FlatButton(
                child: Row(
                  children: <Widget>[
                    OBText('View latest comments',
                      style: TextStyle(
                          color: _themeValueParserService
                              .parseGradient(theme.primaryAccentColor)
                              .colors[1],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                onPressed: _onWantsToLoadLatestComments
            ),
          ],
        ),
      );
    }
  }
}


class OBInfinitePostCommentsLoadMoreDelegate extends LoadMoreDelegate {
  const OBInfinitePostCommentsLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english}) {
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
