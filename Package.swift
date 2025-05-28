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
		.library(
			name: "IBStore",
			targets: ["IBStore"]
		),
    ],
    dependencies: [
		.package(url: "https://github.com/stensoosaar/ibmodels", from: "10.33.0"),
		.package(url: "https://github.com/duckdb/duckdb-swift", .upToNextMajor(from: "1.1.3")),
		.package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-collections.git", .upToNextMinor(from: "1.0.0")),
	],
    targets: [
		.target(
			name: "IBClient",
			dependencies: [
				.product(
					name: "TWS",
					package: "ibmodels"
				),
				.product(
					name: "Collections",
					package: "swift-collections"
				)
			],
			path: "IBClient/IBClient"
		),
		.testTarget(
			name: "IBClientTests",
			dependencies: ["IBClient"],
			path: "IBClient/IBClientTests"
		),
		.target(
			name: "IBStore",
			dependencies: [
				"IBClient",
				.product(
					name: "DuckDB",
					package: "duckdb-swift"
				),
			],
			path: "IBStore/IBStore",
			resources: [
				.copy("Resources/StoreSchema.sql")
			]
		),
    ]
)
