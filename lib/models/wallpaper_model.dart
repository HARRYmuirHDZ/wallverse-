/// Wallpaper data model for WallVerse
class Wallpaper {
  final String id;
  final String subcategoryId;
  final String imageUrl;
  final String resolution; // 'HD', '4K', '8K'
  final bool isFree;
  bool isUnlocked;

  Wallpaper({
    required this.id,
    required this.subcategoryId,
    required this.imageUrl,
    required this.resolution,
    required this.isFree,
    this.isUnlocked = false,
  });

  factory Wallpaper.fromMap(Map<String, dynamic> map, String docId) {
    return Wallpaper(
      id: docId,
      subcategoryId: map['subcategory_id'] ?? '',
      imageUrl: map['image_url'] ?? '',
      resolution: map['resolution'] ?? 'HD',
      isFree: map['is_free'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subcategory_id': subcategoryId,
      'image_url': imageUrl,
      'resolution': resolution,
      'is_free': isFree,
    };
  }

  /// Whether the user can access this wallpaper
  bool get isAccessible => isFree || isUnlocked;
}
