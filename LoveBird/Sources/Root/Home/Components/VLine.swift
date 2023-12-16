//
//  VLine.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/25.
//

import SwiftUI

struct VLine: Shape {
  struct Property {
    let color: Color
    let lineWidth: CGFloat
    let dash: [CGFloat]

    static let timelineDotted: Self = .init(color: Color(asset: LoveBirdAsset.primary), lineWidth: 1, dash: [2])
    static let timeline: Self = .init(color: Color(asset: LoveBirdAsset.primary), lineWidth: 2, dash: [])
  }

  private let property: Property

  init(property: Property) {
    self.property = property
  }

  var body: some View {
    self
      .stroke(style: StrokeStyle(lineWidth: property.lineWidth, dash: property.dash))
      .frame(maxWidth: property.lineWidth, maxHeight: .infinity)
      .foregroundColor(property.color)
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 0, y: rect.height))
    return path
  }
}
