import 'package:Openbook/models/follow_list.dart';

// UGH naming

class FollowListsList {
  final List<FollowList> lists;

  FollowListsList({
    this.lists,
  });

  factory FollowListsList.fromJson(List<dynamic> parsedJson) {
    List<FollowList> lists =
        parsedJson.map((listJson) => FollowList.fromJSON(listJson)).toList();

    return FollowListsList(
      lists: lists,
    );
  }
}
