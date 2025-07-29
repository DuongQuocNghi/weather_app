import 'dart:async';
import 'package:flutter/material.dart';

class Throttler {
  final Duration delay;
  Timer? _timer;
  bool _isThrottled = false;

  Throttler({this.delay = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    if (!_isThrottled) {
      action();
      _isThrottled = true;
      _timer = Timer(delay, () {
        _isThrottled = false;
      });
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}

class ThrottlerExample extends StatefulWidget {
  @override
  _ThrottlerExampleState createState() => _ThrottlerExampleState();
}

class _ThrottlerExampleState extends State<ThrottlerExample> {
  final Throttler _throttler = Throttler(delay: Duration(milliseconds: 1000));
  int _counter = 0;

  void _handleButtonPress() {
    _throttler.run(() {
      setState(() {
        _counter++;
      });
      print('Button pressed! Counter: $_counter');
    });
  }

  @override
  void dispose() {
    _throttler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Throttler Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleButtonPress,
              child: Text('Press Multiple Times Quickly'),
            ),
            SizedBox(height: 20),
            Text('Try pressing the button multiple times quickly.\nOnly the first press will be processed.'),
          ],
        ),
      ),
    );
  }
}