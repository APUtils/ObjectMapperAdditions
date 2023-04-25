// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "ObjectMapperAdditions",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "ObjectMapperAdditions",
            targets: ["ObjectMapperAdditions"]
        ),
        .library(
            name: "ObjectMapperAdditionsRealm",
            targets: ["ObjectMapperAdditionsRealm"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "ObjectMapperAdditions",
            dependencies: [
                .product(name: "ObjectMapper", package: "ObjectMapper"),
                .product(name: "RoutableLogger", package: "RoutableLogger"),
            ],
            path: "ObjectMapperAdditions/Classes/Core",
            swiftSettings: [
                .define("SPM"),
            ]
        ),
        .target(
            name: "ObjectMapperAdditionsRealm",
            dependencies: [
                "ObjectMapperAdditions",
                .product(name: "Realm", package: "realm-cocoa"),
                .product(name: "RealmSwift", package: "realm-cocoa"),
            ],
            path: "ObjectMapperAdditions/Classes/Realm",
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
