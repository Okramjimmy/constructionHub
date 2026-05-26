class ChecklistItemModel {
  ChecklistItemModel({
    required this.id,
    required this.number,
    required this.name,
    required this.fieldType,
    this.value,
    this.photoPath,
    this.remarks = '',
    this.options = const [],
    this.description,
  });

  final String id;
  final int number;
  final String name;
  final String fieldType;
  final dynamic value;
  final String? photoPath;
  final String remarks;
  final List<String> options;
  final String? description;

  bool get isCompleted {
    if (value == null) return false;
    if (value is String && value.toString().isEmpty) return false;
    if (value is bool) return true; // Boolean checkbox is always either true or false, but if it is false and not interacted, value might be null initially.
    return true;
  }

  ChecklistItemModel copyWith({
    dynamic value,
    String? photoPath,
    String? remarks,
  }) {
    return ChecklistItemModel(
      id: id,
      number: number,
      name: name,
      fieldType: fieldType,
      value: value ?? this.value,
      photoPath: photoPath ?? this.photoPath,
      remarks: remarks ?? this.remarks,
      options: options,
      description: description,
    );
  }
}
