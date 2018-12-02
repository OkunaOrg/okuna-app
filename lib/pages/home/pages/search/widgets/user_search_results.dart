import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBUserSearchResults extends StatelessWidget {
  final List<User> results;
  final String searchQuery;
  final OnSearchUserPressed onSearchUserPressed;

  OBUserSearchResults(this.results, this.searchQuery,
      {Key key, @required this.onSearchUserPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return results.length > 0 ? _buildSearchResults() : _buildNoResults();
  }

  Widget _buildSearchResults() {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          User user = results[index];

          return ListTile(
            onTap: () {
              onSearchUserPressed(user);
            },
            leading: OBUserAvatar(
              size: OBUserAvatarSize.medium,
              avatarUrl: user.getProfileAvatar(),
            ),
            title: Text(
              user.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(children: [
              Text(user.getProfileName()),
              user.isFollowing ? Text(' · Following') : SizedBox()
            ]),
          );
        });
  }

  Widget _buildNoResults() {
    return Container(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.sentiment_dissatisfied,
                  size: 30.0, color: Colors.black26),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'No user found matching \'$searchQuery\'.',
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef void OnSearchUserPressed(User user);
