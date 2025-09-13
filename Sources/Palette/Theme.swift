//
//  Theme.swift
//  Theme
//
//  Created by Michael Tibollo on 2025-09-12.
//

import Foundation
import SwiftUI

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@dynamicMemberLookup
public struct Theme: Decodable, Equatable {
    
    public let name: String
    
    private let colors: [String: Color]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case colors
    }
    
    /// Initializes a `Theme` with a name and an array of named colors.
    /// - Parameters:
    ///   - name: The name of the theme
    ///   - colors: A dictionary of color names to Color values
    public init(name: String, colors: [String: Color]) {
        self.name = name
        self.colors = colors
    }
    
    /// Initializes a `Theme` from a JSON format
    /// - Parameter decoder: The decoder to read data from
    /// - Throws: PaletteError if the theme data is invalid
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode name
        name = try container.decode(String.self, forKey: .name)
        guard !name.isEmpty else {
            throw PaletteError.invalidTheme("Theme name cannot be empty")
        }
        
        // Decode colors with proper error handling
        let rawColors = try container.decode([String: String].self, forKey: .colors)
        var parsedColors: [String: Color] = [:]
        var invalidColors: [String] = []
        
        for (key, hexValue) in rawColors {
            do {
                let color = try Color.from(hex: hexValue)
                parsedColors[key] = color
            } catch {
                invalidColors.append("\(key): \(hexValue)")
            }
        }
        
        // If any colors failed to parse, throw an error with details
        if !invalidColors.isEmpty {
            throw PaletteError.invalidTheme("Invalid hex colors: \(invalidColors.joined(separator: ", "))")
        }
        
        guard !parsedColors.isEmpty else {
            throw PaletteError.invalidTheme("Theme must contain at least one color")
        }
        
        colors = parsedColors
    }
    
    /// Access colors using string keys
    /// - Parameter member: The color name to access
    /// - Returns: The Color if found, nil otherwise
    public subscript(dynamicMember member: String) -> Color? {
        return colors[member]
    }
    
    /// Get all available color names in this theme
    /// - Returns: An array of color names
    public var colorNames: [String] {
        return Array(colors.keys).sorted()
    }
    
    /// Check if a color exists in this theme
    /// - Parameter name: The color name to check
    /// - Returns: True if the color exists, false otherwise
    public func hasColor(named name: String) -> Bool {
        return colors[name] != nil
    }
    
    /// Get a color by name with a fallback
    /// - Parameters:
    ///   - name: The color name to get
    ///   - fallback: The fallback color if the named color doesn't exist
    /// - Returns: The requested color or the fallback
    public func color(named name: String, fallback: Color = .clear) -> Color {
        return colors[name] ?? fallback
    }
}
