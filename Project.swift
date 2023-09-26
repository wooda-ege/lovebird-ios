import ProjectDescription

let project = Project(
  name: "LoveBird",
  packages: [
    .remote(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      requirement: .upToNextMajor(from: "0.59.0")
    )
  ],
  targets: [
    Target(
      name: "LoveBird",
      platform: .iOS,
      product: .app,
      bundleId: "com.lovebird.ios",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: "LoveBird/Info.plist",
      sources: ["LoveBird/Sources/**", "LoveBird/Config.swift"],
      resources: ["LoveBird/Resources/**"],
      dependencies: [
        .package(product: "ComposableArchitecture"),
        .sdk(name: "SwiftUI", type: .framework, status: .optional),
        .sdk(name: "WebKit", type: .framework)
      ]
    )
  ]
)
