//
//  PaletteError.swift
//  Palette
//
//  Created by Michael Tibollo on 2025-09-12.
//

import Foundation

public enum PaletteError: Error, LocalizedError {
    
    case fileNotFound(String)
    case noThemesAvailable
    case invalidHexColor(String)
    case malformedJSON(String)
    case themeNotFound(String)
    case invalidTheme(String)
    case decodingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .noThemesAvailable:
            return "[Palette] No themes were found to be available."
        case .fileNotFound(let fileName):
            return "[Palette] Theme file \(fileName).json not found in bundle."
        case .invalidHexColor(let hex):
            return "[Palette] Invalid hex color format: \(hex)"
        case .malformedJSON(let details):
            return "[Palette] Malformed JSON: \(details)"
        case .themeNotFound(let name):
            return "[Palette] Theme '\(name)' not found in available themes."
        case .invalidTheme(let details):
            return "[Palette] Invalid theme: \(details)"
        case .decodingError(let details):
            return "[Palette] Decoding error: \(details)"
        }
    }
}

