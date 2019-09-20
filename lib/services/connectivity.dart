import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamSubscription _connectivityChangeSubscription;
  ConnectivityResult _connectivity;

  ConnectivityService() {
    _bootstrapConectivity();
  }

  void _bootstrapConectivity() async {
    _connectivity = await Connectivity().checkConnectivity();
    _connectivityChangeSubscription =
        onConnectivityChange(_onConnectivityChange);
  }

  void dispose() {
    _connectivityChangeSubscription.cancel();
  }

  StreamSubscription onConnectivityChange(onConnectivityChange) {
    return Connectivity().onConnectivityChanged.listen(onConnectivityChange);
  }

  ConnectivityResult getConnectivity() {
    return _connectivity;
  }

  void _onConnectivityChange(ConnectivityResult connectivity) {
    _connectivity = connectivity;
  }
}
