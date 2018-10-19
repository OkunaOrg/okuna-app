
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePostModal extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              child: Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            middle: Text('Create post'),
            trailing: OBPrimaryButton(
              isSmall: true,
              onPressed: () {},
              child: Text('Post'),
            ),
          ),
          child: Center(
            child: Text('Communities Page Content'),
          )),
    );
  }
}