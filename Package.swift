// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AdMobComponents",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(
            name: "AdMobComponents",
            targets: ["AdMobComponents"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            .upToNextMajor(from: "11.7.0")
        ),
    ],
    targets: [
        .target(
            name: "AdMobComponents",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ]
        ),
        .testTarget(
            name: "AdMobComponentTests",
            dependencies: ["AdMobComponents"]
        ),
    ]
)
