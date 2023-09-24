import ProjectDescription

let project = Project(
    name: "LoveBird",
    organizationName: "Prography",
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
                .external(name: "ComposableArchitecture")
            ]
        )
    ]
)
