import 'package:Openbook/models/post.dart';
import 'package:flutter/material.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post _post;

  OBPostBodyImage(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Image( image: NetworkImage(_post.getImage())),
    );
  }
}
