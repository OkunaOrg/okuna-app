import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
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
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          User user = results[index];

          return OBUserTile(
            user,
            onUserTilePressed: onSearchUserPressed,
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
              const SizedBox(
                height: 20.0,
              ),
              OBText(
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
