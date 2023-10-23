// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swift SimpleAnalytics",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Swift SimpleAnalytics",
            targets: ["Swift SimpleAnalytics"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Swift SimpleAnalytics"),
        .testTarget(
            name: "Swift SimpleAnalyticsTests",
            dependencies: ["Swift SimpleAnalytics"]),
    ]
)
