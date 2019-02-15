import 'dart:async';
import 'package:Openbook/models/categories_list.dart';
import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/category_tab.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/my_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/trending_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/user_avatar_tab.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/tabs/image_tab.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

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

    Gradient themeGradient =
        _themeValueParser.parseGradient(theme.primaryAccentColor);

    Color tabIndicatorColor = themeGradient.colors[0];
    Color themePrimaryColor = _themeValueParser.parseColor(theme.primaryColor);
    Color themeTextColor = _themeValueParser.parseColor(theme.primaryTextColor);

    Color tabLabelColor = _themeValueParser.parseColor(theme.primaryTextColor);

    User loggedInUser = _userService.getLoggedInUser();
    bool userHasAvatar = loggedInUser.hasProfileAvatar();

    List<Widget> tabs = [
      OBUserAvatarTab(
        user: loggedInUser,
      ),
      OBImageTab(
        text: 'All',
        color: Pigment.fromString('#2d2d2d'),
        textColor: Pigment.fromString('#ffffff'),
        imageProvider:
            AssetImage('assets/images/categories/category_all-min.png'),
      ),
    ];

    List<Widget> categoriesTabs = _categories.map((Category category) {
      return OBCategoryTab(
        category: category,
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
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
