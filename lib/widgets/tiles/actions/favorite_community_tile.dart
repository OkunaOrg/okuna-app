import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBFavoriteCommunityTile extends StatefulWidget {
  final Community community;
  final VoidCallback onFavoritedCommunity;
  final VoidCallback onUnfavoritedCommunity;
  final Widget favoriteSubtitle;
  final Widget unfavoriteSubtitle;

  const OBFavoriteCommunityTile(
      {Key key,
      @required this.community,
      this.onFavoritedCommunity,
      this.onUnfavoritedCommunity,
      this.favoriteSubtitle,
      this.unfavoriteSubtitle})
      : super(key: key);

  @override
  OBFavoriteCommunityTileState createState() {
    return OBFavoriteCommunityTileState();
  }
}

class OBFavoriteCommunityTileState extends State<OBFavoriteCommunityTile> {
  UserService _userService;
  ToastService _toastService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        if (community == null) return const SizedBox();

        bool isFavorite = community.isFavorite;

        return ListTile(
          enabled: !_requestInProgress,
          leading: OBIcon(isFavorite
              ? OBIcons.unfavoriteCommunity
              : OBIcons.favoriteCommunity),
          title: OBText(
              isFavorite ? 'Unfavorite community' : 'Favorite community'),
          onTap: isFavorite ? _unfavoriteCommunity : _favoriteCommunity,
          subtitle:
              isFavorite ? widget.unfavoriteSubtitle : widget.favoriteSubtitle,
        );
      },
    );
  }

  void _favoriteCommunity() async {
    _setRequestInProgress(true);
    try {
      await _userService.favoriteCommunity(widget.community);
      if (widget.onFavoritedCommunity != null) widget.onFavoritedCommunity();
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unfavoriteCommunity() async {
    _setRequestInProgress(true);
    try {
      await _userService.unfavoriteCommunity(widget.community);
      if (widget.onUnfavoritedCommunity != null)
        widget.onUnfavoritedCommunity();
    } catch (e) {
      _onError(e);
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
