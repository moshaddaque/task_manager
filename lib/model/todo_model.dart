class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  Importance importance;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.importance = Importance.Low,
  });

  // convert from JSON to object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      importance: Importance.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            json[''].toString().toLowerCase(),
      ),
    );
  }

  // convert from object to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'importance': importance.toString().split('.').last,
    };
  }
}

enum Importance { Low, Medium, High }
