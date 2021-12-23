import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  Future<ConnectivityResult?> checkConnection() async {
    ConnectivityResult _connectionStatus = ConnectivityResult.none;

    final Connectivity _connectivity = Connectivity();
    // try {
      _connectionStatus = await _connectivity.checkConnectivity();
      return _connectionStatus;
    // } catch (e) {
    //   return null;
    // }
  }
}
