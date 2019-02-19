import 'dart:async';
import 'package:Openbook/models/categories_list.dart';
import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/category_tab.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/my_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/trending_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/user_avatar_tab.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/icon_button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
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
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;
  ModalService _modalService;
  NavigationService _navigationService;

  List<Category> _categories;
  TabController _tabController;

  ScrollController _myCommunitiesScrollController;
  ScrollController _allTrendingCommnunitiesScrollController;

  List<ScrollController> _categoriesScrollControllers;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.attach(context: context, state: this);
    _needsBootstrap = true;
    _categories = [];
    _categoriesScrollControllers = [];
    _tabController = _makeTabController();
    _myCommunitiesScrollController = ScrollController();
    _allTrendingCommnunitiesScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _modalService = openbookProvider.modalService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
            title: 'Communities',
            trailing: OBIconButton(
              OBIcons.add,
              themeColor: OBIconThemeColor.primaryAccent,
              onPressed: _onWantsToCreateCommunity,
            )),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                  controller: _tabController, children: _buildTabBarViews()),
            )
          ],
        )));
  }

  Widget _buildTabBar() {
    OBTheme theme = _themeService.getActiveTheme();

    Gradient themeGradient =
        _themeValueParserService.parseGradient(theme.primaryAccentColor);

    Color tabIndicatorColor = themeGradient.colors[0];

    Color tabLabelColor =
        _themeValueParserService.parseColor(theme.primaryTextColor);

    return TabBar(
      controller: _tabController,
      tabs: _buildTabs(),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isScrollable: true,
      indicatorColor: tabIndicatorColor,
      labelColor: tabLabelColor,
    );
  }

  List<Widget> _buildTabs() {
    User loggedInUser = _userService.getLoggedInUser();

    List<Widget> tabs = [
      OBUserAvatarTab(
        user: loggedInUser,
      ),
      OBImageTab(
        text: 'All',
        color: Pigment.fromString('#2d2d2d'),
        textColor: Pigment.fromString('#ffffff'),
        imageProvider:
            const AssetImage('assets/images/categories/category_all-min.png'),
      ),
    ];

    List<Widget> categoriesTabs = _categories.map((Category category) {
      return OBCategoryTab(
        category: category,
      );
    }).toList();

    tabs.addAll(categoriesTabs);

    return tabs;
  }

  List<Widget> _buildTabBarViews() {
    List<Widget> tabBarViews = [
      OBMyCommunities(
        scrollController: _myCommunitiesScrollController,
      ),
      OBTrendingCommunities(
        scrollController: _allTrendingCommnunitiesScrollController,
      )
    ];

    _categoriesScrollControllers = [];

    List<Widget> categoriesTabBarViews = _categories.map((Category category) {
      ScrollController scrollController = ScrollController();
      _categoriesScrollControllers.add(scrollController);
      return OBTrendingCommunities(
        category: category,
        scrollController: scrollController,
      );
    }).toList();

    tabBarViews.addAll(categoriesTabBarViews);
    return tabBarViews;
  }

  void _bootstrap() {
    _refreshCategories();
  }

  Future<void> _refreshCategories() async {
    try {
      CategoriesList categoriesList = await _userService.getCategories();
      _setCategories(categoriesList.categories);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      throw error;
    }
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      _categories = categories;
      _tabController = _makeTabController();
    });
  }

  void scrollToTop() {
    int currentIndex = _tabController.index;
    ScrollController currentTabScrollController;

    if (currentIndex == 0) {
      currentTabScrollController = _myCommunitiesScrollController;
    } else if (currentIndex == 1) {
      currentTabScrollController = _allTrendingCommnunitiesScrollController;
    } else {
      // It's a category scroll controller
      currentTabScrollController =
          _categoriesScrollControllers[currentIndex - 2];
    }

    currentTabScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  TabController _makeTabController() {
    TabController controller =
        TabController(length: _categories.length + 2, vsync: this);
    return controller;
  }

  void _onWantsToCreateCommunity() async {
    Community createdCommunity =
        await _modalService.openCreateCommunity(context: context);
    if (createdCommunity != null) {
      _navigationService.navigateToCommunity(
          community: createdCommunity, context: context);
    }
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
