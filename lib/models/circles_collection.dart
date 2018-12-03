import 'package:Openbook/models/list.dart';

class OBListsCollection {
  final List<OBList> lists;

  OBListsCollection({
    this.lists,
  });

  factory OBListsCollection.fromJson(List<dynamic> parsedJson) {
    List<OBList> lists =
        parsedJson.map((listJson) => OBList.fromJSON(listJson)).toList();

    return OBListsCollection(
      lists: lists,
    );
  }
}
