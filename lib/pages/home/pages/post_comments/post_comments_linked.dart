import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post-commenter.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/user_preferences.dart';
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
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/widgets/load_more.dart';
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

class OBPostCommentsLinkedPageState extends State<OBPostCommentsLinkedPage>
    with SingleTickerProviderStateMixin {
  UserService _userService;
  UserPreferencesService _userPreferencesService;
  ToastService _toastService;
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;
  Post _post;
  AnimationController _animationController;
  Animation<double> _animation;

  GlobalKey _keyPostBody = GlobalKey();
  double _positionTopCommentSection;
  ScrollController _postCommentsScrollController;
  List<PostComment> _postComments = [];
  bool _noMoreBottomItemsToLoad;
  bool _noMoreTopItemsToLoad;
  bool _needsBootstrap;
  bool _shouldHideStackedLoadingScreen;
  bool _startScrollWasInitialised;
  PostCommentsSortType _currentSort;
  FocusNode _commentInputFocusNode;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  static const OFFSET_TOP_HEADER = 64.0;
  static const HEIGHT_POST_HEADER = 72.0;
  static const HEIGHT_POST_REACTIONS = 35.0;
  static const HEIGHT_POST_CIRCLES = 26.0;
  static const HEIGHT_POST_ACTIONS = 46.0;
  static const TOTAL_PADDING_POST_TEXT = 40.0;
  static const HEIGHT_POST_DIVIDER = 5.5;
  static const HEIGHT_SIZED_BOX = 16.0;
  static const TOTAL_FIXED_OFFSET_Y = OFFSET_TOP_HEADER +
      HEIGHT_POST_HEADER +
      HEIGHT_POST_REACTIONS +
      HEIGHT_POST_CIRCLES +
      HEIGHT_POST_ACTIONS +
      HEIGHT_SIZED_BOX +
      HEIGHT_POST_DIVIDER;
  static const LOAD_MORE_COMMENTS_COUNT = 5;
  static const COUNT_MIN_INCLUDING_LINKED_COMMENT = 3;
  static const COUNT_MAX_AFTER_LINKED_COMMENT = 2;
  static const TOTAL_COMMENTS_IN_SLICE =
      COUNT_MIN_INCLUDING_LINKED_COMMENT + COUNT_MAX_AFTER_LINKED_COMMENT;

  CancelableOperation _refreshCommentsOperation;
  CancelableOperation _refreshCommentsSliceOperation;
  CancelableOperation _refreshCommentsWithCreatedPostCommentVisibleOperation;
  CancelableOperation _refreshPostOperation;
  CancelableOperation _loadMoreBottomCommentsOperation;
  CancelableOperation _loadMoreTopCommentsOperation;
  CancelableOperation _toggleSortCommentsOperation;

  @override
  void initState() {
    super.initState();
    _post = widget.postComment.post;
    _needsBootstrap = true;
    _postComments = [];
    _noMoreBottomItemsToLoad = true;
    _currentSort = PostCommentsSortType.dec;
    _noMoreTopItemsToLoad = false;
    _startScrollWasInitialised = false;
    _shouldHideStackedLoadingScreen = false;
    _commentInputFocusNode = FocusNode();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = new Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _animation.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _userPreferencesService = provider.userPreferencesService;
      _toastService = provider.toastService;
      _themeValueParserService = provider.themeValueParserService;
      _themeService = provider.themeService;
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
    await _setPostCommentsSortTypeFromPreferences();
    await _refreshPost();
    await _refreshCommentsSlice();
  }

  Future _setPostCommentsSortTypeFromPreferences() async {
    PostCommentsSortType sortType =
        await _userPreferencesService.getPostCommentsSortType();
    _currentSort = sortType;
  }

  void dispose() {
    super.dispose();
    _animation.removeStatusListener(_onAnimationStatusChanged);
    if (_refreshCommentsOperation != null) _refreshCommentsOperation.cancel();
    if (_refreshCommentsSliceOperation != null)
      _refreshCommentsSliceOperation.cancel();
    if (_loadMoreBottomCommentsOperation != null)
      _loadMoreBottomCommentsOperation.cancel();
    if (_refreshPostOperation != null) _refreshPostOperation.cancel();
    if (_toggleSortCommentsOperation != null)
      _toggleSortCommentsOperation.cancel();
    if (_loadMoreTopCommentsOperation != null)
      _loadMoreTopCommentsOperation.cancel();
    if (_refreshCommentsWithCreatedPostCommentVisibleOperation != null)
      _refreshCommentsWithCreatedPostCommentVisibleOperation.cancel();
  }

  void _onAnimationStatusChanged(status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _shouldHideStackedLoadingScreen = true;
      });
    }
  }

  List<Widget> _getStackChildren() {
    var theme = _themeService.getActiveTheme();
    var primaryColor = _themeValueParserService.parseColor(theme.primaryColor);

    List<Widget> _stackChildren = [];

    if (_shouldHideStackedLoadingScreen) {
      _stackChildren.add(Column(
        children: _getColumnChildren(),
      ));
    } else {
      _stackChildren.addAll([
        Column(
          children: _getColumnChildren(),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0,
          child: IgnorePointer(
              ignoring: true,
              child: FadeTransition(
                opacity: _animation,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: primaryColor),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
              )),
        )
      ]);
    }

    return _stackChildren;
  }

  List<Widget> _getColumnChildren() {
    List<Widget> _columnChildren = [];
    _postCommentsScrollController = ScrollController(
        initialScrollOffset: _calculatePositionTopCommentSection());
    _columnChildren.addAll([
      Expanded(
        child: RefreshIndicator(
            child: GestureDetector(
              key: _refreshIndicatorKey,
              onTap: _unfocusCommentInput,
              child: LoadMore(
                  whenEmptyLoad: false,
                  isFinish: _noMoreBottomItemsToLoad,
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
                  onLoadMore: _loadMoreBottomComments),
            ),
            onRefresh: _onWantsToRefreshComments),
      ),
      OBPostCommenter(
        _post,
        autofocus: widget.autofocusCommentInput,
        commentTextFieldFocusNode: _commentInputFocusNode,
        onPostCommentCreated: _refreshCommentsWithCreatedPostCommentVisible,
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

    if (_animationController.status != AnimationStatus.completed &&
        !_startScrollWasInitialised) {
      Future.delayed(Duration(milliseconds: 0), () {
        _postCommentsScrollController.animateTo(
            _positionTopCommentSection - 100.0,
            duration: Duration(milliseconds: 5),
            curve: Curves.easeIn);
      });
    }

    if (commentIndex == 0) {
      _animationController.forward();
      Future.delayed(Duration(milliseconds: 0), () {
        if (!_startScrollWasInitialised) {
          setState(() {
            _startScrollWasInitialised = true;
          });
        }
      });
    }

    if (postComment.id == widget.postComment.id) {
      var theme = _themeService.getActiveTheme();
      var primaryColor =
          _themeValueParserService.parseColor(theme.primaryColor);
      final bool isDarkPrimaryColor = primaryColor.computeLuminance() < 0.179;
      return DecoratedBox(
        decoration: BoxDecoration(
          color: isDarkPrimaryColor
              ? Color.fromARGB(20, 255, 255, 255)
              : Color.fromARGB(10, 0, 0, 0),
        ),
        child: OBPostComment(
          key: Key('postComment#${postComment.id}'),
          postComment: postComment,
          post: _post,
          onPostCommentDeletedCallback: onPostCommentDeletedCallback,
        ),
      );
    } else {
      return OBPostComment(
        key: Key('postComment#${postComment.id}'),
        postComment: postComment,
        post: _post,
        onPostCommentDeletedCallback: onPostCommentDeletedCallback,
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
        Container(
          key: _keyPostBody,
          child: OBPostBody(_post),
        ),
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
        _buildLoadTopCommentsBar(),
      ],
    );
  }

  Future<void> _refreshCommentsSlice() async {
    if (_refreshCommentsSliceOperation != null)
      _refreshCommentsSliceOperation.cancel();
    try {
      _refreshCommentsSliceOperation = CancelableOperation.fromFuture(
          _userService.getCommentsForPost(_post,
              minId: widget.postComment.id,
              maxId: widget.postComment.id,
              countMax: COUNT_MAX_AFTER_LINKED_COMMENT,
              countMin: COUNT_MIN_INCLUDING_LINKED_COMMENT,
              sort: _currentSort));

      _postComments = (await _refreshCommentsSliceOperation.value).comments;
      _setPostComments(_postComments);
      _checkIfMoreTopItemsToLoad();
      _setNoMoreBottomItemsToLoad(false);
    } catch (error) {
      _onError(error);
    } finally {
      _refreshCommentsSliceOperation = null;
    }
  }

  void _setPositionTopCommentSection() {
    setState(() {
      _positionTopCommentSection = _calculatePositionTopCommentSection();
    });
  }

  Future<void> _refreshPost() async {
    if (_refreshPostOperation != null) _refreshPostOperation.cancel();
    try {
      // This will trigger the updateSubject of the post
      _refreshPostOperation = CancelableOperation.fromFuture(
          _userService.getPostWithUuid(_post.uuid));

      await _refreshPostOperation.value;
      _setPositionTopCommentSection();
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

    PostComment lastPost = _postComments.last;
    int lastPostId = lastPost.id;
    List<PostComment> moreComments;
    try {
      if (_currentSort == PostCommentsSortType.dec) {
        _loadMoreBottomCommentsOperation = CancelableOperation.fromFuture(
            _userService.getCommentsForPost(_post,
                countMax: LOAD_MORE_COMMENTS_COUNT,
                maxId: lastPostId,
                sort: _currentSort));
      } else {
        _loadMoreBottomCommentsOperation = CancelableOperation.fromFuture(
            _userService.getCommentsForPost(_post,
                countMin: LOAD_MORE_COMMENTS_COUNT,
                minId: lastPostId + 1,
                sort: _currentSort));
      }

      moreComments = (await _loadMoreBottomCommentsOperation.value).comments;

      if (moreComments.length == 0) {
        _setNoMoreBottomItemsToLoad(true);
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

  Future<bool> _loadMoreTopComments() async {
    if (_loadMoreTopCommentsOperation != null)
      _loadMoreTopCommentsOperation.cancel();
    if (_postComments.length == 0) return true;

    List<PostComment> topComments;
    PostComment firstPost = _postComments.first;
    int firstPostId = firstPost.id;
    try {
      if (_currentSort == PostCommentsSortType.dec) {
        _loadMoreTopCommentsOperation = CancelableOperation.fromFuture(
            _userService.getCommentsForPost(_post,
                sort: PostCommentsSortType.dec,
                countMin: LOAD_MORE_COMMENTS_COUNT,
                minId: firstPostId + 1));
      } else if (_currentSort == PostCommentsSortType.asc) {
        _loadMoreTopCommentsOperation = CancelableOperation.fromFuture(
            _userService.getCommentsForPost(_post,
                sort: PostCommentsSortType.asc,
                countMax: LOAD_MORE_COMMENTS_COUNT,
                maxId: firstPostId));
      }

      topComments = (await _loadMoreTopCommentsOperation.value).comments;

      if (topComments.length < LOAD_MORE_COMMENTS_COUNT &&
          topComments.length != 0) {
        _setNoMoreTopItemsToLoad(true);
        _addToStartPostComments(topComments);
      } else if (topComments.length == LOAD_MORE_COMMENTS_COUNT) {
        _addToStartPostComments(topComments);
      } else {
        _setNoMoreTopItemsToLoad(true);
        _showNoMoreTopItemsToLoadToast();
      }
      return true;
    } catch (error) {
      _onError(error);
    } finally {
      _loadMoreTopCommentsOperation = null;
    }

    return false;
  }

  void _removePostCommentAtIndex(int index) {
    setState(() {
      _postComments.removeAt(index);
    });
  }

  void _refreshCommentsWithCreatedPostCommentVisible(
      PostComment createdPostComment) async {
    if (_refreshCommentsWithCreatedPostCommentVisibleOperation != null)
      _refreshCommentsWithCreatedPostCommentVisibleOperation.cancel();
    _unfocusCommentInput();
    List<PostComment> comments;
    int createdCommentId = createdPostComment.id;
    try {
      if (_currentSort == PostCommentsSortType.dec) {
        _refreshCommentsWithCreatedPostCommentVisibleOperation =
            CancelableOperation.fromFuture(_userService.getCommentsForPost(
                _post,
                sort: PostCommentsSortType.dec,
                countMin: LOAD_MORE_COMMENTS_COUNT,
                minId: createdCommentId));
      } else if (_currentSort == PostCommentsSortType.asc) {
        _refreshCommentsWithCreatedPostCommentVisibleOperation =
            CancelableOperation.fromFuture(_userService.getCommentsForPost(
                _post,
                sort: PostCommentsSortType.asc,
                countMax: LOAD_MORE_COMMENTS_COUNT,
                maxId: createdCommentId + 1));
      }

      comments =
          (await _refreshCommentsWithCreatedPostCommentVisibleOperation.value)
              .comments;

      _setPostComments(comments);
      _setNoMoreTopItemsToLoad(false);
      _setNoMoreBottomItemsToLoad(false);
      _scrollToNewComment();
    } catch (error) {
      _onError(error);
    } finally {
      _refreshCommentsWithCreatedPostCommentVisibleOperation = null;
    }
  }

  void _onPostDeleted(Post post) {
    Navigator.of(context).pop();
  }

  void _checkIfMoreTopItemsToLoad() {
    int linkedCommentId = widget.postComment.id;
    Iterable<PostComment> listBeforeLinkedComment = [];
    if (_currentSort == PostCommentsSortType.dec) {
      listBeforeLinkedComment =
          _postComments.where((comment) => comment.id > linkedCommentId);
    } else if (_currentSort == PostCommentsSortType.asc) {
      listBeforeLinkedComment =
          _postComments.where((comment) => comment.id < linkedCommentId);
    }
    if (listBeforeLinkedComment.length < 2) {
      _setNoMoreTopItemsToLoad(true);
    }
  }

  Future _onWantsToRefreshComments() async {
    if (_refreshCommentsOperation != null) _refreshCommentsOperation.cancel();
    try {
      _refreshCommentsOperation = CancelableOperation.fromFuture(
          _userService.getCommentsForPost(_post, sort: _currentSort));
      _postComments = (await _refreshCommentsOperation.value).comments;
      _setPostComments(_postComments);
      _setNoMoreBottomItemsToLoad(false);
      _setNoMoreTopItemsToLoad(true);
    } catch (error) {
      _onError(error);
    } finally {
      _refreshCommentsOperation = null;
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

  void _setNoMoreBottomItemsToLoad(bool noMoreItemsToLoad) {
    setState(() {
      _noMoreBottomItemsToLoad = noMoreItemsToLoad;
    });
  }

  void _setNoMoreTopItemsToLoad(bool noMoreItemsToLoad) {
    setState(() {
      _noMoreTopItemsToLoad = noMoreItemsToLoad;
    });
  }

  void _showNoMoreTopItemsToLoadToast() {
    _toastService.info(context: context, message: 'No more comments to load');
  }

  void _setCurrentSortValue(PostCommentsSortType newSortValue) {
    setState(() {
      _currentSort = newSortValue;
    });
  }

  void _scrollToNewComment() {
    if (_currentSort == PostCommentsSortType.asc) {
      _postCommentsScrollController.animateTo(10000,
          duration: Duration(milliseconds: 5), curve: Curves.easeIn);
    } else if (_currentSort == PostCommentsSortType.dec) {
      _postCommentsScrollController.animateTo(
          _positionTopCommentSection - 200.0,
          duration: Duration(milliseconds: 5),
          curve: Curves.easeIn);
    }
  }

  void _onWantsToToggleSortComments() async {
    PostCommentsSortType newSortType;

    if (_currentSort == PostCommentsSortType.asc) {
      newSortType = PostCommentsSortType.dec;
    } else {
      newSortType = PostCommentsSortType.asc;
    }
    _userPreferencesService.setPostCommentsSortType(newSortType);
    _setCurrentSortValue(newSortType);
    _onWantsToRefreshComments();
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

  double _calculatePositionTopCommentSection() {
    double aspectRatio;
    double finalMediaScreenHeight = 0.0;
    double finalTextHeight = 0.0;
    double totalOffsetY = 0.0;
    double screenWidth = MediaQuery.of(context).size.width;
    if (_post.hasImage()) {
      aspectRatio = _post.getImageWidth() / _post.getImageHeight();
      finalMediaScreenHeight = screenWidth / aspectRatio;
    }
    if (_post.hasVideo()) {
      aspectRatio = _post.getVideoWidth() / _post.getVideoHeight();
      finalMediaScreenHeight = screenWidth / aspectRatio;
    }

    if (_post.hasText()) {
      TextStyle style = TextStyle(fontSize: 16.0);
      TextSpan text = new TextSpan(text: _post.text, style: style);

      TextPainter textPainter = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      textPainter.layout(
          maxWidth: screenWidth - 40.0); //padding is 20 in OBPostBodyText
      finalTextHeight = textPainter.size.height + TOTAL_PADDING_POST_TEXT;
    }

    if (_post.hasCircles() ||
        (_post.isEncircled != null && _post.isEncircled)) {
      totalOffsetY = totalOffsetY + HEIGHT_POST_CIRCLES;
    }

    totalOffsetY = totalOffsetY +
        finalMediaScreenHeight +
        finalTextHeight +
        TOTAL_FIXED_OFFSET_Y;

    return totalOffsetY;
  }

  Widget _buildLoadTopCommentsBar() {
    var theme = _themeService.getActiveTheme();

    if (_noMoreTopItemsToLoad) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: OBSecondaryText(
                  _postComments.length > 0
                      ? _currentSort == PostCommentsSortType.dec
                          ? 'Newest comments'
                          : 'Oldest comments'
                      : 'Be the first to comment!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                  child: OBText(
                    _postComments.length > 0
                        ? _currentSort == PostCommentsSortType.dec
                            ? 'See oldest comments'
                            : 'See newest comments'
                        : '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: _onWantsToToggleSortComments),
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
            Expanded(
              flex: 4,
              child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      OBIcon(OBIcons.arrowUp),
                      const SizedBox(width: 10.0),
                      OBText(
                        _currentSort == PostCommentsSortType.dec
                            ? 'Newer'
                            : 'Older',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: _loadMoreTopComments),
            ),
            Expanded(
              flex: 6,
              child: FlatButton(
                  child: OBText(
                    _currentSort == PostCommentsSortType.dec
                        ? 'View newest comments'
                        : 'View oldest comments',
                    style: TextStyle(
                        color: _themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: _onWantsToRefreshComments),
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
