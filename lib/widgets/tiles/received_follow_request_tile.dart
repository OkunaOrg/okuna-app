import 'package:Okuna/models/follow_request.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

import '../../provider.dart';

class OBReceivedFollowRequestTile extends StatefulWidget {
  final FollowRequest followRequest;
  final ValueChanged<FollowRequest> onFollowRequestApproved;
  final ValueChanged<FollowRequest> onFollowRequestRejected;

  const OBReceivedFollowRequestTile(this.followRequest,
      {Key key, this.onFollowRequestApproved, this.onFollowRequestRejected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBReceivedFollowRequestTileState();
  }
}

class OBReceivedFollowRequestTileState
    extends State<OBReceivedFollowRequestTile> {
  ToastService _toastService;
  LocalizationService _localizationService;
  UserService _userService;
  NavigationService _navigationService;
  bool _needsBootstrap;

  bool _isFollowRequestActionInProgress;
  CancelableOperation _followRequestActionOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _isFollowRequestActionInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    if (_needsBootstrap) {
      _localizationService = openbookProvider.localizationService;
      _userService = openbookProvider.userService;
      _navigationService = openbookProvider.navigationService;
    }

    return OBUserTile(
      widget.followRequest.creator,
      onUserTilePressed: (User user){
        _navigationService.navigateToUserProfile(user: user, context: context);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OBButton(
            size: OBButtonSize.small,
            isLoading: _isFollowRequestActionInProgress,
            child: Text(toBeginningOfSentenceCase(
                _localizationService.moderation__community_review_reject)),
            type: OBButtonType.danger,
            onPressed: _onWantsToRejectRequest,
          ),
          const SizedBox(
            width: 10,
          ),
          OBButton(
            size: OBButtonSize.small,
            isLoading: _isFollowRequestActionInProgress,
            child: Text(toBeginningOfSentenceCase(
                _localizationService.moderation__community_review_approve)),
            type: OBButtonType.success,
            onPressed: _onWantsToApproveRequest,
          ),
        ],
      ),
    );
  }

  Future<void> _onWantsToApproveRequest() async {
    _setFollowRequestActionInProgress(true);

    try {
      _followRequestActionOperation = CancelableOperation.fromFuture(
          _userService
              .approveFollowRequestFromUser(widget.followRequest.creator));
      await _followRequestActionOperation.value;
      widget.onFollowRequestApproved(widget.followRequest);
    } catch (error) {
      _onError(error);
      rethrow;
    } finally {
      _setFollowRequestActionInProgress(false);
      _followRequestActionOperation = null;
    }
  }

  Future<void> _onWantsToRejectRequest() async {
    _setFollowRequestActionInProgress(true);

    try {
      _followRequestActionOperation = CancelableOperation.fromFuture(
          _userService
              .rejectFollowRequestFromUser(widget.followRequest.creator));
      await _followRequestActionOperation.value;
      widget.onFollowRequestRejected(widget.followRequest);
    } catch (error) {
      _onError(error);
      rethrow;
    } finally {
      _setFollowRequestActionInProgress(false);
      _followRequestActionOperation = null;
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
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setFollowRequestActionInProgress(bool followRequestActionInProgress) {
    setState(() {
      _isFollowRequestActionInProgress = followRequestActionInProgress;
    });
  }
}
