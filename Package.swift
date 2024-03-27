// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "ObjectMapperAdditions",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
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
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper", .upToNextMinor(from: "4.2.0")),
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "ObjectMapperAdditions",
            dependencies: [
                .product(name: "ObjectMapper", package: "ObjectMapper"),
                .product(name: "RoutableLogger", package: "RoutableLogger"),
            ],
            path: "ObjectMapperAdditions",
            sources: ["Classes/Core"],
            resources: [
                .process("Privacy/ObjectMapperAdditions.Core/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
        .target(
            name: "ObjectMapperAdditionsRealm",
            dependencies: [
                "ObjectMapperAdditions",
                .product(name: "Realm", package: "realm-swift"),
                .product(name: "RealmSwift", package: "realm-swift"),
            ],
            path: "ObjectMapperAdditions",
            sources: ["Classes/Realm"],
            resources: [
                .process("Privacy/ObjectMapperAdditions.Realm/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
