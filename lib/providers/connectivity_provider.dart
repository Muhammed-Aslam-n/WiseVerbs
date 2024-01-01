
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityProvider extends ChangeNotifier {
  static final ConnectivityProvider _instance =
  ConnectivityProvider._internal();

  factory ConnectivityProvider() => _instance;

  ConnectivityProvider._internal();

  bool _isConnected = true; // Assume initially connected

  bool get isConnected => _isConnected;

  void initConnectivity() async{
    debugPrint('connectivityListenerInitiated');
    if(await Connectivity().checkConnectivity() != ConnectivityResult.none){
      _isConnected = true;
    }else{
      _isConnected = false;
    }
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        debugPrint('No Connectivity Found');
        // No internet connection
        _isConnected = false;
      } else {
        debugPrint('Connectivity Found');
        _isConnected = true;
      }
      notifyListeners();
    });
  }
}
