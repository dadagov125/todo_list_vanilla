import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ListenCallback<T> = void Function(BuildContext context, T current);

typedef ListenWhenCallback<T> = bool Function(T previous, T current);

class ValueListenableListener<T> extends StatefulWidget {
  const ValueListenableListener({
    required this.listenable,
    required this.child,
    required this.listen,
    super.key,
    this.listenWhen,
  });

  final ValueListenable<T> listenable;
  final ListenCallback<T> listen;
  final ListenWhenCallback<T>? listenWhen;
  final Widget child;

  @override
  State createState() => _ValueListenableListenerState<T>();
}

class _ValueListenableListenerState<T>
    extends State<ValueListenableListener<T>> {
  late T _previousValue;

  @override
  void initState() {
    super.initState();
    _startListening(widget.listenable);
  }

  @override
  void didUpdateWidget(ValueListenableListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      _stopListening(oldWidget.listenable);
      _startListening(widget.listenable);
    }
  }

  @override
  void dispose() {
    _stopListening(widget.listenable);
    super.dispose();
  }

  void _startListening(ValueListenable<T> listenable) {
    _previousValue = listenable.value;
    listenable.addListener(_handleChange);
  }

  void _stopListening(ValueListenable<T> listenable) {
    listenable.removeListener(_handleChange);
  }

  void _handleChange() {
    final currentValue = widget.listenable.value;
    if (widget.listenWhen?.call(_previousValue, currentValue) ?? true) {
      widget.listen(context, currentValue);
    }
    _previousValue = currentValue;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
