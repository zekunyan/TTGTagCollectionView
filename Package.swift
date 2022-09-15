// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "TTGTags",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "TTGTags",
            targets: ["TTGTags"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TTGTags",
            path: "Sources",
            publicHeadersPath: ""
        ),
    ]
)
