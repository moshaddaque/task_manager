import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master_pro/constants/constant_color.dart';
import 'package:task_master_pro/controller/provider_controller.dart';
import 'package:task_master_pro/model/todo_model.dart';

class TodoDetailsScreen extends StatelessWidget {
  final String todoId;
  const TodoDetailsScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    // Get the TodoItem from the provider using the todoId
    final todo =
        Provider.of<ProviderController>(context).activeTodoList.firstWhere(
              (todo) => todo.id == todoId,
            );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
              color: mainColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: todoId.isEmpty
          ? const Text("No data")
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            todo.description,
                            style: const TextStyle(
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: todo.importance == Importance.Low
                                ? Colors.black
                                : todo.importance == Importance.Medium
                                    ? Colors.orange
                                    : todo.importance == Importance.High
                                        ? Colors.red
                                        : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Importance: ${todo.importance.name}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: todo.importance == Importance.Low
                                ? Colors.black
                                : todo.importance == Importance.Medium
                                    ? Colors.orange
                                    : todo.importance == Importance.High
                                        ? Colors.red
                                        : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
