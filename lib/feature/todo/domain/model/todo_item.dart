class TodoItem {
  const TodoItem({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.attachments,
  });

  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final List<String> attachments;

  TodoItem copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    List<String>? attachments,
  }) =>
      TodoItem(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        attachments: attachments ?? this.attachments,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          createdAt == other.createdAt &&
          attachments == other.attachments;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      attachments.hashCode;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'createdAt': createdAt,
        'attachments': attachments,
      };

  // ignore: sort_constructors_first
  factory TodoItem.fromJson(Map<String, dynamic> map) => TodoItem(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        createdAt: map['createdAt'] as DateTime,
        attachments: map['attachments'] as List<String>,
      );
}
