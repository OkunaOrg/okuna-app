import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCirclesSearchResults extends StatelessWidget {
  final List<Circle> results;
  final List<Circle> selectedCircles;

  final String searchQuery;
  final OnCirclePressed onCirclePressed;

  OBCirclesSearchResults(this.results, this.searchQuery,
      {Key key, @required this.onCirclePressed, @required this.selectedCircles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return results.length > 0 ? _buildSearchResults() : _buildNoResults();
  }

  Widget _buildSearchResults() {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          Circle circle = results[index];
          bool isSelected = selectedCircles.contains(circle);

          return ListTile(
            onTap: () {
              onCirclePressed(circle);
            },
            leading: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 25),
            ),
            title: OBText(circle.name),
          );
        });
  }

  Widget _buildNoResults() {
    return Container(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OBIcon(OBIcons.sad, customSize: 30.0),
              SizedBox(
                height: 20.0,
              ),
              OBText(
                'No circle found matching \'$searchQuery\'.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef void OnCirclePressed(Circle pressedCircle);
