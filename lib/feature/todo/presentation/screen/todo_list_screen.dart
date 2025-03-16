import 'package:flutter/material.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: TodoItemsControllerScope.of(context),
        builder: (context, value, child) {
          final isLoading = value.isLoading;
          final todoList = value.data;
          final items = todoList?.items ?? [];
          return Stack(
            children: [
              Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: const Text('Todo List'),
                      centerTitle: false,
                      pinned: true,
                      actions: [
                        TodoItemsListSortButtons(
                          state: value,
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            TodoListItemTile(item: items[index]),
                        childCount: items.length,
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.viewInsetsOf(context).bottom,
                child: NewTodoItemNameInput(
                  isLoading: isLoading,
                ),
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      );
}
