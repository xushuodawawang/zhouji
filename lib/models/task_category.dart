class TaskCategory {
  const TaskCategory({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.isDefault,
  });

  final int id;
  final String name;
  final int colorValue;
  final bool isDefault;
}
