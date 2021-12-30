// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ActionHierarchy",
	platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .macCatalyst(.v13), .tvOS(.v13)],
	products: [
		.library(
			name: "ActionHierarchy",
			targets: ["ActionHierarchy"]),
	],
	dependencies: [
	],
	targets: [
		.target(
			name: "ActionHierarchy",
			dependencies: []),
		.testTarget(
			name: "ActionHierarchyTests",
			dependencies: ["ActionHierarchy"]),
	]
)
