// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "ObjectMapperAdditions",
    platforms: [
        .iOS(.v11),
        .tvOS(.v9),
        .macOS(.v10_10),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "ObjectMapperAdditions",
            targets: ["ObjectMapperAdditions"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-cocoa.git", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/APUtils/LogsManager.git", .upToNextMajor(from: "9.1.14")),
    ],
    targets: [
        .target(
            name: "ObjectMapperAdditions",
            dependencies: [
                "RealmSwift",
                "ObjectMapper",
                "RoutableLogger",
            ],
            path: "ObjectMapperAdditions/Classes/",
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
