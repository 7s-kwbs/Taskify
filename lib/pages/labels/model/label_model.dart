import 'dart:ui';

class Label {
  final String id;
  final String name;
  final Color color;
  final DateTime createdAt;

  Label({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt
  });

  Label copyWith({
    String? name,
    Color? color
  }){
    return Label(
      id: id, 
      name: name ?? this.name, 
      color: color ?? this.color, 
      createdAt: createdAt
    );
  }
}