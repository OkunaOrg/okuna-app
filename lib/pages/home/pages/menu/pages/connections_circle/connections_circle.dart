import 'package:Openbook/models/circle.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circle/widgets/connections_circle_header/connections_circle_header.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circle/widgets/connections_circle_users.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBConnectionsCirclePage extends StatefulWidget {
  final Circle connectionsCircle;

  OBConnectionsCirclePage(
    this.connectionsCircle,
  );

  @override
  State<OBConnectionsCirclePage> createState() {
    return OBConnectionsCirclePageState();
  }
}

class OBConnectionsCirclePageState extends State<OBConnectionsCirclePage> {
  UserService _userService;
  ToastService _toastService;
  ModalService _modalService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  bool _needsBootstrap;
  bool _isConnectionsCircle;

  @override
  void initState() {
    super.initState();
    _isConnectionsCircle = false;
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;
    _modalService = provider.modalService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBNavigationBar(
          trailing: _buildNavigationBarTrailingItem(),
        ),
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            child: OBPrimaryColorContainer(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OBConnectionsCircleHeader(widget.connectionsCircle,
                        isConnectionsCircle: _isConnectionsCircle),
                    Expanded(
                      child: OBConnectionsCircleUsers(
                        widget.connectionsCircle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onRefresh: _refreshConnectionsCircle));
  }

  Widget _buildNavigationBarTrailingItem() {
    if (_isConnectionsCircle) return SizedBox();
    return GestureDetector(
      onTap: () {
        _modalService.openEditConnectionsCircle(
            connectionsCircle: widget.connectionsCircle, context: context);
      },
      child: Text('Edit'),
    );
  }

  void _bootstrap() async {
    await _refreshConnectionsCircle();
    var loggedInUser = _userService.getLoggedInUser();
    bool isConnectionsCircle =
        loggedInUser.isConnectionsCircle(widget.connectionsCircle);
    _setIsConnectionsCircle(isConnectionsCircle);
  }

  Future<void> _refreshConnectionsCircle() async {
    try {
      await _userService
          .getConnectionsCircleWithId(widget.connectionsCircle.id);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }

  void _setIsConnectionsCircle(bool isConnectionsCircle) {
    setState(() {
      _isConnectionsCircle = isConnectionsCircle;
    });
  }
}
