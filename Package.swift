// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "TTGTags",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "TTGTags",
            targets: ["TTGTags"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TTGTags",
            path: "Sources/TTGTags"
        ),
        .testTarget(
            name: "TTGTagsTests",
            dependencies: ["TTGTags"],
            path: "Tests/TTGTagsTests"
        ),
    ]
)
