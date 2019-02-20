import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/widgets/favorite_communities.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/widgets/joined_communities.dart';
import 'package:flutter/cupertino.dart';

class OBMyCommunities extends StatelessWidget {

  final ScrollController scrollController;

  const OBMyCommunities({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[OBFavoriteCommunities(), OBJoinedCommunities()],
        ),
      ),
    );
  }
}
