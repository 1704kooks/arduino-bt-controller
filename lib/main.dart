import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';

void main() {
  runApp(const ArduinoBluetoothApp());
}

class ArduinoBluetoothApp extends StatelessWidget {
  const ArduinoBluetoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arduino Bluetooth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ArduinoControllerPage(),
    );
  }
}

class ArduinoControllerPage extends StatefulWidget {
  const ArduinoControllerPage({super.key});

  @override
  State<ArduinoControllerPage> createState() =>
      _ArduinoControllerPageState();
}

class _ArduinoControllerPageState extends State<ArduinoControllerPage> {
  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();

  bool _isConnected = false;
  bool _isConnecting = false;
  bool _ledOn = false;

  String _status = 'HC-05 : Not Connected';

  Future<void> connectHC05() async {
    setState(() {
      _isConnecting = true;
      _status = 'HC-05 : Searching...';
    });

    try {
      final devices = await _bluetooth.getPairedDevices();

      BluetoothDevice? hc05;

      for (final device in devices) {
        if (device.name.toUpperCase().contains('HC-05')) {
          hc05 = device;
          break;
        }
      }

      if (hc05 == null) {
        setState(() {
          _status = 'HC-05 : Paired device not found';
          _isConnecting = false;
        });
        return;
      }

      setState(() {
        _status = 'HC-05 : Connecting...';
      });

      final success = await _bluetooth.connect(hc05.address);

      setState(() {
        _isConnected = success;
        _isConnecting = false;

        if (success) {
          _status = 'HC-05 : Connected';
        } else {
          _status = 'HC-05 : Connection Failed';
        }
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isConnecting = false;
        _status = 'HC-05 : Error';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bluetooth Error: $e'),
          ),
        );
      }
    }
  }

  Future<void> turnLedOn() async {
    if (!_isConnected) return;

    try {
      final success = await _bluetooth.sendString('1');

      if (success) {
        setState(() {
          _ledOn = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Send Error: $e'),
          ),
        );
      }
    }
  }

  Future<void> turnLedOff() async {
    if (!_isConnected) return;

    try {
      final success = await _bluetooth.sendString('0');

      if (success) {
        setState(() {
          _ledOn = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Send Error: $e'),
          ),
        );
      }
    }
  }

  Future<void> disconnectHC05() async {
  try {
    await _bluetooth.disconnect();

    setState(() {
      _isConnected = false;
      _ledOn = false;
      _status = 'HC-05 : Not Connected';
    });
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disconnect Error: $e'),
        ),
      );
    }
  }
}

  @override
  void dispose() {
    if (_isConnected) {
      _bluetooth.disconnect();
    }

    _bluetooth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arduino Bluetooth'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isConnected ? Colors.green : Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isConnecting
                ? null
                : (_isConnected ? disconnectHC05 : connectHC05),
              child: Text(
  _isConnecting
      ? 'Connecting...'
      : (_isConnected ? 'Disconnect HC-05' : 'Connect HC-05'),
),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isConnected ? turnLedOn : null,
              child: const Text('LED ON'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isConnected ? turnLedOff : null,
              child: const Text('LED OFF'),
            ),

            const SizedBox(height: 40),

            Text(
              _ledOn ? 'LED Status : ON' : 'LED Status : OFF',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}