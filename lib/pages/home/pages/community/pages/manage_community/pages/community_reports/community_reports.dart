import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_reports/community_post_reports.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityReportsPage<T> extends StatefulWidget {
  final Community community;

  const OBCommunityReportsPage({Key key, @required this.community})
      : super(key: key);

  @override
  OBCommunityReportsPageState createState() {
    return OBCommunityReportsPageState();
  }
}

class OBCommunityReportsPageState extends State<OBCommunityReportsPage> with TickerProviderStateMixin {
  ThemeService _themeService;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _themeService = openbookProvider.themeService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(title: 'Reported Content'),
        child: OBPrimaryColorContainer(
            child: StreamBuilder(
            stream: _themeService.themeChange,
            initialData: _themeService.getActiveTheme(),
            builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: OBCommunityPostReports(community: widget.community),
                    )
                  ],
                );
              }
            )
          )
        );
  }
}
