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
      title: 'Arduino Bluetooth Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BluetoothControllerPage(),
    );
  }
}

class BluetoothControllerPage extends StatefulWidget {
  const BluetoothControllerPage({super.key});

  @override
  State<BluetoothControllerPage> createState() =>
      _BluetoothControllerPageState();
}

class _BluetoothControllerPageState extends State<BluetoothControllerPage> {
  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();

  bool _isConnected = false;
  bool _isConnecting = false;
  bool _ledOn = false;

  String _status = 'Not Connected';

  Future<void> connectHC05() async {
    setState(() {
      _isConnecting = true;
      _status = 'Searching for HC-05...';
    });

    try {
      final devices = await _bluetooth.getPairedDevices();

      final hc05 = devices.firstWhere(
        (device) =>
            (device.name ?? '').toUpperCase().contains('HC-05'),
      );

      setState(() {
        _status = 'Connecting to HC-05...';
      });

      final success = await _bluetooth.connect(hc05.address);

      if (!mounted) return;

      setState(() {
        _isConnected = success;
        _status = success ? 'HC-05 Connected' : 'Connection Failed';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isConnected = false;
        _status = 'HC-05 Not Found';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  Future<void> disconnectHC05() async {
    try {
      await _bluetooth.disconnect();
    } finally {
      if (!mounted) return;

      setState(() {
        _isConnected = false;
        _ledOn = false;
        _status = 'Not Connected';
      });
    }
  }

  Future<void> turnLedOn() async {
    if (!_isConnected) return;

    await _bluetooth.sendString('1');

    if (!mounted) return;

    setState(() {
      _ledOn = true;
    });
  }

  Future<void> turnLedOff() async {
    if (!_isConnected) return;

    await _bluetooth.sendString('0');

    if (!mounted) return;

    setState(() {
      _ledOn = false;
    });
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
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Arduino Controller',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Icon(
                Icons.memory,
                size: 70,
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              const Text(
                'Arduino Bluetooth',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'HC-05 Wireless Controller',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // Bluetooth connection card
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _isConnected
                                  ? Colors.green.shade50
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.bluetooth,
                              color: _isConnected
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'HC-05',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _status,
                                  style: TextStyle(
                                    color: _isConnected
                                        ? Colors.green
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            _isConnected
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _isConnected
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isConnecting
                              ? null
                              : (_isConnected
                                  ? disconnectHC05
                                  : connectHC05),
                          icon: Icon(
                            _isConnected
                                ? Icons.bluetooth_disabled
                                : Icons.bluetooth_connected,
                          ),
                          label: Text(
                            _isConnecting
                                ? 'Connecting...'
                                : (_isConnected
                                    ? 'Disconnect HC-05'
                                    : 'Connect HC-05'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LED control card
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'LED CONTROL',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _ledOn
                              ? Colors.amber.shade100
                              : Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          size: 58,
                          color: _ledOn
                              ? Colors.amber.shade700
                              : Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        _ledOn ? 'LED ON' : 'LED OFF',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _ledOn
                              ? Colors.amber.shade800
                              : Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton.icon(
                                onPressed:
                                    _isConnected ? turnLedOn : null,
                                icon: const Icon(Icons.power_settings_new),
                                label: const Text('LED ON'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton.icon(
                                onPressed:
                                    _isConnected ? turnLedOff : null,
                                icon: const Icon(Icons.power_off),
                                label: const Text('LED OFF'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                _isConnected
                    ? 'Bluetooth connection ready'
                    : 'Connect HC-05 to enable LED control',
                style: TextStyle(
                  color: _isConnected
                      ? Colors.green.shade700
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}