//
//  SplashView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct SplashView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Image(asset: LoveBirdAsset.imgBird)
    }
    .padding(0)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(
      LinearGradient(
        stops: [
          Gradient.Stop(color: Color(red: 1, green: 0, blue: 0.48), location: 0.00),
          Gradient.Stop(color: Color(red: 1, green: 0.42, blue: 0.45), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1)
      )
    )
    .background(.white)
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
