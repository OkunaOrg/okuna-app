import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;

  OBPostActionReact(this._post);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var modalService = openbookProvider.modalService;

    return StreamBuilder(
      stream: _post.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        Post post = snapshot.data;
        if (post == null) return SizedBox();
        PostReaction reaction = post.reaction;
        bool hasReaction = reaction != null;

        var onPressed = () async {
          if (hasReaction) {
            await userService.deletePostReaction(
                postReaction: reaction, post: _post);
            _post.clearReaction();
          } else {
            modalService.openReactToPost(post: _post, context: context);
          }
        };

        Widget buttonChild = Row(
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
                : OBIcon(OBIcons.react, customSize: 20.0,),
            SizedBox(
              width: 10.0,
            ),
            OBText(
              hasReaction ? reaction.getEmojiKeyword() : 'React',
              style: TextStyle(
                color: hasReaction ? Colors.white : null,
                fontWeight: hasReaction ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );

        return OBButton(
          child: buttonChild,
          onPressed: onPressed,
          type: hasReaction ? OBButtonType.primary : OBButtonType.highlight,
        );
      },
    );
  }
}

typedef void OnWantsToReactToPost(Post post);
