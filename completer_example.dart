import 'dart:async';
import 'package:flutter/material.dart';

class CompleterExample extends StatefulWidget {
  @override
  _CompleterExampleState createState() => _CompleterExampleState();
}

class _CompleterExampleState extends State<CompleterExample> {
  Completer<void>? _currentOperation;
  int _counter = 0;

  Future<void> _handleButtonPress() async {
    // If there's already an operation in progress, wait for it to complete
    if (_currentOperation != null) {
      print('Operation already in progress, waiting...');
      await _currentOperation!.future;
      return;
    }

    // Create a new completer for this operation
    _currentOperation = Completer<void>();

    try {
      // Simulate some async work
      await Future.delayed(Duration(milliseconds: 2000));
      
      setState(() {
        _counter++;
      });
      
      print('Button pressed! Counter: $_counter');
    } finally {
      // Complete the operation
      _currentOperation!.complete();
      _currentOperation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completer Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _currentOperation != null ? null : _handleButtonPress,
              child: Text(_currentOperation != null ? 'Processing...' : 'Press Multiple Times'),
            ),
            SizedBox(height: 20),
            if (_currentOperation != null)
              Text('Operation in progress...', style: TextStyle(color: Colors.orange)),
            SizedBox(height: 20),
            Text('Try pressing the button multiple times quickly.\nOnly the first press will be processed.'),
          ],
        ),
      ),
    );
  }
}