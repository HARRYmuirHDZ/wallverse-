/// Subcategory data model for WallVerse
class Subcategory {
  final String id;
  final String categoryId;
  final String name;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  factory Subcategory.fromMap(Map<String, dynamic> map, String docId) {
    return Subcategory(
      id: docId,
      categoryId: map['category_id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
    };
  }
}
