/// WallVerse Internationalization System
/// Supports English and Spanish with easy extensibility
library;

class AppLocale {
  final String code;
  final String name;
  final String flag;

  const AppLocale({
    required this.code,
    required this.name,
    required this.flag,
  });
}

class AppLocalizations {
  static const List<AppLocale> supportedLocales = [
    AppLocale(code: 'en', name: 'English', flag: '🇺🇸'),
    AppLocale(code: 'es', name: 'Español', flag: '🇪🇸'),
    AppLocale(code: 'fr', name: 'Français', flag: '🇫🇷'),
    AppLocale(code: 'pt', name: 'Português', flag: '🇧🇷'),
    AppLocale(code: 'de', name: 'Deutsch', flag: '🇩🇪'),
    AppLocale(code: 'ja', name: '日本語', flag: '🇯🇵'),
  ];

  static String _currentLocale = 'en';

  static String get currentLocale => _currentLocale;

  static void setLocale(String locale) {
    if (_translations.containsKey(locale)) {
      _currentLocale = locale;
    }
  }

  static String translate(String key) {
    return _translations[_currentLocale]?[key] ??
        _translations['en']?[key] ??
        key;
  }

  // Shorthand
  static String t(String key) => translate(key);

  static final Map<String, Map<String, String>> _translations = {
    // ─── ENGLISH ────────────────────────────────────────
    'en': {
      // General
      'app_name': 'WallVerse',
      'app_tagline': '4K Wallpapers',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'ok': 'OK',
      'cancel': 'Cancel',
      'close': 'Close',
      'search': 'Search',
      'settings': 'Settings',
      'language': 'Language',
      'select_language': 'Select Language',
      'device_type': 'Device Type',

      // Device types
      'phone': 'Phone',
      'large_phone': 'Large Phone',
      'tablet': 'Tablet',
      'select_device': 'Select Your Device',
      'device_subtitle': 'Wallpapers will be sized for your screen',
      'auto_detect': 'Auto Detect',
      'auto_detect_desc': 'Uses your current screen resolution',
      'resizing': 'Adjusting to', 

      // Navigation
      'home': 'Home',
      'categories': 'Categories',
      'explore': 'Explore',
      'favorites': 'Favorites',

      // Categories
      'anime': 'Anime',
      'games': 'Games',
      'movies': 'Movies',
      'nature': 'Landscapes',
      'neon': 'Neon',
      'cars': 'Cars',
      'space': 'Space',
      'minimalist': 'Minimalist',

      // Anime subcategories
      'naruto': 'Naruto',
      'dragon_ball': 'Dragon Ball',
      'dragon_ball_2': 'Dragon Ball 2',
      'demon_slayer': 'Demon Slayer',
      'one_piece': 'One Piece',
      'attack_on_titan': 'Attack on Titan',

      // Games subcategories
      'roblox': 'Roblox',
      'minecraft': 'Minecraft',
      'call_of_duty': 'Call of Duty',
      'fortnite': 'Fortnite',
      'gta': 'GTA',

      // Movies subcategories
      'marvel': 'Marvel',
      'dc': 'DC',
      'star_wars': 'Star Wars',
      'harry_potter': 'Harry Potter',
      'avatar': 'Avatar',

      // Nature subcategories
      'mountains': 'Mountains',
      'beaches': 'Beaches',
      'forest': 'Forest',
      'waterfalls': 'Waterfalls',
      'sunsets': 'Sunsets',

      // Neon subcategories
      'neon_city': 'Neon City',
      'neon_signs': 'Neon Signs',
      'neon_abstract': 'Neon Abstract',
      'neon_portraits': 'Neon Portraits',
      'neon_gaming': 'Neon Gaming',

      // Cars subcategories
      'sports_cars': 'Sports Cars',
      'classic_cars': 'Classic Cars',
      'super_cars': 'Super Cars',
      'jdm': 'JDM',
      'modified': 'Modified',

      // Space subcategories
      'galaxies': 'Galaxies',
      'planets': 'Planets',
      'nebula': 'Nebula',
      'astronaut': 'Astronaut',
      'black_hole': 'Black Hole',

      // Minimalist subcategories
      'geometric': 'Geometric',
      'gradients': 'Gradients',
      'typography': 'Typography',
      'line_art': 'Line Art',
      'abstract': 'Abstract',

      // Wallpaper actions
      'download': 'Download',
      'set_wallpaper': 'Set Wallpaper',
      'share': 'Share',
      'download_success': 'Wallpaper downloaded successfully!',
      'set_wallpaper_success': 'Wallpaper set successfully!',
      'share_wallpaper': 'Check out this wallpaper from WallVerse!',

      // Premium / Ads
      'premium_wallpaper': 'Premium Wallpaper',
      'watch_ad_to_unlock': 'Watch a short video to unlock this wallpaper',
      'watch_ad': 'Watch Ad',
      'ad_not_ready': 'Ad not ready yet. Please try again.',
      'wallpaper_unlocked': 'Wallpaper unlocked!',
      'free': 'Free',
      'locked': 'Locked',

      // Resolutions
      'hd': 'HD',
      '4k': '4K',
      '8k': '8K',

      // Splash
      'splash_subtitle': 'Your universe of wallpapers',

      // Errors
      'no_wallpapers': 'No wallpapers found',
      'load_error': 'Failed to load content',
      'permission_denied': 'Storage permission required',
      'no_internet': 'No internet connection',
    },

    // ─── ESPAÑOL ────────────────────────────────────────
    'es': {
      // General
      'app_name': 'WallVerse',
      'app_tagline': 'Fondos 4K',
      'loading': 'Cargando...',
      'error': 'Error',
      'retry': 'Reintentar',
      'ok': 'Aceptar',
      'cancel': 'Cancelar',
      'close': 'Cerrar',
      'search': 'Buscar',
      'settings': 'Ajustes',
      'language': 'Idioma',
      'select_language': 'Seleccionar Idioma',
      'device_type': 'Tipo de Dispositivo',

      // Device types
      'phone': 'Teléfono',
      'large_phone': 'Teléfono Grande',
      'tablet': 'Tableta',
      'select_device': 'Selecciona tu Dispositivo',
      'device_subtitle': 'Los fondos se ajustarán a tu pantalla',
      'auto_detect': 'Detectar Automáticamente',
      'auto_detect_desc': 'Usa la resolución actual de tu pantalla',
      'resizing': 'Ajustando a',

      // Navigation
      'home': 'Inicio',
      'categories': 'Categorías',
      'explore': 'Explorar',
      'favorites': 'Favoritos',

      // Categories
      'anime': 'Anime',
      'games': 'Juegos',
      'movies': 'Películas',
      'nature': 'Paisajes',
      'neon': 'Neón',
      'cars': 'Autos',
      'space': 'Espacio',
      'minimalist': 'Minimalista',

      // Anime subcategories
      'naruto': 'Naruto',
      'dragon_ball': 'Dragon Ball',
      'dragon_ball_2': 'Dragon Ball 2',
      'demon_slayer': 'Demon Slayer',
      'one_piece': 'One Piece',
      'attack_on_titan': 'Ataque a los Titanes',

      // Games subcategories
      'roblox': 'Roblox',
      'minecraft': 'Minecraft',
      'call_of_duty': 'Call of Duty',
      'fortnite': 'Fortnite',
      'gta': 'GTA',

      // Movies subcategories
      'marvel': 'Marvel',
      'dc': 'DC',
      'star_wars': 'Star Wars',
      'harry_potter': 'Harry Potter',
      'avatar': 'Avatar',

      // Nature subcategories
      'mountains': 'Montañas',
      'beaches': 'Playas',
      'forest': 'Bosque',
      'waterfalls': 'Cascadas',
      'sunsets': 'Atardeceres',

      // Neon subcategories
      'neon_city': 'Ciudad Neón',
      'neon_signs': 'Letreros Neón',
      'neon_abstract': 'Neón Abstracto',
      'neon_portraits': 'Retratos Neón',
      'neon_gaming': 'Gaming Neón',

      // Cars subcategories
      'sports_cars': 'Autos Deportivos',
      'classic_cars': 'Autos Clásicos',
      'super_cars': 'Super Autos',
      'jdm': 'JDM',
      'modified': 'Modificados',

      // Space subcategories
      'galaxies': 'Galaxias',
      'planets': 'Planetas',
      'nebula': 'Nebulosa',
      'astronaut': 'Astronauta',
      'black_hole': 'Agujero Negro',

      // Minimalist subcategories
      'geometric': 'Geométrico',
      'gradients': 'Degradados',
      'typography': 'Tipografía',
      'line_art': 'Arte Lineal',
      'abstract': 'Abstracto',

      // Wallpaper actions
      'download': 'Descargar',
      'set_wallpaper': 'Establecer Fondo',
      'share': 'Compartir',
      'download_success': '¡Fondo descargado exitosamente!',
      'set_wallpaper_success': '¡Fondo establecido exitosamente!',
      'share_wallpaper': '¡Mira este fondo de pantalla de WallVerse!',

      // Premium / Ads
      'premium_wallpaper': 'Fondo Premium',
      'watch_ad_to_unlock': 'Mira un video corto para desbloquear este fondo',
      'watch_ad': 'Ver Anuncio',
      'ad_not_ready': 'Anuncio no disponible. Intenta de nuevo.',
      'wallpaper_unlocked': '¡Fondo desbloqueado!',
      'free': 'Gratis',
      'locked': 'Bloqueado',

      // Resolutions
      'hd': 'HD',
      '4k': '4K',
      '8k': '8K',

      // Splash
      'splash_subtitle': 'Tu universo de fondos de pantalla',

      // Errors
      'no_wallpapers': 'No se encontraron fondos',
      'load_error': 'Error al cargar contenido',
      'permission_denied': 'Se requiere permiso de almacenamiento',
      'no_internet': 'Sin conexión a internet',
    },

    // ─── FRANÇAIS ───────────────────────────────────────
    'fr': {
      'app_name': 'WallVerse',
      'app_tagline': 'Fonds d\'écran 4K',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'retry': 'Réessayer',
      'ok': 'OK',
      'cancel': 'Annuler',
      'close': 'Fermer',
      'search': 'Rechercher',
      'settings': 'Paramètres',
      'language': 'Langue',
      'select_language': 'Choisir la Langue',
      'device_type': 'Type d\'Appareil',
      'phone': 'Téléphone',
      'large_phone': 'Grand Téléphone',
      'tablet': 'Tablette',
      'home': 'Accueil',
      'categories': 'Catégories',
      'explore': 'Explorer',
      'favorites': 'Favoris',
      'anime': 'Anime',
      'games': 'Jeux',
      'movies': 'Films',
      'nature': 'Nature',
      'neon': 'Néon',
      'cars': 'Voitures',
      'space': 'Espace',
      'minimalist': 'Minimaliste',
      'download': 'Télécharger',
      'set_wallpaper': 'Définir comme fond',
      'share': 'Partager',
      'download_success': 'Fond d\'écran téléchargé !',
      'watch_ad_to_unlock': 'Regardez une vidéo pour débloquer',
      'watch_ad': 'Voir la Pub',
      'free': 'Gratuit',
      'locked': 'Verrouillé',
      'splash_subtitle': 'Votre univers de fonds d\'écran',
      'no_wallpapers': 'Aucun fond d\'écran trouvé',
      'mountains': 'Montagnes',
      'beaches': 'Plages',
      'forest': 'Forêt',
      'waterfalls': 'Cascades',
      'sunsets': 'Couchers de soleil',
      'naruto': 'Naruto',
      'dragon_ball': 'Dragon Ball',
      'dragon_ball_2': 'Dragon Ball 2',
      'demon_slayer': 'Demon Slayer',
      'one_piece': 'One Piece',
      'attack_on_titan': 'L\'Attaque des Titans',
      'marvel': 'Marvel',
      'dc': 'DC',
      'star_wars': 'Star Wars',
      'harry_potter': 'Harry Potter',
      'avatar': 'Avatar',
      'premium_wallpaper': 'Fond Premium',
      'wallpaper_unlocked': 'Fond débloqué !',
    },

    // ─── PORTUGUÊS ──────────────────────────────────────
    'pt': {
      'app_name': 'WallVerse',
      'app_tagline': 'Papéis de Parede 4K',
      'loading': 'Carregando...',
      'error': 'Erro',
      'retry': 'Tentar novamente',
      'ok': 'OK',
      'cancel': 'Cancelar',
      'close': 'Fechar',
      'search': 'Pesquisar',
      'settings': 'Configurações',
      'language': 'Idioma',
      'select_language': 'Selecionar Idioma',
      'device_type': 'Tipo de Dispositivo',
      'phone': 'Celular',
      'large_phone': 'Celular Grande',
      'tablet': 'Tablet',
      'home': 'Início',
      'categories': 'Categorias',
      'anime': 'Anime',
      'games': 'Jogos',
      'movies': 'Filmes',
      'nature': 'Natureza',
      'neon': 'Neon',
      'cars': 'Carros',
      'space': 'Espaço',
      'minimalist': 'Minimalista',
      'download': 'Baixar',
      'set_wallpaper': 'Definir Papel de Parede',
      'share': 'Compartilhar',
      'download_success': 'Papel de parede baixado com sucesso!',
      'watch_ad_to_unlock': 'Assista um vídeo para desbloquear',
      'watch_ad': 'Assistir Anúncio',
      'free': 'Grátis',
      'locked': 'Bloqueado',
      'splash_subtitle': 'Seu universo de papéis de parede',
      'mountains': 'Montanhas',
      'beaches': 'Praias',
      'forest': 'Floresta',
      'waterfalls': 'Cachoeiras',
      'sunsets': 'Pôr do Sol',
    },

    // ─── DEUTSCH ────────────────────────────────────────
    'de': {
      'app_name': 'WallVerse',
      'app_tagline': '4K Hintergrundbilder',
      'loading': 'Laden...',
      'error': 'Fehler',
      'retry': 'Erneut versuchen',
      'ok': 'OK',
      'cancel': 'Abbrechen',
      'close': 'Schließen',
      'search': 'Suchen',
      'settings': 'Einstellungen',
      'language': 'Sprache',
      'select_language': 'Sprache wählen',
      'device_type': 'Gerätetyp',
      'phone': 'Handy',
      'large_phone': 'Großes Handy',
      'tablet': 'Tablet',
      'home': 'Startseite',
      'categories': 'Kategorien',
      'anime': 'Anime',
      'games': 'Spiele',
      'movies': 'Filme',
      'nature': 'Natur',
      'neon': 'Neon',
      'cars': 'Autos',
      'space': 'Weltraum',
      'minimalist': 'Minimalistisch',
      'download': 'Herunterladen',
      'set_wallpaper': 'Als Hintergrund',
      'share': 'Teilen',
      'download_success': 'Hintergrundbild heruntergeladen!',
      'watch_ad_to_unlock': 'Video ansehen zum Freischalten',
      'watch_ad': 'Werbung ansehen',
      'free': 'Kostenlos',
      'locked': 'Gesperrt',
      'splash_subtitle': 'Dein Universum für Hintergrundbilder',
      'mountains': 'Berge',
      'beaches': 'Strände',
      'forest': 'Wald',
      'waterfalls': 'Wasserfälle',
      'sunsets': 'Sonnenuntergänge',
    },

    // ─── 日本語 ──────────────────────────────────────────
    'ja': {
      'app_name': 'WallVerse',
      'app_tagline': '4K壁紙',
      'loading': '読み込み中...',
      'error': 'エラー',
      'retry': '再試行',
      'ok': 'OK',
      'cancel': 'キャンセル',
      'close': '閉じる',
      'search': '検索',
      'settings': '設定',
      'language': '言語',
      'select_language': '言語を選択',
      'device_type': 'デバイスタイプ',
      'phone': 'スマートフォン',
      'large_phone': '大型スマートフォン',
      'tablet': 'タブレット',
      'home': 'ホーム',
      'categories': 'カテゴリー',
      'anime': 'アニメ',
      'games': 'ゲーム',
      'movies': '映画',
      'nature': '自然',
      'neon': 'ネオン',
      'cars': '車',
      'space': '宇宙',
      'minimalist': 'ミニマリスト',
      'download': 'ダウンロード',
      'set_wallpaper': '壁紙に設定',
      'share': '共有',
      'download_success': '壁紙をダウンロードしました！',
      'watch_ad_to_unlock': '動画を見てロック解除',
      'watch_ad': '広告を見る',
      'free': '無料',
      'locked': 'ロック',
      'splash_subtitle': '壁紙の宇宙へようこそ',
      'mountains': '山',
      'beaches': 'ビーチ',
      'forest': '森',
      'waterfalls': '滝',
      'sunsets': '夕日',
    },
  };
}
