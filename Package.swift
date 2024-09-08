// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SunnyFit",
    products: [
        .library(
            name: "SunnyFit",
            targets: ["SunnyFit"]
        ),
    ],
    targets: [
        .target(
            name: "SunnyFit"),
        .testTarget(
            name: "SunnyFitTests",
            dependencies: ["SunnyFit"]
        )
    ]
)
