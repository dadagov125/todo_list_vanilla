import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/core.dart';
import 'package:todo_list/feature/todo/todo.dart';

class TodoItemsStorageImpl extends TodoItemsStorage {
  TodoItemsStorageImpl({required SharedPreferencesAsync sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferencesAsync _sharedPreferences;

  final _itemsStreamController = StreamController<List<TodoItem>>.broadcast();

  late final _record = _TodoItemsRecord(
    sharedPreferences: _sharedPreferences,
    key: 'todo_items',
  );

  @override
  Future<List<TodoItem>> getItems() => _record.read();

  @override
  Future<void> saveItems(List<TodoItem> items) async {
    await _record.write(items);
    _itemsStreamController.add(items);
  }

  @override
  Stream<List<TodoItem>> watchItems() async* {
    yield await _record.read();
    yield* _itemsStreamController.stream;
  }

  @override
  Future<void> clear() async {
    await _record.remove();
    _itemsStreamController.add([]);
  }

  @override
  Future<void> dispose() async {
    await _itemsStreamController.close();
  }
}

class _TodoItemsRecord extends Record<List<TodoItem>> {
  _TodoItemsRecord({
    required SharedPreferencesAsync sharedPreferences,
    required String key,
  })  : _key = key,
        _sharedPreferences = sharedPreferences;

  final String _key;

  final SharedPreferencesAsync _sharedPreferences;

  @override
  Future<void> remove() async {
    await _sharedPreferences.remove(_key);
  }

  @override
  Future<List<TodoItem>> read() async {
    final jsonStrong = await _sharedPreferences.getString(_key);
    if (jsonStrong == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonStrong);
    return jsonList.map((item) => TodoItem.fromJson(item)).toList();
  }

  @override
  Future<void> write(List<TodoItem> data) async {
    final jsonList = data.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _sharedPreferences.setString(_key, jsonString);
  }
}
