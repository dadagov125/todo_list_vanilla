import 'package:todo_list/core/core.dart';

class AsyncStateController<T> extends QueuedController<AsyncS<T>> {
  AsyncStateController(super.value);
}
