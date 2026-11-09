// swift-tools-version: 6.4

import PackageDescription

let package = Package(
  name: "WindowsMacros",
  dependencies: [
    .package(name: "swift-dependencies", path: "../../..")
  ],
  targets: [
    .executableTarget(
      name: "WindowsMacros",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    )
  ]
)
