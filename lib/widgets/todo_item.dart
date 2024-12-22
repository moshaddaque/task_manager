import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master_pro/constants/constant_color.dart';
import 'package:task_master_pro/controller/provider_controller.dart';
import 'package:task_master_pro/views/todo_details_screen.dart';

import '../model/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);
    return Consumer<ProviderController>(
      builder: (context, controller, child) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoDetailsScreen(todoId: todo.id),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: kElevationToShadow[4],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: titleStyle,
                        ),
                        Text(
                          todo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          buildShowDialog(
                              context, titleController, descriptionController);
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: mainColor,
                          size: 30,
                        ),
                      ),
                      IconButton(
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
                                    controller.removeTodo(todo.id);
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
                      IconButton(
                        onPressed: () {
                          controller.toggleStatus(todo.id);
                        },
                        icon: Icon(
                          todo.isCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: mainColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 5,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: todo.importance == Importance.Low
                      ? Colors.black
                      : todo.importance == Importance.Medium
                          ? Colors.orange
                          : todo.importance == Importance.High
                              ? Colors.red
                              : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void buildShowDialog(BuildContext context, TextEditingController title,
      TextEditingController des) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                hintStyle: const TextStyle(color: Colors.grey),
                border: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: des,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Enter task Description',
                hintStyle: const TextStyle(color: Colors.grey),
                border: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
            ),
            const SizedBox(height: 8),
            Consumer<ProviderController>(
              builder: (context, controller, child) => ListTile(
                title: Text(
                  'Importance: ${controller.selectedImportance.name}',
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: const Icon(
                  Icons.arrow_drop_down,
                  size: 40,
                  color: mainColor,
                ),
                onTap: () {
                  // Open bottom sheet to select importance
                  _showImportancePicker(context, controller);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              height: 60,
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: mainColor),
                    ),
                  ),
                  onPressed: () {
                    final String description = des.text ?? '';
                    if (title.text.isNotEmpty) {
                      Provider.of<ProviderController>(context, listen: false)
                          .updateTodo(
                        todo.id,
                        title.text,
                        description,
                        Provider.of<ProviderController>(context, listen: false)
                            .selectedImportance,
                      );
                      title.clear();
                      des.clear();
                      Navigator.pop(context); // Close the bottom sheet
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.red,
                          closeIconColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * .75,
                            right: 10,
                            left: 10,
                          ),
                          behavior: SnackBarBehavior.floating,
                          content: const Text("Title must be provided"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Update Todo',
                    style: titleStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImportancePicker(
      BuildContext context, ProviderController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: Importance.values.map((importance) {
            return ListTile(
              title: Text(importance.name),
              onTap: () {
                controller.setImportance(importance);
                Navigator.pop(context); // Close the importance selection sheet
              },
            );
          }).toList(),
        );
      },
    );
  }
}
