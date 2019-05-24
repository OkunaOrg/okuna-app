import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';

String modelTypeToString(dynamic modelInstance) {
  if (modelInstance is Post) {
    return 'post';
  } else if (modelInstance is PostComment) {
    return 'post comment';
  } else if (modelInstance is Community) {
    return 'community';
  } else if (modelInstance is User) {
    return 'user';
  }
  return 'item';
}
