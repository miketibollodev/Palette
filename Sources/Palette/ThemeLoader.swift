//
//  ThemeLoader.swift
//  Palette
//
//  Created by Michael Tibollo on 2025-09-12.
//

import Foundation

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
internal enum ThemeLoader {
    
    /// Load themes from a local JSON file in the bundle
    /// - Parameters:
    ///   - fileName: The name of the JSON file (without extension)
    ///   - bundle: The bundle to load the file from
    /// - Returns: An array of themes loaded from the JSON file
    /// - Throws: PaletteError if the file cannot be loaded or parsed
    static func loadThemes(fileName: String, bundle: Bundle = .main) throws -> [Theme] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw PaletteError.fileNotFound(fileName)
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw PaletteError.fileNotFound("\(fileName).json - \(error.localizedDescription)")
        }
        
        do {
            return try JSONDecoder().decode([Theme].self, from: data)
        } catch let decodingError as DecodingError {
            let errorMessage = formatDecodingError(decodingError)
            throw PaletteError.decodingError(errorMessage)
        } catch {
            throw PaletteError.malformedJSON(error.localizedDescription)
        }
    }
    
    /// Format a DecodingError into a readable string
    /// - Parameter error: The DecodingError to format
    /// - Returns: A formatted error message
    private static func formatDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let context):
            return "Type mismatch for type \(type) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .valueNotFound(let type, let context):
            return "Value not found for type \(type) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .keyNotFound(let key, let context):
            return "Key '\(key.stringValue)' not found at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .dataCorrupted(let context):
            return "Data corrupted at path: \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) - \(context.debugDescription)"
        @unknown default:
            return "Unknown decoding error: \(error.localizedDescription)"
        }
    }
}
