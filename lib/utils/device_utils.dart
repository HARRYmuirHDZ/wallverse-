import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../models/device_profile.dart';

/// Device types for responsive wallpaper sizing
enum DeviceType { phone, largePhone, tablet }

/// Manages device type selection, specific device model, and language preferences
class DeviceProvider extends ChangeNotifier {
  DeviceType _deviceType = DeviceType.phone;
  String _languageCode = 'en';
  String _selectedDeviceId = 'auto'; // Default to auto-detect
  DeviceProfile? _selectedDevice;

  DeviceType get deviceType => _deviceType;
  String get languageCode => _languageCode;
  String get selectedDeviceId => _selectedDeviceId;
  DeviceProfile? get selectedDevice => _selectedDevice;

  /// Returns true if the user has selected "Auto" (detect screen automatically)
  bool get isAutoDetect => _selectedDeviceId == 'auto';

  DeviceProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load device type (legacy)
    final savedDevice = prefs.getString('device_type') ?? 'phone';
    switch (savedDevice) {
      case 'largePhone':
        _deviceType = DeviceType.largePhone;
        break;
      case 'tablet':
        _deviceType = DeviceType.tablet;
        break;
      default:
        _deviceType = DeviceType.phone;
    }

    // Load specific device model
    _selectedDeviceId = prefs.getString('selected_device_id') ?? 'auto';
    _selectedDevice = DeviceCatalog.findById(_selectedDeviceId);

    // Load language
    _languageCode = prefs.getString('language_code') ?? 'en';
    AppLocalizations.setLocale(_languageCode);

    notifyListeners();
  }

  Future<void> setDeviceType(DeviceType type) async {
    _deviceType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_type', type.name);
    notifyListeners();
  }

  /// Set the specific device model for wallpaper sizing
  Future<void> setSelectedDevice(DeviceProfile device) async {
    _selectedDeviceId = device.id;
    _selectedDevice = device.id == 'auto' ? null : device;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_device_id', device.id);

    // Also update legacy device type based on resolution
    if (device.id != 'auto') {
      if (device.width >= 1800) {
        _deviceType = DeviceType.tablet;
      } else if (device.width >= 1400) {
        _deviceType = DeviceType.largePhone;
      } else {
        _deviceType = DeviceType.phone;
      }
      await prefs.setString('device_type', _deviceType.name);
    }

    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    AppLocalizations.setLocale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
    notifyListeners();
  }

  /// Get device-appropriate dimensions for wallpaper download
  /// If a specific device is selected, returns its exact resolution.
  /// If auto-detect, returns based on the actual screen size.
  Size getWallpaperSize([BuildContext? context]) {
    // If a specific device model is selected, use its exact resolution
    if (_selectedDevice != null) {
      return Size(
        _selectedDevice!.width.toDouble(),
        _selectedDevice!.height.toDouble(),
      );
    }

    // If auto-detect and we have a context, use actual screen resolution
    if (context != null) {
      final mq = MediaQuery.of(context);
      final pixelRatio = mq.devicePixelRatio;
      return Size(
        mq.size.width * pixelRatio,
        mq.size.height * pixelRatio,
      );
    }

    // Fallback based on device type
    switch (_deviceType) {
      case DeviceType.phone:
        return const Size(1080, 1920);
      case DeviceType.largePhone:
        return const Size(1440, 3120);
      case DeviceType.tablet:
        return const Size(2048, 2732);
    }
  }

  /// Get a friendly description of the current device setting
  String getSelectedDeviceLabel() {
    if (_selectedDevice != null) {
      return '${_selectedDevice!.brand} ${_selectedDevice!.model}';
    }
    return AppLocalizations.t('auto_detect');
  }

  /// Get grid column count for device type
  int getGridColumns() {
    switch (_deviceType) {
      case DeviceType.phone:
        return 2;
      case DeviceType.largePhone:
        return 2;
      case DeviceType.tablet:
        return 3;
    }
  }

  /// Get device type display name
  String getDeviceLabel(DeviceType type) {
    switch (type) {
      case DeviceType.phone:
        return AppLocalizations.t('phone');
      case DeviceType.largePhone:
        return AppLocalizations.t('large_phone');
      case DeviceType.tablet:
        return AppLocalizations.t('tablet');
    }
  }

  /// Get device icon
  IconData getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.phone:
        return Icons.smartphone;
      case DeviceType.largePhone:
        return Icons.phone_android;
      case DeviceType.tablet:
        return Icons.tablet_android;
    }
  }
}
