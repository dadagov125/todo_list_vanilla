class TodoItem {
  const TodoItem({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.attachments,
  });

  final String name;
  final String description;
  final DateTime createdAt;
  final List<String> attachments;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          createdAt == other.createdAt &&
          attachments == other.attachments;

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      attachments.hashCode;
}
