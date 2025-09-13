//
//  Palette.swift
//  Palette
//
//  Created by Michael Tibollo on 2025-09-12.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Observable
public final class Palette {
    
    /// The currently active theme
    public private(set) var theme: Theme
    
    /// All available themes
    public private(set) var themes: [Theme]
    
    /// The default theme name (if specified during initialization)
    public private(set) var defaultThemeName: String?
    
    private let key: String = "Palette.currentTheme"
    
    /// Initialize Palette with themes from a JSON file
    /// - Parameters:
    ///   - fileName: The name of the JSON file (without extension)
    ///   - defaultName: Optional default theme name to use if no saved theme exists
    ///   - bundle: The bundle to load the file from (defaults to .main)
    /// - Throws: PaletteError if themes cannot be loaded or are invalid
    public init(from fileName: String, defaultName: String? = nil, bundle: Bundle = .main) throws {
        let themes = try ThemeLoader.loadThemes(fileName: fileName, bundle: bundle)
        guard !themes.isEmpty else {
            throw PaletteError.noThemesAvailable
        }
        
        // Validate themes
        for theme in themes {
            try Palette.validateTheme(theme)
        }
        
        self.themes = themes
        self.defaultThemeName = defaultName
        
        // Set initial theme
        if let savedName = UserDefaults.standard.string(forKey: key), 
           let savedTheme = themes.first(where: { $0.name == savedName }) {
            self.theme = savedTheme
        } else if let defaultName, 
                  let defaultTheme = themes.first(where: { $0.name == defaultName }) {
            self.theme = defaultTheme
        } else if let first = themes.first {
            self.theme = first
        } else {
            throw PaletteError.noThemesAvailable
        }
    }
    
    /// Create a Palette instance safely, returning nil if initialization fails
    /// - Parameters:
    ///   - fileName: The name of the JSON file (without extension)
    ///   - defaultName: Optional default theme name to use if no saved theme exists
    ///   - bundle: The bundle to load the file from (defaults to .main)
    /// - Returns: A Palette instance if successful, nil otherwise
    public static func create(from fileName: String, defaultName: String? = nil, bundle: Bundle = .main) -> Palette? {
        do {
            return try Palette(from: fileName, defaultName: defaultName, bundle: bundle)
        } catch {
            print("Failed to create Palette: \(error)")
            return nil
        }
    }
    
    /// Create a Palette with a default theme as fallback
    /// - Parameters:
    ///   - fileName: The name of the JSON file (without extension)
    ///   - defaultName: Optional default theme name to use if no saved theme exists
    ///   - bundle: The bundle to load the file from (defaults to .main)
    /// - Returns: A Palette instance with fallback theme if file loading fails
    public static func createWithFallback(from fileName: String, defaultName: String? = nil, bundle: Bundle = .main) -> Palette {
        if let palette = create(from: fileName, defaultName: defaultName, bundle: bundle) {
            return palette
        } else {
            // Create a fallback palette with basic colors
            let fallbackTheme = Theme(
                name: "Fallback",
                colors: [
                    "primary": .blue,
                    "secondary": .gray,
                    "background": .white,
                    "text": .black,
                    "accent": .red
                ]
            )
            return Palette(themes: [fallbackTheme], defaultTheme: fallbackTheme)
        }
    }
    
    /// Initialize Palette with existing themes (for fallback scenarios)
    /// - Parameters:
    ///   - themes: Array of themes to use
    ///   - defaultTheme: The default theme to use
    private init(themes: [Theme], defaultTheme: Theme) {
        self.themes = themes
        self.theme = defaultTheme
        self.defaultThemeName = defaultTheme.name
    }
    
    /// Set the active theme
    /// - Parameter theme: The theme to set as active
    /// - Throws: PaletteError.themeNotFound if the theme is not in the available themes
    public func setTheme(_ theme: Theme) throws {
        guard themes.contains(theme) else {
            throw PaletteError.themeNotFound(theme.name)
        }
        self.theme = theme
        UserDefaults.standard.set(theme.name, forKey: key)
    }
    
    /// Set the active theme by name
    /// - Parameter name: The name of the theme to set
    /// - Throws: PaletteError.themeNotFound if no theme with that name exists
    public func setTheme(named name: String) throws {
        guard let theme = themes.first(where: { $0.name == name }) else {
            throw PaletteError.themeNotFound(name)
        }
        try setTheme(theme)
    }
    
    /// Get all available theme names
    /// - Returns: An array of theme names
    public func getAvailableThemeNames() -> [String] {
        return themes.map { $0.name }.sorted()
    }
    
    /// Check if a theme exists
    /// - Parameter name: The theme name to check
    /// - Returns: True if the theme exists, false otherwise
    public func hasTheme(named name: String) -> Bool {
        return themes.contains { $0.name == name }
    }
    
    /// Reset to the default theme
    /// - Throws: PaletteError.themeNotFound if no default theme is set or found
    public func resetToDefault() throws {
        guard let defaultName = defaultThemeName else {
            throw PaletteError.themeNotFound("No default theme specified")
        }
        try setTheme(named: defaultName)
    }
    
    /// Validate a theme file without loading it into the palette
    /// - Parameters:
    ///   - fileName: The name of the JSON file (without extension)
    ///   - bundle: The bundle to load the file from (defaults to .main)
    /// - Returns: An array of validated themes
    /// - Throws: PaletteError if the file cannot be loaded or themes are invalid
    public static func validateThemeFile(_ fileName: String, bundle: Bundle = .main) throws -> [Theme] {
        let themes = try ThemeLoader.loadThemes(fileName: fileName, bundle: bundle)
        
        for theme in themes {
            try validateTheme(theme)
        }
        
        return themes
    }
    
    /// Validate a single theme
    /// - Parameter theme: The theme to validate
    /// - Throws: PaletteError if the theme is invalid
    private static func validateTheme(_ theme: Theme) throws {
        guard !theme.name.isEmpty else {
            throw PaletteError.invalidTheme("Theme name cannot be empty")
        }
        
        guard !theme.colorNames.isEmpty else {
            throw PaletteError.invalidTheme("Theme '\(theme.name)' must contain at least one color")
        }
    }
}
