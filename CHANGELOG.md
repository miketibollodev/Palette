# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] - 2025-01-XX

### Fixed
- Fixed crash when passing nil Palette to @Environment(Palette.self)
- Improved initialization safety with fallback themes
- Updated all examples to use non-optional Palette objects

### Added
- `Palette.createWithFallback()` method for safe initialization
- Fallback theme system with basic colors when file loading fails
- Private initializer for creating Palette with existing themes
- Comprehensive example showing safe initialization patterns

### Changed
- All README examples now use non-optional Palette
- Simplified view code by removing optional handling
- Updated initialization patterns to prevent crashes

## [1.0.0] - 2025-01-XX

### Added
- Initial release of Palette
- JSON-based theme definitions
- SwiftUI Environment integration with @Observable
- Comprehensive error handling
- Multi-platform support (iOS 17+, macOS 14+, watchOS 10+, tvOS 17+)
- Dynamic theme switching
- Persistent theme storage
- Type-safe color access with dynamic member lookup
- Theme validation
- Comprehensive test coverage

### Features
- 🎨 JSON-based theme definitions
- 🔄 SwiftUI Environment integration
- ✅ Comprehensive validation
- 📱 Multi-platform support
- 🧪 Well tested
- 🎯 Type-safe
- 💾 Persistent storage
- 🌊 Reactive updates
