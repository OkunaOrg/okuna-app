import 'package:Okuna/libs/str_utils.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/models/user.dart';

String modelTypeToString(dynamic modelInstance, {bool capitalize = false}) {
  String result;
  if (modelInstance is Post) {
    result = 'post';
  } else if (modelInstance is PostComment) {
    result = 'post comment';
  } else if (modelInstance is Community) {
    result = 'community';
  } else if (modelInstance is User) {
    result = 'user';
  } else {
    result = 'item';
  }

  return capitalize ? toCapital(result) : result;
}
