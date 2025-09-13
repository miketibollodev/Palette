import Testing
import SwiftUI
@testable import Palette

// MARK: - Color Extension Tests

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testColorHexInitialization() async throws {
    // Test valid hex colors
    let validHexColors = [
        "#FF0000", // Red
        "#00FF00", // Green
        "#0000FF", // Blue
        "#FFFFFF", // White
        "#000000", // Black
        "FF0000",  // Without #
        "#FF0000FF", // With alpha
        "FF0000FF"   // With alpha, no #
    ]
    
    for hex in validHexColors {
        let color = Color(hex: hex)
        #expect(color != nil, "Color should be created from valid hex: \(hex)")
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testColorHexInitializationInvalid() async throws {
    // Test invalid hex colors
    let invalidHexColors = [
        "GGGGGG", // Invalid characters
        "12345",  // Too short
        "1234567", // Wrong length
        "",       // Empty
        "ZZZZZZ"  // Invalid characters
    ]
    
    for hex in invalidHexColors {
        let color = Color(hex: hex)
        #expect(color == nil, "Color should be nil for invalid hex: \(hex)")
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testColorFromHexThrows() async throws {
    // Test that Color.from(hex:) throws for invalid colors
    do {
        _ = try Color.from(hex: "INVALID")
        #expect(Bool(false), "Should have thrown an error")
    } catch PaletteError.invalidHexColor {
        // Expected error
    } catch {
        #expect(Bool(false), "Should have thrown PaletteError.invalidHexColor")
    }
}

// MARK: - Theme Tests

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testThemeInitialization() async throws {
    let colors = [
        "primary": Color.red,
        "secondary": Color.blue,
        "background": Color.white
    ]
    
    let theme = Theme(name: "TestTheme", colors: colors)
    #expect(theme.name == "TestTheme")
    #expect(theme.colorNames.count == 3)
    #expect(theme.hasColor(named: "primary"))
    #expect(theme.hasColor(named: "nonexistent") == false)
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testThemeColorAccess() async throws {
    let colors = [
        "primary": Color.red,
        "secondary": Color.blue
    ]
    
    let theme = Theme(name: "TestTheme", colors: colors)
    
    // Test dynamic member lookup
    #expect(theme.primary == Color.red)
    #expect(theme.secondary == Color.blue)
    #expect(theme.nonexistent == nil)
    
    // Test color method with fallback
    #expect(theme.color(named: "primary") == Color.red)
    #expect(theme.color(named: "nonexistent", fallback: .green) == Color.green)
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testThemeEquality() async throws {
    let colors1 = ["primary": Color.red]
    let colors2 = ["primary": Color.red]
    let colors3 = ["primary": Color.blue]
    
    let theme1 = Theme(name: "Theme1", colors: colors1)
    let theme2 = Theme(name: "Theme1", colors: colors2)
    let theme3 = Theme(name: "Theme2", colors: colors1)
    let theme4 = Theme(name: "Theme1", colors: colors3)
    
    #expect(theme1 == theme2)
    #expect(theme1 != theme3)
    #expect(theme1 != theme4)
}

// MARK: - PaletteError Tests

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testPaletteErrorDescriptions() async throws {
    let errors: [PaletteError] = [
        .fileNotFound("test"),
        .noThemesAvailable,
        .invalidHexColor("#INVALID"),
        .malformedJSON("test"),
        .themeNotFound("test"),
        .invalidTheme("test"),
        .decodingError("test")
    ]
    
    for error in errors {
        let description = error.errorDescription
        #expect(description != nil)
        #expect(description!.contains("[Palette]"))
    }
}

// MARK: - Mock Data for Testing

private struct MockThemeData {
    static let validJSON = """
    [
        {
            "name": "Light",
            "colors": {
                "primary": "#FF0000",
                "secondary": "#00FF00",
                "background": "#FFFFFF"
            }
        },
        {
            "name": "Dark",
            "colors": {
                "primary": "#FF0000",
                "secondary": "#00FF00",
                "background": "#000000"
            }
        }
    ]
    """.data(using: .utf8)!
    
    static let invalidJSON = """
    [
        {
            "name": "Invalid",
            "colors": {
                "primary": "INVALID_HEX",
                "secondary": "#00FF00"
            }
        }
    ]
    """.data(using: .utf8)!
    
    static let malformedJSON = """
    [
        {
            "name": "Test",
            "colors": {
                "primary": "#FF0000"
            }
        }
    """.data(using: .utf8)!
}

// MARK: - ThemeLoader Tests

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testThemeLoaderFileNotFound() async throws {
    do {
        _ = try ThemeLoader.loadThemes(fileName: "nonexistent", bundle: .main)
        #expect(Bool(false), "Should have thrown fileNotFound error")
    } catch PaletteError.fileNotFound {
        // Expected error
    } catch {
        #expect(Bool(false), "Should have thrown PaletteError.fileNotFound")
    }
}

// MARK: - Integration Tests

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testColorParsingWithVariousFormats() async throws {
    let testCases = [
        ("#FF0000", true),
        ("FF0000", true),
        ("#FF0000FF", true),
        ("FF0000FF", true),
        ("INVALID", false),
        ("", false),
        ("#GGGGGG", false)
    ]
    
    for (hex, shouldSucceed) in testCases {
        let color = Color(hex: hex)
        if shouldSucceed {
            #expect(color != nil, "Should succeed for: \(hex)")
        } else {
            #expect(color == nil, "Should fail for: \(hex)")
        }
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
@Test func testThemeColorNames() async throws {
    let colors = [
        "zebra": Color.red,
        "apple": Color.green,
        "banana": Color.blue
    ]
    
    let theme = Theme(name: "Test", colors: colors)
    let colorNames = theme.colorNames
    
    #expect(colorNames == ["apple", "banana", "zebra"]) // Should be sorted
}
