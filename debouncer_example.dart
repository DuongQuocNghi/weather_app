import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class DebouncerExample extends StatefulWidget {
  @override
  _DebouncerExampleState createState() => _DebouncerExampleState();
}

class _DebouncerExampleState extends State<DebouncerExample> {
  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  int _counter = 0;

  void _handleButtonPress() {
    _debouncer.run(() {
      setState(() {
        _counter++;
      });
      print('Button pressed! Counter: $_counter');
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debouncer Example')),
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
            Text('Try pressing the button multiple times quickly.\nOnly the last press will be processed.'),
          ],
        ),
      ),
    );
  }
}