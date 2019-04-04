import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_report.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_reports/widgets/reported_post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/post_reports_api.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queries/collections.dart';

class OBCommunityPostReports<T> extends StatefulWidget {
  final Community community;

  const OBCommunityPostReports({Key key, @required this.community})
      : super(key: key);

  @override
  OBCommunityPostReportsState createState() {
    return OBCommunityPostReportsState();
  }
}

class OBCommunityPostReportsState extends State<OBCommunityPostReports> with TickerProviderStateMixin {
  bool _confirmationInProgress;
  bool _rejectionInProgress;
  UserService _userService;
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;
  ToastService _toastService;
  bool _needsBootstrap;
  Post _activePost;
  List<Post> _reportedPosts;
  AnimationController animationController;
  Animation<Offset> offset;
  static const HEIGHT_INFO_PLUS_BUTTONS_SECTION = 230.0;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(animationController);
    _confirmationInProgress = false;
    _rejectionInProgress = false;
  }

  @override
  Widget build(BuildContext context) {

    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _toastService = openbookProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _getProgressIndicator(),
            _buildReportedPosts(screenHeight),
            _buildReportInfo(),
            _buildButtons(),
          ],
        );
  }

  Widget _buildButtons() {
    if (_reportedPosts == null || _reportedPosts.length == 0) return SizedBox(height: 0.0,);

    var theme = _themeService.getActiveTheme();
    return Container(
      color: _themeValueParserService.parseColor(theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OBButton(
              size: OBButtonSize.large,
              type: OBButtonType.highlight,
              child: Text('Reject'),
              onPressed: _onCancel,
              isLoading: _rejectionInProgress,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: OBButton(
              size: OBButtonSize.large,
              child: Text('Confirm'),
              onPressed: _onConfirm,
              isLoading: _confirmationInProgress,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReportInfo() {
    if (_reportedPosts != null &&_reportedPosts.length > 0) {
      var theme = _themeService.getActiveTheme();
      return Container(
          height: 35,
          color: _themeValueParserService.parseColor(theme.primaryColor),
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: _buildReportCategoriesInfo()
          )
      );
    } else {
      return SizedBox();
    }

  }

  List<Widget> _buildReportCategoriesInfo() {
    List<Widget> _categoriesInfo = [];

    var reports = new Collection<PostReport>(_activePost.reportsList.reports);
    var groupedReports = reports
        .groupBy((report) => report.category.title)
        .select((group) => {
          'title': group.key,
          'count': group.count(),
          'pluralText': group.count() > 1 ? 'reports' : 'report'
    });

    for(var category in groupedReports.asIterable()) {
      _categoriesInfo.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OBText('${category['title']}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                OBText('${category['count']} ${category['pluralText']}')
              ]
          ),
        )
      );
    }

    return _categoriesInfo;
  }

  Widget _buildReportedPosts(double screenHeight) {

    if (_reportedPosts == null) return const SizedBox();
    if (_reportedPosts.length > 0) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight - HEIGHT_INFO_PLUS_BUTTONS_SECTION),
        child: SlideTransition(
          position: offset,
          child: Container(
            height: screenHeight - HEIGHT_INFO_PLUS_BUTTONS_SECTION,
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _activePost != null ?  OBReportedPost(_activePost) : const SizedBox(),
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBIcon(
              OBIcons.check,
              themeColor: OBIconThemeColor.primaryAccent,
              size: OBIconSize.extraLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            OBText(
              'There are no reported posts!',
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void onRejectPostReport(Post post) {
    setState(() {
      _reportedPosts.remove(post);
    });
    animationController.reset();
    if (_reportedPosts.length > 0) _setActivePost(_reportedPosts.last);
  }

  void onConfirmPostReport(Post post) {
    setState(() {
      _reportedPosts.remove(post);
    });
    animationController.reset();
    if (_reportedPosts.length > 0) _setActivePost(_reportedPosts.last);
  }

  _setActivePost(Post post) {
    setState(() {
      _activePost = post;
      animationController.forward();
    });
  }

  _setReportedPosts(PostsList postList) {
    setState(() {
      _reportedPosts = postList.posts;
    });
    if (_reportedPosts.length > 0) _setActivePost(_reportedPosts.last);
  }

  Widget _getProgressIndicator() {
    if (_reportedPosts == null) {
      return Expanded(
        child: Center(
            child: CircularProgressIndicator()
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _bootstrap() async {
    var reportedPostList = await _userService.getReportedPostsForCommunity(widget.community);
    _setReportedPosts(reportedPostList);
  }

  void _onConfirm() async {
    _setConfirmationInProgress(true);
    try {
      await _userService.confirmPostReport(
          post: _activePost,
          report: _activePost.reportsList.reports[0]
      );
      onConfirmPostReport(_activePost);
    } catch (error) {
      _onError(error);
    } finally {
      _setConfirmationInProgress(false);
    }
  }

  void _onError(error) {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(message: 'No internet connection', context: context);
    } else {
      _toastService.error(message: 'Unknown error.', context: context);
      throw error;
    }
  }

  void _onCancel() async {
    _setRejectionInProgress(true);
    try {
      await _userService.rejectPostReport(
          post: _activePost,
          report: _activePost.reportsList.reports[0]
      );
      onRejectPostReport(_activePost);
    } catch (error) {
      _onError(error);
    } finally {
      _setRejectionInProgress(false);
    }
  }

  void _setConfirmationInProgress(confirmationInProgress) {
    setState(() {
      _confirmationInProgress = confirmationInProgress;
    });
  }

  void _setRejectionInProgress(rejectionInProgress) {
    setState(() {
      _rejectionInProgress = rejectionInProgress;
    });
  }
}
