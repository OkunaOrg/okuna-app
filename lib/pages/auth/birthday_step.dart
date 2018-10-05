import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthBirthdayStepPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text('Next', style: TextStyle(fontSize: 18.0)),
      onPressed: () {},
    );
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          SizedBox(
            width: 10.0,
          ),
          Text(
            'Previous',
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
