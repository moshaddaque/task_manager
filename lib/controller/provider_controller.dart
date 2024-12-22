import 'package:flutter/material.dart';
import 'package:task_master_pro/model/todo_model.dart';

class ProviderController with ChangeNotifier {
  final List<Todo> _todoList = [];
  Importance _selectedImportance = Importance.Low;

  // get importance
  Importance get selectedImportance => _selectedImportance;

  // set importance
  void setImportance(Importance importance) {
    _selectedImportance = importance;
    notifyListeners(); // Notify listeners that the importance has changed
  }

  // get ActiveTodoList
  List<Todo> get activeTodoList => _todoList
      .where(
        (todo) => !todo.isCompleted,
      )
      .toList();

  // get completedTodoList
  List<Todo> get completedTodoList => _todoList
      .where(
        (todo) => todo.isCompleted,
      )
      .toList();

  // add todoItem
  void addTodo(String title, String description, Importance importance) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      importance: importance,
    );

    // add in list
    _todoList.add(newTodo);
    notifyListeners();
  }

  // remove todoItem
  void removeTodo(String id) {
    try {
      _todoList.removeWhere(
        (todo) => todo.id == id,
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // toggle todoItem Status
  void toggleStatus(String id) {
    final todo = _todoList.firstWhere(
      (todo) => todo.id == id,
    );
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }

  void updateTodo(
      String id, String title, String description, Importance importance) {
    final todoIndex = _todoList.indexWhere((todo) => todo.id == id);

    if (todoIndex != -1) {
      _todoList[todoIndex] = Todo(
        id: id,
        title: title,
        description: description,
        importance: importance,
        isCompleted: _todoList[todoIndex].isCompleted,
      );
    }
    notifyListeners();
  }
}
