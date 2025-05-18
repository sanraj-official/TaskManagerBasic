class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final bool isCompleted;
  final List<DateTime> updatedAt ;
  final DateTime? completedAt ;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
    this.updatedAt = const [],
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted ? 1 : 0,
        'updatedAt': updatedAt.map((date) => date.toIso8601String()).toList().toString(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        createdAt: DateTime.parse(map['createdAt']),
        isCompleted: map['isCompleted'] == 1,
        updatedAt:  (map['updatedAt'] != null && map['updatedAt'].toString().trim().length > 2)
            ? map['updatedAt']
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((date) => DateTime.tryParse(date.trim()))
            .whereType<DateTime>()
            .toList()
            : [],
        completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
      );

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
    List<DateTime>? updatedAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
