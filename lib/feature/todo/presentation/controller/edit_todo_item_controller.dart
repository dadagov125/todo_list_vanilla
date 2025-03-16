import 'package:flutter/material.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class EditTodoItemController extends AsyncStateController<TodoItem> {
  EditTodoItemController({
    required int itemId,
    required GetTodoItemUseCase getTodoItemUseCase,
    required SaveTodoItemUseCase saveTodoItemUseCase,
    required RemoveTodoItemUseCase removeTodoItemUseCase,
    required PickFileUseCase pickFileUseCase,
  })  : _pickFileUseCase = pickFileUseCase,
        _removeTodoItemUseCase = removeTodoItemUseCase,
        _itemId = itemId,
        _saveTodoItemUseCase = saveTodoItemUseCase,
        _getTodoItemUseCase = getTodoItemUseCase,
        super(AsyncS.initial(null));

  final int _itemId;
  final GetTodoItemUseCase _getTodoItemUseCase;
  final SaveTodoItemUseCase _saveTodoItemUseCase;
  final RemoveTodoItemUseCase _removeTodoItemUseCase;
  final PickFileUseCase _pickFileUseCase;

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

  void addFile(FileSource source) {
    addTask((setValue) async {
      final prevValue = value;
      try {
        final file = await _pickFileUseCase.execute(source);
        final item = prevValue.data;
        if (file == null || item == null) {
          return setValue(prevValue);
        }
        final copy = item.copyWith(
          attachments: [...item.attachments, file.path],
        );
        setValue(AsyncS.loaded(copy));
      } on Object catch (e) {
        setValue(AsyncS.error(e, data: prevValue.data));
      }
    });
  }

  void removeFile(String path) {
    addTask((setValue) async {
      final prevValue = value;
      try {
        final item = prevValue.data;
        if (item == null) return;
        final copy = item.copyWith(
          attachments: item.attachments.where((e) => e != path).toList(),
        );
        setValue(AsyncS.loaded(copy));
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

  void remove() {
    addTask((setValue) async {
      final prevValue = value;

      try {
        final item = prevValue.data;
        if (item == null) return;
        setValue(AsyncS.loading(prevValue));
        await _removeTodoItemUseCase.execute(item.id);
        setValue(AsyncS.initial(null));
      } on Object catch (e) {
        setValue(AsyncS.error(e, data: prevValue.data));
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
            _InheritedEditTodoItemController>()
        : context
            .findAncestorWidgetOfExactType<_InheritedEditTodoItemController>();

    assert(notifier != null, 'No EditTodoItemControllerScope found in context');
    return notifier!.notifier!;
  }
}

class _EditTodoItemControllerScopeState
    extends State<EditTodoItemControllerScope> {
  late final EditTodoItemController _controller;

  @override
  void initState() {
    super.initState();
    final itemsStorage = TodoDependencyScope.of(context).todoItemsStorage;
    final fileService = TodoDependencyScope.of(context).fileService;
    _controller = EditTodoItemController(
      itemId: widget.itemId,
      getTodoItemUseCase: GetTodoItemUseCase(itemsStorage: itemsStorage),
      saveTodoItemUseCase: SaveTodoItemUseCase(itemsStorage: itemsStorage),
      removeTodoItemUseCase: RemoveTodoItemUseCase(itemsStorage: itemsStorage),
      pickFileUseCase: PickFileUseCase(fileService: fileService),
    );
    _controller.loadItem();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedEditTodoItemController(
        notifier: _controller,
        child: widget.child,
      );
}

class _InheritedEditTodoItemController
    extends InheritedNotifier<EditTodoItemController> {
  const _InheritedEditTodoItemController({
    required super.child,
    required super.notifier,
  });
}
