import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:flutter/material.dart';

class WaitlistSubscribeArguments {
  int count;

  WaitlistSubscribeArguments({this.count});

}

class OBWaitlistSubscribeDoneStep extends StatefulWidget {
  final int count;

  OBWaitlistSubscribeDoneStep({@required this.count});

  @override
  State<StatefulWidget> createState() {
    return OBWaitlistSubscribeDoneStepState();
  }
}

class OBWaitlistSubscribeDoneStepState extends State<OBWaitlistSubscribeDoneStep> {
  LocalizationService localizationService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;

    return Scaffold(
      body: Container(
        child: Center(child: SingleChildScrollView(child: _buildAllSet())),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _buildNextButton(context: context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllSet() {
    String congratulationsText = localizationService.trans('AUTH.CREATE_ACC.CONGRATULATIONS');
    String countText = localizationService.trans('AUTH.CREATE_ACC.YOUR_SUBSCRIBED');

    return Column(
        children: <Widget>[
          Text(
            '👍‍',
            style: TextStyle(fontSize: 45.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(congratulationsText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                //color: Colors.white
              )),
          const SizedBox(
            height: 20.0,
          ),
          Text(countText.replaceFirst('{0}', widget.count.toString()),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ]
    );
  }

  Widget _buildNextButton({@required BuildContext context}) {

    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Done',
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      onPressed: () {
        Navigator.popUntil(context, (route){
          return route.isFirst;
        });
        Navigator.pushReplacementNamed(context, '/auth');
      },
    );
  }
}
