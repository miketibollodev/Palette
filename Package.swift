// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Palette",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "Palette",
            targets: ["Palette"]),
    ],
    targets: [
        .target(
            name: "Palette",
            path: "Sources/Palette",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        ),
        .testTarget(
            name: "PaletteTests",
            dependencies: ["Palette"],
            path: "Tests/PaletteTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
