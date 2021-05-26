// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "Apps",
  platforms: [.macOS(.v11)],
  products: [
    .library(name: "Apps", targets: ["Apps"]),
  ],
  targets: [
    .target(
      name: "Apps",
      dependencies: []),
    .testTarget(
      name: "AppsTests",
      dependencies: ["Apps"]),
  ]
)
