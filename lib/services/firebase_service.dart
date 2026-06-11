import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/subcategory_model.dart';
import '../models/wallpaper_model.dart';

/// Firebase service with built-in demo mode.
/// When Firebase is not configured, returns sample data with Picsum placeholder images.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Set to true when Firebase is properly configured
  static const bool _useFirebase = false;

  // ─── CATEGORIES ─────────────────────────────────────

  Future<List<Category>> getCategories() async {
    if (_useFirebase) {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      return snapshot.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList();
    }
    return _demoCategories;
  }

  // ─── SUBCATEGORIES ──────────────────────────────────

  Future<List<Subcategory>> getSubcategories(String categoryId) async {
    if (_useFirebase) {
      final snapshot = await FirebaseFirestore.instance
          .collection('subcategories')
          .where('category_id', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) => Subcategory.fromMap(doc.data(), doc.id)).toList();
    }
    return _demoSubcategories
        .where((s) => s.categoryId == categoryId)
        .toList();
  }

  // ─── WALLPAPERS (PAGINATED) ─────────────────────────

  Future<List<Wallpaper>> getWallpapers(
    String subcategoryId, {
    int limit = 20,
    String? startAfterId,
  }) async {
    if (_useFirebase) {
      Query<Map<String, dynamic>> query;
      if (subcategoryId == 'cars_all') {
        final subcategorySnapshot = await FirebaseFirestore.instance
            .collection('subcategories')
            .where('category_id', isEqualTo: 'cars')
            .get();
        final subIds = subcategorySnapshot.docs.map((doc) => doc.id).toList();

        if (subIds.isEmpty) return [];
        query = FirebaseFirestore.instance
            .collection('wallpapers')
            .where('subcategory_id', whereIn: subIds)
            .limit(limit);
      } else {
        query = FirebaseFirestore.instance
            .collection('wallpapers')
            .where('subcategory_id', isEqualTo: subcategoryId)
            .limit(limit);
      }

      if (startAfterId != null) {
        final lastDoc = await FirebaseFirestore.instance
            .collection('wallpapers')
            .doc(startAfterId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Wallpaper.fromMap(doc.data(), doc.id)).toList();
    }

    if (subcategoryId == 'cars_all') {
      final List<Wallpaper> customCarWallpapers = [
        Wallpaper(
          id: 'mustang',
          subcategoryId: 'sports_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2F1967%20Ford%20Mustang%20Shelby%20GT500.png?alt=media&token=358b5502-3433-448c-b49b-c7314c9210e6',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'audi_rs6',
          subcategoryId: 'sports_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FAudi%20RS6.png?alt=media&token=0ab800e1-4c85-43fe-a6e4-badd83f8f805',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'corvette_c8',
          subcategoryId: 'sports_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FChevrolet%20Corvette%20C8.png?alt=media&token=4a577568-adf2-4460-b9a1-d580998103b9',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'ferrari',
          subcategoryId: 'super_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FFerrari.png?alt=media&token=f8aa60f3-921d-460d-9831-272224a0962d',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'lamborghini',
          subcategoryId: 'super_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FLamborghini%20Aventador.png?alt=media&token=27755770-59d1-40cf-8fe1-e646d956d63b',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'porsche',
          subcategoryId: 'super_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FPorsche%20911%20GT3%20RS.png?alt=media&token=8f2ee6c9-b5b9-40b2-88b9-a34218d6c9c3',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'honda_civic',
          subcategoryId: 'jdm',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FHondaCivic.png?alt=media&token=7f61b96f-6c86-4250-9956-7074326341db',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'toyota_ae86',
          subcategoryId: 'jdm',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FToyota%20AE86.png?alt=media&token=768bfe6e-9593-49ff-8cec-518f4a816575',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nissan_skyline',
          subcategoryId: 'jdm',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FNissan%20Skyline%20GT-R.png?alt=media&token=3dab93f3-23bf-4605-b821-12f22f9c29c7',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'toyota_supra',
          subcategoryId: 'jdm',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FToyota%20Supra%20MK4.png?alt=media&token=cc091ff0-6ecc-4ea8-8c69-ac471e253e79',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'toyota_yaris',
          subcategoryId: 'jdm',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FToyota%20Yaris.png?alt=media&token=2cc4cb4a-01f7-4879-be52-45d096457ec7',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'jeep_wrangler',
          subcategoryId: 'classic_cars',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FJeep%20Wrangler.png?alt=media&token=498ab3fb-ef04-4ad8-ab49-4a6ba41ca4da',
          resolution: '4K',
          isFree: false,
        ),
      ];

      int startIndex = 0;
      if (startAfterId != null) {
        startIndex = customCarWallpapers.indexWhere((w) => w.id == startAfterId) + 1;
        if (startIndex <= 0) startIndex = 0;
      }
      final endIndex = (startIndex + limit).clamp(0, customCarWallpapers.length);
      return customCarWallpapers.sublist(startIndex, endIndex);
    }

    if (subcategoryId == 'dragon_ball') {
      final List<Wallpaper> customDbWallpapers = [
        Wallpaper(
          id: 'broly_1',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2FBroly.png?alt=media&token=f75e664a-28df-4d9b-80e2-e3159882f2fe',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'majin_buu_1',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2Fmajin%20Buu.png?alt=media&token=c19908e4-634a-4d00-99d3-0d1963e1e824',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'goku_3',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2FGoku3.png?alt=media&token=8972cf48-8e26-4908-843d-ec7c17dc0d58',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'android_18',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2F18.png?alt=media&token=a50a600e-104c-47d9-862d-dce806826728',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'cell',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2FCell.png?alt=media&token=ca73112c-408f-49df-b939-09c47279c86d',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'frieza',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2FFreezer.png?alt=media&token=e3cf66ee-eeed-40b3-aef6-5c6fe0ba6fcc',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'trunks',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2FTrons.png?alt=media&token=47509ef2-411e-4b92-86f6-36aa1ce13183',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'bills',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2Fbills.png?alt=media&token=9cc12cda-21f7-4306-a510-3220c5bd2a08',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'gotenks',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2Fgotenks%20.png?alt=media&token=f117998f-37dc-4353-8089-59e9cf8f3e00',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'jiren',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2Fjiren.png?alt=media&token=c83c1ab2-0d92-4d69-914d-abe384e1e829',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'piccolo',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2Fpicoro.png?alt=media&token=67a38166-35f3-493f-adb4-abc8457ab308',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'vegeta',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2Fvegueta.png?alt=media&token=d0aac368-a101-4715-a8d4-ed5d14036de9',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'vegeta_blue',
          subcategoryId: 'dragon_ball',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Anime%2FDragon_ball%2FveguetaBlue.png?alt=media&token=b99a41e6-c1ad-450e-b052-1885d3285ca0',
          resolution: '4K',
          isFree: false,
        ),
      ];

      int startIndex = 0;
      if (startAfterId != null) {
        startIndex = customDbWallpapers.indexWhere((w) => w.id == startAfterId) + 1;
        if (startIndex <= 0) startIndex = 0;
      }
      final endIndex = (startIndex + limit).clamp(0, customDbWallpapers.length);
      return customDbWallpapers.sublist(startIndex, endIndex);
    }

    if (subcategoryId == 'nature_all') {
      final List<Wallpaper> customNatureWallpapers = [
        Wallpaper(
          id: 'nature_playa',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2Fplaya.png?alt=media&token=a70e5f9d-4587-4af4-ad6e-bc66fee5db78',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'nature_sahara',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FSahara.png?alt=media&token=ecc88935-afc4-47b6-b6ac-8180af3a1428',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'nature_boreales',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FBoreales%20islandia.png?alt=media&token=dbca9cd3-2748-4d2f-af32-df7d611825cc',
          resolution: '4K',
          isFree: true,
        ),
        Wallpaper(
          id: 'nature_volcan',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2Fvolcan%20lava.png?alt=media&token=bba7623e-fa86-4a41-ac35-03476e66bc86',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_penon',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FPe%C3%B1on.png?alt=media&token=4da96ac1-ec0c-4702-99de-55c9611522fd',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_patagonia',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FPatagonia.png?alt=media&token=3e685e5e-d2e9-4f83-81cf-b6c2f260ba53',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_fuji',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FMonte%20Fuji%20.png?alt=media&token=2cf88d00-6e6e-4d13-af95-599717009885',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_iguazu',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FIguazu.png?alt=media&token=f97254b4-60c5-4c11-b7cc-53f38b99e134',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_cañon',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FGran%20ca%C3%B1on.png?alt=media&token=d3035220-0a34-4a8e-b87c-f560fa2c9ced',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_glacial',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FGlacial%20lake.png?alt=media&token=e19cd667-d54e-4672-8a4f-71b66347fc3a',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_alpes',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FGalaxia%20alpes.png?alt=media&token=c576ce9c-2c90-433d-b1bf-3d5640c69af7',
          resolution: '4K',
          isFree: false,
        ),
        Wallpaper(
          id: 'nature_coliseo',
          subcategoryId: 'nature_all',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Natural%2FColiseo%20romano.png?alt=media&token=202da4cb-e39c-41a5-86e4-c18f757d3a02',
          resolution: '4K',
          isFree: false,
        ),
      ];

      int startIndex = 0;
      if (startAfterId != null) {
        startIndex = customNatureWallpapers.indexWhere((w) => w.id == startAfterId) + 1;
        if (startIndex <= 0) startIndex = 0;
      }
      final endIndex = (startIndex + limit).clamp(0, customNatureWallpapers.length);
      return customNatureWallpapers.sublist(startIndex, endIndex);
    }

    return _generateDemoWallpapers(subcategoryId);
  }

  // ─── DEMO DATA ──────────────────────────────────────

  static final List<Category> _demoCategories = [
    Category(id: 'anime', name: 'anime', iconName: 'anime'),
    Category(id: 'games', name: 'games', iconName: 'games'),
    Category(id: 'movies', name: 'movies', iconName: 'movies'),
    Category(id: 'nature', name: 'nature', iconName: 'nature'),
    Category(id: 'neon', name: 'neon', iconName: 'neon'),
    Category(id: 'cars', name: 'cars', iconName: 'cars'),
    Category(id: 'space', name: 'space', iconName: 'space'),
    Category(id: 'minimalist', name: 'minimalist', iconName: 'minimalist'),
  ];

  static final List<Subcategory> _demoSubcategories = [
    // Anime
    Subcategory(id: 'naruto', categoryId: 'anime', name: 'naruto'),
    Subcategory(id: 'dragon_ball', categoryId: 'anime', name: 'dragon_ball'),
    Subcategory(id: 'dragon_ball_2', categoryId: 'anime', name: 'dragon_ball_2'),
    Subcategory(id: 'demon_slayer', categoryId: 'anime', name: 'demon_slayer'),
    Subcategory(id: 'one_piece', categoryId: 'anime', name: 'one_piece'),
    Subcategory(id: 'attack_on_titan', categoryId: 'anime', name: 'attack_on_titan'),
    // Games
    Subcategory(id: 'roblox', categoryId: 'games', name: 'roblox'),
    Subcategory(id: 'minecraft', categoryId: 'games', name: 'minecraft'),
    Subcategory(id: 'call_of_duty', categoryId: 'games', name: 'call_of_duty'),
    Subcategory(id: 'fortnite', categoryId: 'games', name: 'fortnite'),
    Subcategory(id: 'gta', categoryId: 'games', name: 'gta'),
    // Movies
    Subcategory(id: 'marvel', categoryId: 'movies', name: 'marvel'),
    Subcategory(id: 'dc', categoryId: 'movies', name: 'dc'),
    Subcategory(id: 'star_wars', categoryId: 'movies', name: 'star_wars'),
    Subcategory(id: 'harry_potter', categoryId: 'movies', name: 'harry_potter'),
    Subcategory(id: 'avatar', categoryId: 'movies', name: 'avatar'),
    // Neon
    Subcategory(id: 'neon_city', categoryId: 'neon', name: 'neon_city'),
    Subcategory(id: 'neon_signs', categoryId: 'neon', name: 'neon_signs'),
    Subcategory(id: 'neon_abstract', categoryId: 'neon', name: 'neon_abstract'),
    Subcategory(id: 'neon_portraits', categoryId: 'neon', name: 'neon_portraits'),
    Subcategory(id: 'neon_gaming', categoryId: 'neon', name: 'neon_gaming'),
    // Cars
    Subcategory(id: 'sports_cars', categoryId: 'cars', name: 'sports_cars'),
    Subcategory(id: 'classic_cars', categoryId: 'cars', name: 'classic_cars'),
    Subcategory(id: 'super_cars', categoryId: 'cars', name: 'super_cars'),
    Subcategory(id: 'jdm', categoryId: 'cars', name: 'jdm'),
    Subcategory(id: 'modified', categoryId: 'cars', name: 'modified'),
    // Space
    Subcategory(id: 'galaxies', categoryId: 'space', name: 'galaxies'),
    Subcategory(id: 'planets', categoryId: 'space', name: 'planets'),
    Subcategory(id: 'nebula', categoryId: 'space', name: 'nebula'),
    Subcategory(id: 'astronaut', categoryId: 'space', name: 'astronaut'),
    Subcategory(id: 'black_hole', categoryId: 'space', name: 'black_hole'),
    // Minimalist
    Subcategory(id: 'geometric', categoryId: 'minimalist', name: 'geometric'),
    Subcategory(id: 'gradients', categoryId: 'minimalist', name: 'gradients'),
    Subcategory(id: 'typography', categoryId: 'minimalist', name: 'typography'),
    Subcategory(id: 'line_art', categoryId: 'minimalist', name: 'line_art'),
    Subcategory(id: 'abstract', categoryId: 'minimalist', name: 'abstract'),
  ];

  /// Generate demo wallpapers using Picsum.photos for realistic images
  List<Wallpaper> _generateDemoWallpapers(String subcategoryId) {
    final resolutions = ['4K', '4K', '4K', '4K', '4K', '4K', '4K', '4K', '4K', '4K', '4K', '4K'];
    final List<Wallpaper> wallpapers = [];

    // Use unique seed per subcategory for varied but consistent images
    final baseSeed = subcategoryId.hashCode.abs();

    for (int i = 0; i < 12; i++) {
      final seed = baseSeed + i;
      String imageUrl = 'https://picsum.photos/seed/$seed/1080/1920';

      // Temporary: Show the user's uploaded Mustang image for the first sports car
      if (subcategoryId == 'sports_cars' && i == 0) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2F1967%20Ford%20Mustang%20Shelby%20GT500.png?alt=media&token=358b5502-3433-448c-b49b-c7314c9210e6';
      } else if (subcategoryId == 'sports_cars' && i == 1) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FAudi%20RS6.png?alt=media&token=0ab800e1-4c85-43fe-a6e4-badd83f8f805';
      } else if (subcategoryId == 'sports_cars' && i == 2) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FChevrolet%20Corvette%20C8.png?alt=media&token=4a577568-adf2-4460-b9a1-d580998103b9';
      } else if (subcategoryId == 'super_cars' && i == 0) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FFerrari.png?alt=media&token=f8aa60f3-921d-460d-9831-272224a0962d';
      } else if (subcategoryId == 'super_cars' && i == 1) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FLamborghini%20Aventador.png?alt=media&token=27755770-59d1-40cf-8fe1-e646d956d63b';
      } else if (subcategoryId == 'super_cars' && i == 2) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FPorsche%20911%20GT3%20RS.png?alt=media&token=8f2ee6c9-b5b9-40b2-88b9-a34218d6c9c3';
      } else if (subcategoryId == 'jdm' && i == 0) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FHondaCivic.png?alt=media&token=7f61b96f-6c86-4250-9956-7074326341db';
      } else if (subcategoryId == 'jdm' && i == 1) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FToyota%20AE86.png?alt=media&token=768bfe6e-9593-49ff-8cec-518f4a816575';
      } else if (subcategoryId == 'jdm' && i == 2) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FNissan%20Skyline%20GT-R.png?alt=media&token=3dab93f3-23bf-4605-b821-12f22f9c29c7';
      } else if (subcategoryId == 'jdm' && i == 3) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FToyota%20Supra%20MK4.png?alt=media&token=cc091ff0-6ecc-4ea8-8c69-ac471e253e79';
      } else if (subcategoryId == 'jdm' && i == 4) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FToyota%20Yaris.png?alt=media&token=2cc4cb4a-01f7-4879-be52-45d096457ec7';
      } else if (subcategoryId == 'classic_cars' && i == 0) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/wallverse-4804c.firebasestorage.app/o/Cars%2FJeep%20Wrangler.png?alt=media&token=498ab3fb-ef04-4ad8-ab49-4a6ba41ca4da';
      }

      wallpapers.add(Wallpaper(
        id: '${subcategoryId}_wp_$i',
        subcategoryId: subcategoryId,
        imageUrl: imageUrl,
        resolution: resolutions[i % resolutions.length],
        isFree: i < 3, // First 3 are free
      ));
    }

    return wallpapers;
  }
}
