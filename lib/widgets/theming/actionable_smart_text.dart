import 'dart:async';

import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/url_launcher.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';

class OBActionableSmartText extends StatefulWidget {
  final String text;

  const OBActionableSmartText({Key key, this.text}) : super(key: key);

  @override
  OBActionableTextState createState() {
    return OBActionableTextState();
  }
}

class OBActionableTextState extends State<OBActionableSmartText> {
  NavigationService _navigationService;
  UserService _userService;
  UrlLauncherService _urlLauncherService;
  ToastService _toastService;

  bool _needsBootstrap;
  StreamSubscription _requestSubscription;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  void dispose() {
    super.dispose();
    _clearRequestSubscription();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _navigationService = openbookProvider.navigationService;
      _userService = openbookProvider.userService;
      _urlLauncherService = openbookProvider.urlLauncherService;
      _toastService = openbookProvider.toastService;
      _needsBootstrap = false;
    }

    return OBSmartText(
      text: widget.text,
      onCommunityNameTapped: _onCommunityNameTapped,
      onUsernameTapped: _onUsernameTapped,
      onLinkTapped: _onLinkTapped,
    );
  }

  void _onCommunityNameTapped(String communityName) {
    _clearRequestSubscription();

    StreamSubscription requestSubscription = _userService
        .getCommunityWithName(communityName)
        .asStream()
        .listen(_onCommunityNameCommunityRetrieved,
            onError: _onRequestError, onDone: _onRequestDone);
    _setRequestSubscription(requestSubscription);
  }

  void _onCommunityNameCommunityRetrieved(Community community) {
    _navigationService.navigateToCommunity(
        community: community, context: context);
  }

  void _onUsernameTapped(String username) {
    _clearRequestSubscription();
    StreamSubscription requestSubscription = _userService
        .getUserWithUsername(username)
        .asStream()
        .listen(_onUsernameUserRetrieved,
            onError: _onRequestError, onDone: _onRequestDone);
    _setRequestSubscription(requestSubscription);
  }

  void _onUsernameUserRetrieved(User user) {
    _navigationService.navigateToUserProfile(user: user, context: context);
  }

  void _onLinkTapped(String link) {
    try {
      _urlLauncherService.launchUrl(link);
    } on UrlLauncherUnsupportedUrlException {
      _toastService.info(message: 'Unsupported link', context: context);
    } catch (error) {
      _onUnkwnownError(error);
    }
  }

  void _onRequestDone() {
    _clearRequestSubscription();
  }

  void _onRequestError(error) {
    if (error is HttpieRequestError) {
      _onHttpieRequestError(error);
    } else if (error is HttpieConnectionRefusedError) {
      _onHttpieConnectionRefusedError(error);
    } else {
      _onUnkwnownError(error);
    }
  }

  void _onHttpieRequestError(HttpieRequestError error) async {
    String humanReadableError = await error.toHumanReadableMessage();
    _toastService.error(message: humanReadableError, context: context);
  }

  void _onHttpieConnectionRefusedError(HttpieConnectionRefusedError error) {
    _toastService.error(message: 'No internet connection', context: context);
  }

  void _onUnkwnownError(error) {
    _toastService.error(message: 'Unknown error', context: context);
    throw error;
  }

  void _clearRequestSubscription() {
    if (_requestSubscription != null) {
      _requestSubscription.cancel();
      _setRequestSubscription(null);
    }
  }

  void _setRequestSubscription(StreamSubscription requestSubscription) {
    _requestSubscription = requestSubscription;
  }
}
