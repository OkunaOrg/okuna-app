import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;
  OnWantsToReactToPost onWantsToReactToPost;

  OBPostActionReact(this._post, {this.onWantsToReactToPost});

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    var userService = provider.userService;

    return StreamBuilder(
      initialData: _post.reaction,
      stream: _post.reactionChangeSubject,
      builder: (BuildContext context, AsyncSnapshot<PostReaction> snapshot) {
        PostReaction reaction = snapshot.data;
        bool hasReaction = reaction != null;

        return FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                hasReaction
                    ? CachedNetworkImage(
                        height: 18.0,
                        imageUrl: reaction.getEmojiImage(),
                        placeholder: SizedBox(),
                        errorWidget: Container(
                          child: Center(child: Text('?')),
                        ),
                      )
                    : OBIcon(OBIcons.react),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  hasReaction ? 'Reacted' : 'React',
                  style: TextStyle(
                    color: hasReaction ? Colors.white : Colors.black,
                    fontWeight:
                        hasReaction ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            color: hasReaction
                ? Pigment.fromString(reaction.getEmojiColor())
                : Color.fromARGB(5, 0, 0, 0),
            onPressed: () async {
              if (hasReaction) {
                await userService.deletePostReaction(
                    postReaction: reaction, post: _post);
                _post.clearReaction();
              } else if (onWantsToReactToPost != null) {
                onWantsToReactToPost(_post);
              }
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(50.0)));
      },
    );
  }
}

typedef void OnWantsToReactToPost(Post post);
