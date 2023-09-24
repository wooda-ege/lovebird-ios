//
//  Dependencies.swift
//  lovebird-iosManifests
//
//  Created by 황득연 on 2023/09/24.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "1.2.0")
        )
    ],
    platforms: [.iOS]
)
