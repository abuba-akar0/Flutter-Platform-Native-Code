import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Channel Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // MethodChannel declaration (static const).
  static const MethodChannel _methodChannel =
  const MethodChannel('platformchannel.companyname.com/deviceinfo');

  // The variable that will hold device info returned from host.
  String _deviceInfo = '';

  @override
  void initState() {
    super.initState();
    // Call _getDeviceInfo when app starts.
    _getDeviceInfo();
  }

  // Async method that invokes the host method and updates state.
  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      final String? result = await _methodChannel.invokeMethod('getDeviceInfo');
      deviceInfo = result ?? 'No device info returned';
    } on PlatformException catch (e) {
      deviceInfo = "Failed to get device info: '${e.message}'.";
    }

    setState(() {
      _deviceInfo = deviceInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Platform Channel - Client')),
      body: SafeArea(
        child: ListTile(
          title: Text(
            'Device info:',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _deviceInfo,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.all(16.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDeviceInfo,
        child: Icon(Icons.refresh),
        tooltip: 'Refresh device info',
      ),
    );
  }
}
