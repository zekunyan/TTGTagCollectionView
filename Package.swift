// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "TTGTagCollectionView",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "TTGTagCollectionView",
            targets: ["TTGTagCollectionView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TTGTagCollectionView",
            path: "Sources",
            publicHeadersPath: ""
        ),
    ]
)
