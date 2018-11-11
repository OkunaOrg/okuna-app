import 'package:Openbook/models/post.dart';
import 'package:flutter/material.dart';

class OBPostBodyImage extends StatelessWidget {
  final Post _post;

  OBPostBodyImage(this._post);

  @override
  Widget build(BuildContext context) {
    String imageUrl = _post.getImage();

    double screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenWidth),
        child: FadeInImage(
          placeholder: AssetImage('assets/images/loading.gif'),
          image: NetworkImage(imageUrl),
        ));
  }
}
