// swift-tools-version: 5.10
import PackageDescription

// Swift Package layout:
// - GameCore: pure Swift rules/state
// - GameClient: SwiftUI + SpriteKit rendering/input
// - ShardsApp: executable app entry point
let package = Package(
    name: "ShardsOfEmber",
    platforms: [
        .macOS(.v13),
        .iOS(.v17)
    ],
    products: [
        .library(name: "GameCore", targets: ["GameCore"]),
        .library(name: "GameClient", targets: ["GameClient"]),
        .executable(name: "ShardsApp", targets: ["ShardsApp"])
    ],
    targets: [
        .target(
            name: "GameCore",
            path: "Sources/GameCore"
        ),
        .target(
            name: "GameClient",
            dependencies: ["GameCore"],
            path: "Sources/GameClient",
            resources: [
                .process("Resources")
            ]
        ),
        .executableTarget(
            name: "ShardsApp",
            dependencies: ["GameClient"],
            path: "Sources/ShardsApp"
        ),
        .testTarget(
            name: "GameCoreTests",
            dependencies: ["GameCore"],
            path: "Tests/GameCoreTests"
        )
    ]
)
