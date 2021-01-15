// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Phrase",
    products: [
        .library(name: "Phrase", targets: ["Phrase"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble",  .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        .target(name: "Phrase", dependencies: []),
        .testTarget(name: "PhraseTests", dependencies: [
            "Phrase",
            "Quick",
            "Nimble"
        ]),
    ]
)
