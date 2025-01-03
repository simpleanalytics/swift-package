// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleAnalytics",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macOS(.v10_15)
    ],
    products: [
        .library(name: "SimpleAnalytics", targets: ["SimpleAnalytics"])
    ],
    targets: [
        .target(name: "SimpleAnalytics", path: "Sources"),
        .testTarget(name: "SimpleAnalyticsTests", dependencies: ["SimpleAnalytics"])
    ]
)
