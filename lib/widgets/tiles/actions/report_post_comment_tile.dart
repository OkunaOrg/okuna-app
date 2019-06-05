import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportPostCommentTile extends StatefulWidget {
  final PostComment postComment;
  final ValueChanged<dynamic> onPostCommentReported;
  final VoidCallback onWantsToReportPostComment;

  const OBReportPostCommentTile({
    Key key,
    this.onPostCommentReported,
    @required this.postComment,
    this.onWantsToReportPostComment,
  }) : super(key: key);

  @override
  OBReportPostCommentTileState createState() {
    return OBReportPostCommentTileState();
  }
}

class OBReportPostCommentTileState extends State<OBReportPostCommentTile> {
  NavigationService _navigationService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _navigationService = openbookProvider.navigationService;

    return StreamBuilder(
      stream: widget.postComment.updateSubject,
      initialData: widget.postComment,
      builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
        var postComment = snapshot.data;

        bool isReported = postComment.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(
              isReported ? 'You have reported this comment' : 'Report comment'),
          onTap: isReported ? () {} : _reportPostComment,
        );
      },
    );
  }

  void _reportPostComment() {
    if (widget.onWantsToReportPostComment != null)
      widget.onWantsToReportPostComment();
    _navigationService.navigateToReportObject(
        context: context,
        object: widget.postComment,
        onObjectReported: widget.onPostCommentReported);
  }
}
