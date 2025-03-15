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
}
