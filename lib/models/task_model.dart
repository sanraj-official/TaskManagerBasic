class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted ? 1 : 0,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        createdAt: DateTime.parse(map['createdAt']),
        isCompleted: map['isCompleted'] == 1,
      );
}
