// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IAP",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "IAP",
            targets: ["IAP"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../../../../packages/NablaUtils"),
        
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "6.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "IAP",
            dependencies: [
                .product(name: "NablaUtils", package: "NablaUtils"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
            ]
        ),
        .testTarget(
            name: "IAPTests",
            dependencies: ["IAP"]
        ),
    ]
)