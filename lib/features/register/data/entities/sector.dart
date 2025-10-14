/*
 {
      "name": "Other",
      "icon": "🌐",
      "color": const Color(0xFF10B981),
    },
 */
class Sector {
  final String name;
  final String icon;
  final String color;

  Sector({
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Sector.fromMap(Map<String, dynamic> map) {
    return Sector(
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
    };
  }
}