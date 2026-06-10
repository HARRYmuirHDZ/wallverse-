/// Device profile model for wallpaper sizing
/// Contains real phone models with their exact screen resolutions
class DeviceProfile {
  final String id;
  final String brand;
  final String model;
  final int width;
  final int height;
  final String displaySize; // e.g. "6.1 inch"

  const DeviceProfile({
    required this.id,
    required this.brand,
    required this.model,
    required this.width,
    required this.height,
    required this.displaySize,
  });

  String get resolution => '${width}x$height';
  double get aspectRatio => width / height;

  @override
  String toString() => '$brand $model ($resolution)';
}

/// All available device brands and their models
class DeviceCatalog {
  static const List<DeviceBrand> brands = [
    // ─── AUTO DETECT ───────────────────────────────────
    DeviceBrand(
      name: 'Auto',
      icon: '📱',
      devices: [
        DeviceProfile(
          id: 'auto',
          brand: 'Auto',
          model: 'Detectar mi pantalla',
          width: 0,
          height: 0,
          displaySize: 'Auto',
        ),
      ],
    ),

    // ─── SAMSUNG ───────────────────────────────────────
    DeviceBrand(
      name: 'Samsung',
      icon: '🔵',
      devices: [
        DeviceProfile(
          id: 'samsung_s24_ultra',
          brand: 'Samsung',
          model: 'Galaxy S24 Ultra',
          width: 1440,
          height: 3120,
          displaySize: '6.8"',
        ),
        DeviceProfile(
          id: 'samsung_s24_plus',
          brand: 'Samsung',
          model: 'Galaxy S24+',
          width: 1440,
          height: 3120,
          displaySize: '6.7"',
        ),
        DeviceProfile(
          id: 'samsung_s24',
          brand: 'Samsung',
          model: 'Galaxy S24',
          width: 1080,
          height: 2340,
          displaySize: '6.2"',
        ),
        DeviceProfile(
          id: 'samsung_s23_ultra',
          brand: 'Samsung',
          model: 'Galaxy S23 Ultra',
          width: 1440,
          height: 3088,
          displaySize: '6.8"',
        ),
        DeviceProfile(
          id: 'samsung_a54',
          brand: 'Samsung',
          model: 'Galaxy A54',
          width: 1080,
          height: 2340,
          displaySize: '6.4"',
        ),
        DeviceProfile(
          id: 'samsung_a34',
          brand: 'Samsung',
          model: 'Galaxy A34',
          width: 1080,
          height: 2340,
          displaySize: '6.6"',
        ),
        DeviceProfile(
          id: 'samsung_a15',
          brand: 'Samsung',
          model: 'Galaxy A15',
          width: 1080,
          height: 2340,
          displaySize: '6.5"',
        ),
        DeviceProfile(
          id: 'samsung_zfold5',
          brand: 'Samsung',
          model: 'Galaxy Z Fold 5',
          width: 1812,
          height: 2176,
          displaySize: '7.6"',
        ),
      ],
    ),

    // ─── APPLE ─────────────────────────────────────────
    DeviceBrand(
      name: 'iPhone',
      icon: '⚪',
      devices: [
        DeviceProfile(
          id: 'iphone_16_pro_max',
          brand: 'iPhone',
          model: '16 Pro Max',
          width: 1320,
          height: 2868,
          displaySize: '6.9"',
        ),
        DeviceProfile(
          id: 'iphone_16_pro',
          brand: 'iPhone',
          model: '16 Pro',
          width: 1206,
          height: 2622,
          displaySize: '6.3"',
        ),
        DeviceProfile(
          id: 'iphone_16',
          brand: 'iPhone',
          model: '16',
          width: 1179,
          height: 2556,
          displaySize: '6.1"',
        ),
        DeviceProfile(
          id: 'iphone_15',
          brand: 'iPhone',
          model: '15',
          width: 1179,
          height: 2556,
          displaySize: '6.1"',
        ),
        DeviceProfile(
          id: 'iphone_14',
          brand: 'iPhone',
          model: '14',
          width: 1170,
          height: 2532,
          displaySize: '6.1"',
        ),
        DeviceProfile(
          id: 'iphone_se',
          brand: 'iPhone',
          model: 'SE (3rd gen)',
          width: 750,
          height: 1334,
          displaySize: '4.7"',
        ),
      ],
    ),

    // ─── XIAOMI ────────────────────────────────────────
    DeviceBrand(
      name: 'Xiaomi',
      icon: '🟠',
      devices: [
        DeviceProfile(
          id: 'xiaomi_14_ultra',
          brand: 'Xiaomi',
          model: '14 Ultra',
          width: 1440,
          height: 3200,
          displaySize: '6.73"',
        ),
        DeviceProfile(
          id: 'xiaomi_14',
          brand: 'Xiaomi',
          model: '14',
          width: 1200,
          height: 2670,
          displaySize: '6.36"',
        ),
        DeviceProfile(
          id: 'redmi_note_13_pro',
          brand: 'Xiaomi',
          model: 'Redmi Note 13 Pro',
          width: 1220,
          height: 2712,
          displaySize: '6.67"',
        ),
        DeviceProfile(
          id: 'redmi_note_13',
          brand: 'Xiaomi',
          model: 'Redmi Note 13',
          width: 1080,
          height: 2400,
          displaySize: '6.67"',
        ),
        DeviceProfile(
          id: 'poco_x6',
          brand: 'Xiaomi',
          model: 'POCO X6',
          width: 1220,
          height: 2712,
          displaySize: '6.67"',
        ),
      ],
    ),

    // ─── MOTOROLA ──────────────────────────────────────
    DeviceBrand(
      name: 'Motorola',
      icon: '🔴',
      devices: [
        DeviceProfile(
          id: 'moto_edge_50',
          brand: 'Motorola',
          model: 'Edge 50 Pro',
          width: 1220,
          height: 2712,
          displaySize: '6.7"',
        ),
        DeviceProfile(
          id: 'moto_g84',
          brand: 'Motorola',
          model: 'Moto G84',
          width: 1080,
          height: 2400,
          displaySize: '6.55"',
        ),
        DeviceProfile(
          id: 'moto_g54',
          brand: 'Motorola',
          model: 'Moto G54',
          width: 1080,
          height: 2400,
          displaySize: '6.5"',
        ),
      ],
    ),

    // ─── GOOGLE ────────────────────────────────────────
    DeviceBrand(
      name: 'Google',
      icon: '🟢',
      devices: [
        DeviceProfile(
          id: 'pixel_9_pro',
          brand: 'Google',
          model: 'Pixel 9 Pro',
          width: 1280,
          height: 2856,
          displaySize: '6.3"',
        ),
        DeviceProfile(
          id: 'pixel_9',
          brand: 'Google',
          model: 'Pixel 9',
          width: 1080,
          height: 2424,
          displaySize: '6.3"',
        ),
        DeviceProfile(
          id: 'pixel_8a',
          brand: 'Google',
          model: 'Pixel 8a',
          width: 1080,
          height: 2400,
          displaySize: '6.1"',
        ),
      ],
    ),

    // ─── HUAWEI ────────────────────────────────────────
    DeviceBrand(
      name: 'Huawei',
      icon: '🔶',
      devices: [
        DeviceProfile(
          id: 'huawei_p60_pro',
          brand: 'Huawei',
          model: 'P60 Pro',
          width: 1220,
          height: 2700,
          displaySize: '6.67"',
        ),
        DeviceProfile(
          id: 'huawei_nova_12',
          brand: 'Huawei',
          model: 'Nova 12',
          width: 1080,
          height: 2412,
          displaySize: '6.7"',
        ),
      ],
    ),

    // ─── ONEPLUS ────────────────────────────────────────
    DeviceBrand(
      name: 'OnePlus',
      icon: '🟡',
      devices: [
        DeviceProfile(
          id: 'oneplus_12',
          brand: 'OnePlus',
          model: '12',
          width: 1440,
          height: 3168,
          displaySize: '6.82"',
        ),
        DeviceProfile(
          id: 'oneplus_nord_3',
          brand: 'OnePlus',
          model: 'Nord 3',
          width: 1240,
          height: 2772,
          displaySize: '6.74"',
        ),
      ],
    ),
  ];

  /// Find a device profile by its ID
  static DeviceProfile? findById(String id) {
    for (final brand in brands) {
      for (final device in brand.devices) {
        if (device.id == id) return device;
      }
    }
    return null;
  }
}

/// Groups devices by brand for the UI selector
class DeviceBrand {
  final String name;
  final String icon;
  final List<DeviceProfile> devices;

  const DeviceBrand({
    required this.name,
    required this.icon,
    required this.devices,
  });
}
