// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ActionHierarchy",
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
