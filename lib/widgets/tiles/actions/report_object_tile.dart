import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportUserTile extends StatefulWidget {
  final User user;
  final ValueChanged<dynamic> onUserReported;
  final VoidCallback onWantsToReportUser;

  const OBReportUserTile({
    Key key,
    this.onUserReported,
    @required this.user,
    this.onWantsToReportUser,
  }) : super(key: key);

  @override
  OBReportUserTileState createState() {
    return OBReportUserTileState();
  }
}

class OBReportUserTileState extends State<OBReportUserTile> {
  ModalService _modalService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _modalService = openbookProvider.modalService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        bool isReported = user.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(
              isReported ?  'You have reported this account' : 'Report account'),
          onTap: isReported ? () {} : _reportUser,
        );
      },
    );
  }

  void _reportUser() {
    if (widget.onWantsToReportUser != null) widget.onWantsToReportUser();
    _modalService.openReportObject(
        context: context,
        object: widget.user,
        onObjectReported: widget.onUserReported);
  }
}
