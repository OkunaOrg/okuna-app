import 'dart:async';
import 'package:Openbook/models/categories_list.dart';
import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/my_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/trending_communities.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/pages/home/pages/search/widgets/user_search_results.dart';
import 'package:Openbook/pages/home/pages/search/widgets/trending/trending.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainCommunitiesPage extends StatefulWidget {
  final OBCommunitiesPageController controller;

  const OBMainCommunitiesPage({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBMainCommunitiesPageState();
  }
}

class OBMainCommunitiesPageState extends State<OBMainCommunitiesPage>
    with TickerProviderStateMixin {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;

  List<Category> _categories;
  TabController _tabController;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.attach(context: context, state: this);
    _needsBootstrap = true;
    _categories = [];
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    if (_needsBootstrap) {
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    Widget currentWidget;

    ThemeService _themeService = openbookProvider.themeService;
    var _themeValueParser = openbookProvider.themeValueParserService;
    OBTheme theme = _themeService.getActiveTheme();

    Color tabIndicatorColor =
        _themeValueParser.parseGradient(theme.primaryAccentColor).colors[1];

    Color tabLabelColor = _themeValueParser.parseColor(theme.primaryTextColor);

    List<Widget> tabs = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Tab(text: 'My communities'),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Tab(text: 'Trending'),
      )
    ];

    List<Widget> categoriesTabs = _categories.map((Category category) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Tab(text: category.title),
      );
    }).toList();

    tabs.addAll(categoriesTabs);

    List<Widget> tabBarViews = [OBMyCommunities(), OBTrendingCommunities()];

    List<Widget> categoriesTabBarViews = _categories.map((Category category) {
      return OBTrendingCommunities(
        category: category,
      );
    }).toList();

    tabBarViews.addAll(categoriesTabBarViews);

    return CupertinoPageScaffold(
        child: OBPrimaryColorContainer(
            child: SafeArea(
                bottom: false,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      controller: _tabController,
                      tabs: tabs,
                      isScrollable: true,
                      indicatorColor: tabIndicatorColor,
                      labelColor: tabLabelColor,
                    ),
                    Expanded(
                      child: TabBarView(
                          controller: _tabController, children: tabBarViews),
                    )
                  ],
                ))));
  }

  void _bootstrap() {
    _refreshCategories();
  }

  Future<void> _refreshCategories() async {
    CategoriesList categoriesList = await _userService.getCategories();
    _setCategories(categoriesList.categories);
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      _categories = categories;
      _tabController =
          TabController(length: _categories.length + 2, vsync: this);
    });
  }

  void _onRequestError(error) {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(message: 'No internet connection', context: context);
    } else {
      _toastService.error(message: 'Unknown error.', context: context);
      throw error;
    }
  }

  void scrollToTop() {
    //_trendingController.scrollToTop();
  }
}

class OBCommunitiesPageController extends PoppablePageController {
  OBMainCommunitiesPageState _state;

  void attach(
      {@required BuildContext context, OBMainCommunitiesPageState state}) {
    super.attach(context: context);
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
