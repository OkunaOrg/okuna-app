import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/tiles/circle_selectable_tile.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBPostAudienceSearchResults extends StatelessWidget {
  final List<Circle> results;
  final List<Circle> selectedCircles;
  final List<Circle> disabledCircles;

  final String searchQuery;
  final OnCirclePressed onCirclePressed;

  OBPostAudienceSearchResults(this.results, this.searchQuery,
      {Key key,
      @required this.onCirclePressed,
      @required this.selectedCircles,
      @required this.disabledCircles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return results.length == 0 && searchQuery.isNotEmpty
        ? _buildNoResults()
        : _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          Circle circle = results[index];
          bool isSelected = selectedCircles.contains(circle);
          bool isDisabled = disabledCircles.contains(circle);

          return OBCircleSelectableTile(
            circle,
            isSelected: isSelected,
            isDisabled: isDisabled,
            onCirclePressed: onCirclePressed,
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
              const SizedBox(
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
