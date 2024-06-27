// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModuleBFramework",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ModuleBFramework",
            targets: ["ModuleBFramework"]
        ),
        .library(
            name: "ModuleBFrameworkInterface",
            targets: ["ModuleBFrameworkInterface"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ModuleBFramework",
            dependencies: [
                "ModuleBFrameworkInterface"
            ],
            path: "Sources/Framework"
        ),
        .target(
            name: "ModuleBFrameworkInterface",
            dependencies: [],
            path: "Sources/Interface"
        ),
        .target(
            name: "ModuleBFrameworkTesting",
            dependencies: [
                "ModuleBFrameworkInterface"
            ],
            path: "Sources/Testing"
        ),
        .testTarget(
            name: "ModuleBFrameworkTests",
            dependencies: [
                "ModuleBFramework",
                "ModuleBFrameworkTesting"
            ],
            path: "Sources/Tests"
        )
    ]
)
