/// Category data model for WallVerse
class Category {
  final String id;
  final String name;
  final String iconName;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
  });

  factory Category.fromMap(Map<String, dynamic> map, String docId) {
    return Category(
      id: docId,
      name: map['name'] ?? '',
      iconName: map['icon'] ?? 'category',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': iconName,
    };
  }
}
