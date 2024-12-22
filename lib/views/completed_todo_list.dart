import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master_pro/controller/provider_controller.dart';

import '../constants/constant_color.dart';

class CompletedTodoList extends StatelessWidget {
  const CompletedTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderController>(
      builder: (context, controller, child) => ListView.builder(
        itemCount: controller.completedTodoList.length,
        itemBuilder: (context, index) {
          final completeTodo = controller.completedTodoList[index];
          return Container(
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: kElevationToShadow[4],
            ),
            child: ListTile(
              title: Text(
                completeTodo.title,
                style: titleStyle,
              ),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.removeTodo(completeTodo.id);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: mainColor,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
