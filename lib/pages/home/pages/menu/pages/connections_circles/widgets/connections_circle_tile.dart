import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circles/connections_circles.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBConnectionsCircleTile extends StatefulWidget {
  final Circle connectionsCircle;
  final VoidCallback onConnectionsCircleDeletedCallback;
  final OnWantsToSeeConnectionsCircle onWantsToSeeConnectionsCircle;
  final bool isReadOnly;

  OBConnectionsCircleTile(
      {@required this.connectionsCircle,
      Key key,
      this.onConnectionsCircleDeletedCallback,
      this.onWantsToSeeConnectionsCircle,
      this.isReadOnly = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBConnectionsCircleTileState();
  }
}

class OBConnectionsCircleTileState extends State<OBConnectionsCircleTile> {
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    Widget tile = _buildTile();

    if (widget.isReadOnly) return tile;

    tile = Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: tile,
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: _deleteConnectionsCircle),
      ],
    );

    if (_requestInProgress) {
      tile = Opacity(opacity: 0.5, child: tile);
    }
    return tile;
  }

  Widget _buildTile() {
    String prettyCount = getPrettyCount(widget.connectionsCircle.usersCount);

    return ListTile(
        onTap: () {
          widget.onWantsToSeeConnectionsCircle(widget.connectionsCircle);
        },
        leading: OBCircleColorPreview(
          widget.connectionsCircle,
          size: OBCircleColorPreviewSize.medium,
        ),
        title: OBText(
          widget.connectionsCircle.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: OBSecondaryText(prettyCount + ' people'));
  }

  void _deleteConnectionsCircle() async {
    _setRequestInProgress(true);
    try {
      await _userService.deleteConnectionsCircle(widget.connectionsCircle);
      // widget.post.decreaseCommentsCount();
      _setRequestInProgress(false);
      if (widget.onConnectionsCircleDeletedCallback != null) {
        widget.onConnectionsCircleDeletedCallback();
      }
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
