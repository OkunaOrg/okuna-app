import 'package:Openbook/libs/type_to_str.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/moderation/moderation_category_list.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/fields/checkbox_field.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReportObjectModal extends StatefulWidget {
  final dynamic object;
  final OnObjectReported onObjectReported;

  const OBReportObjectModal({
    Key key,
    this.object,
    this.onObjectReported,
  }) : super(key: key);

  @override
  OBReportObjectModalState createState() {
    return OBReportObjectModalState();
  }
}

class OBReportObjectModalState extends State<OBReportObjectModal> {
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

    OBTheme theme = _themeService.getActiveTheme();

    Color textColor = _themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(
                'Please select a reason',
                style: TextStyle(color: textColor),
              )),
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

    return OBCheckboxField(
      value: _pickedModerationCategory == category,
      onTap: () async {
        var result = await _navigationService.navigateToConfirmReportObject(
            object: widget.object, category: category, context: context);
        if (result != null) {
          widget.onObjectReported(widget.object);
          Navigator.pop(context);
        }
      },
      title: category.title,
      subtitle: category.description,
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: 'Report ' + modelTypeToString(widget.object),
      trailing: GestureDetector(
        onTap: _onWantsToGoNext,
        child: const OBText('Next'),
      ),
    );
  }

  void _onWantsToGoNext() {
    _navigationService.navigateToConfirmReportObject(
        context: context,
        object: widget.object,
        category: _pickedModerationCategory);
  }

  void _bootstrap() async {
    var moderationCategories = await _userService.getModerationCategories();
    _setModerationCategories(moderationCategories);
  }

  _setModerationCategories(ModerationCategoriesList moderationCategoriesList) {
    setState(() {
      print(moderationCategoriesList.moderationCategories);
      _moderationCategories = moderationCategoriesList.moderationCategories;
    });
  }

}

typedef OnObjectReported(dynamic object);
