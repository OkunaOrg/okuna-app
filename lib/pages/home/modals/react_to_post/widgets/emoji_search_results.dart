import 'package:Openbook/models/emoji.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmojiSearchResults extends StatelessWidget {
  final List<Emoji> results;

  OBEmojiSearchResults(this.results, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
