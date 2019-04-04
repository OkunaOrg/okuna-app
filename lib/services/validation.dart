import 'dart:io';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/communities_api.dart';
import 'package:Openbook/services/connections_circles_api.dart';
import 'package:Openbook/services/follows_lists_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:validators/validators.dart' as validators;

class ValidationService {
  AuthApiService _authApiService;
  CommunitiesApiService _communitiesApiService;
  FollowsListsApiService _followsListsApiService;
  ConnectionsCirclesApiService _connectionsCirclesApiService;

  static const int USERNAME_MAX_LENGTH = 30;
  static const int COMMUNITY_NAME_MAX_LENGTH = 32;
  static const int COMMUNITY_TITLE_MAX_LENGTH = 32;
  static const int COMMUNITY_DESCRIPTION_MAX_LENGTH = 500;
  static const int COMMUNITY_USER_ADJECTIVE_MAX_LENGTH = 16;
  static const int COMMUNITY_RULES_MAX_LENGTH = 1500;
  static const int POST_MAX_LENGTH = 1120;
  static const int POST_COMMENT_MAX_LENGTH = 560;
  static const int PASSWORD_MIN_LENGTH = 10;
  static const int PASSWORD_MAX_LENGTH = 100;
  static const int CIRCLE_MAX_LENGTH = 100;
  static const int COLOR_ATTR_MAX_LENGTH = 7;
  static const int LIST_MAX_LENGTH = 100;
  static const int PROFILE_NAME_MAX_LENGTH = 192;
  static const int PROFILE_NAME_MIN_LENGTH = 1;
  static const int PROFILE_LOCATION_MAX_LENGTH = 64;
  static const int PROFILE_BIO_MAX_LENGTH = 150;
  static const int POST_REPORT_COMMENT_MAX_LENGTH = 560;
  static const int POST_IMAGE_MAX_SIZE = 20971520;
  static const int AVATAR_IMAGE_MAX_SIZE = 10485760;
  static const int COVER_IMAGE_MAX_SIZE = 10485760;

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setCommunitiesApiService(CommunitiesApiService communitiesApiService) {
    _communitiesApiService = communitiesApiService;
  }

  void setFollowsListsApiService(
      FollowsListsApiService followsListsApiService) {
    _followsListsApiService = followsListsApiService;
  }

  void setConnectionsCirclesApiService(
      ConnectionsCirclesApiService connectionsCirclesApiService) {
    _connectionsCirclesApiService = connectionsCirclesApiService;
  }

  bool isQualifiedEmail(String email) {
    return validators.isEmail(email);
  }

  bool isQualifiedLink(String link) {
    final uri = Uri.decodeFull(link);
    return isUrl(uri) && validators.contains(uri, '?token=');
  }

  bool isUrl(String url) {
    return validators.isURL(url);
  }

  bool isAlphanumericWithSpaces(String str) {
    String p = r'^[a-z0-9\s]+$';

    RegExp regExp = new RegExp(p, caseSensitive: false);

    return regExp.hasMatch(str);
  }

  bool isAlphanumericWithUnderscores(String str) {
    String p = r'^[a-zA-Z0-9_]+$';

    RegExp regExp = new RegExp(p, caseSensitive: false);

    return regExp.hasMatch(str);
  }

  bool isPasswordAllowedLength(String password) {
    return password.length >= PASSWORD_MIN_LENGTH &&
        password.length <= PASSWORD_MAX_LENGTH;
  }

  bool isPostTextAllowedLength(String postText) {
    return postText.length < POST_MAX_LENGTH;
  }

  bool isBioAllowedLength(String bio) {
    return bio.length > 0 && bio.length < PROFILE_BIO_MAX_LENGTH;
  }

  bool isLocationAllowedLength(String location) {
    return location.length > 0 && location.length < PROFILE_LOCATION_MAX_LENGTH;
  }

  bool isUsernameAllowedLength(String username) {
    return username.length > 0 && username.length < USERNAME_MAX_LENGTH;
  }

  bool isPostCommentAllowedLength(String postComment) {
    return postComment.length > 0 &&
        postComment.length < POST_COMMENT_MAX_LENGTH;
  }

  bool isCommunityNameAllowedLength(String name) {
    return name.length > 0 && name.length < COMMUNITY_NAME_MAX_LENGTH;
  }

  bool isCommunityDescriptionAllowedLength(String description) {
    return description.length > 0 &&
        description.length < COMMUNITY_DESCRIPTION_MAX_LENGTH;
  }

  bool isCommunityTitleAllowedLength(String title) {
    return title.length > 0 && title.length < COMMUNITY_TITLE_MAX_LENGTH;
  }

  bool isCommunityRulesAllowedLength(String rules) {
    return rules.length > 0 && rules.length < COMMUNITY_RULES_MAX_LENGTH;
  }

  bool isCommunityUserAdjectiveAllowedLength(String userAdjective) {
    return userAdjective.length > 0 &&
        userAdjective.length < COMMUNITY_USER_ADJECTIVE_MAX_LENGTH;
  }

  bool isPostReportCommentAllowedLength(String commentText) {
    return commentText.length < POST_REPORT_COMMENT_MAX_LENGTH;
  }

  bool isFollowsListNameAllowedLength(String followsList) {
    return followsList.length > 0 && followsList.length < LIST_MAX_LENGTH;
  }

  bool isConnectionsCircleNameAllowedLength(String connectionsCircle) {
    return connectionsCircle.length > 0 &&
        connectionsCircle.length < CIRCLE_MAX_LENGTH;
  }

  bool isUsernameAllowedCharacters(String username) {
    String p = r'^[a-zA-Z0-9_.]+$';

    RegExp regExp = new RegExp(p, caseSensitive: false);

    return regExp.hasMatch(username);
  }

  bool isCommunityNameAllowedCharacters(String name) {
    String p = r'^[a-zA-Z0-9_]+$';

    RegExp regExp = new RegExp(p, caseSensitive: false);

    return regExp.hasMatch(name);
  }

  Future<bool> isUsernameTaken(String username) async {
    HttpieResponse response =
        await _authApiService.checkUsernameIsAvailable(username: username);
    if (response.isAccepted()) {
      return false;
    } else if (response.isBadRequest()) {
      return true;
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<bool> isCommunityNameTaken(String name) async {
    HttpieResponse response =
        await _communitiesApiService.checkNameIsAvailable(name: name);
    if (response.isAccepted()) {
      return false;
    } else if (response.isBadRequest()) {
      return true;
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<bool> isEmailTaken(String email) async {
    HttpieResponse response =
        await _authApiService.checkEmailIsAvailable(email: email);
    if (response.isAccepted()) {
      return false;
    } else if (response.isBadRequest()) {
      return true;
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<bool> isFollowsListNameTaken(String name) async {
    HttpieResponse response =
        await _followsListsApiService.checkNameIsAvailable(name: name);
    if (response.isAccepted()) {
      return false;
    } else if (response.isBadRequest()) {
      return true;
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<bool> isConnectionsCircleNameTaken(String name) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.checkNameIsAvailable(name: name);
    if (response.isAccepted()) {
      return false;
    } else if (response.isBadRequest()) {
      return true;
    } else {
      throw HttpieRequestError(response);
    }
  }

  bool isNameAllowedLength(String name) {
    return name.length >= PROFILE_NAME_MIN_LENGTH &&
        name.length <= PROFILE_NAME_MAX_LENGTH;
  }

  Future<bool> isImageAllowedSize(File image, OBImageType type) async {
    int size = await image.length();
    return size <= getAllowedImageSize(type);
  }

  int getAllowedImageSize(OBImageType type) {
    if (type == OBImageType.avatar) {
      return AVATAR_IMAGE_MAX_SIZE;
    } else if (type == OBImageType.cover) {
      return COVER_IMAGE_MAX_SIZE;
    } else {
      return POST_IMAGE_MAX_SIZE;
    }
  }

  String validateUserUsername(String username) {
    assert(username != null);

    String errorMsg;

    if (username.length == 0) {
      errorMsg = 'Username cannot be empty.';
    } else if (!isUsernameAllowedLength(username)) {
      errorMsg =
          'A username can\'t be longer than $USERNAME_MAX_LENGTH characters.';
    } else if (!isUsernameAllowedCharacters(username)) {
      errorMsg =
          'A username can only contain alphanumeric characters and underscores.';
    }

    return errorMsg;
  }

  String validatePostComment(String postComment) {
    assert(postComment != null);

    String errorMsg;

    if (postComment.length == 0) {
      errorMsg = 'Comment cannot be empty.';
    } else if (!isPostCommentAllowedLength(postComment)) {
      errorMsg =
          'A comment can\'t be longer than $POST_COMMENT_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validateUserEmail(String email) {
    assert(email != null);

    String errorMsg;

    if (email.length == 0) {
      errorMsg = 'Email cannot be empty.';
    } else if (!isQualifiedEmail(email)) {
      errorMsg = 'Please provide a valid email.';
    }

    return errorMsg;
  }

  String validateUserRegistrationLink(String link) {
    assert(link != null);

    String errorMsg;

    if (link.length == 0) {
      errorMsg = 'Link cannot be empty.';
    } else if (!isQualifiedLink(link)) {
      errorMsg = 'This link appears to be invalid';
    }

    return errorMsg;
  }

  String validateUserPassword(String password) {
    assert(password != null);

    String errorMsg;

    if (password.length == 0) {
      errorMsg = 'Password can\'t be empty.';
    } else if (!isPasswordAllowedLength(password)) {
      errorMsg =
          'Password must be between $PASSWORD_MIN_LENGTH and $PASSWORD_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validateUserProfileName(String name) {
    assert(name != null);

    String errorMsg;

    if (name.isEmpty) {
      errorMsg = 'Name can\'t be empty.';
    } else if (!isNameAllowedLength(name)) {
      errorMsg =
          'Name must be between $PROFILE_NAME_MIN_LENGTH and $PROFILE_NAME_MAX_LENGTH characters.';
    }
    return errorMsg;
  }

  String validateUserProfileUrl(String url) {
    assert(url != null);

    if (url.isEmpty) return null;

    String errorMsg;

    if (!isUrl(url)) {
      errorMsg = 'Please provide a valid url.';
    }

    return errorMsg;
  }

  String validateUserProfileLocation(String location) {
    assert(location != null);

    if (location.isEmpty) return null;

    String errorMsg;

    if (!isLocationAllowedLength(location)) {
      errorMsg =
          'Location can\'t be longer than $PROFILE_LOCATION_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validateUserProfileBio(String bio) {
    assert(bio != null);

    if (bio.isEmpty) return null;

    String errorMsg;

    if (!isBioAllowedLength(bio)) {
      errorMsg =
          'Bio can\'t be longer than $PROFILE_BIO_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validateFollowsListName(String name) {
    assert(name != null);

    String errorMsg;

    if (name.length == 0) {
      errorMsg = 'List name cannot be empty.';
    } else if (!isFollowsListNameAllowedLength(name)) {
      errorMsg =
          'List name must be no longer than $LIST_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validateConnectionsCircleName(String name) {
    assert(name != null);

    String errorMsg;

    if (name.length == 0) {
      errorMsg = 'List name cannot be empty.';
    } else if (!isConnectionsCircleNameAllowedLength(name)) {
      errorMsg =
          'List name must be no longer than $LIST_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validateCommunityName(String name) {
    assert(name != null);

    String errorMsg;

    if (name.length == 0) {
      errorMsg = 'Name cannot be empty.';
    } else if (!isCommunityNameAllowedLength(name)) {
      errorMsg =
          'Name can\'t be longer than $COMMUNITY_NAME_MAX_LENGTH characters.';
    } else if (!isCommunityNameAllowedCharacters(name)) {
      errorMsg =
          'Name can only contain alphanumeric characters and underscores.';
    }

    return errorMsg;
  }

  String validateCommunityTitle(String title) {
    assert(title != null);

    String errorMsg;

    if (title.length == 0) {
      errorMsg = 'Title cannot be empty.';
    } else if (!isCommunityTitleAllowedLength(title)) {
      errorMsg =
          'Title can\'t be longer than $COMMUNITY_TITLE_MAX_LENGTH characters.';
    }
    return errorMsg;
  }

  String validateCommunityRules(String rules) {
    assert(rules != null);

    if (rules.isEmpty) return null;

    String errorMsg;

    if (rules.length == 0) {
      errorMsg = 'Rules cannot be empty.';
    } else if (!isCommunityRulesAllowedLength(rules)) {
      errorMsg =
          'Rules can\'t be longer than $COMMUNITY_RULES_MAX_LENGTH characters.';
    }
    return errorMsg;
  }

  String validateCommunityDescription(String description) {
    assert(description != null);

    if (description.isEmpty) return null;

    String errorMsg;

    if (!isCommunityDescriptionAllowedLength(description)) {
      errorMsg =
          'Description can\'t be longer than $COMMUNITY_DESCRIPTION_MAX_LENGTH characters.';
    }
    return errorMsg;
  }

  String validateCommunityUserAdjective(String userAdjective) {
    assert(userAdjective != null);

    if (userAdjective.isEmpty) return null;

    String errorMsg;

    if (!isCommunityUserAdjectiveAllowedLength(userAdjective)) {
      errorMsg =
          'Adjectives can\'t be longer than $COMMUNITY_USER_ADJECTIVE_MAX_LENGTH characters.';
    }

    return errorMsg;
  }

  String validatePostReportComment(String commentText) {
    String errorMsg;
    if (!isPostReportCommentAllowedLength(commentText)) {
      errorMsg =
      'Comment cannot be longer than $POST_REPORT_COMMENT_MAX_LENGTH characters.';
    }
    return errorMsg;
  }
}
