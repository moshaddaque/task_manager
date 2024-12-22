import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_master_pro/constants/constant_data.dart';

import '../model/todo_model.dart';

class TodoService {
  // get todoList
  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(ConstantData.BASE_URL));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map(
            (todo) => Todo.fromJson(todo),
          )
          .toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // create todoItem
  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(ConstantData.BASE_URL),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode == 201) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Create todo');
    }
  }

  // update todoItem
  Future<void> updateTodo(String id, Todo todo) async {
    final response = await http.put(
      Uri.parse('${ConstantData.BASE_URL}/$id'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to Update todo');
    }
  }

  // delete todoItem
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('${ConstantData.BASE_URL}/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
