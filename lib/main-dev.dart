import 'package:flutter/material.dart';
import 'package:Openbook/app.dart';
import 'package:Openbook/config.dart';

void main() {
  Config.appFlavor = Flavor.DEVELOPMENT;
  runApp(new MyApp());
}
