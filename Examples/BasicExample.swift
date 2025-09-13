import SwiftUI
import Palette

// Example of safe Palette initialization
@main
struct PaletteExampleApp: App {
    @State private var palette: Palette
    
    init() {
        // Always start with a fallback theme - never nil
        _palette = State(initialValue: Palette.createWithFallback(from: "themes", defaultName: "Light"))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(palette)
                .task {
                    // Try to load real themes, keep fallback if it fails
                    if let realPalette = Palette.create(from: "themes", defaultName: "Light") {
                        palette = realPalette
                    }
                }
        }
    }
}

struct ContentView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        ThemedContentView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(palette.theme.background)
    }
}

struct ThemedContentView: View {
    @Environment(Palette.self) private var palette
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Palette")
                .font(.largeTitle)
                .foregroundColor(palette.theme.primary)
            
            Text("Current Theme: \(palette.theme.name)")
                .foregroundColor(palette.theme.text)
            
            Button("Switch to Dark Theme") {
                try? palette.setTheme(named: "Dark")
            }
            .foregroundColor(palette.theme.accent)
            .padding()
            .background(palette.theme.primary.opacity(0.1))
            .cornerRadius(8)
            
            // Theme picker
            Picker("Theme", selection: Binding(
                get: { palette.theme.name },
                set: { try? palette.setTheme(named: $0) }
            )) {
                ForEach(palette.getAvailableThemeNames(), id: \.self) { themeName in
                    Text(themeName).tag(themeName)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
    }
}
