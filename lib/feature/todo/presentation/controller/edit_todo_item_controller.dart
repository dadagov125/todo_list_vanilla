import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class EditTodoItemController extends AsyncStateController<TodoItem> {
  EditTodoItemController({
    required int itemId,
    required GetTodoItemUseCase getTodoItemUseCase,
    required SaveTodoItemUseCase saveTodoItemUseCase,
  })  : _itemId = itemId,
        _saveTodoItemUseCase = saveTodoItemUseCase,
        _getTodoItemUseCase = getTodoItemUseCase,
        super(AsyncS.initial(null));

  final int _itemId;
  final GetTodoItemUseCase _getTodoItemUseCase;
  final SaveTodoItemUseCase _saveTodoItemUseCase;

  void loadItem() {
    addTask((setValue) async {
      final prevState = value;
      try {
        setValue(AsyncS.loading(prevState));
        final item = await _getTodoItemUseCase.execute(_itemId);
        setValue(
          AsyncS.loaded(item),
        );
      } on Object catch (e) {
        setValue(AsyncS.error(e, data: prevState.data));
      }
    });
  }

  void updateItem(TodoItem item) {
    addTask((setValue) async {
      final prevValue = value;
      try {
        setValue(AsyncS.loaded(item));
      } on Object catch (e) {
        setValue(AsyncS.error(e, data: prevValue.data));
      }
    });
  }

  void save() {
    addTask((setValue) async {
      final prevValue = value;
      final item = prevValue.data;
      if (item == null) return;
      try {
        setValue(AsyncS.loading(value));
        await _saveTodoItemUseCase.execute(item);
        setValue(AsyncS.loaded(item));
      } on Object catch (e) {
        setValue(AsyncS.error(e, data: item));
      }
    });
  }
}

class EditTodoItemControllerScope extends StatefulWidget {
  const EditTodoItemControllerScope({
    required this.child,
    required this.itemId,
    super.key,
  });

  final Widget child;
  final int itemId;

  @override
  State<EditTodoItemControllerScope> createState() =>
      _EditTodoItemControllerScopeState();

  static EditTodoItemController of(
    BuildContext context, {
    bool listen = false,
  }) {
    final notifier = listen
        ? context.dependOnInheritedWidgetOfExactType<
            _InheiretedEditTodoItemController>()
        : context
            .findAncestorWidgetOfExactType<_InheiretedEditTodoItemController>();
    if (notifier == null) {
      throw FlutterError(
          'TodoItemControllerScope.of was called with a context that does not contain a TodoItemControllerScope.');
    }
    return notifier.notifier!;
  }
}

class _EditTodoItemControllerScopeState
    extends State<EditTodoItemControllerScope> {
  late final EditTodoItemController _controller;

  @override
  void initState() {
    super.initState();
    final itemsStorage = TodoDependency.of(context).todoItemsStorage;
    _controller = EditTodoItemController(
      itemId: widget.itemId,
      getTodoItemUseCase: GetTodoItemUseCase(itemsStorage: itemsStorage),
      saveTodoItemUseCase: SaveTodoItemUseCase(itemsStorage: itemsStorage),
    );
    _controller.loadItem();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheiretedEditTodoItemController(
        notifier: _controller,
        child: widget.child,
      );
}

class _InheiretedEditTodoItemController
    extends InheritedNotifier<EditTodoItemController> {
  const _InheiretedEditTodoItemController({
    required super.child,
    required super.notifier,
  });
}
