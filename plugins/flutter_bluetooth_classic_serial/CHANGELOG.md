## 1.3.2

### Bug Fixes
- 🛠️ **iOS Plugin Registration**: Fixed Swift plugin class name references in pubspec.yaml for proper iOS builds
- 🛠️ **macOS Plugin Registration**: Fixed Swift plugin class name references in pubspec.yaml for proper macOS builds
- 📱 **Cross-Platform Compatibility**: Ensured consistent plugin registration across all supported platforms

## 1.3.1

### Maintenance
- 📚 **Documentation Updates**: Updated README with comprehensive platform support information
- 🔧 **Version Alignment**: Synchronized version numbers across documentation and package files

## 1.3.0

### Features
- 🐧 **Linux Support**: Added complete Bluetooth Classic support for Linux platform
- 🔧 **BlueZ Integration**: Implemented native Linux Bluetooth Classic communication using BlueZ stack
- 📱 **Cross-platform Expansion**: Extended plugin support to Android, iOS, macOS, Linux, and Windows platforms
- 🔄 **RFCOMM Communication**: Added RFCOMM socket-based serial communication for Linux

### Technical Improvements
- 🏗️ **Platform Architecture**: Created Linux-specific C++ implementation with HCI and RFCOMM support
- 🔄 **Unified API**: Maintained consistent API across all supported platforms
- 📦 **Plugin Registration**: Updated Linux plugin registration and build configuration
- 🧵 **Threading**: Implemented proper threading for Bluetooth data reception on Linux

## 1.2.0

### Features
- 🍎 **macOS Support**: Added complete Bluetooth Classic support for macOS platform
- 🔧 **IOBluetooth Integration**: Implemented native macOS Bluetooth Classic communication using IOBluetooth framework
- 📱 **Cross-platform Expansion**: Extended plugin support to Android, iOS, macOS, and Windows platforms
- 🔐 **macOS Permissions**: Added Bluetooth usage description for proper macOS app permissions

### Technical Improvements
- 🏗️ **Platform Architecture**: Created macOS-specific Swift implementation with RFCOMM channel support
- 🔄 **Unified API**: Maintained consistent API across all supported platforms
- 📦 **Plugin Registration**: Updated macOS plugin registration and configuration

## 1.1.1

### Bug Fixes
- 🔧 **Fixed sendData Type Casting**: Resolved "byte[] cannot be cast to java.util.List" runtime errors in Android
- 📱 **Enhanced iOS Data Handling**: Improved sendData method to handle multiple input types (List<int>, FlutterStandardTypedData, Data)
- 🪟 **Windows Build Fixes**: Corrected CMake target naming and include path issues for Windows plugin
- 🔄 **Cross-platform Type Safety**: Implemented robust type checking and conversion in all platform implementations
- 📡 **UTF-8 Serialization**: Fixed sendString method to use explicit List<int> conversion for consistent platform channel serialization

### Technical Improvements
- 🛡️ **Defensive Programming**: Added type validation in sendData methods across all platforms
- 🔧 **Platform Channel Compatibility**: Ensured consistent data type handling between Dart and native platforms

## 1.1.0

### Features
- ✨ **Complete Device Discovery**: Added `getDiscoveredDevices()` method to retrieve devices found during discovery
- 🔍 **Real-time Discovery Events**: Added `onDeviceDiscovered` stream for live device discovery notifications
- 📱 **Enhanced Example App**: Updated example to display discovered devices alongside paired devices
- 🔄 **Discovery Session Management**: Clear discovered devices list when starting new discovery session
- 🛡️ **Duplicate Prevention**: Prevent duplicate devices in discovery results

### Technical Improvements
- 📡 **Cross-platform Discovery**: Implemented device discovery storage in both Android and iOS plugins
- 🔧 **Event Channel Enhancement**: Modified state channel to handle device discovery events separately
- 🏗️ **API Consistency**: Added discovery methods to platform interface for consistent cross-platform behavior

## 1.0.4

### Bug Fixes
- 📱 Added missing iOS podspec file to fix CocoaPods integration
- 🔧 Fixed "No podspec found for flutter_bluetooth_classic_serial" error
- 📦 Configured iOS podspec with proper Swift 5.0 and iOS 11.0+ support
- 🏗️ Improved package structure for better cross-platform compatibility

## 1.0.3

### Bug Fixes
- 🔧 Fixed MissingPluginException errors by correcting channel name mismatches
- ✅ Updated Android, iOS, and Windows plugin implementations with proper channel names
- 🛠️ Fixed Android Bluetooth permissions in plugin manifest
- 📱 Created working example app with comprehensive Bluetooth demo
- 🔍 Fixed API usage in example to match singleton pattern
- ⚡ Improved error handling and user feedback in example app
- 🎯 Added support for Android 12+ Bluetooth permissions

## 1.0.1

### Bug Fixes
- ✅ Updated repository URLs to correct GitHub location
- ✅ Improved package metadata for pub.dev publication
- ✅ Removed unsupported web platform references
- 🔧 Updated Android package structure for better compatibility

## 1.0.0

### Features
- ✨ Initial release of Flutter Bluetooth Classic plugin
- 🔍 Device discovery and pairing
- 🔗 Connection management for Android, iOS, and Windows
- 📡 Bidirectional data transmission
- 📱 Multi-platform support (Android, iOS, Windows)
- 🔄 Real-time data streaming
- 🛡️ Robust error handling and connection management

### Platform Support
- ✅ Android: Full Bluetooth Classic support
- ✅ iOS: MFi accessory framework integration
- ✅ Windows: Native Windows Bluetooth API integration

### API
- `FlutterBluetoothClassic.instance` - Main plugin interface
- `BluetoothConnection.toAddress()` - Device connection
- Device discovery and enumeration
- Data transmission and reception
- Connection state management
