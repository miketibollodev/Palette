# Palette

A SwiftUI-first theme management package that provides seamless color theming through SwiftUI's environment system. Define your themes in JSON and inject them into your SwiftUI views using `@Environment` for automatic UI updates.

## Features

- **JSON-based theme definitions** - Define your themes in simple JSON files
- **SwiftUI Environment integration** - Inject themes using `@Environment` for automatic updates
- **Comprehensive validation** - Detailed error handling for invalid themes and colors
- **Multi-platform support** - Works on iOS 17+, macOS 14+, watchOS 10+, and tvOS 17+
- **Well tested** - Comprehensive test coverage with Swift Testing
- **Type-safe** - Dynamic member lookup for easy color access
- **Persistent storage** - Automatically saves and restores the selected theme
- **Reactive updates** - UI automatically updates when themes change

## Installation

### Swift Package Manager

Add Palette to your project using Swift Package Manager:

1. In Xcode, go to **File > Add Package Dependencies**
2. Enter the repository URL: `https://github.com/miketibollodev/Palette.git`
3. Select the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/miketibollodev/Palette.git", from: "1.0.0")
]
```

## Quick Start

### 1. Create a Theme JSON File

Create a JSON file (e.g., `themes.json`) in your app bundle:

```json
[
  {
    "name": "Light",
    "colors": {
      "primary": "#007AFF",
      "secondary": "#5856D6",
      "background": "#FFFFFF",
      "text": "#000000",
      "accent": "#FF3B30"
    }
  },
  {
    "name": "Dark",
    "colors": {
      "primary": "#0A84FF",
      "secondary": "#5E5CE6",
      "background": "#000000",
      "text": "#FFFFFF",
      "accent": "#FF453A"
    }
  }
]
```

### 2. Set Up Environment in Your App

```swift
import SwiftUI
import Palette

@main
struct MyApp: App {
    @State private var palette: Palette?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(palette)
                .onAppear {
                    loadThemes()
                }
        }
    }
    
    private func loadThemes() {
        do {
            palette = try Palette(from: "themes", defaultName: "Light")
        } catch {
            print("Failed to load themes: \(error)")
        }
    }
}
```

### 3. Use Colors in Your SwiftUI Views

```swift
import SwiftUI
import Palette

struct ContentView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Palette")
                .font(.largeTitle)
                .foregroundColor(palette?.theme.primary)
            
            Text("This text uses the secondary color")
                .foregroundColor(palette?.theme.secondary)
            
            Button("Switch to Dark Theme") {
                try? palette?.setTheme(named: "Dark")
            }
            .foregroundColor(palette?.theme.accent)
            .padding()
            .background(palette?.theme.primary.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(palette?.theme.background)
    }
}
```

## Advanced SwiftUI Usage

### Environment-Based Theme Management

```swift
import SwiftUI
import Palette

// Use @State at the app level for theme management
@main
struct MyApp: App {
    @State private var palette: Palette?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(palette)
                .onAppear {
                    loadThemes()
                }
        }
    }
    
    private func loadThemes() {
        do {
            palette = try Palette(from: "themes", defaultName: "Light")
        } catch {
            print("Failed to load themes: \(error)")
        }
    }
}

// Use @Environment in your views
struct ThemedView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack {
            Text("Current Theme: \(palette?.theme.name ?? "None")")
                .foregroundColor(palette?.theme.text)
            
            // Theme picker
            Picker("Theme", selection: Binding(
                get: { palette?.theme.name ?? "" },
                set: { try? palette?.setTheme(named: $0) }
            )) {
                ForEach(palette?.getAvailableThemeNames() ?? [], id: \.self) { themeName in
                    Text(themeName).tag(themeName)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .background(palette?.theme.background)
    }
}
```

### Custom View Modifiers

```swift
import SwiftUI
import Palette

// Create custom view modifiers for common theming patterns
struct ThemedButton: ViewModifier {
    @Environment(Palette.self) private var palette
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary, accent
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(buttonTextColor)
            .background(buttonBackgroundColor)
            .cornerRadius(8)
    }
    
    private var buttonTextColor: Color {
        guard let palette = palette else { return .primary }
        switch style {
        case .primary: return .white
        case .secondary: return palette.theme.primary
        case .accent: return .white
        }
    }
    
    private var buttonBackgroundColor: Color {
        guard let palette = palette else { return .blue }
        switch style {
        case .primary: return palette.theme.primary
        case .secondary: return palette.theme.primary.opacity(0.1)
        case .accent: return palette.theme.accent
        }
    }
}

// Usage
struct MyView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack {
            Button("Primary Action") { }
                .modifier(ThemedButton(style: .primary))
            
            Button("Secondary Action") { }
                .modifier(ThemedButton(style: .secondary))
            
            Button("Accent Action") { }
                .modifier(ThemedButton(style: .accent))
        }
    }
}
```

### Theme Validation and Error Handling

```swift
import SwiftUI
import Palette

struct ThemeValidationView: View {
    @State private var validationResult: String = ""
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack {
            Text("Theme Validation")
                .font(.headline)
                .foregroundColor(palette?.theme.primary)
            
            Button("Validate Current Themes") {
                validateThemes()
            }
            .modifier(ThemedButton(style: .primary))
            
            Text(validationResult)
                .foregroundColor(palette?.theme.text)
                .padding()
        }
        .background(palette?.theme.background)
    }
    
    private func validateThemes() {
        do {
            let themes = try Palette.validateThemeFile("themes")
            validationResult = "✅ Found \(themes.count) valid themes"
        } catch PaletteError.invalidHexColor(let hex) {
            validationResult = "❌ Invalid hex color: \(hex)"
        } catch PaletteError.fileNotFound(let fileName) {
            validationResult = "❌ Theme file not found: \(fileName)"
        } catch {
            validationResult = "❌ Validation error: \(error.localizedDescription)"
        }
    }
}
```

### Dynamic Color Access

```swift
import SwiftUI
import Palette

struct ColorShowcaseView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(palette?.theme.colorNames ?? [], id: \.self) { colorName in
                    ColorSwatch(colorName: colorName)
                }
            }
            .padding()
        }
        .background(palette?.theme.background)
    }
}

struct ColorSwatch: View {
    let colorName: String
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(palette?.theme.color(named: colorName, fallback: .gray) ?? .gray)
                .frame(height: 100)
                .cornerRadius(8)
            
            Text(colorName)
                .font(.caption)
                .foregroundColor(palette?.theme.text)
        }
        .padding(8)
        .background(palette?.theme.background.opacity(0.5))
        .cornerRadius(8)
    }
}
```

## SwiftUI Error Handling

Handle errors gracefully in your SwiftUI views:

```swift
import SwiftUI
import Palette

struct ThemeErrorView: View {
    @State private var errorMessage: String?
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack {
            if let error = errorMessage {
                Text("Theme Error")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text(error)
                    .foregroundColor(palette?.theme.text)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Retry") {
                    loadThemes()
                }
                .modifier(ThemedButton(style: .primary))
            } else {
                // Your normal content here
                ContentView()
            }
        }
        .onAppear {
            loadThemes()
        }
    }
    
    private func loadThemes() {
        do {
            // This would be called from your app's theme loading
            let themes = try Palette.validateThemeFile("themes")
            errorMessage = nil
        } catch PaletteError.fileNotFound(let fileName) {
            errorMessage = "Theme file not found: \(fileName)"
        } catch PaletteError.invalidHexColor(let hex) {
            errorMessage = "Invalid hex color: \(hex)"
        } catch PaletteError.themeNotFound(let name) {
            errorMessage = "Theme not found: \(name)"
        } catch PaletteError.invalidTheme(let details) {
            errorMessage = "Invalid theme: \(details)"
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
}
```

## SwiftUI Best Practices

### 1. Use @State at App Level for Theme Management

```swift
// Use @State at the app level for simple theme management
@main
struct MyApp: App {
    @State private var palette: Palette?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(palette)
                .onAppear {
                    loadThemes()
                }
        }
    }
    
    private func loadThemes() {
        do {
            palette = try Palette(from: "themes", defaultName: "Light")
        } catch {
            print("Failed to load themes: \(error)")
        }
    }
}
```

### 2. Create Reusable Themed Components

```swift
struct ThemedCard<Content: View>: View {
    let content: Content
    @Environment(Palette.self) private var palette
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(palette?.theme.background.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(palette?.theme.primary.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(8)
    }
}
```

### 3. Handle Theme Loading States

```swift
struct ThemeLoadingView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        Group {
            if palette == nil {
                ProgressView("Loading themes...")
                    .foregroundColor(.secondary)
            } else {
                ContentView()
            }
        }
    }
}
```

## Supported Color Formats

- `#RRGGBB` - 6-digit hex (e.g., `#FF0000`)
- `RRGGBB` - 6-digit hex without # (e.g., `FF0000`)
- `#RRGGBBAA` - 8-digit hex with alpha (e.g., `#FF0000FF`)
- `RRGGBBAA` - 8-digit hex with alpha, no # (e.g., `FF0000FF`)

## Requirements

- iOS 17.0+
- macOS 14.0+
- watchOS 10.0+
- tvOS 17.0+
- Swift 5.9+

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please file an issue on GitHub.
