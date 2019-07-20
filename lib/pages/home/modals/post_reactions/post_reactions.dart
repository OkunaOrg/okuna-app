import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/reactions_emoji_count.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/modals/post_reactions/widgets/post_reaction_list.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostReactionsModal extends StatefulWidget {
  // The post to display the reactions for
  final Post post;

  // The optional emoji to show first
  final Emoji reactionEmoji;

  // The post reactiosn emoji counts
  final List<ReactionsEmojiCount> reactionsEmojiCounts;

  const OBPostReactionsModal(
      {Key key,
      @required this.post,
      this.reactionEmoji,
      @required this.reactionsEmojiCounts})
      : super(key: key);

  @override
  OBPostReactionsModalState createState() {
    return OBPostReactionsModalState();
  }
}

class OBPostReactionsModalState extends State<OBPostReactionsModal>
    with TickerProviderStateMixin {
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;
  bool _needsBootstrap;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _tabController =
        TabController(length: widget.reactionsEmojiCounts.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      LocalizationService localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    OBTheme theme = _themeService.getActiveTheme();

    Color tabIndicatorColor = _themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(localizationService),
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                tabs: _buildPostReactionsIcons(),
                isScrollable: true,
                indicatorColor: tabIndicatorColor,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _buildPostReactionsTabs(),
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildPostReactionsTabs() {
    return widget.reactionsEmojiCounts.map((reactionsEmojiCount) {
      return OBPostReactionList(
        post: widget.post,
        emoji: reactionsEmojiCount.emoji,
      );
    }).toList();
  }

  List<Widget> _buildPostReactionsIcons() {
    return widget.reactionsEmojiCounts.map((reactionsEmojiCount) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Tab(icon: OBEmoji(reactionsEmojiCount.emoji)),
      );
    }).toList();
  }

  Widget _buildNavigationBar(LocalizationService localizationService) {
    return OBThemedNavigationBar(
        title: localizationService.post__post_reactions_title);
  }

  void _bootstrap() async {
    int tabIndex = 0;

    if (widget.reactionEmoji != null) {
      tabIndex = widget.reactionsEmojiCounts.indexWhere((reactionEmojiCount) {
        return reactionEmojiCount.emoji.id == widget.reactionEmoji.id;
      });
    }

    _tabController.index = tabIndex;
  }
}
