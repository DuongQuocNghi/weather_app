import 'dart:async';

/// Utility class để xử lý multiple events
class EventHandlerUtils {
  /// Debouncer - chỉ thực hiện action cuối cùng sau một khoảng thời gian
  static class Debouncer {
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

  /// Throttler - chỉ thực hiện action đầu tiên trong khoảng thời gian
  static class Throttler {
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

  /// SingleActionHandler - chỉ cho phép một action chạy tại một thời điểm
  static class SingleActionHandler {
    bool _isRunning = false;
    Completer<void>? _currentOperation;

    Future<void> run(Future<void> Function() action) async {
      if (_isRunning) {
        print('Action already in progress, ignoring this call');
        return;
      }

      _isRunning = true;
      _currentOperation = Completer<void>();

      try {
        await action();
      } finally {
        _isRunning = false;
        _currentOperation?.complete();
        _currentOperation = null;
      }
    }

    bool get isRunning => _isRunning;
  }

  /// AsyncDebouncer - debouncer cho async operations
  static class AsyncDebouncer {
    final Duration delay;
    Timer? _timer;
    Completer<void>? _lastCompleter;

    AsyncDebouncer({this.delay = const Duration(milliseconds: 300)});

    Future<void> run(Future<void> Function() action) async {
      _timer?.cancel();
      
      // Cancel previous operation if still running
      _lastCompleter?.complete();
      
      final completer = Completer<void>();
      _lastCompleter = completer;
      
      _timer = Timer(delay, () async {
        try {
          await action();
          if (!completer.isCompleted) {
            completer.complete();
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      });

      return completer.future;
    }

    void dispose() {
      _timer?.cancel();
      _lastCompleter?.complete();
    }
  }
}

/// Ví dụ sử dụng:
/// 
/// ```dart
/// class MyWidget extends StatefulWidget {
///   final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));
///   final Throttler _throttler = Throttler(delay: Duration(milliseconds: 1000));
///   final SingleActionHandler _actionHandler = SingleActionHandler();
///   final AsyncDebouncer _asyncDebouncer = AsyncDebouncer(delay: Duration(milliseconds: 300));
/// 
///   void _handleSearch(String query) {
///     _debouncer.run(() {
///       // Chỉ thực hiện search sau khi user ngừng gõ 500ms
///       performSearch(query);
///     });
///   }
/// 
///   void _handleButtonPress() {
///     _throttler.run(() {
///       // Chỉ thực hiện action đầu tiên trong 1 giây
///       submitForm();
///     });
///   }
/// 
///   Future<void> _handleAsyncOperation() async {
///     await _actionHandler.run(() async {
///       // Chỉ cho phép một async operation chạy tại một thời điểm
///       await performAsyncWork();
///     });
///   }
/// 
///   Future<void> _handleAsyncSearch(String query) async {
///     await _asyncDebouncer.run(() async {
///       // Debounce async search operations
///       await performAsyncSearch(query);
///     });
///   }
/// }
/// ```