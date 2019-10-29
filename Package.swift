// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let realmVersionStr = "3.20.0"
let objectMapperVersionStr = "3.5.1"

let package = Package(
    name: "ObjectMapperAdditions",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9),
        .macOS(.v10_10),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "ObjectMapperAdditions/Core",
            targets: ["ObjectMapperAdditions/Core"]
        ),
        .library(
            name: "ObjectMapperAdditions/Realm",
            targets: ["ObjectMapperAdditions/Realm"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-cocoa.git", .exact(Version(realmVersionStr)!)),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .exact(Version(objectMapperVersionStr)!)),
    ],
    targets: [
        .target(
            name: "ObjectMapperAdditions/Core",
            dependencies: [
                "ObjectMapper"
            ],
            path: "ObjectMapperAdditions/Classes/Core",
            exclude: [
            ]
        ),
        .target(
            name: "ObjectMapperAdditions/Realm",
            dependencies: [
                "ObjectMapperAdditions/Core",
                "RealmSwift",
                "ObjectMapper"
            ],
            path: "ObjectMapperAdditions/Classes/Realm",
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
let version = Version(6, 0, 2)
