import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/report_categories_list.dart';
import 'package:Openbook/models/report_category.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/post_reports_api.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReportPostModal extends StatefulWidget {
  final Post reportedPost;
  final OnPostReported onPostReported;

  const OBReportPostModal(
      {Key key,
        @required this.reportedPost,
        @required this.onPostReported
      })
      : super(key: key);

  @override
  OBReportPostModalState createState() {
    return OBReportPostModalState();
  }
}

class OBReportPostModalState extends State<OBReportPostModal>
    with TickerProviderStateMixin {
  PostReportsApiService _postReportsApiService;
  ThemeService _themeService;
  NavigationService _navigationService;
  UserService _userService;
  ThemeValueParserService _themeValueParserService;
  List<ReportCategory> _reportCategories = [];
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _themeService = openbookProvider.themeService;
      _userService = openbookProvider.userService;
      _navigationService = openbookProvider.navigationService;
      _postReportsApiService = openbookProvider.postReportsApiService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _bootstrap();
      _needsBootstrap = false;
    }

    OBTheme theme = _themeService.getActiveTheme();

    Color textColor = _themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];

    Color textColorCategoryText = _themeValueParserService.parseColor(theme.primaryTextColor);

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Please select a reason', style: TextStyle(color: textColor),)
              ),
              Expanded(
                child:  ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return _buildReportCategoryTile(context, index);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: _reportCategories.length,
                ),
              ),
              _getProgressIndicator()
            ],
          ),
        ));
  }

  Widget _buildReportCategoryTile(context, index) {
    OBTheme theme = _themeService.getActiveTheme();
    Color textColorCategoryText = _themeValueParserService.parseColor(theme.primaryTextColor);

    return ListTile(
      onTap: () async {
        var result = await _navigationService.navigateToReportPostForm(
            post: widget.reportedPost,
            category: _reportCategories[index],
            context: context
        );
        if (result) {
          widget.onPostReported(widget.reportedPost);
          Navigator.pop(context);
        }
      },
      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      title: Text(_reportCategories[index].title,
        style: TextStyle(color: textColorCategoryText),),
      trailing: OBIcon(
          OBIcons.menuForward,
          size: OBIconSize.small),
    );
  }

  Widget _getProgressIndicator() {
    if (_reportCategories.length == 0) {
      return Expanded(
          child: Center(
            child: CircularProgressIndicator()
        )
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
        title: 'Report Post');
  }

  _setReportCategories(ReportCategoriesList reportCategoriesList) {
    setState(() {
      _reportCategories = reportCategoriesList.categories;
    });
  }

  void _bootstrap() async {
     var reportCategories = await _userService.getReportCategories();
     _setReportCategories(reportCategories);
  }
}
