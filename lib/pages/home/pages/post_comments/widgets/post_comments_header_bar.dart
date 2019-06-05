import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/post_comments/post_comments_page_controller.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';


class OBPostCommentsHeaderBar extends StatelessWidget {
  PostCommentsPageType pageType;
  bool noMoreTopItemsToLoad;
  List<PostComment> postComments;
  PostCommentsSortType currentSort;
  VoidCallback onWantsToToggleSortComments;
  VoidCallback loadMoreTopComments;
  VoidCallback onWantsToRefreshComments;

  static const PAGE_COMMENTS_TEXT_MAP = {
    'NEWEST': 'Newest comments',
    'NEWER': 'Newer',
    'VIEW_NEWEST': 'View newest comments',
    'SEE_NEWEST': 'See newest comments',
    'OLDEST': 'Oldest comments',
    'OLDER': 'Older',
    'VIEW_OLDEST': 'View oldest comments',
    'SEE_OLDEST': 'See oldest comments',
    'BE_THE_FIRST': 'Be the first to comment',
  };

  static const PAGE_REPLIES_TEXT_MAP = {
    'NEWEST': 'Newest replies',
    'NEWER': 'Newer',
    'VIEW_NEWEST': 'View newest replies',
    'SEE_NEWEST': 'See newest replies',
    'OLDEST': 'Oldest replies',
    'OLDER': 'Older',
    'VIEW_OLDEST': 'View oldest replies',
    'SEE_OLDEST': 'See oldest replies',
    'BE_THE_FIRST': 'Be the first to reply',
  };

  OBPostCommentsHeaderBar({
    @required this.pageType,
    @required this.noMoreTopItemsToLoad,
    @required this.postComments,
    @required this.currentSort,
    @required this.onWantsToToggleSortComments,
    @required this.loadMoreTopComments,
    @required this.onWantsToRefreshComments,
  });

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    ThemeService _themeService = provider.themeService;
    ThemeValueParserService _themeValueParserService = provider.themeValueParserService;
    var theme = _themeService.getActiveTheme();
    Map<String, String> _pageTextMap;
    if (this.pageType == PostCommentsPageType.comments) {
      _pageTextMap = PAGE_COMMENTS_TEXT_MAP;
    } else {
      _pageTextMap = PAGE_REPLIES_TEXT_MAP;
    }


    if (this.noMoreTopItemsToLoad) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: OBSecondaryText(
                  this.postComments.length > 0
                      ? this.currentSort == PostCommentsSortType.dec
                      ? _pageTextMap['NEWEST']
                      : _pageTextMap['OLDEST']
                      : _pageTextMap['BE_THE_FIRST'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                  child: OBText(
                    this.postComments.length > 0
                        ? this.currentSort == PostCommentsSortType.dec
                        ?  _pageTextMap['SEE_OLDEST']
                        :  _pageTextMap['SEE_NEWEST']
                        : '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: this.onWantsToToggleSortComments),
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
                        this.currentSort == PostCommentsSortType.dec
                            ?  _pageTextMap['NEWER']
                            :  _pageTextMap['OLDER'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: this.loadMoreTopComments),
            ),
            Expanded(
              flex: 6,
              child: FlatButton(
                  child: OBText(
                    this.currentSort == PostCommentsSortType.dec
                        ? _pageTextMap['VIEW_NEWEST']
                        :  _pageTextMap['VIEW_OLDEST'],
                    style: TextStyle(
                        color: _themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: this.onWantsToRefreshComments),
            ),
          ],
        ),
      );
    }
  }
}
