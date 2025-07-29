import 'package:flutter/material.dart';

class SimpleFlagExample extends StatefulWidget {
  @override
  _SimpleFlagExampleState createState() => _SimpleFlagExampleState();
}

class _SimpleFlagExampleState extends State<SimpleFlagExample> {
  bool _isProcessing = false;
  int _counter = 0;

  void _handleButtonPress() async {
    if (_isProcessing) {
      print('Action is already in progress, ignoring this call');
      return;
    }

    _isProcessing = true;
    
    // Simulate some async work
    await Future.delayed(Duration(milliseconds: 2000));
    
    setState(() {
      _counter++;
    });
    
    print('Button pressed! Counter: $_counter');
    _isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Flag Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleButtonPress,
              child: Text(_isProcessing ? 'Processing...' : 'Press Multiple Times'),
            ),
            SizedBox(height: 20),
            if (_isProcessing)
              Text('Action is in progress...', style: TextStyle(color: Colors.orange)),
            SizedBox(height: 20),
            Text('Try pressing the button multiple times quickly.\nOnly the first press will be processed.'),
          ],
        ),
      ),
    );
  }
}