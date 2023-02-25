// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "OYPermission",
    products: [
        .library(name: "OYPermission", targets: ["OYPermission"])
    ],
    targets: [
        .target(name: "OYPermission", path: "Sources")
    ]
)
