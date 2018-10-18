import 'package:flutter/material.dart';

class MainDrawerHeaderAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(10.0)),
          height: 39.0,
          width: 39.0,
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: _buildUserAvatar(),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  child: Icon(Icons.more_horiz),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 25.0,
                  width: 25.0),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildUserAvatar(){
    return Image.asset('assets/images/avatar.png');
  }
}
