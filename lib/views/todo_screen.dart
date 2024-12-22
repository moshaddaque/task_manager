import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master_pro/constants/constant_color.dart';
import 'package:task_master_pro/controller/provider_controller.dart';
import 'package:task_master_pro/model/todo_model.dart';
import 'package:task_master_pro/views/active_todo_list.dart';

import 'completed_todo_list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "TaskMaster Pro",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _selectedIndex == 0
            ? const ActiveTodoList()
            : const CompletedTodoList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "All",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: "Completed",
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      autofocus: true,
      child: const Icon(
        Icons.add,
        size: 40,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: textFieldStyle,
                        enabledBorder: textFieldStyle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
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
                            final String des =
                                _descriptionController.text ?? '';
                            if (_titleController.text.isNotEmpty) {
                              Provider.of<ProviderController>(context,
                                      listen: false)
                                  .addTodo(
                                _titleController.text,
                                des,
                                Provider.of<ProviderController>(context,
                                        listen: false)
                                    .selectedImportance,
                              );
                              _titleController.clear();
                              _descriptionController.clear();
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
                                    bottom: MediaQuery.of(context).size.height *
                                        .75,
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
                            'Add Todo',
                            style: titleStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
