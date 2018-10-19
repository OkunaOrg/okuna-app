import 'package:flutter/material.dart';

class MainAvatarDrawerOpener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: _buildUserAvatar(),
            ),
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        )
      ],
    );
  }

  Widget _buildUserAvatar(){
    return Image.asset('assets/images/avatar.png');
  }
}
