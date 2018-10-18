import 'package:flutter/material.dart';

class MainDrawerUserOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Vincent Ruijter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('@vincent', style: TextStyle(fontSize: 16.0),),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(135.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 2.0, height: 1,),
                  Text('Posts'),
                  SizedBox(width: 10.0, height: 1,),
                  Text('3.5k', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 2.0, height: 1,),
                  Text('Followers')
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
