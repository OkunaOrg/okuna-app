import 'dart:async';

import 'package:Okuna/models/communities_list.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
export 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';

class OBActionableSmartText extends StatefulWidget {
  final String text;
  final int maxlength;
  final OBTextSize size;
  final TextOverflow overflow;
  final TextOverflow lengthOverflow;
  final SmartTextElement trailingSmartTextElement;
  final Map<String, Hashtag> hashtagsMap;

  const OBActionableSmartText(
      {Key key,
      this.text,
      this.maxlength,
      this.size = OBTextSize.medium,
      this.overflow = TextOverflow.clip,
      this.lengthOverflow = TextOverflow.ellipsis,
      this.trailingSmartTextElement,
      this.hashtagsMap})
      : super(key: key);

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
  LocalizationService _localizationService;

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
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    return OBSmartText(
      text: widget.text,
      maxlength: widget.maxlength,
      overflow: widget.overflow,
      lengthOverflow: widget.lengthOverflow,
      onCommunityNameTapped: _onCommunityNameTapped,
      onUsernameTapped: _onUsernameTapped,
      onLinkTapped: _onLinkTapped,
      onHashtagTapped: _onHashtagNameHashtagRetrieved,
      trailingSmartTextElement: widget.trailingSmartTextElement,
      hashtagsMap: widget.hashtagsMap,
      size: widget.size,
    );
  }

  void _onCommunityNameTapped(String communityName) {
    _clearRequestSubscription();
    // [TODO] The getCommunity is too slow for retrieving on tap.
    //  When we process c/communities inside posts in the same way as hashtags,
    //  the model will already be included and therefore there will be no need
    // to retrieve anything. Therefore, for now a "hotfix" for a faster get
    // community using the SEARCH api instead of the GET of communities to
    // retrieve a lighter model
    StreamSubscription requestSubscription = _userService
        .getCommunitiesWithQuery(communityName, count: 1)
        .asStream()
        .listen((CommunitiesList communities) {
      if (communities.communities.isNotEmpty) {
        Community community = communities.communities.first;
        if (community.name.toLowerCase() == communityName.toLowerCase()) {
          _navigationService.navigateToCommunity(
              community: community, context: context);
          return;
        }
      }

      _toastService.error(
          message: _localizationService.post__community_not_found,
          context: context);
    }, onError: _onError, onDone: _onRequestDone);
    _setRequestSubscription(requestSubscription);
  }

  // Please see comments on _onCommunityNameTapped
  //void _onCommunityNameCommunityRetrieved(Community community) {}

  void _onUsernameTapped(String username) {
    _clearRequestSubscription();
    StreamSubscription requestSubscription = _userService
        .getUserWithUsername(username)
        .asStream()
        .listen(_onUsernameUserRetrieved,
            onError: _onError, onDone: _onRequestDone);
    _setRequestSubscription(requestSubscription);
  }

  void _onHashtagNameHashtagRetrieved(
      {Hashtag hashtag, String rawHashtagName}) {
    _navigationService.navigateToHashtag(
        hashtag: hashtag, rawHashtagName: rawHashtagName, context: context);
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
      _onError(error);
    }
  }

  void _onRequestDone() {
    _clearRequestSubscription();
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
