import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

final List<TodoItem> _todoItems = [
  TodoItem(
    name: 'name3',
    description: 'description 233333',
    createdAt: DateTime.now(),
    attachments: ['attachment1', 'attachment2'],
  ),
  TodoItem(
    name: 'name2',
    description: 'description2',
    createdAt: DateTime.now().subtract(
      const Duration(days: 1, hours: 2, minutes: 10, seconds: 30),
    ),
    attachments: [],
  ),
  TodoItem(
    name: 'name3 sd sd sd sd fs df sd fs df sdfasdfsdfasdfa'
        'sdfasdfsadfsad'
        ' fsdafasdfsadf sadfasdf sadfsadf sadfsadfsdaf ',
    description:
        'description3 s s sd sd sd sd sd sd sd sa s dasd sadacfsdfasdfsadf'
        'asdfsadfsd fsd fsadfsadfsadfsda fsdafsdafsadfsadfs adf as'
        'df asd f asdf sad ',
    createdAt: DateTime.now().subtract(const Duration(days: 2, minutes: 30)),
    attachments: [],
  ),
];

class TodoItemsController extends AsyncStateController<TodoList> {
  TodoItemsController() : super(AsyncS.initial(null));

  void loadItems() {
    addTask((setValue) async {
      try {
        final prevState = value;
        setValue(AsyncS.loading(prevState));
        await Future.delayed(const Duration(seconds: 2));
        setValue(
          AsyncS.loaded(TodoList(items: _todoItems)),
        );
      } on Object catch (e) {
        setValue(AsyncS.error(e));
      }
    });
  }

  void addNewItem(String name) {
    if (name.isEmpty) return;
    addTask((setValue) async {
      try {
        final prevState = value;
        setValue(AsyncS.loading(prevState));
        await Future.delayed(const Duration(seconds: 2));

        final newItem = TodoItem(
          name: name,
          description: '',
          createdAt: DateTime.now(),
          attachments: [],
        );

        final todoList = prevState.data ?? const TodoList(items: []);
        final itemsCopy = [...todoList.items, newItem];

        itemsCopy.sort(todoList.comparator.call);

        setValue(
          AsyncS.loaded(todoList.copyWith(items: itemsCopy)),
        );
      } on Object catch (e) {
        setValue(AsyncS.error(e));
      }
    });
  }

  void sort(TodoItemComparator comparator) {
    addTask(
      (setValue) async {
        try {
          value.mapOrNull(
            loaded: (state) {
              final todoList = state.data;
              final itemsCopy = [...todoList.items];
              itemsCopy.sort(comparator.call);
              setValue(
                AsyncS.loaded(
                  todoList.copyWith(items: itemsCopy, comparator: comparator),
                ),
              );
            },
          );
        } on Object catch (e) {
          setValue(AsyncS.error(e));
        }
      },
    );
  }
}
