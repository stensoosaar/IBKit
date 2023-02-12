// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


let package = Package(
    name: "IBKit",
	defaultLocalization: "en",
	platforms: [
		.macOS(.v12)
	],
    products: [
        .library(
			name: "IBKit",
			targets: ["IBKit"]),
    ],
    dependencies: [
	],
    targets: [
        .target(
			name: "IBKit",
			dependencies: [],
			path: "IBKit/IBKit"),
        .testTarget(
			name: "IBKitTests",
			dependencies: ["IBKit"],
			path: "IBKit/IBKitTests")
    ]
)
