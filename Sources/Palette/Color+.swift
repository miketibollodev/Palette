//
//  Color+.swift
//  Palette
//
//  Created by Michael Tibollo on 2025-09-12.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
internal extension Color {
    
    /// Creates a Color from a hex string
    /// - Parameter hex: A hex string in format #RRGGBB or #RRGGBBAA
    /// - Returns: A Color if the hex string is valid, nil otherwise
    init?(hex: String) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // Handle # prefix
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        // Validate hex string contains only valid characters
        guard hex.allSatisfy({ $0.isHexDigit }) else { return nil }
        
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else { return nil }
        
        let r, g, b, a: UInt64
        switch hex.count {
        case 6:
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
    
    /// Creates a Color from a hex string with error handling
    /// - Parameter hex: A hex string in format #RRGGBB or #RRGGBBAA
    /// - Throws: PaletteError.invalidHexColor if the hex string is invalid
    /// - Returns: A Color from the hex string
    static func from(hex: String) throws -> Color {
        guard let color = Color(hex: hex) else {
            throw PaletteError.invalidHexColor(hex)
        }
        return color
    }
}

private extension Character {
    var isHexDigit: Bool {
        return ("0"..."9").contains(self) || 
               ("a"..."f").contains(self) || 
               ("A"..."F").contains(self)
    }
}
