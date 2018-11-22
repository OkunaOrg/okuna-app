import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/pages/home/modals/react_to_post/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmojiSearchResults extends StatelessWidget {
  final List<Emoji> results;
  final String searchQuery;

  OBEmojiSearchResults(this.results, this.searchQuery, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return results.length > 0 ? _buildSearchResults() : _buildNoResults();
  }

  Widget _buildSearchResults() {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          Emoji emoji = results[index];

          return ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 25),
              child: CachedNetworkImage(
                imageUrl: emoji.image,
                placeholder:
                    Image(image: AssetImage('assets/images/loading.gif')),
                errorWidget: Container(
                  child: Center(child: Text('?')),
                ),
              ),
            ),
            title: Text(emoji.keyword),
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
              Icon(Icons.sentiment_dissatisfied, size: 30.0, color: Colors.black26),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'No emoji found matching \'$searchQuery\'.',
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
