import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/moderation/moderation_category_list.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/checkbox.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectUpdateCategoryPage extends StatefulWidget {
  final ModeratedObject moderatedObject;

  const OBModeratedObjectUpdateCategoryPage(
      {Key key, @required this.moderatedObject})
      : super(key: key);

  @override
  OBModeratedObjectUpdateCategoryPageState createState() {
    return OBModeratedObjectUpdateCategoryPageState();
  }
}

class OBModeratedObjectUpdateCategoryPageState
    extends State<OBModeratedObjectUpdateCategoryPage> {
  UserService _userService;
  ToastService _toastService;
  List<ModerationCategory> _moderationCategories = [];
  ModerationCategory _selectedModerationCategory;
  bool _needsBootstrap;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _requestInProgress = false;
    _selectedModerationCategory = widget.moderatedObject.category;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _toastService = openbookProvider.toastService;
      _userService = openbookProvider.userService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
    return Opacity(
      opacity: _requestInProgress ? 0.8 : 1,
      child: Expanded(
        child: ListView.separated(
          padding: EdgeInsets.all(0.0),
          itemBuilder: _buildModerationCategoryTile,
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: _moderationCategories.length,
        ),
      ),
    );
  }

  Widget _buildModerationCategoryTile(context, index) {
    ModerationCategory category = _moderationCategories[index];

    return GestureDetector(
      onTap: () => _setSelectedModerationCategory(category),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              title: OBText(
                category.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: OBSecondaryText(category.description),
              //trailing: OBIcon(OBIcons.chevronRight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: OBCheckbox(
              value: _selectedModerationCategory == category,
            ),
          )
        ],
      ),
    );
  }

  void _setSelectedModerationCategory(ModerationCategory category) {
    setState(() {
      _selectedModerationCategory = category;
    });
  }

  void _saveModerationCategory() {
    _setRequestInProgress(true);
    try {
      _userService.updateModeratedObject(widget.moderatedObject,
          category: _selectedModerationCategory);
      Navigator.of(context).pop();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
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

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: 'Update category',
      trailing: OBButton(
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _saveModerationCategory,
        child: Text('Save'),
      ),
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

  _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}

typedef OnObjectReported(dynamic object);
