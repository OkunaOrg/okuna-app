import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/widgets/favorite_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/widgets/joined_communities.dart';
import 'package:flutter/cupertino.dart';

class OBMyCommunities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[OBFavoriteCommunities(), OBJoinedCommunities()],
    );
  }
}
