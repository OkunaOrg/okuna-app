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

class OBPostCommentsLinkedPageState extends State<OBPostCommentsLinkedPage>
    with SingleTickerProviderStateMixin {
  UserService _userService;
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
  bool _noMoreItemsToLoad;
  bool _noMoreEarlierItemsToLoad;
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

  @override
  void initState() {
    super.initState();
    _post = widget.postComment.post;
    _needsBootstrap = true;
    _postComments = [];
    _noMoreItemsToLoad = true;
    _currentSort = PostCommentsSortType.dec;
    _noMoreEarlierItemsToLoad = false;
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
    await _refreshPost();
    await _refreshCommentsSlice();
  }

  void dispose() {
    super.dispose();
    _animation.removeStatusListener(_onAnimationStatusChanged);
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  onLoadMore: _loadMoreBottomComments),
            ),
            onRefresh: _onWantsToRefreshComments),
      ),
      OBPostCommenter(
        _post,
        autofocus: widget.autofocusCommentInput,
        commentTextFieldFocusNode: _commentInputFocusNode,
        onPostCommentCreated: _onPostCommentCreated,
        onPostCommentWillBeCreated: _onWantsToLoadnewestComments,
      )
    ]);

    return _columnChildren;
  }

  Future _onWantsToRefreshComments() async {
    await _onWantsToLoadnewestComments();
  }

  Widget _getCommentTile(int index) {
    int commentIndex = index - 1;
    var postComment = _postComments[commentIndex];
    var onPostCommentDeletedCallback = () {
      _removePostCommentAtIndex(commentIndex);
    };

    if (_animationController.status != AnimationStatus.completed &&
        !_startScrollWasInitialised) {
      _postCommentsScrollController.animateTo(
          _positionTopCommentSection - 100.0,
          duration: Duration(milliseconds: 5),
          curve: Curves.easeIn);
    }

    if (index == _postComments.length) {
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
        child: OBExpandedPostComment(
          postComment: postComment,
          post: _post,
          onPostCommentDeletedCallback: onPostCommentDeletedCallback,
        ),
      );
    } else {
      return OBExpandedPostComment(
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
        _buildLoadEarlierCommentsBar(),
      ],
    );
  }

  Future<void> _refreshCommentsSlice() async {
    try {
      _postComments = (await _userService.getCommentsForPost(_post,
              minId: widget.postComment.id,
              maxId: widget.postComment.id,
              countMax: COUNT_MAX_AFTER_LINKED_COMMENT,
              countMin: COUNT_MIN_INCLUDING_LINKED_COMMENT))
          .comments;
      _setPostComments(_postComments);
      _checkIfMoreEarlierItemsToLoad();
      _setNoMoreItemsToLoad(false);
    } catch (error) {
      _onError(error);
    }
  }

  void _setPositionTopCommentSection() {
    setState(() {
      _positionTopCommentSection = _calculatePositionTopCommentSection();
    });
  }

  Future<void> _refreshPost() async {
    try {
      // This will trigger the updateSubject of the post
      await _userService.getPostWithUuid(_post.uuid);
      _setPositionTopCommentSection();
    } catch (error) {
      _onError(error);
    }
  }

  Future<bool> _loadMoreBottomComments() async {
    if (_postComments.length == 0) return true;

    var lastPost = _postComments.last;
    var lastPostId = lastPost.id;
    var moreComments;
    try {
      if (_currentSort == PostCommentsSortType.dec) {
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

  Future<bool> _loadMoreTopComments() async {
    if (_postComments.length == 0) return true;

    var firstPost = _postComments.first;
    var firstPostId = firstPost.id;

    try {
      var moreComments = (await _userService.getCommentsForPost(_post,
              countMin: LOAD_MORE_COMMENTS_COUNT, minId: firstPostId + 1))
          .comments;

      if (moreComments.length < LOAD_MORE_COMMENTS_COUNT &&
          moreComments.length != 0) {
        _setNoMoreEarlierItemsToLoad(true);
        _addToStartPostComments(moreComments);
      } else if (moreComments.length == LOAD_MORE_COMMENTS_COUNT) {
        _addToStartPostComments(moreComments);
      } else {
        _setNoMoreEarlierItemsToLoad(true);
        _showNoMoreTopItemsToLoad();
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

  void _checkIfMoreEarlierItemsToLoad() {
    var linkedCommentId = widget.postComment.id;
    var listBeforeLinkedComment =
        _postComments.where((comment) => comment.id > linkedCommentId);
    if (listBeforeLinkedComment.length < 2) {
      _setNoMoreEarlierItemsToLoad(true);
    }
  }

  void _onWantsToLoadEarlierComments() async {
    await _loadMoreTopComments();
  }

  Future _onWantsToLoadnewestComments() async {
    try {
      _setCurrentSortValue(PostCommentsSortType.dec);
      _postComments = (await _userService.getCommentsForPost(_post)).comments;
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

  void _showNoMoreTopItemsToLoad() {
    _toastService.info(context: context,message: 'No more comments to load');
  }

  void _setCurrentSortValue(PostCommentsSortType newSortValue) {
    setState(() {
      _currentSort = newSortValue;
    });
  }

  void _onWantsToToggleSortComments() async {
    PostCommentsSortType newSortType;

    if (_currentSort == PostCommentsSortType.asc) {
      newSortType = PostCommentsSortType.dec;
    } else {
      newSortType = PostCommentsSortType.asc;
    }

    try {
      _postComments =
          (await _userService.getCommentsForPost(_post, sort: newSortType))
              .comments;
      _setCurrentSortValue(newSortType);
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
                    OBText(
                      'Earlier',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: _onWantsToLoadEarlierComments),
            FlatButton(
                child: Row(
                  children: <Widget>[
                    OBText(
                      'View newest comments',
                      style: TextStyle(
                          color: _themeValueParserService
                              .parseGradient(theme.primaryAccentColor)
                              .colors[1],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: _onWantsToLoadnewestComments),
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
