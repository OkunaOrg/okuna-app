
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatelessWidget{

  final Post _post;

  OBPostActionReact(this._post);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OBIcon(OBIcons.react, size: OBIconSize.medium,),
          SizedBox(width: 10.0,),
          Text('React')
        ],
      ),
    );
  }
}