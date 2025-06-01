// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


let package = Package(
    name: "IBKit",
	defaultLocalization: "en",
    platforms: [
        .macOS(.v13), .iOS(.v17)
    ],
    products: [
        .library(
			name: "IBClient",
			targets: ["IBClient"]
		),
    ],
    dependencies: [
		.package(url: "https://github.com/stensoosaar/ibmodels", from: "10.33.0"),
	],
    targets: [
		.target(
			name: "IBClient",
			dependencies: [
				.product(
					name: "TWS",
					package: "ibmodels"
				)
			],
			path: "IBClient/IBClient"
		),
		.testTarget(
			name: "IBClientTests",
			dependencies: ["IBClient"],
			path: "IBClient/IBClientTests"
		)
    ]
)
