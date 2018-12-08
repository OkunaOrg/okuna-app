import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmojiSearchResults extends StatelessWidget {
  final List<Emoji> results;
  final String searchQuery;
  final OnEmojiPressed onEmojiPressed;

  OBEmojiSearchResults(this.results, this.searchQuery,
      {Key key, @required this.onEmojiPressed})
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
            onTap: () {
              onEmojiPressed(emoji);
            },
            leading: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 25),
              child: CachedNetworkImage(
                imageUrl: emoji.image,
                placeholder:
                    Image(image: AssetImage('assets/images/loading.gif')),
                errorWidget: Container(
                  child: Center(child: OBPrimaryText('?')),
                ),
              ),
            ),
            title: OBPrimaryText(emoji.keyword),
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
              OBIcon(OBIcons.sad, customSize: 30.0),
              SizedBox(
                height: 20.0,
              ),
              OBPrimaryText(
                'No emoji found matching \'$searchQuery\'.',
                style: TextStyle(
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
