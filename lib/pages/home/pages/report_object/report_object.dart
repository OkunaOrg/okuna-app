import 'package:Openbook/libs/type_to_str.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/moderation/moderation_category_list.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReportObjectPage extends StatefulWidget {
  final dynamic object;
  final OnObjectReported onObjectReported;

  const OBReportObjectPage({
    Key key,
    this.object,
    this.onObjectReported,
  }) : super(key: key);

  @override
  OBReportObjectPageState createState() {
    return OBReportObjectPageState();
  }
}

class OBReportObjectPageState extends State<OBReportObjectPage> {
  ThemeService _themeService;
  NavigationService _navigationService;
  UserService _userService;
  ThemeValueParserService _themeValueParserService;
  List<ModerationCategory> _moderationCategories = [];
  ModerationCategory _pickedModerationCategory;
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
      _themeValueParserService = openbookProvider.themeValueParserService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                child: OBText(
                  'Why are you reporting this ' +
                      modelTypeToString(widget.object) +
                      '?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              _moderationCategories.isEmpty
                  ? _buildProgressIndicator()
                  : _buildModerationCategories(),
            ],
          ),
        ));
  }

  Widget _buildProgressIndicator() {
    return Expanded(
      child: Center(
        child: OBProgressIndicator(),
      ),
    );
  }

  Widget _buildModerationCategories() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(0.0),
        itemBuilder: _buildModerationCategoryTile,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: _moderationCategories.length,
      ),
    );
  }

  Widget _buildModerationCategoryTile(context, index) {
    ModerationCategory category = _moderationCategories[index];

    return ListTile(
      onTap: () async {
        var result = await _navigationService.navigateToConfirmReportObject(
            object: widget.object, category: category, context: context);
        if (result != null && result) {
          if(widget.onObjectReported != null) widget.onObjectReported(widget.object);
          Navigator.pop(context);
        }
      },
      title: OBText(
        category.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: OBSecondaryText(category.description),
      //trailing: OBIcon(OBIcons.chevronRight),
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: 'Report ' + modelTypeToString(widget.object),
    );
  }

  void _bootstrap() async {
    var moderationCategories = await _userService.getModerationCategories();
    _setModerationCategories(moderationCategories);
  }

  _setModerationCategories(ModerationCategoriesList moderationCategoriesList) {
    setState(() {
      _moderationCategories = moderationCategoriesList.moderationCategories;
    });
  }
}

typedef OnObjectReported(dynamic object);
