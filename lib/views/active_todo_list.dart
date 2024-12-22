import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/provider_controller.dart';
import '../widgets/todo_item.dart';

class ActiveTodoList extends StatelessWidget {
  const ActiveTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderController>(
      builder: (context, todoProvider, child) {
        return ListView.builder(
          itemCount: todoProvider.activeTodoList.length,
          itemBuilder: (context, index) {
            final todo = todoProvider.activeTodoList[index];
            return TodoItem(
              todo: todo,
            );
          },
        );
      },
    );
  }
}
