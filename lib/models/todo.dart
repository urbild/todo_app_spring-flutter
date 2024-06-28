class Todo {
  final String id;
  final String todoName;
  bool completed;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.todoName,
    required this.completed,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todoName: json['todoName'],
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoName': todoName,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
