import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

abstract class QueuedController<T> extends ValueListenable<T>
    with ChangeNotifier {
  QueuedController(this._value);

  final Queue<_Task<T>> _taskQueue = Queue();
  bool _isExecuting = false;
  bool _isDisposed = false;
  T _value;

  @override
  T get value => _value;

  void _setValue(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  @protected
  Future<void> addTask(AsyncValueSetter<ValueSetter<T>> asyncValueSetter) {
    assert(!_isDisposed, 'Controller is disposed');
    final completer = Completer<void>();
    _taskQueue.add(_Task(() => asyncValueSetter(_setValue), completer));
    _execute();
    return completer.future;
  }

  Future<void> _execute() async {
    if (_isExecuting || _taskQueue.isEmpty) return;
    _isExecuting = true;
    while (_taskQueue.isNotEmpty) {
      final task = _taskQueue.removeFirst();
      try {
        await task.operation();
        task.completer.complete();
      } catch (e, stackTrace) {
        task.completer.completeError(e, stackTrace);
      }
    }
    _isExecuting = false;
  }

  @override
  void dispose() {
    _taskQueue.clear();
    _isDisposed = true;
    super.dispose();
  }
}

@immutable
class _Task<T> {
  const _Task(this.operation, this.completer);

  final AsyncCallback operation;
  final Completer<void> completer;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Task &&
          runtimeType == other.runtimeType &&
          operation == other.operation &&
          completer == other.completer;

  @override
  int get hashCode => operation.hashCode ^ completer.hashCode;
}
