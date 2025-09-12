// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Palette",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Palette",
            targets: ["Palette"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Palette"),
        .testTarget(
            name: "PaletteTests",
            dependencies: ["Palette"]
        ),
    ]
)
